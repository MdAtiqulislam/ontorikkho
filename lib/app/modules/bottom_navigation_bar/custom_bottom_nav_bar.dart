import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constraints/app_colors.dart';
import 'custom_bottom_nav_bar_controller.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({super.key});

  final CustomBottomNavigationController controller = Get.put(CustomBottomNavigationController());

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.calendar_month, 'label': 'Event'},
    {'icon': Icons.supervisor_account, 'label': 'Partner'},
    {'icon': Icons.perm_media_outlined, 'label': 'Gallery'},
    {'icon': Icons.storefront, 'label': 'Store'},
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Obx(
        () => controller.user.value.subscriptionStatus=="Approved"?Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor.withOpacity(.3),
                blurRadius: 5,
                offset: const Offset(0, -2)
              )
            ],
            border: Border(top: BorderSide(color: AppColors.shadowColor,width: .5.h))
          ),
          child: BottomNavigationBar(
            selectedItemColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.selectedIndex.value,
            unselectedFontSize: 10.sp,
            selectedFontSize: 12.sp,
            onTap: (index) {
              controller.changeIndex(index);
            },
            items: navItems.map((item) {
              return BottomNavigationBarItem(
                icon: Icon(item['icon']),
                label: item['label'],
              );
            }).toList(),
          ),
        ):SizedBox.shrink(),
      ),
    );
  }
}
