import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/events/models/event_list_model.dart';
import 'package:ontorikkho/app/modules/events/controllers/events_controller.dart';
import 'package:ontorikkho/common_widgets/app_button.dart';
import 'package:ontorikkho/constraints/app_colors.dart';

class EventListItem extends StatelessWidget {
  final SingleEvent event;
  final bool showJoinButton;
  final double imageSize;

  const EventListItem({
    super.key,
    required this.event,
    this.showJoinButton = false,
    this.imageSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventsController>();
    return Obx(() {
      final isFav = controller.favouriteEvents.any((e) => e.id == event.id);

      return GestureDetector(
        onTap: () => controller.getDetails(event: event),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6.h),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  event.image ?? "",
                  width: imageSize.w,
                  height: imageSize.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.event, size: imageSize.w, color: Colors.grey),
                ),
              ),
              SizedBox(width: 10.w),

              // Title & Date & Time Difference
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title ?? "",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    if ((event.startDate ?? "").isNotEmpty)
                      Text(
                        event.startDate ?? "",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    if ((event.timeDifference ?? "").isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          event.timeDifference ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Favourite Icon + Join Button
              Column(
                children: [
                  GestureDetector(
                    onTap: () => controller.addOrUpdateFavouriteEvent(event: event),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                      size: 22.sp,
                    ),
                  ),
                  if (showJoinButton)
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: AppButton(
                        text: "Join",
                        onTap: () => controller.joinEvent(event),
                        verticalPadding: 4.h,
                        horizontalPadding: 8.w,
                        fontSize: 10,
                        bgColor: AppColors.primaryColor,
                        textTransform: TextTransform.none,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
