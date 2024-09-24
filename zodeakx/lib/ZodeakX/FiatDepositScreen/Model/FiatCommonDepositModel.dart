// To parse this JSON data, do
//
//     final createFiatDepositModel = createFiatDepositModelFromJson(jsonString);

import 'dart:convert';

class CreateFiatDepositModel {
  CreateFiatDepositModel({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  String? typename;

  factory CreateFiatDepositModel.fromRawJson(String str) => CreateFiatDepositModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateFiatDepositModel.fromJson(Map<String, dynamic> json) => CreateFiatDepositModel(
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
