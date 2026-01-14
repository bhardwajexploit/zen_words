import 'package:get/get.dart';
import 'package:zenwords/screens/splash/splash_controller.dart';
import 'package:zenwords/screens/splash/splash_repo.dart';

class SplashBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SplashRepo());
  Get.put<SplashController>(SplashController(Get.find()));
  }

}