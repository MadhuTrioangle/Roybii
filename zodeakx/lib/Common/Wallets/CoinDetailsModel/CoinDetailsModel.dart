// To parse this JSON data, do
//
//     final inOrderBalanceModel = inOrderBalanceModelFromJson(jsonString);

import 'dart:convert';

class InOrderBalanceModel {
  InOrderBalanceModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  InOrderBalance? result;
  String? typename;

  factory InOrderBalanceModel.fromRawJson(String str) => InOrderBalanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InOrderBalanceModel.fromJson(Map<String, dynamic> json) => InOrderBalanceModel(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : InOrderBalance.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class InOrderBalance {
  InOrderBalance({
    this.inorderBalance,
    this.availableBalance,
    this.totalBalance,
    this.typename,
  });

  num? inorderBalance;
  num? availableBalance;
  num? totalBalance;
  String? typename;

  factory InOrderBalance.fromRawJson(String str) => InOrderBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InOrderBalance.fromJson(Map<String, dynamic> json) => InOrderBalance(
    inorderBalance: json["inorderBalance"] == null ? null : json["inorderBalance"].toDouble(),
    availableBalance: json["availableBalance"] == null ? null : json["availableBalance"].toDouble(),
    totalBalance: json["totalBalance"] == null ? null : json["totalBalance"].toDouble(),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "inorderBalance": inorderBalance == null ? null : inorderBalance,
    "availableBalance": availableBalance == null ? null : availableBalance,
    "totalBalance": totalBalance == null ? null : totalBalance,
    "__typename": typename == null ? null : typename,
  };
}
