import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/margin_model/CrossMarginWalletModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/ExchangeRateModel.dart';

import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../Exchange/Model/WalletBalanceModel.dart';
import '../../SplashScreen/ViewModel/SplashViewModel.dart';
import '../CommonWithdraw/View/SelectWalletBottomSheet.dart';
import '../CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import '../FutureModel/FuturePositionsModel.dart';
import '../FutureModel/FutureWalletModel.dart';
import '../funding_coin_details/model/UserFundingWalletDetailsModel.dart';
import '../margin_model/UserWalletPnlModel.dart';

class WalletViewModel extends ChangeNotifier {
   List<String>   walletTabs = [
  stringVariables.overview,
  stringVariables.spot,
  stringVariables.staking,
  stringVariables.funding,
  stringVariables.margin,
  stringVariables.futures,
  ];
  WalletViewModel? viewModel;
  List<DashBoardBalance> searchResult = [];
  TextEditingController searchController = TextEditingController();
  bool noInternet = false;
  bool needToLoad = true;
  List<DashBoardBalance>? viewModelDashBoardBalance;
  GetExchangeResult? getExchangeResult;
  dynamic totalBtcBalance = 0;
  dynamic addedTotal = 0;
  dynamic total = 0;
  late List<num>? totalList = [];
  late List<num>? totalFiatList = [];
  num? totaldefaultFiatValue = 0;
  num? addedFiatTotal = 0;
  dynamic btcValue = 0;
  dynamic usdValue = 0;
  dynamic estimateFiatValue = 0;
  dynamic estimateTotalValue = 0;
  dynamic estimateFundingFiatValue = 0;
  dynamic estimateFundingTotalValue = 0;

  bool isvisible = true;
  bool overviewZero = false;
  bool spotZero = false;
  bool fundZero = false;
  bool marginCrossAccountZero = false;
  bool marginCrossShowDebt = false;
  bool marginIsolatedAccountZero = false;
  bool marginIsolatedShowDebt = false;
  bool futureUsdmZero = false;
  bool futureCoinmZero = false;
  bool spotSearch = false;
  bool fundingSearch = false;
  int tabIndex = 0;
  int marginTabIndex = 0;
  int futureTabIndex = 0;
  int usdmTabIndex = 0;
  int coinmTabIndex = 0;
  String defaultCryptoCurrency =
      constant.pref?.getString("defaultCryptoCurrency") ?? '';
  String defaultFiatCurrency =
      constant.pref?.getString("defaultFiatCurrency") ?? '';
  List<CrossMarginWallet> crossMarginWallet = [];

  List<CrossMarginWallet> crossMarginWalletZero = [];
  List<CrossMarginWallet> crossMarginWalletDebt = [];
  List<CrossMarginWallet> crossMarginWalletBoth = [];
  int crossMarginWalletItem = 0;
  int isolatedMarginWalletItem = 0;
  bool marginLoader = true;
  UserWalletPnl? userWalletPnl;
  UserWalletPnl? userWalletPnlUsdt;
  num totalCrossEquity = 0;
  num totalCrossDebt = 0;
  num totalIsolatedEquity = 0;
  num totalIsolatedDebt = 0;
  num fiatValue = 0;
  int totalActivePairs = 0;
  List<UserFundingWalletDetails> userFundingWalletDetails = [];
  SplashViewModel? splashViewModel;
  List<FutureWallet> usdmWallet = [];
  List<FutureWallet> usdmWalletZero = [];
  List<FutureWallet> coinmWallet = [];
  List<FutureWallet> coinmWalletZero = [];
  num totalUsdmBalance = 0;
  num totalCoinmBalance = 0;
  num totalUsdmCryptoBalance = 0;
  num totalCoinmCryptoBalance = 0;
  num usdmMarginFiat = 0;
  num usdmMarginCrypto = 0;
  num usdmUnrealizedFiat = 0;
  num usdmUnrealizedCrypto = 0;
  num coinmUnrealizedFiat = 0;
  num coinmUnrealizedCrypto = 0;
  FuturePositions? usdmPositions;
  FuturePositions? coinmPositions;
  int walletIndex = 0;

  setWalletIndex(int value) {
    walletIndex = value;
    notifyListeners();
  }

  /// initilizing API
  WalletViewModel() {

    // if (constant.userLoginStatus.value) getDashBoardBalance();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  void setOverviewZero(dynamic value) async {
    overviewZero = !overviewZero;
    notifyListeners();
  }

