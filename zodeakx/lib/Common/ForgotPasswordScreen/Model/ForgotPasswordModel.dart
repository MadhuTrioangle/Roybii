// To parse this JSON data, do
//
//     final forgotPasswordModel = forgotPasswordModelFromJson(jsonString);

import 'dart:convert';

class ForgotPasswordModel {
  ForgotPasswordModel({
    this.sendForgetPasswordVerifyMail,
  });

  SendForgetPasswordVerifyMail? sendForgetPasswordVerifyMail;

  factory ForgotPasswordModel.fromRawJson(String str) => ForgotPasswordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) => ForgotPasswordModel(
    sendForgetPasswordVerifyMail: json["sendForgetPasswordVerifyMail"] == null ? null : SendForgetPasswordVerifyMail.fromJson(json["sendForgetPasswordVerifyMail"]),
  );

  Map<String, dynamic> toJson() => {
    "sendForgetPasswordVerifyMail": sendForgetPasswordVerifyMail == null ? null : sendForgetPasswordVerifyMail!.toJson(),
  };
}

class SendForgetPasswordVerifyMail {
  SendForgetPasswordVerifyMail({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  ForgotPassword ?result;
  String ?typename;

  factory SendForgetPasswordVerifyMail.fromRawJson(String str) => SendForgetPasswordVerifyMail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SendForgetPasswordVerifyMail.fromJson(Map<String, dynamic> json) => SendForgetPasswordVerifyMail(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : ForgotPassword.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result!.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class ForgotPassword {
  ForgotPassword({
    this.tokenType,
    this.token,
    this.tempOtp,
    this.typename,
  });

  String ?tokenType;
  String ?token;
  String ?tempOtp;
  String ?typename;

  factory ForgotPassword.fromRawJson(String str) => ForgotPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPassword.fromJson(Map<String, dynamic> json) => ForgotPassword(
    tokenType: json["token_type"] == null ? null : json["token_type"],
    token: json["token"] == null ? null : json["token"],
    tempOtp: json["tempOTP"] == null ? null : json["tempOTP"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "token_type": tokenType == null ? null : tokenType,
    "token": token == null ? null : token,
    "tempOTP": tempOtp == null ? null : tempOtp,
    "__typename": typename == null ? null : typename,
  };
}

// import 'dart:convert';
//
// class ForgotPasswordModel {
//   ForgotPasswordModel({
//     this.statusCode,
//     this.statusMessage,
//     this.result,
//     this.typename,
//   });
//
//   int? statusCode;
//   String? statusMessage;
//   ForgotPassword ?result;
//   String ?typename;
//
//   factory ForgotPasswordModel.fromRawJson(String str) => ForgotPasswordModel.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) => ForgotPasswordModel(
//     statusCode: json["status_code"] == null ? null : json["status_code"],
//     statusMessage: json["status_message"] == null ? null : json["status_message"],
//     result: json["result"] == null ? null : ForgotPassword.fromJson(json["result"]),
//     typename: json["__typename"] == null ? null : json["__typename"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status_code": statusCode == null ? null : statusCode,
//     "status_message": statusMessage == null ? null : statusMessage,
//     "result": result == null ? null : result!.toJson(),
//     "__typename": typename == null ? null : typename,
//   };
// }
//
// class ForgotPassword {
//   ForgotPassword({
//     this.tokenType,
//     this.rememberToken,
//     this.tempOtp,
//     this.typename,
//   });
//
//   String ?tokenType;
//   String ?rememberToken;
//   String ?tempOtp;
//   String ?typename;
//
//   factory ForgotPassword.fromRawJson(String str) => ForgotPassword.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory ForgotPassword.fromJson(Map<String, dynamic> json) => ForgotPassword(
//     tokenType: json["token_type"] == null ? null : json["token_type"],
//     rememberToken: json["remember_token"] == null ? null : json["remember_token"],
//     tempOtp: json["tempOTP"] == null ? null : json["tempOTP"],
//     typename: json["__typename"] == null ? null : json["__typename"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "token_type": tokenType == null ? null : tokenType,
//     "remember_token": rememberToken == null ? null : rememberToken,
//     "tempOTP": tempOtp == null ? null : tempOtp,
//     "__typename": typename == null ? null : typename,
//   };
// }
