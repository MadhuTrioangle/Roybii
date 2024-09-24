// To parse this JSON data, do
//
//     final deleteBankDetaislModel = deleteBankDetaislModelFromJson(jsonString);

import 'dart:convert';

class DeleteBankDetaislModel {
  DeleteBankDetaislModel({
    this.deleteBankDetail,
  });

  DeleteBankDetail ?deleteBankDetail;

  factory DeleteBankDetaislModel.fromRawJson(String str) => DeleteBankDetaislModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteBankDetaislModel.fromJson(Map<String, dynamic> json) => DeleteBankDetaislModel(
    deleteBankDetail: json["deleteBankDetail"] == null ? null : DeleteBankDetail.fromJson(json["deleteBankDetail"]),
  );

  Map<String, dynamic> toJson() => {
    "deleteBankDetail": deleteBankDetail == null ? null : deleteBankDetail!.toJson(),
  };
}

class DeleteBankDetail {
  DeleteBankDetail({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int ?statusCode;
  String ?statusMessage;
  String ?typename;

  factory DeleteBankDetail.fromRawJson(String str) => DeleteBankDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteBankDetail.fromJson(Map<String, dynamic> json) => DeleteBankDetail(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "__typename": typename == null ? null : typename,
  };
}
