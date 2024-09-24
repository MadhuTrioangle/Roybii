// To parse this JSON data, do
//
//     final projectCommitedModel = projectCommitedModelFromJson(jsonString);

import 'dart:convert';

class ProjectCommitedModel {
  int? statusCode;
  String? statusMessage;
  List<ProjectCommited>? result;
  String? typename;

  ProjectCommitedModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory ProjectCommitedModel.fromRawJson(String str) => ProjectCommitedModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProjectCommitedModel.fromJson(Map<String, dynamic> json) => ProjectCommitedModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<ProjectCommited>.from(json["result"]!.map((x) => ProjectCommited.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class ProjectCommited {
  int? noOfParticipants;
  int? commitedValue;
  String? holdingCurrency;
  String? projectId;
  String? typename;

  ProjectCommited({
    this.noOfParticipants,
    this.commitedValue,
    this.holdingCurrency,
    this.projectId,
    this.typename,
  });

  factory ProjectCommited.fromRawJson(String str) => ProjectCommited.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProjectCommited.fromJson(Map<String, dynamic> json) => ProjectCommited(
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
