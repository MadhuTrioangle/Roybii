// To parse this JSON data, do
//
//     final getFiatCurrency = getFiatCurrencyFromJson(jsonString);

import 'dart:convert';

class GetFiatCurrencyForWithdraw {
  GetFiatCurrencyForWithdraw({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<GetFiatCurrencies>? result;
  String? typename;

  factory GetFiatCurrencyForWithdraw.fromRawJson(String str) => GetFiatCurrencyForWithdraw.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFiatCurrencyForWithdraw.fromJson(Map<String, dynamic> json) => GetFiatCurrencyForWithdraw(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<GetFiatCurrencies>.from(json["result"].map((x) => GetFiatCurrencies.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class GetFiatCurrencies {
  GetFiatCurrencies({
    this.currencyCode,
    this.minWithdrawLimit,
    this.withdrawFee,
    this.typename,
  });

  String? currencyCode;
  num? minWithdrawLimit;
  num? withdrawFee;
  Typename? typename;

  factory GetFiatCurrencies.fromRawJson(String str) => GetFiatCurrencies.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFiatCurrencies.fromJson(Map<String, dynamic> json) => GetFiatCurrencies(
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    minWithdrawLimit: json["min_withdraw_limit"] == null ? null : json["min_withdraw_limit"].toDouble(),
    withdrawFee: json["withdraw_fee"] == null ? null : json["withdraw_fee"],
    typename: json["__typename"] == null ? null : typenameValues.map![json["__typename"]],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode == null ? null : currencyCode,
    "min_withdraw_limit": minWithdrawLimit == null ? null : minWithdrawLimit,
    "withdraw_fee": withdrawFee == null ? null : withdrawFee,
    "__typename": typename == null ? null : typenameValues.reverse[typename],
  };
}

enum Typename { FIAT_CURRENCY_RESPONSE }

final typenameValues = EnumValues({
  "fiatCurrencyResponse": Typename.FIAT_CURRENCY_RESPONSE
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap ?? Map();
  }
}
