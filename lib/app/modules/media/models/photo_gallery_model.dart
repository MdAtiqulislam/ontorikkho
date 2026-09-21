// To parse this JSON data, do
//
//     final photoGalleryModel = photoGalleryModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';

PhotoGalleryModel photoGalleryModelFromJson(String str) => PhotoGalleryModel.fromJson(json.decode(str));

String photoGalleryModelToJson(PhotoGalleryModel data) => json.encode(data.toJson());

class PhotoGalleryModel {
  final String? msg;
  final bool? status;
  final List<SingleImage>? data;
  final Pagination? pagination;

  PhotoGalleryModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory PhotoGalleryModel.fromJson(Map<String, dynamic> json) => PhotoGalleryModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleImage>.from(json["data"]!.map((x) => SingleImage.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SingleImage {
  final int? id;
  final String? photo;

  SingleImage({
    this.id,
    this.photo,
  });

  factory SingleImage.fromJson(Map<String, dynamic> json) => SingleImage(
    id: json["id"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
  };
}


