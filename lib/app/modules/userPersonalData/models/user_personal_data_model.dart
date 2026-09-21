// To parse this JSON data, do
//
//     final userPersonalDataModel = userPersonalDataModelFromJson(jsonString);

import 'dart:convert';

UserDataModel userPersonalDataModelFromJson(String str) => UserDataModel.fromJson(json.decode(str));

String userPersonalDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  final String? msg;
  final bool? status;
  final UserData? data;

  UserDataModel({
    this.msg,
    this.status,
    this.data,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : UserData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class UserData {
  final int? id;
  final int? userId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? address;
  final String? gender;
  final String? emargencyContact;
  final String? bloodGroup;
  final String? membershipType;
  final String? membershipId;
  final dynamic sports;
  final dynamic hobbies;
  final dynamic club;
  final String? highestEdu;
  final String? profileImage;
  final String? status;
  final String? expiredDate;
  final String? subscriptionStatus;
  final int? is2faStatusCheck;
  final String? google2faSecret;

  UserData({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.mobile,
    this.address,
    this.gender,
    this.emargencyContact,
    this.bloodGroup,
    this.membershipType,
    this.membershipId,
    this.sports,
    this.hobbies,
    this.club,
    this.highestEdu,
    this.profileImage,
    this.status,
    this.expiredDate,
    this.subscriptionStatus,
    this.is2faStatusCheck,
    this.google2faSecret,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    address: json["address"],
    gender: json["gender"],
    emargencyContact: json["emargency_contact"],
    bloodGroup: json["blood_group"],
    membershipType: json["membership_type"],
    membershipId: json["membership_id"],
    sports: json["sports"],
    hobbies: json["hobbies"],
    club: json["club"],
    highestEdu: json["highest_edu"],
    profileImage: json["profile_image"],
    status: json["status"],
    expiredDate: json["expired_date"],
    subscriptionStatus: json["subscribtion_status"],
    is2faStatusCheck: json["is_2fa_status_check"],
    google2faSecret: json["google2fa_secret"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "email": email,
    "mobile": mobile,
    "address": address,
    "gender": gender,
    "emargency_contact": emargencyContact,
    "blood_group": bloodGroup,
    "membership_type": membershipType,
    "membership_id": membershipId,
    "sports": sports,
    "hobbies": hobbies,
    "club": club,
    "highest_edu": highestEdu,
    "profile_image": profileImage,
    "status": status,
    "expired_date": expiredDate,
    "subscribtion_status": subscriptionStatus,
    "is_2fa_status_check": is2faStatusCheck,
    "google2fa_secret": google2faSecret,
  };
}
