import 'dart:convert';

class UserPaymentDetailsModel {
  UserPaymentDetailsModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<UserPaymentDetails>? result;
  String? typename;

  factory UserPaymentDetailsModel.fromRawJson(String str) =>
      UserPaymentDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserPaymentDetailsModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? []
            : List<UserPaymentDetails>.from(
                json["result"]!.map((x) => UserPaymentDetails.fromJson(x))),
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

class UserPaymentDetails {
  UserPaymentDetails({
    this.id,
    this.userId,
    this.paymentDetails,
    this.createdDate,
    this.modifiedDate,
    this.paymentMethodId,
    this.paymentName,
    this.typename,
  });

  String? id;
  String? userId;
  PaymentDetails? paymentDetails;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? paymentMethodId;
  String? paymentName;
  String? typename;

  factory UserPaymentDetails.fromRawJson(String str) =>
      UserPaymentDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserPaymentDetails.fromJson(Map<String, dynamic> json) =>
      UserPaymentDetails(
        id: json["_id"],
        userId: json["user_id"],
        paymentDetails: json["payment_details"] == null
            ? null
            : PaymentDetails.fromJson(json["payment_details"]),
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        modifiedDate: json["modified_date"] == null
            ? null
            : DateTime.parse(json["modified_date"]),
        paymentMethodId: json["payment_method_id"],
        paymentName: json["payment_name"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "payment_details": paymentDetails?.toJson(),
        "created_date": createdDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "payment_method_id": paymentMethodId,
        "payment_name": paymentName,
        "__typename": typename,
      };
}

class PaymentDetails {
  PaymentDetails(
      {this.accountNumber,
      this.ifscCode,
      this.bankName,
      this.accountType,
      this.branch,
      this.qrCode,
      this.upiId,
      this.paymentName,
      this.id});

  String? id;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? accountType;
  String? branch;
  String? qrCode;
  String? upiId;
  String? paymentName;

  factory PaymentDetails.fromRawJson(String str) =>
      PaymentDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        accountNumber: json["account_number"],
        ifscCode: json["ifsc_code"],
        bankName: json["bank_name"],
        accountType: json["account_type"],
        branch: json["branch"],
        qrCode: json["qr_code"],
        upiId: json["upi_id"],
      );

  Map<String, dynamic> toJson() => {
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "bank_name": bankName,
        "account_type": accountType,
        "branch": branch,
        "qr_code": qrCode,
        "upi_id": upiId,
      };
}
