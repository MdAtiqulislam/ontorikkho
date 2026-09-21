/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';

import '../../../../utils/util.dart';
import '../../../routes/app_pages.dart';
import '../../missingDocuments/controllers/missing_documents_controller.dart';

class DocumentUploadReminderCard extends GetView<HomeController> {
  const DocumentUploadReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

     decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
       color: AppColors.dangerColor.withOpacity(0.08),
     ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.contentPadding.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.dangerColor,
              size: 36.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText(
                    text: "Documents Pending!",
                    size: 14,
                    color: AppColors.dangerColor,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    getMissingDocsMessage(controller.missingDocuments.length),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.mutedText,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  AppButton(
                    text: "Upload Now",
                    fontSize: 12,
                    onTap: () {
                      Get.put(MissingDocumentsController()).missingDocuments=controller.missingDocuments;
                      Get.toNamed(Routes.MISSING_DOCUMENTS);
                    },
                    bgColor: AppColors.primaryColor,
                    verticalPadding: 6.h,
                    horizontalPadding: 14.w,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';

import '../../../../utils/util.dart';
import '../../../routes/app_pages.dart';
import '../../missingDocuments/controllers/missing_documents_controller.dart';

class DocumentUploadReminderCard extends GetView<HomeController> {
  const DocumentUploadReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final missingCount = controller.missingDocumentCount.value;
      final pendingCount = controller.pendingDocumentCount.value;

      if (missingCount == 0 && pendingCount == 0) {
        return const SizedBox.shrink();
      }

      // ✅ Improved readable messages
      String message = '';
      if (missingCount > 0 && pendingCount > 0) {
        message =
        "You have $missingCount document${missingCount > 1 ? 's' : ''} missing and $pendingCount pending for approval. Please upload the missing documents to complete your profile.";
      } else if (missingCount > 0) {
        message =
        "You have $missingCount document${missingCount > 1 ? 's' : ''} missing. Please upload ${missingCount > 1 ? 'them' : 'it'} to complete your profile.";
      } else if (pendingCount > 0) {
        message =
        "You have $pendingCount document${pendingCount > 1 ? 's are' : ' is'} waiting for admin approval. We’ll notify you once they are verified.";
      }

      // ✅ Card design
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          color: AppColors.warningColor.withOpacity(0.08),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.contentPadding.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                missingCount > 0
                    ? Icons.warning_amber
                    : Icons.hourglass_top_rounded,
                color:  missingCount > 0?AppColors.dangerColor:AppColors.warningColor,
                size: 36.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      text: missingCount > 0
                          ? missingCount > 1?"Documents Missing!":"Document Missing!"
                          : "Approval Pending!",
                      size: 14,
                      color:missingCount > 0?AppColors.dangerColor: AppColors.warningColor,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.mutedText,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if(missingCount > 0)AppButton(
                      text: missingCount > 0
                          ? "Upload Documents"
                          : "View Pending Status",
                      fontSize: 12,
                      onTap: () {
                        Get.put(MissingDocumentsController())
                            .missingDocuments = controller.missingDocuments;
                        Get.toNamed(Routes.MISSING_DOCUMENTS);
                      },
                      bgColor: AppColors.primaryColor,
                      verticalPadding: 6.h,
                      horizontalPadding: 14.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
