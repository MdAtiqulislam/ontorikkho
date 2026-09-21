// To parse this JSON data, do
//
//     final signUpOtherInfoModel = signUpOtherInfoModelFromJson(jsonString);

import 'dart:convert';

import '../../../../models/gender_model.dart';
import '../../../../models/highest_edu_model.dart';
import '../../../../models/membership_type_model.dart';

SignUpOtherInfoModel signUpOtherInfoModelFromJson(String str) => SignUpOtherInfoModel.fromJson(json.decode(str));

String signUpOtherInfoModelToJson(SignUpOtherInfoModel data) => json.encode(data.toJson());

class SignUpOtherInfoModel {
  final String? msg;
  final bool? status;
  final Data? data;

  SignUpOtherInfoModel({
    this.msg,
    this.status,
    this.data,
  });

  factory SignUpOtherInfoModel.fromJson(Map<String, dynamic> json) => SignUpOtherInfoModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  final List<MembershipType>? membershipTypes;
  final Gender? gender;
  final List<HighestEdu>? highestEdu;

  Data({
    this.membershipTypes,
    this.gender,
    this.highestEdu,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    membershipTypes: json["membership_types"] == null ? [] : List<MembershipType>.from(json["membership_types"]!.map((x) => MembershipType.fromJson(x))),
    gender: json["gender"] == null ? null : Gender.fromJson(json["gender"]),
    highestEdu: json["highest_edu"] == null ? [] : List<HighestEdu>.from(json["highest_edu"]!.map((x) => HighestEdu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "membership_types": membershipTypes == null ? [] : List<dynamic>.from(membershipTypes!.map((x) => x.toJson())),
    "gender": gender?.toJson(),
    "highest_edu": highestEdu == null ? [] : List<dynamic>.from(highestEdu!.map((x) => x.toJson())),
  };
}






