// To parse this JSON data, do
//
//     final walletBalanceModel = walletBalanceModelFromJson(jsonString);

import 'dart:convert';

class WalletBalanceModel {
  String? socketId;
  BalanceDetails? firstCurrency;
  BalanceDetails? secondCurrency;

  WalletBalanceModel({
    this.socketId,
    this.firstCurrency,
    this.secondCurrency,
  });

  factory WalletBalanceModel.fromRawJson(String str) =>
      WalletBalanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) =>
      WalletBalanceModel(
        socketId: json["socket_id"],
        firstCurrency: json["firstCurrency"] == null
            ? null
            : BalanceDetails.fromJson(json["firstCurrency"]),
        secondCurrency: json["secondCurrency"] == null
            ? null
            : BalanceDetails.fromJson(json["secondCurrency"]),
      );

  Map<String, dynamic> toJson() => {
        "socket_id": socketId,
        "firstCurrency": firstCurrency?.toJson(),
        "secondCurrency": secondCurrency?.toJson(),
      };
}

class BalanceDetails {
  String? currencyCode;
  num? amount;
  num? inorder;
  bool? newDeposit;
  String? id;

  BalanceDetails({
    this.currencyCode,
    this.amount,
    this.inorder,
    this.newDeposit,
    this.id,
  });

  factory BalanceDetails.fromRawJson(String str) =>
      BalanceDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BalanceDetails.fromJson(Map<String, dynamic> json) => BalanceDetails(
        currencyCode: json["currency_code"],
        amount: json["Amount"]?.toDouble(),
        inorder: json["inorder"]?.toDouble(),
        newDeposit: json["new_deposit"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "currency_code": currencyCode,
        "Amount": amount,
        "inorder": inorder,
        "new_deposit": newDeposit,
        "_id": id,
      };
}
