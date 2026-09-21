import 'package:ontorikkho/app/modules/pages/models/page_model.dart';

import '../../../../models/pagination_model.dart';


class InvitedPagesModel {
  final String? msg;
  final bool? status;
  final InvitedPagesData? data;

  const InvitedPagesModel({
    this.msg,
    this.status,
    this.data,
  });

  factory InvitedPagesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const InvitedPagesModel();

    return InvitedPagesModel(
      msg: json['msg'] as String?,
      status: json['status'] as bool?,
      data: json['data'] != null
          ? InvitedPagesData.fromJson(json['data'])
          : null,
    );
  }

  InvitedPagesModel copyWith({
    String? msg,
    bool? status,
    InvitedPagesData? data,
  }) {
    return InvitedPagesModel(
      msg: msg ?? this.msg,
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}

class InvitedPagesData {
  final List<PageModel> pages;
  final Pagination? pagination;

  const InvitedPagesData({
    this.pages = const [],
    this.pagination,
  });

  factory InvitedPagesData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const InvitedPagesData();

    return InvitedPagesData(
      pages: (json['invitations'] as List?)
          ?.map((e) => PageModel.fromJson(e))
          .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  InvitedPagesData copyWith({
    List<PageModel>? pages,
    Pagination? pagination,
  }) {
    return InvitedPagesData(
      pages: pages ?? this.pages,
      pagination: pagination ?? this.pagination,
    );
  }
}
