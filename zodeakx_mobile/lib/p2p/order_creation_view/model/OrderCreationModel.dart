import 'dart:convert';

class OrderCreationModel {
  OrderCreationModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  OrderCreation? result;
  String? typename;

  factory OrderCreationModel.fromRawJson(String str) =>
      OrderCreationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCreationModel.fromJson(Map<String, dynamic> json) =>
      OrderCreationModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : OrderCreation.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class OrderCreation {
  OrderCreation({
    this.id,
    this.fromAsset,
    this.toAsset,
    this.price,
    this.amount,
    this.total,
    this.createdDate,
    this.modifiedDate,
    this.typename,
  });

  String? id;
  String? fromAsset;
  String? toAsset;
  double? price;
  double? amount;
  num? total;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? typename;

  factory OrderCreation.fromRawJson(String str) =>
      OrderCreation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCreation.fromJson(Map<String, dynamic> json) => OrderCreation(
        id: json["_id"],
        fromAsset: json["from_asset"],
        toAsset: json["to_asset"],
        price: json["price"]?.toDouble(),
        amount: json["amount"]?.toDouble(),
        total: json["total"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] == null
            ? null
            : DateTime.parse(json["modified_date"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from_asset": fromAsset,
        "to_asset": toAsset,
        "price": price,
        "amount": amount,
        "total": total,
        "created_date": createdDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "__typename": typename,
      };
}
