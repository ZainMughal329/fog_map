import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fog_map/reuseable/storage_pref.dart';
import 'package:fog_map/sigin/index.dart';
import 'package:fog_map/splash_screen/controller.dart';
import 'package:fog_map/welcom_screens/index.dart';
import 'package:get/get.dart';

import '../reuseable/session_manager.dart';
import '../views/mapView/home_page.dart';
import '../views/mapView/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class SplashScreen extends GetView<SplashScreenController> {
  SplashScreen({Key? key}) : super(key: key);

  onInit() {
    StorePrefrences sp = StorePrefrences();
    FirebaseAuth auth = FirebaseAuth.instance;
    final userRef = FirebaseDatabase.instance.ref().child('users');




    Future.delayed(Duration(seconds: 3), () async {




      bool? val = await sp.getIsFirstOpen();
      if (val == true) {
        if (FirebaseAuth.instance.currentUser != null) {

          SessionController().userId =
              FirebaseAuth.instance.currentUser!.uid.toString();



          Get.off(() => HomeScreen());
        } else {
          Get.off(() => SignInPage());
        }
      } else {
        Get.to(() => WelcomePage());
      }
    });
  }

  final controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    // controller.chekSession();
    onInit();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Splash Screen View"),
        ),
      ),
    );
  }
}
