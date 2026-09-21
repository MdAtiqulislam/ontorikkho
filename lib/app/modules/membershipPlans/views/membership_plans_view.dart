/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:html/parser.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../theme/widget_theme/custom_text_theme.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/membership_plans_controller.dart';

class MembershipPlansView extends GetView<MembershipPlansController> {
  const MembershipPlansView({super.key});

  String parseHtmlString(String? htmlString) {
    if (htmlString == null) return "";
    final document = parse(htmlString);
    return parse(document.body?.text).documentElement?.text ?? "";
  }

  @override
  Widget build(BuildContext context) {
    //final CarouselController carouselController = CarouselController();
    final RxInt currentIndex = 0.obs;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Membership Plans", showBackButton: true),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingScreen();
          }

          final plans = controller.membershipPlans;
          if (plans.isEmpty) {
            return const Center(child: Text("No membership plans available."));
          }

          final List<Color> packageColors = [
            const Color(0xFF1976D2),
            const Color(0xFF00796B),
            const Color(0xFF8E24AA),
            const Color(0xFFF57C00),
            const Color(0xFFD32F2F),
            const Color(0xFF388E3C),
            const Color(0xFF5D4037),
            const Color(0xFF303F9F),
          ];

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.horizontalPadding.w,
              vertical: AppDimensions.verticalPadding.h,
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 10.h),

                    /// 🔹 Message section
                    Text(
                      "Upgrade your plan to unlock more benefits! 🚀",
                      style: AppTextStyles.header(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20.h),

                    /// 🔹 Carousel section
                    CarouselSlider.builder(
                     // carouselController: carouselController,
                      options: CarouselOptions(
                        height: 520.h,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.92,
                        onPageChanged: (index, reason) {
                          currentIndex.value = index;
                        },
                      ),
                      itemCount: plans.length,
                      itemBuilder: (context, index, _) {
                        final plan = plans[index];
                        final color = packageColors[index % packageColors.length];
                        final isCurrent =
                            plan.id == controller.currentPlan.value.id;

                        final ScrollController innerScrollController =
                        ScrollController();

                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 10.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadius.r),
                                gradient: LinearGradient(
                                  colors: [
                                    color.withAlpha((0.9 * 255).round()),
                                    color.withAlpha((0.7 * 255).round())
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withAlpha((0.3 * 255).round()),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Image + Title
                                  if ((plan.image ?? "").isNotEmpty)
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.network(
                                          plan.image!,
                                          height: 80.sp,
                                          width: 80.sp,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 10.h),

                                  Center(
                                    child: Text(
                                      plan.title ?? "Untitled Plan",
                                      style: AppTextStyles.title(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  Center(
                                    child: Text(
                                      "৳${plan.amount ?? 0} for ${plan.periodInMonth ?? 0} months"
                                          "${(plan.inductionFees ?? 0) > 0 ? " + ৳${plan.inductionFees} induction fees" : ""}",
                                      style: AppTextStyles.body(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  SizedBox(height: 12.h),

                                  /// Scrollable description section
                                  Expanded(
                                    child: ScrollbarTheme(
                                      data: ScrollbarThemeData(
                                        thumbColor: WidgetStateProperty.all(color.withAlpha((0.9 * 255).round())), // plan color
                                        trackColor: WidgetStateProperty.all(color.withAlpha((0.3 * 255).round())), // track color
                                        thickness: WidgetStateProperty.all(6.w),
                                        radius: Radius.circular(8.r),
                                      ),
                                      child: Scrollbar(
                                        controller: innerScrollController,
                                        thumbVisibility: true,
                                        radius: Radius.circular(8.r),
                                        thickness: 4.w,
                                        child: SingleChildScrollView(
                                          controller: innerScrollController,
                                          physics: const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                if ((plan.description ?? "")
                                                    .isNotEmpty)
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Description:",
                                                        style: AppTextStyles.header(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        parseHtmlString(
                                                            plan.description),
                                                        style: AppTextStyles.body(
                                                          color: Colors.white70,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.h),
                                                    ],
                                                  ),
                                                if ((plan.eligibility ?? "")
                                                    .isNotEmpty)
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Eligibility:",
                                                        style: AppTextStyles.header(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        parseHtmlString(
                                                            plan.eligibility),
                                                        style: AppTextStyles.body(
                                                          color: Colors.white70,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.h),
                                                    ],
                                                  ),
                                                if ((plan.accessBenefits ?? "")
                                                    .isNotEmpty)
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Access Benefits:",
                                                        style: AppTextStyles.header(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        parseHtmlString(
                                                            plan.accessBenefits),
                                                        style: AppTextStyles.body(
                                                          color: Colors.white70,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  /// Upgrade button
                                  Center(
                                    child: AppButton(
                                      bgColor: isCurrent
                                          ? Colors.white70
                                          : Colors.white,
                                      textColor: isCurrent
                                          ? Colors.grey.shade700
                                          : color,
                                      borderColor: color,
                                      text: isCurrent
                                          ? "Current Plan"
                                          : "Upgrade",
                                      onTap: isCurrent
                                          ? null
                                          : () {
                                        controller.upgradePlan(plan);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Current Plan Badge
                            /// Current Plan Icon Badge
                            if (isCurrent)
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white, // light background
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.check_circle, // current plan icon

                                    color: AppColors.successColor, // card's main color
                                    size: 24.sp,
                                  ),
                                ),
                              ),

                          ],
                        );
                      },
                    ),

                    SizedBox(height: 12.h),

                    /// Page indicator
                    Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          plans.length,
                              (i) => Container(
                            width: currentIndex.value == i ? 12 : 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: currentIndex.value == i
                                  ? AppColors.primaryColor
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 25.h),
                  ],
                ),
                if(controller.isUpdating.value)LoadingScreen()
              ],
            ),
          );
        }),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:html/parser.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/custom_loading_screen.dart';
import '../../../../constraints/app_colors.dart';
import '../../../../constraints/dimensions.dart';
import '../../../../theme/widget_theme/custom_text_theme.dart';
import '../../bottom_navigation_bar/custom_bottom_nav_bar.dart';
import '../../customAppBar/custom_app_bar.dart';
import '../controllers/membership_plans_controller.dart';

class MembershipPlansView extends GetView<MembershipPlansController> {
  const MembershipPlansView({super.key});

  String parseHtmlString(String? htmlString) {
    if (htmlString == null) return "";
    final document = parse(htmlString);
    return parse(document.body?.text).documentElement?.text ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs;
    final CarouselSliderController carouselController = CarouselSliderController();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(title: "Membership Plans", showBackButton: true),
        bottomNavigationBar:  CustomBottomNavigationBar(),
        body: Obx(() {
          if (controller.isLoading.value) return const LoadingScreen();

          final plans = controller.membershipPlans;
          if (plans.isEmpty) {
            return const Center(child: Text("No membership plans available."));
          }

          final List<Color> packageColors = [
            const Color(0xFF1976D2),
            const Color(0xFF00796B),
            const Color(0xFF8E24AA),
            const Color(0xFFF57C00),
            const Color(0xFFD32F2F),
            const Color(0xFF388E3C),
            const Color(0xFF5D4037),
            const Color(0xFF303F9F),
          ];

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.horizontalPadding.w,
                  vertical: AppDimensions.verticalPadding.h,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "Upgrade your plan to unlock more benefits! 🚀",
                      style: AppTextStyles.header(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    /// 🔹 Carousel Section
                    CarouselSlider.builder(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        height: 520.h,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.92,
                        initialPage: currentIndex.value,
                        onPageChanged: (index, reason) {
                          currentIndex.value = index;
                        },
                      ),
                      itemCount: plans.length,
                      itemBuilder: (context, index, _) {
                        final plan = plans[index];
                        final color = packageColors[index % packageColors.length];
                        final currentPlan = controller.currentPlan.value;

                        final bool isCurrent = plan.id == currentPlan.id;
                        final bool isBeforeCurrent = controller.isBeforeCurrent(plan);

                        final ScrollController innerScroll = ScrollController();

                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppDimensions.borderRadius.r),
                                gradient: LinearGradient(
                                  colors: [
                                    color.withAlpha((0.9 * 255).round()),
                                    color.withAlpha((0.7 * 255).round()),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withAlpha((0.3 * 255).round()),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ((plan.image ?? "").isNotEmpty)
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.network(
                                          plan.image!,
                                          height: 80.sp,
                                          width: 80.sp,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 10.h),

                                  Center(
                                    child: Text(
                                      plan.title ?? "Untitled Plan",
                                      style: AppTextStyles.title(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  Center(
                                    child: Text(
                                      "৳${plan.amount ?? 0} for ${plan.periodInMonth ?? 0} months"
                                          "${(plan.inductionFees ?? 0) > 0 ? " + ৳${plan.inductionFees} induction fees" : ""}",
                                      style: AppTextStyles.body(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  Expanded(
                                    child: ScrollbarTheme(
                                      data: ScrollbarThemeData(
                                        thumbColor: WidgetStateProperty.all(color.withAlpha((0.9 * 255).round())), // plan color
                                        trackColor: WidgetStateProperty.all(color.withAlpha((0.3 * 255).round())), // track color
                                        thickness: WidgetStateProperty.all(6.w),
                                        radius: Radius.circular(8.r),
                                      ),
                                      child: Scrollbar(
                                        controller: innerScroll,
                                        thumbVisibility: true,
                                        radius: Radius.circular(8.r),
                                        thickness: 4.w,
                                        child: SingleChildScrollView(
                                          controller: innerScroll,
                                          physics: const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if ((plan.description ?? "").isNotEmpty)
                                                  _buildSection("Description", parseHtmlString(plan.description)),
                                                if ((plan.eligibility ?? "").isNotEmpty)
                                                  _buildSection("Eligibility", parseHtmlString(plan.eligibility)),
                                                if ((plan.accessBenefits ?? "").isNotEmpty)
                                                  _buildSection("Access Benefits", parseHtmlString(plan.accessBenefits)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  Center(
                                    child: AppButton(
                                      bgColor: (isCurrent || isBeforeCurrent)
                                          ? Colors.white70
                                          : Colors.white,
                                      textColor: (isCurrent || isBeforeCurrent)
                                          ? Colors.grey.shade700
                                          : color,
                                      borderColor: color,
                                      text: isCurrent
                                          ? "Current Plan"
                                          : isBeforeCurrent
                                          ? "Not Available"
                                          : "Upgrade",
                                      onTap: (isCurrent || isBeforeCurrent)
                                          ? null
                                          : () async {
                                        int oldIndex = currentIndex.value;
                                         controller.upgradePlan(plan);
                                        // restore last index
                                        Future.delayed(const Duration(milliseconds: 200), () {
                                          carouselController.animateToPage(oldIndex);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// ✅ Current Plan Badge
                            if (isCurrent)
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.verified_rounded,
                                    color: color,//AppColors.successColor,
                                    size: 28.sp,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 12.h),

                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        plans.length,
                            (i) => Container(
                          width: currentIndex.value == i ? 12 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: currentIndex.value == i
                                ? AppColors.primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
              if (controller.isUpdating.value) const LoadingScreen(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: AppTextStyles.header(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            content,
            style: AppTextStyles.body(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
