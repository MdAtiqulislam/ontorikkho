import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/controllers/share_post_controller.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';

class PostShareBottomSheet extends GetView<SharePostController> {
  const PostShareBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 12.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Handle
              Container(
                width: 45.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                "Share Post",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 18.h),

              _shareToWallView(),

              /* /// Search Friend
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.horizontalPadding.w,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search friend...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),*/
              SizedBox(height: AppDimensions.widgetPadding.h),

              /// Recent Friends
              if (controller.isLoading.value)
                Center(child: CircularProgressIndicator()),
              if (controller.friends.isNotEmpty)
                SizedBox(
                  height: 95.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.horizontalPadding.w,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final friend = controller.friends[index];
                      return SizedBox(
                        width: 70.w,
                        child: InkWell(
                          onTap: () {
                            controller.shareToFriend(friendId: friend.id.toString(), caption: "Share post");
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CustomCircleAvatar(
                                    image: friend.avatar,
                                    width: 58.r,
                                    height: 58.r,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 18.r,
                                      height: 18.r,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                friend.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(width: 14.w),
                    itemCount: controller.friends.length,
                  ),
                ),

              Divider(height: 28.h),

              _ShareTile(
                icon: Icons.dynamic_feed_rounded,
                color: Colors.blue,
                title: "Share to Wall",
                subtitle: "Post this on your profile",
                onTap: () {
                  controller.shareToWall(caption: "Share post");
                },
              ),

              /*            _ShareTile(
              icon: Icons.message_rounded,
              color: Colors.green,
              title: "Send in Message",
              subtitle: "Share with your friends",
              onTap: () {},
            ),*/
              _ShareTile(
                icon: Icons.link_rounded,
                color: Colors.orange,
                title: "Copy Link",
                subtitle: "Copy post URL",
                onTap: () {
                  controller.copyLink();
                },
              ),

              _ShareTile(
                icon: Icons.share_rounded,
                color: Colors.purple,
                title: "More Apps",
                subtitle: "WhatsApp, Messenger, Telegram...",
                onTap: () {
                  controller.shareExternal();
                },
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shareToWallView() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.horizontalPadding.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.09),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCircleAvatar(
                  width: 52.sp,
                  height: 52.sp,
                  image: controller.user.value.profileImage ?? "", // user avatar
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.user.value.name??"", style: AppTextStyles.header()),

                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          _badge(
                            icon: Icons.dynamic_feed_rounded,
                            text: "Feed",
                          ),

                          SizedBox(width: 8.w),

                          _badge(icon: Icons.public, text: "Public"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            TextField(
              minLines: 5,
              maxLines: 8,
              controller: controller.cationController,
              decoration: InputDecoration(
                hintText: "Say something about this post...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),

            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 100.w,
                child: AppButton(text: "Share now",
                    bgColor: AppColors.primaryColor,
                    onTap: () {
                      controller.shareToWall(caption: controller.cationController.text);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: Colors.grey.shade700),
          SizedBox(width: 5.w),
          Text(
            text,
            style: AppTextStyles.body(
              color: Colors.grey.shade700,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShareTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      leading: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp)),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade500),
    );
  }
}
