

import 'dart:convert';

class VerifyTfa {
  VerifyTfa({
    this.verifytfa,
  });

  Verifytfa? verifytfa;

  factory VerifyTfa.fromRawJson(String str) => VerifyTfa.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyTfa.fromJson(Map<String, dynamic> json) => VerifyTfa(
    verifytfa: json["verifytfa"] == null ? null : Verifytfa.fromJson(json["verifytfa"]),
  );

  Map<String, dynamic> toJson() => {
    "verifytfa": verifytfa == null ? null : verifytfa?.toJson(),
  };
}

class Verifytfa {
  Verifytfa({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  VerifyTfaWithPassword? result;
  String? typename;

  factory Verifytfa.fromRawJson(String str) => Verifytfa.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Verifytfa.fromJson(Map<String, dynamic> json) => Verifytfa(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : VerifyTfaWithPassword.fromJson(json["result"]),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : result?.toJson(),
    "__typename": typename == null ? null : typename,
  };
}

class VerifyTfaWithPassword {
  VerifyTfaWithPassword({
    this.buttonvalue,
    this.typename,
  });

  String? buttonvalue;
  String? typename;

  factory VerifyTfaWithPassword.fromRawJson(String str) => VerifyTfaWithPassword.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyTfaWithPassword.fromJson(Map<String, dynamic> json) => VerifyTfaWithPassword(
    buttonvalue: json["buttonvalue"] == null ? null : json["buttonvalue"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "buttonvalue": buttonvalue == null ? null : buttonvalue,
    "__typename": typename == null ? null : typename,
  };
}
