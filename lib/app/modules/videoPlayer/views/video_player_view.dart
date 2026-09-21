
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/videoPlayer/views/universal_video_player.dart';

import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../theme/widget_theme/custom_text_theme.dart';
import '../controllers/video_player_controller.dart';

class VideoPlayerView extends GetView<VideoPlayerController> {
  const VideoPlayerView({super.key});
  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return SafeArea(

      child: Scaffold(
        appBar: isLandscape ? null : AppBar(title: const Text("Video Player"), centerTitle: true),
        body: Obx(() {
          if (controller.isLoading.value) return const LoadingScreen();

          if (isLandscape) {
            return Center(
              child: UniversalVideoPlayer.fromLink(controller.videoURL.value, autoPlay: true),
            );
          }

          return Column(
            children: [
              SizedBox(
                height: 220.h,
                width: double.infinity,
                child: UniversalVideoPlayer.fromLink(controller.videoURL.value),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildDetailsHeader()),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  Widget _buildDetailsHeader() {
    
    return Column(
      children: [
      Text( "",style: AppTextStyles.header(),),
        SizedBox(height: AppDimensions.widgetPadding.h,),
       // Text(video.description??"",style: AppTextStyles.body(),)
      ],
    );
  }
}
