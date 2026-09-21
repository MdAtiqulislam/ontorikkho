import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constraints/app_colors.dart';

class FileCircleAvatar extends StatelessWidget {
  final File? imageFile;
  final double width;
  final double height;
  final double? radius;
  final double? border;
  final BoxFit? fit;
  final Color? bgColor;
  final bool showEditIcon;
  final VoidCallback? onEditTap;
  final Widget? editIcon;
  final Color? editButtonBg;

  const FileCircleAvatar({
    super.key,
    this.imageFile,
    required this.width,
    required this.height,
    this.radius,
    this.border,
    this.fit,
    this.bgColor,
    this.showEditIcon = false,
    this.onEditTap,
    this.editIcon,
    this.editButtonBg,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = radius == null
        ? const BoxDecoration(shape: BoxShape.circle)
        : BoxDecoration(borderRadius: BorderRadius.circular(radius!));

    final imageWidget = imageFile != null
        ? Image.file(
      imageFile!,
      fit: fit ?? BoxFit.cover,
    )
        : const Icon(Icons.person, size: 40, color: AppColors.mutedText); // fallback

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(border ?? 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? AppColors.borderLight,
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: height,
            width: width,
            decoration: decoration.copyWith(
              color: bgColor ?? AppColors.mutedText,
            ),
            child: imageWidget,
          ),
        ),
        if (showEditIcon)
          Positioned(
            bottom: 10,
            right: 0,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onEditTap,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: editButtonBg ?? Colors.white.withOpacity(0.8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: editIcon ??
                      const Icon(Icons.edit,
                          size: 18, color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
