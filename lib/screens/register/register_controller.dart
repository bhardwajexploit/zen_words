import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenwords/screens/register/register_repo.dart';

class RegisterController extends GetxController {
  final RegisterRepo _repo;
  RegisterController(this._repo);
  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPassword() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    // ✅ Network check before API call
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.wifi) &&
          !connectivityResult.contains(ConnectivityResult.mobile) &&
          !connectivityResult.contains(ConnectivityResult.ethernet)) {
        Get.snackbar(
          "No Internet",
          "Please check your connection and try again 💕",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    } catch (e) {
      // Network check failed, proceed anyway
      debugPrint("Network check failed: $e");
    }

    try {
      isLoading.value = true;

      await _repo.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint(e.toString());

      // ✅ SocketException specific handling
      if (e.toString().contains("SocketException") ||
          e.toString().contains("Network") ||
          e.toString().contains("Failed host lookup")) {
        Get.snackbar(
          "Connection Error",
          "Please check internet connection and try again",
          snackPosition: SnackPosition.TOP,
        );
      }
      // Other errors handled by repo (your existing logic)
    } finally {
      isLoading.value = false;
    }
  }

}
