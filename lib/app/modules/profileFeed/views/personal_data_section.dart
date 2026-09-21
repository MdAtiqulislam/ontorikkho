import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/profileFeed/models/profile_feed_model.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class PersonalDataSection extends StatelessWidget {
  final PersonalDataModel personalData;
  final bool isOwnProfile;

  const PersonalDataSection({
    super.key,
    required this.personalData, required this.isOwnProfile,
  });

  Widget infoRow(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox();

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.contentPadding.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[700]),
          SizedBox(width: AppDimensions.sectionPadding.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.widgetPadding.h),

          /// Title Row
          Row(
            children: [
              Expanded(
                child: Text(
                  "Personal Data",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            /* if(isOwnProfile) IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit, size: 20.sp),
              ),*/
            ],
          ),

          SizedBox(height: AppDimensions.widgetPadding.h),

          /// Info Rows
          infoRow(Icons.home_outlined, personalData.permanentAddress ?? ""),
          infoRow(Icons.location_on_outlined, personalData.currentAddress ?? ""),
          infoRow(Icons.cake_outlined, personalData.dateOfBirth ?? ""),
          infoRow(Icons.favorite_border, personalData.maritalStatus ?? ""),

          SizedBox(height: AppDimensions.widgetPadding.h),
        ],
      ),
    );
  }
}