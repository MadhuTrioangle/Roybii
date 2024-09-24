// import 'dart:convert';
//
// class FavoriteAllMarketsModelClass {
//   int? statusCode;
//   String? statusMessage;
//   FavoriteMarkets? result;
//   String? typename;
//
//   FavoriteAllMarketsModelClass({
//     this.statusCode,
//     this.statusMessage,
//     this.result,
//     this.typename,
//   });
//
//   factory FavoriteAllMarketsModelClass.fromRawJson(String str) =>
//       FavoriteAllMarketsModelClass.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory FavoriteAllMarketsModelClass.fromJson(Map<String, dynamic> json) =>
//       FavoriteAllMarketsModelClass(
//         statusCode: json["status_code"],
//         statusMessage: json["status_message"],
//         result: json["result"] == null
//             ? null
//             : FavoriteMarkets.fromJson(json["result"]),
//         typename: json["__typename"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status_code": statusCode,
//         "status_message": statusMessage,
//         "result": result?.toJson(),
//         "__typename": typename,
//       };
// }
//
// class FavoriteMarkets {
//   List<MarginTrade>? spot;
//   List<MarginTrade>? margin;
//   List<FutureTrade>? future;
//   String? typename;
//
//   FavoriteMarkets({
//     this.spot,
//     this.margin,
//     this.future,
//     this.typename,
//   });
//
//   factory FavoriteMarkets.fromRawJson(String str) =>
//       FavoriteMarkets.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory FavoriteMarkets.fromJson(Map<String, dynamic> json) =>
//       FavoriteMarkets(
//         spot: json["spot"] == null
//             ? []
//             : List<MarginTrade>.from(
//                 json["spot"]!.map((x) => MarginTrade.fromJson(x))),
//         margin: json["margin"] == null
//             ? []
//             : List<MarginTrade>.from(
//                 json["margin"]!.map((x) => MarginTrade.fromJson(x))),
//         future: json["future"] == null
//             ? []
//             : List<FutureTrade>.from(
//                 json["future"]!.map((x) => FutureTrade.fromJson(x))),
//         typename: json["__typename"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "spot": spot == null
//             ? []
//             : List<dynamic>.from(spot!.map((x) => x.toJson())),
//         "margin": margin == null
//             ? []
//             : List<dynamic>.from(margin!.map((x) => x.toJson())),
//         "future": future == null
//             ? []
//             : List<dynamic>.from(future!.map((x) => x.toJson())),
//         "__typename": typename,
//       };
// }
//
// class FutureTrade {
//   String? contractType;
//   String? markets;
//   String? symbol;
//   String? price;
//   String? changePercent;
//   String? high24H;
//   String? low24H;
//   String? volume24H;
//   List<FavExchangeRate>? exchangeRates;
//   String? typename;
//
//   FutureTrade({
//     this.contractType,
//     this.markets,
//     this.symbol,
//     this.price,
//     this.changePercent,
//     this.high24H,
//     this.low24H,
//     this.volume24H,
//     this.exchangeRates,
//     this.typename,
//   });
//
//   factory FutureTrade.fromRawJson(String str) =>
//       FutureTrade.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory FutureTrade.fromJson(Map<String, dynamic> json) => FutureTrade(
//         contractType: json["contract_type"],
//         markets: json["markets"],
//         symbol: json["symbol"],
//         price: json["price"],
//         changePercent: json["change_percent"],
//         high24H: json["high_24h"],
//         low24H: json["low_24h"],
//         volume24H: json["volume_24h"],
//         exchangeRates: json["exchange_rates"] == null
//             ? []
//             : List<FavExchangeRate>.from(json["exchange_rates"]!
//                 .map((x) => FavExchangeRate.fromJson(x))),
//         typename: json["__typename"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "contract_type": contractType,
//         "markets": markets,
//         "symbol": symbol,
//         "price": price,
//         "change_percent": changePercent,
//         "high_24h": high24H,
//         "low_24h": low24H,
//         "volume_24h": volume24H,
//         "exchange_rates": exchangeRates == null
//             ? []
//             : List<dynamic>.from(exchangeRates!.map((x) => x.toJson())),
//         "__typename": typename,
//       };
// }
//
// class FavExchangeRate {
//   ToCurrencyCode? toCurrencyCode;
//   String? exchangeRate;
//   Typename? typename;
//
//   FavExchangeRate({
//     this.toCurrencyCode,
//     this.exchangeRate,
//     this.typename,
//   });
//
//   factory FavExchangeRate.fromRawJson(String str) =>
//       FavExchangeRate.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory FavExchangeRate.fromJson(Map<String, dynamic> json) =>
//       FavExchangeRate(
//         toCurrencyCode: toCurrencyCodeValues.map[json["to_currency_code"]],
//         exchangeRate: json["exchange_rate"],
//         typename: typenameValues.map[json["__typename"]],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "to_currency_code": toCurrencyCodeValues.reverse[toCurrencyCode],
//         "exchange_rate": exchangeRate,
//         "__typename": typenameValues.reverse[typename],
//       };
// }
//
// enum ToCurrencyCode { ARS, BRL, COP, EUR, GBP, INR, MXN, ONE, RKL, USD }
//
// final toCurrencyCodeValues = EnumValues({
//   "ARS": ToCurrencyCode.ARS,
//   "BRL": ToCurrencyCode.BRL,
//   "COP": ToCurrencyCode.COP,
//   "EUR": ToCurrencyCode.EUR,
//   "GBP": ToCurrencyCode.GBP,
//   "INR": ToCurrencyCode.INR,
//   "MXN": ToCurrencyCode.MXN,
//   "ONE": ToCurrencyCode.ONE,
//   "RKL": ToCurrencyCode.RKL,
//   "USD": ToCurrencyCode.USD
// });
//
// enum Typename { EXCHANGE_DATA }
//
// final typenameValues = EnumValues({"exchangeData": Typename.EXCHANGE_DATA});
//
// class MarginTrade {
//   String? pair;
//   String? modifiedPair;
//   String? price;
//   String? changePercent;
//   String? high24H;
//   String? low24H;
//   String? volume24H;
//   String? leverage;
//   List<FavExchangeRate>? exchangeRates;
//   String? typename;
//
//   MarginTrade({
//     this.pair,
//     this.modifiedPair,
//     this.price,
//     this.changePercent,
//     this.high24H,
//     this.low24H,
//     this.volume24H,
//     this.leverage,
//     this.exchangeRates,
//     this.typename,
//   });
//
//   factory MarginTrade.fromRawJson(String str) =>
//       MarginTrade.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory MarginTrade.fromJson(Map<String, dynamic> json) => MarginTrade(
//         pair: json["pair"],
//         modifiedPair: json["modified_pair"],
//         price: json["price"],
//         changePercent: json["change_percent"],
//         high24H: json["high_24h"],
//         low24H: json["low_24h"],
//         volume24H: json["volume_24h"],
//         leverage: json["leverage"],
//         exchangeRates: json["exchange_rates"] == null
//             ? []
//             : List<FavExchangeRate>.from(json["exchange_rates"]!
//                 .map((x) => FavExchangeRate.fromJson(x))),
//         typename: json["__typename"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "pair": pair,
//         "modified_pair": modifiedPair,
//         "price": price,
//         "change_percent": changePercent,
//         "high_24h": high24H,
//         "low_24h": low24H,
//         "volume_24h": volume24H,
//         "leverage": leverage,
//         "exchange_rates": exchangeRates == null
//             ? []
//             : List<dynamic>.from(exchangeRates!.map((x) => x.toJson())),
//         "__typename": typename,
//       };
// }
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

