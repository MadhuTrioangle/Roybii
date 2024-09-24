import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';
import 'package:zodeakx_mobile/Common/Wallets/CommonWithdraw/View/SelectWalletBottomSheet.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Queries/MarketQueries.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/CurrencyPreferenceScreen/Model/CurrencyPreferenceModel.dart';
import '../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../Exchange/Model/WalletBalanceModel.dart';
import '../CoinDetailsModel/CoinDetailsModel.dart';
import '../CoinDetailsModel/find_address.dart';
import '../CoinDetailsModel/get_currency.dart';
import '../CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import '../TransactionDetails/Model/CryptoWithdrawHistoryModel.dart';
import '../TransactionDetails/Model/FiatWithdrawHistory.dart';

class CoinDetailsViewModel extends ChangeNotifier {
  CoinDetailsViewModel? viewModel;
  bool noInternet = false;
  bool needToLoad = true;
  int Counter = 5;
  bool ReadMoreFlag = false;
  bool openReadMoreFlag = false;
  InOrderBalance? inOrderBalance;
  List<FiatCurrency>? viewModelCurrencyPairs;
  List<CryptoWithdrawHistoryDetails>? cryptoWithdrawHistoryDetails;
  List<CryptoWithdrawHistoryDetails>? cryptoDepositHistoryDetails;
  List<FiatWithdrawHistoryDetails>? fiatWithdrawHistoryDetails;
  List<FiatWithdrawHistoryDetails>? fiatDepositHistoryDetails;
  FindAddress? findAddress;
  List<GetCurrency>? getCurrency;
  List<String> fiat = [];
  List<CryptoWithdrawHistoryDetails>? cryptoTransaction = [];
  List<FiatWithdrawHistoryDetails>? fiatTransaction = [];
  String? network = "BTC";

  List<String>? getCoins = [];
  List<String>? getNetworks = [];
  String? dropdownvalue;

  /// initilizing API
  CoinDetailsViewModel() {}

  setDropdownvalue(String value) {
    dropdownvalue = value;
    notifyListeners();
  }

