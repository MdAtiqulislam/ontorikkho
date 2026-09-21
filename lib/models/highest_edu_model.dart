class HighestEdu {
  final String? id;
  final String? name;

  HighestEdu({
    this.id,
    this.name,
  });

  factory HighestEdu.fromJson(Map<String, dynamic> json) => HighestEdu(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}