import 'dart:convert';

class CancelledOrderModelClass {
  int? statusCode;
  String? statusMessage;
  CancelledOrder? result;
  String? typename;

  CancelledOrderModelClass({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory CancelledOrderModelClass.fromRawJson(String str) => CancelledOrderModelClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancelledOrderModelClass.fromJson(Map<String, dynamic> json) => CancelledOrderModelClass(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : CancelledOrder.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class CancelledOrder {
  List<CancelOrder>? data;
  int? total;
  int? limit;
  int? page;
  int? pages;
  String? typename;

  CancelledOrder({
    this.data,
    this.total,
    this.limit,
    this.page,
    this.pages,
    this.typename,
  });

  factory CancelledOrder.fromRawJson(String str) => CancelledOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancelledOrder.fromJson(Map<String, dynamic> json) => CancelledOrder(
    data: json["data"] == null ? [] : List<CancelOrder>.from(json["data"]!.map((x) => CancelOrder.fromJson(x))),
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

class CancelOrder {
  String? id;
  num? amount;
  num? initial_amount;
  num? marketPrice;
  num? adminFeePercentage;
  num? adminFeeAmount;
  num? total;
  String? tradeType;
  String? orderType;
  String? pair;
  String? status;
  num? partialAmount;
  num? stopPrice;
  num? limitPrice;
  num? triggerPrice;
  DateTime? orderedDate;
  DateTime? tradedDate;
  DateTime? cancelledDate;
  String? userId;
  String? userEmail;
  List<User>? user;
  String? typename;

  CancelOrder({
    this.id,
    this.amount,
    this.initial_amount,
    this.marketPrice,
    this.adminFeePercentage,
    this.adminFeeAmount,
    this.total,
    this.tradeType,
    this.orderType,
    this.pair,
    this.status,
    this.partialAmount,
    this.stopPrice,
    this.limitPrice,
    this.triggerPrice,
    this.orderedDate,
    this.tradedDate,
    this.cancelledDate,
    this.userId,
    this.userEmail,
    this.user,
    this.typename,
  });

  factory CancelOrder.fromRawJson(String str) => CancelOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CancelOrder.fromJson(Map<String, dynamic> json) => CancelOrder(
    id: json["_id"],
    amount: json["amount"]?.toDouble(),
    initial_amount: json["initial_amount"]?.toDouble(),
    marketPrice: json["market_price"]?.toDouble(),
    adminFeePercentage: json["admin_fee_percentage"],
    adminFeeAmount: json["admin_fee_amount"],
    total: json["total"]?.toDouble(),
    tradeType: json["trade_type"],
    orderType: json["order_type"],
    pair: json["pair"],
    status: json["status"],
    partialAmount: json["partial_amount"],
    stopPrice: json["stop_price"],
    limitPrice: json["limit_price"],
    triggerPrice: json["trigger_price"],
    orderedDate: json["ordered_date"] == null ? null : DateTime.parse(json["ordered_date"]),
    tradedDate: json["traded_date"] == null ? null : DateTime.parse(json["traded_date"]),
    cancelledDate: json["cancelled_date"] == null ? null : DateTime.parse(json["cancelled_date"]),
    userId: json["user_id"],
    userEmail: json["user_email"],
    user: json["user"] == null ? [] : List<User>.from(json["user"]!.map((x) => User.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "amount": amount,
    "initial_amount": initial_amount,
    "market_price": marketPrice,
    "admin_fee_percentage": adminFeePercentage,
    "admin_fee_amount": adminFeeAmount,
    "total": total,
    "trade_type": tradeType,
    "order_type": orderType,
    "pair": pair,
    "status": status,
    "partial_amount": partialAmount,
    "stop_price": stopPrice,
    "limit_price": limitPrice,
    "trigger_price": triggerPrice,
    "ordered_date": orderedDate?.toIso8601String(),
    "traded_date": tradedDate?.toIso8601String(),
    "cancelled_date": cancelledDate?.toIso8601String(),
    "user_id": userId,
    "user_email": userEmail,
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class User {
  String? email;
  String? typename;

  User({
    this.email,
    this.typename,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "__typename": typename,
  };
}
