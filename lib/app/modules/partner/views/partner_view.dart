import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/bottom_navigation_bar/custom_bottom_nav_bar.dart';
import 'package:ontorikkho/app/modules/customAppBar/custom_app_bar.dart';
import 'package:ontorikkho/app/modules/partner/views/partner_shimmer_screen.dart';
import 'package:ontorikkho/common_widgets/custom_list_tile.dart';
import 'package:ontorikkho/common_widgets/empty_screen.dart';
import 'package:ontorikkho/common_widgets/section_header.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';
import '../controllers/partner_controller.dart';
import '../../../../common_widgets/expandable_html_widget.dart';

class PartnerView extends GetView<PartnerController> {
  const PartnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(
              () =>
          controller.isLoading.value
              ? PartnerShimmerScreen()
              : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
            ),
            child: CustomScrollView(
              controller: controller.scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppDimensions.contentPadding.h,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true, // This makes it sticky
                  delegate: _SliverAppBarDelegate(
                    child: Container(
                      color:
                      Theme
                          .of(
                        context,
                      )
                          .scaffoldBackgroundColor,
                      // Matches Scaffold background
                      child: SectionHeader(
                        title: "Partners",
                        subTitle:
                        "total ${controller.pagination.value.total ?? 0}",
                        showMoreButton: false,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppDimensions.contentPadding.h,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: controller.partners.length,
                          (buildContext,
                          index,) {
                        var partner = controller.partners[index];
                        return CustomListTile(
                          avatar: partner.partnerLogo ?? "",
                          title: partner.partnerName ?? "",
                          leading: HeaderText(
                            text: "${index + 1}",
                            size: 12,
                          ),
                          subTitle: _buildSubTitle(
                            subTitle:
                            partner.description ?? "",
                            offer: partner.specialOffers ?? "",
                          ),
                        );
                      }),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppDimensions.widgetPadding.h,
                  ),
                ),
                if(controller.partners.isEmpty)SliverToBoxAdapter(
                  child: EmptyScreen(message: "No partner found!",icon: Icons.supervisor_account,),),
                if(controller.isLoadingMore.value) SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator(),)
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppDimensions.sectionPadding.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSubTitle({required String subTitle, required String offer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpandableHtmlWidget(htmlContent: subTitle),
        if (int.tryParse(offer) != null && int.parse(offer) > 0)
          Container(
            margin: EdgeInsets.only(top: 6),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.contentPadding.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
              gradient: const LinearGradient(
                colors: [Color(0xffFEC00F), Color(0xFFFFE680)],
              ),
            ),
            child: HeaderText(text: "$offer% Offer", size: 10),
          ),
      ],
    );
  }


}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(BuildContext context,
      double shrinkOffset,
      bool overlapsContent,) {
    return child;
  }

  @override
  double get maxExtent =>
      child is PreferredSizeWidget
          ? (child as PreferredSizeWidget).preferredSize.height
          : 40.0.sp;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
