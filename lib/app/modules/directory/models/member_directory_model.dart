
import 'dart:convert';
import 'package:ontorikkho/models/pagination_model.dart';

MemberDirectoryModel memberDirectoryModelFromJson(String str) => MemberDirectoryModel.fromJson(json.decode(str));
String memberDirectoryModelToJson(MemberDirectoryModel data) => json.encode(data.toJson());

class MemberDirectoryModel {
  final String? msg;
  final bool? status;
  final List<SingleDirectory>? boardMembers;
  final List<SingleDirectory>? data;
  final Pagination? pagination;

  MemberDirectoryModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
    this.boardMembers
  });

  factory MemberDirectoryModel.fromJson(Map<String, dynamic> json) => MemberDirectoryModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleDirectory>.from(json["data"]!.map((x) => SingleDirectory.fromJson(x))),
    boardMembers: json["board_members"] == null ? [] : List<SingleDirectory>.from(json["board_members"]!.map((x) => SingleDirectory.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "board_members": data == null ? [] : List<dynamic>.from(boardMembers!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SingleDirectory {
  final int? id;
  final String? name;
  final String? mobile;
  final String? profilePhoto;
  final String? membershipType;

  SingleDirectory({
    this.id,
    this.name,
    this.mobile,
    this.profilePhoto,
    this.membershipType
  });

  factory SingleDirectory.fromJson(Map<String, dynamic> json) => SingleDirectory(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
    profilePhoto: json["profile_photo"],
    membershipType: json["membership_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "profile_photo": profilePhoto,
    "membership_type": membershipType,
  };
}


