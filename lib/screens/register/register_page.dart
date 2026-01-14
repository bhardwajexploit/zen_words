import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/app_colours.dart';
import 'package:zenwords/screens/register/register_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Scaffold(
      resizeToAvoidBottomInset:true,
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
                        color: AppColors.softPurple.withValues(alpha: 0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Create Account",
                          style: GoogleFonts.bubblegumSans(
                            fontSize: 32,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Join ZenWords and start your daily positivity journey",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            color: AppColors.textDark.withValues(alpha: .7),
                          ),
                        ),

                        const SizedBox(height: 32),

                        _buildTextField(
                          controller: controller.nameController,
                          icon: Icons.person,
                          hint: "Full Name",
                        ),

                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: controller.emailController,
                          icon: Icons.email,
                          hint: "Email",
                        ),

                        const SizedBox(height: 20),

                        Obx(() => _buildPasswordField(
                          controller: controller.passwordController,
                          isHidden: controller.isPasswordHidden.value,
                          toggle: controller.togglePassword,
                          hint: "Password",
                          icon: Icons.lock,
                        )),

                        const SizedBox(height: 20),

                        Obx(() => _buildPasswordField(
                          controller: controller.confirmPasswordController,
                          isHidden:
                          controller.isConfirmPasswordHidden.value,
                          toggle: controller.toggleConfirmPassword,
                          hint: "Confirm Password",
                          icon: Icons.lock_outline,
                        )),

                        const SizedBox(height: 32),

                        Obx(() => _buildRegisterButton(controller)),

                        const SizedBox(height: 24),

                        GestureDetector(
                          onTap: () => Get.offAllNamed('/login'),
                          child: Text(
                            "Already have an account? Log in",
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cloudWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.softPurple.withValues(alpha: .1),
            blurRadius: 12,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.textDark),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.textDark)
          ),

          prefixIcon: Icon(icon, color: AppColors.heartPink),
          hintText: hint,
          hintStyle:
          TextStyle(color: AppColors.textDark.withValues(alpha: .5)),
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

  Widget _buildRegisterButton(RegisterController c) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: c.isLoading.value ? null : c.registerUser,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.softPurple.withValues(alpha: .7);
            }
            return AppColors.softPurple;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: c.isLoading.value
            ? const CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.textLight,
        )
            : Text(
          "Create Account",
          style: GoogleFonts.bubblegumSans(
            fontSize: 22,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }
}

Widget _buildPasswordField({
  required TextEditingController controller,
  required bool isHidden,
  required VoidCallback toggle,
  required String hint,
  required IconData icon,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.cloudWhite,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.softPurple.withValues(alpha: .1),
          blurRadius: 12,
        ),
      ],
    ),
    child: TextField(

      controller: controller,
      obscureText: isHidden,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColors.textDark),
        ),
        prefixIcon: Icon(icon, color: AppColors.heartPink),
        suffixIcon: IconButton(
          icon: Icon(
            isHidden ? Icons.visibility_off : Icons.visibility,
            color: AppColors.softPurple,
          ),
          onPressed: toggle,
        ),
        hintText: hint,
        hintStyle:
        TextStyle(color: AppColors.textDark.withValues(alpha: .5)),
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
