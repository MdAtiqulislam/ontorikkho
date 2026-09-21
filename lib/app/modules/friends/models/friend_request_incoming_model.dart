// To parse this JSON data, do
//
//     final friendRequestIncomingModel = friendRequestIncomingModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/models/single_friend_model.dart';

FriendRequestIncomingModel friendRequestIncomingModelFromJson(String str) => FriendRequestIncomingModel.fromJson(json.decode(str));

String friendRequestIncomingModelToJson(FriendRequestIncomingModel data) => json.encode(data.toJson());

class FriendRequestIncomingModel {
  final String? msg;
  final bool? status;
  final IncomingRequestData? data;

  FriendRequestIncomingModel({
    this.msg,
    this.status,
    this.data,
  });

  FriendRequestIncomingModel copyWith({
    String? msg,
    bool? status,
    IncomingRequestData? data,
  }) =>
      FriendRequestIncomingModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory FriendRequestIncomingModel.fromJson(Map<String, dynamic> json) => FriendRequestIncomingModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : IncomingRequestData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class IncomingRequestData {
  final List<SingleFriendModel>? requests;

  IncomingRequestData({
    this.requests,
  });

  IncomingRequestData copyWith({
    List<SingleFriendModel>? requests,
  }) =>
      IncomingRequestData(
        requests: requests ?? this.requests,
      );

  factory IncomingRequestData.fromJson(Map<String, dynamic> json) => IncomingRequestData(
    requests: json["requests"] == null ? [] : List<SingleFriendModel>.from(json["requests"]!.map((x) => SingleFriendModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "requests": requests == null ? [] : List<dynamic>.from(requests!.map((x) => x.toJson())),
  };
}




