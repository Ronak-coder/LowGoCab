import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static const String appName = 'LowGo Cab';
  static const String whatsappNumber = '+91XXXXXXXXXX';

  // Sightseeing Cab in Jaipur Inspired Palette
  static const Color primaryColor = Color(0xFFEE0B5E); // Vibrant Pink/Magenta
  static const Color secondaryColor = Color(0xFF1A1A1A); // Dark Grey/Black
  static const Color accentColor = Color(0xFFFFD700); // Gold for accents
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color topBarColor = Color(0xFFEE0B5E);
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppConstants.primaryColor,
    primary: AppConstants.primaryColor,
    secondary: AppConstants.secondaryColor,
    surface: AppConstants.backgroundColor,
  ),
  textTheme: GoogleFonts.jostTextTheme(), // Using the Jost font as on the site
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  ),
);
