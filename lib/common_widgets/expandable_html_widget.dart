import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/constraints/app_colors.dart';

class ExpandableHtmlWidget extends StatefulWidget {
  final String htmlContent;
  final double? textSize;

  const ExpandableHtmlWidget({
    super.key,
    required this.htmlContent,
    this.textSize,
  });

  @override
  State<ExpandableHtmlWidget> createState() => _ExpandableHtmlWidgetState();
}

class _ExpandableHtmlWidgetState extends State<ExpandableHtmlWidget> {
  bool isExpanded = false;
  final int lineCount = 3;

  @override
  Widget build(BuildContext context) {
    final plainText = _htmlToPlainText(widget.htmlContent);

    final maxChars = lineCount * 30;
    final showToggle = plainText.length > maxChars;

    return GestureDetector(
      onTap: showToggle
          ? () => setState(() => isExpanded = !isExpanded)
          : null,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: widget.textSize ?? 13.sp,
            color: AppColors.bodyText,
          ),
          children: [
            TextSpan(
              text: isExpanded
                  ? plainText
                  : _truncateText(plainText, lineCount),
            ),
            if (showToggle)
              TextSpan(
                text: isExpanded ? '  Read less' : '  Read more',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: widget.textSize ?? 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int lines) {
    final maxChars = lines * 30;
    return text.length <= maxChars
        ? text
        : '${text.substring(0, maxChars).trim()}...';
  }

  String _htmlToPlainText(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }
}