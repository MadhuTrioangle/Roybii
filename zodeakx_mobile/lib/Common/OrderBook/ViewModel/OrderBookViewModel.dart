import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/TradeView/Model/OkxOrderBookModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../ZodeakX/DashBoardScreen/Model/ExchangeRateModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../TradeView/Model/OrderBooksModel.dart';
import '../Model/OrderBookModel.dart';

class OrderBookViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  int selectedTradePair = 0;
  int selectedDecimal = 0;
  List<bool> viewFilter = [true, false, false];
  OpenOrders? getOpenOrders;
  List<String> tradePairs = [];
  String tradePair = "ETH/BTC";
  bool buySellFlag = true;
  bool initSocket = false;
  dynamic estimateFiatValue = 0;
  dynamic exchangeRate = 0;
  List<ListOfTradePairs>? viewModelpriceTickersModel;

  OrderBookViewModel() {
    initSocket = true;
  }

  fetchData([startSocket = true]) {
    getOrderBookByPairs(tradePair, startSocket);
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// trade Pair
  setTradePair(String pair) async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    // marketViewModel.ws?.close();
    //  marketViewModel.webSocket?.clearListeners();
    tradePair = pair;
    notifyListeners();
    initSocket = true;
    fetchData();
  }

  /// trade Pair
  setBuySellFlag(bool flag) async {
    buySellFlag = await flag;
    notifyListeners();
  }

  /// Loader
  setGetOpenOrders(OpenOrders? openOrders,
      [isSocket = false, startSocket = true]) async {
    securedPrint("openOrders${openOrders?.bids?.length}");
    securedPrint("openOrders${openOrders?.asks?.length}");
    getOpenOrders = openOrders;
    notifyListeners();
    getPriceTickers(tradePair);
    // if (!isSocket)
    // if (initSocket && startSocket) {
    //   getOrderBookSocket();
    //   initSocket = false;
    // }
  }

  /// Trade Pair
  setSelectedTradePair(int selectedPair) async {
    selectedTradePair = selectedPair;
    notifyListeners();
  }

  /// Trade Pair
  setSelectedDecimal(int decimal) async {
    selectedDecimal = decimal;
    notifyListeners();
  }

  /// view Filter
  setViewFilter(List<bool> filter) async {
    viewFilter = filter;
    notifyListeners();
  }

  leaveSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocket?.clearListeners();
    marketViewModel.ws?.close();
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
    url += "${tradePair?.replaceAll("/", "").toLowerCase()}@ticker/";
    url += "${tradePair?.replaceAll("/", "").toLowerCase()}@depth";
    return url;
  }

  getOrderBookLocalSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    marketViewModel.webSocket?.on("tradeOpenOrders_$tradePair", (data) {
      var decodeResponse = HandleResponse.completed(OpenOrders.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          setGetOpenOrders(decodeResponse.data, true);
          break;
        default:
          break;
      }
    });

    marketViewModel.webSocket?.on('trade_pair_$tradePair', (data) {
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

    marketViewModel.setViewModel(this);
  }

  getOrderBookSocket() async {
    initSocket = false;
    if (!constant.okxStatus.value) {
      getOrderBookLocalSocket();
      return;
    }
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    marketViewModel.ws = await WebSocket.connect(getUrl());
    marketViewModel.ws?.listen(
      (data) {
        if (json.decode(data)["stream"].contains("ticker")) {
          TradePairModel tradePairModel =
              TradePairModel.fromJson(json.decode(data));
          updateTradePairs(tradePairModel.data!);
        } else if (json.decode(data)["stream"].contains("depth")) {
          OrderBooksModel orderBooksModel =
              OrderBooksModel.fromJson(json.decode(data));
          updateOpenOrder(orderBooksModel.data!);
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

  updateOkxOpenOrder(OkxOrderBook data) {
    updateOkxBuyData(data);
    updateOkxSellData(data);
  }

  updateSellData(OrderBooks orderBooks) {
    var exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
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
            double.parse(
                exchangeViewModel.viewModelpriceTickersModel?.first.lastPrice ??
                    "0"))
        .toList();

    asks = asks?.toSet().toList();

    getOpenOrders?.asks = asks;
    notifyListeners();
  }

  updateOkxSellData(OkxOrderBook orderBooks) {
    var exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    for (int i = 0; i < (orderBooks.asks ?? []).length; i++) {
      if (orderBooks.asks?[i][1] == "0.00000000") {
        orderBooks.asks?.remove(orderBooks.asks?[i]);
      }
    }

    for (int i = 0; i < (getOpenOrders?.asks ?? []).length; i++) {
      String apiPrice = getOpenOrders?.asks?[i][0];
      for (int j = 0; j < (orderBooks.asks ?? []).length; j++) {
        if (apiPrice == orderBooks.asks?[j][0]) {
          getOpenOrders?.asks?[i] = (orderBooks.asks?[j] ?? []);
        }
      }
    }

    List<List<dynamic>>? asks =
        (getOpenOrders?.asks ?? []) + (orderBooks.asks ?? []);

    asks = List.of(asks)
      ..sort((a, b) => double.parse(b[0]).compareTo(double.parse(a[0])));

    asks = asks
        .where((element) =>
            double.parse(element[0]) >=
            double.parse(
                exchangeViewModel.viewModelpriceTickersModel?.first.lastPrice ??
                    "0"))
        .toList();

    asks = asks.toSet().toList();

    getOpenOrders?.asks = asks;
    notifyListeners();
  }

  updateOkxBuyData(OkxOrderBook orderBooks) {
    var exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    for (int i = 0; i < (orderBooks.bids ?? []).length; i++) {
      if (orderBooks.bids?[i][1] == "0.00000000") {
        orderBooks.bids?.remove(orderBooks.bids?[i]);
      }
    }
    for (int i = 0; i < (getOpenOrders?.bids ?? []).length; i++) {
      String apiPrice = getOpenOrders?.bids?[i][0];
      for (int j = 0; j < (orderBooks.bids ?? []).length; j++) {
        if (apiPrice == orderBooks.bids?[j][0]) {
          getOpenOrders?.bids?[i] = (orderBooks.bids?[j] ?? []);
        }
      }
    }

    List<List<dynamic>>? bids =
        (getOpenOrders?.bids ?? []) + (orderBooks.bids ?? []);

    bids = List.of(bids)
      ..sort((a, b) => double.parse(a[0])!.compareTo(double.parse(b[0])!));

    bids = bids
        .where((element) =>
            double.parse(element[0]) <=
            double.parse(
                exchangeViewModel.viewModelpriceTickersModel?.first.lastPrice ??
                    "0"))
        .toList();

    bids = bids.toSet().toList();

    getOpenOrders?.bids = bids;
    notifyListeners();
  }

  updateBuyData(OrderBooks orderBooks) {
    var exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    for (int i = 0; i < (orderBooks.b ?? []).length; i++) {
      if (orderBooks.b?[i][1] == "0.00000000") {
        orderBooks.b?.remove(orderBooks.b?[i]);
      }
    }

    for (int i = 0; i < (getOpenOrders?.bids ?? []).length; i++) {
      String apiPrice = getOpenOrders?.bids?[i][0];
      for (int j = 0; j < (orderBooks.b ?? []).length; j++) {
        if (apiPrice == orderBooks.b?[j][0]) {
          getOpenOrders?.bids?[i] = (orderBooks.b?[j] ?? []);
        }
      }
    }

    List<List<dynamic>>? bids =
        (getOpenOrders?.bids ?? []) + (orderBooks.b ?? []);

    bids = List.of(bids!)
      ..sort((a, b) => double.parse(a[0]).compareTo(double.parse(b[0])));

    bids = bids
        .where((element) =>
            double.parse(element[0]) <=
            double.parse(
                exchangeViewModel.viewModelpriceTickersModel?.first.lastPrice ??
                    "0"))
        .toList();

    bids = bids.toSet().toList();

    getOpenOrders?.bids = bids;
    notifyListeners();
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

  void updateTradePair(ListOfTradePairs data) {
    if (data.symbol == tradePair && viewModelpriceTickersModel != null) {
      viewModelpriceTickersModel![0] = data;
    }
    notifyListeners();
  }

  getOrderBookByPairs(String pair, [startSocket = true]) async {
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
          setGetOpenOrders(decodeResponse.data?.result, false, startSocket);
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

  /// set trade pairs
  setPriceTickers(List<ListOfTradePairs>? priceTickers) {
    viewModelpriceTickersModel = priceTickers;
    String currency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    if (currency == "USD") {
      estimateFiatValue =
          double.parse(priceTickers?.first.exchangeRates!.usd ?? "0");
    } else if (currency == "GBP") {
      estimateFiatValue =
          double.parse(priceTickers?.first.exchangeRates!.gbp ?? "0");
    } else {
      estimateFiatValue =
          double.parse(priceTickers?.first.exchangeRates!.eur ?? "0");
    }
    getEstimateFiatValue(tradePair);
    notifyListeners();
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
    notifyListeners();
  }
}
