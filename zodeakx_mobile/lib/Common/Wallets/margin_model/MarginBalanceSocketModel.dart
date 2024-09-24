import 'dart:convert';

class MarginSocketBalanceModel {
  String? socketId;
  String? pair;
  num? marginRatio;
  bool? isolatedWallet;
  Eth? eth;

  MarginSocketBalanceModel({
    this.socketId,
    this.pair,
    this.marginRatio,
    this.isolatedWallet,
    this.eth,
  });

  factory MarginSocketBalanceModel.fromRawJson(String str) => MarginSocketBalanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MarginSocketBalanceModel.fromJson(Map<String, dynamic> json) => MarginSocketBalanceModel(
    socketId: json["socket_id"],
    pair: json["pair"],
    marginRatio: json["margin_ratio"],
    isolatedWallet: json["isolated_wallet"],
    eth: json["ETH"] == null ? null : Eth.fromJson(json["ETH"]),
  );

  Map<String, dynamic> toJson() => {
    "socket_id": socketId,
    "pair": pair,
    "margin_ratio": marginRatio,
    "isolated_wallet": isolatedWallet,
    "ETH": eth?.toJson(),
  };
}

class Eth {
  String? currencyCode;
  num? totalBalance;
  num? availableBalance;
  num? inorder;
  num? borrowed;
  num? interest;
  String? id;

  Eth({
    this.currencyCode,
    this.totalBalance,
    this.availableBalance,
    this.inorder,
    this.borrowed,
    this.interest,
    this.id,
  });

  factory Eth.fromRawJson(String str) => Eth.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Eth.fromJson(Map<String, dynamic> json) => Eth(
    currencyCode: json["currency_code"],
    totalBalance: json["total_balance"],
    availableBalance: json["available_balance"],
    inorder: json["inorder"],
    borrowed: json["borrowed"],
    interest: json["interest"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode,
    "total_balance": totalBalance,
    "available_balance": availableBalance,
    "inorder": inorder,
    "borrowed": borrowed,
    "interest": interest,
    "_id": id,
  };
}
