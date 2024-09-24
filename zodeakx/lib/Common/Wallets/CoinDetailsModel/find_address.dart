import 'dart:convert';

class AddressCommonResponse {
  AddressCommonResponse({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  FindAddress? result;
  String? typename;

  factory AddressCommonResponse.fromRawJson(String str) =>
      AddressCommonResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddressCommonResponse.fromJson(Map<String, dynamic> json) =>
      AddressCommonResponse(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage:
            json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null
            ? null
            : FindAddress.fromJson(json["result"]),
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result?.toJson(),
        "__typename": typename == null ? null : typename,
      };
}

class FindAddress {
  FindAddress({
    this.address,
    this.qrCode,
    this.tagId,
    this.typename,
  });

  String? address;
  String? qrCode;
  String? tagId;
  String? typename;

  factory FindAddress.fromRawJson(String str) =>
      FindAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FindAddress.fromJson(Map<String, dynamic> json) => FindAddress(
        address: json["address"] == null ? null : json["address"],
        qrCode: json["qr_Code"] == null ? null : json["qr_Code"],
        tagId: json["tag_id"] == null ? null : json["tag_id"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "address": address == null ? null : address,
        "qr_Code": qrCode == null ? null : qrCode,
        "tag_id": tagId == null ? null : tagId,
        "__typename": typename == null ? null : typename,
      };
}
FindAddress dummyFindAddress =
FindAddress(address: "", qrCode: "", tagId: "", typename: "");