// To parse this JSON data, do
//
//     final favoriteAllMarketsModelClass = favoriteAllMarketsModelClassFromJson(jsonString);

import 'dart:convert';


class FavoriteAllMarketsModelClass {
  int? statusCode;
  String? statusMessage;
  FavoriteMarkets? result;
  String? typename;

  FavoriteAllMarketsModelClass({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory FavoriteAllMarketsModelClass.fromRawJson(String str) => FavoriteAllMarketsModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavoriteAllMarketsModelClass.fromJson(Map<String, dynamic> json) => FavoriteAllMarketsModelClass(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : FavoriteMarkets.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class FavoriteMarkets {
  List<MarginTrade>? spot;
  String? typename;

  FavoriteMarkets({
    this.spot,
    this.typename,
  });

  factory FavoriteMarkets.fromRawJson(String str) => FavoriteMarkets.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavoriteMarkets.fromJson(Map<String, dynamic> json) => FavoriteMarkets(
    spot: json["spot"] == null ? [] : List<MarginTrade>.from(json["spot"]!.map((x) => MarginTrade.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "spot": spot == null ? [] : List<dynamic>.from(spot!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class MarginTrade {
  String? pair;
  String? modifiedPair;
  String? price;
  String? changePercent;
  String? high24H;
  String? low24H;
  String? volume24H;
  List<FavExchangeRate>? exchangeRates;
  String? typename;

  MarginTrade({
    this.pair,
    this.modifiedPair,
    this.price,
    this.changePercent,
    this.high24H,
    this.low24H,
    this.volume24H,
    this.exchangeRates,
    this.typename,
  });

  factory MarginTrade.fromRawJson(String str) => MarginTrade.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MarginTrade.fromJson(Map<String, dynamic> json) => MarginTrade(
    pair: json["pair"],
    modifiedPair: json["modified_pair"],
    price: json["price"],
    changePercent: json["change_percent"],
    high24H: json["high_24h"],
    low24H: json["low_24h"],
    volume24H: json["volume_24h"],
    exchangeRates: json["exchange_rates"] == null ? [] : List<FavExchangeRate>.from(json["exchange_rates"]!.map((x) => FavExchangeRate.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "pair": pair,
    "modified_pair": modifiedPair,
    "price": price,
    "change_percent": changePercent,
    "high_24h": high24H,
    "low_24h": low24H,
    "volume_24h": volume24H,
    "exchange_rates": exchangeRates == null ? [] : List<dynamic>.from(exchangeRates!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class FavExchangeRate {
  String? toCurrencyCode;
  String? exchangeRate;
  Typename? typename;

  FavExchangeRate({
    this.toCurrencyCode,
    this.exchangeRate,
    this.typename,
  });

  factory FavExchangeRate.fromRawJson(String str) => FavExchangeRate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavExchangeRate.fromJson(Map<String, dynamic> json) => FavExchangeRate(
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

enum Typename {
  EXCHANGE_DATA
}

final typenameValues = EnumValues({
  "exchangeData": Typename.EXCHANGE_DATA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
