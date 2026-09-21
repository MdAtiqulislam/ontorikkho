// To parse this JSON data, do
//
//     final bdDataModel = bdDataModelFromJson(jsonString);

import 'dart:convert';

BdDataModel bdDataModelFromJson(String str) => BdDataModel.fromJson(json.decode(str));

String bdDataModelToJson(BdDataModel data) => json.encode(data.toJson());

class BdDataModel {
  final List<Division>? divisions;

  BdDataModel({
    this.divisions,
  });

  factory BdDataModel.fromJson(Map<String, dynamic> json) => BdDataModel(
    divisions: json["divisions"] == null ? [] : List<Division>.from(json["divisions"]!.map((x) => Division.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "divisions": divisions == null ? [] : List<dynamic>.from(divisions!.map((x) => x.toJson())),
  };
}

class Division {
  final String? name;
  final List<District>? districts;

  Division({
    this.name,
    this.districts,
  });

  factory Division.fromJson(Map<String, dynamic> json) => Division(
    name: json["name"],
    districts: json["districts"] == null ? [] : List<District>.from(json["districts"]!.map((x) => District.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "districts": districts == null ? [] : List<dynamic>.from(districts!.map((x) => x.toJson())),
  };
}

class District {
  final String? name;
  final List<dynamic>? upazilas;

  District({
    this.name,
    this.upazilas,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
    name: json["name"],
    upazilas: json["upazilas"] == null ? [] : List<dynamic>.from(json["upazilas"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "upazilas": upazilas == null ? [] : List<dynamic>.from(upazilas!.map((x) => x)),
  };
}

class UpazilaClass {
  final String? name;
  final List<String>? unions;

  UpazilaClass({
    this.name,
    this.unions,
  });

  factory UpazilaClass.fromJson(Map<String, dynamic> json) => UpazilaClass(
    name: json["name"],
    unions: json["unions"] == null ? [] : List<String>.from(json["unions"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "unions": unions == null ? [] : List<dynamic>.from(unions!.map((x) => x)),
  };
}
