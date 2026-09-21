// To parse this JSON data, do
//
//     final searchFriendModel = searchFriendModelFromJson(jsonString);

import 'dart:convert';

import 'package:ontorikkho/app/modules/friends/models/friend_basic_info_model.dart';

import '../../../../models/pagination_model.dart';

SearchFriendModel searchFriendModelFromJson(String str) =>
    SearchFriendModel.fromJson(json.decode(str));

String searchFriendModelToJson(SearchFriendModel data) =>
    json.encode(data.toJson());

class SearchFriendModel {
  final String? msg;
  final bool? status;
  final SearchData? data;

  SearchFriendModel({this.msg, this.status, this.data});

  SearchFriendModel copyWith({String? msg, bool? status, SearchData? data}) =>
      SearchFriendModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory SearchFriendModel.fromJson(Map<String, dynamic> json) =>
      SearchFriendModel(
        msg: json["msg"],
        status: json["status"],
        data: json["data"] == null ? null : SearchData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class SearchData {
  final List<SearchUser>? users;
  final Pagination? pagination;

  SearchData({this.users, this.pagination});

  SearchData copyWith({List<SearchUser>? users, Pagination? pagination}) =>
      SearchData(
        users: users ?? this.users,
        pagination: pagination ?? this.pagination,
      );

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    users:
        json["users"] == null
            ? []
            : List<SearchUser>.from(
              json["users"]!.map((x) => SearchUser.fromJson(x)),
            ),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "users":
        users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SearchUser {
  final FriendsBasicInfoModel? user;
  final SearchMember? member;
  final bool? isFriend;
  final int? requestId;
  final Mutual? mutual;
  final String? userRole;

  SearchUser({
    this.user,
    this.member,
    this.isFriend,
    this.mutual,
    this.userRole,
    this.requestId
  });

  SearchUser copyWith({
    FriendsBasicInfoModel? user,
    SearchMember? member,
    bool? isFriend,
    Mutual? mutual,
    String? userRole,
    int? requestId,

  }) => SearchUser(
    user: user ?? this.user,
    member: member ?? this.member,
    isFriend: isFriend ?? this.isFriend,
    mutual: mutual ?? this.mutual,
    userRole: userRole ?? this.userRole,
    requestId: requestId ?? this.requestId,
  );

  factory SearchUser.fromJson(Map<String, dynamic> json) => SearchUser(
    user:
        json["user"] == null
            ? null
            : FriendsBasicInfoModel.fromJson(json["user"]),
    member:
        json["member"] == null ? null : SearchMember.fromJson(json["member"]),
    isFriend: json["is_friend"],
    mutual: json["mutual"] == null ? null : Mutual.fromJson(json["mutual"]),
    userRole: json["user_rule"],
    requestId: json["request_id"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "member": member?.toJson(),
    "is_friend": isFriend,
    "mutual": mutual?.toJson(),
    "user_rule": userRole,
    "request_id": requestId,
  };
}

class SearchMember {
  final dynamic collegeName;
  final dynamic degree;
  final String? highestEdu;
  final dynamic educationSession;
  final dynamic occupation;
  final dynamic serviceId;

  SearchMember({
    this.collegeName,
    this.degree,
    this.highestEdu,
    this.educationSession,
    this.occupation,
    this.serviceId,
  });

  SearchMember copyWith({
    dynamic collegeName,
    dynamic degree,
    String? highestEdu,
    dynamic educationSession,
    dynamic occupation,
    dynamic serviceId,
  }) => SearchMember(
    collegeName: collegeName ?? this.collegeName,
    degree: degree ?? this.degree,
    highestEdu: highestEdu ?? this.highestEdu,
    educationSession: educationSession ?? this.educationSession,
    occupation: occupation ?? this.occupation,
    serviceId: serviceId ?? this.serviceId,
  );

  factory SearchMember.fromJson(Map<String, dynamic> json) => SearchMember(
    collegeName: json["college_name"],
    degree: json["degree"],
    highestEdu: json["highest_edu"],
    educationSession: json["education_session"],
    occupation: json["occupation"],
    serviceId: json["service_id"],
  );

  Map<String, dynamic> toJson() => {
    "college_name": collegeName,
    "degree": degree,
    "highest_edu": highestEdu,
    "education_session": educationSession,
    "occupation": occupation,
    "service_id": serviceId,
  };
}

class Mutual {
  final int? mutualCount;
  final List<FriendsBasicInfoModel>? mutualMembers;

  Mutual({this.mutualCount, this.mutualMembers});

  Mutual copyWith({
    int? mutualCount,
    List<FriendsBasicInfoModel>? mutualMembers,
  }) => Mutual(
    mutualCount: mutualCount ?? this.mutualCount,
    mutualMembers: mutualMembers ?? this.mutualMembers,
  );

  factory Mutual.fromJson(Map<String, dynamic> json) => Mutual(
    mutualCount: json["mutual_count"],
    mutualMembers:
        json["mutual_members"] == null
            ? []
            : List<FriendsBasicInfoModel>.from(
              json["mutual_members"]!.map(
                (x) => FriendsBasicInfoModel.fromJson(x),
              ),
            ),
  );

  Map<String, dynamic> toJson() => {
    "mutual_count": mutualCount,
    "mutual_members":
        mutualMembers == null
            ? []
            : List<dynamic>.from(mutualMembers!.map((x) => x.toJson())),
  };
}
