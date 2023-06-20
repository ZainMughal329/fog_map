import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  late GoogleMapController mapController;
  late StreamSubscription locationSubscription;

  final markerList = <Marker>[].obs;

  double speed = 0.0;
}
