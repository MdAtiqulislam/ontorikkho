/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../utils/download_documents.dart';
import '../controllers/image_viewer_controller.dart';

class ImageViewerView extends StatefulWidget {
  const ImageViewerView({super.key});

  @override
  State<ImageViewerView> createState() => _ImageViewerViewState();
}

class _ImageViewerViewState extends State<ImageViewerView> {
  late PageController _pageController;
  late ImageViewerController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<ImageViewerController>();
    _pageController = PageController(initialPage: controller.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: controller.imageList.isNotEmpty?controller.imageList.length:controller.imageUrlList.length,
            pageController: _pageController,
            onPageChanged: (index) {
              controller.currentIndex.value = index;
            },
            builder: (context, index) {

              String item=controller.imageList.isNotEmpty?controller.imageList[index].photo??"":controller.imageUrlList[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(item??""),//AssetImage(controller.imageList[index].photo??""),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                heroAttributes: PhotoViewHeroAttributes(tag: item.toString()),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          // Close button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Get.back(),
            ),
          ),

          // Download button
          Positioned(
            bottom: 30,
            right: 20,
            child: Obx(() {
              final currentImage = controller.imageList[controller.currentIndex.value];
              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () async {
                  // Assets download simulation
                  await downloadFile(fileUrl: currentImage.photo??"");
                },
                icon: const Icon(Icons.download),
                label: const Text("Download"),
              );
            }),
          ),
        ],
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../utils/download_documents.dart';
import '../controllers/image_viewer_controller.dart';

class ImageViewerView extends StatefulWidget {
  const ImageViewerView({super.key});

  @override
  State<ImageViewerView> createState() => _ImageViewerViewState();
}

class _ImageViewerViewState extends State<ImageViewerView> {
  late PageController _pageController;
  late ImageViewerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ImageViewerController>();
    _pageController = PageController(initialPage: controller.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: controller.imageList.isNotEmpty
                  ? controller.imageList.length
                  : controller.imageUrlList.length,
              pageController: _pageController,
              onPageChanged: (index) {
                controller.currentIndex.value = index;
              },
              builder: (context, index) {
                String imageUrl = controller.imageList.isNotEmpty
                    ? controller.imageList[index].photo ?? ""
                    : controller.imageUrlList[index];
      
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
      
            /// Close button
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
      
            /// Download button
            Positioned(
              bottom: 30,
              right: 20,
              child: Obx(() {
                final imageUrl = controller.currentImageUrl;
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () async {
                    if (imageUrl.isNotEmpty) {
                      await downloadFile(fileUrl: imageUrl);
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text("Download"),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}