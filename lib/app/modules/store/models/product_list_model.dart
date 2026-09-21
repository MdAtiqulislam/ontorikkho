/*

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';

import '../../../../models/single_product.dart';

ProductListModel productListModelModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
  final String? msg;
  final bool? status;
  final List<SingleProduct>? data;
  final PaginationModel? pagination;

  ProductListModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleProduct>.from(json["data"]!.map((x) => SingleProduct.fromJson(x))),
    pagination: json["pagination"] == null ? null : PaginationModel.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}


*/



// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';

import '../../../../models/single_product.dart';

ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
  final String? msg;
  final bool? status;
  final ProductListData? data;
  final Pagination? pagination;

  ProductListModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : ProductListData.fromJson(json["data"]),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
    "pagination": pagination?.toJson(),
  };
}

class ProductListData {
  final int? currentPage;
  final List<SingleProduct>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  //final List<Link>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  ProductListData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
   // this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) => ProductListData(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<SingleProduct>.from(json["data"]!.map((x) => SingleProduct.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
   // links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<SingleProduct>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
   // "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}




