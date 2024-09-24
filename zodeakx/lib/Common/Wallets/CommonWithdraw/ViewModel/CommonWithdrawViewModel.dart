import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';

import '../../../../Utils/Constant/AppConstants.dart';
import '../../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../../funding_wallet/funding_coin_details/model/funding_wallet_balance.dart';
import '../../../Transfer/ViewModel/TransferViewModel.dart';
import '../../CoinDetailsModel/get_currency.dart';

class CommonWithdrawViewModel extends ChangeNotifier {
  final TextEditingController recepientAddress = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController tagId = TextEditingController();
  final TextEditingController fiatAmount = TextEditingController();
  final TextEditingController bank = TextEditingController();
  final TextEditingController network = TextEditingController();
  SelectWallet radioValue = SelectWallet.spot;
  String? spotWalletBalance = "0.00";
  String? fundingWallettBalance = "0.00";
  TransferViewModel? transferViewModel;
  GetBalance? getBalance;
  GetUserFundingWalletDetailsClass? getUserFundingWalletDetailsClass;
  List<DashBoardBalance>? getSpotBalance = [];
  List<GetUserFundingWalletDetails>? getFundingBalance = [];
  bool needToLoad = false;
  bool noInternet = false;
  String balance = "0.00";
  String networkWidget = "";
  String? netwoksDropDownValue = "BTC";

  List<GetCurrency>? getCurrency;
  List<String>? netwoksDropDown = [];

  setRadioValue(SelectWallet value, String balanceValue) async {
    radioValue = value;
    balance = balanceValue;
    notifyListeners();
  }

  setNetWorkDropdown(String value) async {
    var getCurrencyViewModel = Provider.of<GetCurrencyViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    netwoksDropDownValue = value;
    await getCurrencyViewModel.getMinWithdrawDetails();
    notifyListeners();
  }

  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  getDashBoardBalance(String currencyCode) async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchBalance();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setBalance(decodeResponse.data, currencyCode);
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

  setBalance(GetBalance? data, String currencyCode) {
    getBalance = data;
    getSpotBalance = getBalance?.result
        ?.where((element) => element.currencyCode == currencyCode.toString())
        .toList();
    spotWalletBalance = trimDecimalsForBalance(
        getSpotBalance?.first.availableBalance.toString() ?? "0.00");
    fetchUserFundingWallet(currencyCode);
    notifyListeners();
  }

  fetchUserFundingWallet(String? currencyCode) async {
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
          setUserFundingWallet(decodeResponse.data, currencyCode);
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

  setUserFundingWallet(
      GetUserFundingWalletDetailsClass? data, String? currencyCode) {
    getUserFundingWalletDetailsClass = data;
    getFundingBalance = getUserFundingWalletDetailsClass?.result
        ?.where((element) => element.currencyCode == currencyCode)
        .toList();
    fundingWallettBalance = trimDecimalsForBalance(
        getFundingBalance?.first.amount.toString() ?? "0.00");
    getCryptoCurrency();
    notifyListeners();
  }

  getCryptoCurrency() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchCryptoCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCryptoCurrency(decodeResponse.data?.result);
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

  setCryptoCurrency(List<GetCurrency>? cryptoCurrency) async {
    getCurrency = cryptoCurrency;
    netwoksDropDown!.clear();
    var ntwk = getCurrency!
        .where(
            (element) => element.currencyCode == constant.walletCurrency.value)
        .toList()
        .first
        .network!
        .first;
    if (ntwk.isNotEmpty) {
      await setNetWorkDropdown(ntwk);
    }
    getCurrency?.forEach((element) {
      if (element.currencyCode == constant.walletCurrency.value) {
        element.network?.forEach((e) {
          netwoksDropDown?.add(e.toString());
        });
      }
    });
    setLoading(false);
    notifyListeners();
  }
}
