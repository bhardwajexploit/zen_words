import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final _box = GetStorage();

  // Keys
  static const _dark = "isDark";


  // Dark Mode
  static bool get isDark => _box.read(_dark) ?? false;
  static void setDark(bool v) => _box.write(_dark, v);



}
