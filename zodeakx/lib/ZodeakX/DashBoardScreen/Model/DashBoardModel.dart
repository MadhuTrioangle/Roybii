// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

class DashboardModel {
  DashboardModel({
    this.data,
  });

  Data? data;

  factory DashboardModel.fromRawJson(String str) => DashboardModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data?.toJson(),
  };
}

class Data {
  Data({
    this.getBalance,
  });

  GetBalance? getBalance;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    getBalance: json["getBalance"] == null ? null : GetBalance.fromJson(json["getBalance"]),
  );

  Map<String, dynamic> toJson() => {
    "getBalance": getBalance == null ? null : getBalance?.toJson(),
  };
}

class GetBalance {
  GetBalance({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<DashBoardBalance>? result;
  String? typename;

  factory GetBalance.fromRawJson(String str) => GetBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetBalance.fromJson(Map<String, dynamic> json) => GetBalance(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<DashBoardBalance>.from(json["result"].map((x) =>
        DashBoardBalance.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class DashBoardBalance {
  DashBoardBalance({
    this.image,
    this.currencyCode,
    this.currencyName,
    this.currencyType,
    this.depositStatus,
    this.withdrawStatus,
    this.tradeStatus,
    this.stakeBalance,
    this.availableBalance,
    this.inorderBalance,
    this.mlmStakeBalance,
    this.totalBalance,
    this.btcValue,
    this.usdValue,
    this.defaultCryptoValue,
    this.status,
    this.typename,
  });

  String? image;
  String? currencyCode;
  String? currencyName;
  CurrencyType? currencyType;
  Status? depositStatus;
  Status? withdrawStatus;
  Status? tradeStatus;
  num? stakeBalance;
  num? availableBalance;
  num? inorderBalance;
  num? mlmStakeBalance;
  num? totalBalance;
  num? btcValue;
  num? usdValue;
  num? defaultCryptoValue;
  Status? status;
  Typename? typename;

  factory DashBoardBalance.fromRawJson(String str) => DashBoardBalance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashBoardBalance.fromJson(Map<String, dynamic> json) => DashBoardBalance(
    image: json["image"] == null ? null : json["image"],
    currencyCode: json["currency_code"] == null ? null : json["currency_code"],
    currencyName: json["currency_name"] == null ? null : json["currency_name"],
    currencyType: json["currency_type"] == null ? null : currencyTypeValues.map![json["currency_type"]],
    depositStatus: json["deposit_status"] == null ? null : statusValues.map![json["deposit_status"]],
    withdrawStatus: json["withdraw_status"] == null ? null : statusValues.map![json["withdraw_status"]],
    tradeStatus: json["trade_status"] == null ? null : statusValues.map![json["trade_status"]],
    stakeBalance: json["stake_balance"] == null ? null : json["stake_balance"],
    availableBalance: json["available_balance"] == null ? null : json["available_balance"],
    inorderBalance: json["inorder_balance"] == null ? null : json["inorder_balance"],
    mlmStakeBalance: json["mlm_stakeBalance"]?.toDouble(),
    totalBalance: json["total_balance"] == null ? null : json["total_balance"],
    btcValue: json["BTCValue"] == null ? null : json["BTCValue"],
    usdValue: json["USDValue"] == null ? null : json["USDValue"],
    defaultCryptoValue: json["defaultCryptoValue"] == null ? null : json["defaultCryptoValue"],
    status: json["status"] == null ? null : statusValues.map![json["status"]],
    typename: json["__typename"] == null ? null : typenameValues.map![json["__typename"]],
  );

  Map<String, dynamic> toJson() => {
    "image": image == null ? null : image,
    "currency_code": currencyCode == null ? null : currencyCode,
    "currency_name": currencyName == null ? null : currencyName,
    "currency_type": currencyType == null ? null : currencyTypeValues.reverse[currencyType],
    "deposit_status": depositStatus == null ? null : statusValues.reverse[depositStatus],
    "withdraw_status": withdrawStatus == null ? null : statusValues.reverse[withdrawStatus],
    "trade_status": tradeStatus == null ? null : statusValues.reverse[tradeStatus],
    "stake_balance": stakeBalance == null ? null : stakeBalance,
    "available_balance": availableBalance == null ? null : availableBalance,
    "inorder_balance": inorderBalance == null ? null : inorderBalance,
    "mlm_stakeBalance": mlmStakeBalance,
    "total_balance": totalBalance == null ? null : totalBalance,
    "BTCValue": btcValue == null ? null : btcValue,
    "USDValue": usdValue == null ? null : usdValue,
    "defaultCryptoValue": defaultCryptoValue == null ? null : defaultCryptoValue,
    "status": status == null ? null : statusValues.reverse[status],
    "__typename": typename == null ? null : typenameValues.reverse[typename],
  };
}

enum CurrencyType { FIAT, CRYPTO }

final currencyTypeValues = EnumValues({
  "crypto": CurrencyType.CRYPTO,
  "fiat": CurrencyType.FIAT
});

enum Status { ACTIVE, IN_ACTIVE }

final statusValues = EnumValues({
  "Active": Status.ACTIVE,
  "InActive": Status.IN_ACTIVE
});

enum Typename { BALANCE_RESPONSE }

final typenameValues = EnumValues({
  "BalanceResponse": Typename.BALANCE_RESPONSE
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap ?? Map();
  }
}

DashBoardBalance dummyDashboard = DashBoardBalance(
  availableBalance: 0.0,
    btcValue: 0.0,
  currencyCode: "",
  currencyName: "",
  defaultCryptoValue: 0,
  inorderBalance: 0,
  totalBalance: 0,
  usdValue: 0

);
