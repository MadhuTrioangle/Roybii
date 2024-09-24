import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zodeakx_mobile/Common/TradeView/Model/OkxTradeHistoryModel.dart';

import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../ZodeakX/DashBoardScreen/Model/ExchangeRateModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairOkxModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../Common/ViewModel/common_view_model.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../OrderBook/Model/OrderBookModel.dart';
import '../Model/OkxOrderBookModel.dart';
import '../Model/OrderBooksModel.dart';
import '../Model/TradeHistoryModel.dart';
import '../Model/TradesHistoryModel.dart';

class TradeViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  String pair = "";
  OpenOrders? getOpenOrders;
  List<TradesHistory> tradeHistory = [];
  List<TradesHistory> yoursTradeHistory = [];
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
  bool buySellFlag = true;
  bool loaderForChart = true;
  List<String> decimals = ["0.000001", "0.00001", "0.0001", "0.001"];
  int drawerIndex = 0;
  bool drawerFlag = false;
  List<String> tradePairs = ["ETH/BTC", "LTC/ETH", "BTC/LTC"];
  List<ListOfTradePairs>? listOfTradePairs;
  List<Map<String, dynamic>> formattedValueForNative = [];
  var SAMPLE_TRADE_SYMBOLS = [];

  setDrawerFlag(bool value) async {
    drawerFlag = value;
    notifyListeners();
  }

  TradeViewModel() {
    initSocket = true;
    getTradePairs();
  }

  fetchData() {
    getOrderBookByPairs(pair);
  }

  restartSocketForDrawer() {
    var commonViewModel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    commonViewModel.getLiquidityStatus("TradeView");
    // getTradeSocket();
  }

  setWebLoad(bool value) async {
    webLoad = value;
    notifyListeners();
  }

  setLoaderForChart(bool value) async {
    loaderForChart = value;
    notifyListeners();
  }

  /// Loader
  setsearchFilterView(bool search) async {
    searchFilterView = search;
    notifyListeners();
  }

  setBuySellFlag(bool flag) async {
    buySellFlag = await flag;
    notifyListeners();
  }

  /// search text
  setSearchText(String text) async {
    searchText = text;
    notifyListeners();
  }

  setDrawerIndex(int value) async {
    drawerIndex = value;
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

  unSubscribeAllTradePairsChannel() async {
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    List allPairChannels = [];
    Map<String, Object>? channels;
    for (int i = 0;
        i < (exchangeViewModel.viewModelTradePairs ?? []).length;
        i++) {
      allPairChannels.add({
        "channel": "tickers",
        "instId": exchangeViewModel.viewModelTradePairs?[i].symbol
            ?.replaceAll("/", "-")
      });
      channels = {
        "op": "unsubscribe",
        "args": allPairChannels,
      };
    }
    await marketViewModel.webSocketChannel.sink.close();
  }

  String getUrl() {
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    String url = constant.wssSocketUrl;
    securedPrint("drawerFlag${drawerFlag}");
    if (drawerFlag) {
      for (int i = 0;
          i < (exchangeViewModel.viewModelTradePairs ?? []).length;
          i++) {
        url += "${exchangeViewModel.viewModelTradePairs?[i].symbol?.replaceAll("/", "").toLowerCase()}" +
            "@ticker${(i == (exchangeViewModel.viewModelTradePairs ?? []).length - 1) ? "" : "/"}";
      }
    } else {
      url += "${pair.replaceAll("/", "").toLowerCase()}@ticker/";
      url += "${pair.replaceAll("/", "").toLowerCase()}@depth/";
      url += "${pair.replaceAll("/", "").toLowerCase()}@trade/";
      url += "${pair.replaceAll("/", "").toLowerCase()}@kline_1d";
    }
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

    marketViewModel.setViewModel(this);
  }

  getTradeSocket() async {
    initSocket = false;
    if (!constant.binanceStatus.value && !constant.okxStatus.value) {
      getTradeLocalSocket();
    } else if (constant.binanceStatus.value) {
      binanceSocket();
    } else if (constant.okxStatus.value) {
      okxSocket();
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

    // marketViewModel.ws = await WebSocket.connect(getUrl());
    // marketViewModel.ws?.listen(
    //   (data) {
    //     if (json.decode(data)["stream"].contains("ticker")) {
    //       TradePairModel tradePairModel =
    //           TradePairModel.fromJson(json.decode(data));
    //       updateTradePairs(tradePairModel.data!);
    //     } else if (json.decode(data)["stream"].contains("trade")) {
    //       TradeHistoryModel tradeHistoryModel =
    //           TradeHistoryModel.fromJson(json.decode(data));
    //       updateTradeHistory(tradeHistoryModel.data!);
    //     } else if (json.decode(data)["stream"].contains("depth")) {
    //       OrderBooksModel orderBooksModel =
    //           OrderBooksModel.fromJson(json.decode(data));
    //       updateOpenOrder(orderBooksModel.data!);
    //     }
    //   },
    //   onDone: () {
    //     marketViewModel.ws?.close();
    //   },
    //   onError: (error) {
    //     marketViewModel.ws?.close();
    //   },
    // );

    marketViewModel.setViewModel(this);
  }

  binanceSocket() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.ws = await WebSocket.connect(getUrl());
    securedPrint("getUrl()${getUrl()}");
    marketViewModel.ws?.listen(
      (data) {
        // securedPrint("data$data");
        if (json.decode(data)["stream"].contains("ticker")) {
          TradePairModel tradePairModel =
              TradePairModel.fromJson(json.decode(data));
          if (json
              .decode(data)["stream"]
              .contains(pair.replaceAll("/", "").toLowerCase())) {
            updateTradePairs(tradePairModel.data);
          } else {}
        } else if (json.decode(data)["stream"].contains("trade")) {
          TradeHistoryModel tradeHistoryModel =
              TradeHistoryModel.fromJson(json.decode(data));
          if (json
              .decode(data)["stream"]
              .contains(pair.replaceAll("/", "").toLowerCase())) {
            updateTradeHistory(tradeHistoryModel.data!);
          } else {}
        } else if (json.decode(data)["stream"].contains("depth")) {
          OrderBooksModel orderBooksModel =
              OrderBooksModel.fromJson(json.decode(data));
          if (json
              .decode(data)["stream"]
              .contains(pair.replaceAll("/", "").toLowerCase())) {
            updateOpenOrder(orderBooksModel.data!);
          } else {}
        }
      },
      onDone: () {
        marketViewModel.ws?.close();
      },
      onError: (error) {
        marketViewModel.ws?.close();
      },
    );
  }

  updateOkxOpenOrder(OkxOrderBook data) {
    updateOkxBuyData(data);
    updateOkxSellData(data);
  }

  updateOkxBuyData(OkxOrderBook orderBooks) {
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
            double.parse(viewModelpriceTickersModel?.first.lastPrice ?? "0"))
        .toList();

    bids = bids.toSet().toList();

    getOpenOrders?.bids = bids;
    notifyListeners();
  }

  updateOkxSellData(OkxOrderBook orderBooks) {
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
            double.parse(viewModelpriceTickersModel?.first.lastPrice ?? "0"))
        .toList();

    asks = asks.toSet().toList();

    getOpenOrders?.asks = asks;
    notifyListeners();
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
    notifyListeners();
  }

  updateBuyData(OrderBooks orderBooks) {
    orderBooks.b?.removeWhere((element) =>
        (element[1] == "0.00000000" || num.parse(element[1].toString()) == 0));

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

    bids?.removeWhere((element) => double.parse(element[1]) == 0);

    getOpenOrders?.bids = bids;
  }

  updateTradeHistory(TradeHistory tradeHistory) {
    TradesHistory tradesHistory = TradesHistory(
      price: tradeHistory.p,
      qty: tradeHistory.q,
      side: (tradeHistory.dataM ?? false) ? "Sell" : "Buy",
    );
    this.tradeHistory.insert(0, tradesHistory);
    setTradeHistory(this.tradeHistory.take(100).toList(), true);
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

  /// Loader
  setGetOpenOrders(OpenOrders? openOrders, [isSocket = false]) async {
    getOpenOrders = openOrders;
    securedPrint("getOpenOrders${getOpenOrders}");
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

  okxSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocketChannel = WebSocketChannel.connect(
      Uri.parse(constant.wssSocketOkxUrl),
    );
    if (!drawerFlag) {
      var channels = {
        "op": "subscribe",
        "args": [
          {"channel": "tickers", "instId": pair.replaceAll("/", "-")},
          {"channel": "books", "instId": pair.replaceAll("/", "-")},
          {"channel": "trades", "instId": pair.replaceAll("/", "-")},
        ]
      };
      marketViewModel.webSocketChannel.sink.add(
        jsonEncode(channels),
      );

      marketViewModel.webSocketChannel.stream.listen(
        (data) {
          // securedPrint(data);
          TradePairOkxModel tradePairOkxModel =
              TradePairOkxModel.fromJson(json.decode(data));
          OkxOrderBookModel okxOrderBookModel =
              OkxOrderBookModel.fromJson(json.decode(data));
          OkxTradeHistoryModel okxTradeHistoryModel =
              OkxTradeHistoryModel.fromJson(json.decode(data));
          // securedPrint("instId${okxOrderBookModel.arg?.instId.toString()}");

          if (okxOrderBookModel.arg?.channel.toString() == "books") {
            if (okxOrderBookModel.data!.isNotEmpty) {
              if (okxOrderBookModel.arg?.instId.toString() ==
                  pair.replaceAll("/", "-")) {
                updateOkxOpenOrder(okxOrderBookModel.data!.first);
              }
            }
          }
          if (tradePairOkxModel.arg?.channel.toString() == "tickers") {
            if (tradePairOkxModel.data!.isNotEmpty) {
              if (okxOrderBookModel.arg?.instId.toString() ==
                  pair.replaceAll("/", "-")) {
                updateOkxTradePairs(tradePairOkxModel.data!.first);
              }
            }
          }
          if (okxTradeHistoryModel.arg?.channel.toString() == "trades") {
            if (okxTradeHistoryModel.data!.isNotEmpty) {
              if (okxOrderBookModel.arg?.instId.toString() ==
                  pair.replaceAll("/", "-")) {
                TradeHistory tradesHistory = TradeHistory(
                  p: okxTradeHistoryModel.data!.first.px,
                  q: okxTradeHistoryModel.data!.first.sz,
                  dataM: okxTradeHistoryModel.data!.first.side == "sell"
                      ? true
                      : false,
                );
                updateTradeHistory(tradesHistory);
              }
            }
          }
        },
        onError: (error) => securedPrint(error),
        onDone: () => {},
      );
    } else {
      List allPairChannels = [];
      Map<String, Object>? channels;
      //securedPrint("socketTradePairs$listOfTradePairs");
      for (int i = 0; i < (listOfTradePairs ?? []).length; i++) {
        allPairChannels.add({
          "channel": "tickers",
          "instId": listOfTradePairs?[i].symbol?.replaceAll("/", "-")
        });
        channels = {
          "op": "subscribe",
          "args": allPairChannels,
        };
      }
      //  securedPrint("channels$channels");
      marketViewModel.webSocketChannel.sink.add(
        jsonEncode(channels),
      );
      marketViewModel.webSocketChannel.stream.listen(
        (data) {
          // securedPrint(data);
          TradePairOkxModel tradePairOkxModel =
              TradePairOkxModel.fromJson(json.decode(data));
          if (tradePairOkxModel.data!.isNotEmpty) {
            updateOkxTradePairs(tradePairOkxModel.data!.first);
          }
        },
        onError: (error) {
          // securedPrint(error);
        },
        onDone: () => {},
      );
    }
  }

  updateOkxTradePairs(OkxTradePairs okxTradePairs) {
    viewModelpriceTickersModel?.forEach((element) {
      if (element.symbol?.replaceAll("/", "-").toUpperCase() ==
          okxTradePairs.instId) {
        element.lastPrice = okxTradePairs.last;
        element.quoteVolume = okxTradePairs.vol24H;
        element.priceChangePercent =
            ((double.parse(okxTradePairs.last.toString()) -
                        double.parse(okxTradePairs.open24H.toString())) *
                    100 /
                    double.parse(okxTradePairs.open24H.toString()))
                .toString();
        element.priceChange = (double.parse(okxTradePairs.last.toString()) -
                double.parse(okxTradePairs.open24H.toString()))
            .toString();
        element.highPrice = okxTradePairs.high24H;
        element.lowPrice = okxTradePairs.low24H;
        estimateFiatValue = double.parse(element.lastPrice.toString()) *
            double.parse("${exchangeRate ?? 0.0}");
      }
    });
    notifyListeners();
  }

  unSubscribeChannel() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    String tradePair = pair.replaceAll("/", "-");
    var channels = {
      "op": "unsubscribe",
      "args": [
        {"channel": "tickers", "instId": pair.replaceAll("/", "-")},
        {"channel": "books", "instId": pair.replaceAll("/", "-")},
        {"channel": "trades", "instId": pair.replaceAll("/", "-")},
      ]
    };
    marketViewModel.webSocketChannel.sink.add(
      jsonEncode(channels),
    );
    await marketViewModel.webSocketChannel.sink.close();
  }

  /// Loader
  setTradeHistory(List<TradesHistory>? history, [isSocket = false]) async {
    tradeHistory = history ?? [];
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
    this.yoursTradeHistory = history ?? [];
    notifyListeners();
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
    changeDecimals();
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

  changeDecimals() {
    String lastPrice = viewModelpriceTickersModel!.first.lastPrice ?? "";
    if (lastPrice.split(".").first.length == 1 ||
        lastPrice.split(".").first.length == 2) {
      decimals = ["0.000001", "0.00001", "0.0001", "0.001"];
    } else if (lastPrice.split(".").first.length == 3) {
      decimals = ["0.00001", "0.0001", "0.001", "0.01"];
    } else if (lastPrice.split(".").first.length == 4) {
      decimals = ["0.0001", "0.001", "0.01", "0.1"];
    } else if (lastPrice.split(".").first.length == 5) {
      decimals = ["0.001", "0.01", "0.1"];
    } else if (lastPrice.split(".").first.length == 6) {
      decimals = ["0.01", "0.1"];
    } else {
      decimals = ["0.1"];
    }
    selectedDecimal = decimals[0];
  }

  /// pair
  setTradePair(String tradePair) async {
    String value = constant.isLive ? "prod" : "demo";
    var dark = checkBrightness.value == Brightness.dark ? "Dark" : "Light";
    pair = tradePair;
    notifyListeners();
    initSocket = true;
    webViewController?.evaluateJavascript(
        source:
            'TradeViewChart("Zodeakx","${pair}",${constant.binanceStatus.value},${constant.okxStatus.value},${SAMPLE_TRADE_SYMBOLS},"$value","${constant.baseUrl}","${constant.baseSocketUrl}")');
    securedPrint("dark2${dark}");
    Future.delayed(Duration(milliseconds: 500), () async {
      webViewController?.evaluateJavascript(
          source: 'changeTradeViewTheme("$dark")');
    });
    setWebLoad(true);
    fetchData();
  }

  getTradePairs() async {
   
    Map<String, dynamic> mutateUserParams = {"data": {}};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchTradePairs(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setTradePairs(decodeResponse.data?.result);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          stringVariables.internetNotAvailable, SnackbarType.negative);
      notifyListeners();
    }
  }

  setTradePairs(List<ListOfTradePairs>? tradePairs) {
    this.listOfTradePairs = tradePairs;
    this.tradePairs.clear();
    listOfTradePairs!.forEach((element) {
      this.tradePairs.add(element.symbol!);
    });
    if (!initSocket) {
      initSocket = true;
      getTradeSocket();
    }
    SAMPLE_TRADE_SYMBOLS.clear();
    this.tradePairs.forEach(
      (element) {
        var a = json.encode({
          "symbol": element,
          "full_name": "Zodeakx:$element",
          "description": element,
          "exchange": "Zodeakx",
          "type": "crypto"
        });
        SAMPLE_TRADE_SYMBOLS.add(a);
      },
    );
    print(SAMPLE_TRADE_SYMBOLS.length);
    notifyListeners();
  }
}
