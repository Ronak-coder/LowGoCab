import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'secrets.dart';

class AppConstants {
  static const String appName = 'LowGo Cab';
  static const String whatsappNumber = '+91 9461386845';
  static const String instagramUrl =
      'https://www.instagram.com/lowgocab?igsh=MXhueHdwNXBkNXlzMg==';
  static const String contactEmail =
      'pragyank@lowgocab.online'; // Admin receives all notifications
  static const String displayEmail = 'support@lowgocab.online'; // UI Display

  // Email via Google Apps Script (free relay using your Gmail)
  // See lib/utils/secrets.dart for setup instructions
  static const String googleScriptUrl = AppSecrets.googleScriptUrl;

  // TravelExplore Blue-Green Gradient Theme
  static const Color primaryColor = Color(0xFF0D8BFF); // Bright Blue
  static const Color primaryLight = Color(0xFF00C6FF);
  static const Color primaryDark = Color(0xFF0072FF);

  static const Color secondaryColor = Color(0xFF00C853); // Green
  static const Color accentColor = Color(0xFFFFB800); // Gold/Yellow

  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x0A000000);

  static const Color successColor = Color(0xFF00C853);
  static const Color topBarColor = Color(0xFF0D8BFF);

  // Main Blue-Green Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D8BFF), Color(0xFF00B4FF), Color(0xFF00C853)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Blue Gradient for headers
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF0D8BFF), Color(0xFF00C6FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Green Gradient
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1F36), Color(0xFF2D325A)],
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
  textTheme: GoogleFonts.interTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF1A1F36),
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
