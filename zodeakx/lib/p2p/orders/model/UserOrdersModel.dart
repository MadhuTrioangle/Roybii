import 'dart:convert';

import '../../home/model/p2p_advertisement.dart';

class UserOrdersModel {
  UserOrdersModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  UserOrders? result;
  String? typename;

  factory UserOrdersModel.fromRawJson(String str) => UserOrdersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserOrdersModel.fromJson(Map<String, dynamic> json) => UserOrdersModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : UserOrders.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class UserOrders {
  UserOrders({
    this.page,
    this.pages,
    this.total,
    this.data,
    this.typename,
  });

  int? page;
  int? pages;
  int? total;
  List<OrdersData>? data;
  String? typename;

  factory UserOrders.fromRawJson(String str) => UserOrders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserOrders.fromJson(Map<String, dynamic> json) => UserOrders(
    page: json["page"],
    pages: json["pages"],
    total: json["total"],
    data: json["data"] == null ? [] : List<OrdersData>.from(json["data"]!.map((x) => OrdersData.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pages": pages,
    "total": total,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class OrdersData {
  OrdersData({
    this.id,
    this.tradeType,
    this.counterParty,
    this.toAsset,
    this.fromAsset,
    this.adminFeeAmount,
    this.advertisementId,
    this.sellerId,
    this.buyerId,
    this.status,
    this.price,
    this.amount,
    this.total,
    this.paymentMethod,
    this.fiatExpiryTime,
    this.cryptoExpiryTime,
    this.loggedInUser,
    this.kycName,
    this.modifiedDate,
    this.createdDate,
    this.typename,
  });

  String? id;
  String? tradeType;
  String? counterParty;
  String? toAsset;
  String? fromAsset;
  num? adminFeeAmount;
  String? advertisementId;
  String? sellerId;
  String? buyerId;
  String? status;
  double? price;
  double? amount;
  num? total;
  PaymentMethod? paymentMethod;
  DateTime? fiatExpiryTime;
  dynamic cryptoExpiryTime;
  String? loggedInUser;
  String? kycName;
  DateTime? modifiedDate;
  DateTime? createdDate;
  String? typename;

  factory OrdersData.fromRawJson(String str) => OrdersData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersData.fromJson(Map<String, dynamic> json) => OrdersData(
    id: json["_id"],
    tradeType: json["trade_type"],
    counterParty: json["counter_party"],
    toAsset: json["to_asset"],
    fromAsset: json["from_asset"],
    adminFeeAmount: json["admin_fee_amount"],
    advertisementId: json["advertisement_id"],
    sellerId: json["seller_id"],
    buyerId: json["buyer_id"],
    status: json["status"],
    price: json["price"]?.toDouble(),
    amount: json["amount"]?.toDouble(),
    total: json["total"],
    paymentMethod: json["payment_method"] == null ? null : PaymentMethod.fromJson(json["payment_method"]),
    fiatExpiryTime: json["fiat_expiry_time"] == null ? null : DateTime.parse(json["fiat_expiry_time"]),
    cryptoExpiryTime: json["crypto_expiry_time"],
    loggedInUser: json["loggedInUser"],
    kycName: json["kyc_name"],
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "trade_type": tradeType,
    "counter_party": counterParty,
    "to_asset": toAsset,
    "from_asset": fromAsset,
    "admin_fee_amount": adminFeeAmount,
    "advertisement_id": advertisementId,
    "seller_id": sellerId,
    "buyer_id": buyerId,
    "status": status,
    "price": price,
    "amount": amount,
    "total": total,
    "payment_method": paymentMethod?.toJson(),
    "fiat_expiry_time": fiatExpiryTime?.toIso8601String(),
    "crypto_expiry_time": cryptoExpiryTime,
    "loggedInUser": loggedInUser,
    "kyc_name": kycName,
    "modified_date": modifiedDate?.toIso8601String(),
    "created_date": createdDate?.toIso8601String(),
    "__typename": typename,
  };
}
