
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_drop_down_field.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_phone_field.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../controllers/subscriprtion_controller.dart';

class UserInfoForm extends GetView<SubscriptionController> {



   UserInfoForm({super.key,});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Obx((){return Column(
        children: [
          CustomDropDownField(
            title: "Membership",
            isRequired: true,
            itemList: controller.membershipTypes,
            onChange: (value) {
              controller.getSelectedMemberShip(value);
            },
            value: controller.selectedMembership.value.title?.isEmpty ?? true
                ? null
                : controller.selectedMembership.value.title=="Affiliate"
                ?"${controller.selectedMembership.value.title} (Free)"
                :controller.selectedMembership.value.title,
            hintText: "--Select Membership Plan--",
            validatorText: "Required",
          ),

          SizedBox(height: AppDimensions.contentPadding.h),
          SizedBox(height: AppDimensions.contentPadding.h),
          Obx(() {
            if (controller.isCountryLoading.value) {
              return const CircularProgressIndicator();
            }

            return Column(
              children: [
                CustomPhoneTextField(
                  title: "Phone Number",
                  isRequired: true,
                  selectedCountry: controller.selectedPhoneCountry.value,
                  callingCode: controller.selectedPhoneCountry.value.callingCode ?? "",
                  controller: controller.phoneController,

                  onChange: (value) {
                    controller.selectedPhoneCountry.value = value;
                  },
                ),
                SizedBox(height: AppDimensions.contentPadding.h),
                CustomPhoneTextField(
                  title: "Emergency Contact",
                  isRequired: false,

                  selectedCountry: controller.selectedEmergencyContactCountry.value,
                  callingCode: controller.selectedEmergencyContactCountry.value.callingCode ?? "",
                  controller: controller.emergencyContactController,
                  onChange: (value) {
                    controller.selectedEmergencyContactCountry.value = value;
                  },
                ),
              ],
            );
          }),

          SizedBox(height: AppDimensions.contentPadding.h),
          CustomDropDownField(
            title: "Gender",
            isRequired: true,
            itemList: controller.genders,
            onChange: (value){
              controller.selectedGender=value??"";
            },
            hintText: "--Select Gender--",
            value: controller.selectedGender!=""?controller.selectedGender:null,
            validatorText: "Required",
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          CustomDropDownField(
            title: "Blood Group",
            itemList: controller.bloodGroup,
            onChange: (value){
              controller.selectedBloodGroup=value??"";
            },
            value: controller.selectedBloodGroup!=""?controller.selectedBloodGroup:null,
            hintText: "--Select Blood Group--",
          ),
          SizedBox(height: AppDimensions.contentPadding.h),
          CustomTextField(
            title: "Address",
            hintText: "Insert Address",
            maxLine: 10,
            minLine: 5,
            isRequired: true,
            validatorText: "Required",
            controller: controller.addressController,
          ),
          SizedBox(height: AppDimensions.sectionPadding.h),
          AppButton(
            text: "Next",
            onTap: () {

              if (_formKey.currentState?.validate() ?? false) {
                controller.scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.bounceIn);
                controller.pageIndex.value=1;

              }
            },
            bgColor: AppColors.primaryColor,
          ),
          SizedBox(height: AppDimensions.sectionPadding.h,)
        ],
      );})
    );
  }
}
