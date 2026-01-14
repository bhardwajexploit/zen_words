import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_repo.dart';

class LoginController extends GetxController {
  final LoginRepo _repo;
  LoginController(this._repo);

  RxBool isPasswordHidden = true.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email and password required");
      return;
    }

    // ✅ Force network check
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.wifi) &&
          !connectivityResult.contains(ConnectivityResult.mobile)) {
        Get.snackbar("No Internet", "Please check connection");
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      isLoading.value = true;
      debugPrint("Attempting login: ${emailController.text}");

      await _repo.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // ✅ Let auth listener handle navigation (remove this)
      // Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}
