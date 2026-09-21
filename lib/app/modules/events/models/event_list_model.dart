import 'dart:convert';
import 'package:ontorikkho/models/pagination_model.dart';

EventListModel eventListModelFromJson(String str) =>
    EventListModel.fromJson(json.decode(str));

String eventListModelToJson(EventListModel data) => json.encode(data.toJson());

class EventListModel {
  final String? msg;
  final bool? status;
  final EventData? data;
  final PaginationSection? pagination;

  EventListModel({
    this.msg,
    this.status,
    this.data,
    this.pagination,
  });

  factory EventListModel.fromJson(Map<String, dynamic> json) => EventListModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? null : EventData.fromJson(json["data"]),
    pagination: json["pagination"] == null
        ? null
        : PaginationSection.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data?.toJson(),
    "pagination": pagination?.toJson(),
  };
}

class EventData {
  final List<SingleEvent>? upcommingEvents;
  final List<SingleEvent>? ongoingEvents;
  final List<SingleEvent>? expiredEvents;

  EventData({
    this.upcommingEvents,
    this.ongoingEvents,
    this.expiredEvents,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    upcommingEvents: json["upcomming_events"] == null
        ? []
        : List<SingleEvent>.from(
        json["upcomming_events"].map((x) => SingleEvent.fromJson(x))),
    ongoingEvents: json["ongoing_events"] == null
        ? []
        : List<SingleEvent>.from(
        json["ongoing_events"].map((x) => SingleEvent.fromJson(x))),
    expiredEvents: json["expired_events"] == null
        ? []
        : List<SingleEvent>.from(
        json["expired_events"].map((x) => SingleEvent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "upcomming_events": upcommingEvents == null
        ? []
        : List<dynamic>.from(upcommingEvents!.map((x) => x.toJson())),
    "ongoing_events": ongoingEvents == null
        ? []
        : List<dynamic>.from(ongoingEvents!.map((x) => x.toJson())),
    "expired_events": expiredEvents == null
        ? []
        : List<dynamic>.from(expiredEvents!.map((x) => x.toJson())),
  };
}

class SingleEvent {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? startDate;
  final String? endDate;
  final String? location;
  final int? status;
  final String? timeDifference;
  final String? eventType;

  SingleEvent({
    this.id,
    this.title,
    this.description,
    this.image,
    this.startDate,
    this.endDate,
    this.location,
    this.status,
    this.timeDifference,
    this.eventType,
  });

  factory SingleEvent.fromJson(Map<String, dynamic> json) => SingleEvent(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    location: json["location"],
    status: json["status"],
    timeDifference: json["time_difference"],
    eventType: json["event_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "start_date": startDate,
    "end_date": endDate,
    "location": location,
    "status": status,
    "time_difference": timeDifference,
    "event_type": eventType,
  };
}

class PaginationSection {
  final Pagination? upcomming;
  final Pagination? ongoing;
  final Pagination? expired;

  PaginationSection({
    this.upcomming,
    this.ongoing,
    this.expired,
  });

  factory PaginationSection.fromJson(Map<String, dynamic> json) =>
      PaginationSection(
        upcomming: json["upcomming"] == null
            ? null
            : Pagination.fromJson(json["upcomming"]),
        ongoing: json["ongoing"] == null
            ? null
            : Pagination.fromJson(json["ongoing"]),
        expired: json["expired"] == null
            ? null
            : Pagination.fromJson(json["expired"]),
      );

  Map<String, dynamic> toJson() => {
    "upcomming": upcomming?.toJson(),
    "ongoing": ongoing?.toJson(),
    "expired": expired?.toJson(),
  };
}
