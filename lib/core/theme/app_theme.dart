import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zenwords/core/theme/app_colours.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.softPink,
    primaryColor: AppColors.heartPink,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDark),

    ),
    primaryTextTheme: GoogleFonts.bubblegumSansTextTheme(),

  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: AppColors.softPurple,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    primaryTextTheme: GoogleFonts.bubblegumSansTextTheme(),
  );
}
