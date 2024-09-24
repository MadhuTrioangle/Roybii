import 'dart:convert';

class OrderBooksModel {
  OrderBooksModel({
    this.stream,
    this.data,
  });

  String? stream;
  OrderBooks? data;

  factory OrderBooksModel.fromRawJson(String str) =>
      OrderBooksModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderBooksModel.fromJson(Map<String, dynamic> json) =>
      OrderBooksModel(
        stream: json["stream"],
        data: json["data"] == null ? null : OrderBooks.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "stream": stream,
        "data": data?.toJson(),
      };
}

class OrderBooks {
  OrderBooks({
    this.dataE,
    this.e,
    this.s,
    this.u,
    this.dataU,
    this.b,
    this.a,
  });

  String? dataE;
  int? e;
  String? s;
  int? u;
  int? dataU;
  List<List<dynamic>>? b;
  List<List<dynamic>>? a;

  factory OrderBooks.fromRawJson(String str) =>
      OrderBooks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderBooks.fromJson(Map<String, dynamic> json) => OrderBooks(
        dataE: json["e"],
        e: json["E"],
        s: json["s"],
        u: json["U"],
        dataU: json["u"],
        b: json["b"] == null
            ? []
            : List<List<String>>.from(
                json["b"]!.map((x) => List<String>.from(x.map((x) => x)))),
        a: json["a"] == null
            ? []
            : List<List<String>>.from(
                json["a"]!.map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "e": dataE,
        "E": e,
        "s": s,
        "U": u,
        "u": dataU,
        "b": b == null
            ? []
            : List<dynamic>.from(
                b!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "a": a == null
            ? []
            : List<dynamic>.from(
                a!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
