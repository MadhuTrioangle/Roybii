import 'dart:convert';

class HighestPriceModel {
  HighestPriceModel({
    this.statusCode,
    this.result,
    this.typename,
  });

  int? statusCode;
  double? result;
  String? typename;

  factory HighestPriceModel.fromRawJson(String str) => HighestPriceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HighestPriceModel.fromJson(Map<String, dynamic> json) => HighestPriceModel(
    statusCode: json["status_code"],
    result: json["result"]?.toDouble(),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "result": result,
    "__typename": typename,
  };
}
