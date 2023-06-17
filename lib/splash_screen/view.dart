import 'package:flutter/material.dart';
import 'package:fog_map/splash_screen/controller.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashScreenController> {
   SplashScreen({Key? key}) : super(key: key);

  final controller = Get.put(SplashScreenController());


  @override
  Widget build(BuildContext context) {
    controller.chekSession();
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            "Splash Screen View"
          ),
        ),
      ),
    );
  }
}
