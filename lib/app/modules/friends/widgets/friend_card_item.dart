/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../utils/enums.dart';

class FriendCardItem extends StatelessWidget {
  final SingleFriendModel friend;
  final FriendRequestStatus status;

  final List<SingleFriendModel> mutualFriends;
  final int? mutualFriendsCount;

  final VoidCallback? onDetails;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback? onConfirm;
  final VoidCallback? onDelete;

  // ✅ Dynamic height & width
  final double? width;
  final double? height;

  const FriendCardItem({
    super.key,
    required this.friend,
    required this.status,
    required this.mutualFriends,
    this.mutualFriendsCount,
    this.onDetails,
    this.onAdd,
    this.onRemove,
    this.onConfirm,
    this.onDelete,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDetails,
      child: Container(
        width: width ?? 180.sp,
        height: height, // parent can pass height
        margin: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼️ Image (flex: 6)
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.borderRadius.r)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// 🔹 Background image with blur
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppDimensions.borderRadius.r)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomNetworkImage(
                            image: friend.avatar ?? "",
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔹 Foreground main image (contain)
                    Center(
                      child: CustomNetworkImage(
                        image: friend.avatar ?? "",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 📝 Content (flex: 4)
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 👤 Name
                    Text(
                      friend.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.header(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 4.h),

                    /// 📍 Address
                    if ((friend.address ?? "").isNotEmpty)
                      Text(
                        friend.address ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(),
                      ),

                    SizedBox(height: 4.h),

                    /// 🔥 Mutual Friends Row
                    if ((mutualFriends.isNotEmpty) || (mutualFriendsCount ?? 0) > 0)
                      Row(
                        children: [
                          _mutualAvatars(),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              "${mutualFriendsCount ?? mutualFriends.length} mutual friends",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body(),
                            ),
                          ),
                        ],
                      ),

                    Spacer(), // Push buttons to bottom

                    /// 🔥 Buttons
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mutualAvatars() {
    final list = mutualFriends.take(3).toList();

    return SizedBox(
      width: (list.length * 16).w,
      height: 20.h,
      child: Stack(
        children: List.generate(list.length, (index) {
          return Positioned(
            left: (index * 12).w,
            child: CustomCircleAvatar(
              width: 20.r,
              height: 20.r,
              image: list[index].avatar ?? "",
              border: 2,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildButtons() {
    if (status == FriendRequestStatus.requested) {
      return Row(
        children: [
          _primaryBtn("Confirm", onConfirm),
          SizedBox(width: AppDimensions.contentPadding.w),
          _secondaryBtn("Delete", onDelete),
        ],
      );
    } else {
      return Row(
        children: [
          _primaryBtn("Add friend", onAdd),
          SizedBox(width: AppDimensions.contentPadding.w),
          _secondaryBtn("Remove", onRemove),
        ],
      );
    }
  }

  Widget _primaryBtn(String text, VoidCallback? onTap) {
    return Expanded(
      child: SizedBox(
        height: 34.h,
        child: AppButton(
          text: text,
          onTap: onTap,
          bgColor: AppColors.primaryColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _secondaryBtn(String text, VoidCallback? onTap) {
    return Expanded(
      child: SizedBox(
        height: 34.h,
        child: AppButton(
          text: text,
          onTap: onTap,
          bgColor: AppColors.borderGrey,
          borderColor: AppColors.buttonGrey,
          textColor: AppColors.headerText,
          fontSize: 12,
        ),
      ),
    );
  }
}*/

/*
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/friends/models/button_config_model.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../utils/enums.dart';
class FriendCardItem extends StatelessWidget {
  final SingleFriendModel friend;
  final FriendRequestStatus? status;

  final List<SingleFriendModel> mutualFriends;
  final int? mutualFriendsCount;

  final VoidCallback? onDetails;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback? onConfirm;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  final double? width;
  final double? height;

  const FriendCardItem({
    super.key,
    required this.friend,
    required this.status,
    required this.mutualFriends,
    this.mutualFriendsCount,
    this.onDetails,
    this.onAdd,
    this.onRemove,
    this.onConfirm,
    this.onDelete,
    this.onCancel,
    this.width,
    this.height,
  });

  /// ✅ Status → Button Config Mapping
  ButtonConfigModel _getButtonConfig() {
    switch (status) {
      case FriendRequestStatus.friend:
        return ButtonConfigModel(
          primaryText: null,
          secondaryText: "Remove friend",
          secondaryAction: onRemove,
        );

      case FriendRequestStatus.sent:
        return ButtonConfigModel(
          primaryText: null,
          secondaryText: "Cancel request",
          secondaryAction: onCancel ?? onDelete,
        );

      case FriendRequestStatus.received:
        return ButtonConfigModel(
          primaryText: "Confirm",
          primaryAction: onConfirm,
          secondaryText: "Delete",
          secondaryAction: onDelete,
        );

      case FriendRequestStatus.canceled:
        return ButtonConfigModel(
          primaryText: "Add friend",
          primaryAction: onAdd,
          secondaryText: "Remove",
          secondaryAction: onRemove,
        );

      case FriendRequestStatus.blocked:
        return const ButtonConfigModel(
          primaryText: null,
          secondaryText: null,
        );

      default:
      /// null / unmatched
        return ButtonConfigModel(
          primaryText: "Add friend",
          primaryAction: onAdd,
          secondaryText: "Remove",
          secondaryAction: onRemove,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDetails,
      child: Container(
        width: width ?? 180.sp,
        height: height,
        margin: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼️ Image
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.borderRadius.r),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Background Blur
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomNetworkImage(
                          image: friend.avatar ?? "",
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Foreground Image
                    Center(
                      child: CustomNetworkImage(
                        image: friend.avatar ?? "",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 📝 Content
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name
                    Text(
                      friend.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.header(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    /// Address
                    if ((friend.address ?? "").isNotEmpty)
                      Text(
                        friend.address ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(),
                      ),

                    SizedBox(height: 4.h),

                    /// Mutual Friends
                    if (mutualFriends.isNotEmpty ||
                        (mutualFriendsCount ?? 0) > 0)
                      Row(
                        children: [
                          _mutualAvatars(),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              "${mutualFriendsCount ?? mutualFriends.length} mutual friends",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body(),
                            ),
                          ),
                        ],
                      ),

                    Spacer(),

                    /// 🔥 Buttons
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mutualAvatars() {
    final list = mutualFriends.take(3).toList();

    return SizedBox(
      width: (list.length * 16).w,
      height: 20.h,
      child: Stack(
        children: List.generate(list.length, (index) {
          return Positioned(
            left: (index * 12).w,
            child: CustomCircleAvatar(
              width: 20.r,
              height: 20.r,
              image: list[index].avatar ?? "",
              border: 2,
            ),
          );
        }),
      ),
    );
  }

  /// ✅ Button Builder
  Widget _buildButtons() {
    final config = _getButtonConfig();

    if (config.primaryText == null &&
        config.secondaryText == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (config.primaryText != null)
          Expanded(
            child: _primaryBtn(
              config.primaryText!,
              config.primaryAction,
            ),
          ),

        if (config.primaryText != null &&
            config.secondaryText != null)
          SizedBox(width: AppDimensions.contentPadding.w),

        if (config.secondaryText != null)
          Expanded(
            child: _secondaryBtn(
              config.secondaryText!,
              config.secondaryAction,
            ),
          ),
      ],
    );
  }

  Widget _primaryBtn(String text, VoidCallback? onTap) {
    return SizedBox(
      height: 34.h,
      child: AppButton(
        text: text,
        onTap: onTap,
        bgColor: AppColors.primaryColor,
        fontSize: 12,
      ),
    );
  }

  Widget _secondaryBtn(String text, VoidCallback? onTap) {
    return SizedBox(
      height: 34.h,
      child: AppButton(
        text: text,
        onTap: onTap,
        bgColor: AppColors.borderGrey,
        borderColor: AppColors.buttonGrey,
        textColor: AppColors.headerText,
        fontSize: 12,
      ),
    );
  }
}*/

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/for_you_controller.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/widgets/friend_action_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/common_widgets/overlapping_avater.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../utils/enums.dart';
import '../controllers/friends_controller.dart';
import '../models/friend_button_config_factory.dart';

class FriendCardItem extends StatelessWidget {
  final FriendsBasicInfoModel friend;
  final FriendRequestStatus? status;
  final List<FriendsBasicInfoModel> mutualFriends;
  final int? mutualFriendsCount;
  final VoidCallback? onDetails;
  final double? width;
  final double? height;
  final FriendActionCallback onActionTap;

  const FriendCardItem({
    super.key,
    required this.friend,
    required this.status,
    required this.mutualFriends,
    this.mutualFriendsCount,
    this.onDetails,
    this.width,
    this.height,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDetails,
      child: Container(
        width: width ?? 180.sp,
        height: height,
        margin: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼️ Image
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.borderRadius.r),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Blur BG
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomNetworkImage(
                          image: friend.avatar ?? "",
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Foreground Image
                    Center(
                      child: CustomNetworkImage(
                        image: friend.avatar ?? "",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 📝 Content
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name
                    Text(
                      friend.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.header(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 4.h),

                    /// Address
                    if ((friend.address ?? "").isNotEmpty)
                      Text(
                        friend.address ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(),
                      ),

                    SizedBox(height: 4.h),

                    /// Mutual Friends
                    if (mutualFriends.isNotEmpty ||
                        (mutualFriendsCount ?? 0) > 0)
                      Row(
                        children: [
                          OverlappingAvatars(items: mutualFriends, imageBuilder: (e)=>e.avatar??""),
                         // _mutualAvatars(),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              "${mutualFriendsCount ?? mutualFriends.length} mutual friends",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body(),
                            ),
                          ),
                        ],
                      ),

                    Spacer(),

                    /// 🔥 Buttons
                    _buildButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 👥 Mutual avatars
/*  Widget _mutualAvatars() {
    final list = mutualFriends.take(3).toList();

    return SizedBox(
      width: (list.length * 16).w,
      height: 20.h,
      child: Stack(
        children: List.generate(list.length, (index) {
          return Positioned(
            left: (index * 12).w,
            child: CustomCircleAvatar(
              width: 20.r,
              height: 20.r,
              image: list[index].avatar ?? "",
              border: 2,
            ),
          );
        }),
      ),
    );
  }*/

  /// 🔥 NEW BUTTON BUILDER (Factory Based)
  Widget _buildButtons() {
    final config = FriendButtonConfigFactory.build(
      status: status,
      showRemoveForCanceled: true,
    );

    /// nothing
    if (config.primaryText == null &&
        config.secondaryText == null &&
        (config.extraActions == null || config.extraActions!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return FriendActionButtons(
      config: config,
      friendId: friend.id.toString(),
      onActionTap: ({required action, required friendId, requestId}) async {
        onActionTap(action: action, friendId: friendId, requestId: requestId);
      },
    );
  }
}
