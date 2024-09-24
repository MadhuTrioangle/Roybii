// To parse this JSON data, do
//
//     final cryptoDepositHistory = cryptoDepositHistoryFromJson(jsonString);

import 'dart:convert';

import 'CryptoWithdrawHistoryModel.dart';

class CryptoDepositHistory {
  CryptoDepositHistory({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  Result? result;
  String? typename;

  factory CryptoDepositHistory.fromRawJson(String str) => CryptoDepositHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CryptoDepositHistory.fromJson(Map<String, dynamic> json) => CryptoDepositHistory(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class Result {
  Result({
    this.data,
    this.total,
    this.limit,
    this.page,
    this.pages,
    this.typename,
  });

  List<CryptoWithdrawHistoryDetails>? data;
  int? total;
  int? limit;
  int? page;
  int? pages;
  String? typename;

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: json["data"] == null ? null : List<CryptoWithdrawHistoryDetails>.from(json["data"].map((x) => CryptoWithdrawHistoryDetails.fromJson(x))),
    total: json["total"] == null ? null : json["total"],
    limit: json["limit"] == null ? null : json["limit"],
    page: json["page"] == null ? null : json["page"],
    pages: json["pages"] == null ? null : json["pages"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total == null ? null : total,
    "limit": limit == null ? null : limit,
    "page": page == null ? null : page,
    "pages": pages == null ? null : pages,
    "__typename": typename == null ? null : typename,
  };
}

class CryptoDepositHistoryDetails {
  CryptoDepositHistoryDetails({
    this.status,
    this.transactionId,
    this.currencyCode,
    this.address,
    this.amount,
    this.userAmount,
    this.adminAmount,
    this.createdDate,
    this.modifiedDate,
    this.typename,
  });

  String? status;
  String? transactionId;
  String? currencyCode;
  String? address;
  num? amount;
  num? userAmount;
  num? adminAmount;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? typename;

  factory CryptoDepositHistoryDetails.fromRawJson(String str) => CryptoDepositHistoryDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CryptoDepositHistoryDetails.fromJson(Map<String, dynamic> json) => CryptoDepositHistoryDetails(
    status: json["status"] == null ? null : json["status"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    address: json["address"] == null ? null : json["address"],
    amount: json["amount"] == null ? null : json["amount"],
    userAmount: json["user_amount"] == null ? null : json["user_amount"].toDouble(),
    adminAmount: json["admin_amount"] == null ? null : json["admin_amount"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "transaction_id": transactionId == null ? null : transactionId,
    "currency_code": currencyCode == null ? null : currencyCode,
    "address": address == null ? null : address,
    "amount": amount == null ? null : amount,
    "user_amount": userAmount == null ? null : userAmount,
    "admin_amount": adminAmount == null ? null : adminAmount,
    "created_date": createdDate == null ? null : createdDate?.toIso8601String(),
    "modified_date": modifiedDate == null ? null : modifiedDate?.toIso8601String(),
    "__typename": typename == null ? null : typename,
  };
}
