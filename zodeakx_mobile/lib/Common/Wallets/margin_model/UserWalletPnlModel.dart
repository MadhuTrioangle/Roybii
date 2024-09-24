// To parse this JSON data, do
//
//     final userWalletPnlModel = userWalletPnlModelFromJson(jsonString);

import 'dart:convert';

class UserWalletPnlModel {
  int? statusCode;
  String? statusMessage;
  UserWalletPnl? result;
  String? typename;

  UserWalletPnlModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory UserWalletPnlModel.fromRawJson(String str) =>
      UserWalletPnlModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserWalletPnlModel.fromJson(Map<String, dynamic> json) =>
      UserWalletPnlModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : UserWalletPnl.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class UserWalletPnl {
  num? dailyPnl;
  num? crossLeverage;
  num? initialRiskRatioCross;
  num? mcrCross;
  num? liquidationRatioCross;
  IsolatedPnl? mcrIsolated;
  IsolatedPnl? initialRiskRatioIsolated;
  IsolatedPnl? liquidationRatioIsolated;
  String? typename;

  UserWalletPnl({
    this.dailyPnl,
    this.crossLeverage,
    this.initialRiskRatioCross,
    this.mcrCross,
    this.liquidationRatioCross,
    this.mcrIsolated,
    this.initialRiskRatioIsolated,
    this.liquidationRatioIsolated,
    this.typename,
  });

  factory UserWalletPnl.fromRawJson(String str) =>
      UserWalletPnl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserWalletPnl.fromJson(Map<String, dynamic> json) => UserWalletPnl(
        dailyPnl: json["daily_pnl"]?.toDouble(),
        crossLeverage: json["cross_leverage"],
        initialRiskRatioCross: json["initial_risk_ratio_cross"]?.toDouble(),
        mcrCross: json["mcr_cross"]?.toDouble(),
        liquidationRatioCross: json["liquidation_ratio_cross"]?.toDouble(),
        mcrIsolated: json["mcr_isolated"] == null
            ? null
            : IsolatedPnl.fromJson(json["mcr_isolated"]),
        initialRiskRatioIsolated: json["initial_risk_ratio_isolated"] == null
            ? null
            : IsolatedPnl.fromJson(json["initial_risk_ratio_isolated"]),
        liquidationRatioIsolated: json["liquidation_ratio_isolated"] == null
            ? null
            : IsolatedPnl.fromJson(json["liquidation_ratio_isolated"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "daily_pnl": dailyPnl,
        "cross_leverage": crossLeverage,
        "initial_risk_ratio_cross": initialRiskRatioCross,
        "mcr_cross": mcrCross,
        "liquidation_ratio_cross": liquidationRatioCross,
        "mcr_isolated": mcrIsolated?.toJson(),
        "initial_risk_ratio_isolated": initialRiskRatioIsolated?.toJson(),
        "liquidation_ratio_isolated": liquidationRatioIsolated?.toJson(),
        "__typename": typename,
      };
}

class IsolatedPnl {
  num? x3;
  num? x5;
  num? x10;
  String? typename;

  IsolatedPnl({
    this.x3,
    this.x5,
    this.x10,
    this.typename,
  });

  factory IsolatedPnl.fromRawJson(String str) =>
      IsolatedPnl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IsolatedPnl.fromJson(Map<String, dynamic> json) => IsolatedPnl(
        x3: json["x3"]?.toDouble(),
        x5: json["x5"]?.toDouble(),
        x10: json["x10"]?.toDouble(),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "x3": x3,
        "x5": x5,
        "x10": x10,
        "__typename": typename,
      };
}
