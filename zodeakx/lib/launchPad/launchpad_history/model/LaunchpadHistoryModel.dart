import 'dart:convert';

class LaunchpadHistoryModel {
  int? statusCode;
  String? statusMessage;
  List<LaunchpadHistory>? result;
  String? typename;

  LaunchpadHistoryModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory LaunchpadHistoryModel.fromRawJson(String str) =>
      LaunchpadHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LaunchpadHistoryModel.fromJson(Map<String, dynamic> json) =>
      LaunchpadHistoryModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? []
            : List<LaunchpadHistory>.from(
                json["result"]!.map((x) => LaunchpadHistory.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class LaunchpadHistory {
  String? projectName;
  num? price;
  dynamic priceHolding;
  num? commitedAmount;
  num? deductedAmount;
  num? allocatedToken;
  String? status;
  String? allocatedTokenId;
  String? commitedTokenId;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? typename;

  LaunchpadHistory({
    this.projectName,
    this.price,
    this.priceHolding,
    this.commitedAmount,
    this.deductedAmount,
    this.allocatedToken,
    this.status,
    this.allocatedTokenId,
    this.commitedTokenId,
    this.createdDate,
    this.modifiedDate,
    this.typename,
  });

  factory LaunchpadHistory.fromRawJson(String str) =>
      LaunchpadHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LaunchpadHistory.fromJson(Map<String, dynamic> json) =>
      LaunchpadHistory(
        projectName: json["project_name"],
        price: json["price"],
        priceHolding: json["price_holding"],
        commitedAmount: json["commited_amount"],
        deductedAmount: json["deducted_amount"],
        allocatedToken: json["allocated_token"],
        status: json["status"],
        allocatedTokenId: json["allocated_token_id"],
        commitedTokenId: json["commited_token_id"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] == null
            ? null
            : DateTime.parse(json["modified_date"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "project_name": projectName,
        "price": price,
        "price_holding": priceHolding,
        "commited_amount": commitedAmount,
        "deducted_amount": deductedAmount,
        "allocated_token": allocatedToken,
        "status": status,
        "allocated_token_id": allocatedTokenId,
        "commited_token_id": commitedTokenId,
        "created_date": createdDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "__typename": typename,
      };
}
