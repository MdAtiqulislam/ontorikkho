
import 'dart:convert';
import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';
import '../../../../models/pagination_model.dart';
import '../../forYou/models/posts_model.dart';
import '../../friends/models/friend_basic_info_model.dart';

PageDetailsModel pageDetailsModelFromJson(String str) => PageDetailsModel.fromJson(json.decode(str));
String pageDetailsModelToJson(PageDetailsModel data) => json.encode(data.toJson());

class PageDetailsModel {
  final String? msg;
  final bool? status;
  final PageDetailsData? data;

  PageDetailsModel({
    this.msg,
    this.status,
    this.data,
  });

  PageDetailsModel copyWith({
    String? msg,
    bool? status,
    PageDetailsData? data,
  }) =>
      PageDetailsModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory PageDetailsModel.fromJson(Map<String, dynamic> json) => PageDetailsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : PageDetailsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class PageDetailsData {
  final PageDataModel? page;
  final int? followerCount;
  final int? mutualCount;
  final List<FriendsBasicInfoModel>? mutualMembers;
  final List<SinglePostModel>? posts;
  final Pagination? pagination;

  PageDetailsData({
    this.page,
    this.followerCount,
    this.mutualCount,
    this.mutualMembers,
    this.posts,
    this.pagination,
  });

  PageDetailsData copyWith({
    PageDataModel? page,
    int? followerCount,
    int? mutualCount,
    List<FriendsBasicInfoModel>? mutualMembers,
    List<SinglePostModel>? posts,
    Pagination? pagination,
  }) =>
      PageDetailsData(
        page: page ?? this.page,
        followerCount: followerCount ?? this.followerCount,
        mutualCount: mutualCount ?? this.mutualCount,
        mutualMembers: mutualMembers ?? this.mutualMembers,
        posts: posts ?? this.posts,
        pagination: pagination ?? this.pagination,
      );

  factory PageDetailsData.fromJson(Map<String, dynamic> json) => PageDetailsData(
    page: json["page"] == null ? null : PageDataModel.fromJson(json["page"]),
    followerCount: json["follower_count"],
    mutualCount: json["mutual_count"],
    mutualMembers: json["mutual_members"] == null ? [] : List<FriendsBasicInfoModel>.from(json["mutual_members"]!.map((x) => FriendsBasicInfoModel.fromJson(x))),
    posts: json["posts"] == null ? [] : List<SinglePostModel>.from(json["posts"]!.map((x) => SinglePostModel.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "page": page?.toJson(),
    "follower_count": followerCount,
    "mutual_count": mutualCount,
    "mutual_members": mutualMembers == null ? [] : List<FriendsBasicInfoModel>.from(mutualMembers!.map((x) => x)),
    "posts": posts == null ? [] : List<SinglePostModel>.from(posts!.map((x) => x)),
    "pagination": pagination?.toJson(),
  };
}



