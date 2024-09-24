// To parse this JSON data, do
//
//     final getOpenOrders = getOpenOrdersFromJson(jsonString);

import 'dart:convert';

class GetOpenOrders {
  GetOpenOrders({
    this.statusCode,
    this.statusMessage,
    this.result,
  });

  int? statusCode;
  String? statusMessage;
  OpenOrders? result;

  factory GetOpenOrders.fromRawJson(String str) =>
      GetOpenOrders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetOpenOrders.fromJson(Map<String, dynamic> json) => GetOpenOrders(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        statusMessage:
            json["status_message"] == null ? null : json["status_message"],
        result: json["result"] == null ? null : OpenOrders.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "status_message": statusMessage == null ? null : statusMessage,
        "result": result == null ? null : result?.toJson(),
      };
}

class OpenOrders {
  OpenOrders({
    this.bids,
    this.asks,
  });

  List<List<dynamic>>? bids;
  List<List<dynamic>>? asks;

  factory OpenOrders.fromRawJson(String str) => OpenOrders.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OpenOrders.fromJson(Map<String, dynamic> json) => OpenOrders(
        bids: json["bids"] == null
            ? null
            : List<List<dynamic>>.from(
                json["bids"].map((x) => List<dynamic>.from(x.map((x) => x)))),
        asks: json["asks"] == null
            ? null
            : List<List<dynamic>>.from(
                json["asks"].map((x) => List<dynamic>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "bids": bids == null
            ? null
            : List<dynamic>.from(
                bids!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "asks": asks == null
            ? null
            : List<dynamic>.from(
                asks!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
