import 'package:get/get.dart';
import 'package:zenwords/screens/collections/collection_binding.dart';
import 'package:zenwords/screens/collections/collection_page.dart';
import 'package:zenwords/screens/dashboard/dashboard_bindings.dart';
import 'package:zenwords/screens/dashboard/dashboard_page.dart';
import 'package:zenwords/screens/favourite/fav_bindings.dart';
import 'package:zenwords/screens/favourite/fav_page.dart';
import 'package:zenwords/screens/login/login_bindings.dart';
import 'package:zenwords/screens/login/login_page.dart';
import 'package:zenwords/screens/register/register_bindings.dart';
import 'package:zenwords/screens/register/register_page.dart';
import 'package:zenwords/screens/splash/splash_bindings.dart';
import 'package:zenwords/screens/welcome/welcome_page.dart';
import '../constants/app_routes.dart';
import '../../screens/splash/splash.dart';
class AppPages {
  AppPages._();
  static final routes =[
    GetPage(name:AppRoutes.splash, page: () => Splash(),binding: SplashBindings()),
    GetPage(name: AppRoutes.home, page:() => DashboardPage(),binding: DashboardBindings()),
    GetPage(name: AppRoutes.login, page: () => LoginPage(),binding: LoginBinding()),
    GetPage(name: AppRoutes.register, page: () => RegisterPage(),binding: RegisterBinding()),
    GetPage(name: AppRoutes.welcome,page:() =>   WelcomePage() ),
    GetPage(name: AppRoutes.favourite, page: () =>FavoritesPage(),binding: FavoritesBinding()),
    GetPage(
      name: AppRoutes.collections,
      page: () => const CollectionsPage(),binding: CollectionsBinding(),
    ),
  ];
}