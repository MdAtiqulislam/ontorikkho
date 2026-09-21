enum PostType { text, image, video, news }

/// 🔹 Facebook-style reactions
enum ReactionType { like, love, haha, wow, sad, angry }

enum MediaType { image, video, youtube, file, link }



enum VideoSourceType { youtube, vimeo, network, uploaded, liveTV, unknown,image }

enum NotificationType {
  comment,
  postReaction,
  friendRequest
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.comment:
        return "comment";
      case NotificationType.postReaction:
        return "post_reaction";
        case NotificationType.friendRequest:
        return "friend_request";
    }
  }
}

/*enum FriendRequestStatus {
  suggestion,
  requested,
  sent,
  friends,
}*/
enum FriendRequestStatus {
  friend,
  sent,
  received,
  canceled,
  blocked,
}

extension FriendRequestStatusExtension on FriendRequestStatus {
  /// Enum → API string
  String get value {
    switch (this) {
      case FriendRequestStatus.friend:
        return "friend";
      case FriendRequestStatus.sent:
        return "sent";
      case FriendRequestStatus.received:
        return "received";
      case FriendRequestStatus.canceled:
        return "canceled";
      case FriendRequestStatus.blocked:
        return "blocked";
    }
  }

  /// API string → Enum
  static FriendRequestStatus? fromString(String? status) {
    if (status == null) return null;

    switch (status.toLowerCase()) {
      case "friend":
        return FriendRequestStatus.friend;
      case "sent":
        return FriendRequestStatus.sent;
      case "received":
        return FriendRequestStatus.received;
      case "canceled":
        return FriendRequestStatus.canceled;
      case "blocked":
        return FriendRequestStatus.blocked;
      default:
        return null;
    }
  }

}

enum FriendActionType {
  add,            // send request
  cancel,         // cancel sent request
  confirm,        // accept request
  delete,         // reject request
  remove,         // remove from suggestions
  unfriend,       // Unfriend user
  block,          // block user
  unblock,        // unblock user
  follow,         // future use
  unfollow,       // future use
  openMenu,       // open bottom sheet
}

enum PageActionType {
  invite,            // send invitation
  follow,            // send request
  unfollow,         // cancel sent request
  remove,        // accept request
  delete,         // reject request
  accept,         // remove from suggestions
  denied,       // Unfriend user
  block,          // block user
  unblock,        // unblock user
  message,
  cancel,
  viewPage,
  active,         // future use
}

enum FriendFilterType {
  suggestions,
  incoming,
  sent,
  yourFriends,
}

enum PageFilterType {
  create,
  recommended,
  invites,
  followed,
}

enum PageStatus {
  notFollowing,
  following,
  invited,
  requested,
  active,
  inactive,
  blocked,
}
enum PostProfileType{
  profilePost,
  pagePost
}

enum PageType {
  businessBrand,
  publicFigure,
  organization,
}

enum PageRole {
  owner,
  admin,
  moderator,
  editor,
  member,
  guest,
  unknown;

  bool get canManage =>
      this == owner ||
          this == admin ||
          this == moderator;

  bool get canEdit =>
      this == owner ||
          this == admin;

  bool get canDelete =>
      this == owner;
}
enum ShareType {
  shareToWall("share_to_wall"),
  shareWithFriend("share_with_friend"),
  shareLink("share_link");

  final String value;

  const ShareType(this.value);
}
