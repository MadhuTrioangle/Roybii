import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';

import '../../../../Utils/Constant/AppConstants.dart';
import '../../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../transfer/model/funding_wallet_balance.dart';
import '../../../transfer/viewModel/transfer_view_model.dart';
import '../../CoinDetailsModel/get_currency.dart';
import '../View/SelectWalletBottomSheet.dart';

class CommonWithdrawViewModel extends ChangeNotifier {
  final TextEditingController recepientAddress = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController tagId = TextEditingController();
  final TextEditingController fiatAmount = TextEditingController();
  final TextEditingController network = TextEditingController();
  final TextEditingController bank = TextEditingController();
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
  bool keyboardVisibility = false;

  setRadioValue(SelectWallet value, String balanceValue) async {
    radioValue = value;
    balance = balanceValue;
    notifyListeners();
  }

  setKeyboardVisibility(bool visiblity) async {
    keyboardVisibility = visiblity;
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
        ?.where((element) => element.currencyCode == currencyCode)
        .toList();
    spotWalletBalance = trimDecimalsForBalance(
        getSpotBalance?.first.availableBalance.toString() ?? "0.00");
    securedPrint("spotWalletBalance${spotWalletBalance}");
    fetchUserFundingWallet(currencyCode);
    notifyListeners();
  }

  fetchUserFundingWallet(String? currencyCode) async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchUserFundingWalletDetails();
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
    securedPrint("fundingWallettBalance${fundingWallettBalance}");
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
    await setNetWorkDropdown(getCurrency!
        .where(
            (element) => element.currencyCode == constant.walletCurrency.value)
        .toList()
        .first
        .network!
        .first);
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
