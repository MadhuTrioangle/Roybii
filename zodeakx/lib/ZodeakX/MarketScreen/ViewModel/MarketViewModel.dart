import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket;
import 'package:zodeakx_mobile/Common/BankDetails/ViewModel/BankDetailsViewModel.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/LoginScreen/ViewModel/LoginViewModel.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../Common/Repositories/CommonRepository.dart';
import '../../../Common/SplashScreen/ViewModel/SplashViewModel.dart';
import '../../../Common/Wallets/CoinDetailsModel/get_currency.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../main.dart';
import '../../../p2p/ads/view_model/p2p_ads_view_model.dart';
import '../../../p2p/common_view/view_model/p2p_common_view_model.dart';
import '../../../p2p/counter_parties_profile/view_model/p2p_counter_profile_view_model.dart';
import '../../../p2p/home/view_model/p2p_home_view_model.dart';
import '../../../p2p/order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../../p2p/orders/view_model/p2p_order_view_model.dart';
import '../../../p2p/payment_methods/view_model/p2p_payment_methods_view_model.dart';
import '../../../p2p/profile/view_model/p2p_profile_view_model.dart';
import '../../../staking/home_page/viewModel/home_page_view_model.dart';
import '../../../staking/stacking_creation/viewModel/stacking_creation_view_model.dart';
import '../../CurrencyPreferenceScreen/ViewModel/CurrencyPreferenceViewModel.dart';
import '../Model/TradePairModel.dart';

class MarketViewModel extends ChangeNotifier {
  socket.Socket? webSocket;
  bool initSocket = false;
  WebSocket? ws;
  List<GetCurrency>? getCurrencies;
  late final messageHandler;
  final List<Map<String, dynamic>> LogoutArray = [
    {
      "title": stringVariables.logIn,
      "logo": loginImage,
    },
    {
      "title": stringVariables.createAccount,
      "logo": user_circle,
    },
  ];
  final List<Map<String, dynamic>> LoginArray = [
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
      "title": stringVariables.exchange,
      "logo": exchangeImage,
    },
    {
      "title": stringVariables.wallet,
      "logo": walletImage,
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
    // {
    //   "title": stringVariables.contactCustomerSupport,
    //   "logo": referralImage,
    // },
  ];

  bool noInternet = false;
  bool needToLoad = true;
  List<ListOfTradePairs>? viewModelTradePairs;
  List<ListOfTradePairs>? socketTradePairs;
  bool loginStatus = false;
  bool isvisible = true;
  CommonModel? logout;
  String? token;
  bool serverError = false;
  dynamic? viewModel;
  int listRange = 10;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// ViewModel
  setViewModel(dynamic value) async {
    viewModel = value;
    notifyListeners();
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
      constant.marketPair.value = "ETH/BTC";
      constant.pref?.setBool('loginStatus', false);
      constant.pref?.setString("userEmail", "${constant.appEmail}");
      var splashViewModel = Provider.of<SplashViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      var currencyPreferenceViewModel =
          Provider.of<CurrencyPreferenceViewModel>(
              NavigationService.navigatorKey.currentContext!,
              listen: false);
      currencyPreferenceViewModel.setCurrency(
          splashViewModel.defaultCurrency?.fiatDefaultCurrency ?? "GBP");
    }
    clearP2PData();
    clearStackData();
    notifyListeners();
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