  void setSpotZero(dynamic value) async {
    spotZero = !spotZero;
    notifyListeners();
  }

  void setFutureUsdmZero(dynamic value) async {
    futureUsdmZero = !futureUsdmZero;
    notifyListeners();
  }

  void setFutureCoinmZero(dynamic value) async {
    futureCoinmZero = !futureCoinmZero;
    notifyListeners();
  }

  void setFundZero(dynamic value) async {
    fundZero = !fundZero;
    notifyListeners();
  }

  void setMarginCrossAccountZero(dynamic value) async {
    if (marginCrossAccountZero) {
      if (marginCrossShowDebt) {
        crossMarginWalletItem =
            crossMarginWalletDebt.length > 5 ? 5 : crossMarginWalletDebt.length;
      } else {
        crossMarginWalletItem = 5;
      }
    } else {
      if (marginCrossShowDebt) {
        crossMarginWalletItem =
            crossMarginWalletBoth.length > 5 ? 5 : crossMarginWalletBoth.length;
      } else {
        if (crossMarginWalletItem > crossMarginWalletZero.length) {
          crossMarginWalletItem = crossMarginWalletZero.length;
        }
      }
    }
    marginCrossAccountZero = !marginCrossAccountZero;
    notifyListeners();
  }

  void setMarginCrossShowDebt(dynamic value) async {
    if (marginCrossShowDebt) {
      if (marginCrossAccountZero) {
        crossMarginWalletItem =
            crossMarginWalletZero.length > 5 ? 5 : crossMarginWalletZero.length;
      } else {
        crossMarginWalletItem = 5;
      }
    } else {
      if (marginCrossAccountZero) {
        crossMarginWalletItem =
            crossMarginWalletBoth.length > 5 ? 5 : crossMarginWalletBoth.length;
      } else {
        if (crossMarginWalletItem > crossMarginWalletDebt.length) {
          crossMarginWalletItem = crossMarginWalletDebt.length;
        }
      }
    }
    marginCrossShowDebt = !marginCrossShowDebt;
    notifyListeners();
  }

  void setSpotSearch(bool value) async {
    spotSearch = value;
    searchController.clear();
    searchResult.clear();
    notifyListeners();
  }

  void setFundingSearch(bool value) async {
    fundingSearch = value;
    notifyListeners();
  }

  void setMarginLoader(bool value) async {
    marginLoader = value;
    notifyListeners();
  }

  void setVisible() async {
    isvisible = !isvisible;
    notifyListeners();
  }

  void setTabIndex(int value) async {
    tabIndex = value;
    notifyListeners();
  }

  void setMarginTabIndex(int value) async {
    marginTabIndex = value;
    notifyListeners();
  }

  void setFutureTabIndex(int value) async {
    futureTabIndex = value;
    notifyListeners();
  }

  void setUsdmTabIndex(int value) async {
    usdmTabIndex = value;
    notifyListeners();
  }

  void setCoinmTabIndex(int value) async {
    coinmTabIndex = value;
    notifyListeners();
  }

  void setCrossMarginWalletItem(int value) async {
    crossMarginWalletItem = value;
    notifyListeners();
  }

  void setIsolatedMarginWalletItem(int value) async {
    isolatedMarginWalletItem = value;
    notifyListeners();
  }

  /// set dashBoardBalance
  setDashboardBalance(List<DashBoardBalance>? dashBoardBalance) {
    viewModelDashBoardBalance = dashBoardBalance;
    addedTotal = 0;
    addedFiatTotal = 0;
    estimateTotalValue = 0;
    viewModelDashBoardBalance?.forEach((e) {
      totalBtcBalance = e.defaultCryptoValue;
      addedTotal = addedTotal! + totalBtcBalance!;
    });
    totalList = [addedTotal!];
    total = totalList?[0];

    viewModelDashBoardBalance?.forEach((element) {
      totaldefaultFiatValue = element.usdValue;
      addedFiatTotal = addedFiatTotal! + totaldefaultFiatValue!;
      estimateTotalValue += element.defaultCryptoValue;
    });
    totalFiatList = [addedFiatTotal!];
    estimateFiatValue = totalFiatList?[0];

    notifyListeners();
  }

