class AllCrossPositionsModel {
  int? statusCode;
  String? statusMessage;
  List<AllCrossPositions>? result;
  String? sTypename;

  AllCrossPositionsModel(
      {this.statusCode, this.statusMessage, this.result, this.sTypename});

  AllCrossPositionsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(new AllCrossPositions.fromJson(v));
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

class AllCrossPositions {
  String? coin;
  String? image;
  num? position;
  num? positionValue;
  num? indexPrice;
  num? liquidationPrice;
  num? interestRate;
  String? sTypename;

  AllCrossPositions(
      {this.coin,
      this.image,
      this.position,
      this.positionValue,
      this.indexPrice,
      this.liquidationPrice,
      this.interestRate,
      this.sTypename});

  AllCrossPositions.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    image = json['image'];
    position = json['position'];
    positionValue = json['position_value'];
    indexPrice = json['index_price'];
    liquidationPrice = json['liquidation_price'];
    interestRate = json['interest_rate'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coin'] = this.coin;
    data['image'] = this.image;
    data['position'] = this.position;
    data['position_value'] = this.positionValue;
    data['index_price'] = this.indexPrice;
    data['liquidation_price'] = this.liquidationPrice;
    data['interest_rate'] = this.interestRate;
    data['__typename'] = this.sTypename;
    return data;
  }
}
