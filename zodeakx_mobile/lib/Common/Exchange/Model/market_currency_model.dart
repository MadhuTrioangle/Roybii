class MarketCurrencyModel {
  int? statusCode;
  String? statusMessage;
  List<MarketCurrency>? result;

  MarketCurrencyModel({this.statusCode, this.statusMessage, this.result});

  MarketCurrencyModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['result'] != null) {
      result = <MarketCurrency>[];
      json['result'].forEach((v) {
        result!.add(new MarketCurrency.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MarketCurrency {
  String? currencyType;
  String? currencyCode;

  MarketCurrency({this.currencyType, this.currencyCode});

  MarketCurrency.fromJson(Map<String, dynamic> json) {
    currencyType = json['currency_type'];
    currencyCode = json['currency_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_type'] = this.currencyType;
    data['currency_code'] = this.currencyCode;
    return data;
  }
}
