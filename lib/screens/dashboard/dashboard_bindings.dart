import 'package:get/get.dart';
import 'package:zenwords/screens/dashboard/dashboard_controller.dart';
import 'package:zenwords/screens/dashboard/dashboard_repo.dart';

class DashboardBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardRepo(),fenix: true);
    Get.lazyPut(() =>DashboardController(Get.find<DashboardRepo>(),),fenix: true);
  }

}