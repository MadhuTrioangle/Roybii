// To parse this JSON data, do
//
//     final merchantRecurringInvoiceModel = merchantRecurringInvoiceModelFromJson(jsonString);

import 'dart:convert';

MerchantRecurringInvoiceModel merchantRecurringInvoiceModelFromJson(
        String str) =>
    MerchantRecurringInvoiceModel.fromJson(json.decode(str));

String merchantRecurringInvoiceModelToJson(
        MerchantRecurringInvoiceModel data) =>
    json.encode(data.toJson());

class MerchantRecurringInvoiceModel {
  num? statusCode;
  String? statusMessage;
  MerchantRecurringInvoice? result;
  String? typename;

  MerchantRecurringInvoiceModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory MerchantRecurringInvoiceModel.fromJson(Map<String, dynamic> json) =>
      MerchantRecurringInvoiceModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : MerchantRecurringInvoice.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class MerchantRecurringInvoice {
  num? total;
  List<MerchantRecurring>? data;
  String? typename;

  MerchantRecurringInvoice({
    this.total,
    this.data,
    this.typename,
  });

  factory MerchantRecurringInvoice.fromJson(Map<String, dynamic> json) =>
      MerchantRecurringInvoice(
        total: json["total"],
        data: json["data"] == null
            ? []
            : List<MerchantRecurring>.from(
                json["data"]!.map((x) => MerchantRecurring.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class MerchantRecurring {
  String? id;
  String? invoiceId;
  String? currency;
  String? merchantName;
  String? merchantPayId;
  String? clientName;
  String? clientEmail;
  String? clientAddress;
  num? itemsOverallAmount;
  num? itemsTaxAmount;
  String? invoiceType;
  dynamic paymentDate;
  dynamic transactionId;
  List<SaleItemInfo>? saleItemInfo;
  String? invoiceDueRecuringValue;
  dynamic invoiceDueRecurringType;
  String? invoiceDueTimeZone;
  DateTime? invoiceDueDate;
  DateTime? createdAt;
  String? status;
  String? typename;

  MerchantRecurring({
    this.id,
    this.invoiceId,
    this.currency,
    this.merchantName,
    this.merchantPayId,
    this.clientName,
    this.clientEmail,
    this.clientAddress,
    this.itemsOverallAmount,
    this.itemsTaxAmount,
    this.invoiceType,
    this.paymentDate,
    this.transactionId,
    this.saleItemInfo,
    this.invoiceDueRecuringValue,
    this.invoiceDueRecurringType,
    this.invoiceDueTimeZone,
    this.invoiceDueDate,
    this.createdAt,
    this.status,
    this.typename,
  });

  factory MerchantRecurring.fromJson(Map<String, dynamic> json) =>
      MerchantRecurring(
        id: json["_id"],
        invoiceId: json["invoiceId"],
        currency: json["currency"],
        merchantName: json["merchantName"],
        merchantPayId: json["merchantPayId"],
        clientName: json["clientName"],
        clientEmail: json["clientEmail"],
        clientAddress: json["clientAddress"],
        itemsOverallAmount: json["itemsOverallAmount"],
        itemsTaxAmount: json["itemsTaxAmount"],
        invoiceType: json["invoiceType"],
        paymentDate: json["paymentDate"],
        transactionId: json["transactionId"],
        saleItemInfo: json["saleItemInfo"] == null
            ? []
            : List<SaleItemInfo>.from(
                json["saleItemInfo"]!.map((x) => SaleItemInfo.fromJson(x))),
        invoiceDueRecuringValue: json["invoiceDueRecuringValue"],
        invoiceDueRecurringType: json["invoiceDueRecurringType"],
        invoiceDueTimeZone: json["invoiceDueTimeZone"],
        invoiceDueDate: json["invoiceDueDate"] == null
            ? null
            : DateTime.parse(json["invoiceDueDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        status: json["status"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "invoiceId": invoiceId,
        "currency": currency,
        "merchantName": merchantName,
        "merchantPayId": merchantPayId,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientAddress": clientAddress,
        "itemsOverallAmount": itemsOverallAmount,
        "itemsTaxAmount": itemsTaxAmount,
        "invoiceType": invoiceType,
        "paymentDate": paymentDate,
        "transactionId": transactionId,
        "saleItemInfo": saleItemInfo == null
            ? []
            : List<dynamic>.from(saleItemInfo!.map((x) => x.toJson())),
        "invoiceDueRecuringValue": invoiceDueRecuringValue,
        "invoiceDueRecurringType": invoiceDueRecurringType,
        "invoiceDueTimeZone": invoiceDueTimeZone,
        "invoiceDueDate": invoiceDueDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "status": status,
        "__typename": typename,
      };
}

class SaleItemInfo {
  String? item;
  String? itemDescription;
  num? itemPerPrice;
  num? itemQuantity;
  num? itemTotalAmount;
  num? discount;
  String? discountType;
  String? typename;

  SaleItemInfo({
    this.item,
    this.itemDescription,
    this.itemPerPrice,
    this.itemQuantity,
    this.itemTotalAmount,
    this.discount,
    this.discountType,
    this.typename,
  });

  factory SaleItemInfo.fromJson(Map<String, dynamic> json) => SaleItemInfo(
        item: json["item"],
        itemDescription: json["itemDescription"],
        itemPerPrice: json["itemPerPrice"],
        itemQuantity: json["itemQuantity"],
        itemTotalAmount: json["itemTotalAmount"],
        discount: json["discount"],
        discountType: json["discountType"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "itemDescription": itemDescription,
        "itemPerPrice": itemPerPrice,
        "itemQuantity": itemQuantity,
        "itemTotalAmount": itemTotalAmount,
        "discount": discount,
        "discountType": discountType,
        "__typename": typename,
      };
}
