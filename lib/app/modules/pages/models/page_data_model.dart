class PageDataModel {
  final int? id;
  final String? name;
  final String? slug;
  final String? pageType;
  final String? description;
  final String? category;
  final int? pageCategoryId;
  final String? profileImage;
  final String? coverImage;
  final int? likesCount;
  final int? followersCount;
  final int? postsCount;
  final String? myRole;
  final bool? isOwner;
  final bool? isFollowing;
  final bool? isBlocked;
  final String? pageStatus;
  final int? ownerId;

  const PageDataModel({
    this.id,
    this.name,
    this.slug,
    this.pageType,
    this.description,
    this.category,
    this.pageCategoryId,
    this.profileImage,
    this.coverImage,
    this.likesCount,
    this.followersCount,
    this.postsCount,
    this.myRole,
    this.isOwner,
    this.isFollowing,
    this.isBlocked,
    this.pageStatus,
    this.ownerId,
  });

  factory PageDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PageDataModel();

    return PageDataModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      pageType: json['page_type'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      pageCategoryId: json['page_category_id'] as int?,
      profileImage: json['profile_image'] as String?,
      coverImage: json['cover_image'] as String?,
      likesCount: json['likes_count'] as int?,
      followersCount: json['followers_count'] as int?,
      postsCount: json['posts_count'] as int?,
      myRole: json['my_role'] as String?,
      isOwner: json['is_owner'] as bool?,
      isFollowing: json['is_following'] as bool?,
      isBlocked: json['is_blocked'] as bool?,
      pageStatus: json['page_status'] as String?,
      ownerId: json['owner_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'page_type': pageType,
      'description': description,
      'category': category,
      'page_category_id': pageCategoryId,
      'profile_image': profileImage,
      'cover_image': coverImage,
      'likes_count': likesCount,
      'followers_count': followersCount,
      'posts_count': postsCount,
      'my_role': myRole,
      'is_owner': isOwner,
      'is_following': isFollowing,
      'is_blocked': isBlocked,
      'page_status': pageStatus,
      'owner_id': ownerId,
    };
  }

  PageDataModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? pageType,
    String? description,
    String? category,
    int? pageCategoryId,
    String? profileImage,
    String? coverImage,
    int? likesCount,
    int? followersCount,
    int? postsCount,
    String? myRole,
    bool? isOwner,
    bool? isFollowing,
    bool? isBlocked,
    String? pageStatus,
    int? ownerId,
  }) {
    return PageDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      pageType: pageType ?? this.pageType,
      description: description ?? this.description,
      category: category ?? this.category,
      pageCategoryId: pageCategoryId ?? this.pageCategoryId,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      likesCount: likesCount ?? this.likesCount,
      followersCount: followersCount ?? this.followersCount,
      postsCount: postsCount ?? this.postsCount,
      myRole: myRole ?? this.myRole,
      isOwner: isOwner ?? this.isOwner,
      isFollowing: isFollowing ?? this.isFollowing,
      isBlocked: isBlocked ?? this.isBlocked,
      pageStatus: pageStatus ?? this.pageStatus,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}