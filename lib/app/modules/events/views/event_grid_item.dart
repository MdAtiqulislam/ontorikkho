import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/common_widgets/custom_card.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../constraints/body_text.dart';
import '../../../../constraints/header_text.dart';

import 'package:get/get.dart';


class EventGridItem extends StatelessWidget {
  final String eventName;
  final String date;
  final String duration;
  final String? image;
  final BoxFit fit;

  final RxBool? isFavourite;
  final VoidCallback? onTapFavourite;

  final VoidCallback onTapDetails;

  final bool showRemoveButton;
  final VoidCallback? onTapRemove;

  const EventGridItem({
    super.key,
    required this.eventName,
    required this.date,
    required this.duration,
    this.image,
    this.fit = BoxFit.cover,
    this.isFavourite,
    this.onTapFavourite,
    required this.onTapDetails,
    this.showRemoveButton = false,
    this.onTapRemove,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      blurRadius: 1,
      child: Material(
        child: InkWell(
          onTap: onTapDetails,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                flex: 6,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomNetworkImage(
                        image: image ?? "",
                        fit: fit,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: showRemoveButton
                          ? _buildRemoveButton()
                          : _buildFavouriteButtonOrEmpty(),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.contentPadding.w,
                  ),
                  child: _buildEventDetails(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavouriteButtonOrEmpty() {
    if (isFavourite == null || onTapFavourite == null) {
      return const SizedBox.shrink();
    }

    return Obx(() => Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black38,
      ),
      child: InkWell(

        onTap: onTapFavourite,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            isFavourite!.value ? Icons.favorite : Icons.favorite_border,
            color: isFavourite!.value ? Colors.red : Colors.white,
          ),
        ),
      ),
    ));
  }

/*  Widget _buildRemoveButton() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black38,
      ),
      child: IconButton(
        onPressed: onTapRemove,
        icon: const Icon(Icons.delete, color: Colors.red),
      ),
    );
  }*/

  Widget _buildRemoveButton() {
    return Material(
      color: Colors.grey.shade300,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTapRemove,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Icon(
            Icons.delete,
            size: 16.sp,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.contentPadding.h),
          HeaderText(
            text: eventName,
            size: 14,
            maxLine: 2,
            align: TextAlign.start,
            resizeAble: false,
          ),
          SizedBox(height: AppDimensions.contentPadding),
          BodyText(
            text: date,
            color: AppColors.primaryColor,
            size: 12,
            resizeAble: false,
          ),
          BodyText(
            text: duration,
            size: 10,
            resizeAble: false,
            align: TextAlign.end,
            color: AppColors.mutedText,
          ),
        ],
      ),
    );
  }
}




