// To parse this JSON data, do
//
//     final adminBankDetails = adminBankDetailsFromJson(jsonString);

import 'dart:convert';

class AdminBankDetails {
  AdminBankDetails({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<GetAdminDetails>? result;
  String? typename;

  factory AdminBankDetails.fromRawJson(String str) => AdminBankDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdminBankDetails.fromJson(Map<String, dynamic> json) => AdminBankDetails(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<GetAdminDetails>.from(json["result"].map((x) => GetAdminDetails.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class GetAdminDetails {
  GetAdminDetails({
    this.adminAccountName,
    this.adminAccountNumber,
    this.bankName,
    this.bankRoutingSortCode,
    this.bankSwiftBicCode,
    this.bankAddress,
    this.bankState,
    this.bankCountry,
    this.bankPostalZipCode,
    this.typename,
  });

  String? adminAccountName;
  String? adminAccountNumber;
  String? bankName;
  String? bankRoutingSortCode;
  String? bankSwiftBicCode;
  String? bankAddress;
  String? bankState;
  String? bankCountry;
  String? bankPostalZipCode;
  String? typename;

  factory GetAdminDetails.fromRawJson(String str) => GetAdminDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAdminDetails.fromJson(Map<String, dynamic> json) => GetAdminDetails(
    adminAccountName: json["admin_account_name"] == null ? null : json["admin_account_name"],
    adminAccountNumber: json["admin_account_number"] == null ? null : json["admin_account_number"],
    bankName: json["bank_name"] == null ? null : json["bank_name"],
    bankRoutingSortCode: json["bank_routing_sort_code"] == null ? null : json["bank_routing_sort_code"],
    bankSwiftBicCode: json["bank_swift_bic_code"] == null ? null : json["bank_swift_bic_code"],
    bankAddress: json["bank_address"] == null ? null : json["bank_address"],
    bankState: json["bank_state"] == null ? null : json["bank_state"],
    bankCountry: json["bank_country"] == null ? null : json["bank_country"],
    bankPostalZipCode: json["bank_postal_zip_code"] == null ? null : json["bank_postal_zip_code"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "admin_account_name": adminAccountName == null ? null : adminAccountName,
    "admin_account_number": adminAccountNumber == null ? null : adminAccountNumber,
    "bank_name": bankName == null ? null : bankName,
    "bank_routing_sort_code": bankRoutingSortCode == null ? null : bankRoutingSortCode,
    "bank_swift_bic_code": bankSwiftBicCode == null ? null : bankSwiftBicCode,
    "bank_address": bankAddress == null ? null : bankAddress,
    "bank_state": bankState == null ? null : bankState,
    "bank_country": bankCountry == null ? null : bankCountry,
    "bank_postal_zip_code": bankPostalZipCode == null ? null : bankPostalZipCode,
    "__typename": typename == null ? null : typename,
  };
}
