// To parse this JSON data, do
//
//     final getBankDetaislModel = getBankDetaislModelFromJson(jsonString);

import 'dart:convert';

class GetBankDetaislModel {
  GetBankDetaislModel({
    this.getBankDetails,
  });

  GetBankDetails ?getBankDetails;

  factory GetBankDetaislModel.fromRawJson(String str) => GetBankDetaislModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBankDetaislModel.fromJson(Map<String, dynamic> json) => GetBankDetaislModel(
    getBankDetails: json["getBankDetails"] == null ? null : GetBankDetails.fromJson(json["getBankDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "getBankDetails": getBankDetails == null ? null : getBankDetails!.toJson(),
  };
}

class GetBankDetails {
  GetBankDetails({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  List<GetBankHistoryDetails>? result;
  String ?typename;

  factory GetBankDetails.fromRawJson(String str) => GetBankDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBankDetails.fromJson(Map<String, dynamic> json) => GetBankDetails(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<GetBankHistoryDetails>.from(json["result"].map((x) => GetBankHistoryDetails.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class GetBankHistoryDetails {
  GetBankHistoryDetails({
    this.bankDetails,
    this.typename,
  });

  List<BankDetail>? bankDetails;
  String? typename;

  factory GetBankHistoryDetails.fromRawJson(String str) => GetBankHistoryDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBankHistoryDetails.fromJson(Map<String, dynamic> json) => GetBankHistoryDetails(
    bankDetails: json["bank_details"] == null ? null : List<BankDetail>.from(json["bank_details"].map((x) => BankDetail.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "bank_details": bankDetails == null ? null : List<dynamic>.from(bankDetails!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class BankDetail {
  BankDetail({
    this.accountNumber,
    this.accountHolderName,
    this.bankName,
    this.ibanNumber,
    this.bankAddress,
    this.primary,
    this.id,
  });

  String ?accountNumber;
  String ?accountHolderName;
  String ?bankName;
  String ?ibanNumber;
  String ?bankAddress;
  bool ?primary;
  String ?id;

  factory BankDetail.fromRawJson(String str) => BankDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    accountNumber: json["account_number"] == null ? null : json["account_number"],
    accountHolderName: json["account_holder_name"] == null ? null : json["account_holder_name"],
    bankName: json["bank_name"] == null ? null : json["bank_name"],
    ibanNumber: json["iban_number"] == null ? null : json["iban_number"],
    bankAddress: json["bank_address"] == null ? null : json["bank_address"],
    primary: json["primary"] == null ? null : json["primary"],
    id: json["_id"] == null ? null : json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "account_number": accountNumber == null ? null : accountNumber,
    "account_holder_name": accountHolderName == null ? null : accountHolderName,
    "bank_name": bankName == null ? null : bankName,
    "iban_number": ibanNumber == null ? null : ibanNumber,
    "bank_address": bankAddress == null ? null : bankAddress,
    "primary": primary == null ? null : primary,
    "_id": id == null ? null : id,
  };
}
