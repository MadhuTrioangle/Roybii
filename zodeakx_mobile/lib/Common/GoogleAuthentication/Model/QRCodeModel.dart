// To parse this JSON data, do
//
//     final getTfaSecret = getTfaSecretFromJson(jsonString);

import 'dart:convert';

class GetTfaSecret {
  GetTfaSecret({
    this.gettfa,
  });

  Gettfa? gettfa;

  factory GetTfaSecret.fromRawJson(String str) => GetTfaSecret.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTfaSecret.fromJson(Map<String, dynamic> json) => GetTfaSecret(
    gettfa: json["gettfa"] == null ? null : Gettfa.fromJson(json["gettfa"]),
  );

  Map<String, dynamic> toJson() => {
    "gettfa": gettfa == null ? null : gettfa?.toJson(),
  };
}

class Gettfa {
  Gettfa({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  GetTFA? result;
  String? typename;

  factory Gettfa.fromRawJson(String str) => Gettfa.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Gettfa.fromJson(Map<String, dynamic> json) => Gettfa(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : GetTFA.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class GetTFA {
  GetTFA({
    this.secret,
    this.url,
    this.typename,
  });

  String? secret;
  String? url;
  String? typename;

  factory GetTFA.fromRawJson(String str) => GetTFA.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetTFA.fromJson(Map<String, dynamic> json) => GetTFA(
    secret: json["secret"] == null ? null : json["secret"],
    url: json["url"] == null ? null : json["url"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "secret": secret == null ? null : secret,
    "url": url == null ? null : url,
    "__typename": typename == null ? null : typename,
  };
}
