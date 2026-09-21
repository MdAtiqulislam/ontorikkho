import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';

import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_circle_avatar.dart';
import '../../../../common_widgets/section_header.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../constraints/header_text.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../controllers/directory_controller.dart';

class DirectoryView extends GetView<DirectoryController> {
  const DirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(showBackButton: true,),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
          () =>
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildDirectoryItem({
    required String image,
    required int index,
    required String name,
    required String contact,
    required String membershipType,
  }) {
    return Container(
     // margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderGrey)),
        boxShadow: [
          BoxShadow(color: AppColors.shadowColor.withAlpha(20), blurRadius: 3),
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: () async {
           // controller.openDialler(phone: contact);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                HeaderText(text: "${index + 1}", size: 12),
                SizedBox(width: AppDimensions.contentPadding.w),
                CustomCircleAvatar(height: 30.sp, width: 30.sp, image: image),
                SizedBox(width: 12.w),
                Expanded(
                  child: HeaderText(
                    text: name,
                    size: 12,
                    align: TextAlign.start,
                  ),
                ),
                // Membership Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getMembershipColor(membershipType),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getMembershipIcon(membershipType),
                        size: 14.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      HeaderText(
                        text: membershipType,
                        size: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

        ),
      ),
    );
  }

  Widget _buildBody(var context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.horizontalPadding.w,
      ),
      child: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.contentPadding.h),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              child: Obx(() {
                if (controller.showSearchBar.value) {
                  // Show only Search Bar
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search members...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                            ),
                            onChanged: controller.search,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            controller.hideSearchBar();
                            controller.searchKey.value = "";
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  // Show the normal header
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: SectionHeader(
                      title: "Member Directory",
                      showMoreButton: false,
                      trailing: IconButton(
                        onPressed: () {
                          controller.toggleSearchBar();
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  );
                }
              }),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.contentPadding.h),
          ),

          SliverToBoxAdapter(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(text: "Board Members",align: TextAlign.start,fontWeight: FontWeight.normal,size: 12,),
              Divider()
            ],
          ),),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: controller.boardMembers.length,
              (buildContext, index) {
                var member = controller.boardMembers[index];

                return _buildDirectoryItem(
                  index: index,
                  image: member.profilePhoto ?? "",
                  name: member.name ?? "",
                  contact: member.mobile ?? "",
                  membershipType: member.membershipType??""
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimensions.sectionPadding.h,),
              HeaderText(text: "All Other Members",align: TextAlign.start,fontWeight: FontWeight.normal,size: 12,),
              Divider()
            ],
          ),),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: controller.generalMembers.length,
              (buildContext, index) {
                var member = controller.generalMembers[index];

                return _buildDirectoryItem(
                  index: index,
                  image: member.profilePhoto ?? "",
                  name: member.name ?? "",
                  contact: member.mobile ?? "",
                  membershipType: member.membershipType??""
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.widgetPadding.h),
          ),
          if (controller.isLoadingMore.value)
            SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
          if (controller.generalMembers.isEmpty)
            SliverToBoxAdapter(
              child: EmptyScreen(
                message: "No member found!",
                icon: Icons.no_accounts_outlined,
              ),
            ),

          SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.sectionPadding.h),
          ),
        ],
      ),
    );
  }
  Color _getMembershipColor(String membershipType) {
    switch (membershipType.toLowerCase()) {
      case "affiliate":
        return Colors.grey;
      case "silver":
        return Colors.blueGrey;
      case "gold":
        return Colors.amber;
      case "platinum":
        return Colors.blueAccent;
      case "life time":
        return Colors.deepPurple;
      default:
        return Colors.black54;
    }
  }

  IconData _getMembershipIcon(String membershipType) {
    switch (membershipType.toLowerCase()) {
      case "affiliate":
        return Icons.person_outline;
      case "silver":
        return Icons.star_border;
      case "gold":
        return Icons.workspace_premium_outlined;
      case "platinum":
        return Icons.diamond_outlined;
      case "life time":
        return Icons.verified_user;
      default:
        return Icons.help_outline;
    }
  }



}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent =>
      child is PreferredSizeWidget
          ? (child as PreferredSizeWidget).preferredSize.height
          : 56.0;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }




}
