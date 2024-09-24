

import 'dart:convert';

class GetActivityModel {
  GetActivityModel({
    this.getActivity,
  });

  GetActivity ?getActivity;

  factory GetActivityModel.fromRawJson(String str) => GetActivityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetActivityModel.fromJson(Map<String, dynamic> json) => GetActivityModel(
    getActivity: json["getActivity"] == null ? null : GetActivity.fromJson(json["getActivity"]),
  );

  Map<String, dynamic> toJson() => {
    "getActivity": getActivity == null ? null : getActivity!.toJson(),
  };
}

class GetActivity {
  GetActivity({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int ?statusCode;
  String? statusMessage;
  List<TimeAndIp>? result;
  String ?typename;

  factory GetActivity.fromRawJson(String str) => GetActivity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetActivity.fromJson(Map<String, dynamic> json) => GetActivity(
    statusCode: json["status_code"] == null ? null : json["status_code"],
    statusMessage: json["status_message"] == null ? null : json["status_message"],
    result: json["result"] == null ? null : List<TimeAndIp>.from(json["result"].map((x) => TimeAndIp.fromJson(x))),
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode == null ? null : statusCode,
    "status_message": statusMessage == null ? null : statusMessage,
    "result": result == null ? null : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename == null ? null : typename,
  };
}

class TimeAndIp {
  TimeAndIp({
    this.source,
    this.device,
    this.ip,
    this.location,
    this.platform,
    this.browser,
    this.os,
    this.typename,
    this.createdDate
  });

  String? source;
  String ?device;
  String ?ip;
  String ?location;
  String ?platform;
  String ?browser;
  String ?os;
  String ?typename;
  String ?createdDate;

  factory TimeAndIp.fromRawJson(String str) => TimeAndIp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeAndIp.fromJson(Map<String, dynamic> json) => TimeAndIp(
    source: json["source"] == null ? null : json["source"],
    device: json["device"] == null ? null : json["device"],
    ip: json["ip"] == null ? null : json["ip"],
    createdDate: json["created_date"] == null ? null : json["created_date"],
    location: json["location"] == null ? null : json["location"],
    platform: json["platform"] == null ? null : json["platform"],
    browser: json["browser"] == null ? null : json["browser"],
    os: json["os"] == null ? null : json["os"],
    typename: json["__typename"] == null ? null : json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "source": source == null ? null : source,
    "device": device == null ? null : device,
    "ip": ip == null ? null : ip,
    "created_date": createdDate == null ? null : createdDate,
    "location": location == null ? null : location,
    "platform": platform == null ? null : platform,
    "browser": browser == null ? null : browser,
    "os": os == null ? null : os,
    "__typename": typename == null ? null : typename,
  };
}
