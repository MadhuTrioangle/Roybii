import 'dart:convert';

class UserCenterModel {
  UserCenterModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  UserCenter? result;
  String? typename;

  factory UserCenterModel.fromRawJson(String str) =>
      UserCenterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserCenterModel.fromJson(Map<String, dynamic> json) =>
      UserCenterModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result:
            json["result"] == null ? null : UserCenter.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class UserCenter {
  UserCenter({
    this.name,
    this.kycStatus,
    this.emailStatus,
    this.joinDate,
    this.avgPaymentTime,
    this.avgReleaseTime,
    this.totalOrders,
    this.sellOrder,
    this.buyOrder,
    this.last30DayTrade,
    this.completionRate,
    this.positiveFeedback,
    this.negative,
    this.positive,
    this.registered,
    this.firstTrade,
    this.typename,
  });

  String? name;
  String? kycStatus;
  String? emailStatus;
  DateTime? joinDate;
  num? avgPaymentTime;
  int? avgReleaseTime;
  int? totalOrders;
  int? sellOrder;
  int? buyOrder;
  int? last30DayTrade;
  num? completionRate;
  num? positiveFeedback;
  int? negative;
  int? positive;
  int? registered;
  int? firstTrade;
  String? typename;

  factory UserCenter.fromRawJson(String str) =>
      UserCenter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserCenter.fromJson(Map<String, dynamic> json) => UserCenter(
        name: json["name"],
        kycStatus: json["kyc_status"],
        emailStatus: json["email_status"],
        joinDate: json["join_date"] == null
            ? null
            : DateTime.parse(json["join_date"]),
        avgPaymentTime: json["avg_payment_time"],
        avgReleaseTime: json["avg_release_time"],
        totalOrders: json["totalOrders"],
        sellOrder: json["sell_order"],
        buyOrder: json["buy_order"],
        last30DayTrade: json["last30DayTrade"],
        completionRate: json["completion_rate"],
        positiveFeedback: json["positive_feedback"],
        negative: json["negative"],
        positive: json["positive"],
        registered: json["registered"],
        firstTrade: json["first_trade"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "kyc_status": kycStatus,
        "email_status": emailStatus,
        "join_date": joinDate?.toIso8601String(),
        "avg_payment_time": avgPaymentTime,
        "avg_release_time": avgReleaseTime,
        "totalOrders": totalOrders,
        "sell_order": sellOrder,
        "buy_order": buyOrder,
        "last30DayTrade": last30DayTrade,
        "completion_rate": completionRate,
        "positive_feedback": positiveFeedback,
        "negative": negative,
        "positive": positive,
        "registered": registered,
        "first_trade": firstTrade,
        "__typename": typename,
      };
}
