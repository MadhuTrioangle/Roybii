// To parse this JSON data, do
//
//     final socialMediaModel = socialMediaModelFromJson(jsonString);

import 'dart:convert';

class SocialMediaModel {
  int? statusCode;
  String? statusMessage;
  SocialMedia? result;
  String? typename;

  SocialMediaModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory SocialMediaModel.fromRawJson(String str) =>
      SocialMediaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) =>
      SocialMediaModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : SocialMedia.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class SocialMedia {
  String? token;
  String? email;
  dynamic accountStatus;
  String? sessionId;
  dynamic tokenType;
  dynamic tempOtp;
  String? vipLevel;
  bool? linkedAccount;
  dynamic mobile_number;
  dynamic mobile_code;
  dynamic mobile_status;
  String? typename;

  SocialMedia({
    this.token,
    this.email,
    this.accountStatus,
    this.sessionId,
    this.tokenType,
    this.tempOtp,
    this.vipLevel,
    this.linkedAccount,
    this.mobile_number,
    this.mobile_code,
    this.mobile_status,
    this.typename,
  });

  factory SocialMedia.fromRawJson(String str) =>
      SocialMedia.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SocialMedia.fromJson(Map<String, dynamic> json) => SocialMedia(
        token: json["token"],
        email: json["email"],
        accountStatus: json["account_status"],
        sessionId: json["session_id"],
        tokenType: json["token_type"],
        tempOtp: json["tempOTP"],
        vipLevel: json["vip_level"],
        linkedAccount: json["linked_account"],
        mobile_number: json["mobile_number"],
        mobile_code: json["mobile_code"],
        mobile_status: json["mobile_status"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "email": email,
        "account_status": accountStatus,
        "session_id": sessionId,
        "token_type": tokenType,
        "tempOTP": tempOtp,
        "vip_level": vipLevel,
        "mobile_number": mobile_number,
        "linked_account": linkedAccount,
        "mobile_code": mobile_code,
        "mobile_status": mobile_status,
        "__typename": typename,
      };
}
