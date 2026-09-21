import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/expandable_html_widget.dart';

class PostTextContent extends StatelessWidget {
  final String text;

  const PostTextContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width,
        child: ExpandableHtmlWidget( htmlContent: text,));
  }
}
