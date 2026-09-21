import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constraints/app_colors.dart';
import '../../constraints/dimensions.dart';

class CustomInputTheme {
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 5,
    contentPadding: EdgeInsets.only(
      left: 24,
    //  bottom: 16.h,
     // top: 16.h,
    ),
    hintStyle:  TextStyle(
      color: AppColors.mutedText,
      fontSize: 14.sp,
    ),
    labelStyle:  TextStyle(
      color: AppColors.mutedText,
      fontSize: 12.sp,
    ),
    floatingLabelStyle: const TextStyle(
      color: AppColors.headerText,
      fontWeight: FontWeight.bold,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.inactiveColor),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.inactiveColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.mutedText),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      borderSide: const BorderSide(color: AppColors.primaryColor),
    ),
  );
}