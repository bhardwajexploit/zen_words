import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zenwords/core/theme/app_theme_bindings.dart';
import 'package:zenwords/services/supabase_service.dart';

import 'core/constants/app_routes.dart';
import 'core/navigations/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  await SupabaseService.init();
/// Seeding data
//  await ZenSeeder.seedQuotes();
  await GetStorage.init();
  Get.put<ThemeController>(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppThemeBindings(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: Get.find<ThemeController>().theme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
