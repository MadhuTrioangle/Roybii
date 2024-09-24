// To parse this JSON data, do
//
//     final updateIdProof = updateIdProofFromJson(jsonString);

import 'dart:convert';

class UpdateIdProof {
  UpdateIdProof({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  GetIdInfo? result;
  String? typename;

  factory UpdateIdProof.fromRawJson(String str) => UpdateIdProof.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateIdProof.fromJson(Map<String, dynamic> json) => UpdateIdProof(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : GetIdInfo.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class GetIdInfo {
  GetIdInfo({
    this.idProofFrontUrl,
    this.idProofBackUrl,
    this.typename,
  });

  String? idProofFrontUrl;
  String? idProofBackUrl;
  String? typename;

  factory GetIdInfo.fromRawJson(String str) => GetIdInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetIdInfo.fromJson(Map<String, dynamic> json) => GetIdInfo(
    idProofFrontUrl: json["id_proof_front_url"] == null ? null : json["id_proof_front_url"],
    idProofBackUrl: json["id_proof_back_url"] == null ? null : json["id_proof_back_url"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "id_proof_front_url": idProofFrontUrl == null ? null : idProofFrontUrl,
    "id_proof_back_url": idProofBackUrl == null ? null : idProofBackUrl,
    "__typename": typename == null ? null : typename,
  };
}
