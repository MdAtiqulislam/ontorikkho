import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/profileFeed/controllers/profile_feed_controller.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';
import '../../../../constraints/dimensions.dart';
import '../../forYou/models/posts_model.dart';
import '../../forYou/views/post_view/post_video_content.dart';

class VideoTabView extends GetView<ProfileFeedController> {
  
  final List<Media> videos;
  final RxBool isLoading;
  final RxBool? isLoadingMore;
  const VideoTabView({
    required this.videos,
    required this.isLoading,
    this.isLoadingMore,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (videos.isEmpty) {
        return const Center(
          child: EmptyScreen(
            message: "No videos found!",
            icon: Icons.video_library_outlined,
          ),
        );
      }

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return PostVideoContent(
                    url: videos[index].url ?? "",
                  );
                },
                childCount: videos.length,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),

          /// Loading Indicator
          if (isLoadingMore?.value ?? false)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      );
    });
  }
}