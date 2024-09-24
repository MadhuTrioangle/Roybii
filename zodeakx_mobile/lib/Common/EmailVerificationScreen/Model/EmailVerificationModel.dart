// To parse this JSON data, do
//
//     final resendMail = resendMailFromJson(jsonString);

import 'dart:convert';

class ResendMail {
    ResendMail({
        this.statusCode,
        this.statusMessage,
        this.result,
        this.typename,
    });

    int? statusCode;
    String? statusMessage;
    ResendVerificationResult? result;
    String? typename;

    factory ResendMail.fromRawJson(String str) => ResendMail.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResendMail.fromJson(Map<String, dynamic> json) => ResendMail(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage: json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null ? null : ResendVerificationResult.fromJson(json["result"]),
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result!.toJson(),
        "__typename": typename == null ? null : typename,
    };
}

class ResendVerificationResult {
    ResendVerificationResult({
        this.tempOtp,
        this.typename,
    });

    String? tempOtp;
    String? typename;

    factory ResendVerificationResult.fromRawJson(String str) => ResendVerificationResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResendVerificationResult.fromJson(Map<String, dynamic> json) => ResendVerificationResult(
        tempOtp: json["tempOTP"] == null ? null : json["tempOTP"],
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "tempOTP": tempOtp == null ? null : tempOtp,
        "__typename": typename == null ? null : typename,
    };
}