  /// set  Crypto Currency
  setCryptoCurrency(List<GetCurrency>? CryptoCurrency, String currencyType) {
    getCurrency = CryptoCurrency;
    getCoins!.clear();
    getNetworks!.clear();
    getCurrency!.forEach((element) {
      getCoins!.add(element.currencyCode!);
      getNetworks!.contains(element.network)
          ? () {}
          : getNetworks!.add(element.network!.first!);
    });
    getCurrency!.forEach((code) {
      if (getCurrency!.contains(code.currencyCode)) {
        getCurrency!.add(code);
      }
    });
    if (currencyType == CurrencyType.CRYPTO.toString()) {
      setNetwork(getCurrency!
          .where((element) =>
              element.currencyCode == constant.walletCurrency.value)
          .toList()
          .first
          .network!.first);
      getInOrderBalance(constant.walletCurrency.value);
    } else {
      getFiatInOrderBalance(constant.walletCurrency.value);
    }
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  Future<void> setNetwork(String text) async {
    network = text;
    notifyListeners();
  }

  /// set inOrderBalance
  setInOrderBalance(InOrderBalance? OrderBalance, [String? value]) {
    inOrderBalance = OrderBalance;
    getFindAddress(value);

    notifyListeners();
  }

  /// set FiatCurrency
  setFiatCurrency(List<FiatCurrency>? fiatCurrency) {
    viewModelCurrencyPairs = fiatCurrency;
    fiat.clear();
    for (var currencyPairs in viewModelCurrencyPairs ?? []) {
      fiat.add('${currencyPairs.currencyCode}');
    }

    getCryptoWithdrawHistoryDetails();
    notifyListeners();
  }

  setOpenReadMoreFlag(bool flag) async {
    openReadMoreFlag = flag;
    notifyListeners();
  }

  setOpenCounter(int counter) async {
    Counter = counter;
    notifyListeners();
  }

  /// set CryptoWithdrawHistoryDetails
  setCryptoWithdrawHistoryDetails(
      List<CryptoWithdrawHistoryDetails>? withdrawHistory) {
    cryptoWithdrawHistoryDetails = withdrawHistory;
    cryptoTransaction = withdrawHistory;
    getCryptoDepositHistoryDetails();
    notifyListeners();
  }

  /// set CryptoDepositHistoryDetails
  setCryptoDepositHistoryDetails(
      List<CryptoWithdrawHistoryDetails>? depositHistory) {
    cryptoDepositHistoryDetails = depositHistory;
    // cryptoTransaction = depositHistory;
    cryptoTransaction != null
        ? cryptoTransaction?.addAll(depositHistory ?? [])
        : cryptoTransaction = depositHistory;
    if (cryptoTransaction != null) {
      cryptoTransaction!.length > 5
          ? setOpenReadMoreFlag(true)
          : setOpenReadMoreFlag(false);
      cryptoTransaction!.length > 5
          ? setOpenCounter(5)
          : setOpenCounter(cryptoTransaction!.length);

      cryptoTransaction = List.of(cryptoTransaction!)
        ..sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
    }
    getFiatWithdrawHistoryDetails();
    notifyListeners();
  }

  /// set FiatWithdrawHistoryDetails
  setFiatWithdrawHistoryDetails(
      List<FiatWithdrawHistoryDetails>? fiatWithdrawHistory) {
    fiatWithdrawHistoryDetails = fiatWithdrawHistory;
    fiatTransaction = fiatWithdrawHistory;
    getFiatDepositHistoryDetails();
    notifyListeners();
  }

  /// set FiatDepositHistoryDetails
  setFiatDepositHistoryDetails(
      List<FiatWithdrawHistoryDetails>? fiatDepositHistory) {
    fiatDepositHistoryDetails = fiatDepositHistory;
    fiatTransaction?.length != 0
        ? fiatTransaction?.addAll(fiatDepositHistory ?? [])
        : fiatTransaction = fiatDepositHistory;
    if (fiatTransaction!.isNotEmpty) {
      fiatTransaction!.length > 5
          ? setOpenReadMoreFlag(true)
          : setOpenReadMoreFlag(false);
      fiatTransaction!.length > 5
          ? setOpenCounter(5)
          : setOpenCounter(fiatTransaction!.length);
    }
    fiatTransaction = List.of(fiatTransaction!)
      ..sort((a, b) => b.modifiedDate!.compareTo(a.modifiedDate!));

    notifyListeners();
  }

  removeListner() {
    this.dispose();
  }

  /// Get Crypto Currency
  getCryptoCurrency([String? currencyType]) async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchCryptoCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCryptoCurrency(decodeResponse.data?.result,
              currencyType ?? CurrencyType.CRYPTO.toString());
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

  ///Get inOrderBalance
  getInOrderBalance(String value) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"currency": value, "network": network}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchInOrderBalance(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setInOrderBalance(decodeResponse.data?.result, value);
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

  ///Get Fiat inOrderBalance
  getFiatInOrderBalance(String value) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"currency": value, "network": network}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchFiatInOrderBalance(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setInOrderBalance(decodeResponse.data?.result, value);
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
    var getCurrencyViewModel = Provider.of<GetCurrencyViewModel>(NavigationService.navigatorKey.currentContext!,listen: false);
    getCurrencyViewModel.setNetwork(currencyCode);
    GetCurrency? currency;
    var hasInternet = await checkInternet.hasInternet();
    securedPrint("currencyCode$currencyCode");
    List<GetCurrency> list = getCurrency
            ?.where((element) => element.currencyCode == currencyCode)
            .toList() ??
        [];

    if (list.isNotEmpty) {
      currency = list.first;
    } else {
      getFiatCurrency();
    }
    securedPrint("getCurrencyViewModel.network${getCurrencyViewModel.network}");
    if (hasInternet) {
      String? query;
      switch (getCurrencyViewModel.network) {
        case "ETH":
          query = marketQueries.ethAddress;
          break;
        case "USDT":
          query = marketQueries.ethAddress;
          break;
        case "USDC":
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
        case "BNB":
          query = marketQueries.bnbAddress;
          break;
        case "DOT":
          query = marketQueries.dotAddress;
          break;
        case "ULX":
          query = marketQueries.ulxAddress;
          break;
        default:
          query = null;
          break;
      }
      if (query == null) {
        setFindAddress(dummyFindAddress);
        getFiatCurrency();
      }
      var response = await productRepository.fetchFindAddress(query);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFindAddress(decodeResponse.data?.result);
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
    getFiatCurrency();
    notifyListeners();
  }

  /// Get FiatCurrency
  getFiatCurrency() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchFiatCurrency();
      var decodeResponse = HandleResponse.completed(response);
      response.result?.first.currencyCode =
          constant.pref?.getString("defaultFiatCurrency") ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFiatCurrency(decodeResponse.data?.result);
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

  ///Get Crypto Withdraw History Details
  getCryptoWithdrawHistoryDetails() async {
    Map<String, dynamic> mutateUserParams = {
      "cryptoWithdrawHistoryData": {
        "queryData": {
          "status": [
            "Cancelled",
            "Email Sent",
            "Rejected",
            "Awaiting Approval",
            "Approved",
            "Approved Unconfirmed",
            "Approved Confirmed",
            "Replaced Unconfirmed",
            "Replaced Confirmed"
          ]
        },
        "sort": {"created_Date": -1}
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository
          .fetchCryptoWithdrawHistoryDetails(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCryptoWithdrawHistoryDetails(decodeResponse.data?.result?.data);
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

  ///Get Crypto Deposit History Details
  getCryptoDepositHistoryDetails() async {
    Map<String, dynamic> mutateUserParams = {
      "cryptoDepositHistoryData": {
        "queryData": {
          "status": ["Confirmed"]
        },
        "sort": {"created_date": -1}
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository
          .fetchCryptoDepositHistoryDetails(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCryptoDepositHistoryDetails(decodeResponse.data?.result?.data);
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

  ///Get Fiat Withdraw History Details
  getFiatWithdrawHistoryDetails() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchFiatWithdrawHistory();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFiatWithdrawHistoryDetails(decodeResponse.data?.result);
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

  ///Get Fiat Deposit History Details
  getFiatDepositHistoryDetails() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchFiatDepositHistory();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFiatDepositHistoryDetails(decodeResponse.data?.result);
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

  /// spot balance socket
  getSpotBalanceSocket() {
   // securedPrint("currency${currency}");
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var walletViewModel = Provider.of<WalletViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    String sessionId = constant.pref?.getString("sessionId") ?? "";
    securedPrint("socketConnect${marketViewModel.webSocket?.connected}");
    marketViewModel.webSocket?.on("walletBalance_$sessionId", (data) {
      securedPrint("~~~~$data");
      walletViewModel.viewModelDashBoardBalance?.forEach((element) {
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
      var decodeResponse =
          HandleResponse.completed(WalletBalanceModel.fromJson(walletBalance));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          if(fromCurrency == decodeResponse.data?.firstCurrency?.currencyCode.toString()){
            setBalance(
              decodeResponse.data,
            );
           // securedPrint("Hiii");
          }else{
            //securedPrint("Biii");
          }
          break;
        default:
          //setLoading(false);
          break;
      }
    });
    });
  }

  setBalance(
    WalletBalanceModel? data,
  ) {
    var commonWithdrawViewModel = Provider.of<CommonWithdrawViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    inOrderBalance?.availableBalance = data?.firstCurrency?.amount;
    inOrderBalance?.totalBalance = (data?.firstCurrency?.amount ?? 0) + num.parse(data?.firstCurrency?.inorder.toString() ?? "0");
    inOrderBalance?.inorderBalance = data?.firstCurrency?.inorder;
    commonWithdrawViewModel.setRadioValue(SelectWallet.spot, '${data?.firstCurrency?.amount ?? "0"}');
    updateDashboardBalance(data);
    notifyListeners();
  }

  updateDashboardBalance(WalletBalanceModel? data) {
    var walletViewModel = Provider.of<WalletViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    walletViewModel.viewModelDashBoardBalance?.forEach((element) {
      if (element.currencyCode == data?.firstCurrency?.currencyCode) {
        element.availableBalance = data?.firstCurrency?.amount;
      } else {

      }
      notifyListeners();
    });
  }
}
