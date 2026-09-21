import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constraints/app_colors.dart';
import 'custom_network_image.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double width;
  final double height;
  final String? image;
  final String? svgNetworkImage;
  final String? localImage;
  final String? memoryImage;
  final double? radius;
  final double? border;
  final BoxFit? fit;
  final Color? bgColor;
  final bool showEditIcon;
  final VoidCallback? onEditTap;
  final Widget? editIcon;
  final Color? editButtonBg;

  const CustomCircleAvatar({
    super.key,
    required this.width,
    required this.height,
    this.image,
    this.svgNetworkImage,
    this.localImage,
    this.memoryImage,
    this.radius,
    this.border,
    this.fit,
    this.bgColor,
    this.showEditIcon = false,
    this.onEditTap,
    this.editIcon,
    this.editButtonBg
  });

  @override
  Widget build(BuildContext context) {
    final decoration = radius == null
        ? BoxDecoration(
      shape: BoxShape.circle,
      color: bgColor ?? AppColors.mutedText,
    )
        : BoxDecoration(
      borderRadius: BorderRadius.circular(radius!),
      color: bgColor ?? AppColors.mutedText,
    );

    final imageWidget = memoryImage != null
        ? Image.memory(
      base64Decode(memoryImage!),
      fit: fit ?? BoxFit.cover,
    )
        : svgNetworkImage != null
        ? SvgPicture.network(svgNetworkImage!, fit: fit ?? BoxFit.cover)
        : CustomNetworkImage(
      image: image ?? '',
      localImage: localImage,
      fit: fit,
    );

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
            decoration: decoration,
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
                    color: editButtonBg??Colors.white.withOpacity(0.8),
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
