

import 'dart:convert';

class FetchAppealHistory {
  FetchAppealHistory({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<AppealHistory>? result;
  String? typename;

  factory FetchAppealHistory.fromRawJson(String str) => FetchAppealHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FetchAppealHistory.fromJson(Map<String, dynamic> json) => FetchAppealHistory(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<AppealHistory>.from(json["result"]!.map((x) => AppealHistory.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class AppealHistory {
  AppealHistory({
    this.id,
    this.userId,
    this.orderId,
    this.status,
    this.userName,
    this.description,
    this.proof,
    this.reasonForAppeal,
    this.createdDate,
    this.modifiedDate,
    this.consensus,
    this.typename,
  });

  String? id;
  String? userId;
  String? orderId;
  String? status;
  String? userName;
  String? description;
  List<Proof>? proof;
  String? reasonForAppeal;
  DateTime? createdDate;
  DateTime? modifiedDate;
  dynamic consensus;
  String? typename;

  factory AppealHistory.fromRawJson(String str) => AppealHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppealHistory.fromJson(Map<String, dynamic> json) => AppealHistory(
    id: json["_id"],
    userId: json["user_id"],
    orderId: json["order_id"],
    status: json["status"],
    userName: json["user_name"],
    description: json["description"],
    proof: json["proof"] == null ? [] : List<Proof>.from(json["proof"]!.map((x) => Proof.fromJson(x))),
    reasonForAppeal: json["reason_for_appeal"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    consensus: json["consensus"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "order_id": orderId,
    "status": status,
    "user_name": userName,
    "description": description,
    "proof": proof == null ? [] : List<dynamic>.from(proof!.map((x) => x.toJson())),
    "reason_for_appeal": reasonForAppeal,
    "created_date": createdDate?.toIso8601String(),
    "modified_date": modifiedDate?.toIso8601String(),
    "consensus": consensus,
    "__typename": typename,
  };
}

class Proof {
  Proof({
    this.id,
    this.proofUrl,
  });

  String? id;
  String? proofUrl;

  factory Proof.fromRawJson(String str) => Proof.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Proof.fromJson(Map<String, dynamic> json) => Proof(
    id: json["_id"],
    proofUrl: json["proof_url"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "proof_url": proofUrl,
  };
}
