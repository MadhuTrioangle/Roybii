// To parse this JSON data, do
//
//     final openOrderHistoryModel = openOrderHistoryModelFromJson(jsonString);

import 'dart:convert';

class OpenOrderHistoryModel {
  OpenOrderHistoryModel({
    required this.statusCode,
    required this.statusMessage,
    required this.result,
    required this.typename,
  });

  int statusCode;
  String statusMessage;
  List<OpenOrderHistory>? result;
  String typename;

  factory OpenOrderHistoryModel.fromRawJson(String str) =>
      OpenOrderHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OpenOrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OpenOrderHistoryModel(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage:
        json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null
            ? null
            : List<OpenOrderHistory>.from(
            json["result"].map((x) => OpenOrderHistory.fromJson(x))),
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null
        ? null
        : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class OpenOrderHistory {
  OpenOrderHistory({
    required this.amount,
    required this.marketPrice,
    required this.total,
    required this.pair,
    required this.id,
    required this.tradeType,
    required this.orderType,
    required this.partialAmount,
    required this.stopPrice,
    required this.limitPrice,
    required this.triggerPrice,
    required this.orderedAmount,
    required this.initialAmount,
    required this.orderedDate,
    required this.status,
    required this.typename,
  });

  double amount;
  double marketPrice;
  double total;
  String pair;
  String id;
  String tradeType;
  String orderType;
  dynamic partialAmount;
  double stopPrice;
  double limitPrice;
  double triggerPrice;
  double orderedAmount;
  double initialAmount;
  DateTime? orderedDate;
  String status;
  String typename;

  factory OpenOrderHistory.fromRawJson(String str) =>
      OpenOrderHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OpenOrderHistory.fromJson(Map<String, dynamic> json) =>
      OpenOrderHistory(
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        marketPrice: json["market_price"] == null
            ? null
            : json["market_price"].toDouble(),
        total: json["total"] == null ? null : json["total"].toDouble(),
        pair: json["pair"] == null ? null : json["pair"],
        id: json["_id"] == null ? null : json["_id"],
        tradeType: json["trade_type"] == null ? null : json["trade_type"],
        orderType: json["order_type"] == null ? null : json["order_type"],
        partialAmount:
        json["partial_amount"] == null ? null : json["partial_amount"],
        stopPrice:
        json["stop_price"] == null ? null : json["stop_price"].toDouble(),
        limitPrice:
        json["limit_price"] == null ? null : json["limit_price"].toDouble(),
        triggerPrice: json["trigger_price"] == null
            ? null
            : json["trigger_price"].toDouble(),
        orderedAmount: json["ordered_amount"] == null
            ? null
            : json["ordered_amount"].toDouble(),
        initialAmount: json["initial_amount"] == null
            ? null
            : json["initial_amount"].toDouble(),
        orderedDate: json["ordered_date"] == null
            ? null
            : DateTime.parse(json["ordered_date"]),
        status: json["status"] == null ? null : json["status"],
        typename: json["__typename"] == null ? null : json["__typename"],
      );

  Map<String, dynamic> toJson() => {
    "amount": amount == null ? null : amount,
    "market_price": marketPrice == null ? null : marketPrice,
    "total": total == null ? null : total,
    "pair": pair == null ? null : pair,
    "_id": id == null ? null : id,
    "trade_type": tradeType == null ? null : tradeType,
    "order_type": orderType == null ? null : orderType,
    "partial_amount": partialAmount == null ? null : partialAmount,
    "stop_price": stopPrice == null ? null : stopPrice,
    "limit_price": limitPrice == null ? null : limitPrice,
    "trigger_price": triggerPrice == null ? null : triggerPrice,
    "ordered_amount": orderedAmount == null ? null : orderedAmount,
    "initial_amount": initialAmount == null ? null : initialAmount,
    "ordered_date":
    orderedDate == null ? null : orderedDate!.toIso8601String(),
    "status": status == null ? null : status,
    "__typename": typename == null ? null : typename,
  };
}
