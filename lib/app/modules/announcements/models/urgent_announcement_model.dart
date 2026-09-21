// To parse this JSON data, do
//
//     final urgentAnnouncementModel = urgentAnnouncementModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/models/single_announcement.dart';

UrgentAnnouncementModel urgentAnnouncementModelFromJson(String str) => UrgentAnnouncementModel.fromJson(json.decode(str));

String urgentAnnouncementModelToJson(UrgentAnnouncementModel data) => json.encode(data.toJson());

class UrgentAnnouncementModel {
  final String? msg;
  final bool? status;
  final List<SingleAnnouncement>? data;
  final Pagination? pagination;

  UrgentAnnouncementModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory UrgentAnnouncementModel.fromJson(Map<String, dynamic> json) => UrgentAnnouncementModel(
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

