class PriceTickersModel {
  int? statusCode;
  String? statusMessage;
  List<PriceTickers>? result;

  PriceTickersModel({this.statusCode, this.statusMessage, this.result});

  PriceTickersModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['result'] != null) {
      result = <PriceTickers>[];
      json['result'].forEach((v) {
        result?.add(new PriceTickers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.result != null) {
      data['result'] = this.result?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceTickers {
  String? symbol;
  String? lastPrice;
  String? priceChange;
  String? priceChangePercent;
  String? highPrice;
  String? lowPrice;
  String? quoteVolume;
  ExchangeRates? exchangeRates;

  PriceTickers(
      {this.symbol,
        this.lastPrice,
        this.priceChange,
        this.priceChangePercent,
        this.highPrice,
        this.lowPrice,
        this.quoteVolume,
        this.exchangeRates});

  PriceTickers.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    lastPrice = json['lastPrice'];
    priceChange = json['priceChange'];
    priceChangePercent = json['priceChangePercent'];
    highPrice = json['highPrice'];
    lowPrice = json['lowPrice'];
    quoteVolume = json['quoteVolume'];
    exchangeRates = json['exchange_rates'] != null
        ? new ExchangeRates.fromJson(json['exchange_rates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['lastPrice'] = this.lastPrice;
    data['priceChange'] = this.priceChange;
    data['priceChangePercent'] = this.priceChangePercent;
    data['highPrice'] = this.highPrice;
    data['lowPrice'] = this.lowPrice;
    data['quoteVolume'] = this.quoteVolume;
    if (this.exchangeRates != null) {
      data['exchange_rates'] = this.exchangeRates?.toJson();
    }
    return data;
  }
}

class ExchangeRates {
  String? usd;
  String? gbp;
  String? eur;

  ExchangeRates({this.usd, this.gbp, this.eur});

  ExchangeRates.fromJson(Map<String, dynamic> json) {
    usd = json['USD'];
    gbp = json['GBP'];
    eur = json['EUR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['USD'] = this.usd;
    data['GBP'] = this.gbp;
    data['EUR'] = this.eur;
    return data;
  }
}
