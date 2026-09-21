import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

import 'app_colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final double fontSize;

  const ExpandableText({
    super.key,
    required this.text,
    this.fontSize = 12,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: widget.fontSize.sp,
      color: AppColors.bodyText,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Html(
            data: widget.text,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(widget.fontSize.sp),
                color: AppColors.bodyText,
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
              ),
            },
          ),
          secondChild: Html(
            data: widget.text,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(widget.fontSize.sp),
                color: AppColors.bodyText,
              ),
            },
          ),
          crossFadeState:
          expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        InkWell(
          onTap: () => setState(() => expanded = !expanded),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              expanded ? "Read less" : "Read more",
              style: textStyle.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
