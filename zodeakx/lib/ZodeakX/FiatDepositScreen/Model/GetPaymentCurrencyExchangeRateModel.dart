// To parse this JSON data, do
//
//     final getPaymentCurrencyExchangeRate = getPaymentCurrencyExchangeRateFromJson(jsonString);

import 'dart:convert';

class GetPaymentCurrencyExchangeRate {
  GetPaymentCurrencyExchangeRate({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  PaymentCurrencyExchangeRate? result;
  String? typename;

  factory GetPaymentCurrencyExchangeRate.fromRawJson(String str) => GetPaymentCurrencyExchangeRate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPaymentCurrencyExchangeRate.fromJson(Map<String, dynamic> json) => GetPaymentCurrencyExchangeRate(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : PaymentCurrencyExchangeRate.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class PaymentCurrencyExchangeRate {
  PaymentCurrencyExchangeRate({
    this.fromCurrencyCode,
    this.toCurrencyCode,
    this.exchangeRate,
    this.typename,
  });

  String? fromCurrencyCode;
  String? toCurrencyCode;
  dynamic? exchangeRate;
  String? typename;

  factory PaymentCurrencyExchangeRate.fromRawJson(String str) => PaymentCurrencyExchangeRate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentCurrencyExchangeRate.fromJson(Map<String, dynamic> json) => PaymentCurrencyExchangeRate(
    fromCurrencyCode: json["from_currency_code"] == null ? null : json["from_currency_code"],
    toCurrencyCode: json["to_currency_code"] == null ? null : json["to_currency_code"],
    exchangeRate: json["exchange_rate"] == null ? null : json["exchange_rate"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "from_currency_code": fromCurrencyCode == null ? null : fromCurrencyCode,
    "to_currency_code": toCurrencyCode == null ? null : toCurrencyCode,
    "exchange_rate": exchangeRate == null ? null : exchangeRate,
    "__typename": typename == null ? null : typename,
  };
}
