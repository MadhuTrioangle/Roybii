import 'dart:convert';

class StakedBalanceModel {
  int? statusCode;
  String? statusMessage;
  StakedBalance? result;

  StakedBalanceModel({
    this.statusCode,
    this.statusMessage,
    this.result,
  });

  factory StakedBalanceModel.fromRawJson(String str) =>
      StakedBalanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StakedBalanceModel.fromJson(Map<String, dynamic> json) =>
      StakedBalanceModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : StakedBalance.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
      };
}

class StakedBalance {
  List<EarnBalance>? earnBalance;
  List<StakeBalance>? stakeBalance;

  StakedBalance({
    this.earnBalance,
    this.stakeBalance,
  });

  factory StakedBalance.fromRawJson(String str) =>
      StakedBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StakedBalance.fromJson(Map<String, dynamic> json) => StakedBalance(
        earnBalance: json["earnBalance"] == null
            ? []
            : List<EarnBalance>.from(
                json["earnBalance"]!.map((x) => EarnBalance.fromJson(x))),
        stakeBalance: json["stakeBalance"] == null
            ? []
            : List<StakeBalance>.from(
                json["stakeBalance"]!.map((x) => StakeBalance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "earnBalance": earnBalance == null
            ? []
            : List<dynamic>.from(earnBalance!.map((x) => x.toJson())),
        "stakeBalance": stakeBalance == null
            ? []
            : List<dynamic>.from(stakeBalance!.map((x) => x.toJson())),
      };
}

class EarnBalance {
  String? id;
  double? totalEarnAmount;
  double? stakeEarnBalanceByUserPreferred;
  double? stakeEarnBalanceByDefaultCurrency;

  EarnBalance({
    this.id,
    this.totalEarnAmount,
    this.stakeEarnBalanceByUserPreferred,
    this.stakeEarnBalanceByDefaultCurrency,
  });

  factory EarnBalance.fromRawJson(String str) =>
      EarnBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarnBalance.fromJson(Map<String, dynamic> json) => EarnBalance(
        id: json["_id"],
        totalEarnAmount: json["totalEarnAmount"]?.toDouble(),
        stakeEarnBalanceByUserPreferred:
            json["stakeEarnBalanceByUserPreferred"]?.toDouble(),
        stakeEarnBalanceByDefaultCurrency:
            json["stakeEarnBalanceByDefaultCurrency"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "totalEarnAmount": totalEarnAmount,
        "stakeEarnBalanceByUserPreferred": stakeEarnBalanceByUserPreferred,
        "stakeEarnBalanceByDefaultCurrency": stakeEarnBalanceByDefaultCurrency,
      };
}

class StakeBalance {
  String? id;
  num? stakeBalance;
  num? stakeBalanceByUserPreferred;
  num? stakeBalanceByDefaultCurrency;

  StakeBalance({
    this.id,
    this.stakeBalance,
    this.stakeBalanceByUserPreferred,
    this.stakeBalanceByDefaultCurrency,
  });

  factory StakeBalance.fromRawJson(String str) =>
      StakeBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StakeBalance.fromJson(Map<String, dynamic> json) => StakeBalance(
        id: json["_id"],
        stakeBalance: json["stakeBalance"],
        stakeBalanceByUserPreferred:
            json["stakeBalanceByUserPreferred"]?.toDouble(),
        stakeBalanceByDefaultCurrency:
            json["stakeBalanceByDefaultCurrency"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "stakeBalance": stakeBalance,
        "stakeBalanceByUserPreferred": stakeBalanceByUserPreferred,
        "stakeBalanceByDefaultCurrency": stakeBalanceByDefaultCurrency,
      };
}
