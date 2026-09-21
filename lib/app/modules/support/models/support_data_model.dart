// To parse this JSON data, do
//
//     final supportDataModel = supportDataModelFromJson(jsonString);

import 'dart:convert';

SupportDataModel supportDataModelFromJson(String str) => SupportDataModel.fromJson(json.decode(str));

String supportDataModelToJson(SupportDataModel data) => json.encode(data.toJson());

class SupportDataModel {
  final String? msg;
  final bool? status;
  final SupportData? data;

  SupportDataModel({
    this.msg,
    this.status,
    this.data,
  });

  factory SupportDataModel.fromJson(Map<String, dynamic> json) => SupportDataModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : SupportData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class SupportData {
  final int? id;
  final String? email;
  final String? phone;
  final String? title;
  final String? description;

  SupportData({
    this.id,
    this.email,
    this.phone,
    this.title,
    this.description,
  });

  factory SupportData.fromJson(Map<String, dynamic> json) => SupportData(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "title": title,
    "description": description,
  };
}
