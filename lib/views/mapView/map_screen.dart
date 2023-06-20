import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/reuseable/utils.dart';
import 'package:fog_map/sigin/index.dart';

// import 'package:geolocator/geolocator.dart' as gl;
// import 'package:geolocator/geolocator.dart' as geolocator;

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'controller.dart';
// API KEY : AIzaSyDybIfmudV9fS8lKkTxp3t_S4z6rrBZBXg

// class MapController extends GetxController {
//   late GoogleMapController _mapController;
//   late StreamSubscription _locationSubscription;
//
//   // late DatabaseReference _locationRef;
//   final Map<String, Marker> _markers = {};
//   final markerList = <Marker>[].obs;
//
//   // RxList markersInRange = [].obs;
//   // LocationData location = LocationData();
//   // final location = getLocation();
//
//   Location location = Location();
//
//   RxList visibleMarkers = [].obs;
//
//   // Location
//   var _currentLocation = LatLng(0.0, 0.0).obs;
//   final _locationRef = FirebaseDatabase.instance.ref().child('locations');
//   final _ref = FirebaseDatabase.instance.ref();
//
//   LatLng get currentLocation => _currentLocation.value;
//   LocationData? locationData;
//   double speed = 0.0;
//
//   @override
//   void onInit() {
//     super.onInit();
//     initLocation();
//     calculateDistances();
//     // calculateDistance();
//     // print('length is : ' + markersInRange.length.toString());
//     // location.
//
//     location.onLocationChanged.listen((LocationData currentLocation) {
//       _currentLocation.value = LatLng(currentLocation.latitude!.toDouble(),
//           currentLocation.longitude!.toDouble());
//
//       _locationRef.child(SessionController().userId.toString()).set({
//         'uid': SessionController().userId,
//         'lat': _currentLocation.value.latitude,
//         'long': _currentLocation.value.longitude,
//         'speed': speed,
//       }).onError((error, stackTrace) {
//         Get.snackbar("error", error.toString());
//         if (kDebugMode) {
//           print(error.toString());
//           Get.snackbar("error", error.toString());
//         }
//       });
//     });
//
//     _locationSubscription = _locationRef.onValue.listen((event) {
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
//           markerList.add(marker);
//         }
//       });
//       update();
//     });
//   }
//
//   void calculateDistances() {
//     List<Marker> visibleMarkers = getVisibleMarkers();
//     print('length is : ' + visibleMarkers.length.toString());
//     for (var marker in visibleMarkers) {
//       double distance = calculateDistance(currentLocation, marker.position);
//       print('Distance to ${marker.markerId.value}: $distance meters');
//     }
//   }
//
//   List<Marker> getVisibleMarkers() {
//     const double maxDistance = 100; // Maximum distance in meters
//     List<Marker> visibleMarkers = [];
//
//     for (var marker in markerList) {
//       double distance = calculateDistance(currentLocation, marker.position);
//       if (distance <= maxDistance) {
//         visibleMarkers.add(marker);
//       }
//     }
//     // print('visibleMarkers length : ' + visibleMarkers.length.toString());
//     return visibleMarkers;
//   }
//
//   double calculateDistance(LatLng start, LatLng end) {
//     const int earthRadius = 6371000; // in meters
//     double lat1 = degreesToRadians(start.latitude);
//     double lon1 = degreesToRadians(start.longitude);
//     double lat2 = degreesToRadians(end.latitude);
//     double lon2 = degreesToRadians(end.longitude);
//
//     double dLon = lon2 - lon1;
//     double dLat = lat2 - lat1;
//
//     double a = math.pow(math.sin(dLat / 2), 2) +
//         math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//     double distance = earthRadius * c;
//
//     return distance;
//   }
//
//   double degreesToRadians(double degrees) {
//     return degrees * (math.pi / 180);
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
//       speed = currentLocation.speed! * 3.6;
//       update(); // Trigger widget update
//     });
//   }
//
//   addmarker(var length, dynamic uid, double lat, double long) async {
//     // markerList.clear();
//     final mar = Marker(
//       markerId: MarkerId(uid),
//       position: LatLng(lat, long),
//       icon: BitmapDescriptor.defaultMarker,
//       infoWindow: InfoWindow(title: "Current Location"),
//     );
//
//     markerList.add(mar);
//   }
//
//   // calculateDistance() async {
//   //   print('inside');
//   //   try{
//   //     print('inside try');
//   //     geolocator.Position currentPosition =
//   //         await geolocator.Geolocator.getCurrentPosition(
//   //       desiredAccuracy: geolocator.LocationAccuracy.high,
//   //     );
//   //     double currentLat = currentPosition.latitude;
//   //     double currentLng = currentPosition.longitude;
//   //
//   //     markersInRange.add(
//   //       Marker(markerId: MarkerId('current lang'), position: currentLocation),
//   //     );
//   //     for (var marker in markerList) {
//   //       double markerLat = marker.position.latitude;
//   //       double markerLng = marker.position.longitude;
//   //
//   //       double distanceInMeters = await geolocator.Geolocator.distanceBetween(
//   //         currentLat,
//   //         currentLng,
//   //         markerLat,
//   //         markerLng,
//   //       );
//   //
//   //       print('distanceInMeters : ' + distanceInMeters.toString());
//   //
//   //       if (distanceInMeters <= 1000) {
//   //         markersInRange.add(marker);
//   //       }
//   //     }
//   //   }catch(e) {
//   //     print('Exception is : ' + e.toString());
//   //   }
//   // }
//
//   @override
//   void onClose() {
//     _locationSubscription.cancel();
//     super.onClose();
//   }
//
//   void setMapController(GoogleMapController controller) {
//     _mapController = controller;
//   }
//
//   Set<Marker> get markers => Set<Marker>.of(_markers.values);
//
//   void animateTo(LatLng latLng) {
//     _mapController.animateCamera(CameraUpdate.newLatLng(latLng));
//   }
// }

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
                onTap: () async {
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
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .signOut()
                                  .then((value) {
                                final ref = FirebaseDatabase.instance
                                    .ref()
                                    .child('locations');
                                ref
                                    .child(
                                        SessionController().userId.toString())
                                    .remove()
                                    .then((value) {
                                  _controller.locationSubscription.cancel();
                                  Utils.showToast('Remove success');
                                }).onError((error, stackTrace) {
                                  Utils.showToast(
                                      'Error occured : ${error.toString()}');
                                });
                                Navigator.pop(context);
                                Utils.showToast("Logout Successfully");
                                // SessionController().userId = "";
                                Get.off(() => SignInPage());
                              }).onError((error, stackTrace) {
                                Utils.showToast(error.toString());
                              });
                            }),
                      ],
                    ),
                  );
                },
                child: Icon(Icons.more_vert_rounded)),
            // InkWell(
            //   onTap: () {
            //     // Get.to(() => ShowDistanceScreen());
            //   },
            //   child: Text('Distance Screen')  ,
            // ),
          ],
        ),
        body: Obx(
          () {
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
                        if (snapshot.snapshot != null) {
                          Map<dynamic, dynamic> values =
                              snapshot.snapshot.value as Map<dynamic, dynamic>;
                          length = values.length;

                          String jsonString = jsonEncode(values);
                          Map<String, dynamic> data = jsonDecode(jsonString);

                          List<dynamic> listKeys = data.keys.toList();
                          print(listKeys.toString());

                          try {
                            for (dynamic node in listKeys) {
                              Map<dynamic, dynamic> childNodes =
                                  Map<String, dynamic>.from(data[node]);
                              print("how many times this block is executing" +
                                  childNodes.toString());

                              _controller.addMarker(
                                  childNodes.length,
                                  childNodes['uid'],
                                  childNodes['lat'],
                                  childNodes['long']);
                            }
                          } catch (e) {
                            Utils.showToast(e.toString());
                          }
                        } else {
                          CircularProgressIndicator();
                        }
                      },
                    ).onError((error, stackTrace) {
                      Utils.showToast(error.toString());
                    });

                    return Stack(
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          zoomControlsEnabled: true,
                          initialCameraPosition: CameraPosition(
                              tilt: 45,
                              target: _controller.currentLocation,
                              zoom: 21),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.mapController = controller;
                          },
                          markers:
                              Set<Marker>.from(_controller.getVisibleMarkers()),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: GetBuilder<MapController>(
                            builder: (controller) => Container(
                              height: 110,
                              width: 110,
                              child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 200,
                                    labelOffset: 10,
                                    axisLineStyle: AxisLineStyle(
                                        thicknessUnit: GaugeSizeUnit.factor,
                                        thickness: 0.03),
                                    majorTickStyle: MajorTickStyle(
                                        length: 2,
                                        thickness: 0.5,
                                        color: Colors.black),
                                    minorTickStyle: MinorTickStyle(
                                        length: 2,
                                        thickness: 0.5,
                                        color: Colors.black),
                                    axisLabelStyle: GaugeTextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                        startValue: 0,
                                        endValue: 200,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        startWidth: 0.03,
                                        endWidth: 0.03,
                                        gradient: SweepGradient(
                                          colors: const <Color>[
                                            Colors.green,
                                            Colors.yellow,
                                            Colors.red
                                          ],
                                          stops: const <double>[0.0, 0.5, 1],
                                        ),
                                      ),
                                    ],
                                    pointers: <GaugePointer>[
                                      NeedlePointer(
                                        value: controller.speed,
                                        needleLength: 0.95,
                                        enableAnimation: true,
                                        animationType: AnimationType.ease,
                                        needleStartWidth: 0.20,
                                        needleEndWidth: 2,
                                        needleColor: Colors.red,
                                        knobStyle: KnobStyle(knobRadius: 0.05),
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                          widget: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  controller.speed
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 05),
                                                Text(
                                                  'kmph',
                                                  style: TextStyle(
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          angle: 90,
                                          positionFactor: 0.75),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
