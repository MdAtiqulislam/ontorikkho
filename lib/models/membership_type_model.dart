class MembershipType {
  final int? id;
  final int? associationId;
  final String? title;
  final dynamic description;
  final int? amount;
  final int? periodInMonth;
  final int? inductionFees;
  final int? code;
  final dynamic serviceId;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MembershipType({
    this.id,
    this.associationId,
    this.title,
    this.description,
    this.amount,
    this.periodInMonth,
    this.inductionFees,
    this.code,
    this.serviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MembershipType.fromJson(Map<String, dynamic> json) => MembershipType(
    id: json["id"],
    associationId: json["association_id"],
    title: json["title"],
    description: json["description"],
    amount: json["amount"],
    periodInMonth: json["period_in_month"],
    inductionFees: json["induction_fees"],
    code: json["code"],
    serviceId: json["service_id"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "association_id": associationId,
    "title": title,
    "description": description,
    "amount": amount,
    "period_in_month": periodInMonth,
    "induction_fees": inductionFees,
    "code": code,
    "service_id": serviceId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}