import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

import '../../controllers/comment_controller.dart';
import 'comments_view.dart';

class CommentsBottomSheet extends GetView<CommentsController> {
  const CommentsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CommentsController());

    final dragController = DraggableScrollableController();

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: .97,
        maxChildSize: .97,
        minChildSize: 0.7,
        controller: dragController,
        builder: (_, scrollController) {

          dragController.addListener(() {
            if (dragController.size <= 0.7) {
              Get.back(result: controller.comments);
            }
          });

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.borderRadius.r),
              ),
            ),
            child: CommentsView(scrollController: scrollController),
          );
        },
      ),
    );
  }
}
