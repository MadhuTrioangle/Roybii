import 'dart:convert';

class GetSpotMarketModelClass {
  int? statusCode;
  String? statusMessage;
  List<String>? fiatCurrency;
  List<GetSpotMarket>? result;
  String? typename;

  GetSpotMarketModelClass({
    this.statusCode,
    this.statusMessage,
    this.fiatCurrency,
    this.result,
    this.typename,
  });

  factory GetSpotMarketModelClass.fromRawJson(String str) =>
      GetSpotMarketModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSpotMarketModelClass.fromJson(Map<String, dynamic> json) =>
      GetSpotMarketModelClass(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        fiatCurrency: json["fiatCurrency"] == null
            ? []
            : List<String>.from(json["fiatCurrency"]!.map((x) => x)),
        result: json["result"] == null
            ? []
            : List<GetSpotMarket>.from(
                json["result"]!.map((x) => GetSpotMarket.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "fiatCurrency": fiatCurrency == null
            ? []
            : List<dynamic>.from(fiatCurrency!.map((x) => x)),
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class GetSpotMarket {
  String? pair;
  String? code;
  String? modifiedPair;
  String? image;
  bool? market;
  String? changePercent;
  String? low24H;
  bool? fav;
  String? high24H;
  String? volume24H;
  String? price;
  String? leverage;
  List<ExchangeRate>? exchangeRates;
  ResultTypename? typename;

  GetSpotMarket({
    this.pair,
    this.code,
    this.modifiedPair,
    this.image,
    this.market,
    this.changePercent,
    this.low24H,
    this.fav,
    this.high24H,
    this.volume24H,
    this.price,
    this.leverage,
    this.exchangeRates,
    this.typename,
  });

  factory GetSpotMarket.fromRawJson(String str) =>
      GetSpotMarket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSpotMarket.fromJson(Map<String, dynamic> json) => GetSpotMarket(
        pair: json["pair"],
        code: json["code"],
        modifiedPair: json["modified_pair"],
        image: json["image"],
        market: json["market"],
        changePercent: json["change_percent"],
        low24H: json["low_24h"],
        fav: json["fav"],
        high24H: json["high_24h"],
        volume24H: json["volume_24h"],
        price: json["price"],
        leverage: json["leverage"],
        exchangeRates: json["exchange_rates"] == null
            ? []
            : List<ExchangeRate>.from(
                json["exchange_rates"]!.map((x) => ExchangeRate.fromJson(x))),
        typename: resultTypenameValues.map[json["__typename"]]!,
      );

  Map<String, dynamic> toJson() => {
        "pair": pair,
        "code": code,
        "modified_pair": modifiedPair,
        "image": image,
        "market": market,
        "change_percent": changePercent,
        "low_24h": low24H,
        "fav": fav,
        "high_24h": high24H,
        "volume_24h": volume24H,
        "price": price,
        "leverage": leverage,
        "exchange_rates": exchangeRates == null
            ? []
            : List<dynamic>.from(exchangeRates!.map((x) => x.toJson())),
        "__typename": resultTypenameValues.reverse[typename],
      };
}

class ExchangeRate {
  String? toCurrencyCode;
  String? exchangeRate;
  ExchangeRateTypename? typename;

  ExchangeRate({
    this.toCurrencyCode,
    this.exchangeRate,
    this.typename,
  });

  factory ExchangeRate.fromRawJson(String str) =>
      ExchangeRate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExchangeRate.fromJson(Map<String, dynamic> json) => ExchangeRate(
        toCurrencyCode: json["to_currency_code"],
        exchangeRate: json["exchange_rate"],
        typename: exchangeRateTypenameValues.map[json["__typename"]]!,
      );

  Map<String, dynamic> toJson() => {
        "to_currency_code": toCurrencyCode,
        "exchange_rate": exchangeRate,
        "__typename": exchangeRateTypenameValues.reverse[typename],
      };
}

enum ExchangeRateTypename { EXCHANGE_DATA }

final exchangeRateTypenameValues =
    EnumValues({"exchangeData": ExchangeRateTypename.EXCHANGE_DATA});

enum ResultTypename { MARKET_DATA }

final resultTypenameValues =
    EnumValues({"marketData": ResultTypename.MARKET_DATA});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
