
import 'package:get/get.dart';
import 'package:zenwords/core/theme/theme_controller.dart';

class AppThemeBindings extends Bindings{
  @override
  void dependencies() {
   Get.put(ThemeController(),permanent: true);
  }

}