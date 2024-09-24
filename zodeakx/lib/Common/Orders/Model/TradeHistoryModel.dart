import 'dart:convert';

class TradeHistoryModelClass {
  int? statusCode;
  String? statusMessage;
  TradeHistoryModel? result;
  String? typename;

  TradeHistoryModelClass({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory TradeHistoryModelClass.fromRawJson(String str) => TradeHistoryModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeHistoryModelClass.fromJson(Map<String, dynamic> json) => TradeHistoryModelClass(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : TradeHistoryModel.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class TradeHistoryModel {
  List<TradeHistoryModelDetails>? data;
  int? total;
  int? limit;
  int? page;
  int? pages;
  String? typename;

  TradeHistoryModel({
    this.data,
    this.total,
    this.limit,
    this.page,
    this.pages,
    this.typename,
  });

  factory TradeHistoryModel.fromRawJson(String str) => TradeHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeHistoryModel.fromJson(Map<String, dynamic> json) => TradeHistoryModel(
    data: json["data"] == null ? [] : List<TradeHistoryModelDetails>.from(json["data"]!.map((x) => TradeHistoryModelDetails.fromJson(x))),
    total: json["total"],
    limit: json["limit"],
    page: json["page"],
    pages: json["pages"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "limit": limit,
    "page": page,
    "pages": pages,
    "__typename": typename,
  };
}

class TradeHistoryModelDetails {
  String? id;
  num? amount;
  num? price;
  num? total;
  num? filledAmount;
  String? pair;
  String? tradeType;
  String? orderType;
  num? adminFeePercentage;
  num? adminFeeAmount;
  DateTime? createdDate;
  String? typename;

  TradeHistoryModelDetails({
    this.id,
    this.amount,
    this.price,
    this.total,
    this.filledAmount,
    this.pair,
    this.tradeType,
    this.orderType,
    this.adminFeePercentage,
    this.adminFeeAmount,
    this.createdDate,
    this.typename,
  });

  factory TradeHistoryModelDetails.fromRawJson(String str) => TradeHistoryModelDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeHistoryModelDetails.fromJson(Map<String, dynamic> json) => TradeHistoryModelDetails(
    id: json["_id"],
    amount: json["amount"]?.toDouble(),
    price: json["price"]?.toDouble(),
    total: json["total"]?.toDouble(),
    filledAmount: json["filled_amount"]?.toDouble(),
    pair: json["pair"],
    tradeType: json["trade_type"],
    orderType: json["order_type"],
    adminFeePercentage: json["admin_fee_percentage"]?.toDouble(),
    adminFeeAmount: json["admin_fee_amount"]?.toDouble(),
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "amount": amount,
    "price": price,
    "total": total,
    "filled_amount": filledAmount,
    "pair": pair,
    "trade_type": tradeType,
    "order_type": orderType,
    "admin_fee_percentage": adminFeePercentage,
    "admin_fee_amount": adminFeeAmount,
    "created_date": createdDate?.toIso8601String(),
    "__typename": typename,
  };
}
