
import 'dart:convert';
import 'package:ontorikkho/app/modules/forYou/models/single_comment.dart';

import '../../../../models/pagination_model.dart';
import '../../../../utils/enums.dart';

PostsModel postsModelFromJson(String str) =>
    PostsModel.fromJson(json.decode(str));

String postsModelToJson(PostsModel data) => json.encode(data.toJson());

class PostsModel {
  final String? msg;
  final bool? status;
  final List<SinglePostModel>? posts;
  final Pagination? pagination;

  PostsModel({this.msg, this.status, this.posts, this.pagination});

  PostsModel copyWith({
    String? msg,
    bool? status,
    List<SinglePostModel>? posts,
    Pagination? pagination,
  }) => PostsModel(
    msg: msg ?? this.msg,
    status: status ?? this.status,
    posts: posts ?? this.posts,
    pagination: pagination ?? this.pagination,
  );

  factory PostsModel.fromJson(Map<String, dynamic> json) => PostsModel(
    msg: json["msg"],
    status: json["status"],
    posts:
        json["posts"] == null
            ? []
            : List<SinglePostModel>.from(
              json["posts"]!.map((x) => SinglePostModel.fromJson(x)),
            ),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "posts":
        posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SinglePostModel {
  final int? id;
  final String? content;
  final String? deepLink;
  final List<Media>? media;
  final String? mediaType;
  final String? mediaPath;
  final String? youtubeLink;
  final String? youtubeVideoId;
  final String? youtubeTitle;
  final String? youtubeAuthor;
  final String? youtubeThumbnail;
  final User? user;
  final String? createdAt;
  final ReactionCounts? reactionCounts;
  final UserReaction? userReaction;
  final List<SingleComment>? comments;
  final bool? canEdit;
  final bool? canDelete;

  SinglePostModel({
    this.id,
    this.content,
    this.deepLink,
    this.media,
    this.mediaType,
    this.mediaPath,
    this.youtubeLink,
    this.youtubeVideoId,
    this.youtubeTitle,
    this.youtubeAuthor,
    this.youtubeThumbnail,
    this.user,
    this.createdAt,
    this.reactionCounts,
    this.userReaction,
    this.comments,
    this.canEdit,
    this.canDelete,
  });

  SinglePostModel copyWith({
    int? id,
    String? content,
    String? deepLink,
    List<Media>? media,
    String? mediaType,
    String? mediaPath,
    String? youtubeLink,
    String? youtubeVideoId,
    String? youtubeTitle,
    String? youtubeAuthor,
    String? youtubeThumbnail,
    User? user,
    String? createdAt,
    ReactionCounts? reactionCounts,
    UserReaction? userReaction,
    List<SingleComment>? comments,
    bool? canEdit,
    bool? canDelete,
  }) =>
      SinglePostModel(
    id: id ?? this.id,
    content: content ?? this.content,
    deepLink: deepLink ?? this.deepLink,
    media: media ?? this.media,
    mediaType: mediaType ?? this.mediaType,
    mediaPath: mediaPath ?? this.mediaPath,
    youtubeLink: youtubeLink ?? this.youtubeLink,
    youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
    youtubeTitle: youtubeTitle ?? this.youtubeTitle,
    youtubeAuthor: youtubeAuthor ?? this.youtubeAuthor,
    youtubeThumbnail: youtubeThumbnail ?? this.youtubeThumbnail,
    user: user ?? this.user,
    createdAt: createdAt ?? this.createdAt,
    reactionCounts: reactionCounts ?? this.reactionCounts,
    userReaction: userReaction ?? this.userReaction,
    comments: comments ?? this.comments,
    canEdit: canEdit ?? this.canEdit,
    canDelete: canDelete ?? this.canDelete,
  );

  factory SinglePostModel.fromJson(Map<String, dynamic> json) => SinglePostModel(
    id: json["id"],
    content: json["content"],
    deepLink: json["deep_link"],
    media:
        json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    mediaType: json["media_type"],
    mediaPath: json["media_path"],
    youtubeLink: json["youtube_link"],
    youtubeVideoId: json["youtube_video_id"],
    youtubeTitle: json["youtube_title"],
    youtubeAuthor: json["youtube_author"],
    youtubeThumbnail: json["youtube_thumbnail"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    createdAt: json["created_at"],
    reactionCounts:
        json["reaction_counts"] == null
            ? null
            : ReactionCounts.fromJson(json["reaction_counts"]),
    userReaction:
        json["user_reaction"] == null
            ? null
            : UserReaction.fromJson(json["user_reaction"]),
    comments:
        json["comments"] == null
            ? []
            : List<SingleComment>.from(
              json["comments"]!.map((x) => SingleComment.fromJson(x)),
            ),
    canEdit: json["can_edit"],
    canDelete: json["can_delete"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "deep_link": deepLink,
    "media":
        media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
    "media_type": mediaType,
    "media_path": mediaPath,
    "youtube_link": youtubeLink,
    "youtube_video_id": youtubeVideoId,
    "youtube_title": youtubeTitle,
    "youtube_author": youtubeAuthor,
    "youtube_thumbnail": youtubeThumbnail,
    "user": user?.toJson(),
    "created_at": createdAt,
    "reaction_counts": reactionCounts?.toJson(),
    "user_reaction": userReaction?.toJson(),
    "comments":
        comments == null
            ? []
            : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "can_edit": canEdit,
    "can_delete": canDelete,
  };
}



class User {
  final int? id;
  final String? name;
  final String? avatar;

  User({this.id, this.name, this.avatar});

  User copyWith({int? id, String? name, String? avatar}) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
  );

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"], avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "avatar": avatar};
}

class Media {
  final int? id;
  final String? type;
  final String? url;

  Media({this.id, this.type, this.url});

  Media copyWith({int?id, String? type, String? url}) =>
      Media(id:id??this.id,type: type ?? this.type, url: url ?? this.url);

  factory Media.fromJson(Map<String, dynamic> json) =>
      Media(id:json["id"],type: json["type"], url: json["url"]);

  Map<String, dynamic> toJson() => {"type": type, "url": url};

  /// Check if media is local
  bool get isLocal {
    if (url == null) return false;
    return !url!.toLowerCase().startsWith('http');
  }

  /// Check if media is network
  bool get isNetwork => !isLocal;

}

class ReactionCounts {
  final int? like;
  final int? love;
  final int? haha;
  final int? wow;
  final int? sad;
  final int? angry;

  const ReactionCounts({
    this.like,
    this.love,
    this.haha,
    this.wow,
    this.sad,
    this.angry,
  });

  factory ReactionCounts.empty() =>
      const ReactionCounts(like: 0, love: 0, haha: 0, wow: 0, sad: 0, angry: 0);

  factory ReactionCounts.fromJson(Map<String, dynamic> json) => ReactionCounts(
    like: json["like"] ?? 0,
    love: json["love"] ?? 0,
    haha: json["haha"] ?? 0,
    wow: json["wow"] ?? 0,
    sad: json["sad"] ?? 0,
    angry: json["angry"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "like": like,
    "love": love,
    "haha": haha,
    "wow": wow,
    "sad": sad,
    "angry": angry,
  };

  ReactionCounts copyWith({
    int? like,
    int? love,
    int? haha,
    int? wow,
    int? sad,
    int? angry,
  }) => ReactionCounts(
    like: like ?? this.like,
    love: love ?? this.love,
    haha: haha ?? this.haha,
    wow: wow ?? this.wow,
    sad: sad ?? this.sad,
    angry: angry ?? this.angry,
  );

  ReactionCounts update(ReactionType type, int delta) {
    switch (type) {
      case ReactionType.like:
        return copyWith(like: (like ?? 0) + delta);
      case ReactionType.love:
        return copyWith(love: (love ?? 0) + delta);
      case ReactionType.haha:
        return copyWith(haha: (haha ?? 0) + delta);
      case ReactionType.wow:
        return copyWith(wow: (wow ?? 0) + delta);
      case ReactionType.sad:
        return copyWith(sad: (sad ?? 0) + delta);
      case ReactionType.angry:
        return copyWith(angry: (angry ?? 0) + delta);
    }
  }
}

class UserReaction {
  final int? id;
  final int? postId;
  final int? userId;
  final String? reactionType;
  final String? createdAt;
  final String? updatedAt;

  UserReaction({
    this.id,
    this.postId,
    this.userId,
    this.reactionType,
    this.createdAt,
    this.updatedAt,
  });

  UserReaction copyWith({
    int? id,
    int? postId,
    int? userId,
    String? reactionType,
    String? createdAt,
    String? updatedAt,
  }) => UserReaction(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    userId: userId ?? this.userId,
    reactionType: reactionType ?? this.reactionType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory UserReaction.fromJson(Map<String, dynamic> json) => UserReaction(
    id: json["id"],
    postId: json["post_id"],
    userId: json["user_id"],
    reactionType: json["reaction_type"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_id": postId,
    "user_id": userId,
    "reaction_type": reactionType,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
