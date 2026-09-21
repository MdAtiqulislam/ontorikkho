/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_media_preview.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class MultiMediaPreview extends StatelessWidget {
  final List<Media> media;
  final bool isList;
  final double? borderRadius;
  final VoidCallback? onRemove;

  const MultiMediaPreview({
    super.key,
    required this.media,
    this.isList = false,
    this.borderRadius,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();

    /// 🔹 LIST VIEW
    if (isList) {
      return Column(
        children: List.generate(
          media.length,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius??AppDimensions.borderRadius.r),
              child: MediaPreview(media: media[index],),
            ),
          ),
        ),
      );
    }

    /// 🔹 SINGLE ITEM
    if (media.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius??AppDimensions.borderRadius.r),
        child: MediaPreview(media: media.first,onRemove: onRemove,),
      );
    }

    /// 🔹 GRID VIEW (max 4)
    final showList = media.take(4).toList();
    final extraCount = media.length - 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: showList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius??AppDimensions.borderRadius.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              MediaPreview(media: showList[index],onRemove: onRemove,),

              /// +N overlay
              if (index == 3 && extraCount > 0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(borderRadius??AppDimensions.borderRadius.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+$extraCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'post_media_preview.dart';

class MultiMediaPreview extends StatelessWidget {
  final List<Media> media;
  final bool isList;
  final double? borderRadius;
  final void Function(Media media)? onRemove; // <-- index pass korar jonno
  final VoidCallback? onViewAll; // <-- index pass korar jonno

  const MultiMediaPreview({
    super.key,
    required this.media,
    this.isList = false,
    this.borderRadius,
    this.onRemove,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();

    final radius = borderRadius ?? AppDimensions.borderRadius.r;

    /// 🔹 LIST VIEW
    if (isList) {
      return Column(
        children: List.generate(
          media.length,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: MediaPreview(
                media: media[index],
                onRemove: onRemove != null ? () => onRemove!(media[index]) : null,
              ),
            ),
          ),
        ),
      );
    }

    /// 🔹 SINGLE ITEM
    if (media.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: MediaPreview(
          media: media.first,
          onRemove: onRemove != null ? () => onRemove!(media[0]) : null,
        ),
      );
    }

    /// 🔹 GRID VIEW (max 4)
    final showList = media.take(4).toList();
    final extraCount = media.length - 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: showList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              MediaPreview(
                media: showList[index],
                onRemove: onRemove != null ? () => onRemove!(media[index]) : null,
              ),

              /// +N overlay
              if (index == 3 && extraCount > 0)
                GestureDetector(
                  onTap: (){
                    onViewAll?.call();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$extraCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
