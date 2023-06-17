// import 'dart:async';
// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fog_map/reuseable/session_manager.dart';
// import 'package:fog_map/reuseable/utils.dart';
// import 'package:fog_map/sigin/index.dart';
// import 'package:fog_map/sigin/sign_up_view.dart';
// import 'package:fog_map/views/mapView/index.dart';
//
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// // API KEY : AIzaSyDybIfmudV9fS8lKkTxp3t_S4z6rrBZBXg
//
// class MapController extends GetxController {
//
//   // late DatabaseReference _locationRef;
//   final Map<String, Marker> _markers = {};
//   Location location = Location();
//   var _currentLocation = LatLng(0.0, 0.0).obs;
//   final _locationRef = FirebaseDatabase.instance.ref().child('locations');
//   // final _ref = FirebaseDatabase.instance.ref();
//
//   LatLng get currentLocation => _currentLocation.value;
//   LocationData? locationData;
//
//   final state = MapState();
//
//   @override
//   void onInit() {
//     super.onInit();
//     initLocation();
//
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       _currentLocation.value = LatLng(currentLocation.latitude!.toDouble(),
//           currentLocation.longitude!.toDouble());
//
//       _locationRef.child(SessionController().userId.toString()).set({
//         'uid': SessionController().userId,
//         'lat': _currentLocation.value.latitude,
//         'long': _currentLocation.value.longitude,
//         'speed': state.speed,
//       }).onError((error, stackTrace) {
//         Get.snackbar("error", error.toString());
//         if (kDebugMode) {
//           print(error.toString());
//           Get.snackbar("error", error.toString());
//         }
//       });
//     });
//
//     state.locationSubscription = _locationRef.onValue.listen((event) {
//       final data = event.snapshot.value as Map<dynamic, dynamic>?;
//       if (data == null) {
//         return;
//       }
//       data.forEach((userId, location) {
//         final lat = location['lat'] as double?;
//         final lng = location['lng'] as double?;
//         if (lat != null && lng != null) {
//           final marker = Marker(
//             markerId: MarkerId(userId),
//             position: LatLng(lat, lng),
//             infoWindow: InfoWindow(title: userId),
//           );
//           state.markerList.add(marker);
//         }
//       });
//       update();
//     });
//   }
//
//   void initLocation() async {
//     Location location = Location();
//
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         // Handle if location service is not enabled
//         return;
//       }
//     }
//
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         // Handle if location permission is not granted
//         return;
//       }
//     }
//
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       locationData = currentLocation;
//       state.speed = currentLocation.speed! * 3.6;
//       update(); // Trigger widget update
//     });
//   }
//
//   addmarker(var length, dynamic uid, double lat, double long) async {
//     // markerList.clear();
//     final mar = Marker(
//         markerId: MarkerId(uid),
//         position: LatLng(lat, long),
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: InfoWindow(title: "Current Location"));
//
//     state.markerList.add(mar);
//   }
//
//   @override
//   void onClose() {
//     state.locationSubscription.cancel();
//     super.onClose();
//   }
//
//   void setMapController(GoogleMapController controller) {
//     state.mapController = controller;
//   }
//
//   Set<Marker> get markers => Set<Marker>.of(_markers.values);
//
//   void animateTo(LatLng latLng) {
//     state.mapController.animateCamera(CameraUpdate.newLatLng(latLng));
//   }
// }