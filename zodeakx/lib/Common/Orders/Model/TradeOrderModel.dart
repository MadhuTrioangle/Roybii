// To parse this JSON data, do
//
//     final tradeOrderModel = tradeOrderModelFromJson(jsonString);

import 'dart:convert';

class TradeOrderModel {
  TradeOrderModel({
    required this.statusCode,
    required this.statusMessage,
    required this.result,
    required this.typename,
  });

  int statusCode;
  String statusMessage;
  TradeOrder? result;
  String typename;

  factory TradeOrderModel.fromRawJson(String str) => TradeOrderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeOrderModel.fromJson(Map<String, dynamic> json) => TradeOrderModel(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : TradeOrder.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result!.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class TradeOrder {
  TradeOrder({
    required this.data,
    required this.total,
    required this.limit,
    required this.page,
    required this.pages,
    required this.typename,
  });

  List<Order>? data;
  int? total;
  int? limit;
  int? page;
  int? pages;
  String typename;

  factory TradeOrder.fromRawJson(String str) => TradeOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeOrder.fromJson(Map<String, dynamic> json) => TradeOrder(
    data: json["data"] == null ? null : List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
    total: json["total"] == null ? null : json["total"],
    limit: json["limit"] == null ? null : json["limit"],
    page: json["page"] == null ? null : json["page"],
    pages: json["pages"] == null ? null : json["pages"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total == null ? null : total,
    "limit": limit == null ? null : limit,
    "page": page == null ? null : page,
    "pages": pages == null ? null : pages,
    "__typename": typename == null ? null : typename,
  };
}

class Order {
  Order({
    required this.id,
    required this.amount,
    required this.marketPrice,
    required this.adminFeePercentage,
    required this.adminFeeAmount,
    required this.total,
    required this.tradeType,
    required this.orderType,
    required this.pair,
    required this.status,
    required this.partialAmount,
    required this.initialAmount,
    required this.stopPrice,
    required this.limitPrice,
    required this.triggerPrice,
    required this.orderedDate,
    required this.tradedDate,
    required this.cancelledDate,
    required this.userId,
    required this.userEmail,
    required this.user,
    required this.typename,
  });

  String id;
  double amount;
  double marketPrice;
  dynamic adminFeePercentage;
  dynamic adminFeeAmount;
  double total;
  String tradeType;
  String orderType;
  String pair;
  String status;
  dynamic partialAmount;
  dynamic initialAmount;
  dynamic stopPrice;
  dynamic limitPrice;
  dynamic triggerPrice;
  DateTime? orderedDate;
  DateTime? tradedDate;
  DateTime? cancelledDate;
  String userId;
  String userEmail;
  List<User>? user;
  String typename;

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"] == null ? null : json["_id"],
    amount: json["amount"] == null ? null : json["amount"].toDouble(),
    marketPrice: json["market_price"] == null ? null : json["market_price"].toDouble(),
    adminFeePercentage: json["admin_fee_percentage"] == null ? null : json["admin_fee_percentage"],
    adminFeeAmount: json["admin_fee_amount"] == null ? null : json["admin_fee_amount"],
    total: json["total"] == null ? null : json["total"].toDouble(),
    tradeType: json["trade_type"] == null ? null : json["trade_type"],
    orderType: json["order_type"] == null ? null : json["order_type"],
    pair: json["pair"] == null ? null : json["pair"],
    status: json["status"] == null ? null : json["status"],
    partialAmount: json["partial_amount"] == null ? null : json["partial_amount"],
    initialAmount: json["initial_amount"] == null ? null : json["initial_amount"],
    stopPrice: json["stop_price"] == null ? null : json["stop_price"],
    limitPrice: json["limit_price"] == null ? null : json["limit_price"],
    triggerPrice: json["trigger_price"] == null ? null : json["trigger_price"],
    orderedDate: json["ordered_date"] == null ? null : DateTime.parse(json["ordered_date"]),
    tradedDate: json["traded_date"] == null ? null : DateTime.parse(json["traded_date"]),
    cancelledDate: json["cancelled_date"] == null ? null : DateTime.parse(json["cancelled_date"]),
    userId: json["user_id"] == null ? null : json["user_id"],
    userEmail: json["user_email"] == null ? null : json["user_email"],
    user: json["user"] == null ? null : List<User>.from(json["user"].map((x) => User.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "amount": amount == null ? null : amount,
    "market_price": marketPrice == null ? null : marketPrice,
    "admin_fee_percentage": adminFeePercentage == null ? null : adminFeePercentage,
    "admin_fee_amount": adminFeeAmount == null ? null : adminFeeAmount,
    "total": total == null ? null : total,
    "trade_type": tradeType == null ? null : tradeType,
    "order_type": orderType == null ? null : orderType,
    "pair": pair == null ? null : pair,
    "status": status == null ? null : status,
    "partial_amount": partialAmount == null ? null : partialAmount,
    "stop_price": stopPrice == null ? null : stopPrice,
    "limit_price": limitPrice == null ? null : limitPrice,
    "trigger_price": triggerPrice == null ? null : triggerPrice,
    "ordered_date": orderedDate == null ? null : orderedDate!.toIso8601String(),
    "traded_date": tradedDate == null ? null : tradedDate!.toIso8601String(),
    "cancelled_date": cancelledDate == null ? null : cancelledDate!.toIso8601String(),
    "user_id": userId == null ? null : userId,
    "user_email": userEmail == null ? null : userEmail,
    "user": user == null ? null : List<dynamic>.from(user!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class User {
  User({
    required this.email,
    required this.typename,
  });

  String email;
  String typename;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"] == null ? null : json["email"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : email,
    "__typename": typename == null ? null : typename,
  };
}
