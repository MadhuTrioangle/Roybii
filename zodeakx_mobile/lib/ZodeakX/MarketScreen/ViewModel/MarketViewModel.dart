import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Common/LoginScreen/ViewModel/LoginViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/Model/TradePairOkxModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/NewModel/GetFavouriteMarkets.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/NewModel/GetSpotMarkets.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../Common/Exchange/Model/market_currency_model.dart';
import '../../../Common/IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import '../../../Common/Repositories/CommonRepository.dart';
import '../../../Common/SplashScreen/ViewModel/SplashViewModel.dart';
import '../../../Common/Wallets/CoinDetailsModel/get_currency.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../main.dart';
import '../../../p2p/ads/view_model/p2p_ads_view_model.dart';
import '../../../p2p/common_view/view_model/p2p_common_view_model.dart';
import '../../../p2p/counter_parties_profile/view_model/p2p_counter_profile_view_model.dart';
import '../../../p2p/home/view_model/p2p_home_view_model.dart';
import '../../../p2p/order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../../p2p/orders/view_model/p2p_order_view_model.dart';
import '../../../p2p/payment_methods/view_model/p2p_payment_methods_view_model.dart';
import '../../../p2p/profile/view_model/p2p_profile_view_model.dart';
import '../../CurrencyPreferenceScreen/ViewModel/CurrencyPreferenceViewModel.dart';
import '../Model/TradePairModel.dart';

class MarketViewModel extends ChangeNotifier {
  socket.Socket? webSocket;
  late WebSocketChannel webSocketChannel;
  final streamController = StreamController.broadcast();
  bool initSocket = false;
  WebSocket? ws;
  List<GetCurrency>? getCurrencies;
  late final messageHandler;
  late TabController spotTabController;
  List<GetSpotMarket>? btcSearchSpotMarketsResult;
  CommonModel? commonModel;
  bool noInternet = false;
  bool needToLoad = true;
  List<ListOfTradePairs>? viewModelTradePairs;
  List<ListOfTradePairs>? socketTradePairs;
  bool loginStatus = false;
  bool isvisible = false;
  CommonModel? logout;
  String? token;
  bool serverError = false;
  dynamic viewModel;
  int listRange = 10;
  bool mlmValue = false;
  List<GetSpotMarket>? usdtSpotMarkets;
  List<GetSpotMarket>? btcSpotMarkets;
  List<GetSpotMarket>? ethSpotMarkets;
  List<GetSpotMarket>? altSpotMarkets;
  List<GetSpotMarket>? fiatSpotMarkets;
  List<MarginTrade>? spotFavouriteTrade;
  FavoriteAllMarketsModelClass? favoriteAllMarketsModelClass;
  TextEditingController searchController = TextEditingController();
  bool searchControllerText = false;
  List<String> defaultCurrencies = [];
  List<String> defaultCurrenciesCards = [];
  List<String> defaultCurrenciesFiatCards = [];
  List<MarketCurrency>? getMarketCurrency;
  int spotTabControllerIndex = 5;
  List<GetSpotMarket>? socketPairs = [];
  String selectedMarketCurrency = stringVariables.alt;
  String selectedMarketFiatCurrency = stringVariables.fiat;
  List<Map<String, dynamic>> LoginArray = [
    {
      "title": stringVariables.dashboard,
      "logo": dashboardImage,
    },
    {
      "title": stringVariables.currencies,
      "logo": currencyImage,
    },
    {
      "title": stringVariables.market,
      "logo": marketImage,
    },
    {
      "title": stringVariables.trades,
      "logo": tradeIcon,
    },
    {
      "title": stringVariables.wallet,
      "logo": walletImage,
    },
    {
      "title": stringVariables.convert,
      "logo": swap,
    },
    {
      "title": stringVariables.bankDetails,
      "logo": bankDetailsImage,
    },
    {
      "title": stringVariables.orders,
      "logo": orderImage,
    },
    {
      "title": stringVariables.security,
      "logo": securityImage,
    },
    {
      "title": stringVariables.setting,
      "logo": settingImage,
    },
    {
      "title": stringVariables.referral,
      "logo": referralImage,
    },
    {
      "title": stringVariables.language,
      "logo": language,
    },
  ];

  List<Map<String, dynamic>> LogoutArray = [
    {
      "title": stringVariables.logIn,
      "logo": loginImage,
    },
    {
      "title": stringVariables.createAccount,
      "logo": user_circle,
    },
  ];

