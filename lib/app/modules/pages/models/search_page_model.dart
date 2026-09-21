// To parse this JSON data, do
//
//     final searchPageModel = searchPageModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/pages/models/page_model.dart';

import '../../../../models/pagination_model.dart';

SearchPageModel searchPageModelFromJson(String str) => SearchPageModel.fromJson(json.decode(str));

String searchPageModelToJson(SearchPageModel data) => json.encode(data.toJson());

class SearchPageModel {
  final String? msg;
  final bool? status;
  final SearchPageData? data;

  SearchPageModel({
    this.msg,
    this.status,
    this.data,
  });

  SearchPageModel copyWith({
    String? msg,
    bool? status,
    SearchPageData? data,
  }) =>
      SearchPageModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory SearchPageModel.fromJson(Map<String, dynamic> json) => SearchPageModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : SearchPageData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class SearchPageData {
  final List<PageModel>? pages;
  final Pagination? pagination;

  SearchPageData({
    this.pages,
    this.pagination,
  });

  SearchPageData copyWith({
    List<PageModel>? pages,
    Pagination? pagination,
  }) =>
      SearchPageData(
        pages: pages ?? this.pages,
        pagination: pagination ?? this.pagination,
      );

  factory SearchPageData.fromJson(Map<String, dynamic> json) => SearchPageData(
    pages: json["pages"] == null ? [] : List<PageModel>.from(json["pages"]!.map((x) => PageModel.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "pages": pages == null ? [] : List<dynamic>.from(pages!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}


