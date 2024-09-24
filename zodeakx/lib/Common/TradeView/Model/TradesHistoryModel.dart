import 'dart:convert';

class TradeHistoryModel {
  TradeHistoryModel({
    this.stream,
    this.data,
  });

  String? stream;
  TradeHistory? data;

  factory TradeHistoryModel.fromRawJson(String str) => TradeHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeHistoryModel.fromJson(Map<String, dynamic> json) => TradeHistoryModel(
    stream: json["stream"],
    data: json["data"] == null ? null : TradeHistory.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "stream": stream,
    "data": data?.toJson(),
  };
}

class TradeHistory {
  TradeHistory({
    this.dataE,
    this.e,
    this.s,
    this.dataT,
    this.p,
    this.q,
    this.b,
    this.a,
    this.t,
    this.dataM,
    this.m,
  });

  String? dataE;
  int? e;
  String? s;
  int? dataT;
  String? p;
  String? q;
  int? b;
  int? a;
  int? t;
  bool? dataM;
  bool? m;

  factory TradeHistory.fromRawJson(String str) => TradeHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradeHistory.fromJson(Map<String, dynamic> json) => TradeHistory(
    dataE: json["e"],
    e: json["E"],
    s: json["s"],
    dataT: json["t"],
    p: json["p"],
    q: json["q"],
    b: json["b"],
    a: json["a"],
    t: json["T"],
    dataM: json["m"],
    m: json["M"],
  );

  Map<String, dynamic> toJson() => {
    "e": dataE,
    "E": e,
    "s": s,
    "t": dataT,
    "p": p,
    "q": q,
    "b": b,
    "a": a,
    "T": t,
    "m": dataM,
    "M": m,
  };
}
