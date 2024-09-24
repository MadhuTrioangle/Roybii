// To parse this JSON data, do
//
//     final cryptoWithdrawHistory = cryptoWithdrawHistoryFromJson(jsonString);

import 'dart:convert';

class CryptoWithdrawHistory {
  CryptoWithdrawHistory({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  Result? result;
  String? typename;

  factory CryptoWithdrawHistory.fromRawJson(String str) => CryptoWithdrawHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CryptoWithdrawHistory.fromJson(Map<String, dynamic> json) => CryptoWithdrawHistory(
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

class CryptoWithdrawHistoryDetails {
  CryptoWithdrawHistoryDetails({
    this.fromAddress,
    this.amount_mob,
    this.amount,
    this.type,
    this.toAddress,
    this.sentAmount,
    this.receivedAmount,
    this.status,
    this.adminFee,
    this.createdDate,
    this.currencyCode,
    this.transactionId,
    this.typename,
    this.address,
    this.userAmount,
    this.adminAmount,
    this.modifiedDate,
  });

  String? fromAddress;
  String? type;
  num? amount_mob;
  num? amount;
  String? toAddress;
  num? sentAmount;
  num? receivedAmount;
  String? status;
  num? adminFee;
  DateTime? createdDate;
  String? currencyCode;
  String? transactionId;
  String? typename;
  String? address;
  num? userAmount;
  num? adminAmount;
  DateTime? modifiedDate;

  factory CryptoWithdrawHistoryDetails.fromRawJson(String str) => CryptoWithdrawHistoryDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CryptoWithdrawHistoryDetails.fromJson(Map<String, dynamic> json) => CryptoWithdrawHistoryDetails(
    fromAddress: json["from_address"] == null ? null : json["from_address"],
    toAddress: json["to_address"] == null ? null : json["to_address"],
    sentAmount: json["sent_amount"] == null ? null : json["sent_amount"].toDouble(),
    receivedAmount: json["received_amount"] == null ? null : json["received_amount"].toDouble(),
    status: json["status"] == null ? null : json["status"],
    type: json["type"] == null ? null : json["type"],
    amount_mob: json["amount_mob"] == null ? null : json["amount_mob"].toDouble(),
    amount: json["amount"] == null ? null : json["amount"].toDouble(),
    adminFee: json["admin_fee"] == null ? null : json["admin_fee"].toDouble(),
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    typename: json["__typename"] == null ? null : json["__typename"],
    address: json["address"] == null ? null : json["address"],
    userAmount: json["user_amount"] == null ? null : json["user_amount"].toDouble(),
    adminAmount: json["admin_amount"] == null ? null : json["admin_amount"],
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),

  );

  Map<String, dynamic> toJson() => {
    "from_address": fromAddress == null ? null : fromAddress,
    "to_address": toAddress == null ? null : toAddress,
    "sent_amount": sentAmount == null ? null : sentAmount,
    "type": type == null ? null : type,
    "amount_mob": amount_mob == null ? null : amount_mob,
    "amount": amount == null ? null : amount,
    "received_amount": receivedAmount == null ? null : receivedAmount,
    "status": status == null ? null : status,
    "admin_fee": adminFee == null ? null : adminFee,
    "created_date": createdDate == null ? null : createdDate?.toIso8601String(),
    "currency_code": currencyCode == null ? null : currencyCode,
    "transaction_id": transactionId == null ? null : transactionId,
    "__typename": typename == null ? null : typename,
    "address": address == null ? null : address,
    "user_amount": userAmount == null ? null : userAmount,
    "admin_amount": adminAmount == null ? null : adminAmount,
    "modified_date": modifiedDate == null ? null : modifiedDate?.toIso8601String(),
  };
}
