// To parse this JSON data, do
//
//     final partnersModel = partnersModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/models/pagination_model.dart';

PartnersModel partnersModelFromJson(String str) => PartnersModel.fromJson(json.decode(str));

String partnersModelToJson(PartnersModel data) => json.encode(data.toJson());

class PartnersModel {
  final String? msg;
  final bool? status;
  final List<SinglePartner>? data;
  final Pagination? pagination;

  PartnersModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory PartnersModel.fromJson(Map<String, dynamic> json) => PartnersModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SinglePartner>.from(json["data"]!.map((x) => SinglePartner.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SinglePartner {
  final int? id;
  final String? partnerLogo;
  final String? partnerName;
  final String? description;
  final String? specialOffers;
  final String? createdBy;
  final int? status;

  SinglePartner({
    this.id,
    this.partnerLogo,
    this.partnerName,
    this.description,
    this.specialOffers,
    this.createdBy,
    this.status,
  });

  factory SinglePartner.fromJson(Map<String, dynamic> json) => SinglePartner(
    id: json["id"],
    partnerLogo: json["partner_logo"],
    partnerName: json["partner_name"],
    description: json["description"],
    specialOffers: json["special_offers"],
    createdBy: json["created_by"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "partner_logo": partnerLogo,
    "partner_name": partnerName,
    "description": description,
    "special_offers": specialOffers,
    "created_by": createdBy,
    "status": status,
  };
}


