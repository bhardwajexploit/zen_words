import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'splash_repo.dart';

class SplashController extends GetxController {
  final SplashRepo _repo;
  SplashController(this._repo);

  @override
  void onInit() {
    super.onInit();

    _boot();
  }

  void _boot() async {
    await Future.delayed(const Duration(seconds: 2));

    debugPrint("🔍 Checking session...");
    final hasSession = _repo.hasSession();
    debugPrint("Session exists: $hasSession");

    if (hasSession) {
      debugPrint("→ Going to /home");
      Get.offAllNamed('/home');
    } else {
      debugPrint("→ Going to /welcome (login flow)");
      Get.offAllNamed('/welcome');
    }

    _bindAuthListener();
  }


  void _bindAuthListener() {
    _repo.authChanges().listen((state) async {
      final event = state.event;
      final session = state.session;

      debugPrint("Auth event: $event, session: ${session?.user.email}");

      if (event == AuthChangeEvent.signedIn && session != null) {
        Get.offAllNamed('/home');
      }

      if (event == AuthChangeEvent.signedOut) {
        Get.offAllNamed('/welcome');
      }
    });
  }
}
