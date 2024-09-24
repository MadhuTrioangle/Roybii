// To parse this JSON data, do
//
//     final verifyNewDevice = verifyNewDeviceFromJson(jsonString);

import 'dart:convert';


class VerifyNewDeviceClass {
  VerifyNewDeviceClass({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  VerifyNewDeviceLogin? result;
  String? typename;

  factory VerifyNewDeviceClass.fromRawJson(String str) => VerifyNewDeviceClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyNewDeviceClass.fromJson(Map<String, dynamic> json) => VerifyNewDeviceClass(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : VerifyNewDeviceLogin.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class VerifyNewDeviceLogin {
  VerifyNewDeviceLogin({
    this.token,
    this.email,
    this.sessionId,
    this.typename,
  });

  String? token;
  String? email;
  String? sessionId;
  String? typename;

  factory VerifyNewDeviceLogin.fromRawJson(String str) => VerifyNewDeviceLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyNewDeviceLogin.fromJson(Map<String, dynamic> json) => VerifyNewDeviceLogin(
    token: json["token"] == null ? null : json["token"],
    email: json["email"] == null ? null : json["email"],
    sessionId: json["session_id"] == null ? null : json["session_id"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token,
    "email": email == null ? null : email,
    "session_id": sessionId == null ? null : sessionId,
    "__typename": typename == null ? null : typename,
  };
}
