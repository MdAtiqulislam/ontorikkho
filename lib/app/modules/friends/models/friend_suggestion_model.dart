// To parse this JSON data, do
//
//     final friendSuggestionModel = friendSuggestionModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/friends/models/friend_request_incoming_model.dart';
import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';
import 'package:ontorikkho/app/modules/friends/models/single_friend_model.dart';

FriendSuggestionModel friendSuggestionModelFromJson(String str) => FriendSuggestionModel.fromJson(json.decode(str));

String friendSuggestionModelToJson(FriendSuggestionModel data) => json.encode(data.toJson());

class FriendSuggestionModel {
  final String? msg;
  final bool? status;
  final SuggestionData? data;

  FriendSuggestionModel({
    this.msg,
    this.status,
    this.data,
  });

  FriendSuggestionModel copyWith({
    String? msg,
    bool? status,
    SuggestionData? data,
  }) =>
      FriendSuggestionModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory FriendSuggestionModel.fromJson(Map<String, dynamic> json) => FriendSuggestionModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : SuggestionData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class SuggestionData {
  final List<SingleFriendModel>? suggestions;

  SuggestionData({
    this.suggestions,
  });

  SuggestionData copyWith({
    List<SingleFriendModel>? suggestions,
  }) =>
      SuggestionData(
        suggestions: suggestions ?? this.suggestions,
      );

  factory SuggestionData.fromJson(Map<String, dynamic> json) => SuggestionData(
    suggestions: json["suggestions"] == null ? [] : List<SingleFriendModel>.from(json["suggestions"]!.map((x) => SingleFriendModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "suggestions": suggestions == null ? [] : List<dynamic>.from(suggestions!.map((x) => x.toJson())),
  };
}

class FriendSuggestion {
  final FriendsBasicInfoModel? user;
  final int? mutualCount;
  final List<FriendsBasicInfoModel>? mutualMembers;

  FriendSuggestion({
    this.user,
    this.mutualCount,
    this.mutualMembers,
  });

  FriendSuggestion copyWith({
    FriendsBasicInfoModel? user,
    int? mutualCount,
    List<FriendsBasicInfoModel>? mutualMembers,
  }) =>
      FriendSuggestion(
        user: user ?? this.user,
        mutualCount: mutualCount ?? this.mutualCount,
        mutualMembers: mutualMembers ?? this.mutualMembers,
      );

  factory FriendSuggestion.fromJson(Map<String, dynamic> json) => FriendSuggestion(
    user: json["user"] == null ? null : FriendsBasicInfoModel.fromJson(json["user"]),
    mutualCount: json["mutual_count"],
    mutualMembers: json["mutual_members"] == null ? [] : List<FriendsBasicInfoModel>.from(json["mutual_members"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "mutual_count": mutualCount,
    "mutual_members": mutualMembers == null ? [] : List<FriendsBasicInfoModel>.from(mutualMembers!.map((x) => x)),
  };
}


