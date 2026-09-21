import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';

import '../../../../constraints/dimensions.dart';
import '../../../../utils/download_documents.dart';
import '../../../routes/app_pages.dart';
import '../../forYou/models/posts_model.dart';
import '../../imageViewer/controllers/image_viewer_controller.dart';
import '../controllers/profile_feed_controller.dart';

class ImageTabView extends StatelessWidget {
  final List<Media> imageList;
  final RxBool isLoading;
  final RxBool? isLoadingMore;

  const ImageTabView({
    required this.imageList,
    required this.isLoading,
    this.isLoadingMore,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (imageList.isEmpty) {
        return const Center(
          child: EmptyScreen(
            message: "No images found!",
            icon: Icons.image_search_sharp,
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
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = imageList[index];
                  final imageUrl = item.url ?? "";

                  return InkWell(
                    onTap: () {
                      final imageViewerController =
                      Get.put(ImageViewerController());

                      imageViewerController.imageUrlList =
                          imageList.map((e) => e.url ?? "").toList();

                      imageViewerController.initialIndex = index;

                      Get.toNamed(Routes.IMAGE_VIEWER);
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadius.r,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomNetworkImage(image: imageUrl),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () async {
                                await downloadFile(fileUrl: imageUrl);
                              },
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: imageList.length,
              ),
            ),
          ),

          /// Loading indicator for pagination
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
