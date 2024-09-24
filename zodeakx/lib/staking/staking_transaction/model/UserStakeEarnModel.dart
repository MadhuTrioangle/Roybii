class UserStakeEarnModel {
  int? statusCode;
  String? statusMessage;
  UserStakeEarn? result;
  String? sTypename;

  UserStakeEarnModel(
      {this.statusCode, this.statusMessage, this.result, this.sTypename});

  UserStakeEarnModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    result = json['result'] != null
        ? new UserStakeEarn.fromJson(json['result'])
        : null;
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result?.toJson();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class UserStakeEarn {
  int? total;
  int? limit;
  int? pages;
  int? page;
  List<UserStakeEarnDetails>? data;
  String? sTypename;

  UserStakeEarn(
      {this.total,
      this.limit,
      this.pages,
      this.page,
      this.data,
      this.sTypename});

  UserStakeEarn.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    pages = json['pages'];
    page = json['page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(new UserStakeEarnDetails.fromJson(v));
      });
    }
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['limit'] = this.limit;
    data['pages'] = this.pages;
    data['page'] = this.page;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class UserStakeEarnDetails {
  String? userStakeId;
  num? interestAmount;
  EarnCurrencyDetails? earnCurrencyDetails;
  UserStakeDetail? userStakeDetails;
  String? createdAt;
  String? sTypename;

  UserStakeEarnDetails(
      {this.userStakeId,
      this.userStakeDetails,
      this.interestAmount,
      this.earnCurrencyDetails,
      this.createdAt,
      this.sTypename});

  UserStakeEarnDetails.fromJson(Map<String, dynamic> json) {
    userStakeId = json['userStakeId'];
    interestAmount = json['interestAmount'];
    earnCurrencyDetails = json['earnCurrencyDetails'] != null
        ? new EarnCurrencyDetails.fromJson(json['earnCurrencyDetails'])
        : null;
    userStakeDetails = json['userStakeDetails'] != null
        ? new UserStakeDetail.fromJson(json['userStakeDetails'])
        : null;
    createdAt = json['createdAt'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userStakeId'] = this.userStakeId;
    data['interestAmount'] = this.interestAmount;
    if (this.earnCurrencyDetails != null) {
      data['earnCurrencyDetails'] = this.earnCurrencyDetails?.toJson();
    }
    if (this.userStakeDetails != null) {
      data['userStakeDetails'] = this.userStakeDetails?.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class EarnCurrencyDetails {
  String? code;
  String? sTypename;

  EarnCurrencyDetails({this.code, this.sTypename});

  EarnCurrencyDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class UserStakeDetail {
  bool? isFlexible;

  UserStakeDetail({this.isFlexible});

  UserStakeDetail.fromJson(Map<String, dynamic> json) {
    isFlexible = json['isFlexible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFlexible'] = this.isFlexible;
    return data;
  }
}
