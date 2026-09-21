import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

enum TextTransform { uppercase, lowercase, none }

class AppButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color? bgColor, textColor, borderColor, splashColor;
  final double? height, width, fontSize, horizontalPadding, verticalPadding;
  final FontWeight? fontWeight;
  final double borderRadius;
  final bool showBorder;
  final TextTransform textTransform;
  final Widget? leading; // Optional leading icon or image
  final Widget? trailing; // Optional trailing icon or image

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.bgColor,
    this.textColor,
    this.borderColor,
    this.splashColor,
    this.borderRadius = AppDimensions.borderRadius,
    this.height,
    this.width,
    this.fontSize = 15,
    this.fontWeight = FontWeight.bold,
    this.horizontalPadding = 10,
    this.verticalPadding = 5,
    this.showBorder = true,
    this.textTransform =
        TextTransform.none, // Default: uppercase transformation
    this.leading, // Initialize leading
    this.trailing, // Initialize trailing
  });

  String _applyTextTransform(String text) {
    switch (textTransform) {
      case TextTransform.uppercase:
        return text.toUpperCase();
      case TextTransform.lowercase:
        return text.toLowerCase();
      case TextTransform.none:
        return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border:
            showBorder
                ? Border.all(
                  color: borderColor ?? AppColors.primaryColor,
                  width: 1.5,
                )
                : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor:
              splashColor ??
              (bgColor == null ? AppColors.primaryColor : Color(0xFF0A3927)),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding!,
              vertical: verticalPadding!,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    SizedBox(width: AppDimensions.contentPadding.w),
                    // Spacing between leading icon and text
                  ],
                  HeaderText(
                    text: _applyTextTransform(text),
                    size: fontSize!,
                    fontWeight: fontWeight!,
                    color:
                        textColor ??
                        (bgColor == null
                            ? AppColors.primaryColor
                            : Colors.white),
                  ),
                  if (trailing != null) ...[
                    SizedBox(width: 8.w),
                    // Spacing between text and trailing icon
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
