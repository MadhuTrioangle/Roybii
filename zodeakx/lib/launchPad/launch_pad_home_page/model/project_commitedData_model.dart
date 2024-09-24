

import 'dart:convert';

class FetchProjectCommitedData {
  int? statusCode;
  String? statusMessage;
  List<FetchCommitedData>? result;
  String? typename;

  FetchProjectCommitedData({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory FetchProjectCommitedData.fromRawJson(String str) => FetchProjectCommitedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FetchProjectCommitedData.fromJson(Map<String, dynamic> json) => FetchProjectCommitedData(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<FetchCommitedData>.from(json["result"]!.map((x) => FetchCommitedData.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class FetchCommitedData {
  int? noOfParticipants;
  num? commitedValue;
  String? holdingCurrency;
  String? projectId;
  String? typename;

  FetchCommitedData({
    this.noOfParticipants,
    this.commitedValue,
    this.holdingCurrency,
    this.projectId,
    this.typename,
  });

  factory FetchCommitedData.fromRawJson(String str) => FetchCommitedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FetchCommitedData.fromJson(Map<String, dynamic> json) => FetchCommitedData(
    noOfParticipants: json["no_of_participants"],
    commitedValue: json["commited_value"],
    holdingCurrency: json["holding_currency"],
    projectId: json["project_id"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "no_of_participants": noOfParticipants,
    "commited_value": commitedValue,
    "holding_currency": holdingCurrency,
    "project_id": projectId,
    "__typename": typename,
  };
}
