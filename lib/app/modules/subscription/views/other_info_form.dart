
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_bottom_sheet.dart';
import '../../../../common_widgets/custom_check_box.dart';
import '../../../../common_widgets/custom_drop_down_field.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/app_strings.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../controllers/subscriprtion_controller.dart';
import 'health_condition_cb_section.dart';

class OtherInfoForm extends GetView<SubscriptionController> {
  OtherInfoForm({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthConditionCheckboxSection(),
          SizedBox(height: AppDimensions.contentPadding.h),

          //reference member section
          /*InkWell(
            onTap: () async {
              final selectedMember = await Get.toNamed(
                Routes.REFERENCE_MEMBER_LIST,
              );
              if (selectedMember != null) {
                controller.selectedReferenceMember.value = selectedMember;
                controller.referenceMemberController.text = selectedMember.name;
              }
            },
            child: IgnorePointer(
              ignoring: true,
              child: CustomTextField(
                title: "Reference Member",
                isRequired: true,
                readonly: true,
                hintText: "Enter Reference Member",
                controller: controller.referenceMemberController,
                validatorText: "Required",
              ),
            ),
          ),
          SizedBox(height: AppDimensions.contentPadding.h),*/

          CustomDropDownField(
            title: "Highest Education Degree",
            isRequired: true,
            itemList: controller.educationDegrees,
            onChange: (value) {
              controller.getSelectedDegree(value);
            },
            hintText: "--Select Education Degree--",
            value: controller.selectedDegree.value.name,
            validatorText: "Required",
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          CustomTextField(
            title: "Do you play sports?",
            hintText: "Enter Sports",
            maxLine: 10,
            minLine: 1,
            controller: controller.sportsController,
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          CustomTextField(
            title: "Do you have any hobbies?",
            hintText: "Enter hobbies",
            maxLine: 10,
            minLine: 1,
            controller: controller.hobbiesController,
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          CustomTextField(
            title: "Why you want to join the club?",
            hintText: "Enter reason",
            maxLine: 10,
            minLine: 1,
            controller: controller.joiningReasonController,
          ),
          SizedBox(height: AppDimensions.contentPadding.h),

          fileUploadSection(),

          Obx(() {
            final checkboxes = controller.getMembershipFeeCheckboxes();

            // ✅ Fill initial false values for each label
            for (var label in checkboxes) {
              controller.acceptedTerms.putIfAbsent(label, () => false);
            }

            final allChecked = controller.acceptedTerms.values.every((isChecked) => isChecked);

            return Column(
              children: [
                ...List.generate(checkboxes.length, (index) {
                  final label = checkboxes[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index != checkboxes.length - 1 ? 10.0 : 0.0,
                    ),
                    child: CustomCheckboxTile(
                      value: controller.acceptedTerms[label] ?? false,
                      onChanged: (val) {
                        controller.acceptedTerms[label] = val;
                        controller.acceptedTerms.refresh(); // refresh UI
                      },
                      label: label,
                    ),
                  );
                }),

                SizedBox(height: AppDimensions.widgetPadding.h),

                // ✅ Next Button with fade effect
                Obx(() {
                  final allChecked = controller.acceptedTerms.values.every((v) => v);

                  return AppButton(
                    text: "Next",
                    showBorder: false,
                    bgColor: allChecked
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.4), // fade look
                    onTap: allChecked
                        ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.pageIndex.value = 2;
                      }
                    }
                        : null, // disabled when unchecked
                  );
                }),
              ],
            );
          }),

          SizedBox(height: AppDimensions.sectionPadding),
        ],
      ),
    );
  }

  void chooseFileOption({required String fileType}) {
    showCustomBottomSheet(
      title: "Select an action",
      content: Column(
        children: [
          // Camera Option
          _buildOption(
            iconPath: AppImagePath.cameraIcon,
            text: "Open Camera",
            subText: "Capture an image using your camera",
            onTap: () {
              controller.selectImage(
                source: ImageSource.camera,
                fileType: fileType,
              );
              Get.back(); // Close bottom sheet
            },
          ),
          const Divider(),

          // Gallery Option
          _buildOption(
            iconPath: AppImagePath.galleryIcon,
            text: "Choose File",
            subText: "Select file from gallery",
            onTap: () {
              controller.handleDocumentSelection(fileType: fileType);
              Get.back(); // Close bottom sheet
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String iconPath,
    required String text,
    required String subText,
    required VoidCallback onTap,
  })
  {
    return Container(
      margin: const EdgeInsets.all(5),
      color: Colors.white,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Row(
              children: [
                Image.asset(iconPath, height: 30.h),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(text: text),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: BodyText(
                        text: subText,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fileUploadSection() {
    return controller.selectedMembership.value.id == 5
        ? Column(
          children: [
            InkWell(
              onTap: () {
                chooseFileOption(fileType: "NID");
              },

              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  title: "Upload NID",
                  hintText: "No file Chosen",
                  readonly: true,
                  isRequired: true,
                  validatorText: "Required",
                  controller: controller.nidController,
                  preFix: Container(
                    margin: EdgeInsets.only(right: 5.w),
                    width: 120.w,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.borderGrey),
                      ),
                    ),
                    child: Center(
                      child: BodyText(text: "Choose file", size: 14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.contentPadding.h),

            InkWell(
              onTap: () {
                chooseFileOption(fileType: "PROFILE");
              },
              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  title: "Upload Profile Picture",
                  hintText: "No file Chosen",
                  readonly: true,
                  isRequired: true,
                  validatorText: "Required",
                  controller: controller.profileController,
                  preFix: Container(
                    margin: EdgeInsets.only(right: 5.w),
                    width: 120.w,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.borderGrey),
                      ),
                    ),
                    child: Center(
                      child: BodyText(text: "Choose file", size: 14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.contentPadding.h),

          ],
        )
        : Column(
          children: [
            InkWell(
              onTap: () {
                chooseFileOption(fileType: "NID");
              },

              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  title: "Upload NID",
                  hintText: "No file Chosen",
                  readonly: true,
                  isRequired: true,
                  controller: controller.nidController,
                  validatorText: "Required",
                  preFix: Container(
                    margin: EdgeInsets.only(right: 5.w),
                    width: 120.w,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.borderGrey),
                      ),
                    ),
                    child: Center(
                      child: BodyText(text: "Choose file", size: 14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.contentPadding.h),

            InkWell(
              onTap: () {
                chooseFileOption(fileType: "PROFILE");
              },
              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  title: "Upload Profile Picture",
                  hintText: "No file Chosen",
                  readonly: true,
                  isRequired: true,
                  controller: controller.profileController,
                  preFix: Container(
                    margin: EdgeInsets.only(right: 5.w),
                    width: 120.w,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.borderGrey),
                      ),
                    ),
                    child: Center(
                      child: BodyText(text: "Choose file", size: 14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.contentPadding.h),

            if(controller.selectedMembership.value.id == 1 ||controller.selectedMembership.value.id == 2)InkWell(
              onTap: () {
                chooseFileOption(fileType: "TIN");
              },
              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  title: "Upload TIN Certificate",
                  hintText: "No file Chosen",
                  readonly: true,
                  isRequired: true,
                  controller: controller.tinController,
                  preFix: Container(
                    margin: EdgeInsets.only(right: 5.w),
                    width: 120.w,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.borderGrey),
                      ),
                    ),
                    child: Center(
                      child: BodyText(text: "Choose file", size: 14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.contentPadding.h),

            InkWell(
              onTap: () {
                chooseFileOption(fileType: "CV");
              },
              child: IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  title: "Upload CV",
                  hintText: "No file Chosen",
                  readonly: true,
                  controller: controller.cvController,
                  preFix: Container(
                    margin: EdgeInsets.only(right: 5.w),
                    width: 120.w,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.borderGrey),
                      ),
                    ),
                    child: Center(
                      child: BodyText(text: "Choose file", size: 14),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: AppDimensions.contentPadding.h),
          ],
        );
  }
}
