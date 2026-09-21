

import 'package:ontorikkho/app/modules/pages/models/page_data_model.dart';

import '../../friends/models/friend_basic_info_model.dart';

class PageModel {
  final PageDataModel? page;
  final int? followerCount;
  final int? mutualCount;
  final List<FriendsBasicInfoModel> mutualMembers;

  const PageModel({
    this.page,
    this.followerCount,
    this.mutualCount,
    this.mutualMembers = const [],
  });

  factory PageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PageModel();

    return PageModel(
      page: json['page'] != null
          ? PageDataModel.fromJson(json['page'])
          : null,
      followerCount: json['follower_count'] as int?,
      mutualCount: json['mutual_count'] as int?,
      mutualMembers: (json['mutual_members'] as List?)
          ?.map((e) => FriendsBasicInfoModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page?.toJson(),
      'follower_count': followerCount,
      'mutual_count': mutualCount,
      'mutual_members': mutualMembers
          .map((member) => member.toJson())
          .toList(),
    };
  }

  PageModel copyWith({
    PageDataModel? page,
    int? followerCount,
    int? mutualCount,
    List<FriendsBasicInfoModel>? mutualMembers,
  }) {
    return PageModel(
      page: page ?? this.page,
      followerCount: followerCount ?? this.followerCount,
      mutualCount: mutualCount ?? this.mutualCount,
      mutualMembers: mutualMembers ?? this.mutualMembers,
    );
  }
}