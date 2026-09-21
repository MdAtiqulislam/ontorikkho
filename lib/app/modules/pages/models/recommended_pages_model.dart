import 'package:ontorikkho/app/modules/pages/models/page_model.dart';

import '../../../../models/pagination_model.dart';
import '../../friends/models/friend_basic_info_model.dart';

class RecommendedPagesModel {
  final String? msg;
  final bool? status;
  final RecommendedPagesData? data;

  const RecommendedPagesModel({
    this.msg,
    this.status,
    this.data,
  });

  factory RecommendedPagesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RecommendedPagesModel();

    return RecommendedPagesModel(
      msg: json['msg'] as String?,
      status: json['status'] as bool?,
      data: json['data'] != null
          ? RecommendedPagesData.fromJson(json['data'])
          : null,
    );
  }

  RecommendedPagesModel copyWith({
    String? msg,
    bool? status,
    RecommendedPagesData? data,
  }) {
    return RecommendedPagesModel(
      msg: msg ?? this.msg,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

class RecommendedPagesData {
  final List<PageModel> pages;
  final Pagination? pagination;

  const RecommendedPagesData({
    this.pages = const [],
    this.pagination,
  });

  factory RecommendedPagesData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RecommendedPagesData();

    return RecommendedPagesData(
      pages: (json['recommended_pages'] as List?)
          ?.map((e) => PageModel.fromJson(e))
          .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  RecommendedPagesData copyWith({
    List<PageModel>? pages,
    Pagination? pagination,
  }) {
    return RecommendedPagesData(
      pages: pages ?? this.pages,
      pagination: pagination ?? this.pagination,
    );
  }
}
