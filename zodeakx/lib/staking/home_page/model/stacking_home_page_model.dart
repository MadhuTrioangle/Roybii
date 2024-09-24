import 'dart:convert';

class GetActiveStakesClass {
  int? statusCode;
  String? statusMessage;
  List<GetAllActiveStatus>? result;

  GetActiveStakesClass({
    this.statusCode,
    this.statusMessage,
    this.result,
  });

  factory GetActiveStakesClass.fromRawJson(String str) => GetActiveStakesClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetActiveStakesClass.fromJson(Map<String, dynamic> json) => GetActiveStakesClass(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<GetAllActiveStatus>.from(json["result"]!.map((x) => GetAllActiveStatus.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class GetAllActiveStatus {
  bool isExpand = false;
  String? id;
  num? minStakeAmount;
  num? maxStakeAmount;
  List<Child>? childs;
  num? interestPeriod;
  num? redemptionPeriod;
  num? totalPersonalQuota;
  bool? isFlexible;
  num? flexibleInterest;
  num? availableSupply;
  String? interestCreditTime;
  CurrencyDetails? stakeCurrencyDetails;
  CurrencyDetails? rewardCurrencyDetails;

  GetAllActiveStatus({
    this.id,
    this.minStakeAmount,
    this.maxStakeAmount,
    this.childs,
    this.interestPeriod,
    this.redemptionPeriod,
    this.totalPersonalQuota,
    this.isFlexible,
    this.flexibleInterest,
    this.availableSupply,
    this.interestCreditTime,
    this.stakeCurrencyDetails,
    this.rewardCurrencyDetails,
  });

  factory GetAllActiveStatus.fromRawJson(String str) => GetAllActiveStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllActiveStatus.fromJson(Map<String, dynamic> json) => GetAllActiveStatus(
    id: json["_id"],
    minStakeAmount: json["minStakeAmount"]?.toDouble(),
    maxStakeAmount: json["maxStakeAmount"]?.toDouble(),
    childs: json["childs"] == null ? [] : List<Child>.from(json["childs"]!.map((x) => Child.fromJson(x))),
    interestPeriod: json["interestPeriod"],
    redemptionPeriod: json["redemptionPeriod"],
    totalPersonalQuota: json["totalPersonalQuota"],
    isFlexible: json["isFlexible"],
    flexibleInterest: json["flexibleInterest"],
    availableSupply: json["availableSupply"]?.toDouble(),
    interestCreditTime: json["interestCreditTime"],
    stakeCurrencyDetails: json["stakeCurrencyDetails"] == null ? null : CurrencyDetails.fromJson(json["stakeCurrencyDetails"]),
    rewardCurrencyDetails: json["rewardCurrencyDetails"] == null ? null : CurrencyDetails.fromJson(json["rewardCurrencyDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "minStakeAmount": minStakeAmount,
    "maxStakeAmount": maxStakeAmount,
    "childs": childs == null ? [] : List<dynamic>.from(childs!.map((x) => x.toJson())),
    "interestPeriod": interestPeriod,
    "redemptionPeriod": redemptionPeriod,
    "totalPersonalQuota": totalPersonalQuota,
    "isFlexible": isFlexible,
    "flexibleInterest": flexibleInterest,
    "availableSupply": availableSupply,
    "interestCreditTime": interestCreditTime,
    "stakeCurrencyDetails": stakeCurrencyDetails?.toJson(),
    "rewardCurrencyDetails": rewardCurrencyDetails?.toJson(),
  };
}

class Child {
  String? id;
  num? lockedDuration;
  num? apr;

  Child({
    this.id,
    this.lockedDuration,
    this.apr,
  });

  factory Child.fromRawJson(String str) => Child.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    id: json["_id"],
    lockedDuration: json["lockedDuration"],
    apr: json["APR"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "lockedDuration": lockedDuration,
    "APR": apr,
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