  setSpotIndex(int val) {
    spotTabControllerIndex = val;
    notifyListeners();
  }

  setSelectedMarketCurrency(String value) {
    selectedMarketCurrency = value;
    notifyListeners();
  }

  setSelectedMarketFiatCurrency(String value) {
    selectedMarketFiatCurrency = value;
    notifyListeners();
  }

  setsearchControllerText(bool value) async {
    searchControllerText = value;
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setMlmStatus(bool value) {
    mlmValue = value;
    notifyListeners();
  }

  /// ViewModel
  setViewModel(dynamic value) async {
    viewModel = value;
  }

  setListRange(int value) {
    listRange = value;
    notifyListeners();
  }

  ///logout
  getlogout(CommonModel? devicelogout) {
    logout = devicelogout;
    if (devicelogout?.statusCode == 200) {
      constant.userLoginStatus.value = false;
      constant.pref?.setBool('loginStatus', false);
      constant.pref?.setString("userEmail", "${constant.appEmail}");
      clearAllData();
      clearP2PData();
      logoutFromGoogle();
      moveToMarket(NavigationService.navigatorKey.currentContext!);
    }

    notifyListeners();
  }

  clearAllData() {
    var splashViewModel = Provider.of<SplashViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var currencyPreferenceViewModel = Provider.of<CurrencyPreferenceViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    currencyPreferenceViewModel.setCurrency(
        splashViewModel.defaultCurrency?.fiatDefaultCurrency ?? "GBP");
    var identityVerificationCommonViewModel =
        Provider.of<IdentityVerificationCommonViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    identityVerificationCommonViewModel.index = 0;
    identityVerificationCommonViewModel.setActive(
        NavigationService.navigatorKey.currentContext!, 0);
    var exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    exchangeViewModel.clearData();
    var loginViewModel = Provider.of<LoginViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    loginViewModel.clearData();
    identityVerificationCommonViewModel.clearData();
    notifyListeners();
  }

  logoutFromGoogle() {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          Platform.isIOS ? constant.googleIosClientId : constant.googleClientId,
      //   scopes: [
      //    'email',
      //    'https://www.googleapis.com/auth/contacts.readonly',
      //      //you can add extras if you require
      // ],
    );
    _googleSignIn.signOut();
  }

  clearP2PData() {
    if (constant.p2pStatus) {
      var p2PCommonViewModel = Provider.of<P2PCommonViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2PCommonViewModel.clearData();
      var p2PHomeViewModel = Provider.of<P2PHomeViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2PHomeViewModel.clearData();
      var p2POrderViewModel = Provider.of<P2POrderViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2POrderViewModel.clearData();
      var p2PAdsViewModel = Provider.of<P2PAdsViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2PAdsViewModel.clearData();
      var p2PProfileViewModel = Provider.of<P2PProfileViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2PProfileViewModel.clearData();
      var p2POrderCreationViewModel = Provider.of<P2POrderCreationViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2POrderCreationViewModel.clearData();
      var p2PPaymentMethodsViewModel = Provider.of<P2PPaymentMethodsViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2PPaymentMethodsViewModel.clearData();
      var p2PCounterProfileViewModel = Provider.of<P2PCounterProfileViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      p2PCounterProfileViewModel.clearData();
    }
  }

  ///Icon visiblity
  void setVisible() {
    isvisible = !isvisible;
    notifyListeners();
  }

  /// initilizing API
  MarketViewModel() {
    getUserLogginStatus();
    listenSockets();

    p2pStatus();

    initSocket = true;
  }

  p2pStatus() {
    if (constant.p2pStatus) {
      LoginArray.insert(4, {
        "title": stringVariables.p2p,
        "logo": p2pMenu,
      });
      LogoutArray.add({
        "title": stringVariables.p2p,
        "logo": p2pMenu,
      });
    }
  }

  // /// set trade pairs
  // setTradePairs(List<ListOfTradePairs>? tradePairs) {
  //   viewModelTradePairs = tradePairs;
  //   if ((tradePairs ?? []).length < listRange) {
  //     setListRange((tradePairs ?? []).length);
  //   }
  //   socketTradePairs = tradePairs?.getRange(0, listRange).toList();
  //   notifyListeners();
  //   callSocket();
  // }

