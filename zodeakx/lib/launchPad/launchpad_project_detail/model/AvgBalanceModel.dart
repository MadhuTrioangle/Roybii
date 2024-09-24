import 'dart:convert';

class AvgBalanceModel {
  int? statusCode;
  String? statusMessage;
  AvgBalance? result;
  String? typename;

  AvgBalanceModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory AvgBalanceModel.fromRawJson(String str) => AvgBalanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvgBalanceModel.fromJson(Map<String, dynamic> json) => AvgBalanceModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : AvgBalance.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class AvgBalance {
  DateTime? subscriptionEndDate;
  DateTime? subscriptionStartDate;
  num? avgBalance;
  String? holdingCurrency;
  String? kyc;
  String? typename;

  AvgBalance({
    this.subscriptionEndDate,
    this.subscriptionStartDate,
    this.avgBalance,
    this.holdingCurrency,
    this.kyc,
    this.typename,
  });

  factory AvgBalance.fromRawJson(String str) => AvgBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvgBalance.fromJson(Map<String, dynamic> json) => AvgBalance(
    subscriptionEndDate: json["subscription_end_date"] == null ? null : DateTime.parse(json["subscription_end_date"]),
    subscriptionStartDate: json["subscription_start_date"] == null ? null : DateTime.parse(json["subscription_start_date"]),
    avgBalance: json["avg_balance"],
    holdingCurrency: json["holding_currency"],
    kyc: json["kyc"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "subscription_end_date": subscriptionEndDate?.toIso8601String(),
    "subscription_start_date": subscriptionStartDate?.toIso8601String(),
    "avg_balance": avgBalance,
    "holding_currency": holdingCurrency,
    "kyc": kyc,
    "__typename": typename,
  };
}
