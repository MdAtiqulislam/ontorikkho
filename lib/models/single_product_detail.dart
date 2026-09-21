class SingleProductDetail {
  final int? colorId;
  final String? colorName;
  final int? sizeId;
  final String? sizeName;
  final String? qty;

  SingleProductDetail({
    this.colorId,
    this.colorName,
    this.sizeId,
    this.sizeName,
    this.qty,
  });

  factory SingleProductDetail.fromJson(Map<String, dynamic> json) => SingleProductDetail(
    colorId: json["color_id"],
    colorName: json["color_name"],
    sizeId: json["size_id"],
    sizeName: json["size_name"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "color_id": colorId,
    "color_name": colorName,
    "size_id": sizeId,
    "size_name": sizeName,
    "qty": qty,
  };
}