  ///Get Balance
  getDashBoardBalance() async {
    splashViewModel = Provider.of<SplashViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    splashViewModel?.getDefault(false);
    constant.pref?.setString("defaultCryptoCurrency",
        splashViewModel?.defaultCurrency?.cryptoDefaultCurrency ?? "");
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
          var match = decodeResponse.data?.result
              ?.where((m) => m.currencyCode == 'BTC')
              .toList();
          btcValue = match?.first.btcValue;
          usdValue = match?.first.usdValue;
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

  setCrossMarginWallet(List<CrossMarginWallet>? result) {
    crossMarginWallet = result ?? [];
    crossMarginWalletZero = crossMarginWallet
        .where((element) => (element.totalBalance ?? 0.0) > 0)
        .toList();

    crossMarginWalletDebt = crossMarginWallet
        .where((element) => (element.borrowedCrypto ?? 0.0) > 0)
        .toList();

    crossMarginWalletBoth = crossMarginWallet
        .where((element) => ((element.borrowedCrypto ?? 0.0) > 0 &&
            (element.totalBalance ?? 0.0) > 0))
        .toList();

    if (marginCrossAccountZero && marginCrossShowDebt) {
      crossMarginWalletItem = crossMarginWalletBoth.length;
    } else if (marginCrossAccountZero) {
      crossMarginWalletItem = crossMarginWalletZero.length;
    } else if (marginCrossShowDebt) {
      crossMarginWalletItem = crossMarginWalletDebt.length;
    } else {
      if (crossMarginWallet.length >= 5)
        crossMarginWalletItem = 5;
      else
        crossMarginWalletItem = crossMarginWallet.length;
    }
    totalCrossDebt = 0;
    totalCrossEquity = 0;
    crossMarginWallet.forEach((element) {
      totalCrossEquity += (element.equityCrypto ?? 0);
      totalCrossDebt += (element.borrowedCrypto ?? 0);
    });
    notifyListeners();
  }

  setFutureWallet(List<FutureWallet>? result, String market) {
    if (market == "usds") {
      usdmWallet = result ?? [];
      totalUsdmBalance = 0;
      totalUsdmCryptoBalance = 0;
      usdmMarginFiat = 0;
      usdmMarginCrypto = 0;
      usdmUnrealizedFiat = 0;
      usdmUnrealizedCrypto = 0;
      usdmWalletZero = usdmWallet
          .where((element) => (element.totalExchangeBalance ?? 0) > 0)
          .toList();
      usdmWallet.forEach((element) {
        totalUsdmBalance += element.totalExchangeBalance ?? 0;
        totalUsdmCryptoBalance += element.defaultTotalBalance ?? 0;
        usdmMarginFiat += (element.totalExchangeBalance ?? 0) +
            (element.unrealizedPnlExchangeBalance ?? 0);
        usdmMarginCrypto += (element.defaultTotalBalance ?? 0) +
            (element.defaultUnrealizedPnl ?? 0);
        usdmUnrealizedFiat += element.unrealizedPnlExchangeBalance ?? 0;
        usdmUnrealizedCrypto += element.defaultUnrealizedPnl ?? 0;
      });
    } else {
      coinmWallet = result ?? [];
      totalCoinmBalance = 0;
      coinmUnrealizedFiat = 0;
      coinmUnrealizedCrypto = 0;
      totalCoinmCryptoBalance = 0;
      coinmWalletZero = coinmWallet
          .where((element) => (element.totalExchangeBalance ?? 0) > 0)
          .toList();
      coinmWallet.forEach((element) {
        totalCoinmBalance += element.totalExchangeBalance ?? 0;
        totalCoinmCryptoBalance += element.defaultTotalBalance ?? 0;
        coinmUnrealizedFiat += element.unrealizedPnlExchangeBalance ?? 0;
        coinmUnrealizedCrypto += element.defaultUnrealizedPnl ?? 0;
      });
    }
    notifyListeners();
  }

  setFuturePositions(FuturePositions? result, String market, int page) {
    if (market == "usds") {
      if (page == 0) {
        usdmPositions = result;
      } else {
        usdmPositions?.data?.addAll(result?.data ?? []);
        usdmPositions?.page = result?.page;
        usdmPositions?.total = result?.total;
      }
    } else {
      if (page == 0) {
        coinmPositions = result;
      } else {
        coinmPositions?.data?.addAll(result?.data ?? []);
        coinmPositions?.page = result?.page;
        coinmPositions?.total = result?.total;
      }
    }
    notifyListeners();
  }

  setUserWalletPnlUsdt(UserWalletPnl? result, [type = "Cross"]) {
    userWalletPnlUsdt = result;
    if (type == stringVariables.cross) {
      getEstimateFiatValue();
    }
    ;
    notifyListeners();
  }

  setUserWalletPnl(UserWalletPnl? result, [type = "Cross"]) {
    userWalletPnl = result;

    notifyListeners();
  }

  getEstimateFiatValue() async {
    String cryptoCurrency =
        constant.pref?.getString("defaultCryptoCurrency") ?? "";
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? "";
    Map<String, dynamic> params = {
      "data": {
        "from_currency": cryptoCurrency,
        "to_currency": fiatCurrency,
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
    fiatValue = result?.exchangeRate ?? 0;
    estimateFundingFiatValue = estimateFundingTotalValue * fiatValue;
    setMarginLoader(false);
    notifyListeners();
  }

  getUserFundingWalletDetails() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getUserFundingWalletDetails();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUserFundingWalletDetails(decodeResponse?.data?.result ?? []);
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

  setUserFundingWalletDetails(List<UserFundingWalletDetails> result) {
    userFundingWalletDetails.clear();

    estimateFundingTotalValue = 0;
    estimateFundingFiatValue = 0;
    userFundingWalletDetails = result;

    userFundingWalletDetails.forEach((element) {
      element.exchangeRate =
          (element.convertedAmount ?? 0) / (element.amount ?? 1);
      element.totalAmount = (element.amount ?? 0) + (element.inorder ?? 0);
      estimateFundingTotalValue += element.convertedAmount;
    });
    estimateFundingFiatValue = estimateFundingTotalValue * fiatValue;

    notifyListeners();
  }

  /// funding balance socket
  getFundingBalanceSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    String sessionId = constant.pref?.getString("sessionId") ?? "";
    securedPrint("socketConnect${marketViewModel.webSocket?.connected}");
    marketViewModel.webSocket?.on("fundingWalletBalance_$sessionId", (data) {
      securedPrint("data>>>>${constant.walletCurrency.value}");
      userFundingWalletDetails.forEach((element) {
        String fromCurrency = element.currencyCode.toString();
        String toCurrency = element.currencyCode.toString();
        var id = data['socket_id'];
        var firstCurrency = data[fromCurrency];
        var secondCurrency = data[toCurrency];
        Map<String, dynamic> walletBalance = {
          'socket_id': id,
          'firstCurrency': firstCurrency,
          'secondCurrency': secondCurrency
        };
        var decodeResponse = HandleResponse.completed(
            WalletBalanceModel.fromJson(walletBalance));
        switch (decodeResponse.status?.index) {
          case 0:
            //setLoading(false);
            break;
          case 1:
            if (fromCurrency ==
                decodeResponse.data?.firstCurrency?.currencyCode.toString()) {
              setBalance(
                decodeResponse.data,
              );
              // securedPrint("Hiii");
            } else {
              // securedPrint("Biii");
            }
            break;
          default:
            //setLoading(false);
            break;
        }
      });
    });
  }

  setBalance(WalletBalanceModel? data) {
    updateBalance(data);
    notifyListeners();
  }

  updateBalance(WalletBalanceModel? data) {
    var commonWithdrawViewModel = Provider.of<CommonWithdrawViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    userFundingWalletDetails.forEach((element) {
      if (element.currencyCode.toString() ==
          data?.firstCurrency?.currencyCode.toString()) {
        element.amount = data?.firstCurrency?.amount;
        element.inorder = data?.firstCurrency?.inorder;
        commonWithdrawViewModel.setRadioValue(SelectWallet.funding,
            data?.firstCurrency?.amount.toString() ?? "0.00");
      } else {
        securedPrint("currency${element.currencyCode.toString()}");
      }
    });
    commonWithdrawViewModel.getUserFundingWalletDetailsClass?.result
        ?.forEach((element) {
      if (element.currencyCode.toString() ==
          data?.firstCurrency?.currencyCode.toString()) {
        element.amount = data?.firstCurrency?.amount;
        element.inorder = data?.firstCurrency?.inorder;
        commonWithdrawViewModel.setRadioValue(SelectWallet.funding,
            data?.firstCurrency?.amount.toString() ?? "0.00");
      } else {
        securedPrint("currency${element.currencyCode.toString()}");
      }
    });
    notifyListeners();
  }

}
