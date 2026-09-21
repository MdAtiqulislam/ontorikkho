/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../../constraints/app_strings.dart';
import 'app_bar_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? minimal;
  final VoidCallback? openDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackButton;
  final bool showNotificationButton;
  final bool showTitleOnly;
  final String? title;

  CustomAppBar({
    this.scaffoldKey,
    this.openDrawer,
    this.minimal,
    this.showBackButton = false,
    this.showNotificationButton = true,
    this.showTitleOnly = false,
    super.key,
    this.title
  });

  final appBarController = Get.put(AppBarController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(21.r),
          bottomRight: Radius.circular(21.r),
        ),
      ),
      child: Stack(
        children: [
          // Black background
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(21.r),
                bottomRight: Radius.circular(21.r),
              ),
            ),
          ),

          // FIRST White Box
          Positioned(
            top: -50.h,
            left: 100.w,
            child: Transform.rotate(
              angle: 0.8, // around -23 degrees
              child: Container(
                width: 40.w,
                height: 200.h,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          // SECOND White Box
          Positioned(
            top: -50.h,
            right: 100.w,
            child: Transform.rotate(
              angle: 0.8, // around -23 degrees
              child: Container(
                  width: 40.w,
                  height: 200.h,
                  color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          // AppBar Content
          Padding(
            padding: EdgeInsets.only(left: AppDimensions.horizontalPadding.w,right: AppDimensions.horizontalPadding.w, top: 30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side Icon (Menu or Back Button)
               if(!showTitleOnly) showBackButton
                    ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                )
                    : IconButton(
                  icon: Image.asset(AppImagePath.userIcon,height: 24.spMin,),
                  onPressed: (){
                    Get.toNamed(Routes.OWN_PROFILE);
                  }*/
/*openDrawer ?? () {
                    scaffoldKey?.currentState?.openDrawer();
                  },*//*

                ),

                // Center Logo
                Expanded(
                  child: Center(
                    child: title==null?Image.asset(
                      AppImagePath.appLogo, // Your logo path
                      height: 30.h,
                      fit: BoxFit.contain,
                    ):HeaderText(text: title??"",color: Colors.white,size: 16,)
                    ,
                  ),
                ),

                // Right Side Notification Icon
                if(showNotificationButton && !showTitleOnly)
                  IconButton(
                  icon:  Icon(Icons.notifications_none_rounded, color: Colors.white,size: 24.spMin,),
                  onPressed: () {
                   if (Get.currentRoute!=Routes.NOTIFICATIONS) {
                     Get.toNamed(Routes.NOTIFICATIONS);
                   }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, 100.h);
}
*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/notification_badge_widget.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../../../constraints/app_strings.dart';
import 'app_bar_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? minimal;
  final VoidCallback? openDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackButton;
  final bool showNotificationButton;
  final bool showTitleOnly;
  final String? title;
  final List<Widget>? actions; // ✅ Added actions support

  CustomAppBar({
    this.scaffoldKey,
    this.openDrawer,
    this.minimal,
    this.showBackButton = false,
    this.showNotificationButton = true,
    this.showTitleOnly = false,
    this.title,
    this.actions,
    super.key,
  });

  final appBarController = Get.put(AppBarController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(21.r),
          bottomRight: Radius.circular(21.r),
        ),
      ),
      child: Stack(
        children: [
          /// 🔹 Black Background
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(21.r),
                bottomRight: Radius.circular(21.r),
              ),
            ),
          ),

          /// 🔹 First White Decorative Box
          Positioned(
            top: -50.h,
            left: 100.w,
            child: Transform.rotate(
              angle: 0.8,
              child: Container(
                width: 40.w,
                height: 200.h,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          /// 🔹 Second White Decorative Box
          Positioned(
            top: -50.h,
            right: 100.w,
            child: Transform.rotate(
              angle: 0.8,
              child: Container(
                width: 40.w,
                height: 200.h,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          /// 🔹 AppBar Content
          Padding(
            padding: EdgeInsets.only(
              left: AppDimensions.horizontalPadding.w,
              right: AppDimensions.horizontalPadding.w,
              top: 30.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// 🔹 LEFT SIDE (Back or Profile)
                if (!showTitleOnly)
                  showBackButton
                      ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  )
                      : IconButton(
                    icon: Image.asset(
                      AppImagePath.userIcon,
                      height: 24.spMin,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.OWN_PROFILE);
                    },
                  )
                else
                  SizedBox(width: 40.w),

                /// 🔹 CENTER (Logo or Title)
                Expanded(
                  child: Center(
                    child: title == null
                        ? Image.asset(
                      AppImagePath.appLogo,
                      height: 30.h,
                      fit: BoxFit.contain,
                    )
                        : HeaderText(
                      text: title ?? "",
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                /// 🔹 RIGHT SIDE (Actions OR Notification)
                if (!showTitleOnly)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions != null && actions!.isNotEmpty
                        ? actions! // ✅ If custom actions exist
                        : (showNotificationButton
                        ? [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [

                          /// 🔔 Notification Icon (Main Click Area)
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.white,
                              size: 24.spMin,
                            ),
                            onPressed: () {
                              appBarController.handleNotificationClick();
                            },
                          ),

                          /// 🔴 Badge (IgnorePointer so it doesn't block tap)
                          NotificationBadge()
                        ],
                      )
                    ]
                        : []),
                  )
                else
                  SizedBox(width: 40.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}