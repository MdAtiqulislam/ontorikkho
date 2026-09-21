// To parse this JSON data, do
//
//     final countryListModel = countryListModelFromJson(jsonString);

import 'dart:convert';

CountryListModel countryListModelFromJson(String str) => CountryListModel.fromJson(json.decode(str));

String countryListModelToJson(CountryListModel data) => json.encode(data.toJson());

class CountryListModel {
  final String? msg;
  final bool? status;
  final List<SingleCountry>? data;

  CountryListModel({
    this.msg,
    this.status,
    this.data,
  });

  factory CountryListModel.fromJson(Map<String, dynamic> json) => CountryListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleCountry>.from(json["data"]!.map((x) => SingleCountry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleCountry {
  final int? id;
  final String? name;
  final String? countryCode;
  final String? iso31663;
  final String? iso31662;
  final String? callingCode;
  final String? flagUrl;
  final int? maxPhoneNumberLength;

  SingleCountry({
    this.id,
    this.name,
    this.countryCode,
    this.iso31663,
    this.iso31662,
    this.callingCode,
    this.flagUrl,
    this.maxPhoneNumberLength
  });

  factory SingleCountry.fromJson(Map<String, dynamic> json) => SingleCountry(
    id: json["id"],
    name: json["name"],
    countryCode: json["country_code"],
    iso31663: json["iso_3166_3"],
    iso31662: json["iso_3166_2"],
    callingCode: json["calling_code"],
    flagUrl: json["flag_url"],
    maxPhoneNumberLength: json["max_phone_number_length"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_code": countryCode,
    "iso_3166_3": iso31663,
    "iso_3166_2": iso31662,
    "calling_code": callingCode,
    "flag_url": flagUrl,
    "max_phone_number_length": maxPhoneNumberLength,
  };
}
