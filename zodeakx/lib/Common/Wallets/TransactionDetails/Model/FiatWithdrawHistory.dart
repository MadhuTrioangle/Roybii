// To parse this JSON data, do
//
//     final fiatWithdrawHistory = fiatWithdrawHistoryFromJson(jsonString);

import 'dart:convert';
import 'dart:math';

class FiatWithdrawHistory {
  FiatWithdrawHistory({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<FiatWithdrawHistoryDetails>? result;
  String? typename;

  factory FiatWithdrawHistory.fromRawJson(String str) => FiatWithdrawHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FiatWithdrawHistory.fromJson(Map<String, dynamic> json) => FiatWithdrawHistory(
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

class FiatWithdrawHistoryDetails {
  FiatWithdrawHistoryDetails({
    this.currencyCode,
    this.status,
    this.sentAmount,
    this.adminFee,
    this.payMode,
    this.receivedAmount,
    this.type,
    this.amount_mob,
    this.transactionId,
    this.modifiedDate,
    this.typename,
  });

  String? currencyCode;
  String? status;
  num? sentAmount;
  num? adminFee;
  String? type;
  num? amount_mob;
  String? payMode;
  num? receivedAmount;
  String? transactionId;
  DateTime? modifiedDate;
  String? typename;

  factory FiatWithdrawHistoryDetails.fromRawJson(String str) => FiatWithdrawHistoryDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FiatWithdrawHistoryDetails.fromJson(Map<String, dynamic> json) => FiatWithdrawHistoryDetails(
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    status: json["status"] == null ? null : json["status"],
    sentAmount: json["sent_amount"] == null ? null : json["sent_amount"],
    adminFee: json["admin_fee"] == null ? null : json["admin_fee"].toDouble(),
    payMode: json["pay_mode"] == null ? null : json["pay_mode"],
    receivedAmount: json["received_amount"] == null ? null : json["received_amount"].toDouble(),
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    type: json["type"] == null ? null : json["type"],
    amount_mob: json["amount_mob"] == null ? null : json["amount_mob"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode == null ? null : currencyCode,
    "status": status == null ? null : status,
    "sent_amount": sentAmount == null ? null : sentAmount,
    "admin_fee": adminFee == null ? null : adminFee,
    "pay_mode": payMode == null ? null : payMode,
    "received_amount": receivedAmount == null ? null : receivedAmount,
    "transaction_id": transactionId == null ? null : transactionId,
    "modified_date": modifiedDate == null ? null : modifiedDate?.toIso8601String(),
    "type":type == null ? null : type,
    "amount_mob":amount_mob == null ? null : amount_mob,
    "__typename": typename == null ? null : typename,
  };
}
