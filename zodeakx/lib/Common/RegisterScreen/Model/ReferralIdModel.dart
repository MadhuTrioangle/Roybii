// To parse this JSON data, do
//
//     final getReferralIdModel = getReferralIdModelFromJson(jsonString);

import 'dart:convert';

class GetReferralIdModel {
  GetReferralIdModel({
    this.getReferralLinkByReferralId,
  });

  GetReferralLinkByReferral? getReferralLinkByReferralId;

  factory GetReferralIdModel.fromRawJson(String str) => GetReferralIdModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReferralIdModel.fromJson(Map<String, dynamic> json) => GetReferralIdModel(
    getReferralLinkByReferralId: json["getReferralLinkByReferralID"] == null ? null : GetReferralLinkByReferral.fromJson(json["getReferralLinkByReferralID"]),
  );

  Map<String, dynamic> toJson() => {
    "getReferralLinkByReferralID": getReferralLinkByReferralId == null ? null : getReferralLinkByReferralId!.toJson(),
  };
}

class GetReferralLinkByReferral {
  GetReferralLinkByReferral({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  ReferralId? result;
  String ?typename;

  factory GetReferralLinkByReferral.fromRawJson(String str) => GetReferralLinkByReferral.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReferralLinkByReferral.fromJson(Map<String, dynamic> json) => GetReferralLinkByReferral(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : ReferralId.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result!.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class ReferralId {
  ReferralId({
    this.id,
    this.userId,
    this.referralId,
    this.youReceive,
    this.friendsReceive,
    this.createdDate,
    this.modifiedDate,
    this.typename,
  });

  String? id;
  String ?userId;
  String ?referralId;
  int? youReceive;
  int? friendsReceive;
  DateTime? createdDate;
  DateTime ?modifiedDate;
  String ?typename;

  factory ReferralId.fromRawJson(String str) => ReferralId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReferralId.fromJson(Map<String, dynamic> json) => ReferralId(
    id: json["_id"] == null ? null : json["_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    referralId: json["referral_id"] == null ? null : json["referral_id"],
    youReceive: json["you_receive"] == null ? null : json["you_receive"],
    friendsReceive: json["friends_receive"] == null ? null : json["friends_receive"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "referral_id": referralId == null ? null : referralId,
    "you_receive": youReceive == null ? null : youReceive,
    "friends_receive": friendsReceive == null ? null : friendsReceive,
    "created_date": createdDate == null ? null : createdDate!.toIso8601String(),
    "modified_date": modifiedDate == null ? null : modifiedDate!.toIso8601String(),
    "__typename": typename == null ? null : typename,
  };
}
