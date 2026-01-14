import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/app_colours.dart';

import 'login_controller.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>(); // ✅ Inject controller

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.softPink,
              AppColors.lavender,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 420),
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.cloudWhite.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.heartPink.withValues(alpha: 0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome Back",
                        style: GoogleFonts.bubblegumSans(
                          fontSize: 32,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Sign in to continue your daily dose of positivity",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          color: AppColors.textDark.withValues(alpha: .7),
                        ),
                      ),

                      const SizedBox(height: 32),

                      _buildTextField(
                        controller: controller.emailController,
                        icon: Icons.email,
                        hint: "Email",
                      ),

                      const SizedBox(height: 20),

                      Obx(() => _buildPasswordField(controller)),


                    const SizedBox(height: 32),

                      Obx(() => _buildLoginButton(controller)),

                      const SizedBox(height: 20),

                      Text(
                        "or",
                        style: TextStyle(
                          color: AppColors.textDark.withValues(alpha: .6),
                        ),
                      ),

                      const SizedBox(height: 24),

                      InkWell(
                        onTap: (){
                          Get.toNamed('/register');
                        },
                        child: Text(
                          "Don’t have an account? Sign up",
                          style: GoogleFonts.quicksand(
                            color: AppColors.softPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cloudWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.heartPink.withValues(alpha: .1),
            blurRadius: 12,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: AppColors.textDark),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.textDark)
          ),
          prefixIcon: Icon(icon, color: AppColors.softPurple),
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textDark.withValues(alpha: .5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.cloudWhite,
        ),
      ),
    );
  }

  Widget _buildLoginButton(LoginController c) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: c.isLoading.value ? null : c.loginUser, // ✅ wired
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.heartPink.withValues(alpha: .7);
            }
            return AppColors.heartPink;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: c.isLoading.value
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textLight,
          ),
        )
            : Text(
          "Login",
          style: GoogleFonts.bubblegumSans(
            fontSize: 22,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(LoginController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cloudWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.heartPink.withValues(alpha: .1),
            blurRadius: 12,
          ),
        ],
      ),
      child: TextField(
        controller: controller.passwordController,
        obscureText: controller.isPasswordHidden.value,
        style: const TextStyle(color: AppColors.textDark),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.textDark)
          ),
          prefixIcon: const Icon(Icons.lock, color: AppColors.softPurple),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordHidden.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.heartPink,
            ),
            onPressed: controller.togglePassword,
          ),
          hintText: "Password",
          hintStyle: TextStyle(
            color: AppColors.textDark.withValues(alpha: .5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.cloudWhite,
        ),
      ),
    );
  }


}
