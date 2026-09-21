import 'package:hive/hive.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final double price;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  final String? discountPrice;

  @HiveField(6)
  final String? afterDiscountPrice;

  @HiveField(7)
  final String? discountPercentage;

  @HiveField(8)
  final String? size;

  @HiveField(9)
  final String? color;

  @HiveField(10)
  final String availableQuantity; // ⬅️ String type

  CartItemModel({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.discountPrice,
    this.afterDiscountPrice,
    this.discountPercentage,
    this.size,
    this.color,
    required this.availableQuantity, // default large stock
  });
}
