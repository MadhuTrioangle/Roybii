import 'dart:convert';

class MessageHistoryModel {
  MessageHistoryModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  List<MessageHistory>? result;
  String? typename;

  factory MessageHistoryModel.fromRawJson(String str) => MessageHistoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageHistoryModel.fromJson(Map<String, dynamic> json) => MessageHistoryModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? [] : List<MessageHistory>.from(json["result"]!.map((x) => MessageHistory.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class MessageHistory {
  MessageHistory({
    this.userId,
    this.conversationId,
    this.adminId,
    this.message,
    this.image,
    this.createdDate,
    this.typename,
  });

  String? userId;
  String? conversationId;
  String? adminId;
  String? message;
  String? image;
  DateTime? createdDate;
  String? typename;
  bool sending = false;
  bool sendingFailed = false;

  factory MessageHistory.fromRawJson(String str) => MessageHistory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageHistory.fromJson(Map<String, dynamic> json) => MessageHistory(
    userId: json["user_id"],
    conversationId: json["conversation_id"],
    adminId: json["admin_id"],
    message: json["message"],
    image: json["image"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "conversation_id": conversationId,
    "admin_id": adminId,
    "message": message,
    "image": image,
    "created_date": createdDate?.toIso8601String(),
    "__typename": typename,
  };
}
