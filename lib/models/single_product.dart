import 'package:ontorikkho/models/single_product_detail.dart';

class SingleProduct {
  final int? id;
  final String? name;
  final String? description;
  final String? price;
  final String? discountPrice;
  final String? afterDiscountPrice;
  final String? discountPercentage;
  final dynamic productRating;
  final String? productImage;
  final List<SingleProductDetail>? productDetails;

  SingleProduct({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discountPrice,
    this.afterDiscountPrice,
    this.discountPercentage,
    this.productRating,
    this.productImage,
    this.productDetails,
  });

  factory SingleProduct.fromJson(Map<String, dynamic> json) => SingleProduct(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    discountPrice: json["discount_price"],
    afterDiscountPrice: json["after_discount_price"],
    discountPercentage: json["discount_percentage"],
    productRating: json["product_rating"],
    productImage: json["product_image"],
    productDetails: json["product_details"] == null ? [] : List<SingleProductDetail>.from(json["product_details"]!.map((x) => SingleProductDetail.fromJson(x))),
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
    "product_details": productDetails == null ? [] : List<dynamic>.from(productDetails!.map((x) => x.toJson())),
  };
}