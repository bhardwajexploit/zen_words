import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../services/app_storage.dart';

class ThemeController extends GetxController {
  RxBool isDark = false.obs;
  @override
  void onInit() {
    super.onInit();
    isDark.value = AppStorage.isDark;
  }

  ThemeMode get theme => isDark.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(theme);
    AppStorage.setDark(isDark.value); // 🔥 Persist
  }
}
