
import 'dart:convert';
class LoginModel {
    LoginModel({
        this.statusCode,
        this.statusMessage,
        this.result,
        this.typename,
    });

    int? statusCode;
    String? statusMessage;
    LoginResponse? result;
    String? typename;

    factory LoginModel.fromRawJson(String str) => LoginModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage: json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null ? null : LoginResponse.fromJson(json["result"]),
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result!.toJson(),
        "__typename": typename == null ? null : typename,
    };
}

class LoginResponse {
    LoginResponse({
        this.token,
        this.email,
        this.sessionId,
        this.accountStatus,
        this.tokenType,
        this.tempOtp,
        this.typename,
    });

    String? token;
    String? email;
    dynamic sessionId;
    String? accountStatus;
    String? tokenType;
    dynamic tempOtp;
    String? typename;

    factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"] == null ? null : json["token"],
        email: json["email"] == null ? null : json["email"],
        sessionId: json["session_id"],
        accountStatus: json["account_status"] == null ? null : json["account_status"],
        tokenType: json["token_type"] == null ? null : json["token_type"],
        tempOtp: json["tempOTP"],
        typename: json["__typename"] == null ? null : json["__typename"],
    );

    Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "email": email == null ? null : email,
        "session_id": sessionId,
        "account_status": accountStatus == null ? null : accountStatus,
        "token_type": tokenType == null ? null : tokenType,
        "tempOTP": tempOtp,
        "__typename": typename == null ? null : typename,
    };
}
