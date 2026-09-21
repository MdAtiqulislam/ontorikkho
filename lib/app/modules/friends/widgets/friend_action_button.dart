import 'package:flutter/material.dart';
import '../../../../utils/enums.dart';
import '../models/button_config_model.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../common_widgets/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef FriendActionCallback =
    void Function({
      required FriendActionType action,
      required String friendId,
      String? requestId,
    });

class FriendActionButtons extends StatelessWidget {
  final ButtonConfigModel config;
  final String friendId;
  final String? requestId;
  final bool isLoading;
  final FriendActionCallback onActionTap;

  const FriendActionButtons({
    super.key,
    required this.config,
    required this.friendId,
    this.requestId,
    this.isLoading = false,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    Widget buildBtn(String text, FriendActionType action, bool primary) {
      return Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: SizedBox(
          height: 36.h,
          child: AppButton(
            text: text,
            fontSize: 12,
            bgColor: primary ? AppColors.primaryColor : AppColors.borderGrey,
            textColor: primary ? Colors.white : AppColors.headerText,
            borderColor: primary ? null : AppColors.buttonGrey,
            onTap:
                isLoading
                    ? null
                    : () {
                      onActionTap(
                        action: action,
                        friendId: friendId,
                        requestId: requestId,
                      );
                    },
          ),
        ),
      );
    }

    // Primary
    if (config.primaryText != null && config.primaryActionType != null) {
      buttons.add(
        buildBtn(config.primaryText!, config.primaryActionType!, true),
      );
    }

    // Secondary
    if (config.secondaryText != null && config.secondaryActionType != null) {
      buttons.add(
        buildBtn(config.secondaryText!, config.secondaryActionType!, false),
      );
    }

    // Extra actions
    if (config.extraActions != null) {
      for (var action in config.extraActions!) {
        buttons.add(buildBtn(action.text, action.action, action.isPrimary));
      }
    }

    return Row(children: buttons);
  }
}
