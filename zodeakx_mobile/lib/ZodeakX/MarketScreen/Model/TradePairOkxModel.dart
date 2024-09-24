import 'dart:convert';

class TradePairOkxModel {
  Arg? arg;
  List<OkxTradePairs>? data;

  TradePairOkxModel({
    this.arg,
    this.data,
  });

  factory TradePairOkxModel.fromRawJson(String str) => TradePairOkxModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TradePairOkxModel.fromJson(Map<String, dynamic> json) => TradePairOkxModel(
    arg: json["arg"] == null ? null : Arg.fromJson(json["arg"]),
    data: json["data"] == null ? [] : List<OkxTradePairs>.from(json["data"]!.map((x) => OkxTradePairs.fromJson(x))),
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

class OkxTradePairs {
  String? instType;
  String? instId;
  String? last;
  String? lastSz;
  String? askPx;
  String? askSz;
  String? bidPx;
  String? bidSz;
  String? open24H;
  String? high24H;
  String? low24H;
  String? sodUtc0;
  String? sodUtc8;
  String? volCcy24H;
  String? vol24H;
  String? ts;

  OkxTradePairs({
    this.instType,
    this.instId,
    this.last,
    this.lastSz,
    this.askPx,
    this.askSz,
    this.bidPx,
    this.bidSz,
    this.open24H,
    this.high24H,
    this.low24H,
    this.sodUtc0,
    this.sodUtc8,
    this.volCcy24H,
    this.vol24H,
    this.ts,
  });

  factory OkxTradePairs.fromRawJson(String str) => OkxTradePairs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OkxTradePairs.fromJson(Map<String, dynamic> json) => OkxTradePairs(
    instType: json["instType"],
    instId: json["instId"],
    last: json["last"],
    lastSz: json["lastSz"],
    askPx: json["askPx"],
    askSz: json["askSz"],
    bidPx: json["bidPx"],
    bidSz: json["bidSz"],
    open24H: json["open24h"],
    high24H: json["high24h"],
    low24H: json["low24h"],
    sodUtc0: json["sodUtc0"],
    sodUtc8: json["sodUtc8"],
    volCcy24H: json["volCcy24h"],
    vol24H: json["vol24h"],
    ts: json["ts"],
  );

  Map<String, dynamic> toJson() => {
    "instType": instType,
    "instId": instId,
    "last": last,
    "lastSz": lastSz,
    "askPx": askPx,
    "askSz": askSz,
    "bidPx": bidPx,
    "bidSz": bidSz,
    "open24h": open24H,
    "high24h": high24H,
    "low24h": low24H,
    "sodUtc0": sodUtc0,
    "sodUtc8": sodUtc8,
    "volCcy24h": volCcy24H,
    "vol24h": vol24H,
    "ts": ts,
  };
}
