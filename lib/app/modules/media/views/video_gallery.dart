
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/media/controllers/media_controller.dart';
import 'package:ontorikkho/app/modules/media/views/video_item.dart';

import '../../../routes/app_pages.dart';
import '../../videoPlayer/controllers/video_player_controller.dart';

class VideoGallery extends GetView<MediaController> {
  const VideoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: controller.videoList.length,
            (context, index) {
              final video = controller.videoList[index];
              return GestureDetector(
                onTap: () {
                  Get.put(VideoPlayerController()).video.value=controller.videoList[index];
                  Get.find<VideoPlayerController>().getVideoUrl();
                  Get.toNamed(Routes.VIDEO_PLAYER);
                },
                child: VideoItem(
                    thumb: video.thumbnail,
                    youtubeLink: video.youtubeLink??""),
              );
            },
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
        ),
      ],
    );
  }
}
