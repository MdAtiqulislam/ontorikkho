// To parse this JSON data, do
//
//     final commentsModel = commentsModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/forYou/models/single_comment.dart';

import '../../../../models/pagination_model.dart';

CommentsModel commentsModelFromJson(String str) => CommentsModel.fromJson(json.decode(str));

String commentsModelToJson(CommentsModel data) => json.encode(data.toJson());

class CommentsModel {
  final String? msg;
  final bool? status;
  final List<SingleComment>? data;
  final Pagination? pagination;

  CommentsModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  CommentsModel copyWith({
    String? msg,
    bool? status,
    List<SingleComment>? data,
    Pagination? pagination,
  }) =>
      CommentsModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleComment>.from(json["data"]!.map((x) => SingleComment.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}


