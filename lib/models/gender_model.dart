class Gender {
  final String? female;
  final String? male;
  final String? other;

  Gender({
    this.female,
    this.male,
    this.other,
  });

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
    female: json["Female"],
    male: json["Male"],
    other: json["Other"],
  );

  Map<String, dynamic> toJson() => {
    "Female": female,
    "Male": male,
    "Other": other,
  };
}