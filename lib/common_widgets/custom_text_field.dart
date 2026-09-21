import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constraints/app_colors.dart';
import '../../constraints/dimensions.dart';
import '../../constraints/header_text.dart';
import '../../constraints/app_strings.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? validatorText;
  final TextInputType? textInputType;
  final String? title;
  final String? levelText;
  final Widget? preFix;
  final Widget? suffix;
  final String? hintText;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final bool? isEnable;
  final bool isRequired;
  final bool? isPassword;
  final bool? readonly;
  final Widget? trailing;
  final List<TextInputFormatter>? inputFormatter;
  final VoidCallback? trailingAction;
  final VoidCallback? onEditingCompleted;
  final EdgeInsetsGeometry? titlePadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.validator,
    this.validatorText,
    this.hintText,
    this.title,
    this.maxLine,
    this.minLine,
    this.isEnable,
    this.isPassword,
    this.readonly,
    this.textInputType,
    this.trailing,
    this.maxLength,
    this.preFix,
    this.suffix,
    this.isRequired = false,
    this.trailingAction,
    this.onEditingCompleted,
    this.inputFormatter,
    this.levelText,
    this.titlePadding
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: titlePadding ?? EdgeInsets.zero,
            child: Row(
              children: [
                HeaderText(
                  text: title!,
                  size: 12,
                ),
                if (isRequired)
                  HeaderText(text: " *", color: Colors.red, size: 12),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                ),
                child: Stack(
                  children: [
                    TextFormField(
                      controller: controller,
                      keyboardType: textInputType,
                      maxLines: maxLine ?? 1,
                      minLines: minLine ?? 1,
                      maxLength: maxLength,
                      inputFormatters: inputFormatter,
                      obscureText: isPassword ?? false,
                      obscuringCharacter: "*",
                      readOnly: readonly ?? false,
                      enabled: isEnable,
                      onEditingComplete: onEditingCompleted,
                      cursorWidth: .5,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.headerText,
                      ),
                      validator: validator ??
                          (isRequired
                              ? (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Required"; // ✅ Default required text
                            }
                            return null;
                          }
                              : null),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(fontSize: 14.sp),
                        labelText: levelText != null
                            ? isRequired
                            ? "$levelText *"
                            : levelText
                            : null,
                        prefixIcon: preFix,
                        suffixIcon: suffix,
                        errorStyle: TextStyle(fontSize: 11.sp, color: AppColors.dangerColor),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),

                    // ⬇️ Multi-line indicator
                    if ((maxLine ?? 1) > 1 || (minLine ?? 1) > 1)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Image.asset(AppImagePath.textareaIcon),
                      ),
                  ],
                ),
              ),
            ),

            if (trailing != null)
              Material(
                color: Colors.transparent,
                child: IconButton(
                  padding: EdgeInsets.only(right: 16.w),
                  icon: trailing!,
                  onPressed: trailingAction,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
