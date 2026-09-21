import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryColor = Color(0xFF188961); // Main blue
  static const Color accentYellow = Color(0xFFFDCB00); // Accent yellow (Product images)

  // Background & Surfaces
  static const Color scaffoldBg = Color(0xFFF8F8F8);
  static const Color cardBg = Colors.white;
  static const Color tableBorder = Color(0xFFD3D3D3);

  // Text Colors
  static const Color headerText = Color(0xFF1F1F1F);
  static const Color bodyText = Color(0xFF4F4F4F);
  static const Color mutedText = Color(0xFF6F6F6F);
  static const Color mutedButton = Color(0xFFABABAB);

  // Icon & UI Elements
  static const Color iconColor = Color(0xFF818181);
  static const Color buttonGrey = Color(0xFFECECEC);
  static const Color inactiveColor = Color(0xFFCCD0D3);
  static const Color borderGrey = Color(0xFFDDDDDD);
  static const Color borderLight = Color(0xFFF5EEE2);
  //static const Color shadowColor = Color(0xFFE7E7E7);
  static final Color shadowColor = Colors.black.withAlpha(80);


  // Status Colors
  static const Color warningColor = Color(0xFFFFC107);
  static const Color dangerColor = Color(0xFFFF0016);
  static const Color successColor = Color(0xFF28A745);
  static const Color infoColor = Color(0xFF17A2B8);


  static const MaterialColor primarySwatchColor = MaterialColor(
    0xFF0B192C,
    <int, Color>{
      50: Color(0xFFE3E6EA),
      100: Color(0xFFB9C1CD),
      200: Color(0xFF8C99AD),
      300: Color(0xFF5F718D),
      400: Color(0xFF3D5375),
      500: Color(0xFF0B192C), // Primary color
      600: Color(0xFF0A1627),
      700: Color(0xFF081322),
      800: Color(0xFF06101D),
      900: Color(0xFF040B14),
    },
  );


}
