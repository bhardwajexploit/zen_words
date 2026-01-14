import 'package:get/get.dart';
import 'fav_controller.dart';
import 'fav_repo.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesRepo());
    Get.lazyPut(() => FavoritesController(Get.find()));
  }
}
