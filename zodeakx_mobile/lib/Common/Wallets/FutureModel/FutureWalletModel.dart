import 'dart:convert';

class FutureWalletModel {
  num? statusCode;
  String? statusMessage;
  List<FutureWallet>? result;
  String? typename;

  FutureWalletModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory FutureWalletModel.fromRawJson(String str) =>
      FutureWalletModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FutureWalletModel.fromJson(Map<String, dynamic> json) =>
      FutureWalletModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? []
            : List<FutureWallet>.from(
                json["result"]!.map((x) => FutureWallet.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class FutureWallet {
  String? markets;
  String? currencyCode;
  String? image;
  String? currencyName;
  num? availableBalance;
  num? inorderBalance;
  num? defaultTotalBalance;
  num? defaultAvailableBalance;
  num? defaultUnrealizedPnl;
  num? totalBalance;
  num? unrealizedPnl;
  num? availableExchangeBalance;
  num? totalExchangeBalance;
  num? unrealizedPnlExchangeBalance;
  String? typename;

  FutureWallet({
    this.markets,
    this.currencyCode,
    this.image,
    this.currencyName,
    this.availableBalance,
    this.inorderBalance,
    this.defaultTotalBalance,
    this.defaultAvailableBalance,
    this.defaultUnrealizedPnl,
    this.totalBalance,
    this.unrealizedPnl,
    this.availableExchangeBalance,
    this.totalExchangeBalance,
    this.unrealizedPnlExchangeBalance,
    this.typename,
  });

  factory FutureWallet.fromRawJson(String str) =>
      FutureWallet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FutureWallet.fromJson(Map<String, dynamic> json) => FutureWallet(
        markets: json["markets"],
        currencyCode: json["currency_code"],
        image: json["image"],
        currencyName: json["currency_name"],
        availableBalance: json["available_balance"]?.toDouble(),
        inorderBalance: json["inorder_balance"],
        defaultTotalBalance: json["default_total_balance"],
        defaultAvailableBalance: json["default_available_balance"],
        defaultUnrealizedPnl: json["default_unrealized_pnl"],
        totalBalance: json["total_balance"]?.toDouble(),
        unrealizedPnl: json["unrealized_pnl"],
        availableExchangeBalance:
            json["available_exchange_balance"]?.toDouble(),
        totalExchangeBalance: json["total_exchange_balance"]?.toDouble(),
        unrealizedPnlExchangeBalance: json["unrealized_pnl_exchange_balance"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "markets": markets,
        "currency_code": currencyCode,
        "image": image,
        "currency_name": currencyName,
        "available_balance": availableBalance,
        "inorder_balance": inorderBalance,
        "default_total_balance": defaultTotalBalance,
        "default_available_balance": defaultAvailableBalance,
        "default_unrealized_pnl": defaultUnrealizedPnl,
        "total_balance": totalBalance,
        "unrealized_pnl": unrealizedPnl,
        "available_exchange_balance": availableExchangeBalance,
        "total_exchange_balance": totalExchangeBalance,
        "unrealized_pnl_exchange_balance": unrealizedPnlExchangeBalance,
        "__typename": typename,
      };
}
