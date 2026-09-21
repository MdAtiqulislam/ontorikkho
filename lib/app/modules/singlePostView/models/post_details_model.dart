// To parse this JSON data, do
//
//     final postDetailsModel = postDetailsModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';

PostDetailsModel postDetailsModelFromJson(String str) => PostDetailsModel.fromJson(json.decode(str));

String postDetailsModelToJson(PostDetailsModel data) => json.encode(data.toJson());

class PostDetailsModel {
  final String? msg;
  final bool? status;
  final SinglePostModel? data;

  PostDetailsModel({
    this.msg,
    this.status,
    this.data,
  });

  PostDetailsModel copyWith({
    String? msg,
    bool? status,
    SinglePostModel? data,
  }) =>
      PostDetailsModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory PostDetailsModel.fromJson(Map<String, dynamic> json) => PostDetailsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["post"] == null ? null : SinglePostModel.fromJson(json["post"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "post": data?.toJson(),
  };
}


