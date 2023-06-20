import 'package:get/get.dart';

class SplashScreenController extends GetxController {
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
