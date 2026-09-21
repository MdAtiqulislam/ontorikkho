class Permission {
  final String? subject;
  final String? action;

  Permission({
    this.subject,
    this.action,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
    subject: json["subject"],
    action: json["action"],
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "action": action,
  };
}