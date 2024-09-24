// To parse this JSON data, do
//
//     final getCurrencyModel = getCurrencyModelFromJson(jsonString);

import 'dart:convert';

class GetCurrencyModel {
  GetCurrencyModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<GetCurrency>? result;
  String? typename;

  factory GetCurrencyModel.fromRawJson(String str) => GetCurrencyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCurrencyModel.fromJson(Map<String, dynamic> json) => GetCurrencyModel(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<GetCurrency>.from(json["result"].map((x) => GetCurrency.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class GetCurrency {
  GetCurrency({
    this.image,
    this.currencyCode,
    this.minWithdrawLimit,
    this.withdrawFee,
    this.typename,
  });

  String? image;
  String? currencyCode;
  num? minWithdrawLimit;
  num? withdrawFee;
  String? typename;

  factory GetCurrency.fromRawJson(String str) => GetCurrency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetCurrency.fromJson(Map<String, dynamic> json) => GetCurrency(
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    image: json["image"] == null ? null : json["image"],
    minWithdrawLimit: json["min_withdraw_limit"] == null ? null : json["min_withdraw_limit"].toDouble(),
    withdrawFee: json["withdraw_fee"] == null ? null : json["withdraw_fee"].toDouble(),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "image": image == null ? null : image,
    "currency_code": currencyCode == null ? null : currencyCode,
    "min_withdraw_limit": minWithdrawLimit == null ? null : minWithdrawLimit,
    "withdraw_fee": withdrawFee == null ? null : withdrawFee,
    "__typename": typename == null ? null : typename,
  };
}
