import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/reuseable/utils.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
class DistanceController extends GetxController{

  final ref=FirebaseDatabase.instance.ref("locations");
  var userLat;
  var userLong;

  void getUserDetails()async{
    await ref.child(SessionController().userId.toString()).get().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> childNodedata = snapshot.value as Map<dynamic,dynamic>;
      userLat = childNodedata['lat'];
      userLong = childNodedata['long'];
      if(kDebugMode){
        print("UserLong"+userLong.toString());
        print("UserLat"+ userLat.toString());
      }
    }).onError((error, stackTrace){
      Utils.showToast(error.toString());
    });
  }



double calDistance(lat,long){
    getUserDetails();
  return calculateDistance(lat, long, userLat, userLong)/1000;
}

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in meters

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return double.parse(distance.toStringAsFixed(2));
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }


}