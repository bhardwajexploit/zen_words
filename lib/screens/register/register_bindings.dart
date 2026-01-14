import 'package:get/get.dart';

import 'package:zenwords/screens/register/register_controller.dart';
import 'package:zenwords/screens/register/register_repo.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterRepo>(() => RegisterRepo());
    Get.lazyPut<RegisterController>(() => RegisterController(Get.find()));
  }
}
