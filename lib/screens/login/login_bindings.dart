import 'package:get/get.dart';
import 'login_controller.dart';
import 'login_repo.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepo>(() => LoginRepo());
    Get.lazyPut<LoginController>(() => LoginController(Get.find<LoginRepo>()));
  }
}
