import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(text: "Contact Details",size: 12,align: TextAlign.start,),
          SizedBox(height: AppDimensions.contentPadding.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.email_outlined,color: AppColors.bodyText,size: 15.sp,),
                  SizedBox(width: AppDimensions.contentPadding.w,),
                  BodyText(text: "Email",size: 12,)
                ],
              ),
              HeaderText(text: "info@ontorikkho.com",size: 12,)
            ],
          ),
          SizedBox(height: AppDimensions.contentPadding.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_phone_outlined,color: AppColors.bodyText,size: 15.sp,),
                  SizedBox(width: AppDimensions.contentPadding.w,),
                  BodyText(text: "Phone Number",size: 12,)
                ],
              ),
              HeaderText(text: "+8801818-484021",size: 12,)
            ],
          ),
            ]),
      ),);
  }
}
