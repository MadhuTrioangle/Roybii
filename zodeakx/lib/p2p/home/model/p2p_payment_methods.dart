import 'dart:convert';

class P2PPaymentMethodsModel {
  P2PPaymentMethodsModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<PaymentMethods>? result;
  String? typename;

  factory P2PPaymentMethodsModel.fromRawJson(String str) => P2PPaymentMethodsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory P2PPaymentMethodsModel.fromJson(Map<String, dynamic> json) => P2PPaymentMethodsModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<PaymentMethods>.from(json["result"]!.map((x) => PaymentMethods.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class PaymentMethods {
  PaymentMethods({
    this.status,
    this.name,
    this.id,
    this.type,
    this.typename,
  });

  String? status;
  String? name;
  String? id;
  String? type;
  String? typename;

  factory PaymentMethods.fromRawJson(String str) => PaymentMethods.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
    status: json["status"],
    name: json["name"],
    id: json["_id"],
    type: json["type"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "name": name,
    "_id": id,
    "type": type,
    "__typename": typename,
  };
}
