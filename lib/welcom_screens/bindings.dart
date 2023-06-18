import 'package:fog_map/welcom_screens/controller.dart';
import 'package:get/get.dart';

class WelcomeBindings implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }

}