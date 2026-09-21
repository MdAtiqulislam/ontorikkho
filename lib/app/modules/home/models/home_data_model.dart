// To parse this JSON data, do
//
//     final homeDataModel = homeDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/events/models/event_list_model.dart';

import '../../../../models/single_announcement.dart';
import '../../../../models/single_pending_item.dart';

HomeDataModel homeDataModelFromJson(String str) => HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
  final String? msg;
  final bool? status;
  final HomeData? data;

  HomeDataModel({
    this.msg,
    this.status,
    this.data,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : HomeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class HomeData {
  final List<SingleEvent>? events;
  final List<SingleAnnouncement>? announcement;
  final List<SinglePendingItem>? pendingList;

  HomeData({
    this.events,
    this.announcement,
    this.pendingList,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    events: json["events"] == null ? [] : List<SingleEvent>.from(json["events"]!.map((x) => SingleEvent.fromJson(x))),
    announcement: json["announcement"] == null ? [] : List<SingleAnnouncement>.from(json["announcement"]!.map((x) => SingleAnnouncement.fromJson(x))),
    pendingList: json["pending_list"] == null ? [] : List<SinglePendingItem>.from(json["pending_list"]!.map((x) => SinglePendingItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
    "announcement": announcement == null ? [] : List<dynamic>.from(announcement!.map((x) => x.toJson())),
    "pending_list": pendingList == null ? [] : List<dynamic>.from(pendingList!.map((x) => x.toJson())),
  };
}





