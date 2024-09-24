// To parse this JSON data, do
//
//     final getReferralLinksModel = getReferralLinksModelFromJson(jsonString);

import 'dart:convert';

class GetReferralLinksModel {
  GetReferralLinksModel({
    this.data,
  });

  Data? data;

  factory GetReferralLinksModel.fromRawJson(String str) => GetReferralLinksModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReferralLinksModel.fromJson(Map<String, dynamic> json) => GetReferralLinksModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data?.toJson(),
  };
}

class Data {
  Data({
    this.getReferralLinks,
  });

  GetReferralLinks? getReferralLinks;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    getReferralLinks: json["getReferralLinks"] == null ? null : GetReferralLinks.fromJson(json["getReferralLinks"]),
  );

  Map<String, dynamic> toJson() => {
    "getReferralLinks": getReferralLinks == null ? null : getReferralLinks?.toJson(),
  };
}

class GetReferralLinks {
  GetReferralLinks({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<Result>? result;
  String? typename;

  factory GetReferralLinks.fromRawJson(String str) => GetReferralLinks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetReferralLinks.fromJson(Map<String, dynamic> json) => GetReferralLinks(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class Result {
  Result({
    this.id,
    this.userId,
    this.referralId,
    this.youReceive,
    this.friendsReceive,
    this.note,
    this.resultDefault,
    this.inviteQr,
    this.noOfFriends,
    this.friendsDetails,
    this.createdDate,
    this.modifiedDate,
    this.typename,
  });

  String? id;
  String? userId;
  String? referralId;
  int? youReceive;
  int? friendsReceive;
  dynamic note;
  bool? resultDefault;
  String? inviteQr;
  int? noOfFriends;
  List<dynamic>? friendsDetails;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? typename;

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"] == null ? null : json["_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    referralId: json["referral_id"] == null ? null : json["referral_id"],
    youReceive: json["you_receive"] == null ? null : json["you_receive"],
    friendsReceive: json["friends_receive"] == null ? null : json["friends_receive"],
    note: json["note"],
    resultDefault: json["default"] == null ? null : json["default"],
    inviteQr: json["invite_qr"] == null ? null : json["invite_qr"],
    noOfFriends: json["noOfFriends"] == null ? null : json["noOfFriends"],
    friendsDetails: json["friendsDetails"] == null ? null : List<dynamic>.from(json["friendsDetails"].map((x) => x)),
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
    "note": note,
    "default": resultDefault == null ? null : resultDefault,
    "invite_qr": inviteQr == null ? null : inviteQr,
    "noOfFriends": noOfFriends == null ? null : noOfFriends,
    "friendsDetails": friendsDetails == null ? null : List<dynamic>.from(friendsDetails!.map((x) => x)),
    "created_date": createdDate == null ? null : createdDate?.toIso8601String(),
    "modified_date": modifiedDate == null ? null : modifiedDate?.toIso8601String(),
    "__typename": typename == null ? null : typename,
  };
}
