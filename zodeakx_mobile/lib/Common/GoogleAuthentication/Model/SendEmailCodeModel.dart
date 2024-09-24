// To parse this JSON data, do
//
//     final sendEmailCodeModel = sendEmailCodeModelFromJson(jsonString);

import 'dart:convert';

class SendEmailCodeModel {
  int? statusCode;
  String? statusMessage;
  SendEmailCode? result;
  String? typename;

  SendEmailCodeModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory SendEmailCodeModel.fromRawJson(String str) => SendEmailCodeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendEmailCodeModel.fromJson(Map<String, dynamic> json) => SendEmailCodeModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : SendEmailCode.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class SendEmailCode {
  String? tokenType;
  String? token;
  String? typename;

  SendEmailCode({
    this.tokenType,
    this.token,
    this.typename,
  });

  factory SendEmailCode.fromRawJson(String str) => SendEmailCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendEmailCode.fromJson(Map<String, dynamic> json) => SendEmailCode(
    tokenType: json["token_type"],
    token: json["token"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "token_type": tokenType,
    "token": token,
    "__typename": typename,
  };
}
