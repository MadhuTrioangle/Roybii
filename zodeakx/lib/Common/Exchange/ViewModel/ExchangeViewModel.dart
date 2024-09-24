import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Exchange/Model/GetBalance.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/CurrencyPreferenceScreen/Model/CurrencyPreferenceModel.dart';
import '../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../ZodeakX/DashBoardScreen/ViewModel/ExchangeRateViewModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../SplashScreen/ViewModel/SplashViewModel.dart';
import '../Model/CreateOrder.dart';
import '../Model/market_currency_model.dart';

class ExchangeViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool tabView = true;
  bool searchFilterView = false;
  double buySliderValue = 0;
  double sellSliderValue = 0;
  int selectedOrderType = 0;
  dynamic estimateFiatValue = 0;
  dynamic exchangeRate = 0;
  final TextEditingController buyLimitController = TextEditingController();
  final TextEditingController sellLimitController = TextEditingController();
  String pair = "ETH/BTC";
  String fromCurrency = "ETH";
  String toCurrency = "BTC";
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
  String drawerLabel = "ETH";
  bool initSocket = false;
  bool drawerFlag = false;
  List<ListOfTradePairs>? drawerFilteredTradePairs;
  List<ListOfTradePairs>? filteredList;
  List<ListOfTradePairs>? viewModelTradePairs;
  Balance? balance;
  List<DashBoardBalance>? viewModelDashBoardBalance;
  List<ListOfTradePairs>? viewModelpriceTickersModel;
  List<String>? getCoins = [];
  List<String>? getFiats = [];
  List<MarketCurrency>? getCurrency;
  List<FiatCurrency>? viewModelCurrencyPairs;
  List<String> staticPairs = ["ETH", "LTC", "BTC"];
  List<String> otherPairs = [];
  List<String> fiatPairs = [];
  String? alt = "ALT";
  String? fiat = "FIAT";
  late TabController tabController;

  ExchangeViewModel() {
    initSocket = true;
  }

  fetchData() {
    getPriceTickers(pair);
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

  filteredListWithChangePercent() {
    setfilteredTradePairs(List.of(filteredList!)
      ..sort((a, b) => double.parse(a.priceChangePercent!)
          .compareTo(double.parse(b.priceChangePercent!))));
    notifyListeners();
  }

  filteredListWithLastPrice() {
    setfilteredTradePairs(List.of(filteredList!)
      ..sort((a, b) =>
          double.parse(a.lastPrice!).compareTo(double.parse(b.lastPrice!))));
    notifyListeners();
  }

  String getUrl() {
    String url = constant.wssSocketUrl;
    if (!drawerFlag) {
      url += "${pair.replaceAll("/", "").toLowerCase()}@ticker";
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
      setDrawerFlag(false);
    }
    return url;
  }

  restartSocketForDrawer() {
    setDrawerFlag(true);
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.ws?.close();
    marketViewModel.webSocket?.clearListeners();
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

  getExchangeSocket() async {
    initSocket = false;
    if (!constant.binanceStatus.value) {
      getExchangeLocalSocket();
      return;
    }

    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    marketViewModel.ws = await WebSocket.connect(getUrl());
    marketViewModel.ws?.listen(
      (data) {
        TradePairModel tradePairModel =
            TradePairModel.fromJson(json.decode(data));
        updateTradePairs(tradePairModel.data!);
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

    if (createOrder.order_type.toLowerCase() ==
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
    } else if (createOrder.order_type.toLowerCase() ==
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
          response.statusCode == 200
              ? customSnackBar.showSnakbar(
                  context,
                  createOrder.trade_type +
                      " " +
                      response.statusMessage.toString(),
                  SnackbarType.positive)
              : customSnackBar.showSnakbar(context,
                  response.statusMessage.toString(), SnackbarType.negative);
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

  /// set trade pairs
  setTradePairs(List<ListOfTradePairs>? tradePairs) {
    viewModelTradePairs = tradePairs;
    setfilteredTradePairs(tradePairs);
    if (searchFilterView) {
      var filtered = tradePairs!
          .where((element) =>
              element.symbol!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      setDrawerFilteredTradePairs(filtered);
    }
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
    getCoins!.clear();
    getCurrency!.forEach((element) {
      if (element.currencyType == "crypto")
        getCoins!.add(element.currencyCode!);
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
    if (constant.userLoginStatus.value) getDashBoardBalance();
    notifyListeners();
  }

  setData() {
    staticPairs = ["ETH", "LTC", "BTC"];
    otherPairs = [];
    fiatPairs = [];
    List<String> cryptoList = [];
    cryptoList = getCoins ?? [];
    List<String> tempList =
        staticPairs.toSet().intersection(cryptoList.toSet()).toList();
    List<String> otherList = listDiff(tempList, cryptoList);
    tempList = tempList + otherList;
    staticPairs = tempList.take(3).toList();
    getCoins!.forEach((element) {
      (!staticPairs.contains(element)) ? otherPairs.add(element) : () {};
    });
    fiatPairs = getFiats ?? [];
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

  setDrawerFlag(bool value) {
    drawerFlag = value;
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
    setFromCurrency(viewModelpriceTickersModel!.first.symbol!.split('/')[0]);
    setToCurrency(viewModelpriceTickersModel!.first.symbol!.split('/')[1]);
    //buyLimitController.text = viewModelpriceTickersModel!.first.lastPrice.toString();
    //sellLimitController.text = viewModelpriceTickersModel!.first.lastPrice.toString();
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

  setBalance(Balance balance) {
    this.balance = balance;
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

  getDashBoardBalance() async {
    var splashViewModel = Provider.of<SplashViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    splashViewModel.getDefault();
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

  /// pair
  setTradePair(String tradePair) async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    constant.marketPair.value = tradePair;
    pair = tradePair;
    initSocket = true;
    fetchData();
    notifyListeners();
  }

  /// search text
  setSearchText(String text) async {
    searchText = text;
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

  void updateTradePair(ListOfTradePairs data) {
    if (data.symbol == pair) viewModelpriceTickersModel![0] = data;
    if (viewModelTradePairs != null) {
      int index = viewModelTradePairs!
          .indexWhere((element) => element.symbol == data.symbol);
      viewModelTradePairs![index] = data;
    }
    notifyListeners();
  }
}
