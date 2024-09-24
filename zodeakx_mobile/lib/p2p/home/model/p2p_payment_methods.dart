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

  factory P2PPaymentMethodsModel.fromRawJson(String str) =>
      P2PPaymentMethodsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory P2PPaymentMethodsModel.fromJson(Map<String, dynamic> json) =>
      P2PPaymentMethodsModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? []
            : List<PaymentMethods>.from(
                json["result"]!.map((x) => PaymentMethods.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
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
    this.paymentFields,
  });

  String? status;
  String? name;
  String? id;
  String? type;
  String? typename;
  List<PaymentField>? paymentFields;

  factory PaymentMethods.fromRawJson(String str) =>
      PaymentMethods.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentMethods.fromJson(Map<String, dynamic> json) => PaymentMethods(
        status: json["status"],
        name: json["name"],
        id: json["_id"],
        type: json["type"],
        typename: json["__typename"],
        paymentFields: json["payment_fields"] == null
            ? []
            : List<PaymentField>.from(
                json["payment_fields"]!.map((x) => PaymentField.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "name": name,
        "_id": id,
        "type": type,
        "__typename": typename,
        "payment_fields": paymentFields == null
            ? []
            : List<dynamic>.from(paymentFields!.map((x) => x.toJson())),
      };
}

class PaymentField {
  String? label;
  String? labelKey;
  bool? isMandatory;
  String? id;
  String? type;

  PaymentField({
    this.label,
    this.labelKey,
    this.isMandatory,
    this.id,
    this.type,
  });

  factory PaymentField.fromRawJson(String str) =>
      PaymentField.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentField.fromJson(Map<String, dynamic> json) => PaymentField(
        label: json["label"],
        labelKey: json["label_key"],
        isMandatory: json["isMandatory"],
        id: json["_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "label_key": labelKey,
        "isMandatory": isMandatory,
        "_id": id,
        "type": type,
      };
}
