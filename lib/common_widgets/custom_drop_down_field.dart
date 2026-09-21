import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

class CustomDropDownField extends StatelessWidget {
  final String? levelText;
  final String? hintText;
  final String? title;
  final String? value;
  final bool? showBorder;
  final Color? bgColor;
  final bool isRequired;
  final int? itemIndex;
  final Function(String?)? onChange;
  final List<String> itemList;
  final String? Function(String?)? validator;
  final String? validatorText;
  final EdgeInsetsGeometry? titlePadding;

  const CustomDropDownField({
    required this.itemList,
    required this.onChange,
    this.isRequired=false,
    this.value,
    this.itemIndex,
    this.levelText,
    this.hintText,
    this.showBorder,
    this.bgColor,
    this.title,
    this.validator,
    this.validatorText,
    super.key,
    this.titlePadding
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null)
          Padding(
            padding: titlePadding?? EdgeInsets.zero,
            child: Row(
              children: [
                HeaderText(
                  text: title!,
                  size: 12,
                  // color: AppColors.mutedText,
                ),
                if(isRequired) HeaderText(text: " *",color: Colors.red,size: 12,),
              ],
            ),
          ),
        
        DropdownButtonFormField<String>(
          isExpanded: true,
          iconSize: 25,
          iconEnabledColor: AppColors.primaryColor,
          iconDisabledColor: AppColors.primaryColor,
          validator: validatorText != null
              ? (value) {
            if ((value ?? "").isEmpty) {
              return validatorText;
            }
            return null;
          }
              : validator,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.bodyText),
          decoration: InputDecoration(
            counterText: "",
            errorStyle: TextStyle(fontSize: 11.sp, color: AppColors.dangerColor),

            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadius.r),
              borderSide:
                  const BorderSide(color: AppColors.inactiveColor),
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadius.r),
              borderSide:
                  const BorderSide(color: AppColors.inactiveColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadius.r),
              borderSide:
                  const BorderSide(color: AppColors.mutedText),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadius.r),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
             hintText: hintText,
            labelText: levelText!=null?isRequired ? "$levelText *" : levelText:null,
            floatingLabelStyle: const TextStyle(
                color: AppColors.headerText,
                fontWeight: FontWeight.bold),
            //  prefixIcon: preFix,
            //  suffixIcon: suffix,
            hintStyle: const TextStyle(color: AppColors.mutedText,fontSize: 14),
            labelStyle: const TextStyle(color: AppColors.mutedText,fontSize: 12),
          ),
          items: itemList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: BodyText(text: value,maxLine: 3,align: TextAlign.start,),
            );
          }).toList(),
          onChanged:onChange,
          value: value,
        ),
      ],
    );

  }
}
