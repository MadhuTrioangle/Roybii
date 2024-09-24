

import 'dart:convert';

class FetchBannerData {
  int? statusCode;
  String? statusMessage;
  Result? result;
  String? typename;

  FetchBannerData({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory FetchBannerData.fromRawJson(String str) => FetchBannerData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FetchBannerData.fromJson(Map<String, dynamic> json) => FetchBannerData(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class Result {
  num? fundRaised;
  int? noOfProjects;
  int? totalParticipants;
  num? totalCommitted;
  String? typename;

  Result({
    this.fundRaised,
    this.noOfProjects,
    this.totalParticipants,
    this.totalCommitted,
    this.typename,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    fundRaised: json["fund_raised"],
    noOfProjects: json["no_of_projects"],
    totalParticipants: json["total_participants"],
    totalCommitted: json["total_committed"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "fund_raised": fundRaised,
    "no_of_projects": noOfProjects,
    "total_participants": totalParticipants,
    "total_committed": totalCommitted,
    "__typename": typename,
  };
}
