// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

import '../../../../models/pagination_model.dart';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  final String? msg;
  final bool? status;
  final List<SingleNotification>? data;
  final int? unreadCount;
  final Pagination? pagination;

  NotificationsModel({
    this.msg,
    this.status,
    this.data,
    this.unreadCount,
    this.pagination,
  });

  NotificationsModel copyWith({
    String? msg,
    bool? status,
    List<SingleNotification>? data,
    int? unreadCount,
    Pagination? pagination,
  }) =>
      NotificationsModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        data: data ?? this.data,
        unreadCount: unreadCount ?? this.unreadCount,
        pagination: pagination ?? this.pagination,
      );

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleNotification>.from(json["data"]!.map((x) => SingleNotification.fromJson(x))),
    unreadCount: json["unread_count"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "unread_count": unreadCount,
    "pagination": pagination?.toJson(),
  };
}

class SingleNotification {
  final String? id;
  final String? type;
  final String? message;
  final NotificationData? data;
  final dynamic readAt;
  final DateTime? createdAt;
  final String? createdAtHuman;

  SingleNotification({
    this.id,
    this.type,
    this.message,
    this.data,
    this.readAt,
    this.createdAt,
    this.createdAtHuman,
  });

  SingleNotification copyWith({
    String? id,
    String? type,
    String? message,
    NotificationData? data,
    dynamic readAt,
    DateTime? createdAt,
    String? createdAtHuman,
  }) =>
      SingleNotification(
        id: id ?? this.id,
        type: type ?? this.type,
        message: message ?? this.message,
        data: data ?? this.data,
        readAt: readAt ?? this.readAt,
        createdAt: createdAt ?? this.createdAt,
        createdAtHuman: createdAtHuman ?? this.createdAtHuman,
      );

  factory SingleNotification.fromJson(Map<String, dynamic> json) => SingleNotification(
    id: json["id"],
    type: json["type"],
    message: json["message"],
    data: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
    readAt: json["read_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    createdAtHuman: json["created_at_human"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "message": message,
    "data": data?.toJson(),
    "read_at": readAt,
    "created_at": createdAt?.toIso8601String(),
    "created_at_human": createdAtHuman,
  };
}

class NotificationData {
  final String? type;
  final int? commentId;
  final int? postId;
  final int? userId;
  final String? userName;
  final String? message;
  final int? reactionId;
  final String? reactionType;

  NotificationData({
    this.type,
    this.commentId,
    this.postId,
    this.userId,
    this.userName,
    this.message,
    this.reactionId,
    this.reactionType,
  });

  NotificationData copyWith({
    String? type,
    int? commentId,
    int? postId,
    int? userId,
    String? userName,
    String? message,
    int? reactionId,
    String? reactionType,
  }) =>
      NotificationData(
        type: type ?? this.type,
        commentId: commentId ?? this.commentId,
        postId: postId ?? this.postId,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        message: message ?? this.message,
        reactionId: reactionId ?? this.reactionId,
        reactionType: reactionType ?? this.reactionType,
      );

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    type: json["type"],
    commentId: json["comment_id"],
    postId: json["post_id"],
    userId: json["user_id"],
    userName: json["user_name"],
    message: json["message"],
    reactionId: json["reaction_id"],
    reactionType: json["reaction_type"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "comment_id": commentId,
    "post_id": postId,
    "user_id": userId,
    "user_name": userName,
    "message": message,
    "reaction_id": reactionId,
    "reaction_type": reactionType,
  };
}


