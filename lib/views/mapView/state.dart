import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapState {
  late GoogleMapController mapController;
  late StreamSubscription locationSubscription;

  final markerList = <Marker>[].obs;

  double speed = 0.0;
}