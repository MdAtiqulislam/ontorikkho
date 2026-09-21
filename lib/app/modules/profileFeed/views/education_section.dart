import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/profile_feed_model.dart';

class EducationSection extends StatelessWidget {
  final List<Education> educations;

  const EducationSection({
    super.key,
    required this.educations,
  });

  @override
  Widget build(BuildContext context) {
    if (educations.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Text(
          "No education details available",
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Education",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ...educations.map((edu) => _buildEducationRow(edu)).toList(),
        ],
      ),
    );
  }

  Widget _buildEducationRow(Education edu) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.school,
            size: 28.sp,
            color: Colors.blueAccent,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // College Name
                Text(
                  edu.collegeName?.toString() ?? "-",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Degree
                if (edu.degree != null && edu.degree!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      edu.degree!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                // Session
                if (edu.session != null)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      edu.session.toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}