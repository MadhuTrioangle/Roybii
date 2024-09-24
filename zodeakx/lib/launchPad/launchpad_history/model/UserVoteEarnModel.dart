import 'dart:convert';

class UserVotesEarnModel {
  int? statusCode;
  String? statusMessage;
  UserVoteEarn? result;
  String? typename;

  UserVotesEarnModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory UserVotesEarnModel.fromRawJson(String str) => UserVotesEarnModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserVotesEarnModel.fromJson(Map<String, dynamic> json) => UserVotesEarnModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : UserVoteEarn.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class UserVoteEarn {
  int? total;
  int? limit;
  int? page;
  int? pages;
  List<VoteEarnData>? data;
  String? typename;

  UserVoteEarn({
    this.total,
    this.data,
    this.limit,
    this.page,
    this.pages,
    this.typename,
  });

  factory UserVoteEarn.fromRawJson(String str) => UserVoteEarn.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserVoteEarn.fromJson(Map<String, dynamic> json) => UserVoteEarn(
    total: json["total"],
    limit: json["limit"],
    page: json["page"],
    pages: json["pages"],
    data: json["data"] == null ? [] : List<VoteEarnData>.from(json["data"]!.map((x) => VoteEarnData.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "limit": limit,
    "page": page,
    "pages": pages,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class VoteEarnData {
  int? noOfVotes;
  String? roundName;
  String? projectName;
  String? rewardCurrencyCode;
  num? rewardAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? typename;

  VoteEarnData({
    this.noOfVotes,
    this.roundName,
    this.projectName,
    this.rewardCurrencyCode,
    this.rewardAmount,
    this.createdAt,
    this.updatedAt,
    this.typename,
  });

  factory VoteEarnData.fromRawJson(String str) => VoteEarnData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VoteEarnData.fromJson(Map<String, dynamic> json) => VoteEarnData(
    noOfVotes: json["noOfVotes"],
    roundName: json["roundName"],
    projectName: json["projectName"],
    rewardCurrencyCode: json["rewardCurrencyCode"],
    rewardAmount: json["rewardAmount"]?.toDouble(),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "noOfVotes": noOfVotes,
    "roundName": roundName,
    "projectName": projectName,
    "rewardCurrencyCode": rewardCurrencyCode,
    "rewardAmount": rewardAmount,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__typename": typename,
  };
}
