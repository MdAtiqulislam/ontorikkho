// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import '../../../../models/logged_in_user_model.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? msg;
  bool? status;
  String? apiToken;
  LoggedInUserModel? data;

  LoginModel({
    this.msg,
    this.status,
    this.apiToken,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    msg: json["msg"],
    status: json["status"],
    apiToken: json["api_token"],
    data: json["data"] == null ? null : LoggedInUserModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "api_token": apiToken,
    "data": data?.toJson(),
  };
}



