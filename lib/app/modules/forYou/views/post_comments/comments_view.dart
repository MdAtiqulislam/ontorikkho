import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/comment_controller.dart';
import 'comment_input.dart';
import 'comment_item.dart';

class CommentsView extends GetView<CommentsController> {
  final ScrollController scrollController;

  CommentsView({super.key, required this.scrollController});

  final inputCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.sp),

        /// Title + Close Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
          child: Row(
            children: [
              /// Cross Button Left
              GestureDetector(
                onTap: () => Get.back(result: controller.comments),
                child: Icon(Icons.close, size: 24.sp),
              ),
              /// Title
              Expanded(
                child: Text(
                  "Comments",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(width:  24.sp),
              ),
            ],
          ),
        ),

        Divider(),

        /// Comment List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.comments.isEmpty) {
              return const Center(child: Text("No comments yet"));
            }

            return ListView.builder(
              controller: scrollController,
              itemCount: controller.comments.length,
              itemBuilder: (_, i) {
                return CommentItem(comment: controller.comments[i]);
              },
            );
          }),
        ),

        /// Add Comment Input
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
          child: CommentInput(
            controller: inputCtrl,
            avatar: controller.userData.value.profileImage ?? "",
            onSend: () {
              if (inputCtrl.text.isNotEmpty) {
                controller.addComment(inputCtrl.text);
                inputCtrl.clear();
              }
            },
          ),
        ),
      ],
    );

  }
}

