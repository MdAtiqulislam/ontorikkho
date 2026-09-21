class Role {
  final int? id;
  final String? roleName;
  final String? roleCode;

  Role({
    this.id,
    this.roleName,
    this.roleCode,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    roleName: json["role_name"],
    roleCode: json["role_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_name": roleName,
    "role_code": roleCode,
  };
}