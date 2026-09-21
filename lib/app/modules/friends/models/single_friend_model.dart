import 'friend_basic_info_model.dart';

class SingleFriendModel {
  final int? id;
  final FriendsBasicInfoModel? user;
  final String? createdAt;
  final int? mutualCount;
  final List<FriendsBasicInfoModel>? mutualMembers;

  SingleFriendModel({
    this.id,
    this.user,
    this.createdAt,
    this.mutualCount,
    this.mutualMembers,
  });

  SingleFriendModel copyWith({
    int? id,
    FriendsBasicInfoModel? user,
    String? createdAt,
    int? mutualCount,
    List<FriendsBasicInfoModel>? mutualMembers,
  }) =>
      SingleFriendModel(
        id: id ?? this.id,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        mutualCount: mutualCount ?? this.mutualCount,
        mutualMembers: mutualMembers ?? this.mutualMembers,
      );

  factory SingleFriendModel.fromJson(Map<String, dynamic> json) => SingleFriendModel(
    id: json["id"],
    user: json["user"] == null ? null : FriendsBasicInfoModel.fromJson(json["user"]),
    createdAt: json["created_at"],
    mutualCount: json["mutual_count"],
    mutualMembers: json["mutual_members"] == null ? [] : List<FriendsBasicInfoModel>.from(json["mutual_members"]!.map((x) => FriendsBasicInfoModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "created_at": createdAt,
    "mutual_count": mutualCount,
    "mutual_members": mutualMembers == null ? [] : List<dynamic>.from(mutualMembers!.map((x) => x.toJson())),
  };
}