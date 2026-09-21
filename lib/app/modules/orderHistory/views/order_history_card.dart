import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ontorikkho/common_widgets/status_badge.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import '../../../../constraints/app_colors.dart';
import '../../store/models/order_history_model.dart';

class OrderHistoryCard extends StatelessWidget {
  final SingleOrderHistory order;
  final VoidCallback onTap;

  const OrderHistoryCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt != null
        ? DateFormat("dd MMM yyyy, hh:mm a").format(order.createdAt!)
        : "";

    return InkWell(
      onTap: onTap,
      child: Container(
        margin:  EdgeInsets.symmetric( vertical: AppDimensions.contentPadding/2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withAlpha(20),
              blurRadius: 5,
              spreadRadius: 0
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left: Order ID + Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #${order.id}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              /// Right: Total + Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "৳${order.total ?? '0'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// Status Chip
                  StatusBadge(status: order.orderStatus??""),
                ],
              ),
            ],
          ),
        ),
      )



    );
  }

}
