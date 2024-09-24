// To parse this JSON data, do
//
//     final referralDashboard = referralDashboardFromJson(jsonString);

import 'dart:convert';

class ReferralDashboard {
  ReferralDashboard({
    this.data,
  });

  Data? data;

  factory ReferralDashboard.fromRawJson(String str) => ReferralDashboard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferralDashboard.fromJson(Map<String, dynamic> json) => ReferralDashboard(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data?.toJson(),
  };
}

class Data {
  Data({
    this.getReferralDashboard,
  });

  GetReferralDashboard? getReferralDashboard;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    getReferralDashboard: json["getReferralDashboard"] == null ? null : GetReferralDashboard.fromJson(json["getReferralDashboard"]),
  );

  Map<String, dynamic> toJson() => {
    "getReferralDashboard": getReferralDashboard == null ? null : getReferralDashboard?.toJson(),
  };
}

class GetReferralDashboard {
  GetReferralDashboard({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  ListofReferral? result;
  String? typename;

  factory GetReferralDashboard.fromRawJson(String str) => GetReferralDashboard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReferralDashboard.fromJson(Map<String, dynamic> json) => GetReferralDashboard(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : ListofReferral.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class ListofReferral {
  ListofReferral({
    this.youEarned,
    this.totalTradedFriends,
    this.totalFriends,
    this.referralDefaultCurrency,
    this.typename,
  });

  num? youEarned;
  num? totalTradedFriends;
  num? totalFriends;
  String? referralDefaultCurrency;
  String? typename;

  factory ListofReferral.fromRawJson(String str) => ListofReferral.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListofReferral.fromJson(Map<String, dynamic> json) => ListofReferral(
    youEarned: json["you_earned"] == null ? null : json["you_earned"],
    totalTradedFriends: json["total_traded_friends"] == null ? null : json["total_traded_friends"],
    totalFriends: json["total_friends"] == null ? null : json["total_friends"],
    referralDefaultCurrency: json["referral_default_currency"] == null ? null : json["referral_default_currency"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "you_earned": youEarned == null ? null : youEarned,
    "total_traded_friends": totalTradedFriends == null ? null : totalTradedFriends,
    "total_friends": totalFriends == null ? null : totalFriends,
    "referral_default_currency": referralDefaultCurrency == null ? null : referralDefaultCurrency,
    "__typename": typename == null ? null : typename,
  };
}
