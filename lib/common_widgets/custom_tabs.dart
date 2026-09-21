import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/constraints/dimensions.dart';

class CustomTabs extends StatelessWidget {
  final int selectedTab;
  final String tab_1;
  final String tab_2;
  final Function(int) onTabChange;

  const CustomTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChange,
    required this.tab_1,
    required this.tab_2
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: selectedTab == 0 ? Colors.white : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.borderRadius.r),
                bottomLeft: Radius.circular(AppDimensions.borderRadius.r),
              ),
              child: InkWell(
                onTap: () => onTabChange(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  alignment: Alignment.center,
                  child: Text(
                    tab_1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedTab == 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: selectedTab == 1 ? Colors.white : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppDimensions.borderRadius.r),
                bottomRight: Radius.circular(AppDimensions.borderRadius.r),
              ),
              child: InkWell(
                onTap: () => onTabChange(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  alignment: Alignment.center,
                  child: Text(
                   tab_2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedTab == 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
