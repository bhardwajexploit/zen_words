import 'package:get/get.dart';
import 'collection_controller.dart';
import 'collection_repo.dart';

class CollectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CollectionsRepo());
    Get.put(CollectionsController(Get.find()));
  }
}
