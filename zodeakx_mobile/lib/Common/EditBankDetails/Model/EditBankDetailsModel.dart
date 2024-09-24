// To parse this JSON data, do
//
//     final editBankDetaislModel = editBankDetaislModelFromJson(jsonString);

import 'dart:convert';

class EditBankDetaislModel {
  EditBankDetaislModel({
    this.editBankDetails,
  });

  EditBankDetails ?editBankDetails;

  factory EditBankDetaislModel.fromRawJson(String str) => EditBankDetaislModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditBankDetaislModel.fromJson(Map<String, dynamic> json) => EditBankDetaislModel(
    editBankDetails: json["EditBankDetails"] == null ? null : EditBankDetails.fromJson(json["EditBankDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "EditBankDetails": editBankDetails == null ? null : editBankDetails!.toJson(),
  };
}

class EditBankDetails {
  EditBankDetails({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  String ?typename;

  factory EditBankDetails.fromRawJson(String str) => EditBankDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EditBankDetails.fromJson(Map<String, dynamic> json) => EditBankDetails(
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
