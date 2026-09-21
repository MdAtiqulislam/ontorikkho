
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ontorikkho/theme/widget_theme/custom_icon_theme.dart';
import 'package:ontorikkho/theme/widget_theme/custom_input_theme.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import 'package:ontorikkho/theme/widget_theme/scroll_bar_theme.dart';
import '../theme/widget_theme/app_bar_theme.dart';
import '../theme/widget_theme/button_theme.dart';
import '../constraints/app_colors.dart';

class CustomTheme {
  CustomTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    primarySwatch: AppColors.primarySwatchColor,
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    appBarTheme: CustomAppBarTheme.appBarTheme,
    buttonTheme: CustomButtonTheme.buttonTheme,
    iconTheme: CustomIconTheme.iconTheme,
    inputDecorationTheme: CustomInputTheme.inputDecorationTheme,
    //textTheme: CustomTextTheme.textTheme,
    scrollbarTheme: CustomScrollBarTheme.scrollBarTheme,
    splashColor: AppColors.primaryColor.withOpacity(.1),
    fontFamily: GoogleFonts.inter().fontFamily,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColorDark: AppColors.primaryColor,
    primarySwatch: AppColors.primarySwatchColor,
    scaffoldBackgroundColor: Colors.black,
   // textTheme: CustomTextTheme.darkTextTheme,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
}




