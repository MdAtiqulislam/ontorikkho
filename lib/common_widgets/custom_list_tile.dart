import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class CustomListTile extends StatelessWidget {
  final String avatar;
  final String? localAvatar;
  final String title;
  final Widget? trailing;
  final Widget? subTitle;
  final Widget? leading;
  final double? avatarHeight;
  final double? avatarWidth;
  final double? elevation;
  final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    this.avatar = "",
    this.localAvatar,
    required this.title,
    this.trailing,
    this.avatarHeight,
    this.avatarWidth,
    this.subTitle,
    this.leading,
    this.onTap,
    this.elevation
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: elevation??1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              // Profile Picture
              ...[
                leading ?? SizedBox.shrink(),
                SizedBox(width: AppDimensions.contentPadding.w),
              ],
              CustomCircleAvatar(
                height: avatarHeight ?? 50.sp,
                width: avatarWidth ?? 50.sp,
                localImage: localAvatar,
                image: avatar,
              ),
              SizedBox(width: 12.w),

              // Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(text: title, size: 12, align: TextAlign.start),
                    if (subTitle != null) ...[
                     // SizedBox(height: AppDimensions.contentPadding.h),
                      subTitle!,
                    ],
                  ],
                ),
              ),

              // Trailing (Optional)
              if (trailing != null) ...[SizedBox(width: 8.w), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
