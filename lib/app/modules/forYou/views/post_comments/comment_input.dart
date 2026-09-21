import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';

class CommentInput extends StatelessWidget {
  final String avatar;
  final TextEditingController controller;
  final VoidCallback onSend;

  const CommentInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CustomCircleAvatar(height: 30.sp, width: 30.sp,image: avatar,),

            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.send), onPressed: onSend),
          ],
        ),
      ),
    );
  }
}

class ReplyInputField extends StatelessWidget {
  final String avatar;
  final TextEditingController controller;
  final VoidCallback onSend;

  const ReplyInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 48, right: 12, top: 4, bottom: 8),
      child: Row(
        children: [
           CustomCircleAvatar(
            height: 30.sp,
            width: 30.sp,
            image:avatar,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Write a reply...",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send, size: 18), onPressed: onSend),
        ],
      ),
    );
  }
}
