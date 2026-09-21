import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constraints/app_colors.dart';

class SingleOTPBox extends StatelessWidget {
  final bool? isLast;
  final bool verified;
  final bool wrongOTP;
  final void Function(String?) onCompleted;
  final void Function(String)? onPaste; // <-- নতুন
  final TextEditingController? controller;

  const SingleOTPBox({
    this.isLast,
    required this.onCompleted,
    this.controller,
    this.onPaste, // <-- নতুন
    this.wrongOTP = false,
    this.verified = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.sp,
      height: 45.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: verified
              ? AppColors.primaryColor
              : wrongOTP
              ? AppColors.dangerColor
              : AppColors.bodyText,
          width: 2,
        ),
      ),
      child: Center(
        child: TextFormField(
          enabled: !verified,
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: (isLast ?? false) ? TextInputAction.done : TextInputAction.next,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
          cursorColor: AppColors.primaryColor,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
          ),
          onChanged: (value) async {
            // Check for paste
            if (value.length > 1 && onPaste != null) {
              onPaste!(value);
              // unfocus after paste
              FocusScope.of(context).unfocus();
              return;
            }

            if (value.isNotEmpty) {
              onCompleted(value);
              if (!(isLast ?? false)) {
                FocusScope.of(context).nextFocus();
              }
            } else {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }
}
