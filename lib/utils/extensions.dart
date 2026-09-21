import 'package:ontorikkho/app/modules/forYou/models/single_comment.dart';
import '../app/modules/forYou/models/posts_model.dart';
import 'enums.dart';

extension TimeAgo on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} d ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} w ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} mo ago';
    } else {
      return '${(diff.inDays / 365).floor()} y ago';
    }
  }
}


extension NumberFormatter on int {
  String get kmB {
    if (this >= 1000000000) {
      return "${(this / 1000000000).toStringAsFixed(1).replaceAll('.0', '')}b";
    } else if (this >= 1000000) {
      return "${(this / 1000000).toStringAsFixed(1).replaceAll('.0', '')}m";
    } else if (this >= 1000) {
      return "${(this / 1000).toStringAsFixed(1).replaceAll('.0', '')}k";
    } else {
      return toString();
    }
  }
}


extension ReactionHelper on ReactionCounts {
  int get totalReactionCount {
    return (like ?? 0) +
        (love ?? 0) +
        (haha ?? 0) +
        (wow ?? 0) +
        (sad ?? 0) +
        (angry ?? 0);
  }

  String get totalReactionFormatted {
    return totalReactionCount.kmB;
  }
}


extension PostCommentHelper on SinglePostModel {
  int get totalCommentsWithReplies {
    if (comments == null || comments!.isEmpty) return 0;

    int total = 0;

    for (final comment in comments!) {
      total += 1;

      if (comment.replies != null && comment.replies!.isNotEmpty) {
        total += _countReplies(comment.replies!);
      }
    }

    return total;
  }

  String get totalCommentsFormatted {
    return totalCommentsWithReplies.kmB;
  }

  int _countReplies(List<SingleComment> replies) {
    int count = 0;

    for (final reply in replies) {
      count += 1;

      if (reply.replies != null && reply.replies!.isNotEmpty) {
        count += _countReplies(reply.replies!);
      }
    }

    return count;
  }
}


extension ReactionTypeParser on String {
  ReactionType toReactionType() {
    return ReactionType.values.firstWhere(
          (e) => e.name.toLowerCase() == toLowerCase(),
      orElse: () => ReactionType.like,
    );
  }
}

extension FriendFilterTypeExtension on FriendFilterType {
  String get label {
    switch (this) {
      case FriendFilterType.suggestions:
        return "Suggestions";
      case FriendFilterType.incoming:
        return "Incoming";
      case FriendFilterType.sent:
        return "Sent";
      case FriendFilterType.yourFriends:
        return "Your Friends";
    }
  }
}


extension PageFilterTypeExtension on PageFilterType {
  String get label {
    switch (this) {
      case PageFilterType.create:
        return "Create";
      case PageFilterType.recommended:
        return "Recommended";
      case PageFilterType.invites:
        return "Invites";
      case PageFilterType.followed:
        return "Followed";
    }
  }
}


extension PageStatusExtension on PageStatus {
  /// 🔹 API value
  String get value {
    switch (this) {
      case PageStatus.notFollowing:
        return "not_following";
      case PageStatus.following:
        return "following";
      case PageStatus.invited:
        return "invited";
      case PageStatus.requested:
        return "requested";
      case PageStatus.active:
        return "active";
      case PageStatus.inactive:
        return "inactive";
      case PageStatus.blocked:
        return "blocked";
    }
  }

  /// 🔹 UI Label
  String get label {
    switch (this) {
      case PageStatus.notFollowing:
        return "Suggested";
      case PageStatus.following:
        return "Following";
      case PageStatus.invited:
        return "Invited";
      case PageStatus.requested:
        return "Requested";
      case PageStatus.active:
        return "Active";
      case PageStatus.inactive:
        return "Inactive";
      case PageStatus.blocked:
        return "Blocked";
    }
  }
  static PageStatus fromString(String? status) {
    switch (status) {
      case "following":
        return PageStatus.following;

      case "invited":
        return PageStatus.invited;

      case "requested":
        return PageStatus.requested;

      case "active":
        return PageStatus.active;

      case "inactive":
        return PageStatus.inactive;

      case "blocked":
        return PageStatus.blocked;

      case "notFollowing":
      default:
        return PageStatus.notFollowing;
    }
  }

  /// 🔹 Helper flags (🔥 useful)
  bool get isFollowing => this == PageStatus.following;
  bool get isNotFollowing => this == PageStatus.notFollowing;
  bool get isInvited => this == PageStatus.invited;
  bool get isRequested => this == PageStatus.requested;

  bool get isActive => this == PageStatus.active;
  bool get isInactive => this == PageStatus.inactive;
  bool get isBlocked => this == PageStatus.blocked;
}

extension PageTypeExtension on PageType {
  /// API value (snake_case)
  String get value {
    switch (this) {
      case PageType.businessBrand:
        return "business_brand";
      case PageType.publicFigure:
        return "public_figure";
      case PageType.organization:
        return "organization";
    }
  }

  /// UI label
  String get label {
    switch (this) {
      case PageType.businessBrand:
        return "Business Brand";
      case PageType.publicFigure:
        return "Public Figure";
      case PageType.organization:
        return "Organization";
    }
  }

  /// from API string → enum
  static PageType fromString(String value) {
    switch (value) {
      case "business_brand":
        return PageType.businessBrand;
      case "public_figure":
        return PageType.publicFigure;
      case "organization":
        return PageType.organization;
      default:
        return PageType.businessBrand;
    }
  }
}

extension PageRoleExtension on String? {
  PageRole get role {
    return PageRole.values.firstWhere(
          (e) => e.name == this?.trim().toLowerCase(),
      orElse: () => PageRole.unknown,
    );
  }
}