import 'dart:convert';

class GetFutureMarketModelClass {
  int? statusCode;
  String? statusMessage;
  List<GetFutureMarket>? result;
  String? typename;

  GetFutureMarketModelClass({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory GetFutureMarketModelClass.fromRawJson(String str) =>
      GetFutureMarketModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFutureMarketModelClass.fromJson(Map<String, dynamic> json) =>
      GetFutureMarketModelClass(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? []
            : List<GetFutureMarket>.from(
                json["result"]!.map((x) => GetFutureMarket.fromJson(x))),
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

class GetFutureMarket {
  String? symbol;
  String? contractType;
  String? price;
  String? low24H;
  String? high24H;
  String? volume24H;
  bool? fav;
  dynamic toCurrencyCode;
  dynamic fromCurrencyCode;
  String? changePercent;
  List<ExchangeRates>? exchangeRates;
  String? typename;

  GetFutureMarket({
    this.symbol,
    this.contractType,
    this.price,
    this.low24H,
    this.high24H,
    this.volume24H,
    this.fav,
    this.toCurrencyCode,
    this.fromCurrencyCode,
    this.changePercent,
    this.exchangeRates,
    this.typename,
  });

  factory GetFutureMarket.fromRawJson(String str) =>
      GetFutureMarket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFutureMarket.fromJson(Map<String, dynamic> json) =>
      GetFutureMarket(
        symbol: json["symbol"],
        contractType: json["contract_type"],
        price: json["price"],
        low24H: json["low_24h"],
        high24H: json["high_24h"],
        volume24H: json["volume_24h"],
        fav: json["fav"],
        toCurrencyCode: json["to_currency_code"],
        fromCurrencyCode: json["from_currency_code"],
        changePercent: json["change_percent"],
        exchangeRates: json["exchange_rates"] == null
            ? []
            : List<ExchangeRates>.from(
                json["exchange_rates"]!.map((x) => ExchangeRates.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "contract_type": contractType,
        "price": price,
        "low_24h": low24H,
        "high_24h": high24H,
        "volume_24h": volume24H,
        "fav": fav,
        "to_currency_code": toCurrencyCode,
        "from_currency_code": fromCurrencyCode,
        "change_percent": changePercent,
        "exchange_rates": exchangeRates == null
            ? []
            : List<dynamic>.from(exchangeRates!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class ExchangeRates {
  String? toCurrencyCode;
  String? exchangeRate;
  Typename? typename;

  ExchangeRates({
    this.toCurrencyCode,
    this.exchangeRate,
    this.typename,
  });

  factory ExchangeRates.fromRawJson(String str) =>
      ExchangeRates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExchangeRates.fromJson(Map<String, dynamic> json) => ExchangeRates(
        toCurrencyCode: json["to_currency_code"],
        exchangeRate: json["exchange_rate"],
        typename: typenameValues.map[json["__typename"]]!,
      );

  Map<String, dynamic> toJson() => {
        "to_currency_code": toCurrencyCode,
        "exchange_rate": exchangeRate,
        "__typename": typenameValues.reverse[typename],
      };
}

enum Typename { EXCHANGE_DATA }

final typenameValues = EnumValues({"exchangeData": Typename.EXCHANGE_DATA});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
