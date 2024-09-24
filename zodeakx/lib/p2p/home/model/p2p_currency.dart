import 'dart:convert';

class P2PCurrencyModel {
  P2PCurrencyModel({
    this.statusCode,
    this.result,
    this.typename,
  });

  int? statusCode;
  List<P2PCurrency>? result;
  String? typename;

  factory P2PCurrencyModel.fromRawJson(String str) =>
      P2PCurrencyModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory P2PCurrencyModel.fromJson(Map<String, dynamic> json) =>
      P2PCurrencyModel(
        statusCode: json["status_code"],
        result: json["result"] == null
            ? []
            : List<P2PCurrency>.from(
                json["result"]!.map((x) => P2PCurrency.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class P2PCurrency {
  P2PCurrency({
    this.image,
    this.type,
    this.code,
    this.status,
    this.p2PStatus,
    this.minAdLimit,
    this.maxAdLimit,
    this.p2PMakerFee,
    this.typename,
  });

  String? image;
  String? type;
  String? code;
  String? status;
  String? p2PStatus;
  double? minAdLimit;
  double? maxAdLimit;
  double? p2PMakerFee;
  String? typename;

  factory P2PCurrency.fromRawJson(String str) =>
      P2PCurrency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory P2PCurrency.fromJson(Map<String, dynamic> json) => P2PCurrency(
        image: json["image"],
        type: json["type"],
        code: json["code"],
        status: json["status"],
        p2PStatus: json["p2p_status"],
        minAdLimit: json["min_ad_limit"]?.toDouble(),
        maxAdLimit: json["max_ad_limit"]?.toDouble(),
        p2PMakerFee: json["p2p_maker_fee"]?.toDouble(),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "type": type,
        "code": code,
        "status": status,
        "p2p_status": p2PStatus,
        "min_ad_limit": minAdLimit,
        "max_ad_limit": maxAdLimit,
        "p2p_maker_fee": p2PMakerFee,
        "__typename": typename,
      };
}
