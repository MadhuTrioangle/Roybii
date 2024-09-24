// To parse this JSON data, do
//
//     final favPairModel = favPairModelFromJson(jsonString);

import 'dart:convert';

class FavPairModel {
  int? statusCode;
  String? statusMessage;
  List<FavPair>? result;
  String? typename;

  FavPairModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory FavPairModel.fromRawJson(String str) =>
      FavPairModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavPairModel.fromJson(Map<String, dynamic> json) => FavPairModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null
            ? []
            : List<FavPair>.from(
                json["result"]!.map((x) => FavPair.fromJson(x))),
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

class FavPair {
  String? pair;
  bool? isfav;
  String? typename;

  FavPair({
    this.pair,
    this.isfav,
    this.typename,
  });

  factory FavPair.fromRawJson(String str) => FavPair.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavPair.fromJson(Map<String, dynamic> json) => FavPair(
        pair: json["pair"],
        isfav: json["isfav"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "pair": pair,
        "isfav": isfav,
        "__typename": typename,
      };
}
