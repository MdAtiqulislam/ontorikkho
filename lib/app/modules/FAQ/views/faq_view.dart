import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/FAQ/views/faq_shimmer_view.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "FAQs",showBackButton: true,),

        body: Obx(() {
          if (controller.isLoading.value) {
            return FAQShimmerList();
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            itemCount: controller.faqs.length,
            itemBuilder: (context, index) {
              var faq = controller.faqs[index];
              bool isExpanded = controller.expandedIndices[index];

              return Container(
                margin: EdgeInsets.only(bottom: AppDimensions.contentPadding.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                  color: Color(0xffF5F5F5),
                ),
                child: ExpansionTile(
                  title: HeaderText(
                    text: "${faq.question}",
                    color: AppColors.headerText,
                    align: TextAlign.start,
                    maxLine: 5,
                    size: 14,
                  ),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (expanded) => controller.toggleExpansion(index),
                  tilePadding: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                    side: BorderSide.none, // Removes border
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                    side: BorderSide.none, // Removes border
                  ),
                  trailing: Obx(() => Icon(
                    controller.expandedIndices[index]
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: AppColors.primaryColor,
                  )),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child: BodyText(text:faq.answer??"",size: 12,maxLine: 50,align: TextAlign.start,),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
