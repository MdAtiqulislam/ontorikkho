
import 'dart:convert';

import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';

import '../../../../models/pagination_model.dart';

MyFriendsModel myFriendsModelFromJson(String str) => MyFriendsModel.fromJson(json.decode(str));

String myFriendsModelToJson(MyFriendsModel data) => json.encode(data.toJson());

class MyFriendsModel {
  final String? msg;
  final bool? status;
  final MyFriendsData? data;

  MyFriendsModel({
    this.msg,
    this.status,
    this.data,
  });

  MyFriendsModel copyWith({
    String? msg,
    bool? status,
    MyFriendsData? data,
  }) =>
      MyFriendsModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory MyFriendsModel.fromJson(Map<String, dynamic> json) => MyFriendsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : MyFriendsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class MyFriendsData {
  final List<FriendsBasicInfoModel>? friends;
  final Pagination? pagination;

  MyFriendsData({
    this.friends,
    this.pagination,
  });

  MyFriendsData copyWith({
    List<FriendsBasicInfoModel>? friends,
    Pagination? pagination,
  }) =>
      MyFriendsData(
        friends: friends ?? this.friends,
        pagination: pagination ?? this.pagination,
      );

  factory MyFriendsData.fromJson(Map<String, dynamic> json) => MyFriendsData(
    friends: json["friends"] == null ? [] : List<FriendsBasicInfoModel>.from(json["friends"]!.map((x) => FriendsBasicInfoModel.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "friends": friends == null ? [] : List<dynamic>.from(friends!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

