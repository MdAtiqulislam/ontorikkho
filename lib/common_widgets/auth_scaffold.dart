/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/app_strings.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final Widget? bottomWidget;
  final AlignmentGeometry imageAlign;
  final ScrollController? scrollController;
  final VoidCallback? onBackPress;

  const AuthScaffold({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
    this.bottomWidget,
    this.imageAlign=Alignment.bottomRight,
     this.scrollController,
    this.onBackPress
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔲 Background with logo
          Column(
            children: [
              SizedBox(
                height: 280.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(AppImagePath.appBarBg,
                      fit: BoxFit.cover,
                      alignment: imageAlign,
                    ),
                    Container(color: Colors.black.withAlpha(200)),
                    if (showBackButton)
                      Positioned(
                        top: 40.h,
                        left: 16.w,
                        child: Container(clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: ()=>onBackPress??Get.back(),
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(30),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withAlpha(100))
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Center(
                      child: Image.asset(AppImagePath.appLogo,
                        height: 60.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🔽 Foreground
          Positioned(
            top: 180.h,
            left: 0,
            right: 0,
            bottom: AppDimensions.verticalPadding*2.h,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    spreadRadius: 4,
                  )
                ],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    HeaderText(
                      text: title,
                      maxLine: 3,
                      size: 24,
                        ),
                    BodyText(text: subtitle,
                        size: 14,fontWeight: FontWeight.w500,),
                    SizedBox(height: 32.h),
                    child,
                    if (bottomWidget != null) ...[
                      SizedBox(height: 24.h),
                      bottomWidget!,
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/constraints/app_strings.dart';
import 'package:ontorikkho/constraints/body_text.dart';
import 'package:ontorikkho/constraints/dimensions.dart';
import 'package:ontorikkho/constraints/header_text.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final Widget? bottomWidget;
  final AlignmentGeometry imageAlign;
  final ScrollController? scrollController;
  final VoidCallback? onBackPress;

  const AuthScaffold({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
    this.bottomWidget,
    this.imageAlign = Alignment.bottomRight,
    this.scrollController,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // keyboard dismiss
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              // 🔲 Background with logo
              Column(
                children: [
                  SizedBox(
                    height: 280.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          AppImagePath.appBarBg,
                          fit: BoxFit.cover,
                          alignment: imageAlign,
                        ),
                        Container(color: Colors.black.withAlpha(200)),
                        if (showBackButton)
                          Positioned(
                            top: 40.h,
                            left: 16.w,
                            child: Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: onBackPress ?? Get.back,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(30),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white.withAlpha(100)),
                                  ),
                                  child: const Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        Center(
                          child: Image.asset(
                            AppImagePath.appLogo,
                            height: 60.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        
              // 🔽 Foreground
              Positioned(
                top: 180.h,
                left: 0,
                right: 0,
                bottom: AppDimensions.verticalPadding * 2.h,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        HeaderText(
                          text: title,
                          maxLine: 3,
                          size: 24,
                        ),
                        BodyText(
                          text: subtitle,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 32.h),
                        child,
                        if (bottomWidget != null) ...[
                          SizedBox(height: 24.h),
                          bottomWidget!,
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
