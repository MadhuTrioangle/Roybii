// To parse this JSON data, do
//
//     final getUserByJwtModel = getUserByJwtModelFromJson(jsonString);

import 'dart:convert';

class GetUserByJwtModel {
  GetUserByJwtModel({
    this.getUserByJwt,
  });

  GetUserByJwt? getUserByJwt;

  factory GetUserByJwtModel.fromRawJson(String str) => GetUserByJwtModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserByJwtModel.fromJson(Map<String, dynamic> json) => GetUserByJwtModel(
    getUserByJwt: json["getUserByJWT"] == null ? null : GetUserByJwt.fromJson(json["getUserByJWT"]),
  );

  Map<String, dynamic> toJson() => {
    "getUserByJWT": getUserByJwt == null ? null : getUserByJwt!.toJson(),
  };
}

class GetUserByJwt {
  GetUserByJwt({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int ?statusCode;
  String ?statusMessage;
  Status ?result;
  String ?typename;

  factory GetUserByJwt.fromRawJson(String str) => GetUserByJwt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserByJwt.fromJson(Map<String, dynamic> json) => GetUserByJwt(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : Status.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result!.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class Status {
  Status({
    this.tfaEnableKey,
    this.antiPhishingCode,
    this.tfaStatus,
    this.kyc,
    this.typename,
  });

  String ?tfaEnableKey;
  String ?antiPhishingCode;
  String ?tfaStatus;
  Kyc ?kyc;
  String ?typename;

  factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    tfaEnableKey: json["tfa_enable_key"] == null ? null : json["tfa_enable_key"],
    antiPhishingCode: json["anti_phishing_code"] == null ? null : json["anti_phishing_code"],
    tfaStatus: json["tfa_status"] == null ? null : json["tfa_status"],
    kyc: json["kyc"] == null ? null : Kyc.fromJson(json["kyc"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "tfa_enable_key": tfaEnableKey == null ? null : tfaEnableKey,
    "anti_phishing_code": antiPhishingCode == null ? null : antiPhishingCode,
    "tfa_status": tfaStatus == null ? null : tfaStatus,
    "kyc": kyc == null ? null : kyc!.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class Kyc {
  Kyc({
    this.kycStatus,
    this.typename,
  });

  String ?kycStatus;
  String ?typename;

  factory Kyc.fromRawJson(String str) => Kyc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Kyc.fromJson(Map<String, dynamic> json) => Kyc(
    kycStatus: json["kyc_status"] == null ? null : json["kyc_status"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "kyc_status": kycStatus == null ? null : kycStatus,
    "__typename": typename == null ? null : typename,
  };
}
