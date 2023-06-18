import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/sigin/index.dart';
import 'package:fog_map/sigin/sign_up_view.dart';
import 'package:fog_map/views/mapView/map_screen.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController{



  SplashScreenController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();



  }
  // void chekSession(){
  //   if(FirebaseAuth.instance.currentUser != null){
  //     SessionController().userId = FirebaseAuth.instance.currentUser!.uid.toString();
  //     Timer(
  //         Duration(seconds: 3),
  //             ()=> Get.off(()=> GMapScreen())
  //     );
  //   }else{
  //
  //     Timer(
  //         Duration(seconds: 3),
  //             ()=> Get.off(()=> SignInPage())
  //     );
  //   }
  // }


}