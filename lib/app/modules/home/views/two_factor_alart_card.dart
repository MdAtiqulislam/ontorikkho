import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TwoFAAlertCard extends StatelessWidget {
  final VoidCallback? onEnableTap;

  const TwoFAAlertCard({super.key, this.onEnableTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: Colors.orange, size: 28.sp),
          SizedBox(width: 12.w),

          Expanded(
            child: Text(
              "Two-Factor Authentication is disabled.",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          SizedBox(width: 10.w),

          TextButton(
            onPressed: onEnableTap,
            child: Text(
              "Enable?",
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

