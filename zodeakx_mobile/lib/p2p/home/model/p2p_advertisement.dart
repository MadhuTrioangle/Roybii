import 'dart:convert';

class P2PAdvertisementModel {
  P2PAdvertisementModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  P2PAdvertisement? result;
  String? typename;

  factory P2PAdvertisementModel.fromRawJson(String str) =>
      P2PAdvertisementModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory P2PAdvertisementModel.fromJson(Map<String, dynamic> json) =>
      P2PAdvertisementModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : P2PAdvertisement.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() =>
      {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class P2PAdvertisement {
  P2PAdvertisement({
    this.total,
    this.limit,
    this.page,
    this.pages,
    this.data,
    this.typename,
  });

  int? total;
  int? limit;
  int? page;
  int? pages;
  List<Advertisement>? data;
  String? typename;

  factory P2PAdvertisement.fromRawJson(String str) =>
      P2PAdvertisement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory P2PAdvertisement.fromJson(Map<String, dynamic> json) =>
      P2PAdvertisement(
        total: json["total"],
        limit: json["limit"],
        page: json["page"],
        pages: json["pages"],
        data: json["data"] == null
            ? []
            : List<Advertisement>.from(
            json["data"]!.map((x) => Advertisement.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() =>
      {
        "total": total,
        "limit": limit,
        "page": page,
        "pages": pages,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class Advertisement {
  Advertisement({
    this.id,
    this.userId,
    this.minTradeOrder,
    this.maxTradeOrder,
    this.advertisementType,
    this.tradeStatus,
    this.paymentMethod,
    this.floatingPrice,
    this.price,
    this.amount,
    this.filledAmount,
    this.status,
    this.total,
    this.fromAsset,
    this.toAsset,
    this.createdDate,
    this.modifiedDate,
    this.autoReply,
    this.completionRate,
    this.totalOrders,
    this.priceType,
    this.paymentTimeLimit,
    this.remarks,
    this.name,
    this.floatingPriceMargin,
    this.typename,
  });

  String? id;
  String? userId;
  num? minTradeOrder;
  num? maxTradeOrder;
  String? advertisementType;
  String? tradeStatus;
  List<PaymentMethod>? paymentMethod;
  num? floatingPrice;
  num? price;
  num? amount;
  num? filledAmount;
  String? status;
  num? total;
  String? fromAsset;
  String? toAsset;
  DateTime? createdDate;
  DateTime? modifiedDate;
  dynamic autoReply;
  num? completionRate;
  num? totalOrders;
  String? priceType;
  num? paymentTimeLimit;
  String? remarks;
  String? name;
  num? floatingPriceMargin;
  String? typename;

  factory Advertisement.fromRawJson(String str) =>
      Advertisement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Advertisement.fromJson(Map<String, dynamic> json) =>
      Advertisement(
        id: json["_id"],
        userId: json["user_id"],
        minTradeOrder: json["min_trade_order"],
        maxTradeOrder: json["max_trade_order"]?.toDouble(),
        advertisementType: json["advertisement_type"],
        tradeStatus: json["trade_status"],
        paymentMethod: json["payment_method"] == null
            ? []
            : List<PaymentMethod>.from(
            json["payment_method"]!.map((x) => PaymentMethod.fromJson(x))),
        floatingPrice: json["floating_price"],
        price: json["price"]?.toDouble(),
        amount: json["amount"]?.toDouble(),
        filledAmount: json["filled_amount"]?.toDouble(),
        status: json["status"],
        total: json["total"],
        fromAsset: json["from_asset"],
        toAsset: json["to_asset"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] == null
            ? null
            : DateTime.parse(json["modified_date"]),
        autoReply: json["auto_reply"],
        completionRate: json["completion_rate"],
        totalOrders: json["totalOrders"],
        priceType: json["price_type"],
        paymentTimeLimit: json["payment_time_limit"],
        remarks: json["remarks"],
        name: json["name"],
        floatingPriceMargin: json["floating_price_margin"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() =>
      {
        "_id": id,
        "user_id": userId,
        "min_trade_order": minTradeOrder,
        "max_trade_order": maxTradeOrder,
        "advertisement_type": advertisementType,
        "trade_status": tradeStatus,
        "payment_method": paymentMethod == null
            ? []
            : List<dynamic>.from(paymentMethod!.map((x) => x.toJson())),
        "floating_price": floatingPrice,
        "price": price,
        "amount": amount,
        "filled_amount": filledAmount,
        "status": status,
        "total": total,
        "from_asset": fromAsset,
        "to_asset": toAsset,
        "created_date": createdDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "auto_reply": autoReply,
        "completion_rate": completionRate,
        "totalOrders": totalOrders,
        "price_type": priceType,
        "payment_time_limit": paymentTimeLimit,
        "remarks": remarks,
        "name": name,
        "floating_price_margin": floatingPriceMargin,
        "__typename": typename,
      };
}

class PaymentMethod {
  PaymentMethod({
    this.paymentMethodId,
    this.paymentMethodName,
    this.typename,
  });

  String? paymentMethodId;
  String? paymentMethodName;
  String? typename;

  factory PaymentMethod.fromRawJson(String str) =>
      PaymentMethod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      PaymentMethod(
        paymentMethodId: json["payment_method_id"],
        paymentMethodName: json["payment_method_name"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() =>
      {
        "payment_method_id": paymentMethodId,
        "payment_method_name": paymentMethodName,
        "__typename": typename,
      };
}

Advertisement dummyAdvertisement = Advertisement(
    id: "6412c991de823a6b62aea312",
    userId: "63076f554743124b1b133fce",
    minTradeOrder: 1,
    maxTradeOrder: 1.9,
    advertisementType: "sell",
    tradeStatus: "published",
    paymentMethod: [
      PaymentMethod(
        paymentMethodId: "62f60825883eb7691f3941e7",
        paymentMethodName: "IMPS"
      ),
      PaymentMethod(
        paymentMethodId: "62f60825883eb7691f3941e7",
        paymentMethodName: "UPI"
      ),
    ],
    floatingPrice: 27726.05,
    price: 0.4,
    amount: 1.86,
    filledAmount: 1,
    status: "partially",
    total: 51570.453,
    fromAsset: "BTC",
    toAsset: "USD",
    autoReply: null,
    completionRate: 75,
    totalOrders: 4,
    priceType: "floating",
    paymentTimeLimit: 15,
    remarks: "",
    name: "DDriveraCripto",
    floatingPriceMargin: 100
);