  clearStackData(){
    var stackingHomePageViewModel = Provider.of<StackingHomePageViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    stackingHomePageViewModel.clearData();
    var stackingCreationViewModel = Provider.of<StackingCreationViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    stackingHomePageViewModel.clearData();
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
    stakingStatus();
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

  stakingStatus() {
    if (constant.stakingStatus) {
      LoginArray.insert(4, {
        "title": stringVariables.staking,
        "logo": stakingMenu,
      });
    }
  }

  /// set trade pairs
  setTradePairs(List<ListOfTradePairs>? tradePairs) {
    viewModelTradePairs = tradePairs;
    if ((tradePairs ?? []).length < listRange)
      setListRange((tradePairs ?? []).length);
    socketTradePairs = tradePairs?.getRange(0, listRange).toList();
    notifyListeners();
    if (initSocket) {
      getMarketSocket();
      initSocket = false;
      getCurrency();
    } else {
      setLoading(false);
    }
  }

  getMarketLocalSocket() {
    viewModelTradePairs?.forEach((element) {
      webSocket?.on('trade_pair_${element.symbol}', (data) {
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
      leaveSocket();
      getMarketSocket();
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
      leaveSocket();
      getMarketSocket();
      initSocket = false;
    }
    notifyListeners();
  }

  String getUrl() {
    String url = constant.wssSocketUrl;
    for (int i = 0; i < (socketTradePairs ?? []).length; i++) {
      url +=
          "${socketTradePairs?[i].symbol?.replaceAll("/", "").toLowerCase()}" +
              "@ticker${(i == (socketTradePairs ?? []).length - 1) ? "" : "/"}";
    }
    return url;
  }

  getMarketSocket() async {
    initSocket = false;
    if (!constant.binanceStatus.value) {
      getMarketLocalSocket();
      return;
    }
    ws = await WebSocket.connect(getUrl());
    ws?.listen(
      (data) {
        TradePairModel tradePairModel =
            TradePairModel.fromJson(json.decode(data));
        updateTradePairs(tradePairModel.data!);
      },
      onDone: () {
        ws?.close();
      },
      onError: (error) {
        ws?.close();
      },
    );

    setViewModel(this);
  }

  updateTradePairs(TradePair tradePairModel) {
    TradePair? tradePair = tradePairModel;
    viewModelTradePairs?.forEach((element) {
      if (element.symbol?.replaceAll("/", "").toUpperCase() == tradePair?.s) {
        element.lastPrice = tradePair?.c;
        element.quoteVolume = tradePair?.q;
        element.priceChangePercent = tradePair?.P;
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
    this.dispose();
  }

  leaveFromSocket(BuildContext context, [bool isBankDetails = false]) {
    var listenViewModel = Provider.of<LoginViewModel>(context, listen: false);
    var commonViewmodel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    if (isBankDetails) listenViewModel.openPage();
    listenViewModel.closeFocus();
    if (commonViewmodel.id == 0)
      constant.previousScreen.value = ScreenType.Market;
    leaveSocket();
  }

  /// sideMenu navigation
  navigation(int index, List<Map<String, dynamic>> sideMenuList,
      BuildContext context) {
    var commonViewmodel = Provider.of<CommonViewModel>(
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
    } else if (clickedItem == stringVariables.exchange) {
      Scaffold.of(context).closeDrawer();
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
      moveToSecurity(context, constant.buttonValue.value);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.setting) {
      moveToSetting(context);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.referral) {
      moveToReferral(context);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.logIn) {
      moveToRegister(context, false);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.createAccount) {
      moveToRegister(context);
      leaveFromSocket(context);
    } else if (clickedItem == stringVariables.p2p) {
      moveToP2P(context);
    } else if (clickedItem == stringVariables.staking) {
      moveToStackingHomePageView(context);
    } else {

    }
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
    webSocket?.connect();
    webSocket?.onConnect((_) {
      securedPrint(
          'connect: ${webSocket?.connected} socketLink: ${webSocket?.io.uri} socket_ID ${webSocket?.id} ');
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
  }

  void updateTradePair(ListOfTradePairs data) {
    int index = viewModelTradePairs!
        .indexWhere((element) => element.symbol == data.symbol);
    viewModelTradePairs![index] = data;
    notifyListeners();
  }

  /// Get TradePairs
  getTradePairs() async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        //"featured": true,
        // "pagination": {
        //   "skip": 0,
        //   "limit": 10,
        // }
      }
    };
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
          (decodeResponse.data?.statusCode != 10001)
              ? setTradePairs(decodeResponse.data?.result)
              : serverError = true;
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
}
