// To parse this JSON data, do
//
//     final addBankDetaislModel = addBankDetaislModelFromJson(jsonString);

import 'dart:convert';

class AddBankDetaislModel {
  AddBankDetaislModel({
    this.addBankDetails,
  });

  AddBankDetails ?addBankDetails;

  factory AddBankDetaislModel.fromRawJson(String str) => AddBankDetaislModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddBankDetaislModel.fromJson(Map<String, dynamic> json) => AddBankDetaislModel(
    addBankDetails: json["AddBankDetails"] == null ? null : AddBankDetails.fromJson(json["AddBankDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "AddBankDetails": addBankDetails == null ? null : addBankDetails!.toJson(),
  };
}

class AddBankDetails {
  AddBankDetails({
    this.statusCode,
    this.statusMessage,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  String? typename;

  factory AddBankDetails.fromRawJson(String str) => AddBankDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddBankDetails.fromJson(Map<String, dynamic> json) => AddBankDetails(
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
