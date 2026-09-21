// To parse this JSON data, do
//
//     final lastShippingAddressModel = lastShippingAddressModelFromJson(jsonString);

import 'dart:convert';

LastShippingAddressModel lastShippingAddressModelFromJson(String str) => LastShippingAddressModel.fromJson(json.decode(str));

String lastShippingAddressModelToJson(LastShippingAddressModel data) => json.encode(data.toJson());

class LastShippingAddressModel {
  final String? msg;
  final bool? status;
  final ShippingAddressData? data;

  LastShippingAddressModel({
    this.msg,
    this.status,
    this.data,
  });

  factory LastShippingAddressModel.fromJson(Map<String, dynamic> json) => LastShippingAddressModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : ShippingAddressData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class ShippingAddressData {
  final int? id;
  final int? orderId;
  final String? fullName;
  final String? phoneNo;
  final String? division;
  final String? district;
  final String? thana;
  final dynamic union;
  final String? streetAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShippingAddressData({
    this.id,
    this.orderId,
    this.fullName,
    this.phoneNo,
    this.division,
    this.district,
    this.thana,
    this.union,
    this.streetAddress,
    this.createdAt,
    this.updatedAt,
  });

  factory ShippingAddressData.fromJson(Map<String, dynamic> json) => ShippingAddressData(
    id: json["id"],
    orderId: json["order_id"],
    fullName: json["full_name"],
    phoneNo: json["phone_no"],
    division: json["division"],
    district: json["district"],
    thana: json["thana"],
    union: json["union"],
    streetAddress: json["street_address"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "full_name": fullName,
    "phone_no": phoneNo,
    "division": division,
    "district": district,
    "thana": thana,
    "union": union,
    "street_address": streetAddress,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
