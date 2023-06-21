import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/reuseable/utils.dart';
import 'package:fog_map/views/mapView/index.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GMapController extends GetxController {
  String modelNum = '';
  late GoogleMapController mapController;
  late StreamSubscription locationSubscription;
  String vehicleType = '';
  // final name =  FirebaseAuth.instance.currentUser!.displayName.toString();


  final Map<String, Marker> _markers = {};
  final markerList = <Marker>[].obs;
  Uint8List? markerImage;

  Location location = Location();

  RxList visibleMarkers = [].obs;


  TextEditingController feedbackController = TextEditingController();

  // Location
  var _currentLocation = LatLng(0.0, 0.0).obs;
  final _locationRef = FirebaseDatabase.instance.ref().child('locations');
  final locRef = FirebaseDatabase.instance.ref().child('locations');
  final userRef = FirebaseDatabase.instance.ref().child('users');
  // String name = "null";

  LatLng get currentLocation => _currentLocation.value;
  LocationData? locationData;
  double speed = 0.0;
  String name = SessionController().userName.toString();

  // Adding custom marker
  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void getName()async{

    await userRef.child(SessionController().userId.toString()).get().then((DataSnapshot snapshot){
      // print("inside name funciton");
      var childNodeData = snapshot!.value as Map<dynamic,dynamic> ;
      if(childNodeData!=null){
        if(kDebugMode){

          print(childNodeData.toString());
        }
        var name=childNodeData['userName'];
        print("Name is $name");
        SessionController().userName=name.toString();

      }
    }).onError((error, stackTrace){
      print("Error whilte fetching name of user");
      print(error.toString());
    });
  }

  // Future<void> getName() async{
  //   await userRef.child(SessionController().userId.toString()).get().then((DataSnapshot snapshot){
  //     var childNodeData = snapshot!.value as Map<dynamic, dynamic>;
  //     if(childNodeData!=null){
  //       if(kDebugMode){
  //         print(childNodeData.toString());
  //       }
  //       name=childNodeData['name'].toString();
  //       print("Name is $name");
  //     }
  //   }).onError((error, stackTrace){
  //     print("Error whilte fetching name of user");
  //   });
  // }

  // Called and initialized all the methods when app starts
  @override
  void onInit() {
    super.onInit();
    initLocation();
    calculateDistances();
    getName();

    location.onLocationChanged.listen((LocationData currentLocation) {
      _currentLocation.value = LatLng(currentLocation.latitude!.toDouble(),
          currentLocation.longitude!.toDouble());

      _locationRef.child(SessionController().userId.toString()).set({
        'uid': SessionController().userId.toString(),
        'lat': _currentLocation.value.latitude,
        'long': _currentLocation.value.longitude,
        'speed': speed,
        'type' : vehicleType,
        'model' : modelNum,
        'name' : SessionController().userName.toString(),
        // 'name' : userRef.child(SessionController().userId.toString()).get().,
      }).onError((error, stackTrace) {
        Get.snackbar("error", error.toString());
        if (kDebugMode) {
          print(error.toString());
          Get.snackbar("error", error.toString());
        }
      });
    });

    locationSubscription = _locationRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return;
      }
      data.forEach((userId, location) {
        final lat = location['lat'] as double?;
        final lng = location['lng'] as double?;

        final speed = location['speed'] as double?;
        if (lat != null && lng != null) {
          final marker = Marker(
            markerId: MarkerId(userId),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: speed!.toStringAsFixed(2).toString(),),
          );
          markerList.add(marker);
        }
      });
      update();
    });
  }

  // Calculating distance between markers on map
  void calculateDistances() {
    List<Marker> visibleMarkers = getVisibleMarkers();
    print('length is : ' + visibleMarkers.length.toString());
    for (var marker in visibleMarkers) {
      double distance = calculateDistance(currentLocation, marker.position);
      print('Distance to ${marker.markerId.value}: $distance meters');
    }
  }

  // Calculating distance and adding only those markers in a list that are
  // within 100 meter range from our current location.
  List<Marker> getVisibleMarkers() {
    const double maxDistance = 100; // Maximum distance in meters
    List<Marker> visibleMarkers = [];

    for (var marker in markerList) {
      double distance = calculateDistance(currentLocation, marker.position);
      if (distance <= maxDistance) {
        visibleMarkers.add(marker);
      }
    }
    // print('visibleMarkers length : ' + visibleMarkers.length.toString());
    return visibleMarkers;
  }

  // method for calculating distance using mathematical equations
  double calculateDistance(LatLng start, LatLng end) {
    const int earthRadius = 6371000; // in meters
    double lat1 = degreesToRadians(start.latitude);
    double lon1 = degreesToRadians(start.longitude);
    double lat2 = degreesToRadians(end.latitude);
    double lon2 = degreesToRadians(end.longitude);

    double dLon = lon2 - lon1;
    double dLat = lat2 - lat1;

    double a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  // Convert the map coordinates(latitude and longitude) that are in degree to radian.
  double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  // Getting the speed of the moving vehicle or object
  void initLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Handle if location service is not enabled
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Handle if location permission is not granted
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      locationData = currentLocation;
      speed = currentLocation.speed! * 3.6;
      update(); // Trigger widget update
    });
  }

  // Adding markers
  addMarker(var length, dynamic uid, double lat, double long) async {
    final Uint8List markerIcon;
    if(vehicleType == 'Car') {

      markerIcon =
      await getBytesFromAssets('assets/images/car.png', 50);
    }else if(vehicleType == 'Bus') {
      markerIcon =
      await getBytesFromAssets('assets/images/bus.png', 50);
    }else if(vehicleType == 'Bike') {
      markerIcon =
      await getBytesFromAssets('assets/images/bycicle.png', 50);
    }else {
      markerIcon =
      await getBytesFromAssets('assets/images/walk.png', 50);
    }
    // markerList.clear();
    final mar = Marker(
      markerId: MarkerId(uid),
      position: LatLng(lat, long),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      infoWindow: InfoWindow(
        title: "Name is : " + name,
      ),
    );

    markerList.add(mar);
  }


  // Dialog box that appear to check weather model number is not empty
  void showFeedbackDialog(BuildContext context) {
    showDialog(

      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Model Number'),
        content: TextFormField(
          controller: feedbackController,
          decoration: InputDecoration(
            hintText: 'Enter Model Number :',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              if (feedbackController.text.isEmpty) {
                Utils.showToast(
                'Feedback Required \nPlease provide feedback before deleting.',
                  // snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                // deleteItem();
                modelNum = feedbackController.text.toString();
                Get.to( () => GMapScreen());

              }
              feedbackController.clear(); // Clear the text field
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    locationSubscription.cancel();
    super.onClose();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> get markers => Set<Marker>.of(_markers.values);

  void animateTo(LatLng latLng) {
    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}
