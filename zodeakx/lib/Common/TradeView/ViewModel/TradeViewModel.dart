import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/TradeView/Model/klineModel.dart';
import 'package:zodeakx_mobile/Utils/Core/NativeChannelListener.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/DashBoardScreen/ViewModel/ExchangeRateViewModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../OrderBook/Model/OrderBookModel.dart';
import '../Model/OrderBooksModel.dart';
import '../Model/TradeHistoryModel.dart';
import '../Model/TradesHistoryModel.dart';

class TradeViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  String pair = "ETH/BTC";
  OpenOrders? getOpenOrders;
  List<TradesHistory>? tradeHistory;
  List<TradesHistory>? yoursTradeHistory;
  bool marketFlag = true;
  bool initSocket = false;
  List<ListOfTradePairs>? viewModelpriceTickersModel;
  dynamic estimateFiatValue = 0;
  dynamic exchangeRate = 0;
  String selectedDecimal = "0.000001";
  bool searchFilterView = false;
  String searchText = "";
  InAppWebViewController? webViewController;
  bool webLoad = false;
  List<KlineFormat> kLineTrade = [];

  static const platform = MethodChannel("flutter.native/helper");
  

  TradeViewModel() {
    initSocket = true;
  }

  fetchData() {
    getOrderBookByPairs(pair);
  }

  setWebLoad(bool value) async {
    webLoad = value;
    notifyListeners();
  }

  /// Loader
  setsearchFilterView(bool search) async {
    searchFilterView = search;
    notifyListeners();
  }

  /// search text
  setSearchText(String text) async {
    searchText = text;
    notifyListeners();
  }

  leaveSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.ws?.close();
    marketViewModel.webSocket?.clearListeners();
    initSocket = true;
    resumeSocket();
  }

  resumeSocket() {
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    exchangeViewModel.initSocket = true;
    exchangeViewModel.fetchData();
  }

  String getUrl() {
    String url = constant.wssSocketUrl;
    url += "${pair?.replaceAll("/", "").toLowerCase()}@ticker/";
    url += "${pair?.replaceAll("/", "").toLowerCase()}@depth/";
    url += "${pair?.replaceAll("/", "").toLowerCase()}@trade/";
    url += "${pair?.replaceAll("/", "").toLowerCase()}@kline_1d";
    return url;
  }

  getTradeLocalSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    String sessionId = constant.pref?.getString("sessionId") ?? "";
    marketViewModel.webSocket?.on("tradeYoursHistory_${sessionId}_$pair",
        (data) {
      var decodeResponse =
          HandleResponse.completed(TradesHistory.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          updateYoursTradeHistory(decodeResponse.data!);
          //setLoading(false);
          break;
        default: //setLoading(false);
          break;
      }
    });

    marketViewModel.webSocket?.on("tradeHistory_$pair", (data) {
      Map<String, dynamic> openOrder = {
        'status_message': "Fetched From API",
        'status_code': 200,
        'result': data,
      };
      var decodeResponse =
          HandleResponse.completed(TradesHistoryModel.fromJson(openOrder));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          setTradeHistory(decodeResponse.data!.result, true);
          //setLoading(false);
          break;
        default: //setLoading(false);
          break;
      }
    });

    marketViewModel.webSocket?.on('trade_pair_$pair', (data) {
      var decodeResponse =
          HandleResponse.completed(ListOfTradePairs.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          updateTradePair(decodeResponse.data!);
          break;
        default:
          break;
      }
    });

  
    
       marketViewModel.webSocket?.on("klines_$pair",
        (data) {
      var decodeResponse =
          HandleResponse.completed(TradesHistory.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          updateYoursTradeHistory(decodeResponse.data!);
          //setLoading(false);
          break;
        default: //setLoading(false);
          break;
      }
    });

    marketViewModel.setViewModel(this);
  }

  getTradeSocket() async {
    initSocket = false;
    if (!constant.binanceStatus.value) {
      getTradeLocalSocket();
      return;
    }
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    String sessionId = constant.pref?.getString("sessionId") ?? "";
    marketViewModel.webSocket?.on("tradeYoursHistory_${sessionId}_$pair",
        (data) {
      var decodeResponse =
          HandleResponse.completed(TradesHistory.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          updateYoursTradeHistory(decodeResponse.data!);
          //setLoading(false);
          break;
        default: //setLoading(false);
          break;
      }
    });

    marketViewModel.ws = await WebSocket.connect(getUrl());
    marketViewModel.ws?.listen(
      (data) {
        if (json.decode(data)["stream"].contains("ticker")) {
          TradePairModel tradePairModel =
              TradePairModel.fromJson(json.decode(data));
          updateTradePairs(tradePairModel.data!);
        } else if (json.decode(data)["stream"].contains("trade")) {
          TradeHistoryModel tradeHistoryModel =
              TradeHistoryModel.fromJson(json.decode(data));
          updateTradeHistory(tradeHistoryModel.data!);
        } else if (json.decode(data)["stream"].contains("depth")) {
          OrderBooksModel orderBooksModel =
              OrderBooksModel.fromJson(json.decode(data));
          updateOpenOrder(orderBooksModel.data!);
        } else if (json.decode(data)["stream"].contains('kline')){
          print(data);
        }
      },
      onDone: () {
        marketViewModel.ws?.close();
      },
      onError: (error) {
        marketViewModel.ws?.close();
      },
    );


    marketViewModel.setViewModel(this);
  }

  updateOpenOrder(OrderBooks orderBooks) {
    updateBuyData(orderBooks);
    updateSellData(orderBooks);
  }

  updateSellData(OrderBooks orderBooks) {
    for (int i = 0; i < (orderBooks.a ?? []).length; i++) {
      if (orderBooks.a?[i][1] == "0.00000000") {
        orderBooks.a?.remove(orderBooks.a?[i]);
      }
    }

    for (int i = 0; i < (getOpenOrders?.asks ?? []).length; i++) {
      String apiPrice = getOpenOrders?.asks?[i][0];
      for (int j = 0; j < (orderBooks?.a ?? []).length; j++) {
        if (apiPrice == orderBooks?.a?[j][0]) {
          getOpenOrders?.asks?[i] = (orderBooks?.a?[j] ?? []);
        }
      }
    }

    List<List<dynamic>>? asks =
        (getOpenOrders?.asks ?? []) + (orderBooks?.a ?? []);

    asks = List.of(asks!)
      ..sort((a, b) => double.parse(b[0])!.compareTo(double.parse(a[0])!));

    asks = asks
        .where((element) =>
            double.parse(element[0]) >=
            double.parse(viewModelpriceTickersModel?.first.lastPrice ?? "0"))
        .toList();

    asks = asks?.toSet().toList();

    getOpenOrders?.asks = asks;
  }

  updateBuyData(OrderBooks orderBooks) {
    for (int i = 0; i < (orderBooks.b ?? []).length; i++) {
      if (orderBooks.b?[i][1] == "0.00000000") {
        orderBooks.b?.remove(orderBooks.b?[i]);
      }
    }

    for (int i = 0; i < (getOpenOrders?.bids ?? []).length; i++) {
      String apiPrice = getOpenOrders?.bids?[i][0];
      for (int j = 0; j < (orderBooks?.b ?? []).length; j++) {
        if (apiPrice == orderBooks?.b?[j][0]) {
          getOpenOrders?.bids?[i] = (orderBooks?.b?[j] ?? []);
        }
      }
    }

    List<List<dynamic>>? bids =
        (getOpenOrders?.bids ?? []) + (orderBooks?.b ?? []);

    bids = List.of(bids!)
      ..sort((a, b) => double.parse(a[0])!.compareTo(double.parse(b[0])!));

    bids = bids
        .where((element) =>
            double.parse(element[0]) <=
            double.parse(viewModelpriceTickersModel?.first.lastPrice ?? "0"))
        .toList();

    bids = bids?.toSet().toList();

    getOpenOrders?.bids = bids;
  }

  updateTradeHistory(TradeHistory tradeHistory) {
    TradesHistory tradesHistory = TradesHistory(
      price: tradeHistory.p,
      qty: tradeHistory.q,
      side: (tradeHistory.dataM ?? false) ? "Sell" : "Buy",
    );
    this.tradeHistory?.insert(0, tradesHistory);
    setTradeHistory(this.tradeHistory?.take(100).toList(), true);
  }

  updateTradePairs(TradePair tradePair) {
    viewModelpriceTickersModel?.forEach((element) {
      if (element.symbol?.replaceAll("/", "").toUpperCase() == tradePair?.s) {
        element.lastPrice = tradePair?.c;
        element.quoteVolume = tradePair?.q;
        element.priceChangePercent = tradePair?.P;
        element.priceChange = tradePair?.p;
        element.highPrice = tradePair?.h;
        element.lowPrice = tradePair?.l;
        estimateFiatValue = double.parse(element.lastPrice.toString()) *
            double.parse("${exchangeRate ?? 0.0}");
      }
    });
    notifyListeners();
  }

  /// Loader
  setGetOpenOrders(OpenOrders? openOrders, [isSocket = false]) async {
    getOpenOrders = openOrders;
    notifyListeners();
    getPriceTickers(pair);
  }

  getOrderBookByPairs(String pair) async {
    var params = {
      "input": {"pair": pair, "limit": 100}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.orderDetails(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setGetOpenOrders(decodeResponse.data?.result);
          getKlineData(pair);
          //setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }

  updateYoursTradeHistory(TradesHistory? history) {
    if (yoursTradeHistory != null) {
      yoursTradeHistory!.insert(0, history!);
    } else {
      yoursTradeHistory = [history!];
    }
    notifyListeners();
  }

  /// Loader
  setTradeHistory(List<TradesHistory>? history, [isSocket = false]) async {
    this.tradeHistory = history;
    notifyListeners();
    if (!isSocket) getYoursTradeHistory(pair);
  }

  getTradeHistory(String pair) async {
    var params = {
      "data": {"pair": pair, "limit": 100}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.tradeHistory(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setTradeHistory(decodeResponse.data?.result);
          //setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }

  /// Loader
  setYoursTradeHistory(List<TradesHistory>? history) async {
    this.yoursTradeHistory = history;
    notifyListeners();
  }

  setTradeData(List<List<String>>? data) async {
    print(data?.length);
    setDefaultData(data);
    //sendData();
  }

  setDefaultData(List<List<String>>? data){

// data.isNotEmpty {
  
// }
    
    data?.forEach((element) {
     kLineTrade.add(KlineFormat(
time: element[0],
high: element[2],
low: element[3],
open: element[1],
close: element[4],
volume: element[7]
     ));
    });

    print(kLineTrade.length);
  }

  getPriceTickers(String pair) async {
    Map<String, dynamic> params = {
      "input": {
        "pairs": [pair]
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchPriceTickers(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setPriceTickers(decodeResponse.data!.result);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }

  void updateTradePair(ListOfTradePairs data) {
    if (data.symbol == pair) viewModelpriceTickersModel![0] = data;
    notifyListeners();
  }

  /// set trade pairs
  setPriceTickers(List<ListOfTradePairs>? priceTickers) {
    viewModelpriceTickersModel = priceTickers;
    String currency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    if (currency == "USD")
      estimateFiatValue =
          double.parse(priceTickers?.first.exchangeRates!.usd ?? "0");
    else if (currency == "GBP")
      estimateFiatValue =
          double.parse(priceTickers?.first.exchangeRates!.gbp ?? "0");
    else
      estimateFiatValue =
          double.parse(priceTickers?.first.exchangeRates!.eur ?? "0");
    getEstimateFiatValue(pair);
    notifyListeners();
    if (initSocket) {
      getTradeSocket();
      initSocket = false;
    }
  }

  getEstimateFiatValue(String pair) async {
    Map<String, dynamic> params = {
      "data": {
        "from_currency": pair.split("/").last,
        "to_currency":
            '${constant.pref?.getString("defaultFiatCurrency") ?? 'GBP'}',
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchExchangeRate(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setEstimateFiatValue(decodeResponse?.data?.result);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }

  setEstimateFiatValue(GetExchangeResult? result) {
    exchangeRate = result?.exchangeRate;
    estimateFiatValue =
        double.parse(viewModelpriceTickersModel!.first.lastPrice.toString()) *
            double.parse("${exchangeRate ?? 0.0}");
    getTradeHistory(pair);
    notifyListeners();
  }

Future sendData() async{

  await _sendMessageToNativeCode();
        
  }

  Future<void> _sendMessageToNativeCode() async {
    try {
      // 3- invoke a method on the method channel,
    
      // final jsonStr = {
      //   "name": "Ali Akhtar",
      //   "email": "ali@example.com",
      // };

      final returnText =
          await platform.invokeMethod('sendMessage', {'name': 10, 'demo': 10});
          print(returnText.toString());

    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> methodHandler(MethodCall call) async {
    final String usersStringJson = call.arguments;
    Map<String, dynamic> userMap = json.decode(usersStringJson);

    switch (call.method) {
      case "receieveMessage":
 // this method name needs to be the same from invokeMethod in Android// you can handle the data here. In this example, we will simply update the view via a data service
        break;
      default:
        print('no method handler for method ${call.method}');
    }
  }
 




  getKlineData(String pair) async {
    var param = {
      "pair": pair,
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet){
      var response = await productRepository.getTradeLine(param);
      var decoderesponse = HandleResponse.completed(response);
      switch (decoderesponse.status?.index) {
         case 0:
          setLoading(false);
          break;
        case 1:
          setTradeData(decoderesponse.data?.result);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    }else {
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }

  getYoursTradeHistory(String pair) async {
    var params = {
      "input": {"pair": pair, "limit": 100}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.yoursTradeHistory(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setYoursTradeHistory(decodeResponse.data?.result);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Loader
  setMarketView() async {
    marketFlag = !marketFlag;
    notifyListeners();
  }

  /// decimal
  setSelectedDecimal(String value) async {
    selectedDecimal = value;
    notifyListeners();
  }

  /// pair
  setTradePair(String tradePair) async {
    pair = tradePair;
    notifyListeners();
    initSocket = true;
    webViewController?.loadUrl(
        urlRequest: URLRequest(url: Uri.parse("about:blank")));
    Future.delayed(Duration(milliseconds: 500), () {
      webViewController?.loadUrl(
          urlRequest: URLRequest(
              url: Uri.parse(
                  "${constant.chartUrl}${pair.split("/").first}_${pair.split("/").last}/chart?theme=${themeSupport().isSelectedDarkMode() ? "dark" : "light"}")));
    });
    setWebLoad(true);
    fetchData();
  }
}
