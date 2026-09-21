// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 0;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      productId: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[2] as String,
      price: fields[3] as double,
      quantity: fields[4] as int,
      discountPrice: fields[5] as String?,
      afterDiscountPrice: fields[6] as String?,
      discountPercentage: fields[7] as String?,
      size: fields[8] as String?,
      color: fields[9] as String?,
      availableQuantity: (fields[10] ?? "0").toString(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.discountPrice)
      ..writeByte(6)
      ..write(obj.afterDiscountPrice)
      ..writeByte(7)
      ..write(obj.discountPercentage)
      ..writeByte(8)
      ..write(obj.size)
      ..writeByte(9)
      ..write(obj.color)
      ..writeByte(10)
      ..write(obj.availableQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
