import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/pages/controllers/create_page_controller.dart';
import 'package:ontorikkho/app/modules/pages/models/page_category_model.dart';

import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/custom_text_field.dart';
import 'package:ontorikkho/common_widgets/custom_drop_down_field.dart';
import 'package:ontorikkho/common_widgets/file_option_bottom_sheet.dart';

import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/utils/enums.dart';
import 'package:ontorikkho/utils/extensions.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class CreatePageView extends GetView<CreatePageController> {
  CreatePageView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Create Page', showBackButton: true),

        body: Obx(
          () => Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ================= NAME =================
                      CustomTextField(
                        controller: controller.nameCtrl,
                        title: "Page Name",
                        hintText: "Enter Page Name",
                        isRequired: true,
                        validatorText: "Required",
                      ),

                      SizedBox(height: AppDimensions.sectionPadding.h),

                      /// ================= PAGE TYPE =================
                      CustomDropDownField(
                        title: "Page Type",
                        isRequired: true,
                        itemList: PageType.values.map((e) => e.label).toList(),
                        value: controller.selectedPageType.value?.label,
                        onChange: (val) {
                          if (val == null) return;

                          controller.selectedCategory.value = PageCategory();
                          controller.selectedPageType.value = PageType.values
                              .firstWhere((e) => e.label == val);

                          controller.getCategories();
                        },
                      ),

                      SizedBox(height: AppDimensions.sectionPadding.h),

                      /// ================= CATEGORY =================
                      Obx(() {
                        return CustomDropDownField(
                          title: "Category",
                          isRequired: true,
                          hintText: "Select category",
                          validatorText: "Required",
                          itemList:
                          controller.pageCategories
                              .map((e) => e.label ?? e.name ?? "")
                              .toList(),

                          value:
                          controller.pageCategories
                              .firstWhereOrNull(
                                (e) =>
                            e.id ==
                                controller.selectedCategory.value?.id,
                          )
                              ?.label,

                          onChange: (val) {
                            final selected = controller.pageCategories
                                .firstWhereOrNull((e) => e.label == val);

                            if (selected != null) {
                              controller.selectedCategory.value = selected;
                            }
                          },
                        );
                      }),

                      SizedBox(height: AppDimensions.sectionPadding.h),

                      /// ================= DESCRIPTION =================
                      CustomTextField(
                        title: "Description",
                        hintText: "Enter description Here",
                        minLine: 3,
                        maxLine: 50,
                        controller: controller.descCtrl,
                      ),

                      SizedBox(height: AppDimensions.sectionPadding.h),

                      /// ================= PROFILE IMAGE =================
                      Text(
                        "Profile Image",
                        style: TextStyle(
                          fontSize: AppDimensions.bodyTextSize.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppDimensions.contentPadding.h),

                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            FileOptionBottomSheet.show(
                              onCameraTap:
                                  () => controller.selectProfilePicture(
                                ImageSource.camera,
                              ),
                              onGalleryTap:
                                  () => controller.selectProfilePicture(
                                ImageSource.gallery,
                              ),
                            );
                          },
                          child: Container(
                            height: 110.h,
                            width: 110.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium.r,
                              ),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium.r,
                              ),
                              child:
                              controller.selectedProfileImage.value != null
                                  ? Image.file(
                                File(
                                  controller.selectedProfileImage.value!,
                                ),
                                fit: BoxFit.cover,
                              )
                                  : const Icon(Icons.add_a_photo),
                            ),
                          ),
                        );
                      }),

                      SizedBox(height: AppDimensions.sectionPadding.h),

                      /// ================= COVER IMAGE =================
                      Text(
                        "Cover Image",
                        style: TextStyle(
                          fontSize: AppDimensions.bodyTextSize.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppDimensions.contentPadding.h),

                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            FileOptionBottomSheet.show(
                              onCameraTap:
                                  () => controller.selectCoverPhoto(
                                ImageSource.camera,
                              ),
                              onGalleryTap:
                                  () => controller.selectCoverPhoto(
                                ImageSource.gallery,
                              ),
                            );
                          },
                          child: Container(
                            height: 150.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium.r,
                              ),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadiusMedium.r,
                              ),
                              child:
                              controller.selectedCoverImage.value != null
                                  ? Image.file(
                                File(controller.selectedCoverImage.value!),
                                fit: BoxFit.cover,
                              )
                                  : const Center(child: Icon(Icons.image)),
                            ),
                          ),
                        );
                      }),

                      SizedBox(height: AppDimensions.sectionPadding.h),

                      /// ================= SUBMIT =================
                      AppButton(
                        text: "Create Page",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            controller.submit();
                          }
                        },
                        bgColor: AppColors.primaryColor,
                        showBorder: false,
                      ),

                      SizedBox(height: AppDimensions.verticalPadding.h),
                    ],
                  ),
                ),
              ),
              if(controller.isLoading.value)LoadingScreen()
            ],
          )
        ),
      ),
    );
  }
}
