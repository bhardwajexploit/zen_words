import 'package:flutter/material.dart';
class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.find<SplashController>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('lib/core/assets/cute2.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.3), // dim background
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          // slight overlay for better contrast
          color: Colors.black.withValues(alpha: 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 70,),

              const SizedBox(height: 12),
              // Text(
              //   'Calm your mind with words',
              // style: TextStyle(color: AppColors.textDark,
              //   fontSize: 15,
              //   ),
              // ),

              const Spacer(),

              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
              const SizedBox(height: 24),
              const Text(
                'Loading your zen…',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
