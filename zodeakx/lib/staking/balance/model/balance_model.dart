

import 'dart:convert';


class GetUserStakesByIdClass {
  int? statusCode;
  String? statusMessage;
  ParticularDetailsId? result;

  GetUserStakesByIdClass({
    this.statusCode,
    this.statusMessage,
    this.result,
  });

  factory GetUserStakesByIdClass.fromRawJson(String str) => GetUserStakesByIdClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserStakesByIdClass.fromJson(Map<String, dynamic> json) => GetUserStakesByIdClass(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : ParticularDetailsId.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
  };
}

class ParticularDetailsId {
  List<UserEarnDatum>? userEarnData;
  List<ParticularDetails>? data;

  ParticularDetailsId({
    this.userEarnData,
    this.data,
  });

  factory ParticularDetailsId.fromRawJson(String str) => ParticularDetailsId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParticularDetailsId.fromJson(Map<String, dynamic> json) => ParticularDetailsId(
    userEarnData: json["userEarnData"] == null ? [] : List<UserEarnDatum>.from(json["userEarnData"]!.map((x) => UserEarnDatum.fromJson(x))),
    data: json["data"] == null ? [] : List<ParticularDetails>.from(json["data"]!.map((x) => ParticularDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userEarnData": userEarnData == null ? [] : List<dynamic>.from(userEarnData!.map((x) => x.toJson())),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ParticularDetails {
  String? id;
  String? userStakeId;
  bool? isFlexible;
  bool? isAutoRestake;
  int? lockedDuration;
  num? apr;
  DateTime? interestEndAt;
  num? stakeAmount;
  DateTime? interestStartAt;
  DateTime? redemptionDate;
  int? redemptionPeriod;
  CurrencyDetails? stakeCurrencyDetails;
  CurrencyDetails? rewardCurrencyDetails;
  DateTime? stakedAt;

  ParticularDetails({
    this.id,
    this.userStakeId,
    this.isFlexible,
    this.isAutoRestake,
    this.lockedDuration,
    this.apr,
    this.interestEndAt,
    this.stakeAmount,
    this.interestStartAt,
    this.redemptionDate,
    this.redemptionPeriod,
    this.stakeCurrencyDetails,
    this.rewardCurrencyDetails,
    this.stakedAt,
  });

  factory ParticularDetails.fromRawJson(String str) => ParticularDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParticularDetails.fromJson(Map<String, dynamic> json) => ParticularDetails(
    id: json["_id"],
    userStakeId: json["userStakeId"],
    isFlexible: json["isFlexible"],
    isAutoRestake: json["isAutoRestake"],
    lockedDuration: json["lockedDuration"],
    apr: json["APR"],
    interestEndAt: json["interestEndAt"] == null ? null : DateTime.parse(json["interestEndAt"]),
    stakeAmount: json["stakeAmount"],
    interestStartAt: json["interestStartAt"] == null ? null : DateTime.parse(json["interestStartAt"]),
    redemptionDate: json["redemptionDate"] == null ? null : DateTime.parse(json["redemptionDate"]),
    redemptionPeriod: json["redemptionPeriod"],
    stakeCurrencyDetails: json["stakeCurrencyDetails"] == null ? null : CurrencyDetails.fromJson(json["stakeCurrencyDetails"]),
    rewardCurrencyDetails: json["rewardCurrencyDetails"] == null ? null : CurrencyDetails.fromJson(json["rewardCurrencyDetails"]),
    stakedAt: json["stakedAt"] == null ? null : DateTime.parse(json["stakedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userStakeId": userStakeId,
    "isFlexible": isFlexible,
    "isAutoRestake": isAutoRestake,
    "lockedDuration": lockedDuration,
    "APR": apr,
    "interestEndAt": interestEndAt?.toIso8601String(),
    "stakeAmount": stakeAmount,
    "interestStartAt": interestStartAt?.toIso8601String(),
    "redemptionDate": redemptionDate?.toIso8601String(),
    "redemptionPeriod": redemptionPeriod,
    "stakeCurrencyDetails": stakeCurrencyDetails?.toJson(),
    "rewardCurrencyDetails": rewardCurrencyDetails?.toJson(),
    "stakedAt": stakedAt?.toIso8601String(),
  };
}

class CurrencyDetails {
  String? code;

  CurrencyDetails({
    this.code,
  });

  factory CurrencyDetails.fromRawJson(String str) => CurrencyDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrencyDetails.fromJson(Map<String, dynamic> json) => CurrencyDetails(
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
  };
}

class UserEarnDatum {
  double? lastEarnAmount;
  double? totalEarnAmount;

  UserEarnDatum({
    this.lastEarnAmount,
    this.totalEarnAmount,
  });

  factory UserEarnDatum.fromRawJson(String str) => UserEarnDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserEarnDatum.fromJson(Map<String, dynamic> json) => UserEarnDatum(
    lastEarnAmount: json["lastEarnAmount"]?.toDouble(),
    totalEarnAmount: json["totalEarnAmount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lastEarnAmount": lastEarnAmount,
    "totalEarnAmount": totalEarnAmount,
  };
}
