// To parse this JSON data, do
//
//     final pageCategoryModel = pageCategoryModelFromJson(jsonString);

import 'dart:convert';

PageCategoryModel pageCategoryModelFromJson(String str) => PageCategoryModel.fromJson(json.decode(str));

String pageCategoryModelToJson(PageCategoryModel data) => json.encode(data.toJson());

class PageCategoryModel {
  final String? msg;
  final bool? status;
  final PageCategoryData? data;

  PageCategoryModel({
    this.msg,
    this.status,
    this.data,
  });

  PageCategoryModel copyWith({
    String? msg,
    bool? status,
    PageCategoryData? data,
  }) =>
      PageCategoryModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory PageCategoryModel.fromJson(Map<String, dynamic> json) => PageCategoryModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : PageCategoryData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class PageCategoryData {
  final String? pageType;
  final bool? categoryRequired;
  final List<PageCategory>? categories;

  PageCategoryData({
    this.pageType,
    this.categoryRequired,
    this.categories,
  });

  PageCategoryData copyWith({
    String? pageType,
    bool? categoryRequired,
    List<PageCategory>? categories,
  }) =>
      PageCategoryData(
        pageType: pageType ?? this.pageType,
        categoryRequired: categoryRequired ?? this.categoryRequired,
        categories: categories ?? this.categories,
      );

  factory PageCategoryData.fromJson(Map<String, dynamic> json) => PageCategoryData(
    pageType: json["page_type"],
    categoryRequired: json["category_required"],
    categories: json["categories"] == null ? [] : List<PageCategory>.from(json["categories"]!.map((x) => PageCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "page_type": pageType,
    "category_required": categoryRequired,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
}

class PageCategory {
  final int? id;
  final String? name;
  final String? slug;
  final String? section;
  final int? parentId;
  final String? parentName;
  final String? label;

  PageCategory({
    this.id,
    this.name,
    this.slug,
    this.section,
    this.parentId,
    this.parentName,
    this.label,
  });

  PageCategory copyWith({
    int? id,
    String? name,
    String? slug,
    String? section,
    int? parentId,
    String? parentName,
    String? label,
  }) =>
      PageCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        section: section ?? this.section,
        parentId: parentId ?? this.parentId,
        parentName: parentName ?? this.parentName,
        label: label ?? this.label,
      );

  factory PageCategory.fromJson(Map<String, dynamic> json) => PageCategory(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    section: json["section"],
    parentId: json["parent_id"],
    parentName: json["parent_name"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "section": section,
    "parent_id": parentId,
    "parent_name": parentName,
    "label": label,
  };
}


