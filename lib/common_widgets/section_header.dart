import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';

import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showMoreButton;
  final String? subTitle;
  final Widget? trailing;
  final VoidCallback? onTapViewAll; // <-- New parameter

  const SectionHeader({
    super.key,
    required this.title,
    this.showMoreButton = true,
    this.subTitle,
    this.trailing,
    this.onTapViewAll, // <-- Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title(),
              ),
            ),
            if (showMoreButton)
              TextButton(
                onPressed: onTapViewAll, // <-- Dynamic onTap
                child: Text(
                  "See All",
                  style: AppTextStyles.body(color: AppColors.primaryColor),
                ),
              ),
            if (trailing != null) ...[
              SizedBox(width: AppDimensions.contentPadding.w),
              trailing ?? SizedBox.shrink(),
            ],
          ],
        ),
        if (subTitle != null) BodyText(text: subTitle ?? ""),
      ],
    );
  }
}
