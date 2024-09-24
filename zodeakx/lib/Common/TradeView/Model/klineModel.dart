import 'dart:convert';

class KlinesData {
    int? statusCode;
    String? statusMessage;
    List<List<String>>? result;

    KlinesData({
        this.statusCode,
        this.statusMessage,
        this.result,
    });

    factory KlinesData.fromRawJson(String str) => KlinesData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory KlinesData.fromJson(Map<String, dynamic> json) => KlinesData(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result: json["result"] == null ? [] : List<List<String>>.from(json["result"]!.map((x) => List<String>.from(x.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}

class KlinesDataBinance {
    String? stream;
    Data? data;

    KlinesDataBinance({
        this.stream,
        this.data,
    });

    factory KlinesDataBinance.fromRawJson(String str) => KlinesDataBinance.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory KlinesDataBinance.fromJson(Map<String, dynamic> json) => KlinesDataBinance(
        stream: json["stream"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "stream": stream,
        "data": data?.toJson(),
    };
}

class Data {
    String? dataE;
    int? e;
    String? s;
    K? k;

    Data({
        this.dataE,
        this.e,
        this.s,
        this.k,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dataE: json["e"],
        e: json["E"],
        s: json["s"],
        k: json["k"] == null ? null : K.fromJson(json["k"]),
    );

    Map<String, dynamic> toJson() => {
        "e": dataE,
        "E": e,
        "s": s,
        "k": k?.toJson(),
    };
}

class K {
    int? kT;
    int? t;
    String? s;
    String? i;
    int? f;
    int? l;
    String? o;
    String? c;
    String? h;
    String? kL;
    String? kV;
    int? n;
    bool? x;
    String? kQ;
    String? v;
    String? q;
    String? b;

    K({
        this.kT,
        this.t,
        this.s,
        this.i,
        this.f,
        this.l,
        this.o,
        this.c,
        this.h,
        this.kL,
        this.kV,
        this.n,
        this.x,
        this.kQ,
        this.v,
        this.q,
        this.b,
    });

    factory K.fromRawJson(String str) => K.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory K.fromJson(Map<String, dynamic> json) => K(
        kT: json["t"],
        t: json["T"],
        s: json["s"],
        i: json["i"],
        f: json["f"],
        l: json["L"],
        o: json["o"],
        c: json["c"],
        h: json["h"],
        kL: json["l"],
        kV: json["v"],
        n: json["n"],
        x: json["x"],
        kQ: json["q"],
        v: json["V"],
        q: json["Q"],
        b: json["B"],
    );

    Map<String, dynamic> toJson() => {
        "t": kT,
        "T": t,
        "s": s,
        "i": i,
        "f": f,
        "L": l,
        "o": o,
        "c": c,
        "h": h,
        "l": kL,
        "v": kV,
        "n": n,
        "x": x,
        "q": kQ,
        "V": v,
        "Q": q,
        "B": b,
    };
}

class KlineFormat {
    String? time;
    String? high;
    String? low;
    String? open;
    String? close;
    String? volume;

    KlineFormat({
        this.time,
        this.high,
        this.low,
        this.open,
        this.close,
        this.volume,
    });

    factory KlineFormat.fromRawJson(String str) => KlineFormat.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory KlineFormat.fromJson(Map<String, dynamic> json) => KlineFormat(
        time: json["time"],
        high: json["high"],
        low: json["low"],
        open: json["open"],
        close: json["close"],
        volume: json["volume"],
    );

    Map<String, dynamic> toJson() => {
        "time": time,
        "high": high,
        "low": low,
        "open": open,
        "close": close,
        "volume": volume,
    };
}
