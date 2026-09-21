import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_loading_screen.dart';
import 'package:ontorikkho/common_widgets/link_preview.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../utils/util.dart';
import '../controllers/create_post_controller.dart';
import 'add_text_sheet.dart';
import 'all_media_view.dart';

class CreatePostView extends GetView<CreatePostController> {
  CreatePostView({super.key});

  final List<PostOption> postOptions = [
    PostOption(Icons.location_on, "Location"),
    PostOption(Icons.emoji_emotions, "Feeling/activity"),
    PostOption(Icons.photo_album, "Album"),
    PostOption(Icons.person_add, "Tag people"),
    PostOption(Icons.flag, "Event"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _bottomNavBar(),
        body: Obx(()=>Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top AppBar
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: Get.back,
                      ),
                      const Expanded(
                        child: Text(
                          "New post",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.transparent,),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                /// User info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                          width: 30.sp,
                          height: 30.sp,
                          border: 3,
                        image: controller.postProfileType==PostProfileType.profilePost
                            ?controller.user.value.profileImage
                            :controller.pageDetails.value.profileImage,
                      ),
                      const SizedBox(width: 10),
                       Flexible(
                         child: Text(
                          controller.postProfileType==PostProfileType.profilePost
                              ?controller.user.value.name??""
                              :controller.pageDetails.value.name??"",
                          style: TextStyle(fontWeight: FontWeight.bold,),
                           maxLines: 2,
                                               ),
                       ),
                    ],
                  ),
                ),

                /// Chips
              /*  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: postOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final option = postOptions[index];
                        return _Chip(icon: option.icon, label: option.label);
                      },
                    ),
                  ),
                ),*/

                const SizedBox(height: 12),

                /// Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: openTextEditor,
                      child: Obx(() {
                        var text = controller.text.value;
                        final link = extractFirstLink(text);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Text
                            Text(
                              text.isEmpty ? "What's on your mind?" : text,
                              style: TextStyle(
                                fontSize: 16,
                                color: text.isEmpty ? Colors.grey : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),

                            /// Media Preview
                            if (controller.selectedMedia.isNotEmpty)
                              Obx(() {
                                final mediaList = controller.selectedMedia;
                                final mediaCount = mediaList.length;

                                /// 🔳 GRID (more then 4)
                                if (mediaCount > 4) {
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.w,
                                      mainAxisSpacing: 8.h,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: mediaCount > 4 ? 4 : mediaCount,
                                    itemBuilder: (context, index) {
                                      final media = mediaList[index];
                                      final isLast = index == 3 && mediaCount > 4;

                                      return InkWell(
                                        onTap: (){
                                          Get.to(() => AllMediaView());
                                        },
                                        child: _MediaItem(
                                          mediaPath: media.path,
                                          isOverlay: isLast,
                                          overlayText: "+${mediaCount - 4}",
                                        ),
                                      );
                                    },
                                  );
                                }

                                /// 📜 LIST (1–4 items)
                                return Column(
                                  children: mediaList.map((media) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: SizedBox(
                                        height: 220.h,
                                        width: double.infinity,
                                        child: _MediaItem(
                                          mediaPath: media.path,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),

                            const SizedBox(height: 12),

                            /// Link Preview
                            if (link != null) LinkPreview(url: link),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            if(controller.isLoading.value)LoadingScreen()
          ],
        )),
      ),
    );
  }

  Widget _bottomNavBar() {
    final controller = Get.find<CreatePostController>();

    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.contentPadding.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BottomAction(
                  icon: Icons.image,
                  label: "Gallery",
                  onTap: controller.pickMedia,
                ),
                /*const SizedBox(width: 12),
                const _BottomAction(icon: Icons.gif_box, label: "GIF"),
                const SizedBox(width: 12),
                const _BottomAction(
                    icon: Icons.star_border, label: "Life event"),
             */ ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.contentPadding.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Chip(
                  icon: Icons.people_outlined,
                  label: "Friends",
                  onTap: () {},
                ),
                AppButton(
                  onTap: controller.hasContent ? controller.submitPost : null,
                  text: "Post",
                  fontSize: AppDimensions.bodyTextSize,
                  verticalPadding: AppDimensions.contentPadding / 2.w,
                  horizontalPadding: AppDimensions.sectionPadding.w,
                  bgColor: controller.hasContent
                      ? AppColors.primaryColor
                      : AppColors.inactiveColor,
                  borderColor: controller.hasContent
                      ? AppColors.primaryColor
                      : AppColors.inactiveColor,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void openTextEditor() {
    Get.bottomSheet(
      AddTextSheet(
        controller: controller.textController,
        onDone: () {
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _Chip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.contentPadding.w,
          vertical: AppDimensions.contentPadding / 2.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _BottomAction({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class PostOption {
  final IconData icon;
  final String label;

  PostOption(this.icon, this.label);
}


class _MediaItem extends StatelessWidget {
  final String mediaPath;
  final bool isOverlay;
  final String? overlayText;

  const _MediaItem({
    required this.mediaPath,
    this.isOverlay = false,
    this.overlayText,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreatePostController>();
    final isVideo = mediaPath.endsWith('.mp4');

    return AspectRatio( // 🔥 FIX
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Media
            isVideo
                ? Obx(() {
              final thumb =
              controller.videoThumbnails[mediaPath];
              if (thumb == null) {
                controller.generateThumbnail(mediaPath);
                return Container(color: Colors.grey.shade300);
              }
              return Image.file(
                File(thumb),
                fit: BoxFit.cover,
              );
            })
                : Image.file(
              File(mediaPath),
              fit: BoxFit.cover,
            ),

            /// ▶ Play icon
            if (isVideo)
              const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 36,
                ),
              ),

            /// ❌ Remove
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () => controller.removeMedia(mediaPath),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close,
                      size: 16, color: Colors.white),
                ),
              ),
            ),

            /// ➕ Overlay
            if (isOverlay)
              Container(
                color: Colors.black.withAlpha(140),
                child: Center(
                  child: Text(
                    overlayText ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}