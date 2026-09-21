
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/circular_button.dart';
import 'package:ontorikkho/constraints/app_strings.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class SocialButtons extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;
  final VoidCallback? onAppleTap;

  const SocialButtons({
    super.key,
    required this.onGoogleTap,
    required this.onFacebookTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: AppDimensions.horizontalPadding.w,
                ),
              ),
            ),
            const HeaderText(text: "OR",size: 15,),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: AppDimensions.horizontalPadding.w,
                ),
              ),
            ),
          ],
        ),
         SizedBox(height: AppDimensions.widgetPadding.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              iconPath: AppImagePath.fbIcon,
              onTap: onFacebookTap,
            ),
            SizedBox(width: AppDimensions.widgetPadding.w),
            _buildSocialButton(
              iconPath: AppImagePath.googleIcon,
              onTap: onGoogleTap,
            ),
            if (onAppleTap != null) ...[
              SizedBox(width: AppDimensions.widgetPadding.w),
              _buildSocialButton(
                iconPath: AppImagePath.appleIcon,
                onTap: onAppleTap!,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return CircularButton(
      bgColor: Colors.white,
        callback: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(iconPath),
        ),);
  }
}
