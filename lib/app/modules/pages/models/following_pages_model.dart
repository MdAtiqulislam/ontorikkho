import 'package:ontorikkho/app/modules/pages/models/page_model.dart';

import '../../../../models/pagination_model.dart';


class FollowingPagesModel {
  final String? msg;
  final bool? status;
  final FollowingPagesData? data;

  const FollowingPagesModel({
    this.msg,
    this.status,
    this.data,
  });

  factory FollowingPagesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FollowingPagesModel();

    return FollowingPagesModel(
      msg: json['msg'] as String?,
      status: json['status'] as bool?,
      data: json['data'] != null
          ? FollowingPagesData.fromJson(json['data'])
          : null,
    );
  }

  FollowingPagesModel copyWith({
    String? msg,
    bool? status,
    FollowingPagesData? data,
  }) {
    return FollowingPagesModel(
      msg: msg ?? this.msg,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

class FollowingPagesData {
  final List<PageModel> pages;
  final Pagination? pagination;

  const FollowingPagesData({
    this.pages = const [],
    this.pagination,
  });

  factory FollowingPagesData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FollowingPagesData();

    return FollowingPagesData(
      pages: (json['following_pages'] as List?)
          ?.map((e) => PageModel.fromJson(e))
          .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  FollowingPagesData copyWith({
    List<PageModel>? pages,
    Pagination? pagination,
  }) {
    return FollowingPagesData(
      pages: pages ?? this.pages,
      pagination: pagination ?? this.pagination,
    );
  }
}
