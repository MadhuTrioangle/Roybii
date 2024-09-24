import 'dart:convert';

class OkxOrderBookModel {
  Arg? arg;
  String? action;
  List<OkxOrderBook>? data;

  OkxOrderBookModel({
    this.arg,
    this.action,
    this.data,
  });

  factory OkxOrderBookModel.fromRawJson(String str) => OkxOrderBookModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OkxOrderBookModel.fromJson(Map<String, dynamic> json) => OkxOrderBookModel(
    arg: json["arg"] == null ? null : Arg.fromJson(json["arg"]),
    action: json["action"],
    data: json["data"] == null ? [] : List<OkxOrderBook>.from(json["data"]!.map((x) => OkxOrderBook.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "arg": arg?.toJson(),
    "action": action,
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

class OkxOrderBook {
  List<List<String>>? asks;
  List<List<String>>? bids;
  String? ts;
  int? checksum;
  int? seqId;
  int? prevSeqId;

  OkxOrderBook({
    this.asks,
    this.bids,
    this.ts,
    this.checksum,
    this.seqId,
    this.prevSeqId,
  });

  factory OkxOrderBook.fromRawJson(String str) => OkxOrderBook.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OkxOrderBook.fromJson(Map<String, dynamic> json) => OkxOrderBook(
    asks: json["asks"] == null ? [] : List<List<String>>.from(json["asks"]!.map((x) => List<String>.from(x.map((x) => x)))),
    bids: json["bids"] == null ? [] : List<List<String>>.from(json["bids"]!.map((x) => List<String>.from(x.map((x) => x)))),
    ts: json["ts"],
    checksum: json["checksum"],
    seqId: json["seqId"],
    prevSeqId: json["prevSeqId"],
  );

  Map<String, dynamic> toJson() => {
    "asks": asks == null ? [] : List<dynamic>.from(asks!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "bids": bids == null ? [] : List<dynamic>.from(bids!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "ts": ts,
    "checksum": checksum,
    "seqId": seqId,
    "prevSeqId": prevSeqId,
  };
}
