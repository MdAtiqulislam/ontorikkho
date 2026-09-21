
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../app/data/my_drawer_controller.dart';
import '../constraints/app_colors.dart';
import '../constraints/body_text.dart';
import '../constraints/dimensions.dart';
import '../constraints/header_text.dart';
import 'app_list_tile_button.dart';
import 'custom_circle_avatar.dart';
import 'custom_loading_screen.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final MyDrawerController controller = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => SafeArea(
        child: Drawer(
          backgroundColor: Colors.white,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? Get.width * .8
              : Get.width * .5,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    CustomCircleAvatar(
                      width: 100,
                      height: 100,
                      image: "",
                      bgColor: AppColors.mutedText,
                      fit: BoxFit.cover,
                      border: 5,
                    ),
                    SizedBox(height: AppDimensions.contentPadding.h),
                    HeaderText(
                      text:"User Name",
                      align: TextAlign.start,
                      maxLine: 3,
                    ),
                    BodyText(text:"user@email.com"),
                    BodyText(text: "+8801XXXXXXXXX"),
                    BodyText(text:  "Occupation"),
                    SizedBox(height: AppDimensions.widgetPadding.h),
                    const Divider(),
                    AppListTileButton(
                        onTap: (){controller.logOut();},
                        icon: Icon(Icons.logout,color: Colors.red,),
                        text: "Logout"
                    )

                    // ...Drawer menu items here
                  ],
                ),
              ),
              if (controller.isLoading.value)
                const Positioned.fill(
                  child: LoadingScreen(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
