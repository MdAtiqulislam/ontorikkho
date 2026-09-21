// To parse this JSON data, do
//
//     final videoGalleryModel = videoGalleryModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';

VideoGalleryModel videoGalleryModelFromJson(String str) => VideoGalleryModel.fromJson(json.decode(str));

String videoGalleryModelToJson(VideoGalleryModel data) => json.encode(data.toJson());

class VideoGalleryModel {
  final String? msg;
  final bool? status;
  final List<SingleVideo>? data;
  final Pagination? pagination;

  VideoGalleryModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory VideoGalleryModel.fromJson(Map<String, dynamic> json) => VideoGalleryModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleVideo>.from(json["data"]!.map((x) => SingleVideo.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SingleVideo {
  final int? id;
  final String? videoType;
  final dynamic videoFile;
  final String? youtubeLink;
  final dynamic thumbnail;

  SingleVideo({
    this.id,
    this.videoType,
    this.videoFile,
    this.youtubeLink,
    this.thumbnail,
  });

  factory SingleVideo.fromJson(Map<String, dynamic> json) => SingleVideo(
    id: json["id"],
    videoType: json["video_type"],
    videoFile: json["video_file"],
    youtubeLink: json["youtube_link"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video_type": videoType,
    "video_file": videoFile,
    "youtube_link": youtubeLink,
    "thumbnail": thumbnail,
  };
}


