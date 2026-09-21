// To parse this JSON data, do
//
//     final generalAnnouncementModel = generalAnnouncementModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';

import '../../../../models/single_announcement.dart';

GeneralAnnouncementModel generalAnnouncementModelFromJson(String str) => GeneralAnnouncementModel.fromJson(json.decode(str));

String generalAnnouncementModelToJson(GeneralAnnouncementModel data) => json.encode(data.toJson());

class GeneralAnnouncementModel {
  final String? msg;
  final bool? status;
  final List<SingleAnnouncement>? data;
  final Pagination? pagination;

  GeneralAnnouncementModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory GeneralAnnouncementModel.fromJson(Map<String, dynamic> json) => GeneralAnnouncementModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleAnnouncement>.from(json["data"]!.map((x) => SingleAnnouncement.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}




