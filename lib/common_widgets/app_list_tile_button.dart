import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/dimensions.dart';
import '../constraints/header_text.dart';


class AppListTileButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget? icon;
  final String text;
  final double textSize;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final bool showHoverEffect;
  final double borderRadius;
  final Color? backgroundColor;
  final Widget? trailing;
  final EdgeInsetsGeometry? margin;
  final double elevation;

  const AppListTileButton({
    super.key,
    required this.onTap,
    this.icon,
    required this.text,
    this.textSize = 14,
    this.textColor,
    this.padding,
    this.showHoverEffect = true,
    this.borderRadius = AppDimensions.borderRadius,
    this.backgroundColor,
    this.trailing,
    this.margin,
    this.elevation=0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin??EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        color: backgroundColor ?? Colors.transparent,
        boxShadow: elevation>0?[BoxShadow(
          blurRadius: elevation,
          color: AppColors.shadowColor
        )]:[]
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Row(
              children: [
                if(icon!=null)...[icon!,
                  SizedBox(width: AppDimensions.widgetPadding.w),],
                Expanded(
                  child: HeaderText(
                    text: text,
                    size: textSize,
                    fontWeight: FontWeight.normal,
                    color: textColor ?? AppColors.headerText,
                    align: TextAlign.start,
                  ),
                ),
                if(trailing!=null)...[SizedBox(width: AppDimensions.contentPadding.w,),trailing??SizedBox.shrink()]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
