import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/expandable_html_widget.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class AnnouncementCard extends StatelessWidget {
 final String title;
 final String duration;
 final String desc;


   const AnnouncementCard({
    super.key,
    required this.title,
    required this.desc,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: HeaderText(text: title,size: 12,align: TextAlign.start,maxLine: 5,)),
          SizedBox(width: AppDimensions.contentPadding.w,),
          BodyText(text: duration,size: 12,),
        ],
      ),
      SizedBox(height: AppDimensions.contentPadding.h,),
      ExpandableHtmlWidget(
        htmlContent: desc,
        textSize: 12.sp,
      ),
         // SizedBox(height: AppDimensions.widgetPadding.h,),
    ]);
  }
}
