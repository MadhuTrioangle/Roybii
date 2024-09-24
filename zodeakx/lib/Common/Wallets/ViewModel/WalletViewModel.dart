import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';

import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../ZodeakX/DashBoardScreen/ViewModel/ExchangeRateViewModel.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../funding_wallet/funding_coin_details/model/funding_wallet_balance.dart';
import '../../../staking/balance/view_model/staking_balance_view_model.dart';

import '../../SplashScreen/ViewModel/SplashViewModel.dart';
import '../CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';


class WalletViewModel extends ChangeNotifier {
  WalletViewModel? viewModel;
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
  List<String> walletTabs = [
    stringVariables.overview,
    stringVariables.spot,
    stringVariables.staking,
    stringVariables.funding,
  ];
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
  int crossMarginWalletItem = 0;
  int isolatedMarginWalletItem = 0;
  bool marginLoader = true;
  num totalCrossEquity = 0;
  num totalCrossDebt = 0;
  num totalIsolatedEquity = 0;
  num totalIsolatedDebt = 0;
  num fiatValue = 0;
  int totalActivePairs = 0;
  List<GetUserFundingWalletDetails> userFundingWalletDetails = [];
  SplashViewModel? splashViewModel;
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



  void setSpotSearch(bool value) async {
    spotSearch = value;
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
    if (constant.stakingStatus) {
      StakingBalanceViewModel stakingBalanceViewModel =
      Provider.of<StakingBalanceViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      stakingBalanceViewModel.getStakeBalance();
    }
    notifyListeners();
  }



  ///Get Balance
  getDashBoardBalance() async {
    splashViewModel = Provider.of<SplashViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    splashViewModel?.getDefault();
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
    notifyListeners();
  }

  getUserFundingWalletDetails() async {
    String? fiatCurrency =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';
    Map<String, dynamic> mutateUserParams = {
      "getUserFundingWalletDetailsInput": {"default_currency": fiatCurrency}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchUserFundingWalletDetails(mutateUserParams);
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

  setUserFundingWalletDetails(List<GetUserFundingWalletDetails> result) {
    userFundingWalletDetails.clear();

    estimateFundingTotalValue = 0;
    estimateFundingFiatValue = 0;
    userFundingWalletDetails = result;

    userFundingWalletDetails.forEach((element) {
      element.exchangeRate =
          (element.convertedAmount ?? 0) / (element.amount ?? 1);
      element.totalAmount = (element.amount ?? 0) + (element.inorder ?? 0);
      estimateFundingFiatValue += element.usdValue;
      estimateFundingTotalValue += element.convertedAmount;
    });
    notifyListeners();
  }




  /// funding balance socket
  // getFundingBalanceSocket() {
  //   var marketViewModel = Provider.of<MarketViewModel>(NavigationService.navigatorKey.currentContext!,listen:false);
  //   String sessionId = constant.pref?.getString("sessionId") ?? "";
  //   securedPrint("socketConnect${marketViewModel.webSocket?.connected}");
  //   marketViewModel.webSocket?.on("fundingWalletBalance_$sessionId", (data) {
  //     securedPrint("data>>>>${constant.walletCurrency.value}");
  //     userFundingWalletDetails.forEach((element) {
  //       String fromCurrency = element.currencyCode.toString();
  //       String toCurrency = element.currencyCode.toString();
  //       var id = data['socket_id'];
  //       var firstCurrency = data[fromCurrency];
  //       var secondCurrency = data[toCurrency];
  //       Map<String, dynamic> walletBalance = {
  //         'socket_id': id,
  //         'firstCurrency': firstCurrency,
  //         'secondCurrency': secondCurrency
  //       };
  //       var decodeResponse = HandleResponse.completed(
  //           WalletBalanceModel.fromJson(walletBalance));
  //       switch (decodeResponse.status?.index) {
  //         case 0:
  //         //setLoading(false);
  //           break;
  //         case 1:
  //           if(fromCurrency == decodeResponse.data?.firstCurrency?.currencyCode.toString()){
  //             setBalance(
  //               decodeResponse.data,
  //             );
  //             // securedPrint("Hiii");
  //           }else{
  //             // securedPrint("Biii");
  //           }
  //           break;
  //         default:
  //         //setLoading(false);
  //           break;
  //       }
  //     });
  //   });
  // }
  //
  // setBalance(WalletBalanceModel? data) {
  //   updateBalance(data);
  //   notifyListeners();
  // }
  //
  // updateBalance(WalletBalanceModel? data){
  //   var commonWithdrawViewModel = Provider.of<CommonWithdrawViewModel>(NavigationService.navigatorKey.currentContext!,listen: false);
  //   userFundingWalletDetails.forEach((element) {
  //     if(element.currencyCode.toString() == data?.firstCurrency?.currencyCode.toString()){
  //       element.amount = data?.firstCurrency?.amount;
  //       element.inorder = data?.firstCurrency?.inorder;
  //       commonWithdrawViewModel.setRadioValue(SelectWallet.funding,data?.firstCurrency?.amount.toString() ?? "0.00");
  //     }else{
  //       securedPrint("currency${element.currencyCode.toString()}");
  //     }
  //   });
  //   commonWithdrawViewModel.getUserFundingWalletDetailsClass?.result?.forEach((element) {
  //     if(element.currencyCode.toString() == data?.firstCurrency?.currencyCode.toString()){
  //       element.amount = data?.firstCurrency?.amount;
  //       element.inorder = data?.firstCurrency?.inorder;
  //       commonWithdrawViewModel.setRadioValue(SelectWallet.funding,data?.firstCurrency?.amount.toString() ?? "0.00");
  //     }else{
  //       securedPrint("currency${element.currencyCode.toString()}");
  //     }
  //   });
  //   notifyListeners();
  // }


}
