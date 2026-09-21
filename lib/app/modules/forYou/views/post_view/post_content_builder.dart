import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_media_preview.dart';
import 'package:ontorikkho/app/modules/forYou/views/post_view/post_text_content.dart';
import 'package:ontorikkho/common_widgets/link_preview.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../../utils/util.dart';
import '../../controllers/for_you_controller.dart';
import 'multi_media_preview.dart';

class PostContentBuilder extends StatelessWidget {
  final Rx<SinglePostModel> post;
  final dynamic controller;

  const PostContentBuilder({
    super.key,
    required this.post,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    final link = post.value.youtubeLink??extractFirstLink(post.value.content??"");
    return Obx(()=>
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// ✅ TEXT FIRST
      //  if (post.value.content != null && post.value.content!.isNotEmpty)
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w,vertical: AppDimensions.contentPadding.h),
            child: PostTextContent(text: post.value.content??"Content"),
          ),

        const SizedBox(height: 8),

        /// ✅ MEDIA PREVIEW

        MultiMediaPreview(
          media: post.value.media??[],
        ),
        if((link??"").isNotEmpty)Padding(
          padding:  EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
          child: LinkPreview(url: link??""),
        )

      ],
    ));
  }
}
