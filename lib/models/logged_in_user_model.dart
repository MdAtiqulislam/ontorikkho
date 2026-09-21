class LoggedInUserModel {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? membershipType;
  String? membershipId;
  String? subscriptionStatus;
  int? memberId;
  String? profileImage;
  String? status;
  String? address;
  String? expiredDate;

  LoggedInUserModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.membershipType,
    this.subscriptionStatus,
    this.membershipId,
    this.memberId,
    this.profileImage,
    this.status,
    this.address,
    this.expiredDate,
  });

  factory LoggedInUserModel.fromJson(Map<String, dynamic> json) => LoggedInUserModel(
    id: json["id"],
    memberId: json["member_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    membershipType: json["membership_type"],
    membershipId: json["membership_code"],
    profileImage: json["profile_image"],
    status: json["status"],
    subscriptionStatus: json["subscribtion_status"],
    address: json["address"],
    expiredDate: json["expired_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "member_id": memberId,
    "name": name,
    "email": email,
    "mobile": mobile,
    "membership_type": membershipType,
    "membership_code": membershipId,
    "profile_image": profileImage,
    "status": status,
    "address": address,
    "expired_date": expiredDate,
    "subscribtion_status": subscriptionStatus,
  };
}