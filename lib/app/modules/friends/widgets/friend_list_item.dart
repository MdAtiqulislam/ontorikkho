
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/widgets/friend_action_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/overlapping_avater.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import '../../../../utils/enums.dart';
import '../models/friend_button_config_factory.dart';



class FriendListItem extends StatelessWidget {
  final FriendsBasicInfoModel friend;
  final String? requestId;
  final FriendRequestStatus? status;
  final List<FriendsBasicInfoModel> mutualFriends;
  final int? mutualFriendsCount;
  final VoidCallback? onDetails;
  final FriendActionCallback onActionTap;

  const FriendListItem({
    super.key,
    required this.friend,
    this.requestId,
    required this.status,
    required this.mutualFriends,
    this.mutualFriendsCount,
    this.onDetails,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.contentPadding.h),
      child: InkWell(
        onTap: onDetails,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👤 Avatar
            CustomCircleAvatar(
              image: friend.avatar ?? "",
              width: 70.r,
              height: 70.r,
              border: 5,
              bgColor: AppColors.primaryColor.withAlpha(30),
            ),
            SizedBox(width: AppDimensions.widgetPadding.w),

            /// 📄 Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Text(
                    friend.name ?? "",
                    style: AppTextStyles.header(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: AppDimensions.contentPadding.h),

                  /// Mutual Friends
                  if (mutualFriends.isNotEmpty || (mutualFriendsCount ?? 0) > 0)
                    Row(
                      children: [

                        OverlappingAvatars(
                            items: mutualFriends,
                            imageBuilder: (e) => e.avatar ?? ""
                        ),

                        //_mutualAvatars(),
                        SizedBox(width: AppDimensions.contentPadding.w),
                        Expanded(
                          child: Text(
                            "${mutualFriendsCount ?? mutualFriends.length} mutual friends",
                            style: AppTextStyles.body(),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: AppDimensions.contentPadding.h),

                  /// Address
                  if ((friend.address ?? "").isNotEmpty)
                    Text(friend.address ?? "", style: AppTextStyles.body()),
                  SizedBox(height: AppDimensions.widgetPadding.h),

                  /// 🔥 Buttons using FriendActionButtons
                  _buildButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final config = FriendButtonConfigFactory.build(
      status: status,
      showRemoveForCanceled: true,
    );

    if (config.primaryText == null &&
        config.secondaryText == null &&
        (config.extraActions == null || config.extraActions!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return FriendActionButtons(
      config: config,
      friendId: friend.id.toString(),
      requestId: requestId,
      onActionTap: ({required action, required friendId, requestId}) async {
        onActionTap(action: action, friendId: friendId, requestId: requestId);
      },
    );
  }
}