import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constraints/body_text.dart';

class LoadingScreen extends StatelessWidget {
  final bool showText;

  const LoadingScreen({this.showText=false,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: Colors.transparent,
      child:  Center(child: Stack(
        children: [

          Image.asset("assets/logo/loading.gif",height: 50.sp,),
         // CircularProgressIndicator(color: AppColors.primaryColor,),
          if(showText)BodyText(text: "Please Wait...")
        ],
      ),),
    );
  }
}
