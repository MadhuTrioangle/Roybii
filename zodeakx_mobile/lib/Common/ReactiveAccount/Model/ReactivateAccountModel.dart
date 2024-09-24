// To parse this JSON data, do
//
//     final reactivateAccountModel = reactivateAccountModelFromJson(jsonString);

import 'dart:convert';

class ReactivateAccountModel {
    ReactivateAccountModel({
        this.statusCode,
        this.statusMessage,
        this.result,
        this.typename,
    });

    int? statusCode;
    String? statusMessage;
    ReactivateAccountResponse? result;
    String? typename;

    factory ReactivateAccountModel.fromRawJson(String str) => ReactivateAccountModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ReactivateAccountModel.fromJson(Map<String, dynamic> json) => ReactivateAccountModel(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage: json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null ? null : ReactivateAccountResponse.fromJson(json["result"]),
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result!.toJson(),
        "__typename": typename == null ? null : typename,
    };
}

class ReactivateAccountResponse {
    ReactivateAccountResponse({
        this.token,
        this.email,
        this.accountStatus,
        this.tokenType,
        this.tempOtp,
        this.typename,
    });

    String? token;
    String? email;
    dynamic accountStatus;
    String? tokenType;
    String? tempOtp;
    String? typename;

    factory ReactivateAccountResponse.fromRawJson(String str) => ReactivateAccountResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ReactivateAccountResponse.fromJson(Map<String, dynamic> json) => ReactivateAccountResponse(
        token: json["token"] == null ? null : json["token"],
        email: json["email"] == null ? null : json["email"],
        accountStatus: json["account_status"],
        tokenType: json["token_type"] == null ? null : json["token_type"],
        tempOtp: json["tempOTP"] == null ? null : json["tempOTP"],
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "email": email == null ? null : email,
        "account_status": accountStatus,
        "token_type": tokenType == null ? null : tokenType,
        "tempOTP": tempOtp == null ? null : tempOtp,
        "__typename": typename == null ? null : typename,
    };
}
