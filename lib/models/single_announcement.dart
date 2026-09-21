class SingleAnnouncement {
  final int? id;
  final String? title;
  final String? description;
  final String? time;
  final String? createdBy;
  final int? status;

  SingleAnnouncement({
    this.id,
    this.title,
    this.description,
    this.time,
    this.createdBy,
    this.status,
  });

  factory SingleAnnouncement.fromJson(Map<String, dynamic> json) => SingleAnnouncement(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    time: json["time"],
    createdBy: json["created_by"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "time": time,
    "created_by": createdBy,
    "status": status,
  };
}