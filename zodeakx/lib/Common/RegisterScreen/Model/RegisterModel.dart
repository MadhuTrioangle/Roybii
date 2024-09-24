// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'dart:convert';

class RegisterModel {
    RegisterModel({
        this.createUser,
    });

    CreateUser? createUser;

    factory RegisterModel.fromRawJson(String str) => RegisterModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        createUser: json["createUser"] == null ? null : CreateUser.fromJson(json["createUser"]),
    );

    Map<String, dynamic> toJson() => {
        "createUser": createUser == null ? null : createUser!.toJson(),
    };
}

class CreateUser {
    CreateUser({
        this.statusCode,
        this.statusMessage,
        this.result,
        this.typename,
    });

    int? statusCode;
    String? statusMessage;
    ResgisteredUserDetails? result;
    String? typename;

    factory CreateUser.fromRawJson(String str) => CreateUser.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CreateUser.fromJson(Map<String, dynamic> json) => CreateUser(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage: json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null ? null : ResgisteredUserDetails.fromJson(json["result"]),
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result!.toJson(),
        "__typename": typename == null ? null : typename,
    };
}

class ResgisteredUserDetails {
    ResgisteredUserDetails({
        this.token,
        this.email,
        this.sessionId,
        this.tokenType,
        this.tempOtp,
        this.typename,
    });

    String? token;
    String? email;
    dynamic sessionId;
    String? tokenType;
    String? tempOtp;
    String? typename;

    factory ResgisteredUserDetails.fromRawJson(String str) => ResgisteredUserDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ResgisteredUserDetails.fromJson(Map<String, dynamic> json) => ResgisteredUserDetails(
        token: json["token"] == null ? null : json["token"],
        email: json["email"] == null ? null : json["email"],
        sessionId: json["session_id"],
        tokenType: json["token_type"] == null ? null : json["token_type"],
        tempOtp: json["tempOTP"] == null ? null : json["tempOTP"],
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "email": email == null ? null : email,
        "session_id": sessionId,
        "token_type": tokenType == null ? null : tokenType,
        "tempOTP": tempOtp == null ? null : tempOtp,
        "__typename": typename == null ? null : typename,
    };
}
