// To parse this JSON data, do
//
//     final verifyTfaLogin = verifyTfaLoginFromJson(jsonString);

import 'dart:convert';

class VerifyTfaLogin {
  VerifyTfaLogin({
    this.verifyTfaLogin,
  });

  VerifyTfaLoginClass? verifyTfaLogin;

  factory VerifyTfaLogin.fromRawJson(String str) => VerifyTfaLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyTfaLogin.fromJson(Map<String, dynamic> json) => VerifyTfaLogin(
    verifyTfaLogin: json["verifyTfaLogin"] == null ? null : VerifyTfaLoginClass.fromJson(json["verifyTfaLogin"]),
  );

  Map<String, dynamic> toJson() => {
    "verifyTfaLogin": verifyTfaLogin == null ? null : verifyTfaLogin?.toJson(),
  };
}

class VerifyTfaLoginClass {
  VerifyTfaLoginClass({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  TfaLogin? result;
  String? typename;

  factory VerifyTfaLoginClass.fromRawJson(String str) => VerifyTfaLoginClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyTfaLoginClass.fromJson(Map<String, dynamic> json) => VerifyTfaLoginClass(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : TfaLogin.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class TfaLogin {
  TfaLogin({
    this.token,
    this.email,
    this.tokenType,
    this.sessionId,
    this.tempOtp,
    this.typename,
  });

  String? token;
  String? email;
  dynamic tokenType;
  String? sessionId;
  dynamic tempOtp;
  String? typename;

  factory TfaLogin.fromRawJson(String str) => TfaLogin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TfaLogin.fromJson(Map<String, dynamic> json) => TfaLogin(
    token: json["token"] == null ? null : json["token"],
    email: json["email"] == null ? null : json["email"],
    tokenType: json["token_type"],
    sessionId: json["session_id"] == null ? null : json["session_id"],
    tempOtp: json["tempOTP"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "token": token == null ? null : token,
    "email": email == null ? null : email,
    "token_type": tokenType,
    "session_id": sessionId == null ? null : sessionId,
    "tempOTP": tempOtp,
    "__typename": typename == null ? null : typename,
  };
}
