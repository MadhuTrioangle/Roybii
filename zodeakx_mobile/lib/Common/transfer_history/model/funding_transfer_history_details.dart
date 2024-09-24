import 'dart:convert';

class GetUserFundingWalletTransferDetailsClass {
  int? statusCode;
  String? statusMessage;
  List<GetUserFundingWalletTransferDetails>? result;

  GetUserFundingWalletTransferDetailsClass({
    this.statusCode,
    this.statusMessage,
    this.result,
  });

  factory GetUserFundingWalletTransferDetailsClass.fromRawJson(String str) => GetUserFundingWalletTransferDetailsClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserFundingWalletTransferDetailsClass.fromJson(Map<String, dynamic> json) => GetUserFundingWalletTransferDetailsClass(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<GetUserFundingWalletTransferDetails>.from(json["result"]!.map((x) => GetUserFundingWalletTransferDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class GetUserFundingWalletTransferDetails {
  String? currencyCode;
  String? fromWallet;
  String? toWallet;
  num? amount;
  String? status;
  DateTime? createdDate;
  String? currencyType;

  GetUserFundingWalletTransferDetails({
    this.currencyCode,
    this.fromWallet,
    this.toWallet,
    this.amount,
    this.status,
    this.createdDate,
    this.currencyType,
  });

  factory GetUserFundingWalletTransferDetails.fromRawJson(String str) => GetUserFundingWalletTransferDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUserFundingWalletTransferDetails.fromJson(Map<String, dynamic> json) => GetUserFundingWalletTransferDetails(
    currencyCode: json["currency_code"],
    fromWallet: json["from_wallet"],
    toWallet: json["to_wallet"],
    amount: json["amount"],
    status: json["status"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    currencyType: json["currency_type"],
  );

  Map<String, dynamic> toJson() => {
    "currency_code": currencyCode,
    "from_wallet": fromWallet,
    "to_wallet": toWallet,
    "amount": amount,
    "status": status,
    "created_date": createdDate?.toIso8601String(),
    "currency_type": currencyType,
  };
}

