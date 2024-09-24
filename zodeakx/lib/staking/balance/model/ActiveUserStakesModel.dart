class ActiveUserStakesModel {
  int? statusCode;
  String? statusMessage;
  ActiveUserStakes? result;

  ActiveUserStakesModel({this.statusCode, this.statusMessage, this.result});

  ActiveUserStakesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    result = json['result'] != null
        ? new ActiveUserStakes.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result?.toJson();
    }
    return data;
  }
}

class ActiveUserStakes {
  List<EarnBalance>? earnBalance;
  List<ExchangeRate>? exchangeRate;
  List<StakeData>? stakeData;
  int? total;
  int? limit;
  int? page;
  int? pages;

  ActiveUserStakes(
      {this.earnBalance,
      this.exchangeRate,
      this.stakeData,
      this.total,
      this.limit,
      this.page,
      this.pages});

  ActiveUserStakes.fromJson(Map<String, dynamic> json) {
    if (json['earnBalance'] != null) {
      earnBalance = [];
      json['earnBalance'].forEach((v) {
        earnBalance?.add(new EarnBalance.fromJson(v));
      });
    }
    if (json['exchangeRate'] != null) {
      exchangeRate = [];
      json['exchangeRate'].forEach((v) {
        exchangeRate?.add(new ExchangeRate.fromJson(v));
      });
    }
    if (json['stakeData'] != null) {
      stakeData = [];
      json['stakeData'].forEach((v) {
        stakeData?.add(new StakeData.fromJson(v));
      });
    }
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.earnBalance != null) {
      data['earnBalance'] = this.earnBalance?.map((v) => v.toJson()).toList();
    }
    if (this.exchangeRate != null) {
      data['exchangeRate'] = this.exchangeRate?.map((v) => v.toJson()).toList();
    }
    if (this.stakeData != null) {
      data['stakeData'] = this.stakeData?.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['limit'] = this.limit;
    data['page'] = this.page;
    data['pages'] = this.pages;
    return data;
  }
}

class EarnBalance {
  String? sId;
  num? earnBalance;

  EarnBalance({this.sId, this.earnBalance});

  EarnBalance.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    earnBalance = json['earnBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['earnBalance'] = this.earnBalance;
    return data;
  }
}

class ExchangeRate {
  String? sId;
  num? exchangeRateByUserPreferred;
  num? usdRate;

  ExchangeRate({this.sId, this.exchangeRateByUserPreferred,this.usdRate});

  ExchangeRate.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    sId = json['_id'];
    exchangeRateByUserPreferred = json['exchangeRateByUserPreferred'];
    usdRate = json['USDRate'];
    data['USDRate'] = this.usdRate;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['exchangeRateByUserPreferred'] = this.exchangeRateByUserPreferred;
    return data;
  }
}

class StakeData {
  String? sId;
  List<StakeItem>? data;
  bool isExpanded = false;
  num? stakeAmount = 0;
  String? stakedAt = "";

  StakeData({this.sId, this.data});

  StakeData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(new StakeItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StakeItem {
  String? sId;
  String? userStakeId;
  String? stakeId;
  bool? isFlexible;
  bool? isAutoRestake;
  String? status;
  StakeCurrencyDetails? stakeCurrencyDetails;
  StakeCurrencyDetails? rewardCurrencyDetails;
  num? stakeAmount;
  num? aPR;
  String? interestEndAt;
  String? stakedAt;
  int? lockedDuration;

  StakeItem(
      {this.sId,
      this.userStakeId,
      this.stakeId,
      this.isFlexible,
      this.isAutoRestake,
      this.status,
      this.stakeCurrencyDetails,
      this.rewardCurrencyDetails,
      this.stakeAmount,
      this.aPR,
      this.interestEndAt,
      this.stakedAt,
      this.lockedDuration});

  StakeItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userStakeId = json['userStakeId'];
    stakeId = json['stakeId'];
    isFlexible = json['isFlexible'];
    isAutoRestake = json['isAutoRestake'];
    status = json['status'];
    stakeCurrencyDetails = json['stakeCurrencyDetails'] != null
        ? new StakeCurrencyDetails.fromJson(json['stakeCurrencyDetails'])
        : null;
    rewardCurrencyDetails = json['rewardCurrencyDetails'] != null
        ? new StakeCurrencyDetails.fromJson(json['rewardCurrencyDetails'])
        : null;
    stakeAmount = json['stakeAmount'];
    aPR = json['APR'];
    interestEndAt = json['interestEndAt'];
    stakedAt = json['stakedAt'];
    lockedDuration = json['lockedDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userStakeId'] = this.userStakeId;
    data['stakeId'] = this.stakeId;
    data['isFlexible'] = this.isFlexible;
    data['isAutoRestake'] = this.isAutoRestake;
    data['status'] = this.status;
    if (this.stakeCurrencyDetails != null) {
      data['stakeCurrencyDetails'] = this.stakeCurrencyDetails?.toJson();
    }
    if (this.rewardCurrencyDetails != null) {
      data['rewardCurrencyDetails'] = this.rewardCurrencyDetails?.toJson();
    }
    data['stakeAmount'] = this.stakeAmount;
    data['APR'] = this.aPR;
    data['interestEndAt'] = this.interestEndAt;
    data['stakedAt'] = this.stakedAt;
    data['lockedDuration'] = this.lockedDuration;
    return data;
  }
}

class StakeCurrencyDetails {
  String? code;

  StakeCurrencyDetails({this.code});

  StakeCurrencyDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}
