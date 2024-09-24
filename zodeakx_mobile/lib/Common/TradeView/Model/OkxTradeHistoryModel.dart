import 'dart:convert';

class OkxTradeHistoryModel {
  Arg? arg;
  List<OkxTradeHistory>? data;

  OkxTradeHistoryModel({
    this.arg,
    this.data,
  });

  factory OkxTradeHistoryModel.fromRawJson(String str) => OkxTradeHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OkxTradeHistoryModel.fromJson(Map<String, dynamic> json) => OkxTradeHistoryModel(
    arg: json["arg"] == null ? null : Arg.fromJson(json["arg"]),
    data: json["data"] == null ? [] : List<OkxTradeHistory>.from(json["data"]!.map((x) => OkxTradeHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "arg": arg?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Arg {
  String? channel;
  String? instId;

  Arg({
    this.channel,
    this.instId,
  });

  factory Arg.fromRawJson(String str) => Arg.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Arg.fromJson(Map<String, dynamic> json) => Arg(
    channel: json["channel"],
    instId: json["instId"],
  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "instId": instId,
  };
}

class OkxTradeHistory {
  String? instId;
  String? tradeId;
  String? px;
  String? sz;
  String? side;
  String? ts;
  String? count;

  OkxTradeHistory({
    this.instId,
    this.tradeId,
    this.px,
    this.sz,
    this.side,
    this.ts,
    this.count,
  });

  factory OkxTradeHistory.fromRawJson(String str) => OkxTradeHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OkxTradeHistory.fromJson(Map<String, dynamic> json) => OkxTradeHistory(
    instId: json["instId"],
    tradeId: json["tradeId"],
    px: json["px"],
    sz: json["sz"],
    side: json["side"],
    ts: json["ts"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "instId": instId,
    "tradeId": tradeId,
    "px": px,
    "sz": sz,
    "side": side,
    "ts": ts,
    "count": count,
  };
}
