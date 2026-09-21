// To parse this JSON data, do
//
//     final pageImagesModel = pageImagesModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';

PageImagesModel pageImagesModelFromJson(String str) => PageImagesModel.fromJson(json.decode(str));

String pageImagesModelToJson(PageImagesModel data) => json.encode(data.toJson());

class PageImagesModel {
  final String? msg;
  final bool? status;
  final List<Media>? photoList;

  PageImagesModel({
    this.msg,
    this.status,
    this.photoList,
  });

  PageImagesModel copyWith({
    String? msg,
    bool? status,
    List<Media>? photoList,
  }) =>
      PageImagesModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        photoList: photoList ?? this.photoList,
      );

  factory PageImagesModel.fromJson(Map<String, dynamic> json) => PageImagesModel(
    msg: json["msg"],
    status: json["status"],
    photoList: json["photo_list"] == null ? [] : List<Media>.from(json["photo_list"]!.map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "photo_list": photoList == null ? [] : List<dynamic>.from(photoList!.map((x) => x.toJson())),
  };
}


