
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/userPersonalData/models/user_personal_data_model.dart';
import 'package:ontorikkho/services/local_services.dart';
import '../../routes/app_pages.dart';

class CustomBottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  var user=UserData().obs;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    user.value=await LocalServices.getUserData()??UserData();
  }


  void changeIndex(int index) {
    selectedIndex.value = index;
    actionPerform(index:index);

  }

  void actionPerform({required int index}) {
    if(index==0 && Get.currentRoute!=Routes.HOME){
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black, // status bar color
          statusBarIconBrightness: Brightness.light,   // Only honored in Android M and above
          statusBarBrightness: Brightness.light,
        ),
      );

      Get.offAllNamed(Routes.HOME);
    }else if(index==1 && Get.currentRoute!=Routes.EVENTS){
      Get.toNamed(Routes.EVENTS);
    }else if(index==2 && Get.currentRoute!=Routes.PARTNER){
     // Get.put(CaseReportController()).clearFilter();
      Get.toNamed(Routes.PARTNER);
    }else if(index==3 && Get.currentRoute!=Routes.MEDIA){
    //  Get.put(CaseCategoryController()).getCaseCategory();
      Get.toNamed(Routes.MEDIA);
    }
    else if(index==4 && Get.currentRoute!=Routes.STORE){
    //  Get.put(CaseCategoryController()).getCaseCategory();
      Get.toNamed(Routes.STORE);
    }
  }
}

