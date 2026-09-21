// 📁 lib/theme/widget_theme/app_bar_theme.dart
import 'package:flutter/material.dart';
import '../../constraints/app_colors.dart';

class CustomAppBarTheme {
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.headerText),
    titleTextStyle: const TextStyle(
      color: AppColors.headerText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  );
}