import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/Exchange/Model/GetBalance.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/CurrencyPreferenceScreen/Model/CurrencyPreferenceModel.dart';
import '../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../ZodeakX/DashBoardScreen/Model/ExchangeRateModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairOkxModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../OrderBook/Model/OrderBookModel.dart';
import '../../OrderBook/ViewModel/OrderBookViewModel.dart';
import '../../SplashScreen/ViewModel/SplashViewModel.dart';
import '../../TradeView/Model/OkxOrderBookModel.dart';
import '../../TradeView/Model/OrderBooksModel.dart';
import '../Model/AllOpenOrderHistoryModel.dart';
import '../Model/CreateOrder.dart';
import '../Model/FavPairModel.dart';
import '../Model/WalletBalanceModel.dart';
import '../Model/market_currency_model.dart';

class ExchangeViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool tabLoader = true;
  bool tabView = true;
  bool searchFilterView = false;
  double buySliderValue = 0;
  double sellSliderValue = 0;
  int selectedOrderType = 0;
  dynamic estimateFiatValue = 0;
  TabController? tradeTabController;
  dynamic exchangeRate = 0;
  int tradeTabIndex = 0;
  final TextEditingController buyAmountController = TextEditingController();
  final TextEditingController buyLimitController = TextEditingController();
  final TextEditingController sellAmountController = TextEditingController();
  final TextEditingController sellLimitController = TextEditingController();
  List<AllOpenOrderHistory>? allOpenOrderHistory = [];
  String pair = constant.spotDefaultPair.value;
  String fromCurrency = "";
  String toCurrency = "";
  String pairIcon = normalSort;
  String lastPriceIcon = normalSort;
  String h24ChangeIcon = normalSort;
  String searchText = "";
  bool albOrder = true;
  int albCounter = 0;
  bool lastOrder = true;
  int lastCounter = 0;
  bool h24Order = true;
  int h24Counter = 0;
  String drawerLabel = "";
  bool initSocket = false;
  bool drawerFlag = false;
  List<ListOfTradePairs>? drawerFilteredTradePairs;
  List<ListOfTradePairs>? filteredList;
  List<ListOfTradePairs>? viewModelTradePairs;
  List<ListOfTradePairs> favTradePairs = [];
  List<ListOfTradePairs> favFilteredList = [];
  Balance? balance;
  List<DashBoardBalance>? viewModelDashBoardBalance;
  List<ListOfTradePairs>? viewModelpriceTickersModel;
  List<String>? getCoins = [];
  List<String>? getFiats = [];
  List<MarketCurrency>? getCurrency;
  List<FiatCurrency>? viewModelCurrencyPairs;
  List<String> staticPairs = ["USDT", "BTC", "ETH", "LTC"];
  List<String> otherPairs = [];
  List<String> fiatPairs = [];
  String alt = stringVariables.alt.toUpperCase();
  String fiat = stringVariables.fiat.toUpperCase();
  late TabController tabController;
  bool marginAccountFlag = false;
  bool isCross = true;
  bool isBeforeCross = true;
  List<String> decimals = ["0.000001", "0.00001", "0.0001", "0.001"];
  List<bool> viewFilter = [true, false, false];
  String selectedDecimals = "0.000001";
  List<String> orderBook = [
    stringVariables.defaultText,
    stringVariables.buyOrders,
    stringVariables.sellOrders
  ];
  String buySpotOrder = stringVariables.limit;

  List<String> orderType = [
    stringVariables.limit,
    stringVariables.markets,
    // stringVariables.stopLimit,
    //  stringVariables.trailingStop
  ];
  bool autoBorrowFlag = false;
  bool autoRepayFlag = false;
  List<FavPair> favPair = [];
  bool isFav = false;
  bool keyboardVisibility = false;
  int callBackRate = 1;
  int drawerIndex = 0;

  String sellSpotOrder = stringVariables.limit;

  // ExchangeViewModel() {
  //   initSocket = true;
  //  autoBorrowFlag = constant.pref?.getBool("autoBorrowMargin") ?? false;
  //   autoRepayFlag = constant.pref?.getBool("autoRepayMargin") ?? false;
  // }

  ExchangeViewModel() {}

  fetchData() {
    // setPairCurrency();
    getPriceTickers(pair);
    getExchangeSocket();
  }

  // setPairCurrency() {
  //   pair = constant.spotDefaultPair.value;
  // }

  setKeyboardVisibility(bool visiblity) async {
    keyboardVisibility = visiblity;
    notifyListeners();
  }

  leaveSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.ws?.close();
    marketViewModel.webSocket?.clearListeners();
    initSocket = true;
  }

  List<ListOfTradePairs>? getFilteredList(String pair) {
    return (filteredList ?? [])
        .where((element) => (element.symbol!.split("/").first == pair ||
            element.symbol!.split("/").last == pair))
        .toList();
  }

  filteredListWithPair() {
    setfilteredTradePairs(
        List.of(filteredList!)..sort((a, b) => a.symbol!.compareTo(b.symbol!)));
    notifyListeners();
  }

  favListWithPair() {
    setFavTradePairs(List.of(favFilteredList!)
      ..sort((a, b) => a.symbol!.compareTo(b.symbol!)));
  }

  filteredListWithChangePercent() {
    setfilteredTradePairs(List.of(filteredList!)
      ..sort((a, b) => double.parse(a.priceChangePercent!)
          .compareTo(double.parse(b.priceChangePercent!))));
    notifyListeners();
  }

  favListWithChangePercent() {
    setFavTradePairs(List.of(favFilteredList!)
      ..sort((a, b) => double.parse(a.priceChangePercent!)
          .compareTo(double.parse(b.priceChangePercent!))));
  }

  filteredListWithLastPrice() {
    setfilteredTradePairs(List.of(filteredList!)
      ..sort((a, b) =>
          double.parse(a.lastPrice!).compareTo(double.parse(b.lastPrice!))));
    notifyListeners();
  }

  favListWithLastPrice() {
    setFavTradePairs(List.of(favFilteredList!)
      ..sort((a, b) =>
          double.parse(a.lastPrice!).compareTo(double.parse(b.lastPrice!))));
  }

  String getUrl() {
    String url = constant.wssSocketUrl;
    if (!drawerFlag) {
      url += "${pair.replaceAll("/", "").toLowerCase()}@ticker/";
      url += "${pair.replaceAll("/", "").toLowerCase()}@depth";
    } else {
      List<ListOfTradePairs>? listOfTradePairs =
          (drawerLabel == alt || drawerLabel == fiat)
              ? viewModelTradePairs?.take(15).toList()
              : getFilteredList(drawerLabel);
      for (int i = 0; i < (listOfTradePairs ?? []).length; i++) {
        url +=
            "${listOfTradePairs?[i].symbol?.replaceAll("/", "").toLowerCase()}" +
                "@ticker${(i == (listOfTradePairs ?? []).length - 1) ? "" : "/"}";
      }
    }
    return url;
  }

  restartSocketForDrawer() {
    var commonViewModel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    commonViewModel.getLiquidityStatus("ExchangeView");
    getExchangeSocket();
  }

  continueSocketForDrawer() {
    setDrawerFlag(false);
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.ws?.close();
    marketViewModel.webSocket?.clearListeners();
    getExchangeSocket();
  }

  getExchangeLocalSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var orderBookViewModel = Provider.of<OrderBookViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    marketViewModel.webSocket?.on("tradeOpenOrders_$pair", (data) {
      var decodeResponse = HandleResponse.completed(OpenOrders.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          orderBookViewModel.setGetOpenOrders(decodeResponse.data, true);
          break;
        default:
          break;
      }
    });

    viewModelTradePairs?.forEach((element) {
      marketViewModel.webSocket?.on('trade_pair_${element.symbol}', (data) {
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
    });

    marketViewModel.setViewModel(this);
  }

  okxSocket() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var orderBookViewModel = Provider.of<OrderBookViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocketChannel = WebSocketChannel.connect(
      Uri.parse(constant.wssSocketOkxUrl),
    );
    if (!drawerFlag) {
      String tradePair = pair.replaceAll("/", "-");
      var channels = {
        "op": "subscribe",
        "args": [
          {"channel": "tickers", "instId": pair.replaceAll("/", "-")},
          {"channel": "books", "instId": pair.replaceAll("/", "-")},
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
          if (constant.okxStatus.value) {
            if (tradePairOkxModel.data!.isNotEmpty) {
              if (okxOrderBookModel.arg?.instId.toString() ==
                  pair.replaceAll("/", "-")) {
                updateOkxTradePairs(tradePairOkxModel.data!.first);
                orderBookViewModel
                    .updateOkxOpenOrder(okxOrderBookModel.data!.first);
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
      List<ListOfTradePairs>? listOfTradePairs =
          (drawerLabel == alt || drawerLabel == fiat)
              ? viewModelTradePairs?.take(15).toList()
              : getFilteredList(drawerLabel);
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
      marketViewModel.webSocketChannel.sink.add(
        jsonEncode(channels),
      );
      marketViewModel.webSocketChannel.stream.listen(
        (data) {
          //securedPrint(data);
          TradePairOkxModel tradePairOkxModel =
              TradePairOkxModel.fromJson(json.decode(data));
          if (tradePairOkxModel.data!.isNotEmpty) {
            updateOkxTradePairs(tradePairOkxModel.data!.first);
          }
        },
        onError: (error) {},
        onDone: () => {},
      );
    }
    notifyListeners();
  }

  unSubscribeAllTradePairsChannel() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    List allPairChannels = [];
    Map<String, Object>? channels;
    List<ListOfTradePairs>? listOfTradePairs =
        (drawerLabel == alt || drawerLabel == fiat)
            ? viewModelTradePairs?.take(15).toList()
            : getFilteredList(drawerLabel);
    for (int i = 0; i < (listOfTradePairs ?? []).length; i++) {
      allPairChannels.add({
        "channel": "tickers",
        "instId": listOfTradePairs?[i].symbol?.replaceAll("/", "-")
      });
      //securedPrint("allPairChannels$allPairChannels");
      channels = {
        "op": "unsubscribe",
        "args": allPairChannels,
      };
    }
    // securedPrint("channels$channels");
    await marketViewModel.webSocketChannel?.sink.close();
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
      ]
    };
    marketViewModel.webSocketChannel.sink.add(
      jsonEncode(channels),
    );
    await marketViewModel.webSocketChannel.sink.close();
  }

  getExchangeSocket() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    initSocket = false;

    getSpotBalanceSocket(marketViewModel);
    getMarginOpenOrders(marketViewModel);

    if (!constant.binanceStatus.value && !constant.okxStatus.value) {
      getExchangeLocalSocket();
    } else if (constant.binanceStatus.value) {
      binanceSocket();
    } else if (constant.okxStatus.value) {
      okxSocket();
    }

    marketViewModel.setViewModel(this);
  }

  getMarginOpenOrders(MarketViewModel marketViewModel) {
    String sessionId = constant.pref?.getString("sessionId") ?? "";
    marketViewModel.webSocket?.on("myMarginOpenOrders_$sessionId", (data) {
      securedPrint("dataaa");
      securedPrint(data['orders']);

      var orders = data['orders']; //3 open order

      var id = data['id'];
      Map<String, dynamic> openOrders = {
        'status_message': "Fetched From API",
        'status_code': 200,
        'result': orders,
        '__typename': 'openOrders'
      };
      var decodeResponse = HandleResponse.completed(
          AllOpenOrderHistoryModel.fromJson(openOrders));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          setAllOpenOrderHistory(decodeResponse.data?.result ?? [], true);
          break;
        default:
          //setLoading(false);
          break;
      }
    });
  }

  binanceSocket() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var orderBookViewModel = Provider.of<OrderBookViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.ws = await WebSocket.connect(getUrl());
    marketViewModel.ws?.listen(
      (data) {
        // securedPrint("data>>>>>${data}");
        if (constant.binanceStatus.value) {
          if (json.decode(data)["stream"].contains("ticker")) {
            TradePairModel tradePairModel =
                TradePairModel.fromJson(json.decode(data));
            if (json
                .decode(data)["stream"]
                .contains(pair.replaceAll("/", "").toLowerCase())) {
              updateTradePairs(tradePairModel.data);
            } else {}
          } else if (json.decode(data)["stream"].contains("depth")) {
            OrderBooksModel orderBooksModel =
                OrderBooksModel.fromJson(json.decode(data));
            if (json
                .decode(data)["stream"]
                .contains(pair.replaceAll("/", "").toLowerCase())) {
              orderBookViewModel.updateOpenOrder(orderBooksModel.data!);
            } else {}
          }
        }
      },
      onDone: () {
        marketViewModel.ws?.close();
        marketViewModel.ws = null;
      },
      onError: (error) {
        marketViewModel.ws?.close();
        marketViewModel.ws = null;
      },
    );
    notifyListeners();
  }

  updateOkxTradePairs(OkxTradePairs okxTradePairModel) {
    OkxTradePairs? okxTradePair = okxTradePairModel;
    viewModelpriceTickersModel?.forEach((element) {
      if (element.symbol?.replaceAll("/", "-").toUpperCase() ==
          okxTradePair.instId) {
        element.lastPrice = okxTradePair.last;
        element.quoteVolume = okxTradePair.vol24H;
        element.priceChangePercent =
            ((double.parse(okxTradePair.last.toString()) -
                        double.parse(okxTradePair.open24H.toString())) *
                    100 /
                    double.parse(okxTradePair.open24H.toString()))
                .toString();
        element.priceChange = (double.parse(okxTradePair.last.toString()) -
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.highPrice = okxTradePair.high24H;
        element.lowPrice = okxTradePair.low24H;
        estimateFiatValue = double.parse(element.lastPrice.toString()) *
            double.parse("${exchangeRate ?? 0.0}");
      } else {
        //securedPrint("hiii");
      }
    });
    viewModelTradePairs?.forEach((element) {
      if (element.symbol?.replaceAll("/", "-").toUpperCase() ==
          okxTradePair.instId) {
        element.lastPrice = okxTradePair.last;
        element.quoteVolume = okxTradePair.vol24H;
        element.priceChangePercent =
            ((double.parse(okxTradePair.last.toString()) -
                        double.parse(okxTradePair.open24H.toString())) *
                    100 /
                    double.parse(okxTradePair.open24H.toString()))
                .toString();
        element.priceChange = (double.parse(okxTradePair.last.toString()) -
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.highPrice = okxTradePair.high24H;
        element.lowPrice = okxTradePair.low24H;
      } else {
        //securedPrint("hiii");
      }
    });
    notifyListeners();
  }

  updateTradePairs(TradePair tradePairModel) {
    TradePair? tradePair = tradePairModel;
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
    viewModelTradePairs?.forEach((element) {
      if (element.symbol?.replaceAll("/", "").toUpperCase() == tradePair?.s) {
        element.lastPrice = tradePair?.c;
        element.quoteVolume = tradePair?.q;
        element.priceChangePercent = tradePair?.P;
        element.priceChange = tradePair?.p;
        element.highPrice = tradePair?.h;
        element.lowPrice = tradePair?.l;
      }
    });
    notifyListeners();
  }

  createOrder(
    BuildContext context,
    CreateOrder createOrder,
  ) async {
    Map<String, dynamic> mutateUserParams;

    if (createOrder.order_type!.toLowerCase() ==
        stringVariables.limit.toLowerCase()) {
      mutateUserParams = {
        "data": {
          "order_type": createOrder.order_type,
          "trade_type": createOrder.trade_type,
          "pair": createOrder.pair,
          "market_price": createOrder.market_price,
          "amount": createOrder.amount,
          "total": createOrder.total
        }
      };
    } else if (createOrder.order_type!.toLowerCase() ==
        stringVariables.stopLimit.toLowerCase()) {
      mutateUserParams = {
        "data": {
          "order_type": createOrder.order_type,
          "trade_type": createOrder.trade_type,
          "pair": createOrder.pair,
          "stop_price": createOrder.stop_price,
          "limit_price": createOrder.limit_price,
          "amount": createOrder.amount,
          "total": createOrder.total
        }
      };
    } else {
      mutateUserParams = {
        "data": {
          "order_type": createOrder.order_type,
          "trade_type": createOrder.trade_type,
          "pair": createOrder.pair,
          "amount": createOrder.amount,
        }
      };
    }

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.createOrder(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          customSnackBar.showSnakbar(
              context,
              response.statusMessage.toString(),
              response.statusCode == 200
                  ? SnackbarType.positive
                  : SnackbarType.negative);
          fetchData();
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

  createMarginOrder(
    BuildContext context,
    CreateOrder createOrder,
  ) async {
    Map<String, dynamic> queryData = {
      "order_type": createOrder.order_type,
      "trade_type": createOrder.trade_type,
      "pair": createOrder.pair,
      "amount": createOrder.amount
    };

    if (createOrder.order_type != stringVariables.markets) {
      queryData["total"] = createOrder.total;
      queryData["market_price"] = createOrder.market_price;
    }

    Map<String, dynamic> mutateUserParams = {"data": queryData};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.createMarginOrder(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCreateMarginOrder(decodeResponse.data);
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

  setCreateMarginOrder(CommonModel? result) {
    if (result?.statusCode == 200) {
      if (tradeTabIndex == 0) {
        getBalance(pair);
      }
    }
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        '${result?.statusMessage}',
        result?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (result?.statusCode == 200) {
      sellAmountController.clear();
      buyAmountController.clear();
    }
    notifyListeners();
  }

  /// set trade pairs
  setTradePairs(List<ListOfTradePairs>? tradePairs) {
    viewModelTradePairs = tradePairs;
    setfilteredTradePairs(tradePairs);
    if (constant.userLoginStatus.value) getUserFavTradePair();
    if (searchFilterView) {
      var filtered = tradePairs!
          .where((element) =>
              element.symbol!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      setDrawerFilteredTradePairs(filtered);
    }
    OrderBookViewModel orderBookViewModel = Provider.of<OrderBookViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    orderBookViewModel.tradePairs.clear();
    viewModelTradePairs!.forEach((element) {
      orderBookViewModel.tradePairs.add(element.symbol!);
    });
    orderBookViewModel.setTradePair(pair);
    orderBookViewModel
        .setSelectedTradePair(orderBookViewModel.tradePairs.indexOf(pair));

    getEstimateFiatValue(pair);
    if (initSocket) {
      getExchangeSocket();
      initSocket = false;
    }
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
    getCryptoCurrency();
    notifyListeners();
  }

  /// Get Crypto Currency
  getCryptoCurrency() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getMarketCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCryptoCurrency(
            decodeResponse.data?.result,
          );
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

  /// set  Crypto Currency
  setCryptoCurrency(
    List<MarketCurrency>? CryptoCurrency,
  ) {
    getCurrency = CryptoCurrency;
    getCoins?.clear();
    getCurrency!.forEach((element) {
      if (element.currencyType == "crypto") {
        getCoins!.add(element.currencyCode!);
      }
    });

    getFiatCurrency();
    notifyListeners();
  }

  /// Get FiatCurrency
  getFiatCurrency() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchFiatCurrency();
      var decodeResponse = HandleResponse.completed(response);
      // response.result?.first.currencyCode =
      //     constant.pref?.getString("defaultFiatCurrency") ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFiatCurrency(decodeResponse.data?.result);
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

  /// set FiatCurrency
  setFiatCurrency(List<FiatCurrency>? fiatCurrency) {
    viewModelCurrencyPairs = fiatCurrency;
    getFiats!.clear();
    for (var currencyPairs in viewModelCurrencyPairs ?? []) {
      getFiats!.add('${currencyPairs.currencyCode}');
    }
    setData();
    setLoading(false);
    if (constant.userLoginStatus.value) {
      getDashBoardBalance();
    } else {
      setTabLoader(false);
    }

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
    selectedDecimals = decimals[0];
  }

  setData() {
    staticPairs = ["USDT", "BTC", "ETH", "LTC"];
    otherPairs = [];
    fiatPairs = [];
    List<String> cryptoList = [];
    cryptoList = getCoins ?? [];
    //  List<String> tempList = staticPairs.toSet().intersection(cryptoList.toSet()).toList();
    //  List<String> otherList = listDiff(tempList, cryptoList);
    //  tempList = tempList + otherList;
    //  staticPairs = tempList.take(4).toList();
    securedPrint("staticPairs${staticPairs}");
    getCoins!.forEach((element) {
      (!staticPairs.contains(element)) ? otherPairs.add(element) : () {};
    });
    fiatPairs = getFiats ?? [];
    notifyListeners();
  }

  List<T> listDiff<T>(List<T> l1, List<T> l2) => (l1.toSet()..addAll(l2))
      .where((i) => !l1.contains(i) || !l2.contains(i))
      .toList();

  /// set trade pairs
  setDrawerFilteredTradePairs(List<ListOfTradePairs>? tradePairs) {
    drawerFilteredTradePairs = tradePairs;
    notifyListeners();
  }

  /// set trade pairs
  setfilteredTradePairs(List<ListOfTradePairs>? tradePairs) {
    filteredList = tradePairs;
    notifyListeners();
  }

  setFavTradePairs(List<ListOfTradePairs> tradePairs) {
    favFilteredList = tradePairs;
    notifyListeners();
  }

  setDrawerFlag(bool value) {
    drawerFlag = value;
    notifyListeners();
  }

  setBuySpotOrder(String value) {
    buySpotOrder = value;
    notifyListeners();
  }

  setSellSpotOrder(String value) {
    sellSpotOrder = value;
    notifyListeners();
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
    changeDecimals();
    setFromCurrency(viewModelpriceTickersModel!.first.symbol!.split('/')[0]);
    setToCurrency(viewModelpriceTickersModel!.first.symbol!.split('/')[1]);
    buyLimitController.text = trimDecimalsForBalance(
        viewModelpriceTickersModel!.first.lastPrice.toString());
    sellLimitController.text = trimDecimalsForBalance(
        viewModelpriceTickersModel!.first.lastPrice.toString());

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

    notifyListeners();
    getTradePairs();
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

  /// set dashBoardBalance
  setDashboardBalance(List<DashBoardBalance>? dashBoardBalance) {
    viewModelDashBoardBalance = dashBoardBalance;
    notifyListeners();
    getBalance(pair);
  }

  setBalance(Balance? balance, [bool isSocket = false]) {
    this.balance = balance;
    if (!isSocket) fetchAllOpenOrderHistory();
    notifyListeners();
  }

  getBalance(String pair) async {
    Map<String, dynamic> params = {
      "data": {"pair": pair, "loggedIn": true}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getBalance(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setBalance(decodeResponse.data!.result);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  getSpotBalanceSocket(MarketViewModel commonViewModel) {
    String sessionId = constant.pref?.getString("sessionId") ?? "";
    commonViewModel.webSocket?.on("walletBalance_$sessionId", (data) {
      String fromCurrency = pair.split("/").first;
      String toCurrency = pair.split("/").last;
      var id = data['socket_id'];
      var firstCurrency = data[fromCurrency];
      var secondCurrency = data[toCurrency];
      Map<String, dynamic> walletBalance = {
        'socket_id': id,
        'firstCurrency': firstCurrency,
        'secondCurrency': secondCurrency
      };
      var decodeResponse =
          HandleResponse.completed(WalletBalanceModel.fromJson(walletBalance));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          num fcurr = decodeResponse.data?.firstCurrency?.amount ?? 0;
          num scurr = decodeResponse.data?.secondCurrency?.amount ?? 0;
          Balance balance = Balance(fcurr: fcurr, scurr: scurr, sTypename: '');
          setBalance(balance, true);
          break;
        default:
          //setLoading(false);
          break;
      }
    });
  }

  getDashBoardBalance() async {
    var splashViewModel = Provider.of<SplashViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    splashViewModel.getDefault(false);
    constant.pref?.setString("defaultCryptoCurrency",
        splashViewModel.defaultCurrency?.cryptoDefaultCurrency ?? "");
    constant.cryptoCurrency.value =
        constant.pref?.getString("defaultCryptoCurrency") ?? '';
    String? fiatCurrency =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';
    Map<String, dynamic> mutateUserParams = {
      "data": {"default_currency": fiatCurrency}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchDashBoardBalance(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setDashboardBalance(decodeResponse.data?.result);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  fetchAllOpenOrderHistory([String? type]) async {
    Map<String, dynamic> allHistoryData = {"margin_order": type != null};
    if (type != null) allHistoryData["margin_type"] = type;
    Map<String, dynamic> mutateUserParams = {"allHistoryData": allHistoryData};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.allOpenOrderHistory(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setAllOpenOrderHistory(decodeResponse.data?.result);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  setAllOpenOrderHistory(List<AllOpenOrderHistory>? result,
      [bool isSocket = false]) {
    allOpenOrderHistory?.clear();
    for (int i = 0; i < result!.length; i++) {
      print(result.length);
      print(result[i].orderType);
      print(result[i].marginType);
      if (result[i].orderType != stringVariables.markets ||
          result[i].marginType != "Cross") {
        allOpenOrderHistory = result ?? [];
      }
    }

    tabLoader = false;
    notifyListeners();
  }

  getUserFavTradePair() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getUserFavTradePair();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUserFavTradePair(decodeResponse.data?.result);
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

  setUserFavTradePair(List<FavPair>? result) {
    favPair.clear();
    favPair = result ?? [];
    List<String> favPairList = [];
    favPair.forEach((element) {
      favPairList.add(element.pair ?? "");
    });
    favTradePairs = (viewModelTradePairs ?? [])
        .where((element) => favPairList.contains(element.symbol))
        .toList();
    favFilteredList = favTradePairs;
    isFav = favPairList.contains(pair);
    notifyListeners();
  }

  updateFavTradePair() async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"pair": pair, "loggedIn": true}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.updateFavTradePair(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUpdateFavTradePair(decodeResponse.data ?? CommonModel());
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

  setUpdateFavTradePair(CommonModel commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200) {
      getUserFavTradePair();
    }
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Loader
  setAlt(String value) async {
    alt = value;
    notifyListeners();
  }

  /// Loader
  setFiat(String value) async {
    fiat = value;
    notifyListeners();
  }

  /// Loader
  setTabView(bool tab) async {
    tabView = tab;
    notifyListeners();
  }

  setMarginAccountFlag(bool value) async {
    marginAccountFlag = value;
    notifyListeners();
  }

  setIsCross(bool value) async {
    isCross = value;
    notifyListeners();
  }

  setIsBeforeCross(bool value) async {
    isBeforeCross = value;
    notifyListeners();
  }

  /// pair
  setTradePair(String tradePair) async {
    pair = tradePair;
    buyAmountController.clear();
    sellAmountController.clear();
    initSocket = true;
    fetchData();
    notifyListeners();
  }

  /// search text
  setSearchText(String text) async {
    searchText = text;
    notifyListeners();
  }

  setTabLoader(bool value) async {
    tabLoader = value;
    notifyListeners();
  }

  setDrawerIndex(int value) async {
    drawerIndex = value;
    notifyListeners();
  }

  /// alb flag
  setAlbOrder(bool flag) async {
    albOrder = flag;
    notifyListeners();
  }

  /// alb count
  setAlbCount(int count) async {
    albCounter = count;
    notifyListeners();
  }

  /// last flag
  setLastOrder(bool flag) async {
    lastOrder = flag;
    notifyListeners();
  }

  /// last count
  setLastCount(int count) async {
    lastCounter = count;
    notifyListeners();
  }

  /// alb flag
  set24HOrder(bool flag) async {
    h24Order = flag;
    notifyListeners();
  }

  /// alb count
  set24HCount(int count) async {
    h24Counter = count;
    notifyListeners();
  }

  setDrawerLabel(String label) async {
    drawerLabel = label;
    notifyListeners();
  }

  /// From Currency
  setFromCurrency(String from) async {
    fromCurrency = from;
    notifyListeners();
  }

  /// To Currency
  setToCurrency(String to) async {
    toCurrency = to;
    notifyListeners();
  }

  /// pair icon
  setPairIcon(String icon) async {
    pairIcon = icon;
    notifyListeners();
  }

  /// last price icon
  setLastPriceIcon(String icon) async {
    lastPriceIcon = icon;
    notifyListeners();
  }

  /// last price icon
  set24hChangeIcon(String icon) async {
    h24ChangeIcon = icon;
    notifyListeners();
  }

  /// Loader
  setsearchFilterView(bool search) async {
    searchFilterView = search;
    notifyListeners();
  }

  /// Buy Slider
  setBuySliderValue(double value) async {
    buySliderValue = value;
    notifyListeners();
  }

  /// Sell Slider
  setSellSliderValue(double value) async {
    sellSliderValue = value;
    notifyListeners();
  }

  /// SelectOrderType
  setOrderType(int type) async {
    selectedOrderType = type;
    notifyListeners();
  }

  setTradeTabIndex(int value) async {
    tradeTabIndex = value;
    notifyListeners();
  }

  setSelectedDecimals(String value) async {
    selectedDecimals = value;
    notifyListeners();
  }

  setViewFilter(List<bool> filter) async {
    viewFilter = filter;
    notifyListeners();
  }

  void updateTradePair(ListOfTradePairs data) {
    if (data.symbol == pair) viewModelpriceTickersModel![0] = data;
    if (viewModelTradePairs != null) {
      int index = viewModelTradePairs!
          .indexWhere((element) => element.symbol == data.symbol);
      viewModelTradePairs![index] = data;
    }
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    tabLoader = true;
    tabView = true;
    searchFilterView = false;
    buySliderValue = 0;
    sellSliderValue = 0;
    selectedOrderType = 0;
    estimateFiatValue = 0;
    exchangeRate = 0;
    pair = "ETH/BTC";
    fromCurrency = "ETH";
    toCurrency = "BTC";
    pairIcon = normalSort;
    lastPriceIcon = normalSort;
    h24ChangeIcon = normalSort;
    searchText = "";
    albOrder = true;
    albCounter = 0;
    lastOrder = true;
    lastCounter = 0;
    h24Order = true;
    h24Counter = 0;
    drawerLabel = "ETH";
    initSocket = false;
    drawerFlag = false;
    isFav = false;
    drawerFilteredTradePairs = null;
    filteredList = null;
    viewModelTradePairs = null;
    balance = null;
    viewModelDashBoardBalance = null;
    viewModelpriceTickersModel = null;
    ;
    getCoins = [];
    getFiats = [];
    getCurrency = null;
    viewModelCurrencyPairs = null;
    staticPairs = ["USDT", "BTC", "ETH", "LTC"];
    otherPairs = [];
    fiatPairs = [];
    alt = "ALT";
    fiat = "FIAT";
    marginAccountFlag = false;
    isCross = true;
    isBeforeCross = true;

    tradeTabIndex = 0;

    allOpenOrderHistory = [];

    decimals = ["0.000001", "0.00001", "0.0001", "0.001"];
    viewFilter = [true, false, false];
    selectedDecimals = "0.000001";
    orderBook = [
      stringVariables.defaultText,
      stringVariables.buy,
      stringVariables.sell
    ];
    buySpotOrder = stringVariables.limit;
    sellSpotOrder = stringVariables.limit;

    autoBorrowFlag = true;
    autoRepayFlag = false;
  }
}
