class TradePairModel {
  TradePairModel({
    required this.stream,
    required this.data,
  });
  late final String stream;
  late final TradePair data;

  TradePairModel.fromJson(Map<String, dynamic> json){
    stream = json['stream'];
    data = TradePair.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['stream'] = stream;
    _data['data'] = data.toJson();
    return _data;
  }
}

class TradePair {
  TradePair({
    required this.e,
    required this.E,
    required this.s,
    required this.p,
    required this.P,
    required this.w,
    required this.x,
    required this.c,
    required this.Q,
    required this.b,
    required this.B,
    required this.a,
    required this.A,
    required this.o,
    required this.h,
    required this.l,
    required this.v,
    required this.q,
    required this.O,
    required this.C,
    required this.F,
    required this.L,
    required this.n,
  });
  late final String e;
  late final int E;
  late final String s;
  late final String p;
  late final String P;
  late final String w;
  late final String x;
  late final String c;
  late final String Q;
  late final String b;
  late final String B;
  late final String a;
  late final String A;
  late final String o;
  late final String h;
  late final String l;
  late final String v;
  late final String q;
  late final int O;
  late final int C;
  late final int F;
  late final int L;
  late final int n;

  TradePair.fromJson(Map<String, dynamic> json){
    e = json['e'];
    E = json['E'];
    s = json['s'];
    p = json['p'];
    P = json['P'];
    w = json['w'];
    x = json['x'];
    c = json['c'];
    Q = json['Q'];
    b = json['b'];
    B = json['B'];
    a = json['a'];
    A = json['A'];
    o = json['o'];
    h = json['h'];
    l = json['l'];
    v = json['v'];
    q = json['q'];
    O = json['O'];
    C = json['C'];
    F = json['F'];
    L = json['L'];
    n = json['n'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['e'] = e;
    _data['E'] = E;
    _data['s'] = s;
    _data['p'] = p;
    _data['P'] = P;
    _data['w'] = w;
    _data['x'] = x;
    _data['c'] = c;
    _data['Q'] = Q;
    _data['b'] = b;
    _data['B'] = B;
    _data['a'] = a;
    _data['A'] = A;
    _data['o'] = o;
    _data['h'] = h;
    _data['l'] = l;
    _data['v'] = v;
    _data['q'] = q;
    _data['O'] = O;
    _data['C'] = C;
    _data['F'] = F;
    _data['L'] = L;
    _data['n'] = n;
    return _data;
  }
}