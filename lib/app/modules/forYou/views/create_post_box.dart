import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';

class CreatePostBox extends StatelessWidget {

  final VoidCallback onCreatePostTap;
  final VoidCallback? onQuickPostTap;
  final VoidCallback? onProfileTap;

  final String userImageUrl;

  const CreatePostBox({
    super.key,
    required this.onCreatePostTap,
    required this.userImageUrl,
    this.onQuickPostTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [

          /// Profile avatar
          GestureDetector(
            onTap: onProfileTap,
            child: CustomCircleAvatar(
              width: 40.sp,
              height: 40.sp,
              border: 3,
              image: userImageUrl,
            ),
          ),

          SizedBox(width: 10.w),

          /// Create post field
          Expanded(
            child: InkWell(
              onTap: onCreatePostTap,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  "What's on your mind?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 10.w),

          /// Image quick post
          InkWell(
            onTap: onQuickPostTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(6.w),
              child: Icon(
                Icons.image,
                color: Colors.green,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}