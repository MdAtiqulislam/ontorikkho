// To parse this JSON data, do
//
//     final currentPlanModel = currentPlanModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/membershipPlans/models/membership_plans_model.dart';

CurrentPlanModel currentPlanModelFromJson(String str) => CurrentPlanModel.fromJson(json.decode(str));

String currentPlanModelToJson(CurrentPlanModel data) => json.encode(data.toJson());

class CurrentPlanModel {
  final String? msg;
  final bool? status;
  final SingleMembershipPlan? data;

  CurrentPlanModel({
    this.msg,
    this.status,
    this.data,
  });

  factory CurrentPlanModel.fromJson(Map<String, dynamic> json) => CurrentPlanModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : SingleMembershipPlan.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

