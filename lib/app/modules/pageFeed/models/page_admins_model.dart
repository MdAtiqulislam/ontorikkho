// To parse this JSON data, do
//
//     final pageAdminsModel = pageAdminsModelFromJson(jsonString);

import 'dart:convert';

PageAdminsModel pageAdminsModelFromJson(String str) => PageAdminsModel.fromJson(json.decode(str));

String pageAdminsModelToJson(PageAdminsModel data) => json.encode(data.toJson());

class PageAdminsModel {
  final String? msg;
  final bool? status;
  final AdminsData? data;

  PageAdminsModel({
    this.msg,
    this.status,
    this.data,
  });

  PageAdminsModel copyWith({
    String? msg,
    bool? status,
    AdminsData? data,
  }) =>
      PageAdminsModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory PageAdminsModel.fromJson(Map<String, dynamic> json) => PageAdminsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : AdminsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class AdminsData {
  final List<Admin>? admins;

  AdminsData({
    this.admins,
  });

  AdminsData copyWith({
    List<Admin>? admins,
  }) =>
      AdminsData(
        admins: admins ?? this.admins,
      );

  factory AdminsData.fromJson(Map<String, dynamic> json) => AdminsData(
    admins: json["admins"] == null ? [] : List<Admin>.from(json["admins"]!.map((x) => Admin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "admins": admins == null ? [] : List<dynamic>.from(admins!.map((x) => x.toJson())),
  };
}

class Admin {
  final int? userId;
  final String? role;
  final AdminUser? user;

  Admin({
    this.userId,
    this.role,
    this.user,
  });

  Admin copyWith({
    int? userId,
    String? role,
    AdminUser? user,
  }) =>
      Admin(
        userId: userId ?? this.userId,
        role: role ?? this.role,
        user: user ?? this.user,
      );

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    userId: json["user_id"],
    role: json["role"],
    user: json["user"] == null ? null : AdminUser.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "role": role,
    "user": user?.toJson(),
  };
}

class AdminUser {
  final int? id;
  final String? name;
  final String? avatar;

  AdminUser({
    this.id,
    this.name,
    this.avatar,
  });

  AdminUser copyWith({
    int? id,
    String? name,
    String? avatar,
  }) =>
      AdminUser(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
  };
}
