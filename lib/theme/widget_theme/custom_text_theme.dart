import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/dimensions.dart';


class AppTextStyles {
  // ---------------- TITLE ----------------
  static TextStyle title({
    BuildContext? context,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,       // ✅ dynamic font size
    bool lineThrough = false,
    bool resizeAble = true,
  }) {
    final resolvedColor = color ??
        (context != null
            ? Theme.of(context).textTheme.headlineLarge?.color
            : AppColors.headerText);
    return TextStyle(
      fontSize: fontSize != null
          ? (resizeAble ? fontSize.sp : fontSize) // custom size
          : (resizeAble
          ? AppDimensions.titleTextSize.sp
          : AppDimensions.titleTextSize.spMin), // default
      fontWeight: fontWeight ?? FontWeight.bold,
      color: resolvedColor,
      decoration:
      lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    );
  }

  // ---------------- HEADER ----------------
  static TextStyle header({
    BuildContext? context,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    bool lineThrough = false,
    bool resizeAble = true,
  }) {
    final resolvedColor = color ??
        (context != null
            ? Theme.of(context).textTheme.headlineSmall?.color
            : AppColors.headerText);
    return TextStyle(
      fontSize: fontSize != null
          ? (resizeAble ? fontSize.sp : fontSize)
          : (resizeAble
          ? AppDimensions.headerTextSize.sp
          : AppDimensions.headerTextSize.spMin),
      fontWeight: fontWeight ?? FontWeight.w500,
      color: resolvedColor,
      decoration:
      lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    );
  }

  // ---------------- BODY ----------------
  static TextStyle body({
    BuildContext? context,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    bool lineThrough = false,
    bool resizeAble = true,
  }) {
    final resolvedColor = color ??
        (context != null
            ? Theme.of(context).textTheme.bodyMedium?.color
            : AppColors.bodyText);
    return TextStyle(
      fontSize: fontSize != null
          ? (resizeAble ? fontSize.sp : fontSize)
          : (resizeAble
          ? AppDimensions.bodyTextSize.sp
          : AppDimensions.bodyTextSize.spMin),
      fontWeight: fontWeight ?? FontWeight.w400,
      color: resolvedColor,
      decoration:
      lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    );
  }

  // ---------------- SMALL ----------------
  static TextStyle small({
    BuildContext? context,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    bool lineThrough = false,
    bool resizeAble = true,
  }) {
    final resolvedColor = color ??
        (context != null
            ? Theme.of(context).textTheme.bodySmall?.color
            : AppColors.mutedText);
    return TextStyle(
      fontSize: fontSize != null
          ? (resizeAble ? fontSize.sp : fontSize)
          : (resizeAble
          ? AppDimensions.smallTextSize.sp
          : AppDimensions.smallTextSize.spMin),
      fontWeight: fontWeight ?? FontWeight.w400,
      color: resolvedColor,
      decoration:
      lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    );
  }

  // ---------------- CAPTION ----------------
  static TextStyle caption({
    BuildContext? context,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    bool lineThrough = false,
    bool resizeAble = true,
  }) {
    final resolvedColor = color ??
        (context != null
            ? Theme.of(context).textTheme.labelSmall?.color
            : AppColors.mutedText);
    return TextStyle(
      fontSize: fontSize != null
          ? (resizeAble ? fontSize.sp : fontSize)
          : (resizeAble
          ? AppDimensions.captionTextSize.sp
          : AppDimensions.captionTextSize.spMin),
      fontWeight: fontWeight ?? FontWeight.w400,
      color: resolvedColor,
      decoration:
      lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    );
  }
}
