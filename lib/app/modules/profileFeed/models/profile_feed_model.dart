
import 'dart:convert';

import 'package:ontorikkho/app/modules/forYou/models/posts_model.dart';

import '../../../../models/pagination_model.dart';

ProfileFeedModel profileFeedModelFromJson(String str) => ProfileFeedModel.fromJson(json.decode(str));

String profileFeedModelToJson(ProfileFeedModel data) => json.encode(data.toJson());

class ProfileFeedModel {
  final String? msg;
  final bool? status;
  final String? friendshipStatus;
  final String? requestId;
  final List<SinglePostModel>? posts;
  final Pagination? pagination;
  final ProfileDataModel? profileData;

  ProfileFeedModel({
    this.msg,
    this.status,
    this.posts,
    this.pagination,
    this.profileData,
    this.friendshipStatus,
    this.requestId
  });

  ProfileFeedModel copyWith({
    String? msg,
    bool? status,
    List<SinglePostModel>? posts,
    Pagination? pagination,
    ProfileDataModel? profileData,
    String? friendshipStatus,
    String? profileId,
  }) =>
      ProfileFeedModel(
        msg: msg ?? this.msg,
        status: status ?? this.status,
        posts: posts ?? this.posts,
        pagination: pagination ?? this.pagination,
        profileData: profileData ?? this.profileData,
        friendshipStatus: friendshipStatus ?? this.friendshipStatus,
        requestId: profileId ?? this.requestId,
      );

  factory ProfileFeedModel.fromJson(Map<String, dynamic> json) => ProfileFeedModel(
    msg: json["msg"],
    status: json["status"],
    posts: json["posts"] == null ? [] : List<SinglePostModel>.from(json["posts"]!.map((x) => SinglePostModel.fromJson(x))),
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    profileData: json["profile_data"] == null ? null : ProfileDataModel.fromJson(json["profile_data"]),
    friendshipStatus: json["friendship_status"],
    requestId: json["request_id"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
    "profile_data": profileData?.toJson(),
    "friendship_status": friendshipStatus,
    "request_id": requestId,
  };
}


class ProfileDataModel {
  final String? profilePicture;
  final dynamic coverPhoto;
  final PersonalDataModel? personalData;
  final Education? education;
  final List<dynamic>? friendList;
  final List<Media>? photoList;
  final List<Media>? videoList;

  ProfileDataModel({
    this.profilePicture,
    this.coverPhoto,
    this.personalData,
    this.education,
    this.friendList,
    this.photoList,
    this.videoList,
  });

  ProfileDataModel copyWith({
    String? profilePicture,
    dynamic coverPhoto,
    PersonalDataModel? personalData,
    Education? education,
    List<dynamic>? friendList,
    List<Media>? photoList,
    List<Media>? videoList,
  }) =>
      ProfileDataModel(
        profilePicture: profilePicture ?? this.profilePicture,
        coverPhoto: coverPhoto ?? this.coverPhoto,
        personalData: personalData ?? this.personalData,
        education: education ?? this.education,
        friendList: friendList ?? this.friendList,
        photoList: photoList ?? this.photoList,
        videoList: videoList ?? this.videoList,
      );

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) => ProfileDataModel(
    profilePicture: json["profile_picture"],
    coverPhoto: json["cover_photo"],
    personalData: json["personal_data"] == null ? null : PersonalDataModel.fromJson(json["personal_data"]),
    education: json["education"] == null ? null : Education.fromJson(json["education"]),
    friendList: json["friend_list"] == null ? [] : List<dynamic>.from(json["friend_list"]!.map((x) => x)),
    photoList: json["photo_list"] == null ? [] : List<Media>.from(json["photo_list"]!.map((x) => Media.fromJson(x))),
    videoList: json["video_list"] == null ? [] : List<Media>.from(json["video_list"]!.map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "profile_picture": profilePicture,
    "cover_photo": coverPhoto,
    "personal_data": personalData?.toJson(),
    "education": education?.toJson(),
    "friend_list": friendList == null ? [] : List<dynamic>.from(friendList!.map((x) => x)),
    "photo_list": photoList == null ? [] : List<dynamic>.from(photoList!.map((x) => x.toJson())),
    "video_list": videoList == null ? [] : List<dynamic>.from(videoList!.map((x) => x.toJson())),
  };
}

class Education {
  final dynamic collegeName;
  final dynamic session;
  final String? degree;

  Education({
    this.collegeName,
    this.session,
    this.degree,
  });

  Education copyWith({
    dynamic collegeName,
    dynamic session,
    String? degree,
  }) =>
      Education(
        collegeName: collegeName ?? this.collegeName,
        session: session ?? this.session,
        degree: degree ?? this.degree,
      );

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    collegeName: json["college_name"],
    session: json["session"],
    degree: json["degree"],
  );

  Map<String, dynamic> toJson() => {
    "college_name": collegeName,
    "session": session,
    "degree": degree,
  };
}

class PersonalDataModel {
  final String? name;
  final String? email;
  final String? mobile;
  final String? permanentAddress;
  final dynamic currentAddress;
  final dynamic dateOfBirth;
  final dynamic maritalStatus;

  PersonalDataModel({
    this.name,
    this.email,
    this.mobile,
    this.permanentAddress,
    this.currentAddress,
    this.dateOfBirth,
    this.maritalStatus,
  });

  PersonalDataModel copyWith({
    String? name,
    String? email,
    String? mobile,
    String? permanentAddress,
    dynamic currentAddress,
    dynamic dateOfBirth,
    dynamic maritalStatus,
  }) =>
      PersonalDataModel(
        name: name ?? this.name,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        permanentAddress: permanentAddress ?? this.permanentAddress,
        currentAddress: currentAddress ?? this.currentAddress,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        maritalStatus: maritalStatus ?? this.maritalStatus,
      );

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) => PersonalDataModel(
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    permanentAddress: json["permanent_address"],
    currentAddress: json["current_address"],
    dateOfBirth: json["date_of_birth"],
    maritalStatus: json["marital_status"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "mobile": mobile,
    "permanent_address": permanentAddress,
    "current_address": currentAddress,
    "date_of_birth": dateOfBirth,
    "marital_status": maritalStatus,
  };
}




