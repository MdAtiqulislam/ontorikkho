import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';

class SingleComment {
  final int? id;
  final String? content;
  final List<Media>? media;
  final User? user;
  final String? createdAt;
  final bool? canDelete;
  final List<SingleComment>? replies;

  SingleComment({
    this.id,
    this.content,
    this.media,
    this.user,
    this.createdAt,
    this.canDelete,
    this.replies,
  });

  SingleComment copyWith({
    int? id,
    String? content,
    List<Media>? media,
    User? user,
    String? createdAt,
    bool? canDelete,
    List<SingleComment>? replies,
  }) =>
      SingleComment(
        id: id ?? this.id,
        content: content ?? this.content,
        media: media ?? this.media,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        canDelete: canDelete ?? this.canDelete,
        replies: replies ?? this.replies,
      );

  factory SingleComment.fromJson(Map<String, dynamic> json) => SingleComment(
    id: json["id"],
    content: json["content"],
    media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => x)),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    createdAt: json["created_at"],
    canDelete: json["can_delete"],
    replies: json["replies"] == null ? [] : List<SingleComment>.from(json["replies"]!.map((x) => SingleComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x)),
    "user": user?.toJson(),
    "created_at": createdAt,
    "can_delete": canDelete,
    "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
  };
}

