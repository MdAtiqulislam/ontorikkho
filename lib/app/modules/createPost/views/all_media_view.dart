import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/create_post_controller.dart';

class AllMediaView extends StatelessWidget {
  AllMediaView({super.key});

  final controller = Get.find<CreatePostController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media"),
        actions: [
          /// 🗑️ Remove all
          TextButton(
            onPressed: () {
              controller.selectedMedia.clear();
              controller.videoThumbnails.clear();
              Get.back();
            },
            child: const Text(
              "Remove all",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final mediaList = controller.selectedMedia;

        if (mediaList.isEmpty) {
          return const Center(child: Text("No media selected"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(12.w),
          itemCount: mediaList.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final media = mediaList[index];
            final isVideo = media.path.endsWith('.mp4');

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isVideo
                      ? _VideoPreview(media.path)
                      : Image.file(
                    File(media.path),
                    height: 220.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// ❌ Remove single
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () =>
                        controller.removeMedia(media.path),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(160),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),

      /// ➕ Add more
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: ElevatedButton.icon(
            onPressed: () {
              controller.pickMedia();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add more media"),
          ),
        ),
      ),
    );
  }
}

class _VideoPreview extends StatelessWidget {
  final String path;
  _VideoPreview(this.path);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreatePostController>();

    return Obx(() {
      final thumb = controller.videoThumbnails[path];

      if (thumb == null) {
        controller.generateThumbnail(path);
        return Container(
          height: 220,
          color: Colors.grey.shade300,
        );
      }

      return Stack(
        children: [
          Image.file(
            File(thumb),
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Positioned.fill(
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
        ],
      );
    });
  }
}