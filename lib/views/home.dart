import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fog_map/reuseable/round_button.dart';
import 'package:fog_map/sigin/index.dart';
import 'package:fog_map/views/mapView/index.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' as math;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Center(
//             child: RoundButton(title: 'LogOut', onPress: () async{
//              await FirebaseAuth.instance.signOut().then((value){
//                Get.to( () => SignInPage());
//              });
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }


class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    List<Marker> visibleMarkers = getVisibleMarkers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Distance to Markers'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: controller.currentLocation,
          zoom: 14,
        ),
        markers: Set<Marker>.from(visibleMarkers),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calculate),
        onPressed: () {
          calculateDistances();
        },
      ),
    );
  }

  void calculateDistances() {
    List<Marker> visibleMarkers = getVisibleMarkers();
    print('length is : ' + visibleMarkers.length.toString());
    for (var marker in visibleMarkers) {
      double distance = calculateDistance(controller.currentLocation, marker.position);
      print('Distance to ${marker.markerId.value}: $distance meters');
    }
  }

  List<Marker> getVisibleMarkers() {
    const double maxDistance = 100; // Maximum distance in meters
    List<Marker> visibleMarkers = [];

    for (var marker in controller.markerList) {
      double distance = calculateDistance(controller.currentLocation, marker.position);
      if (distance <= maxDistance) {
        visibleMarkers.add(marker);
      }
    }
    print('visibleMarkers length : ' + visibleMarkers.length.toString());
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
}
