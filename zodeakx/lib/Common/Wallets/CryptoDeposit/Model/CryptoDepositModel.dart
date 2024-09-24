// To parse this JSON data, do
//
//     final userCryptoAddress = userCryptoAddressFromJson(jsonString);

import 'dart:convert';

class UserCryptoAddress {
  UserCryptoAddress({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  CryptoAddress? result;
  String? typename;

  factory UserCryptoAddress.fromRawJson(String str) => UserCryptoAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserCryptoAddress.fromJson(Map<String, dynamic> json) => UserCryptoAddress(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : CryptoAddress.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class CryptoAddress {
  CryptoAddress({
    this.address,
    this.qrCode,
    this.typename,
  });

  String? address;
  String? qrCode;
  String? typename;

  factory CryptoAddress.fromRawJson(String str) => CryptoAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CryptoAddress.fromJson(Map<String, dynamic> json) => CryptoAddress(
    address: json["address"] == null ? null : json["address"],
    qrCode: json["qr_Code"] == null ? null : json["qr_Code"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? null : address,
    "qr_Code": qrCode == null ? null : qrCode,
    "__typename": typename == null ? null : typename,
  };
}
