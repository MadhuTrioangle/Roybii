class TradePairs {
  int? statusCode;
  String? statusMessage;
  List<ListOfTradePairs>? result;

  TradePairs({this.statusCode, this.statusMessage, this.result});

  TradePairs.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['result'] != null) {
      result = <ListOfTradePairs>[];
      json['result'].forEach((v) {
        result?.add(new ListOfTradePairs.fromJson(v));
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

class ListOfTradePairs {
  String? symbol;
  String? lastPrice;
  String? priceChange;
  String? priceChangePercent;
  String? highPrice;
  String? lowPrice;
  String? quoteVolume;
  ExchangeRates? exchangeRates;
  String? leverageIsolated;
  bool? enableMarginIsolated;
  bool? enableMarginCross;

  ListOfTradePairs(
      {this.symbol,
      this.lastPrice,
      this.priceChange,
      this.priceChangePercent,
      this.highPrice,
      this.lowPrice,
      this.quoteVolume,
      this.leverageIsolated,
      this.enableMarginIsolated,
      this.enableMarginCross,
      this.exchangeRates});

  ListOfTradePairs.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    lastPrice = json['lastPrice'];
    priceChange = json['priceChange'];
    priceChangePercent = json['priceChangePercent'];
    highPrice = json['highPrice'];
    lowPrice = json['lowPrice'];
    quoteVolume = json['quoteVolume'];
    leverageIsolated = json['leverage_isolated'];
    enableMarginIsolated = json['enable_margin_isolated'];
    enableMarginCross = json['enable_margin_cross'];
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
    data['leverage_isolated'] = this.leverageIsolated;
    data['enable_margin_isolated'] = this.enableMarginIsolated;
    data['enable_margin_cross'] = this.enableMarginCross;
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

ListOfTradePairs dummyTradePairs = ListOfTradePairs(
  symbol: "---",
  lastPrice: "0",
  priceChange: "0",
  priceChangePercent: "0",
  highPrice: "0",
  lowPrice: "0",
  quoteVolume: "0",
  leverageIsolated: "0",
  enableMarginCross: false,
  enableMarginIsolated: false,
  exchangeRates: ExchangeRates(
    usd: "0",
    gbp: "0",
    eur: "0",
  ),
);
