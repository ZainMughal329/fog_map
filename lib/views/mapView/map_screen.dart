import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/reuseable/utils.dart';
import 'package:fog_map/sigin/index.dart';
import 'package:fog_map/sigin/sign_up_view.dart';


import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// API KEY : AIzaSyDybIfmudV9fS8lKkTxp3t_S4z6rrBZBXg

class MapController extends GetxController {
  late GoogleMapController _mapController;
  late StreamSubscription _locationSubscription;
  // late DatabaseReference _locationRef;
  final Map<String, Marker> _markers = {};
  final markerList = <Marker>[].obs;
  Location location = Location();
  var _currentLocation = LatLng(0.0, 0.0).obs;
  final _locationRef = FirebaseDatabase.instance.ref().child('locations');
  final _ref = FirebaseDatabase.instance.ref();
  LatLng get currentLocation => _currentLocation.value;

  @override
  void onInit() {
    super.onInit();

    location.onLocationChanged.listen((LocationData currentLocation) {
      _currentLocation.value = LatLng(currentLocation.latitude!.toDouble(),
          currentLocation.longitude!.toDouble());

      _locationRef.child(SessionController().userId.toString()).set({
        'uid': SessionController().userId,
        'lat': _currentLocation.value.latitude,
        'long': _currentLocation.value.longitude,
      }).onError((error, stackTrace) {
        Get.snackbar("error", error.toString());
        if (kDebugMode) {
          print(error.toString());
          Get.snackbar("error", error.toString());
        }
      });
    });

    _locationSubscription = _locationRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return;
      }
      data.forEach((userId, location) {
        final lat = location['lat'] as double?;
        final lng = location['lng'] as double?;
        if (lat != null && lng != null) {
          final marker = Marker(
            markerId: MarkerId(userId),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: userId),
          );
          markerList.add(marker);
        }
      });
      update();
    });
  }

  addmarker(var length,dynamic uid, double lat, double long) async {
    // markerList.clear();
    final mar = Marker(
        markerId: MarkerId(uid),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Current Location"));


    markerList.add(mar);

  }

  @override
  void onClose() {
    _locationSubscription.cancel();
    super.onClose();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Set<Marker> get markers => Set<Marker>.of(_markers.values);

  void animateTo(LatLng latLng) {
    _mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}

class GMapScreen extends StatelessWidget {
  final _controller = Get.put(MapController());
  final ref = FirebaseDatabase.instance.ref().child('locations');
  var length;
  Map<dynamic, dynamic>? values;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent app from exiting when back button is pressed
        // Show an exit confirmation dialog to the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        );

        // Return false to prevent default system back button behavior
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Map Screen"),
          actions: [
            InkWell(
              onTap: ()async{
                await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmation'),
                  content: Text('Are you sure you want to LogOut?'),
                  actions: [
                    TextButton(
                      child: Text('No'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('Yes'),

                      onPressed: () async{
                        await FirebaseAuth.instance.signOut().then((value){
                          _controller._locationSubscription.cancel();
                          Navigator.pop(context);
                          Utils.showToast("Logout Successfully");
                          // SessionController().userId = "";
                          Get.off(()=> SignInPage());
                        }).onError((error, stackTrace){
                          Utils.showToast(error.toString());
                        });


                      }
                    ),
                  ],
                ),
                );
              },
                child: Icon(Icons.more_vert_rounded)),
          ],
        ),

          body: Obx(() {
        if (_controller.currentLocation.latitude == 0.0 &&
            _controller.currentLocation.longitude == 0.0) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return StreamBuilder(

              stream: ref.onValue,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {

                  return Center(child: const CircularProgressIndicator());
                } else {

                  Map<dynamic, dynamic> map = snapshot.data.snapshot.value;


                  ref.once().then(

                        (DatabaseEvent snapshot) {


                      if(snapshot.snapshot!=null){

                        Map<dynamic, dynamic> values =
                        snapshot.snapshot.value as Map<dynamic, dynamic>;
                        length = values.length;


                        String jsonString = jsonEncode(values);
                        Map<String, dynamic> data = jsonDecode(jsonString);


                        List<dynamic> listKeys = data.keys.toList();
                        print(listKeys.toString());

                        try{
                          for (dynamic node in listKeys) {
                            Map<dynamic, dynamic> childNodes = Map<String, dynamic>.from(data[node]);
                            print("how many times this block is executing" + childNodes.toString());

                            _controller.addmarker(childNodes.length,childNodes['uid'], childNodes['lat'], childNodes['long']);



                          }
                        }catch (e){
                          Utils.showToast(e.toString());
                        }

                      }else{
                        CircularProgressIndicator();

                      }
                    },
                  ).onError((error, stackTrace){


                    Utils.showToast(error.toString());
                  });


                  return GoogleMap(
                    mapType: MapType.normal,
                    zoomControlsEnabled: true,
                    initialCameraPosition: CameraPosition(
                        tilt: 45, target: _controller.currentLocation, zoom: 21),
                    onMapCreated: (GoogleMapController controller) {
                      _controller._mapController = controller;
                    },
                    markers: Set<Marker>.from(_controller.markerList),
                  );
                }
              });
        }
      })),
    );
  }
}