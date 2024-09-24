import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/SplashScreen/ViewModel/SplashViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';

import '../../../Common/Wallets/CoinDetailsModel/find_address.dart';
import '../../../Common/Wallets/CoinDetailsModel/get_currency.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/Networking/GraphQL/Queries/MarketQueries.dart';
import '../../Repositories/ProductRepositories.dart';
import '../../Setting/Model/GetUserByJwtModel.dart';
import 'ExchangeRateViewModel.dart';

class DashBoardViewModel extends ChangeNotifier {
  DashBoardViewModel? viewModel;
  bool isvisible = true;
  bool noInternet = false;
  bool needToLoad = true;
  List<DashBoardBalance>? viewModelDashBoardBalance;
  num? availableBalanceForDefaultCryptoValue = 0.0;
  GetExchangeResult? getExchangeResult;
  GetUserJwt? viewModelVerification;
  bool buttonEnable = false;
  String buttonValue = 'Enable';
  num? totalBtcBalance = 0;
  num? addedTotal = 0;
  num? total = 0;
  late List<num>? totalList = [];
  late List<num>? totalFiatList = [];
  num? btcValue = 0;
  num? usdValue = 0;
  num? estimateFiatValue = 0;
  num? estimateTotalValue = 0;
  num? totaldefaultFiatValue = 0;
  num? addedFiatTotal = 0;
  String defaultCryptoCurrency =
      constant.pref?.getString("defaultCryptoCurrency") ?? '';
  String defaultFiatCurrency =
      constant.pref?.getString("defaultFiatCurrency") ?? '';
  dynamic minWithdrawLimit = '';
  List<GetCurrency>? getCurrency;
  dynamic withdrawFee = 0.0;
  dynamic withdraw = 0.0;
  FindAddress? findAddress;
  List<DashBoardBalance>? viewModelDashBoardBalanceForDefaultCurrency = [];
  setButtonValue(bool buttonEnable) async {
    this.buttonEnable = buttonEnable;
    notifyListeners();
  }

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// set Icon visibility
  void setVisible() async {
    isvisible = !isvisible;
    notifyListeners();
  }

  /// set dashBoardBalance
  setDashboardBalance(List<DashBoardBalance>? dashBoardBalance) {
    String defaultCrypto =
        constant.pref?.getString("defaultCryptoCurrency") ?? '';
    viewModelDashBoardBalance = dashBoardBalance;
    addedTotal = 0;
    addedFiatTotal = 0;
    viewModelDashBoardBalance?.forEach((e) {
      totalBtcBalance = e.defaultCryptoValue;
      addedTotal = addedTotal! + totalBtcBalance!;
    });
    totalList = [addedTotal!];
    total = totalList?[0];
    viewModelDashBoardBalanceForDefaultCurrency = viewModelDashBoardBalance
        ?.where((element) => element.currencyCode == defaultCrypto)
        .toList();
    availableBalanceForDefaultCryptoValue =
        viewModelDashBoardBalanceForDefaultCurrency?.first.availableBalance;
    viewModelDashBoardBalance?.forEach((element) {
      totaldefaultFiatValue = element.usdValue;
      addedFiatTotal = addedFiatTotal! + totaldefaultFiatValue!;
    });
    totalFiatList = [addedFiatTotal!];
    estimateFiatValue = totalFiatList?[0];
    notifyListeners();
  }

  /// set Crypto Withdraw
  setCurrencyForCryptoWithdraw(List<GetCurrency>? getCryptoCurrency) {
    getCurrency = getCryptoCurrency;
    var amount = getCurrency
        ?.where((c) => c.currencyCode == defaultCryptoCurrency)
        .toList();
    withdraw = '${amount?.first.withdrawFee}';
    withdrawFee = double.parse('${amount?.first.withdrawFee}') / 100.0;
    notifyListeners();
  }

  /// set Crypto Withdraw
  setMinimumWithdrawAmount(List<GetCurrency>? getCryptoCurrency) {
    minWithdrawLimit = getCryptoCurrency?.first.minWithdrawLimit;
    notifyListeners();
  }

  ///Get Balance
  getDashBoardBalance() async {
    var splashViewModel = Provider.of<SplashViewModel>(
        NavigationService.navigatorKey.currentContext!);
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
          var match = decodeResponse.data?.result
              ?.where((m) => m.currencyCode == 'BTC')
              .toList();
          btcValue = match?.first.btcValue;
          usdValue = match?.first.usdValue;
          setDashboardBalance(
              decodeResponse.data?.result as List<DashBoardBalance>);
          getIdVerification();
          setLoading(false);
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

  /// Get IdVerification

  getIdVerification() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      constant.QRSecertCode.value = response.result?.tfaEnableKey ?? "";
      constant.buttonValue.value = response.result?.tfaStatus ?? '';
      constant.antiCode.value = response.result?.antiPhishingCode ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          if (decodeResponse.data?.statusCode == 200) {
            buttonValue = response.result?.tfaStatus ?? '';
            constant.buttonValue.value = response.result?.tfaStatus ?? '';
            constant.pref?.setString(
                "buttonValue", response.result?.tfaStatus ?? "UnVerified");
            if (constant.buttonValue.value == 'verified') {
              setButtonValue(true);
            } else {
              setButtonValue(false);
            }
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("buttonValue", constant.buttonValue.value);
            constant.antiCode.value = response.result?.antiPhishingCode ?? '';
            prefs.setString("code", constant.antiCode.value);
            setIdVerification(decodeResponse.data?.result);
            getFindAddress(constant.cryptoCurrency.value);
          }
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

  /// Find Address
  getFindAddress([String? currencyCode]) async {
    var hasInternet = await checkInternet.hasInternet();

    if (hasInternet) {
      String? query = marketQueries.ethAddress;
      switch (currencyCode) {
        case "ETH":
          query = marketQueries.ethAddress;
          break;
        case "BTC":
          query = marketQueries.btcAddress;
          break;
        case "LTC":
          query = marketQueries.ltcAddress;
          break;
        case "SOL":
          query = marketQueries.solAddress;
          break;
        case "ADA":
          query = marketQueries.adaAddress;
          break;
        case "MATIC":
          query = marketQueries.maticAddress;
          break;
        case "DOGE":
          query = marketQueries.dogeAddress;
          break;
        case "XRP":
          query = marketQueries.xrpAddress;
          break;
        default:
          query = marketQueries.bnbAddress;
          break;
      }
      var response = await productRepository.fetchFindAddress(query);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFindAddress(decodeResponse.data?.result);
          getCurrencyForCryptoWithdraw();

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

  /// set Find Address
  setFindAddress(FindAddress? address) {
    findAddress = address;
    notifyListeners();
  }

  ///Get Currency
  getCurrencyForCryptoWithdraw() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          var match = decodeResponse.data?.result
              ?.where((m) => m.currencyCode == defaultCryptoCurrency)
              .toList();
          setMinimumWithdrawAmount(match);
          setCurrencyForCryptoWithdraw(decodeResponse.data?.result);
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
}
