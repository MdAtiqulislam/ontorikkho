/*
import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/app/modules/membershipPlans/models/current_plan_model.dart';
import 'package:ontorikkho/app/modules/membershipPlans/models/membership_plans_model.dart';
import 'package:ontorikkho/app/modules/membershipRenew/controllers/membership_renew_controller.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import '../../../../services/local_services.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';


class MembershipPlansController extends GetxController {
  var isLoading = false.obs;
  var isUpdating = false.obs;

  var membershipPlans = <SingleMembershipPlan>[].obs;

  // Example current plan
  var currentPlan = SingleMembershipPlan().obs;


  @override
  Future<void> onInit() async {
    super.onInit();
   await loadPlans();
   await loadCurrentPlan();
  }

  Future<void> loadPlans()async {
    isLoading.value=true;
    var endpoint=APIEndPoints.getMembershipPlans;
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint);
      if(res!=null){
        MembershipPlansModel membershipPlansModel=MembershipPlansModel.fromJson(res);
        membershipPlans.value=membershipPlansModel.data??[];
      }
    } finally {
      isLoading.value=false;
    }
  }

  Future<void> loadCurrentPlan()async {
    isLoading.value=true;
    var endpoint=APIEndPoints.getCurrentPlan;
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint);
      if(res!=null){
        CurrentPlanModel currentPlanModel=CurrentPlanModel.fromJson(res);
        currentPlan.value=currentPlanModel.data??SingleMembershipPlan();
      }
    } finally {
      isLoading.value=false;
    }
  }

  void upgradePlan(SingleMembershipPlan plan)async {
    isUpdating.value=true;
    var endpoint=APIEndPoints.upgradePlan;
    var body={"membership_type_id":plan.id.toString()};
    try {
      var res=await RemoteServices.postRequest(endpoint: endpoint,body: body);
      if(res!=null){
       await loadCurrentPlan();
       await getUserData();
      }
    } finally {
      isUpdating.value=false;
    }
  }

  Future<void> getUserData() async {
    isLoading.value=true;
    var endpoint=APIEndPoints.getUserData;
    try {
      var res=await RemoteServices.getRequest(endpoint: endpoint);
      if(res!=null){
        UserDataModel userDataModel=UserDataModel.fromJson(res);
        await LocalServices().storeUserData(userDataModel.data??UserData()).then((value) async {
         await Get.put(HomeController()).getUserData();
         await Get.put(MembershipRenewController()).getUserData();
        });

      }
    } finally {
      isLoading.value=false;
    }
  }
}
*/


import 'package:get/get.dart';
import 'package:ontorikkho/app/modules/home/controllers/home_controller.dart';
import 'package:ontorikkho/app/modules/membershipPlans/models/current_plan_model.dart';
import 'package:ontorikkho/app/modules/membershipPlans/models/membership_plans_model.dart';
import 'package:ontorikkho/app/modules/membershipRenew/controllers/membership_renew_controller.dart';
import 'package:ontorikkho/constraints/api_end_points.dart';
import 'package:ontorikkho/services/remote_services.dart';
import '../../../../services/local_services.dart';
import '../../userPersonalData/models/user_personal_data_model.dart';

class MembershipPlansController extends GetxController {
  var isLoading = false.obs;
  var isUpdating = false.obs;

  var membershipPlans = <SingleMembershipPlan>[].obs;
  var currentPlan = SingleMembershipPlan().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadPlans();
    await loadCurrentPlan();
  }

  Future<void> loadPlans() async {
    isLoading.value = true;
    try {
      var res = await RemoteServices.getRequest(endpoint: APIEndPoints.getMembershipPlans);
      if (res != null) {
        MembershipPlansModel model = MembershipPlansModel.fromJson(res);
        membershipPlans.value = model.data ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCurrentPlan() async {
    isLoading.value = true;
    try {
      var res = await RemoteServices.getRequest(endpoint: APIEndPoints.getCurrentPlan);
      if (res != null) {
        CurrentPlanModel model = CurrentPlanModel.fromJson(res);
        currentPlan.value = model.data ?? SingleMembershipPlan();
      }
    } finally {
      isLoading.value = false;
    }
  }

  bool isBeforeCurrent(SingleMembershipPlan plan) {
    final current = currentPlan.value;
    if (current.id == null || membershipPlans.isEmpty) return false;

    final currentIndex = membershipPlans.indexWhere((p) => p.id == current.id);
    final planIndex = membershipPlans.indexWhere((p) => p.id == plan.id);

    // Disable all before current + also last one
    final isLast = planIndex == membershipPlans.length - 1;
    return planIndex < currentIndex || isLast;
  }

  void upgradePlan(SingleMembershipPlan plan) async {
    isUpdating.value = true;
    var body = {"membership_type_id": plan.id.toString()};
    try {
      var res = await RemoteServices.postRequest(
        endpoint: APIEndPoints.upgradePlan,
        body: body,
      );
      if (res != null) {
        await loadCurrentPlan();
        await getUserData();
      }
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    try {
      var res = await RemoteServices.getRequest(endpoint: APIEndPoints.getUserData);
      if (res != null) {
        UserDataModel model = UserDataModel.fromJson(res);
        await LocalServices.storeUserData(model.data ?? UserData());
        await Get.put(HomeController()).getUserData();
        await Get.put(MembershipRenewController()).getUserData();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
