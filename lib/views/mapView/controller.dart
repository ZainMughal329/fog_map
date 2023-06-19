import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/reuseable/utils.dart';
import 'package:fog_map/sigin/index.dart';
import 'package:fog_map/sigin/sign_up_view.dart';

// import 'package:geolocator/geolocator.dart' as gl;
// import 'package:geolocator/geolocator.dart' as geolocator;

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// import 'model.dart';
// API KEY : AIzaSyDybIfmudV9fS8lKkTxp3t_S4z6rrBZBXg

class MapController extends GetxController {
  late GoogleMapController mapController;
  late StreamSubscription locationSubscription;

  // late DatabaseReference _locationRef;
  final Map<String, Marker> _markers = {};
  final markerList = <Marker>[].obs;

  // RxList markersInRange = [].obs;
  // LocationData location = LocationData();
  // final location = getLocation();

  Location location = Location();

  RxList visibleMarkers = [].obs;

  // Location
  var _currentLocation = LatLng(0.0, 0.0).obs;
  final _locationRef = FirebaseDatabase.instance.ref().child('locations');
  final _ref = FirebaseDatabase.instance.ref();

  LatLng get currentLocation => _currentLocation.value;
  LocationData? locationData;
  double speed = 0.0;
  // RxList<double> distances = <double>[].obs;
  final List<double> distances = [];

  // final Set<Marker> markers = Set<Marker>().obs;
  // final List<MarkerDistance> markerDistances = <MarkerDistance>[].obs;
  @override
  void onInit() {
    super.onInit();
    initLocation();
    calculateDistances();
    // addInDistanceList();
    // calculateAndShowDistance();
    // calculateDistance();
    // print('length is : ' + markersInRange.length.toString());
    // location.

    location.onLocationChanged.listen((LocationData currentLocation) {
      _currentLocation.value = LatLng(currentLocation.latitude!.toDouble(),
          currentLocation.longitude!.toDouble());

      _locationRef.child(SessionController().userId.toString()).set({
        'uid': SessionController().userId,
        'lat': _currentLocation.value.latitude,
        'long': _currentLocation.value.longitude,
        'speed': speed,
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

  // void calculateAndShowDistances() {
  //   // Calculate distances to each marker from current location
  //   markerList.forEach((marker) {
  //     double marker_distance = getDistance(
  //       marker.position.latitude,
  //       marker.position.longitude,
  //       currentLocation.latitude,
  //       currentLocation.longitude,
  //     );
  //     distances.add(marker_distance);
  //   });
  // }
  //
  // double getDistance(
  //     double lat1,
  //     double lon1,
  //     double lat2,
  //     double lon2,
  //     ) {
  //   const double earthRadius = 6371; // in kilometers
  //   double dLat = degreesToRadians(lat2 - lat1);
  //   double dLon = degreesToRadians(lon2 - lon1);
  //
  //   double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
  //       math.cos(degreesToRadians(lat1)) *
  //           math.cos(degreesToRadians(lat2)) *
  //           math.sin(dLon / 2) *
  //           math.sin(dLon / 2);
  //   double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  //   double marker_distance = earthRadius * c;
  //
  //   return marker_distance;
  // }

  // void calculateAndShowDistance() {
  //   List<Marker> showDistance = addInDistanceList();
  //   print('showdistance length is : ' + showDistance.length.toString());
  //   for(var mark in showDistance) {
  //     double dist = calculateDistance(currentLocation, mark.position);
  //     print('Distance to ${mark.markerId.value}: $dist kilometers');
  //
  //   }
  // }
  //
  // List<Marker> addInDistanceList() {
  //   final List<Marker> distances = [];
  //   print('length os distance is : ' +distances.length.toString());
  //   for (var mar in markerList) {
  //     print('inside');
  //     double dis = calculateDistance(currentLocation, mar.position);
  //     distances.add(mar);
  //     print('length of distance is : ' +distances.length.toString());
  //
  //   }
  //   print('length of  distance after loop is : ' +distances.length.toString());
  //   return distances;
  //
  // }
  // Calculate distances between current location and markers

  void calculateDistances() {
    List<Marker> visibleMarkers = getVisibleMarkers();
    print('length is : ' + visibleMarkers.length.toString());
    for (var marker in visibleMarkers) {
      double distance = calculateDistance(currentLocation, marker.position);
      print('Distance to ${marker.markerId.value}: $distance meters');
    }
  }

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

  double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

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

  addmarker(var length, dynamic uid, double lat, double long) async {
    // markerList.clear();
    final mar = Marker(
      markerId: MarkerId(uid),
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: "Current Location"),
    );

    markerList.add(mar);
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
