// 📁 widgets/common_text/body_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';

class BodyText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final Color? color;
  final double size;
  final int maxLine;
  final TextOverflow textOverflow;
  final FontWeight fontWeight;
  final bool resizeAble;
  final bool lineThrough; // 👈 New property added

  const BodyText({
    super.key,
    required this.text,
    this.color,
    this.size = 12,
    this.textOverflow = TextOverflow.ellipsis,
    this.fontWeight = FontWeight.w400,
    this.align = TextAlign.start,
    this.maxLine = 3,
    this.resizeAble = true,
    this.lineThrough = false, // 👈 Default is false
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      overflow: textOverflow,
      textAlign: align,
      style: TextStyle(
        color: color ?? AppColors.bodyText,
        fontSize: resizeAble ? size.sp : size.spMin,
        fontWeight: fontWeight,
        decoration: lineThrough ? TextDecoration.lineThrough : TextDecoration.none, // 👈 Here
      ),
    );
  }
}
