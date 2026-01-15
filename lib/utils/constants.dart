import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConstants {
  static const String appName = 'LowGo Cab';
  static const String whatsappNumber =
      '+919461386845'; // Updated with a placeholder but valid-ish number
  static const String contactEmail = 'support@lowgocab.online';

  // EmailJS Configuration (For Free Auto-Emails)
  static const String emailJsServiceId =
      'service_xxey8ct'; // Get from emailjs.com
  static const String emailJsTemplateId =
      'template_v4saizz'; // Get from emailjs.com
  static const String emailJsPublicKey =
      's9vo_rN7nVTZf27iz'; // Get from emailjs.com

  // Sightseeing Cab in Jaipur Inspired Palette - Enhanced for Modern Feel
  static const Color primaryColor = Color(0xFFEE0B5E); // Vibrant Pink/Magenta
  static const Color primaryLight = Color(0xFFFF4D8D);
  static const Color primaryDark = Color(0xFFB50847);

  static const Color secondaryColor = Color(0xFF1A1A1A); // Dark Grey/Black
  static const Color accentColor = Color(0xFFFFD700); // Gold

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFBFBFB);
  static const Color cardShadow = Color(0x0A000000);

  static const Color successColor = Color(0xFF27AE60);
  static const Color topBarColor = Color(0xFFEE0B5E);

  // Gradients for modern feel
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [secondaryColor, Color(0xFF333333)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppConstants.primaryColor,
    primary: AppConstants.primaryColor,
    onPrimary: Colors.white,
    secondary: AppConstants.secondaryColor,
    onSecondary: Colors.white,
    surface: AppConstants.backgroundColor,
  ),
  textTheme: GoogleFonts.outfitTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppConstants.secondaryColor,
    elevation: 0,
    centerTitle: false,
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style:
        ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
          elevation: 0,
          shadowColor: AppConstants.primaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.hovered)) return Colors.white12;
            return null;
          }),
        ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppConstants.primaryColor,
      side: const BorderSide(color: AppConstants.primaryColor, width: 2),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    color: Colors.white,
    margin: EdgeInsets.zero,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppConstants.surfaceColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
    ),
    labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    floatingLabelStyle: const TextStyle(
      color: AppConstants.primaryColor,
      fontWeight: FontWeight.bold,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  ),
);
