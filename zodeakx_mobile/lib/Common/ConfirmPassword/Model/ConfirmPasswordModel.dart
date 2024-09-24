// To parse this JSON data, do
//
//     final newPassword = newPasswordFromJson(jsonString);

import 'dart:convert';

class NewPassword {
  NewPassword({
    this.data,
  });

  Data? data;

  factory NewPassword.fromRawJson(String str) => NewPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewPassword.fromJson(Map<String, dynamic> json) => NewPassword(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.newPassword,
  });

  NewPasswordClass ?newPassword;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    newPassword: json["newPassword"] == null ? null : NewPasswordClass.fromJson(json["newPassword"]),
  );

  Map<String, dynamic> toJson() => {
    "newPassword": newPassword == null ? null : newPassword!.toJson(),
  };
}

class NewPasswordClass {
  NewPasswordClass({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  String ?typename;

  factory NewPasswordClass.fromRawJson(String str) => NewPasswordClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewPasswordClass.fromJson(Map<String, dynamic> json) => NewPasswordClass(
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
