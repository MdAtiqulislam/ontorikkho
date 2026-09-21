import 'role_model.dart';

class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? moduleType;
  final dynamic moduleTypeId;
  final String? roleId;
  final int? isActive;
  final dynamic emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final Role? role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.moduleType,
    this.moduleTypeId,
    this.roleId,
    this.isActive,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    moduleType: json["module_type"],
    moduleTypeId: json["module_type_id"],
    roleId: json["role_id"],
    isActive: json["is_active"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    role: json["role"] == null ? null : Role.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "module_type": moduleType,
    "module_type_id": moduleTypeId,
    "role_id": roleId,
    "is_active": isActive,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "role": role?.toJson(),
  };
}