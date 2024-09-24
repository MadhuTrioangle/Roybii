import 'dart:convert';

class MerchantPaymentLinkModel {
  int? statusCode;
  String? statusMessage;
  MerchantPaymentLink? result;
  String? typename;

  MerchantPaymentLinkModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory MerchantPaymentLinkModel.fromRawJson(String str) =>
      MerchantPaymentLinkModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MerchantPaymentLinkModel.fromJson(Map<String, dynamic> json) =>
      MerchantPaymentLinkModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? null
            : MerchantPaymentLink.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class MerchantPaymentLink {
  int? total;
  List<MerchantPayment>? data;
  String? typename;

  MerchantPaymentLink({
    this.total,
    this.data,
    this.typename,
  });

  factory MerchantPaymentLink.fromRawJson(String str) =>
      MerchantPaymentLink.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MerchantPaymentLink.fromJson(Map<String, dynamic> json) =>
      MerchantPaymentLink(
        total: json["total"],
        data: json["data"] == null
            ? []
            : List<MerchantPayment>.from(
                json["data"]!.map((x) => MerchantPayment.fromJson(x))),
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

class MerchantPayment {
  String? id;
  String? merchantName;
  String? merchantEmail;
  String? merchantPayId;
  String? currency;
  double? payAmount;
  String? paymentLink;
  String? paymentLinkId;
  String? paymentLinkReference;
  String? paymentLinkType;
  String? productName;
  String? productType;
  String? productDetail;
  int? totalNoOfPayments;
  int? remainingNoOfPayments;
  String? status;
  DateTime? createdAt;
  DateTime? validityDate;
  String? typename;

  MerchantPayment({
    this.id,
    this.merchantName,
    this.merchantEmail,
    this.merchantPayId,
    this.currency,
    this.payAmount,
    this.paymentLink,
    this.paymentLinkId,
    this.paymentLinkReference,
    this.paymentLinkType,
    this.productName,
    this.productType,
    this.productDetail,
    this.totalNoOfPayments,
    this.remainingNoOfPayments,
    this.status,
    this.createdAt,
    this.validityDate,
    this.typename,
  });

  factory MerchantPayment.fromRawJson(String str) =>
      MerchantPayment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MerchantPayment.fromJson(Map<String, dynamic> json) =>
      MerchantPayment(
        id: json["_id"],
        merchantName: json["merchantName"],
        merchantEmail: json["merchantEmail"],
        merchantPayId: json["merchantPayId"],
        currency: json["currency"],
        payAmount: json["payAmount"]?.toDouble(),
        paymentLink: json["paymentLink"],
        paymentLinkId: json["paymentLinkId"],
        paymentLinkReference: json["paymentLinkReference"],
        paymentLinkType: json["paymentLinkType"],
        productName: json["productName"],
        productType: json["productType"],
        productDetail: json["productDetail"],
        totalNoOfPayments: json["totalNoOfPayments"],
        remainingNoOfPayments: json["remainingNoOfPayments"],
        status: json["status"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        validityDate: json["validityDate"] == null
            ? null
            : DateTime.parse(json["validityDate"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "merchantName": merchantName,
        "merchantEmail": merchantEmail,
        "merchantPayId": merchantPayId,
        "currency": currency,
        "payAmount": payAmount,
        "paymentLink": paymentLink,
        "paymentLinkId": paymentLinkId,
        "paymentLinkReference": paymentLinkReference,
        "paymentLinkType": paymentLinkType,
        "productName": productName,
        "productType": productType,
        "productDetail": productDetail,
        "totalNoOfPayments": totalNoOfPayments,
        "remainingNoOfPayments": remainingNoOfPayments,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "validityDate": validityDate?.toIso8601String(),
        "__typename": typename,
      };
}
