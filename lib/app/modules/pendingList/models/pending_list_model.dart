// To parse this JSON data, do
//
//     final pendingListModel = pendingListModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';
import 'package:ontorikkho/models/single_pending_item.dart';

PendingListModel pendingListModelFromJson(String str) => PendingListModel.fromJson(json.decode(str));

String pendingListModelToJson(PendingListModel data) => json.encode(data.toJson());

class PendingListModel {
  final String? msg;
  final bool? status;
  final List<SinglePendingItem>? data;
  final Pagination? pagination;

  PendingListModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory PendingListModel.fromJson(Map<String, dynamic> json) => PendingListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SinglePendingItem>.from(json["data"]!.map((x) => SinglePendingItem.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}


