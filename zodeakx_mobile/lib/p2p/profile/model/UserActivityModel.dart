import 'dart:convert';

class UserActivityModel {
  UserActivityModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<UserActivity>? result;
  String? typename;

  factory UserActivityModel.fromRawJson(String str) => UserActivityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserActivityModel.fromJson(Map<String, dynamic> json) => UserActivityModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<UserActivity>.from(json["result"]!.map((x) => UserActivity.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class UserActivity {
  UserActivity({
    this.userId,
    this.createdDate,
    this.modifiedDate,
    this.typename,
  });

  String? userId;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? typename;

  factory UserActivity.fromRawJson(String str) => UserActivity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserActivity.fromJson(Map<String, dynamic> json) => UserActivity(
    userId: json["user_id"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "created_date": createdDate?.toIso8601String(),
    "modified_date": modifiedDate?.toIso8601String(),
    "__typename": typename,
  };
}
