class IsolatedPositionsModel {
  int? statusCode;
  String? statusMessage;
  List<IsolatedPositions>? result;
  String? sTypename;

  IsolatedPositionsModel(
      {this.statusCode, this.statusMessage, this.result, this.sTypename});

  IsolatedPositionsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(new IsolatedPositions.fromJson(v));
      });
    }
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result?.map((v) => v.toJson()).toList();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class IsolatedPositions {
  String? pair;
  String? riskRatio;
  num? indexPrice;
  num? liquidationPrice;
  List<IsolatedWallet>? wallet;
  String? sTypename;

  IsolatedPositions(
      {this.pair,
      this.riskRatio,
      this.indexPrice,
      this.liquidationPrice,
      this.wallet,
      this.sTypename});

  IsolatedPositions.fromJson(Map<String, dynamic> json) {
    pair = json['pair'];
    riskRatio = json['risk_ratio'];
    indexPrice = json['index_price'];
    liquidationPrice = json['liquidation_price'];
    if (json['wallet'] != null) {
      wallet = [];
      json['wallet'].forEach((v) {
        wallet?.add(new IsolatedWallet.fromJson(v));
      });
    }
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pair'] = this.pair;
    data['risk_ratio'] = this.riskRatio;
    data['index_price'] = this.indexPrice;
    data['liquidation_price'] = this.liquidationPrice;
    if (this.wallet != null) {
      data['wallet'] = this.wallet?.map((v) => v.toJson()).toList();
    }
    data['__typename'] = this.sTypename;
    return data;
  }
}

class IsolatedWallet {
  String? coin;
  String? image;
  num? position;
  num? positionValue;
  num? positionPnl;
  num? interestRate;
  String? sTypename;

  IsolatedWallet(
      {this.coin,
      this.image,
      this.position,
      this.positionValue,
      this.positionPnl,
        this.interestRate,
      this.sTypename});

  IsolatedWallet.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    image = json['image'];
    position = json['position'];
    positionValue = json['position_value'];
    positionPnl = json['position_pnl'];
    interestRate = json['interest_rate'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coin'] = this.coin;
    data['image'] = this.image;
    data['position'] = this.position;
    data['position_value'] = this.positionValue;
    data['position_pnl'] = this.positionPnl;
    data['interest_rate'] = this.interestRate;
    data['__typename'] = this.sTypename;
    return data;
  }
}
