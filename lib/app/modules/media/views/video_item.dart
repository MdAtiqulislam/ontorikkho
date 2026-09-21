import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../utils/util.dart';

class VideoItem extends StatelessWidget {
  final String? thumb;
  final String youtubeLink;

  const VideoItem({
    required this.thumb,
    required this.youtubeLink,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = thumb ??getYoutubeThumbnail(youtubeLink)!;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomNetworkImage(
            image: imageUrl,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Center(
            child: CustomNetworkImage(
              image: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: Icon(
              Icons.play_circle_fill,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

  }
}
