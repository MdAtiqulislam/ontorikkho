import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class AddTextSheet extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onDone;

  const AddTextSheet({
    super.key,
    required this.controller,
    this.onDone,
  });

  @override
  State<AddTextSheet> createState() => _AddTextSheetState();
}

class _AddTextSheetState extends State<AddTextSheet> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    /// auto focus + cursor last position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 0.95.sh, // ✅ 80% screen height (correct)
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            /// ───────── Top Bar ─────────
            Row(
              children: [
                /// Close
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: Get.back,
                ),

                /// Title
                Expanded(
                  child: Center(
                    child: Text(
                      "Add text",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),

                /// Done
                TextButton(
                  onPressed: () {
                    widget.onDone?.call();
                    Get.back();
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(),

            /// ───────── Text Field Area ─────────
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadius.r),
                  border: Border.all(
                    width: 1,
                    color: AppColors.borderGrey,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}