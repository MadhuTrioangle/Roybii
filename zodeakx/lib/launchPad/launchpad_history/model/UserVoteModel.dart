import 'dart:convert';

class UserVoteModel {
  int? statusCode;
  String? statusMessage;
  UserVote? result;
  String? typename;

  UserVoteModel({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory UserVoteModel.fromRawJson(String str) =>
      UserVoteModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserVoteModel.fromJson(Map<String, dynamic> json) => UserVoteModel(
        statusCode: json["status_code"],
        statusMessage: json["status_message"],
        result:
            json["result"] == null ? null : UserVote.fromJson(json["result"]),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "status_message": statusMessage,
        "result": result?.toJson(),
        "__typename": typename,
      };
}

class UserVote {
  List<Count>? count;
  List<VoteData>? data;
  String? typename;

  UserVote({
    this.count,
    this.data,
    this.typename,
  });

  factory UserVote.fromRawJson(String str) =>
      UserVote.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserVote.fromJson(Map<String, dynamic> json) => UserVote(
        count: json["count"] == null
            ? []
            : List<Count>.from(json["count"]!.map((x) => Count.fromJson(x))),
        data: json["data"] == null
            ? []
            : List<VoteData>.from(json["data"]!.map((x) => VoteData.fromJson(x))),
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "count": count == null
            ? []
            : List<dynamic>.from(count!.map((x) => x.toJson())),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "__typename": typename,
      };
}

class Count {
  int? total;
  int? page;
  int? pages;
  int? limit;
  String? typename;

  Count({
    this.total,
    this.page,
    this.pages,
    this.limit,
    this.typename,
  });

  factory Count.fromRawJson(String str) => Count.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        total: json["total"],
        page: json["page"],
        pages: json["pages"],
        limit: json["limit"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "pages": pages,
        "limit": limit,
        "__typename": typename,
      };
}

class VoteData {
  int? noOfVotes;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? projectName;
  String? currency;
  String? typename;

  VoteData({
    this.noOfVotes,
    this.createdAt,
    this.updatedAt,
    this.projectName,
    this.currency,
    this.typename,
  });

  factory VoteData.fromRawJson(String str) => VoteData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VoteData.fromJson(Map<String, dynamic> json) => VoteData(
        noOfVotes: json["noOfVotes"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        projectName: json["project_name"],
        currency: json["currency"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "noOfVotes": noOfVotes,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "project_name": projectName,
        "currency": currency,
        "__typename": typename,
      };
}
