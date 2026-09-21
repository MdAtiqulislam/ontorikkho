// To parse this JSON data:
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  final String? msg;
  final bool? status;
  final OrderDetailsData? data;

  OrderDetailsModel({
    this.msg,
    this.status,
    this.data,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        msg: json["msg"],
        status: json["status"],
        data: json["data"] == null
            ? null
            : OrderDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class OrderDetailsData {
  final int? id;
  final int? userId;
  final int? associationId;
  final String? orderNumber;
  final String? subtotal;
  final String? discount;
  final String? deliveryCharge;
  final String? total;
  final String? orderStatus;
  final String? paymentStatus;
  final String? paymentMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Item>? items;
  final ShippingAddress? shippingAddress;

  OrderDetailsData({
    this.id,
    this.userId,
    this.associationId,
    this.orderNumber,
    this.subtotal,
    this.discount,
    this.deliveryCharge,
    this.total,
    this.orderStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
    this.items,
    this.shippingAddress,
  });

  factory OrderDetailsData.fromJson(Map<String, dynamic> json) =>
      OrderDetailsData(
        id: json["id"],
        userId: json["user_id"],
        associationId: json["association_id"],
        orderNumber: json["order_number"],
        subtotal: json["subtotal"],
        discount: json["discount"],
        deliveryCharge: json["delivery_charge"],
        total: json["total"],
        orderStatus: json["order_status"],
        paymentStatus: json["payment_status"],
        paymentMethod: json["payment_method"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        items: json["items"] == null
            ? []
            : List<Item>.from(
            json["items"]!.map((x) => Item.fromJson(x))),
        shippingAddress: json["shipping_address"] == null
            ? null
            : ShippingAddress.fromJson(json["shipping_address"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "association_id": associationId,
    "order_number": orderNumber,
    "subtotal": subtotal,
    "discount": discount,
    "delivery_charge": deliveryCharge,
    "total": total,
    "order_status": orderStatus,
    "payment_status": paymentStatus,
    "payment_method": paymentMethod,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "items":
    items == null ? [] : items!.map((x) => x.toJson()).toList(),
    "shipping_address": shippingAddress?.toJson(),
  };
}

class Item {
  final int? id;
  final int? orderId;
  final int? productId;
  final int? quantity;
  final String? color;
  final String? size;
  final String? unitPrice;
  final String? totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Product? product;

  Item({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.color,
    this.size,
    this.unitPrice,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    orderId: json["order_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    color: json["color"],
    size: json["size"],
    unitPrice: json["unit_price"],
    totalPrice: json["total_price"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    product:
    json["product"] == null ? null : Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_id": productId,
    "quantity": quantity,
    "color": color,
    "size": size,
    "unit_price": unitPrice,
    "total_price": totalPrice,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "product": product?.toJson(),
  };
}

class Product {
  final int? id;
  final dynamic associationId;
  final String? name;
  final String? description;
  final String? slug;
  final String? price;
  final String? discountPrice;
  final String? afterDiscountPrice;
  final String? discountPercentage;
  final int? productImageId;
  final dynamic sizeRange;
  final dynamic productRating;
  final int? status;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? productImage;
  final int? totalQty;

  Product({
    this.id,
    this.associationId,
    this.name,
    this.description,
    this.slug,
    this.price,
    this.discountPrice,
    this.afterDiscountPrice,
    this.discountPercentage,
    this.productImageId,
    this.sizeRange,
    this.productRating,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.productImage,
    this.totalQty,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    associationId: json["association_id"],
    name: json["name"],
    description: json["description"],
    slug: json["slug"],
    price: json["price"],
    discountPrice: json["discount_price"],
    afterDiscountPrice: json["after_discount_price"],
    discountPercentage: json["discount_percentage"],
    productImageId: json["product_image_id"],
    sizeRange: json["size_range"],
    productRating: json["product_rating"],
    status: json["status"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    productImage: json["product_image"],
    totalQty: json["total_qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "association_id": associationId,
    "name": name,
    "description": description,
    "slug": slug,
    "price": price,
    "discount_price": discountPrice,
    "after_discount_price": afterDiscountPrice,
    "discount_percentage": discountPercentage,
    "product_image_id": productImageId,
    "size_range": sizeRange,
    "product_rating": productRating,
    "status": status,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "product_image": productImage,
    "total_qty": totalQty,
  };
}

class ShippingAddress {
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

  ShippingAddress({
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

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        id: json["id"],
        orderId: json["order_id"],
        fullName: json["full_name"],
        phoneNo: json["phone_no"],
        division: json["division"],
        district: json["district"],
        thana: json["thana"],
        union: json["union"],
        streetAddress: json["street_address"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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
