// To parse this JSON data, do
//
//     final transferHistoryModel = transferHistoryModelFromJson(jsonString);

import 'dart:convert';

class TransferHistoryModel {
  int? statusCode;
  String? statusMessage;
  TransferHistory? result;
  String? typename;

  TransferHistoryModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory TransferHistoryModel.fromRawJson(String str) =>
      TransferHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransferHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransferHistoryModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : TransferHistory.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class TransferHistory {
  int? total;
  int? page;
  int? pages;
  List<TransferHistoryData>? data;
  String? typename;

  TransferHistory({
    this.total,
    this.page,
    this.pages,
    this.data,
    this.typename,
  });

  factory TransferHistory.fromRawJson(String str) =>
      TransferHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransferHistory.fromJson(Map<String, dynamic> json) =>
      TransferHistory(
        total: json["total"],
        page: json["page"],
        pages: json["pages"],
        data: json["data"] == null
            ? []
            : List<TransferHistoryData>.from(
                json["data"]!.map((x) => TransferHistoryData.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "pages": pages,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class TransferHistoryData {
  String? pair;
  String? coin;
  String? marginAccount;
  bool? autoTopupTransferin;
  String? fromWallet;
  String? toWallet;
  num? amount;
  String? status;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? typename;

  TransferHistoryData({
    this.pair,
    this.coin,
    this.marginAccount,
    this.autoTopupTransferin,
    this.fromWallet,
    this.toWallet,
    this.amount,
    this.status,
    this.createdDate,
    this.modifiedDate,
    this.typename,
  });

  factory TransferHistoryData.fromRawJson(String str) =>
      TransferHistoryData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransferHistoryData.fromJson(Map<String, dynamic> json) =>
      TransferHistoryData(
        pair: json["pair"],
        coin: json["coin"],
        marginAccount: json["margin_account"],
        autoTopupTransferin: json["auto_topup_transferin"],
        fromWallet: json["from_wallet"],
        toWallet: json["to_wallet"],
        amount: json["amount"]?.toDouble(),
        status: json["status"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] == null
            ? null
            : DateTime.parse(json["modified_date"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "pair": pair,
        "coin": coin,
        "margin_account": marginAccount,
        "auto_topup_transferin": autoTopupTransferin,
        "from_wallet": fromWallet,
        "to_wallet": toWallet,
        "amount": amount,
        "status": status,
        "created_date": createdDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "__typename": typename,
      };
}
