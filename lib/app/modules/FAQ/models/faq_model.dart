// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  final String? msg;
  final bool? status;
  final List<SingleFAQ>? data;

  FaqModel({
    this.msg,
    this.status,
    this.data,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    msg: json["msg"],
    status: json["status"],
    data: json["data"] == null ? [] : List<SingleFAQ>.from(json["data"]!.map((x) => SingleFAQ.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleFAQ {
  final String? question;
  final String? answer;

  SingleFAQ({
    this.question,
    this.answer,
  });

  factory SingleFAQ.fromJson(Map<String, dynamic> json) => SingleFAQ(
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };
}
