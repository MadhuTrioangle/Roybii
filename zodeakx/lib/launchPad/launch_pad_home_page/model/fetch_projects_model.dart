

import 'dart:convert';

class FetchProjects {
  int? statusCode;
  String? statusMessage;
  Result? result;
  String? typename;

  FetchProjects({
    this.statusCode,
    this.statusMessage,
    this.result,
    this.typename,
  });

  factory FetchProjects.fromRawJson(String str) => FetchProjects.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FetchProjects.fromJson(Map<String, dynamic> json) => FetchProjects(
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "status_message": statusMessage,
    "result": result?.toJson(),
    "__typename": typename,
  };
}

class Result {
  List<Datum>? data;
  int? total;
  int? limit;
  int? page;
  int? pages;
  String? typename;

  Result({
    this.data,
    this.total,
    this.limit,
    this.page,
    this.pages,
    this.typename,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    total: json["total"],
    limit: json["limit"],
    page: json["page"],
    pages: json["pages"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "limit": limit,
    "page": page,
    "pages": pages,
    "__typename": typename,
  };
}

class Datum {
  String? id;
  String? projectName;
  String? projectLogo;
  String? projectStatus;
  num? hardcapPerUser;
  num? minimumCommitment;
  String? description;
  num? price;
  String? holdingCurrency;
  String? fiatCurrency;
  String? token;
  num? tokensOffered;
  DateTime? tokenDistribution;
  num? totalTokenSupply;
  num? totalCirculatingSupply;
  num? hardcap;
  String? introduction;
  String? keyFeatures;
  DateTime? createdDate;
  DateTime? modifiedDate;
  HoldCalculationPeriod? holdCalculationPeriod;
  TionPeriod? allocationPeriod;
  TionPeriod? subscriptionPeriod;
  TokenLink? tokenLink;
  num? exchangeRate;
  String? typename;

  Datum({
    this.id,
    this.projectName,
    this.projectLogo,
    this.projectStatus,
    this.hardcapPerUser,
    this.minimumCommitment,
    this.description,
    this.price,
    this.holdingCurrency,
    this.fiatCurrency,
    this.token,
    this.tokensOffered,
    this.tokenDistribution,
    this.totalTokenSupply,
    this.totalCirculatingSupply,
    this.hardcap,
    this.introduction,
    this.keyFeatures,
    this.createdDate,
    this.modifiedDate,
    this.holdCalculationPeriod,
    this.allocationPeriod,
    this.subscriptionPeriod,
    this.tokenLink,
    this.exchangeRate,
    this.typename,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    projectName: json["project_name"],
    projectLogo: json["project_logo"],
    projectStatus: json["project_status"],
    hardcapPerUser: json["hardcap_per_user"],
    minimumCommitment: json["minimum_commitment"],
    description: json["description"],
    price: json["price"],
    holdingCurrency: json["holding_currency"],
    fiatCurrency: json["fiat_currency"],
    token: json["token"],
    tokensOffered: json["tokens_offered"],
    tokenDistribution: json["token_distribution"] == null ? null : DateTime.parse(json["token_distribution"]),
    totalTokenSupply: json["total_token_supply"],
    totalCirculatingSupply: json["total_circulating_supply"],
    hardcap: json["hardcap"],
    introduction: json["introduction"],
    keyFeatures: json["key_features"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
    modifiedDate: json["modified_date"] == null ? null : DateTime.parse(json["modified_date"]),
    holdCalculationPeriod: json["hold_calculation_period"] == null ? null : HoldCalculationPeriod.fromJson(json["hold_calculation_period"]),
    allocationPeriod: json["allocation_period"] == null ? null : TionPeriod.fromJson(json["allocation_period"]),
    subscriptionPeriod: json["subscription_period"] == null ? null : TionPeriod.fromJson(json["subscription_period"]),
    tokenLink: json["token_link"] == null ? null : TokenLink.fromJson(json["token_link"]),
    exchangeRate: json["exchange_rate"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "project_name": projectName,
    "project_logo": projectLogo,
    "project_status": projectStatus,
    "hardcap_per_user": hardcapPerUser,
    "minimum_commitment": minimumCommitment,
    "description": description,
    "price": price,
    "holding_currency": holdingCurrency,
    "fiat_currency": fiatCurrency,
    "token": token,
    "tokens_offered": tokensOffered,
    "token_distribution": tokenDistribution?.toIso8601String(),
    "total_token_supply": totalTokenSupply,
    "total_circulating_supply": totalCirculatingSupply,
    "hardcap": hardcap,
    "introduction": introduction,
    "key_features": keyFeatures,
    "created_date": createdDate?.toIso8601String(),
    "modified_date": modifiedDate?.toIso8601String(),
    "hold_calculation_period": holdCalculationPeriod?.toJson(),
    "allocation_period": allocationPeriod?.toJson(),
    "subscription_period": subscriptionPeriod?.toJson(),
    "token_link": tokenLink?.toJson(),
    "exchange_rate": exchangeRate,
    "__typename": typename,
  };
}

class TionPeriod {
  DateTime? startDate;
  DateTime? endDate;
  int? noOfHours;
  int? breakHours;
  String? typename;

  TionPeriod({
    this.startDate,
    this.endDate,
    this.noOfHours,
    this.breakHours,
    this.typename,
  });

  factory TionPeriod.fromRawJson(String str) => TionPeriod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TionPeriod.fromJson(Map<String, dynamic> json) => TionPeriod(
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    noOfHours: json["no_of_hours"],
    breakHours: json["break_hours"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "no_of_hours": noOfHours,
    "break_hours": breakHours,
    "__typename": typename,
  };
}

class HoldCalculationPeriod {
  DateTime? startDate;
  int? noOfDays;
  DateTime? endDate;
  String? typename;

  HoldCalculationPeriod({
    this.startDate,
    this.noOfDays,
    this.endDate,
    this.typename,
  });

  factory HoldCalculationPeriod.fromRawJson(String str) => HoldCalculationPeriod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HoldCalculationPeriod.fromJson(Map<String, dynamic> json) => HoldCalculationPeriod(
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    noOfDays: json["no_of_days"],
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "start_date": startDate?.toIso8601String(),
    "no_of_days": noOfDays,
    "end_date": endDate?.toIso8601String(),
    "__typename": typename,
  };
}

class TokenLink {
  String? whitePaperLink;
  String? researchReportLink;
  String? websiteLink;
  String? facebookLink;
  String? twitterLink;
  String? mediumLink;
  String? typename;

  TokenLink({
    this.whitePaperLink,
    this.researchReportLink,
    this.websiteLink,
    this.facebookLink,
    this.twitterLink,
    this.mediumLink,
    this.typename,
  });

  factory TokenLink.fromRawJson(String str) => TokenLink.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenLink.fromJson(Map<String, dynamic> json) => TokenLink(
    whitePaperLink: json["white_paper_link"],
    researchReportLink: json["research_report_link"],
    websiteLink: json["website_link"],
    facebookLink: json["facebook_link"],
    twitterLink: json["twitter_link"],
    mediumLink: json["medium_link"],
    typename: json["__typename"],
  );

  Map<String, dynamic> toJson() => {
    "white_paper_link": whitePaperLink,
    "research_report_link": researchReportLink,
    "website_link": websiteLink,
    "facebook_link": facebookLink,
    "twitter_link": twitterLink,
    "medium_link": mediumLink,
    "__typename": typename,
  };
}
