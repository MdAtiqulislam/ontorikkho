import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class CustomInfoDialog extends StatelessWidget {
  final String title;
  final String description;
  final Widget? infoIcon;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final String? acceptText;
  final String? declineText;

  const CustomInfoDialog({
    super.key,
    required this.title,
    required this.description,
    this.infoIcon,
    this.onAccept,
    this.onDecline,
    this.acceptText,
    this.declineText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      insetPadding: EdgeInsets.all(20.r),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              color: AppColors.primaryColor,
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.verticalPadding.h),
              child: HeaderText(text: title,color: Colors.white,align: TextAlign.start,),),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (infoIcon != null)
                  infoIcon!,
                if (infoIcon != null) SizedBox(height: 16.h),
                 SizedBox(height: 12.h),
                BodyText(text: description,maxLine: 30,),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (declineText != null)
                      AppButton(
                        onTap: () {
                          Get.back();
                          onDecline?.call();
                        },
                       text: declineText??"",
                        textColor: Colors.white,
                        bgColor: AppColors.dangerColor,
                        showBorder: false,
                      ),
                    if (acceptText != null)...
                      [
                        SizedBox(width: AppDimensions.sectionPadding.w,),
                        AppButton(
                          onTap: () {
                            Get.back();
                            onAccept?.call();
                          },
                          text: acceptText??"",
                          textColor: Colors.white,
                          bgColor: AppColors.primaryColor,
                          showBorder: false,
                        ),
                      ],
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
