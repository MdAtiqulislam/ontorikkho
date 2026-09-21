// To parse this JSON data, do
//
//     final pageImagesModel = pageImagesModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';

PageVideosModel pageVideosModelFromJson(String str) => PageVideosModel.fromJson(json.decode(str));

String pageVideosModelToJson(PageVideosModel data) => json.encode(data.toJson());

class PageVideosModel {
  final String? msg;
  final bool? status;
  final List<Media>? videoList;

  PageVideosModel({
    this.msg,
    this.status,
    this.videoList,
  });

  PageVideosModel copyWith({
    String? msg,
    bool? status,
    List<Media>? videoList,
  }) =>
      PageVideosModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        videoList: videoList ?? this.videoList,
      );

  factory PageVideosModel.fromJson(Map<String, dynamic> json) => PageVideosModel(
    msg: json["msg"],
    status: json["status"],
    videoList: json["video_list"] == null ? [] : List<Media>.from(json["video_list"]!.map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "video_list": videoList == null ? [] : List<dynamic>.from(videoList!.map((x) => x.toJson())),
  };
}


