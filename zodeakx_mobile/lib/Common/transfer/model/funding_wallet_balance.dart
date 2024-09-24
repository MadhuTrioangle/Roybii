import 'dart:convert';

import '../../../Utils/Languages/English/StringVariables.dart';

class GetUserFundingWalletDetailsClass {
  int? statusCode;
  String? statusMessage;
  List<GetUserFundingWalletDetails>? result;

  GetUserFundingWalletDetailsClass({
    this.statusCode,
    this.statusMessage,
    this.result,
  });

  factory GetUserFundingWalletDetailsClass.fromRawJson(String str) => GetUserFundingWalletDetailsClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserFundingWalletDetailsClass.fromJson(Map<String, dynamic> json) => GetUserFundingWalletDetailsClass(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<GetUserFundingWalletDetails>.from(json["result"]!.map((x) => GetUserFundingWalletDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class GetUserFundingWalletDetails {
  num? amount;
  num? inorder;
  String? currencyCode;
  num? convertedAmount;
  ConvertedCurrencyCode? convertedCurrencyCode;
  String? currencyLogo;
  String? currencyType;

  GetUserFundingWalletDetails({
    this.amount,
    this.inorder,
    this.currencyCode,
    this.convertedAmount,
    this.convertedCurrencyCode,
    this.currencyLogo,
    this.currencyType,
  });

  factory GetUserFundingWalletDetails.fromRawJson(String str) => GetUserFundingWalletDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserFundingWalletDetails.fromJson(Map<String, dynamic> json) => GetUserFundingWalletDetails(
    amount: json["amount"]?.toDouble(),
    inorder: json["inorder"]?.toDouble(),
    currencyCode: json["currency_code"],
    convertedAmount: json["converted_amount"]?.toDouble(),
    convertedCurrencyCode: convertedCurrencyCodeValues.map[json["converted_currency_code"]]!,
    currencyLogo: json["currency_logo"],
    currencyType: json["currency_type"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "inorder": inorder,
    "currency_code": currencyCode,
    "converted_amount": convertedAmount,
    "converted_currency_code": convertedCurrencyCodeValues.reverse[convertedCurrencyCode],
    "currency_logo": currencyLogo,
    "currency_type": currencyType,
  };
}

enum ConvertedCurrencyCode {
  BTC
}

final convertedCurrencyCodeValues = EnumValues({
  "BTC": ConvertedCurrencyCode.BTC
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

GetUserFundingWalletDetails all = GetUserFundingWalletDetails(currencyCode: stringVariables.all);