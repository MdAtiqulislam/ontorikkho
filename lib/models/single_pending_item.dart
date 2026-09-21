
class SinglePendingItem {
  final int? id;
  final String? name;
  final String? profileImage;

  SinglePendingItem({
    this.id,
    this.name,
    this.profileImage,
  });

  factory SinglePendingItem.fromJson(Map<String, dynamic> json) => SinglePendingItem(
    id: json["id"],
    name: json["name"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile_image": profileImage,
  };
}