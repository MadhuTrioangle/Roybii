// To parse this JSON data, do
//
//     final fiatDepositHistory = fiatDepositHistoryFromJson(jsonString);

import 'dart:convert';

import 'FiatWithdrawHistory.dart';

class FiatDepositHistory {
  FiatDepositHistory({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<FiatWithdrawHistoryDetails>? result;
  String? typename;

  factory FiatDepositHistory.fromRawJson(String str) => FiatDepositHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FiatDepositHistory.fromJson(Map<String, dynamic> json) => FiatDepositHistory(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<FiatWithdrawHistoryDetails>.from(json["result"].map((x) => FiatWithdrawHistoryDetails.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class FiatDepositHistoryDetails {
  FiatDepositHistoryDetails({
    this.currencyCode,
    this.transactionId,
    this.payMode,
    this.status,
    this.amount,
    this.modifiedDate,
    this.typename,
  });

  String? currencyCode;
  String? transactionId;
  String? payMode;
  String? status;
  num? amount;
  DateTime? modifiedDate;
  String? typename;

  factory FiatDepositHistoryDetails.fromRawJson(String str) => FiatDepositHistoryDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FiatDepositHistoryDetails.fromJson(Map<String, dynamic> json) => FiatDepositHistoryDetails(
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    payMode: json["pay_mode"] == null ? null : json["pay_mode"],
    status: json["status"] == null ? null : json["status"],
    amount: json["amount"] == null ? null : json["amount"],
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode == null ? null : currencyCode,
    "transaction_id": transactionId == null ? null : transactionId,
    "pay_mode": payMode == null ? null : payMode,
    "status": status == null ? null : status,
    "amount": amount == null ? null : amount,
    "modified_date": modifiedDate == null ? null : modifiedDate?.toIso8601String(),
    "__typename": typename == null ? null : typename,
  };
}
