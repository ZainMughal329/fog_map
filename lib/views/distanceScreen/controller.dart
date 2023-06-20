import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
class DistanceController extends GetxController{

  final ref=FirebaseDatabase.instance.ref("location");

}