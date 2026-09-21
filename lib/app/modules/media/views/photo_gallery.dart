import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/imageViewer/controllers/image_viewer_controller.dart';
import 'package:ontorikkho/app/modules/media/controllers/media_controller.dart';
import 'package:ontorikkho/app/modules/media/views/image_grid_shimmer.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';

import '../../../../constraints/dimensions.dart';
import '../../../../utils/download_documents.dart';
import '../../../routes/app_pages.dart';

class PhotoGallery extends GetView<MediaController> {
  const PhotoGallery({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(()=>CustomScrollView(
      controller: controller.imageScrollController,
      slivers: [
        controller.isLoadingImages.value
            ? ImageGridShimmer()
            : imageSection(),
        if(controller.isLoadingMoreImages.value)SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(),)),
      ],
    ));
  }


  Widget imageSection() {
    return controller.images.isEmpty
        ?SliverToBoxAdapter(child: EmptyScreen(message: "No images found!",icon: Icons.image_search_sharp,),)
        :SliverGrid(
      delegate: SliverChildBuilderDelegate(
          childCount: controller.images.length, (buildContext,
          index,) {
        var image = controller.images[index];
        return InkWell(
          onTap: () {
            Get
                .put(ImageViewerController())
                .imageList = controller.images;
            Get
                .find<ImageViewerController>()
                .currentIndex
                .value = index;
            Get
                .find<ImageViewerController>()
                .initialIndex = index;
            Get.toNamed(Routes.IMAGE_VIEWER
              ,);
          },
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                    child: CustomNetworkImage(image: image.photo ?? "")
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 70,

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black12,
                            Colors.black54,
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      await downloadFile(fileUrl: image.photo ?? "");
                    },
                    icon: Icon(Icons.download, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5
      ),
    );
  }

}