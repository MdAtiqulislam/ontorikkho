// To parse this JSON data, do
//
//     final productDetailsModel = productDetailsModelFromJson(jsonString);

import 'dart:convert';

ProductDetailsModel productDetailsModelFromJson(String str) => ProductDetailsModel.fromJson(json.decode(str));

String productDetailsModelToJson(ProductDetailsModel data) => json.encode(data.toJson());

class ProductDetailsModel {
  final String? msg;
  final bool? status;
  final ProductDetailsData? data;

  ProductDetailsModel({
    this.msg,
    this.status,
    this.data,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) => ProductDetailsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : ProductDetailsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class ProductDetailsData {
  final int? id;
  final String? name;
  final String? description;
  final String? price;
  final String? discountPrice;
  final String? afterDiscountPrice;
  final String? discountPercentage;
  final dynamic productRating;
  final String? productImage;
  final int? totalQty;
  final List<ColorGroup>? productDetails;

  ProductDetailsData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discountPrice,
    this.afterDiscountPrice,
    this.discountPercentage,
    this.productRating,
    this.productImage,
    this.totalQty,
    this.productDetails,
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) => ProductDetailsData(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    discountPrice: json["discount_price"],
    afterDiscountPrice: json["after_discount_price"],
    discountPercentage: json["discount_percentage"],
    productRating: json["product_rating"],
    productImage: json["product_image"],
    totalQty: json["total_qty"],
    productDetails: json["product_details"] == null ? [] : List<ColorGroup>.from(json["product_details"]!.map((x) => ColorGroup.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "discount_price": discountPrice,
    "after_discount_price": afterDiscountPrice,
    "discount_percentage": discountPercentage,
    "product_rating": productRating,
    "product_image": productImage,
    "total_qty": totalQty,
    "product_details": productDetails == null ? [] : List<dynamic>.from(productDetails!.map((x) => x.toJson())),
  };
}

class ColorGroup {
  final int? colorId;
  final String? colorName;
  final List<Size>? sizes;

  ColorGroup({
    this.colorId,
    this.colorName,
    this.sizes,
  });

  factory ColorGroup.fromJson(Map<String, dynamic> json) => ColorGroup(
    colorId: json["color_id"],
    colorName: json["color_name"],
    sizes: json["sizes"] == null ? [] : List<Size>.from(json["sizes"]!.map((x) => Size.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "color_id": colorId,
    "color_name": colorName,
    "sizes": sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x.toJson())),
  };
}

class Size {
  final int? sizeId;
  final String? sizeName;
  final String? qty;

  Size({
    this.sizeId,
    this.sizeName,
    this.qty,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    sizeId: json["size_id"],
    sizeName: json["size_name"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "size_id": sizeId,
    "size_name": sizeName,
    "qty": qty,
  };
}
