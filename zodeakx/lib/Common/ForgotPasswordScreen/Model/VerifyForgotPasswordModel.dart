// To parse this JSON data, do
//
//     final verifyForgotPasswordModel = verifyForgotPasswordModelFromJson(jsonString);

import 'dart:convert';

class VerifyForgotPasswordModel {
  VerifyForgotPasswordModel({
    this.verfiyForgetPasswordCode,
  });

  VerfiyForgetPasswordCode ?verfiyForgetPasswordCode;

  factory VerifyForgotPasswordModel.fromRawJson(String str) => VerifyForgotPasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyForgotPasswordModel.fromJson(Map<String, dynamic> json) => VerifyForgotPasswordModel(
    verfiyForgetPasswordCode: json["verfiyForgetPasswordCode"] == null ? null : VerfiyForgetPasswordCode.fromJson(json["verfiyForgetPasswordCode"]),
  );

  Map<String, dynamic> toJson() => {
    "verfiyForgetPasswordCode": verfiyForgetPasswordCode == null ? null : verfiyForgetPasswordCode!.toJson(),
  };
}

class VerfiyForgetPasswordCode {
  VerfiyForgetPasswordCode({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  String? typename;

  factory VerfiyForgetPasswordCode.fromRawJson(String str) => VerfiyForgetPasswordCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerfiyForgetPasswordCode.fromJson(Map<String, dynamic> json) => VerfiyForgetPasswordCode(
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
