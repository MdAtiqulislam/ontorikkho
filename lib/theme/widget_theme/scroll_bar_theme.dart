
// 📁 lib/theme/widget_theme/scrollbar_theme.dart
import 'package:flutter/material.dart';
import '../../constraints/app_colors.dart';

class CustomScrollBarTheme {
  static ScrollbarThemeData scrollBarTheme = ScrollbarThemeData(
    thumbColor: WidgetStateProperty.all(AppColors.primaryColor.withOpacity(0.7)),
    radius: const Radius.circular(12),
  );
}