import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/margin_model/CrossMarginWalletModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../transfer_history/viewModel/transfer_history_view_model.dart';
import '../../wallet_select/viewModel/wallet_select_view_model.dart';
import '../model/funding_wallet_balance.dart';

class TransferViewModel extends ChangeNotifier {
  bool isSwap = false;
  bool needToLoad = true;
  bool buttonLoader = false;
  bool click = true;
  bool noInternet = false;
  String currency = 'BTC';
  String setCurrencyForFilter = stringVariables.all;
  String pair = 'ETH/USDT';
  GetBalance? getBalance;
  String? availabeBalance = "0.00";
  num? maxBalance = 0;
  List<DashBoardBalance>? currencyBalance = [];

  CrossMarginWalletModel? crossMarginWallet;
  List<CrossMarginWallet>? crossMarginWalletBalance = [];
  List<GetUserFundingWalletDetails>? fundingWalletBalance = [];

  WalletSelectViewModel? walletSelectViewModel;
  CommonModel? commonModel;
  WalletViewModel? walletViewModel;

  GetUserFundingWalletDetailsClass? getUserFundingWalletDetailsClass;
  List<String> fundingCoins = [];
  TransferHistoryViewModel? transferHistoryViewModel;



  TransferViewModel() {

  }

 
  setButtonLoader(bool value) {
    buttonLoader = value;
    notifyListeners();
  }

  updateBalance() {
    walletSelectViewModel = Provider.of<WalletSelectViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
   

    if (walletSelectViewModel?.firstWallet == stringVariables.spotWallet &&
        walletSelectViewModel?.secondtWallet == stringVariables.crossMargin) {
      securedPrint("CROSS");

      getDashBoardBalance();
    } else if (walletSelectViewModel?.firstWallet ==
            stringVariables.spotWallet &&
        walletSelectViewModel?.secondtWallet == stringVariables.funding) {
      securedPrint("FUNDING");
      fetchUserFundingWallet("fundingTransfer");
      getDashBoardBalance();
    } else if (walletSelectViewModel?.firstWallet ==
            stringVariables.spotWallet &&
        walletSelectViewModel?.secondtWallet == stringVariables.usdsfutures) {
      securedPrint("usdsfutures");
      getDashBoardBalance();
      // getFutureWalletDetails();
    } else if (walletSelectViewModel?.firstWallet ==
            stringVariables.spotWallet &&
        walletSelectViewModel?.secondtWallet == stringVariables.coinFuture) {
      securedPrint("coinFuture");
      //getFutureWalletDetails();
      getDashBoardBalance();
    } else {
      securedPrint("ISOLATED");
    }

    notifyListeners();
  }

  setSwapBool() {
    isSwap = !isSwap;
    notifyListeners();
  }

  setClick() {
    click = !click;
    notifyListeners();
  }

  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setCurrency(String value) {
    currency = value;
    notifyListeners();
  }

  setCurrencyForFilterModal(String value) {
    setCurrencyForFilter = value;
    notifyListeners();
  }

  setPair(String value) {
    pair = value;
    notifyListeners();
  }

  getDashBoardBalance() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchBalance();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setBalance(decodeResponse.data);
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

  setBalance(GetBalance? data) {
    getBalance = data;
    setLoading(false);
    setSpotMarginvValue();
    notifyListeners();
  }

  setSpotMarginvValue() {

    currencyBalance?.clear();

    getBalance?.result?.forEach((element) {
      currencyBalance = getBalance?.result
          ?.where((element) => element.currencyCode.toString() == currency)
          .toList();
    });
    if (walletSelectViewModel?.firstWallet == stringVariables.spotWallet) {
      availabeBalance = trimDecimalsForBalance(
          currencyBalance!.first.availableBalance.toString());
    }

    notifyListeners();
  }

  userFundingWalletTransfer(
      String amount, String firstWallet, String secondtWallet) async {


    Map<String, dynamic> params = {
      "input": {
        "from_wallet": firstWallet == stringVariables.funding
            ? "funding_wallet"
            : "spot_wallet",
        "to_wallet": secondtWallet == stringVariables.spotWallet
            ? "spot_wallet"
            : "funding_wallet",
        "currency_code": currency,
        "amount": double.parse(amount)
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.userFundingWalletTransfer(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFundingWalletTransfer(decodeResponse.data);
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

  setFundingWalletTransfer(CommonModel? data) {
    walletViewModel = Provider.of<WalletViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    commonModel = data;
    if (commonModel?.statusCode == 200) {
      if (walletSelectViewModel?.firstWallet == stringVariables.spotWallet) {
        getDashBoardBalance();
      } else {
        fetchUserFundingWallet("fundingTransfer");
      }
      walletViewModel?.getDashBoardBalance();
      walletViewModel?.getUserFundingWalletDetails();
    }
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel!.statusMessage.toString(),
        commonModel!.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);

    Navigator.pop(NavigationService.navigatorKey.currentContext!);
    notifyListeners();
  }

  fetchUserFundingWallet(String? screen) async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchUserFundingWalletDetails();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUserFundingWallet(decodeResponse.data, screen);
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

  setUserFundingWallet(GetUserFundingWalletDetailsClass? data, String? screen) {
    transferHistoryViewModel = Provider.of<TransferHistoryViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    fundingCoins.clear();
    getUserFundingWalletDetailsClass = data;
    getUserFundingWalletDetailsClass?.result?.forEach((element) {
      if (transferHistoryViewModel?.tabIndex == 0 &&
          screen == "fundingTransferModal") {
        if (element.currencyType == "crypto") {
          fundingCoins.add(element.currencyCode.toString());
        }
      } else if (transferHistoryViewModel?.tabIndex == 1 &&
          screen == "fundingTransferModal") {
        if (element.currencyType == "fiat") {
          fundingCoins.add(element.currencyCode.toString());
        }
      } else {
        fundingCoins.add(element.currencyCode.toString());
      }
    });
    if (screen == "fundingTransferModal") {
      fundingCoins..insert(0, stringVariables.all);
    }
    setFundingBalanceValue();
    setLoading(false);
    notifyListeners();
  }

  setFundingBalanceValue() {
    walletSelectViewModel = Provider.of<WalletSelectViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);


    fundingWalletBalance?.clear();

    getUserFundingWalletDetailsClass?.result?.forEach((element) {
      fundingWalletBalance = getUserFundingWalletDetailsClass?.result
          ?.where((element) => element.currencyCode == currency)
          .toList();
    });
    if (walletSelectViewModel?.firstWallet == stringVariables.funding) {
      availabeBalance =
          trimDecimalsForBalance(fundingWalletBalance!.first.amount.toString());
    }
    notifyListeners();
  }
}
