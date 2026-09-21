// To parse this JSON data, do
//
//     final orderHistoryModel = orderHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) => OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) => json.encode(data.toJson());

class OrderHistoryModel {
  final String? msg;
  final bool? status;
  final List<SingleOrderHistory>? data;

  OrderHistoryModel({
    this.msg,
    this.status,
    this.data,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) => OrderHistoryModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleOrderHistory>.from(json["data"]!.map((x) => SingleOrderHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleOrderHistory {
  final int? id;
  final int? userId;
  final String? subtotal;
  final String? discount;
  final String? deliveryCharge;
  final String? total;
  final String? orderStatus;
  final String? paymentStatus;
  final String? paymentMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SingleOrderHistory({
    this.id,
    this.userId,
    this.subtotal,
    this.discount,
    this.deliveryCharge,
    this.total,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleOrderHistory.fromJson(Map<String, dynamic> json) => SingleOrderHistory(
    id: json["id"],
    userId: json["user_id"],
    subtotal: json["subtotal"],
    discount: json["discount"],
    deliveryCharge: json["delivery_charge"],
    total: json["total"],
    orderStatus: json["order_status"],
    paymentStatus: json["payment_status"],
    paymentMethod: json["payment_method"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "subtotal": subtotal,
    "discount": discount,
    "delivery_charge": deliveryCharge,
    "total": total,
    "order_status": orderStatus,
    "payment_status": paymentStatus,
    "payment_method": paymentMethod,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
