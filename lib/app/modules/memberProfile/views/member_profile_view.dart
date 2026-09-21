import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/common_widgets/custom_list_tile.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/utils/util.dart';

import '../../../../constraints/app_colors.dart';
import '../controllers/profile_controller.dart';
import 'bio_card.dart';
import 'contact_info_card.dart';

class MemberProfileView extends GetView<ProfileController> {
  const MemberProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar:CustomAppBar(showBackButton: true,title: "Member Profile",),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
          child: Column(
            children: [
              SizedBox(height: AppDimensions.widgetPadding.h,),
              BioCard(),
              SizedBox(height: AppDimensions.widgetPadding.h,),
              ContactInfoCard(),
              SizedBox(height: AppDimensions.widgetPadding.h,),
              SectionHeader(title: "Activity History",showMoreButton: false,),
              SizedBox(height: AppDimensions.widgetPadding.h,),
              CustomListTile(title: "Child Education",localAvatar: "assets/images/moc_image_3.png",),
              CustomListTile(title: "Strong Support Network",localAvatar: "assets/images/moc_image_4.png",),
              CustomListTile(title: "Strong Support Network",localAvatar: "assets/images/moc_image_3.png",),
            ],
          ),
        ),
      ),
    );
  }
}
