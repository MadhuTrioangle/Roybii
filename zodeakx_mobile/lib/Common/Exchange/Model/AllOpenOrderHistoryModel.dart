import 'dart:convert';

class AllOpenOrderHistoryModel {
  num? statusCode;
  String? statusMessage;
  List<AllOpenOrderHistory>? result;
  String? typename;

  AllOpenOrderHistoryModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory AllOpenOrderHistoryModel.fromRawJson(String str) => AllOpenOrderHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllOpenOrderHistoryModel.fromJson(Map<String, dynamic> json) => AllOpenOrderHistoryModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<AllOpenOrderHistory>.from(json["result"]!.map((x) => AllOpenOrderHistory.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class AllOpenOrderHistory {
  num? amount;
  num? marketPrice;
  num? total;
  String? pair;
  String? id;
  String? tradeType;
  String? orderType;
  num? partialAmount;
  num? stopPrice;
  num? limitPrice;
  num? triggerPrice;
  num? orderedAmount;
  num? initialAmount;
  DateTime? orderedDate;
  String? status;
  bool? marginOrder;
  String? marginType;
  bool? liquidationOrder;
  String? typename;

  AllOpenOrderHistory({
    this.amount,
    this.marketPrice,
    this.total,
    this.pair,
    this.id,
    this.tradeType,
    this.orderType,
    this.partialAmount,
    this.stopPrice,
    this.limitPrice,
    this.triggerPrice,
    this.orderedAmount,
    this.initialAmount,
    this.orderedDate,
    this.status,
    this.marginOrder,
    this.marginType,
    this.liquidationOrder,
    this.typename,
  });

  factory AllOpenOrderHistory.fromRawJson(String str) => AllOpenOrderHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllOpenOrderHistory.fromJson(Map<String, dynamic> json) => AllOpenOrderHistory(
    amount: json["amount"],
    marketPrice: json["market_price"]?.toDouble(),
    total: json["total"]?.toDouble(),
    pair: json["pair"],
    id: json["_id"],
    tradeType: json["trade_type"],
    orderType: json["order_type"],
    partialAmount: json["partial_amount"],
    stopPrice: json["stop_price"],
    limitPrice: json["limit_price"],
    triggerPrice: json["trigger_price"],
    orderedAmount: json["ordered_amount"],
    initialAmount: json["initial_amount"],
    orderedDate: json["ordered_date"] == null ? null : DateTime.parse(json["ordered_date"]),
    status: json["status"],
    marginOrder: json["margin_order"],
    marginType: json["margin_type"],
    liquidationOrder: json["liquidation_order"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "market_price": marketPrice,
    "total": total,
    "pair": pair,
    "_id": id,
    "trade_type": tradeType,
    "order_type": orderType,
    "partial_amount": partialAmount,
    "stop_price": stopPrice,
    "limit_price": limitPrice,
    "trigger_price": triggerPrice,
    "ordered_amount": orderedAmount,
    "initial_amount": initialAmount,
    "ordered_date": orderedDate?.toIso8601String(),
    "status": status,
    "margin_order": marginOrder,
    "margin_type": marginType,
    "liquidation_order": liquidationOrder,
    "__typename": typename,
  };
}
