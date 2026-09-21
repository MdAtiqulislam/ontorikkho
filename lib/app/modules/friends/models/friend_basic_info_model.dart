class FriendsBasicInfoModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? avatar;
  final String? friendshipStatus;

  FriendsBasicInfoModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.avatar,
    this.friendshipStatus,
  });

  FriendsBasicInfoModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? avatar,
    String? friendshipStatus,
  }) =>
      FriendsBasicInfoModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        avatar: avatar ?? this.avatar,
        friendshipStatus: friendshipStatus ?? this.friendshipStatus,
      );

  factory FriendsBasicInfoModel.fromJson(Map<String, dynamic> json) => FriendsBasicInfoModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    avatar: json["avatar"],
    friendshipStatus: json["friendship_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "avatar": avatar,
    "friendship_status": friendshipStatus,
  };
}