  // callSocket() {
  //   if (initSocket) {
  //     getMarketSocket();
  //     initSocket = false;
  //     getCurrency();
  //   } else {
  //     setLoading(false);
  //   }
  //   notifyListeners();
  // }

  getMarketLocalSocket() {
    socketPairs?.forEach((element) {
      webSocket?.on('trade_pair_${element.pair}', (data) {
        var decodeResponse =
            HandleResponse.completed(ListOfTradePairs.fromJson(data));
        switch (decodeResponse.status?.index) {
          case 0:
            //setLoading(false);
            break;
          case 1:
            updateTradePair(decodeResponse.data!);
            //setLoading(false);
            break;
          default:
            //setLoading(false);
            break;
        }
      });
    });

    setViewModel(this);
  }

  updateSocketTradePairs(int type) {
    if (type == 0) {
      socketTradePairs =
          viewModelTradePairs?.getRange((listRange - 10), listRange).toList();

      initSocket = false;
    } else if (type == 1) {
      int added = 10;
      if (((viewModelTradePairs ?? []).length - listRange) < added) {
        added = (viewModelTradePairs ?? []).length - listRange;
        listRange = (viewModelTradePairs ?? []).length;
      }
      int range = (listRange + added);
      if (range > (viewModelTradePairs ?? []).length) {
        listRange = (viewModelTradePairs ?? []).length - 10;
        return;
      }
      socketTradePairs =
          viewModelTradePairs?.getRange(listRange, range).toList();

      initSocket = false;
    }
    notifyListeners();
  }

  String getUrl() {
    String url = constant.wssSocketUrl;
    securedPrint("socketPairs${socketPairs?.length}");
    for (int i = 0; i < (socketPairs ?? []).length; i++) {
      url += "${socketPairs?[i].pair?.replaceAll("/", "").toLowerCase()}" +
          "@ticker${(i == (socketPairs ?? []).length - 1) ? "" : "/"}";
    }
    return url;
  }

  unSubscribeChannel() async {
    List allPairChannels = [];
    Map<String, Object>? channels;
    for (int i = 0; i < (socketPairs ?? []).length; i++) {
      allPairChannels.add({
        "channel": "tickers",
        "instId": socketPairs?[i].pair?.replaceAll("/", "-")
      });
      channels = {
        "op": "unsubscribe",
        "args": allPairChannels,
      };
    }
    webSocketChannel.sink.close();
  }

  okxSocket() {
    webSocketChannel = WebSocketChannel.connect(
      Uri.parse(constant.wssSocketOkxUrl),
    );
    List allPairChannels = [];
    Map<String, Object>? channels;
    for (int i = 0; i < (socketPairs ?? []).length; i++) {
      allPairChannels.add({
        "channel": "tickers",
        "instId": socketPairs?[i].pair?.replaceAll("/", "-")
      });
      channels = {
        "op": "subscribe",
        "args": allPairChannels,
      };
    }
    webSocketChannel.sink.add(
      jsonEncode(channels),
    );
    webSocketChannel.stream.listen(
      (data) {
        // securedPrint(data);
        TradePairOkxModel tradePairOkxModel =
            TradePairOkxModel.fromJson(json.decode(data));
        if (tradePairOkxModel.data!.isNotEmpty) {
          updateOkxTradePairs(tradePairOkxModel.data!.first);
        } else {}
      },
      onError: (error) {},
      onDone: () => {},
    );
  }

  getTradeSocket() {
    final channel = WebSocketChannel.connect(
      Uri.parse(constant.wssSocketOkxUrl),
    );
    String pair = "ETH-USDT";
    var channels = {
      "op": "subscribe",
      "args": [
        {"channel": "trades", "instId": pair},
      ]
    };
    channel.sink.add(
      jsonEncode(channels),
    );
    channel.stream.listen(
      (data) {
        // securedPrint(data);
      },
      onError: (error) => securedPrint(error),
      onDone: () => {},
    );
  }

  getMarketSocket() async {
    initSocket = false;
    if (!constant.binanceStatus.value && !constant.okxStatus.value) {
      getMarketLocalSocket();
    } else if (constant.binanceStatus.value) {
      binanceSocket();
    } else if (constant.okxStatus.value) {
      okxSocket();
    }

    setViewModel(this);
  }

