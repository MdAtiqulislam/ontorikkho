import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/multi_media_preview.dart';
import 'package:ontorikkho/utils/enums.dart';
import '../../../../common_widgets/custom_circle_avatar.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/link_preview.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../utils/util.dart';
import '../../createPost/views/add_text_sheet.dart';
import '../controllers/edit_post_controller.dart';

class EditPostView extends GetView<EditPostController> {
  EditPostView({super.key});

  final List<PostOption> postOptions = [
    PostOption(Icons.location_on, "Location"),
    PostOption(Icons.emoji_emotions, "Feeling/activity"),
    PostOption(Icons.photo_album, "Album"),
    PostOption(Icons.person_add, "Tag people"),
    PostOption(Icons.flag, "Event"),
  ];

  @override
  Widget build(BuildContext context) {
    print(controller.postProfileType);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _bottomNavBar(),
        body: Obx(() =>
            Stack(
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
                              "Update post",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz, color: Colors
                                .transparent),
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
                            width: 30.sp, height: 30.sp, border: 3,
                            image:controller.postProfileType==PostProfileType.profilePost
                                ? controller.post.value.user?.avatar ?? ""
                                :controller.pageDetails.value.profileImage??"",
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.postProfileType==PostProfileType.profilePost
                                ? controller.post.value.user?.name ?? ""
                                :controller.pageDetails.value.name??"",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    /// Chips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: postOptions.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final option = postOptions[index];
                            return _Chip(
                                icon: option.icon, label: option.label);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: openTextEditor,
                          child: Obx(() {
                            var text = controller.text.value;
                            final link = extractFirstLink(text) ??
                                controller.post.value.youtubeLink;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// Text
                                Text(
                                  text.isEmpty ? "What's on your mind?" : text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: text.isEmpty ? Colors.grey : Colors
                                        .black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Obx(() =>
                                    MultiMediaPreview(
                                      media: controller.totalMedia.value,
                                      isList: true,
                                      onRemove: (media) {
                                        controller.removeMedia(media);
                                      },),),
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
    final controller = Get.find<EditPostController>();

    return Obx((){
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
                const SizedBox(width: 12),
                const _BottomAction(icon: Icons.gif_box, label: "GIF"),
                const SizedBox(width: 12),
                const _BottomAction(
                    icon: Icons.star_border, label: "Life event"),
              ],
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
                  onTap: controller.hasContent.value ? controller.updatePost : null,
                  text: "Update",
                  fontSize: AppDimensions.bodyTextSize,
                  verticalPadding: AppDimensions.contentPadding / 2.w,
                  horizontalPadding: AppDimensions.sectionPadding.w,
                  bgColor: controller.hasContent.value
                      ? AppColors.primaryColor
                      : AppColors.inactiveColor,
                  borderColor: controller.hasContent.value
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
        onDone: () {},
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


