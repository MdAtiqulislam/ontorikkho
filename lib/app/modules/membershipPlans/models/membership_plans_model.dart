// To parse this JSON data, do
//
//     final membershipPlansModel = membershipPlansModelFromJson(jsonString);

import 'dart:convert';

MembershipPlansModel membershipPlansModelFromJson(String str) => MembershipPlansModel.fromJson(json.decode(str));

String membershipPlansModelToJson(MembershipPlansModel data) => json.encode(data.toJson());

class MembershipPlansModel {
  final String? msg;
  final bool? status;
  final List<SingleMembershipPlan>? data;

  MembershipPlansModel({
    this.msg,
    this.status,
    this.data,
  });

  factory MembershipPlansModel.fromJson(Map<String, dynamic> json) => MembershipPlansModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleMembershipPlan>.from(json["data"]!.map((x) => SingleMembershipPlan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleMembershipPlan {
  final int? id;
  final int? associationId;
  final String? title;
  final dynamic description;
  final String? eligibility;
  final String? accessBenefits;
  final int? amount;
  final int? periodInMonth;
  final int? inductionFees;
  final int? code;
  final dynamic serviceId;
  final int? membershipTypeMediaId;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? image;

  SingleMembershipPlan({
    this.id,
    this.associationId,
    this.title,
    this.description,
    this.eligibility,
    this.accessBenefits,
    this.amount,
    this.periodInMonth,
    this.inductionFees,
    this.code,
    this.serviceId,
    this.membershipTypeMediaId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  factory SingleMembershipPlan.fromJson(Map<String, dynamic> json) => SingleMembershipPlan(
    id: json["id"],
    associationId: json["association_id"],
    title: json["title"],
    description: json["description"],
    eligibility: json["eligibility"],
    accessBenefits: json["access_benefits"],
    amount: json["amount"],
    periodInMonth: json["period_in_month"],
    inductionFees: json["induction_fees"],
    code: json["code"],
    serviceId: json["service_id"],
    membershipTypeMediaId: json["membership_type_media_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "association_id": associationId,
    "title": title,
    "description": description,
    "eligibility": eligibility,
    "access_benefits": accessBenefits,
    "amount": amount,
    "period_in_month": periodInMonth,
    "induction_fees": inductionFees,
    "code": code,
    "service_id": serviceId,
    "membership_type_media_id": membershipTypeMediaId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image": image,
  };
}