  binanceSocket() async {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    marketViewModel.ws = await WebSocket.connect(getUrl());
    securedPrint("getUrl()${getUrl()}");
    marketViewModel.ws?.listen(
      (data) {
        // securedPrint(data);
        TradePairModel tradePairModel =
            TradePairModel.fromJson(json.decode(data));
        updateTradePairs(tradePairModel.data);
      },
      onDone: () {
        marketViewModel.ws?.close();
        securedPrint("closed");
      },
      onError: (error) {
        marketViewModel.ws?.close();
      },
    );
  }

  updateTradePairs(TradePair tradePairModel) {
    TradePair? tradePair = tradePairModel;

    btcSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() == tradePair.s) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });
    usdtSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() == tradePair.s) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });
    ethSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() == tradePair.s) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });
    altSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() == tradePair.s) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });
    fiatSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() == tradePair.s) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });
    spotFavouriteTrade?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() == tradePair.s) {
        element.price = tradePair.c;
        element.changePercent = tradePair.P;
        element.volume24H = tradePair.q;
      }
    });

    notifyListeners();
  }

  updateOkxTradePairs(OkxTradePairs okxTradePairModel) {
    OkxTradePairs? okxTradePair = okxTradePairModel;

    btcSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() ==
          okxTradePair.instId) {
        element.price = okxTradePair.last;
        element.changePercent = ((double.parse(okxTradePair.last.toString()) -
                    double.parse(okxTradePair.open24H.toString())) *
                100 /
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.volume24H = okxTradePair.vol24H;
      }
    });
    ethSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() ==
          okxTradePair.instId) {
        element.price = okxTradePair.last;
        element.changePercent = ((double.parse(okxTradePair.last.toString()) -
                    double.parse(okxTradePair.open24H.toString())) *
                100 /
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.volume24H = okxTradePair.vol24H;
      }
    });
    usdtSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() ==
          okxTradePair.instId) {
        element.price = okxTradePair.last;
        element.changePercent = ((double.parse(okxTradePair.last.toString()) -
                    double.parse(okxTradePair.open24H.toString())) *
                100 /
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.volume24H = okxTradePair.vol24H;
      }
    });
    altSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() ==
          okxTradePair.instId) {
        element.price = okxTradePair.last;
        element.changePercent = ((double.parse(okxTradePair.last.toString()) -
                    double.parse(okxTradePair.open24H.toString())) *
                100 /
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.volume24H = okxTradePair.vol24H;
      }
    });
    fiatSpotMarkets?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() ==
          okxTradePair.instId) {
        element.price = okxTradePair.last;
        element.changePercent = ((double.parse(okxTradePair.last.toString()) -
                    double.parse(okxTradePair.open24H.toString())) *
                100 /
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.volume24H = okxTradePair.vol24H;
      }
    });
    spotFavouriteTrade?.forEach((element) {
      if (element.pair?.replaceAll("/", "").toUpperCase() ==
          okxTradePair.instId) {
        element.price = okxTradePair.last;
        element.changePercent = ((double.parse(okxTradePair.last.toString()) -
                    double.parse(okxTradePair.open24H.toString())) *
                100 /
                double.parse(okxTradePair.open24H.toString()))
            .toString();
        element.volume24H = okxTradePair.vol24H;
      }
    });


    notifyListeners();
  }

  ///Get Currency
  getCurrency() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCurrency(decodeResponse.data?.result);
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

  /// set Crypto Withdraw
  setCurrency(List<GetCurrency>? getCryptoCurrency) {
    getCurrencies = getCryptoCurrency;
    notifyListeners();
  }

  ///Toggle Button
  bool active = themeSupport().isSelectedDarkMode() ? true : false;

  toggleStatus(bool value, BuildContext context) {
    MyApp.of(context)?.toggleDarkMode();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness: checkBrightness.value == Brightness.dark
                ? Brightness.light
                : Brightness.dark) // Or Brightness.dark
        );
    active = value;
    saveTheme(active);
    notifyListeners();
  }

  /// sabe theme
  void saveTheme(bool value) async {
    constant.pref?.setBool('userSelectedTheme', value);
  }

  removeListner() {
    dispose();
  }

  leaveFromSocket(BuildContext context, [bool isBankDetails = false]) {
    var listenViewModel = Provider.of<LoginViewModel>(context, listen: false);
    var commonViewmodel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    if (isBankDetails) listenViewModel.openPage();
    listenViewModel.closeFocus();
    if (commonViewmodel.id == 0) {
      constant.previousScreen.value = ScreenType.Market;
    }
    leaveSocket();
  }

  /// sideMenu navigation
  navigation(int index, List<Map<String, dynamic>> sideMenuList,
      BuildContext context) {
    var commonViewmodel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    var exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    String clickedItem = sideMenuList[index]["title"];
    if (clickedItem == stringVariables.dashboard) {
      moveToDashBoard(context);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.currencies) {
      moveToCurrency(context);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.market) {
      Scaffold.of(context).closeDrawer();
      commonViewmodel.setActive(0);
    } else if (clickedItem == stringVariables.trades) {
      Scaffold.of(context).closeDrawer();
      exchangeViewModel.setTradePair(constant.spotDefaultPair.value);
      commonViewmodel.setActive(1);
    } else if (clickedItem == stringVariables.wallet) {
      Scaffold.of(context).closeDrawer();
      commonViewmodel.setActive(3);
    } else if (clickedItem == stringVariables.bankDetails) {
      moveToBankDetails(context);
      leaveFromSocket(context, true);
    } else if (clickedItem == stringVariables.orders) {
      Scaffold.of(context).closeDrawer();
      commonViewmodel.setActive(2);
    } else if (clickedItem == stringVariables.security) {
      moveToSecurity(
        context,
      );
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.setting) {
      moveToSetting(context);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.referral) {
      moveToReferral(context);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.logIn) {
      moveToRegister(context, true);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.createAccount) {
      moveToRegister(context, true);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.p2p) {
      moveToP2P(context);
    } else {}
  }

  leaveSocket() {
    webSocket?.clearListeners();
    ws?.close();
    initSocket = true;
  }

  getUserLogginStatus() {
    var token =
        constant.pref?.getString("userToken") ?? constant.userToken.value;
    loginStatus = constant.pref?.getBool("loginStatus") ?? false;
    constant.userEmail.value = constant.pref?.getString("userEmail") ?? '';
    constant.userToken.value = token;
    constant.userLoginStatus.value = loginStatus;
  }

  /// Listen Sockets

  listenSockets() async {
    webSocket = socket.io(
        constant.baseSocketUrl,
        socket.OptionBuilder()
            .setExtraHeaders(<String, dynamic>{
              'authorization': "bearer ${constant.userToken.value}",
              'withCredentials': false
            })
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    print("connectyy${webSocket?.connected}");
    webSocket?.connect();

    print("ectyy${webSocket?.connected}");
    webSocket?.onConnect((_) {
      securedPrint(
          'connect: ${webSocket?.connected} socketLink: ${webSocket?.io.uri} socket_ID ${webSocket?.id}');
      webSocket?.onDisconnect((data) => securedPrint("disconnected"));
      webSocket?.onConnectError((data) => securedPrint("connect_error: $data"));
      webSocket
          ?.onConnectTimeout((data) => securedPrint("connect_timeout: $data"));
      webSocket?.onConnecting((data) => securedPrint("connecting: $data"));
      webSocket?.onError((data) => securedPrint("error: $data"));
      webSocket?.onReconnect((data) => securedPrint("reconnect: $data"));
      webSocket?.onReconnectAttempt(
          (data) => securedPrint("reconnect_attempt: $data"));
      webSocket?.onReconnectFailed(
          (data) => securedPrint("reconnect_failed: $data"));
      webSocket
          ?.onReconnectError((data) => securedPrint("reconnect_error: $data"));
      webSocket?.onReconnecting((data) => securedPrint("reconnecting: $data"));
      webSocket?.onPing((data) => securedPrint("ping: $data"));
      webSocket?.onPong((data) => securedPrint("pong: $data"));
      webSocket?.onError((data) => securedPrint('øøøø $data'));
      webSocket?.on('room_test', (data) => securedPrint('øøøø $data'));
    });
    webSocket?.onError((data) => securedPrint('øøøø $data'));
    webSocket?.onDisconnect((data) => securedPrint("disconnected"));
  }

  void updateTradePair(ListOfTradePairs data) {
    int index = viewModelTradePairs!
        .indexWhere((element) => element.symbol == data.symbol);
    viewModelTradePairs![index] = data;
    notifyListeners();
  }

  /// Get TradePairs
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
          serverError = false;
          // (decodeResponse.data?.statusCode != 10001)
          //     ? setTradePairs(decodeResponse.data?.result)
          //     : serverError = true;
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

  /// get deviceLogout Details
  logoutUser(String token) async {
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      'input': {"token": token}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutatelogoutUser(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getlogout(decodeResponse.data as CommonModel);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      setLoading(true);
    }
  }

  getSpotMarket(String currency) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"to_currency": currency}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchSpotMarketPair(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          serverError = false;
          (decodeResponse.data?.statusCode != 10001)
              ? setSpotMarket(decodeResponse.data?.result, currency)
              : serverError = true;
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

  setSpotMarket(List<GetSpotMarket>? result, String currency) {
    if (currency == defaultCurrencies[0]) {
      btcSpotMarkets = result;
      btcSearchSpotMarketsResult = result ?? [];
    } else if (currency == defaultCurrencies[1]) {
      usdtSpotMarkets = result;
      btcSearchSpotMarketsResult = result ?? [];
    } else if (currency == defaultCurrencies[2]) {
      ethSpotMarkets = result;
      btcSearchSpotMarketsResult = result ?? [];
    } else if (currency == selectedMarketCurrency) {
      altSpotMarkets = result;
      btcSearchSpotMarketsResult = result ?? [];
    } else if (currency == selectedMarketFiatCurrency) {
      fiatSpotMarkets = result;
      btcSearchSpotMarketsResult = result ?? [];
    }
    setSocketPairs(btcSearchSpotMarketsResult);
    notifyListeners();
  }

  setSocketPairs(List<GetSpotMarket>? result) {
    socketPairs = result;
    // getMarketSocket();
    notifyListeners();
  }

  getFav() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchFavouriteMarket();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFav(decodeResponse.data);
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

  setFav(FavoriteAllMarketsModelClass? data) {
    favoriteAllMarketsModelClass = data;
    spotFavouriteTrade = favoriteAllMarketsModelClass?.result?.spot;
 //   marginFavouriteTrade = favoriteAllMarketsModelClass?.result?.margin;
 //   futureFavouriteTrade = favoriteAllMarketsModelClass?.result?.future;
    notifyListeners();
  }

  /// update fav pair - spot and margin

  updateFavTradePair(String pair, bool isFav, String market) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"pair": pair, "loggedIn": isFav}
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
          setUpdateFavTradePair(decodeResponse.data ?? CommonModel(), market);
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

  setUpdateFavTradePair(CommonModel commonModel, String market) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel.statusMessage ?? "",
        commonModel.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel.statusCode == 200) {
      if (market == "favourite") {
        getFav();
      } else {
        for (var element in defaultCurrencies) {
          if (element == market) {
            getSpotMarket(element);
          }
        }

        for (var element in defaultCurrenciesFiatCards) {
          if (element == market) {
            getSpotMarket(element);
          }
        }
      }
    }
  }

  /// update fav pair - future

  updateFavSymbol(String contract, String market) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"symbol": contract}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.updateFavSymbol(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFavSymbol(decodeResponse.data, market);
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

  setFavSymbol(CommonModel? data, String market) {
    commonModel = data;
    CustomSnackBar().showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        '${commonModel?.statusMessage}',
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (market == "favourite") {
      getFav();
    }
    notifyListeners();
  }

  getMarketCurrencies() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getMarketCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setMarketCurrency(
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

  setMarketCurrency(
    List<MarketCurrency>? CryptoCurrency,
  ) {
    getMarketCurrency = CryptoCurrency;
    defaultCurrencies.clear();
    defaultCurrenciesCards.clear();
    defaultCurrenciesFiatCards.clear();
    getMarketCurrency!.forEach((element) {
      if (element.currencyType == "crypto") {
        defaultCurrencies.add(element.currencyCode!);
        defaultCurrenciesCards.add(element.currencyCode!);
      } else if (element.currencyType == "fiat") {
        defaultCurrenciesFiatCards.add(element.currencyCode!);
      }
    });
    securedPrint(
        "defaultCurrenciesFiatCards${defaultCurrenciesFiatCards.length}");
    if (defaultCurrencies.length > 2) {
      defaultCurrenciesCards.remove(defaultCurrencies[0]);
      defaultCurrenciesCards.remove(defaultCurrencies[1]);
      defaultCurrenciesCards.remove(defaultCurrencies[2]);
    }
    if (defaultCurrenciesFiatCards.isNotEmpty) {
      setSpotIndex(4);
    }
    getSpotMarket(defaultCurrencies[0]);
    notifyListeners();
  }
}
