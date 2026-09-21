
import 'dart:convert';

import 'package:ontorikkho/app/modules/pages/models/page_model.dart';

import '../../../../models/pagination_model.dart';

MyPagesModel myPagesModelFromJson(String str) => MyPagesModel.fromJson(json.decode(str));

String myPagesModelToJson(MyPagesModel data) => json.encode(data.toJson());

class MyPagesModel {
  final String? msg;
  final bool? status;
  final MyPagesData? data;

  MyPagesModel({
    this.msg,
    this.status,
    this.data,
  });

  MyPagesModel copyWith({
    String? msg,
    bool? status,
    MyPagesData? data,
  }) =>
      MyPagesModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory MyPagesModel.fromJson(Map<String, dynamic> json) => MyPagesModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : MyPagesData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class MyPagesData {
  final List<PageModel>? myPages;
  final Pagination? pagination;

  MyPagesData({
    this.myPages,
    this.pagination,
  });

  MyPagesData copyWith({
    List<PageModel>? myPages,
    Pagination? pagination,
  }) =>
      MyPagesData(
        myPages: myPages ?? this.myPages,
        pagination: pagination ?? this.pagination,
      );

  factory MyPagesData.fromJson(Map<String, dynamic> json) => MyPagesData(
    myPages: json["my_pages"] == null ? [] : List<PageModel>.from(json["my_pages"]!.map((x) => PageModel.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "my_pages": myPages == null ? [] : List<dynamic>.from(myPages!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

