// To parse this JSON data, do
//
//     final eventDetailsModel = eventDetailsModelFromJson(jsonString);

import 'dart:convert';

EventDetailsModel eventDetailsModelFromJson(String str) => EventDetailsModel.fromJson(json.decode(str));

String eventDetailsModelToJson(EventDetailsModel data) => json.encode(data.toJson());

class EventDetailsModel {
  final String? msg;
  final bool? status;
  final EventDetailsData? data;

  EventDetailsModel({
    this.msg,
    this.status,
    this.data,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) => EventDetailsModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : EventDetailsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
  };
}

class EventDetailsData {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? startDate;
  final String? endDate;
  final String? time;
  final String? location;
  final String? eventType;

  EventDetailsData({
    this.id,
    this.title,
    this.description,
    this.image,
    this.startDate,
    this.endDate,
    this.time,
    this.location,
    this.eventType,
  });

  factory EventDetailsData.fromJson(Map<String, dynamic> json) => EventDetailsData(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    time: json["time"],
    location: json["location"],
    eventType: json["event_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "start_date": startDate,
    "end_date": endDate,
    "time": time,
    "location": location,
    "event_type": eventType,
  };
}
