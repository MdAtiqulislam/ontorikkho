import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/extensions.dart';

import '../models/page_admins_model.dart';

class AdminCard extends StatelessWidget {
  final Admin admin;
  final String userId;
  final VoidCallback onRemove;

  const AdminCard({
    super.key,
    required this.admin,
    required this.userId,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOwner = admin.role.role.canDelete;
    final bool isMyCard = admin.userId.toString() == userId;

    return Container(
      margin: EdgeInsets.only(
        bottom: AppDimensions.contentPadding.h,
      ),
      decoration: BoxDecoration(
        color: isMyCard
            ? Colors.blue.withValues(alpha: .05)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadiusMedium.r,
        ),
        border: Border.all(
          color: isMyCard
              ? Colors.blue.withValues(alpha: .30)
              : Colors.grey.withValues(alpha: .10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadiusMedium.r,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            AppDimensions.widgetPadding.w,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMyCard ? 2.w : 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isMyCard
                      ? Border.all(
                    color: Colors.blue.withValues(alpha: .6),
                    width: 2,
                  )
                      : null,
                ),
                child: CustomCircleAvatar(
                  width: 56.sp,
                  height: 56.sp,
                  image: admin.user?.avatar ?? "",
                ),
              ),

              SizedBox(width: AppDimensions.widgetPadding.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (isMyCard)
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: Icon(
                              Icons.my_location_rounded,
                              size: 17.sp,
                              color: Colors.blue,
                            ),
                          ),

                        Expanded(
                          child: Text(
                            admin.user?.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:
                              AppDimensions.headerTextSize.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: AppDimensions.contentPadding.h,
                    ),

                    _RoleBadge(
                      role: admin.role ?? "",
                    ),
                  ],
                ),
              ),

              if (!isOwner && !isMyCard)
                Tooltip(
                  message: "Remove Admin",
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor:
                      Colors.red.withValues(alpha: .08),
                    ),
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.person_remove_alt_1_rounded,
                      color: Colors.red,
                      size: 20.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final color = _roleColor(role);

    final icon = switch (role.toLowerCase()) {
      "owner" => Icons.workspace_premium_rounded,
      "admin" => Icons.verified_user_rounded,
      "moderator" => Icons.security_rounded,
      _ => Icons.person_outline,
    };

    final roleName = role.isEmpty
        ? ""
        : role[0].toUpperCase() + role.substring(1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.contentPadding.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadiusLarge.r,
        ),
        border: Border.all(
          color: color.withOpacity(.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 15.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            roleName,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: AppDimensions.smallTextSize.sp,
            ),
          ),
        ],
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case "owner":
        return Colors.orange;
      case "admin":
        return Colors.blue;
      case "moderator":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}