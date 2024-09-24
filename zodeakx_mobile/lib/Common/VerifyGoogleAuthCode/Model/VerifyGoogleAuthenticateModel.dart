// To parse this JSON data, do
//
//     final googleAuthenticationVerificationModel = googleAuthenticationVerificationModelFromJson(jsonString);

import 'dart:convert';

class GoogleAuthenticationVerificationModel {
  GoogleAuthenticationVerificationModel({
    this.antiPhishingCodeVerification,
  });

  AntiPhishingCodeVerification ?antiPhishingCodeVerification;

  factory GoogleAuthenticationVerificationModel.fromRawJson(String str) => GoogleAuthenticationVerificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GoogleAuthenticationVerificationModel.fromJson(Map<String, dynamic> json) => GoogleAuthenticationVerificationModel(
    antiPhishingCodeVerification: json["antiPhishingCodeVerification"] == null ? null : AntiPhishingCodeVerification.fromJson(json["antiPhishingCodeVerification"]),
  );

  Map<String, dynamic> toJson() => {
    "antiPhishingCodeVerification": antiPhishingCodeVerification == null ? null : antiPhishingCodeVerification!.toJson(),
  };
}

class AntiPhishingCodeVerification {
  AntiPhishingCodeVerification({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  String ?typename;

  factory AntiPhishingCodeVerification.fromRawJson(String str) => AntiPhishingCodeVerification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AntiPhishingCodeVerification.fromJson(Map<String, dynamic> json) => AntiPhishingCodeVerification(
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
