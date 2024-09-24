// To parse this JSON data, do
//
//     final getMarketOverviewModel = getMarketOverviewModelFromJson(jsonString);

import 'dart:convert';

GetMarketOverviewModel getMarketOverviewModelFromJson(String str) => GetMarketOverviewModel.fromJson(json.decode(str));

String getMarketOverviewModelToJson(GetMarketOverviewModel data) => json.encode(data.toJson());

class GetMarketOverviewModel {
  int statusCode;
  String statusMessage;
  Overview result;
  String typename;

  GetMarketOverviewModel({
    required this.statusCode,
    required this.statusMessage,
    required this.result,
    required this.typename,
  });

  factory GetMarketOverviewModel.fromJson(Map<String, dynamic> json) => GetMarketOverviewModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: Overview.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result.toJson(),
    "__typename": typename,
  };
}

class Overview {
  List<Gainer> highlight;
  List<Gainer> gainer;
  List<Gainer> volume;
  String typename;

  Overview({
    required this.highlight,
    required this.gainer,
    required this.volume,
    required this.typename,
  });

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
    highlight: List<Gainer>.from(json["highlight"].map((x) => Gainer.fromJson(x))),
    gainer: List<Gainer>.from(json["gainer"].map((x) => Gainer.fromJson(x))),
    volume: List<Gainer>.from(json["volume"].map((x) => Gainer.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "highlight": List<dynamic>.from(highlight.map((x) => x.toJson())),
    "gainer": List<dynamic>.from(gainer.map((x) => x.toJson())),
    "volume": List<dynamic>.from(volume.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class Gainer {
  String image;
  String code;
  String price;
  String changePercent;
  List<ExchangeRate> exchangeRates;
  GainerTypename typename;
  String? volume24H;

  Gainer({
    required this.image,
    required this.code,
    required this.price,
    required this.changePercent,
    required this.exchangeRates,
    required this.typename,
    this.volume24H,
  });

  factory Gainer.fromJson(Map<String, dynamic> json) => Gainer(
    image: json["image"],
    code: json["code"],
    price: json["price"],
    changePercent: json["change_percent"],
    exchangeRates: List<ExchangeRate>.from(json["exchange_rates"].map((x) => ExchangeRate.fromJson(x))),
    typename: gainerTypenameValues.map[json["__typename"]]!,
    volume24H: json["volume_24h"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "code": code,
    "price": price,
    "change_percent": changePercent,
    "exchange_rates": List<dynamic>.from(exchangeRates.map((x) => x.toJson())),
    "__typename": gainerTypenameValues.reverse[typename],
    "volume_24h": volume24H,
  };
}

class ExchangeRate {
  String toCurrencyCode;
  String exchangeRate;
  ExchangeRateTypename typename;

  ExchangeRate({
    required this.toCurrencyCode,
    required this.exchangeRate,
    required this.typename,
  });

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

enum ExchangeRateTypename {
  EXCHANGE_DATA
}

final exchangeRateTypenameValues = EnumValues({
  "exchangeData": ExchangeRateTypename.EXCHANGE_DATA
});

enum GainerTypename {
  MARKET_DATA
}

final gainerTypenameValues = EnumValues({
  "marketData": GainerTypename.MARKET_DATA
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
