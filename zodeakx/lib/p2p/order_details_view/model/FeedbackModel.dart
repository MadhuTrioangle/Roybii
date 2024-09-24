import 'dart:convert';

class FeedbackModel {
  FeedbackModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  P2PFeedback? result;
  String? typename;

  factory FeedbackModel.fromRawJson(String str) => FeedbackModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : P2PFeedback.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class P2PFeedback {
  P2PFeedback({
    this.page,
    this.pages,
    this.total,
    this.data,
    this.typename,
  });

  int? page;
  int? pages;
  int? total;
  List<FeedbackData>? data;
  String? typename;

  factory P2PFeedback.fromRawJson(String str) => P2PFeedback.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory P2PFeedback.fromJson(Map<String, dynamic> json) => P2PFeedback(
    page: json["page"],
    pages: json["pages"],
    total: json["total"],
    data: json["data"] == null ? [] : List<FeedbackData>.from(json["data"]!.map((x) => FeedbackData.fromJson(x))),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "pages": pages,
    "total": total,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "__typename": typename,
  };
}

class FeedbackData {
  FeedbackData({
    this.id,
    this.userId,
    this.feedback,
    this.feedbackType,
    this.createdDate,
    this.modifiedDate,
    this.name,
    this.paymentMethod,
    this.typename,
  });

  String? id;
  String? userId;
  String? feedback;
  String? feedbackType;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? name;
  String? paymentMethod;
  String? typename;

  factory FeedbackData.fromRawJson(String str) => FeedbackData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackData.fromJson(Map<String, dynamic> json) => FeedbackData(
    id: json["_id"],
    userId: json["user_id"],
    feedback: json["feedback"],
    feedbackType: json["feedback_type"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    name: json["name"],
    paymentMethod: json["payment_method"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "feedback": feedback,
    "feedback_type": feedbackType,
    "created_date": createdDate?.toIso8601String(),
    "modified_date": modifiedDate?.toIso8601String(),
    "name": name,
    "payment_method": paymentMethod,
    "__typename": typename,
  };
}
