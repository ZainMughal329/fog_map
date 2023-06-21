import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fog_map/reuseable/session_manager.dart';
import 'package:fog_map/reuseable/storage_pref.dart';
import 'package:fog_map/sigin/state.dart';
import 'package:fog_map/views/mapView/home_page.dart';
import 'package:fog_map/views/mapView/map_screen.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  var verificationId = "".obs;

  final state = SignInState();


  final auth = FirebaseAuth.instance;

  final _db = FirebaseDatabase.instance.ref().child('users');

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userController = TextEditingController();
  final emailFocus = FocusNode();
  final userFocus = FocusNode();
  final passwordFocus = FocusNode();

  void dispose() {
    super.dispose();
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    userFocus.dispose();
    userController.dispose();
    passwordFocus.dispose();
  }

  SignInController();

  registerUser(String email, password) async {
    state.loading.value = true;
    try {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userId = auth.currentUser!.uid.toString();
        SessionController().userName =  userController.text;

        _db.child(auth.currentUser!.uid.toString()).set({
          'id': auth.currentUser!.uid.toString(),
          'userName': userController.text.toString(),
          'phone': '',
          'email': email,
          'photoUrl': ''
        }).then((value) {
          print('Success');
          StorePrefrences sp = StorePrefrences();

          sp.setIsFirstOpen(true);
        });
        state.loading.value = false;
        Get.snackbar('Success', 'Congrats your account has been created');
        userController.clear();
        emailController.clear();
        passwordController.clear();
        Get.off(() => HomeScreen());
      }).onError((error, stackTrace) {
        state.loading.value = false;
        print('error is : ' + error.toString());
      });
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      print('Error is : ' + e.toString());
      state.loading.value = false;
    }
  }

  logInUser(String email, password) async {
    state.loading.value = true;
    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        Get.snackbar('Success', 'Congrats');

        StorePrefrences sp = StorePrefrences();
        sp.setIsFirstOpen(true);
        emailController.clear();
        passwordController.clear();
        Get.off(() => GMapScreen());

        state.loading.value = false;
      }).onError((error, stackTrace) {
        print('error is : ' + error.toString());
        Get.snackbar('Error', 'Something went wrong');
        state.loading.value = false;
      });
    } catch (e) {
      print('Error is : ' + e.toString());
      state.loading.value = false;
    }
  }
}
