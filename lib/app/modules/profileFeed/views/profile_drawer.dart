import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ontorikkho/app/modules/pageFeed/controllers/page_feed_controller.dart';
import 'package:ontorikkho/app/modules/pages/controllers/pages_controller.dart';
import 'package:ontorikkho/app/modules/pages/models/page_model.dart';
import 'package:ontorikkho/app/routes/app_pages.dart';
import 'package:ontorikkho/common_widgets/app_list_tile_button.dart';
import 'package:ontorikkho/common_widgets/custom_circle_avatar.dart';
import 'package:ontorikkho/common_widgets/custom_network_image.dart';
import 'package:ontorikkho/constraints/app_colors.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/theme/widget_theme/custom_text_theme.dart';
import '../../../../services/my_pages_service.dart';
import '../controllers/profile_feed_controller.dart';
import 'package:get/get.dart';

class ProfileDrawer extends StatelessWidget {
  ProfileDrawer({super.key});

  final controller = Get.put(ProfileFeedController());
  final myPageService = Get.find<MyPageService>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Drawer(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(.08),
                  ),
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                        width: 65.sp,
                        height: 65.sp,
                        border: 4,
                        bgColor: AppColors.primaryColor.withOpacity(.15),
                        image: controller.profileData.value.profilePicture ?? "",
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.profileData.value.personalData?.name ?? "",
                              style: AppTextStyles.header(fontSize: 18.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              controller.profileData.value.personalData?.email ?? "",
                              style: AppTextStyles.body(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      /*  CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18.sp,
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                          ),
                        ),*/
                    ],
                  ),
                ),

                SizedBox(height: 15.h),

                /*SizedBox(height: AppDimensions.sectionPadding.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CustomCircleAvatar(
                    width: 50.sp,
                    height: 50.sp,
                    border: 5,
                    bgColor: AppColors.primaryColor.withAlpha(100),
                    image: controller.profileData.value.profilePicture ?? "",
                  ),
                  title: Text(
                    controller.profileData.value.personalData?.name ?? "",
                    style: AppTextStyles.header(),
                    textAlign: TextAlign.start,
                  ),
                  subtitle: Text(
                    controller.profileData.value.personalData?.permanentAddress ?? "",
                    style: AppTextStyles.body(fontSize: 10.sp),
                    textAlign: TextAlign.start,
                  ),
                *//*  trailing: IconButton(
                    onPressed: () {
                      //todo
                    },
                    icon: Icon(Icons.swap_horizontal_circle_outlined),
                  ),*//*
                ),
                Divider(),*/
                Expanded(child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.horizontalPadding.w),
                  children: [
                    if (myPageService.myPages.isNotEmpty) ...[
                      Text("My Pages", style: AppTextStyles.header()),
                      SizedBox(height: AppDimensions.contentPadding.h),
                      SizedBox(
                        height: 100.sp,
                        child: ListView.builder(
                          itemCount: myPageService.myPages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final pageData = myPageService.myPages[index].obs;
                            return _pageCard(data:pageData);
                          },
                        ),
                      ),
                      // SizedBox(height: AppDimensions.widgetPadding.h),
                    ],
                    AppListTileButton(
                      margin: EdgeInsets.zero,
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.FRIENDS);
                      },
                      icon: Icon(Icons.people, color: AppColors.headerText),
                      text: "Friends",
                      textColor: AppColors.headerText,
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: AppDimensions.contentPadding.h,
                      ),
                    ),
                    AppListTileButton(
                      margin: EdgeInsets.zero,
                      onTap: () {
                        Get.back();
                        Get.put(PagesController()).getMyPages();
                        Get.toNamed(Routes.PAGES);
                      },
                      icon: Icon(Icons.pages, color: AppColors.headerText),
                      text: "Pages",
                      textColor: AppColors.headerText,
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: AppDimensions.contentPadding.h,
                      ),
                    ),

                  ],
                )),
                Divider(height: 1),
                Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Text(
                    "Ontorikkho",
                    style: AppTextStyles.body(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget _pageCard({required Rx<PageModel> data}) {
    return Obx(()=>InkWell(
      onTap: (){
        Get.put(PageFeedController()).getPageDetails(id:data.value.page?.id??0);
        Get.toNamed(Routes.PAGE_FEED);
      },
      child: Container(
        width: 70.sp,
        margin: EdgeInsets.only(
          right: AppDimensions.widgetPadding.w,
        ),
        child: Column(
          children: [
            Container(
              width: 60.sp,
              height: 60.sp,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(.3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 3,
                  ),
                ],
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadius.r,
                ),
              ),
              child: CustomNetworkImage(
                borderRadius: AppDimensions.borderRadius.r,
                image: data.value.page?.profileImage ?? "",
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              data.value.page?.name ??"",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.small(),
            ),
          ],
        ),
      ),
    ));
  }
}
