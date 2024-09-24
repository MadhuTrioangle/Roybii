
import 'dart:convert';

class ExchangeRate {
  ExchangeRate({
    this.data,
  });

  Data? data;

  factory ExchangeRate.fromRawJson(String str) => ExchangeRate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExchangeRate.fromJson(Map<String, dynamic> json) => ExchangeRate(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data?.toJson(),
  };
}

class Data {
  Data({
    this.getExchangeRate,
  });

  GetExchangeRate? getExchangeRate;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    getExchangeRate: json["getExchangeRate"] == null ? null : GetExchangeRate.fromJson(json["getExchangeRate"]),
  );

  Map<String, dynamic> toJson() => {
    "getExchangeRate": getExchangeRate == null ? null : getExchangeRate?.toJson(),
  };
}

class GetExchangeRate {
  GetExchangeRate({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  GetExchangeResult? result;
  String? typename;

  factory GetExchangeRate.fromRawJson(String str) => GetExchangeRate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetExchangeRate.fromJson(Map<String, dynamic> json) => GetExchangeRate(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : GetExchangeResult.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class GetExchangeResult {
  GetExchangeResult({
    this.id,
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.exchangeRate,
    this.typename,
  });

  dynamic id;
  String? fromCurrencyCode;
  String? toCurrencyCode;
  double? exchangeRate;
  String? typename;

  factory GetExchangeResult.fromRawJson(String str) => GetExchangeResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetExchangeResult.fromJson(Map<String, dynamic> json) => GetExchangeResult(
    id: json["_id"],
    fromCurrencyCode: json["from_currency_code"] == null ? null : json["from_currency_code"],
    toCurrencyCode: json["to_currency_code"] == null ? null : json["to_currency_code"],
    exchangeRate: json["exchange_rate"] == null ? null : json["exchange_rate"].toDouble(),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "from_currency_code": fromCurrencyCode == null ? null : fromCurrencyCode,
    "to_currency_code": toCurrencyCode == null ? null : toCurrencyCode,
    "exchange_rate": exchangeRate == null ? null : exchangeRate,
    "__typename": typename == null ? null : typename,
  };
}
