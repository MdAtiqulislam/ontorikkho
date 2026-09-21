// 📁 widgets/common_text/header_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final Color? color;
  final double size;
  final int maxLine;
  final TextOverflow textOverflow;
  final FontWeight fontWeight;
  final bool resizeAble;

  const HeaderText({
    super.key,
    required this.text,
    this.color,
    this.size = 16,
    this.textOverflow = TextOverflow.ellipsis,
    this.fontWeight = FontWeight.w600,
    this.align = TextAlign.center,
    this.maxLine = 1,
    this.resizeAble = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      overflow: textOverflow,
      textAlign: align,
      style: TextStyle(
        color: color ?? AppColors.headerText,
        fontSize: resizeAble ? size.sp : size.spMin,
        fontWeight: fontWeight,
      ),
    );
  }
}
