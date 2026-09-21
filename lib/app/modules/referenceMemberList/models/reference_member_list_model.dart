
import 'dart:convert';

import '../../../../models/pagination_model.dart';

ReferenceMemberListModel referenceMemberListModelFromJson(String str) => ReferenceMemberListModel.fromJson(json.decode(str));

String referenceMemberListModelToJson(ReferenceMemberListModel data) => json.encode(data.toJson());

class ReferenceMemberListModel {
  final String? msg;
  final bool? status;
  final List<SingleReferenceMember>? data;
  final Pagination? pagination;

  ReferenceMemberListModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory ReferenceMemberListModel.fromJson(Map<String, dynamic> json) => ReferenceMemberListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleReferenceMember>.from(json["data"]!.map((x) => SingleReferenceMember.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SingleReferenceMember {
  final int? id;
  final String? name;

  SingleReferenceMember({
    this.id,
    this.name,
  });

  factory SingleReferenceMember.fromJson(Map<String, dynamic> json) => SingleReferenceMember(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}


