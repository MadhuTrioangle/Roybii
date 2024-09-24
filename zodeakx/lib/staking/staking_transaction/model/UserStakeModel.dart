class UserStakeModel {
  int? statusCode;
  String? statusMessage;
  UserStake? result;
  String? sTypename;

  UserStakeModel(
      {this.statusCode, this.statusMessage, this.result, this.sTypename});

  UserStakeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    result =
        json['result'] != null ? new UserStake.fromJson(json['result']) : null;
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

class UserStake {
  int? total;
  int? limit;
  int? pages;
  int? page;
  List<UserStakeDetails>? data;
  String? sTypename;

  UserStake(
      {this.total,
      this.limit,
      this.pages,
      this.page,
      this.data,
      this.sTypename});

  UserStake.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    pages = json['pages'];
    page = json['page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(new UserStakeDetails.fromJson(v));
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

class UserStakeDetails {
  String? sId;
  String? userStakeId;
  bool? isFlexible;
  bool? isAutoRestake;
  String? interestEndAt;
  String? status;
  StakeCurrencyDetails? stakeCurrencyDetails;
  StakeCurrencyDetails? rewardCurrencyDetails;
  num? stakeAmount;
  num? aPR;
  String? stakedAt;
  int? lockedDuration;
  String? sTypename;
  bool isExpanded = false;

  UserStakeDetails(
      {this.sId,
      this.userStakeId,
      this.isFlexible,
      this.isAutoRestake,
      this.interestEndAt,
      this.status,
      this.stakeCurrencyDetails,
      this.rewardCurrencyDetails,
      this.stakeAmount,
      this.aPR,
      this.stakedAt,
      this.lockedDuration,
      this.sTypename});

  UserStakeDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userStakeId = json['userStakeId'];
    isFlexible = json['isFlexible'];
    isAutoRestake = json['isAutoRestake'];
    interestEndAt = json['interestEndAt'];
    status = json['status'];
    stakeCurrencyDetails = json['stakeCurrencyDetails'] != null
        ? new StakeCurrencyDetails.fromJson(json['stakeCurrencyDetails'])
        : null;
    rewardCurrencyDetails = json['rewardCurrencyDetails'] != null
        ? new StakeCurrencyDetails.fromJson(json['rewardCurrencyDetails'])
        : null;
    stakeAmount = json['stakeAmount'];
    aPR = json['APR'];
    stakedAt = json['stakedAt'];
    lockedDuration = json['lockedDuration'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userStakeId'] = this.userStakeId;
    data['isFlexible'] = this.isFlexible;
    data['isAutoRestake'] = this.isAutoRestake;
    data['interestEndAt'] = this.interestEndAt;
    data['status'] = this.status;
    if (this.stakeCurrencyDetails != null) {
      data['stakeCurrencyDetails'] = this.stakeCurrencyDetails?.toJson();
    }
    if (this.rewardCurrencyDetails != null) {
      data['rewardCurrencyDetails'] = this.rewardCurrencyDetails?.toJson();
    }
    data['stakeAmount'] = this.stakeAmount;
    data['APR'] = this.aPR;
    data['stakedAt'] = this.stakedAt;
    data['lockedDuration'] = this.lockedDuration;
    data['__typename'] = this.sTypename;
    return data;
  }
}

class StakeCurrencyDetails {
  String? code;
  String? sTypename;

  StakeCurrencyDetails({this.code, this.sTypename});

  StakeCurrencyDetails.fromJson(Map<String, dynamic> json) {
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
