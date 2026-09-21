import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../utils/enums.dart';

typedef PageActionCallback = void Function({
required PageActionType action,
required String pageId,
});



class PageActionButtons extends StatelessWidget {
  final PageStatus status;
  final String pageId;
  final bool isLoading;
  final PageActionCallback? onActionTap;
  const PageActionButtons({
    super.key,
    required this.status,
    required this.pageId,
    this.isLoading = false,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getButtonConfig(status);

    return Row(
      children: [

        /// ================= PRIMARY BUTTON =================
        if (config.primaryText != null)
          Expanded(
            child: _buildButton(
              text: config.primaryText!,
              action: config.primaryAction!,
              isPrimary: true,
              onTap: () {
                onActionTap?.call(
                  action: config.primaryAction!,
                  pageId: pageId,
                );
              },
            ),
          ),

        /// ================= SPACING =================
        if (config.primaryText != null &&
            config.secondaryText != null)
          SizedBox(width: 8.w),

        /// ================= SECONDARY BUTTON =================
        if (config.secondaryText != null)
          Expanded(
            child: _buildButton(
              text: config.secondaryText!,
              action: config.secondaryAction!,
              isPrimary: false,
              onTap: () {
                onActionTap?.call(
                  action: config.secondaryAction!,
                  pageId: pageId,
                );
              },
            ),
          ),
      ],
    );
  }

  PageButtonConfig _getButtonConfig(PageStatus status) {
    switch (status) {

    /// ================= NOT FOLLOWING =================
      case PageStatus.notFollowing:
        return const PageButtonConfig(
          primaryText: "Follow",
          primaryAction: PageActionType.follow,
          secondaryText: "Remove",
          secondaryAction: PageActionType.remove,
        );

    /// ================= FOLLOWING =================
      case PageStatus.following:
        return const PageButtonConfig(
          primaryText: "Following",
          primaryAction: PageActionType.unfollow,
         // secondaryText: "Message",
        //  secondaryAction: PageStatus.active,
        );

    /// ================= INVITED =================
      case PageStatus.invited:
        return const PageButtonConfig(
          primaryText: "Accept",
          primaryAction: PageActionType.accept,
          secondaryText: "Decline",
          secondaryAction: PageActionType.denied,
        );

    /// ================= REQUESTED =================
      case PageStatus.requested:
        return const PageButtonConfig(
         // primaryText: "Requested",
         // primaryAction: PageActionType.,
          secondaryText: "Cancel Request",
          secondaryAction: PageActionType.cancel,
        );

    /// ================= ACTIVE =================
      case PageStatus.active:
        return const PageButtonConfig(
          primaryText: "Open",
          primaryAction: PageActionType.viewPage,
        );

    /// ================= INACTIVE =================
      case PageStatus.inactive:
        return const PageButtonConfig(
          primaryText: "Inactive",
          primaryAction: PageActionType.active,
        );

    /// ================= BLOCKED =================
      case PageStatus.blocked:
        return const PageButtonConfig(
          primaryText: "Unblock",
          primaryAction: PageActionType.unblock,
        );
    }
  }

  Widget _buildButton({
    required String text,
    required PageActionType action,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 36.h,
      child: AppButton(
        text: text,
        fontSize: 12,
        bgColor:
        isPrimary ? AppColors.primaryColor : AppColors.borderGrey,
        textColor:
        isPrimary ? Colors.white : AppColors.headerText,
        borderColor:
        isPrimary ? null : AppColors.buttonGrey,
        onTap: isLoading ? null : onTap,
      ),
    );
  }
}

class PageButtonConfig {
  final String? primaryText;
  final PageActionType? primaryAction;

  final String? secondaryText;
  final PageActionType? secondaryAction;

  const PageButtonConfig({
    this.primaryText,
    this.primaryAction,
    this.secondaryText,
    this.secondaryAction,
  });
}