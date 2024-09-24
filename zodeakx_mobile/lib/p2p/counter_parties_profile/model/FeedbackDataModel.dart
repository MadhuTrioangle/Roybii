import 'dart:convert';

class FeedbackDataModel {
  FeedbackDataModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  int? statusCode;
  String? statusMessage;
  FeedbackData? result;
  String? typename;

  factory FeedbackDataModel.fromRawJson(String str) => FeedbackDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackDataModel.fromJson(Map<String, dynamic> json) => FeedbackDataModel(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : FeedbackData.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class FeedbackData {
  FeedbackData({
    this.page,
    this.pages,
    this.total,
    this.data,
    this.typename,
  });

  int? page;
  int? pages;
  int? total;
  List<Feedbacks>? data;
  String? typename;

  factory FeedbackData.fromRawJson(String str) => FeedbackData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackData.fromJson(Map<String, dynamic> json) => FeedbackData(
    page: json["page"],
    pages: json["pages"],
    total: json["total"],
    data: json["data"] == null ? [] : List<Feedbacks>.from(json["data"]!.map((x) => Feedbacks.fromJson(x))),
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

class Feedbacks {
  Feedbacks({
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

  factory Feedbacks.fromRawJson(String str) => Feedbacks.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Feedbacks.fromJson(Map<String, dynamic> json) => Feedbacks(
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
