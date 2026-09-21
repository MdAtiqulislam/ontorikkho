
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_snackbar.dart';
import 'package:ontorikkho/common_widgets/custom_text_field.dart';
import 'package:ontorikkho/common_widgets/show_hide_password_button.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../controllers/subscriprtion_controller.dart';
class CompleteSubmission extends GetView<SubscriptionController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CompleteSubmission({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(text: "Your provided information:"),
          BodyText(
            text:
                "Mobile: ${_safe("+${controller.selectedPhoneCountry.value.callingCode??""}${controller.phoneController.text}")}\n"
                "Gender: ${_safe(controller.selectedGender)}\n"
                "Blood Group: ${_safe(controller.selectedBloodGroup)}\n"
                "Address: ${_safe(controller.addressController.text)}\n"
                "Emergency Contact: ${_safe("+${controller.selectedPhoneCountry.value.callingCode??""}${controller.emergencyContactController.text}")}\n"
                "Education: ${_safe(controller.selectedDegree.value.name)}\n"
                "Sports: ${_safe(controller.sportsController.text)}\n"
                "Hobbies: ${_safe(controller.hobbiesController.text)}\n"
                "Health Conditions: ${_safeListLabels(controller.selectedConditions)}\n"
                "Reason for Joining: ${_safe(controller.joiningReasonController.text)}\n"
                "Reference Member: ${_safe(controller.selectedReferenceMember.value.name?.toString())}\n"
                "Membership Type: ${_safe(controller.selectedMembership.value.title?.toString())}",
            maxLine: 50,
          ),


          SizedBox(height: 12.h),

          SizedBox(height: AppDimensions.sectionPadding.h,),
          AppButton(
              text: "Save",
              bgColor: AppColors.primaryColor,
              showBorder: false,
              onTap: (){
            if(_formKey.currentState?.validate()??false){
              if(controller.passwordController.text==controller.confirmPasswordController.text){
                controller.completeRegistration();

              }else{
                CustomSnackBar(
                  isSuccess: false,
                  msg: "Passwords do not match. Please try again."
                ).showSnackBar();
              }
            }
          }),
          SizedBox(height: AppDimensions.sectionPadding.h,)
        ],
      )),
    );
  }

  String _safe(String? value) {
    return (value == null || value.trim().isEmpty) ? '--' : value.trim();
  }
  String _safeListLabels(List<String> list) {
    if (list.isEmpty) return '--';
    return list.join(', ');
  }
}
