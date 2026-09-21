// To parse this JSON data, do
//
//     final privacyPolicyModel = privacyPolicyModelFromJson(jsonString);

import 'dart:convert';

PrivacyPolicyModel privacyPolicyModelFromJson(String str) => PrivacyPolicyModel.fromJson(json.decode(str));

String privacyPolicyModelToJson(PrivacyPolicyModel data) => json.encode(data.toJson());

class PrivacyPolicyModel {
  final bool? status;
  final String? msg;
  final PrivacyPolicyData? data;

  PrivacyPolicyModel({
    this.status,
    this.msg,
    this.data,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) => PrivacyPolicyModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : PrivacyPolicyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class PrivacyPolicyData {
  final String? html;

  PrivacyPolicyData({
    this.html,
  });

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) => PrivacyPolicyData(
    html: json["html"],
  );

  Map<String, dynamic> toJson() => {
    "html": html,
  };
}
