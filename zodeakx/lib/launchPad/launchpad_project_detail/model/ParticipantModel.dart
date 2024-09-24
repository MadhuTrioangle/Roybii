import 'dart:convert';

class ParticipantModel {
  int? statusCode;
  String? statusMessage;
  Participant? result;
  String? typename;

  ParticipantModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory ParticipantModel.fromRawJson(String str) => ParticipantModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ParticipantModel.fromJson(Map<String, dynamic> json) => ParticipantModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : Participant.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class Participant {
  String? userId;
  String? projectId;
  num? allocatedToken;
  String? allocatedTokenId;
  num? commitedAmount;
  String? commitedTokenId;
  num? deductedAmount;
  String? typename;

  Participant({
    this.userId,
    this.projectId,
    this.allocatedToken,
    this.allocatedTokenId,
    this.commitedAmount,
    this.commitedTokenId,
    this.deductedAmount,
    this.typename,
  });

  factory Participant.fromRawJson(String str) => Participant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    userId: json["user_id"],
    projectId: json["project_id"],
    allocatedToken: json["allocated_token"]?.toDouble(),
    allocatedTokenId: json["allocated_token_id"],
    commitedAmount: json["commited_amount"],
    commitedTokenId: json["commited_token_id"],
    deductedAmount: json["deducted_amount"]?.toDouble(),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "project_id": projectId,
    "allocated_token": allocatedToken,
    "allocated_token_id": allocatedTokenId,
    "commited_amount": commitedAmount,
    "commited_token_id": commitedTokenId,
    "deducted_amount": deductedAmount,
    "__typename": typename,
  };
}
