// To parse this JSON data, do
//
//     final currencyPreference = currencyPreferenceFromJson(jsonString);

import 'dart:convert';

class CurrencyPreference {
  CurrencyPreference({
    this.data,
  });

  Data ?data;

  factory CurrencyPreference.fromRawJson(String str) => CurrencyPreference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrencyPreference.fromJson(Map<String, dynamic> json) => CurrencyPreference(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.getFiatCurrency,
  });

  GetFiatCurrency ?getFiatCurrency;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    getFiatCurrency: json["getFiatCurrency"] == null ? null : GetFiatCurrency.fromJson(json["getFiatCurrency"]),
  );

  Map<String, dynamic> toJson() => {
    "getFiatCurrency": getFiatCurrency == null ? null : getFiatCurrency!.toJson(),
  };
}

class GetFiatCurrency {
  GetFiatCurrency({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  List<FiatCurrency>? result;
  String ?typename;

  factory GetFiatCurrency.fromRawJson(String str) => GetFiatCurrency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetFiatCurrency.fromJson(Map<String, dynamic> json) => GetFiatCurrency(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<FiatCurrency>.from(json["result"].map((x) => FiatCurrency.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}


class FiatCurrency {
  FiatCurrency({
    this.currencyCode,
    this.currencyName,
    this.minWithdrawLimit,
    this.withdrawFee,
    this.typename,
  });

  String ?currencyCode;
  String? currencyName;
  num ?minWithdrawLimit;
  num ?withdrawFee;
  Typename ?typename;

  factory FiatCurrency.fromRawJson(String str) => FiatCurrency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FiatCurrency.fromJson(Map<String, dynamic> json) => FiatCurrency(
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    currencyName: json["currency_name"] == null ? null : json["currency_name"],
    minWithdrawLimit: json["min_withdraw_limit"] == null ? null : json["min_withdraw_limit"].toDouble(),
    withdrawFee: json["withdraw_fee"] == null ? null : json["withdraw_fee"],
    typename: json["__typename"] == null ? null : typenameValues.map[json["__typename"]],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode == null ? null : currencyCode,
    "currency_name": currencyName == null ? null : currencyName,
    "min_withdraw_limit": minWithdrawLimit == null ? null : minWithdrawLimit,
    "withdraw_fee": withdrawFee == null ? null : withdrawFee,
    "__typename": typename == null ? null : typenameValues.reverse![typename],
  };
}

enum Typename { FIAT_CURRENCY_RESPONSE }

final typenameValues = EnumValues({
  "fiatCurrencyResponse": Typename.FIAT_CURRENCY_RESPONSE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
