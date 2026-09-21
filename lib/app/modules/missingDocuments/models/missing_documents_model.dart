// To parse this JSON data, do
//
//     final missingDocumentsModel = missingDocumentsModelFromJson(jsonString);

import 'dart:convert';

MissingDocumentsModel missingDocumentsModelFromJson(String str) => MissingDocumentsModel.fromJson(json.decode(str));

String missingDocumentsModelToJson(MissingDocumentsModel data) => json.encode(data.toJson());

class MissingDocumentsModel {
  final String? msg;
  final bool? status;
  final List<SingleMissingDocument>? data;

  MissingDocumentsModel({
    this.msg,
    this.status,
    this.data,
  });

  factory MissingDocumentsModel.fromJson(Map<String, dynamic> json) => MissingDocumentsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleMissingDocument>.from(json["data"]!.map((x) => SingleMissingDocument.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleMissingDocument {
  final int? id;
  final int? associationId;
  final int? memberId;
  final String? name;
  final dynamic documentMediaId;
  final int? addedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? adminStatus;
  final int? documentId;
  final String? documentName;

  SingleMissingDocument({
    this.id,
    this.associationId,
    this.memberId,
    this.name,
    this.documentMediaId,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
    this.adminStatus,
    this.documentId,
    this.documentName,
  });

  factory SingleMissingDocument.fromJson(Map<String, dynamic> json) => SingleMissingDocument(
    id: json["id"],
    associationId: json["association_id"],
    memberId: json["member_id"],
    name: json["name"],
    documentMediaId: json["document_media_id"],
    addedBy: json["added_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    adminStatus: json["admin_status"],
    documentId: json["document_id"],
    documentName: json["document_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "association_id": associationId,
    "member_id": memberId,
    "name": name,
    "document_media_id": documentMediaId,
    "added_by": addedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "admin_status": adminStatus,
    "document_id": documentId,
    "document_name": documentName,
  };
}
