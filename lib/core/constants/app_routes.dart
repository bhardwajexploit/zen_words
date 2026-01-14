abstract class AppRoutes {
  AppRoutes._();
  static const home=_Paths.home;
  static const splash=_Paths.splash;
  static const welcome=_Paths.welcome;
  static const login=_Paths.login;
  static const register=_Paths.register;
  static const favourite=_Paths.favourite;
  static const collections=_Paths.collections;
}

abstract class  _Paths {
  static const register='/register';
  static const welcome='/welcome';
  static const login='/login';
  static const home='/home';
  static const splash='/splash';
  static const favourite='/fav';
  static const collections='/collections';
}