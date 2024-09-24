// To parse this JSON data, do
//
//     final antiPhishingModel = antiPhishingModelFromJson(jsonString);

import 'dart:convert';

class AntiPhishingModel {
  AntiPhishingModel({
    this.antiPhishingCode,
  });

  AntiPhishingCode ?antiPhishingCode;

  factory AntiPhishingModel.fromRawJson(String str) => AntiPhishingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AntiPhishingModel.fromJson(Map<String, dynamic> json) => AntiPhishingModel(
    antiPhishingCode: json["antiPhishingCode"] == null ? null : AntiPhishingCode.fromJson(json["antiPhishingCode"]),
  );

  Map<String, dynamic> toJson() => {
    "antiPhishingCode": antiPhishingCode == null ? null : antiPhishingCode!.toJson(),
  };
}

class AntiPhishingCode {
  AntiPhishingCode({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  String ?typename;

  factory AntiPhishingCode.fromRawJson(String str) => AntiPhishingCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AntiPhishingCode.fromJson(Map<String, dynamic> json) => AntiPhishingCode(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "__typename": typename == null ? null : typename,
  };
}
