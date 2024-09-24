import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/staking/staking_history/view_model/staking_order_history_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/view_model/staking_transaction_view_model.dart';

import '../../../Common/Wallets/CoinDetailsModel/get_currency.dart';
import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../balance/view_model/staking_balance_view_model.dart';

class SearchCoinsViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  List<GetCurrency>? cryptoCurrency;
  String? selectedCurrency = null;
  String? selectedHistoryCurrency = null;
  bool searchControllerText = false;

  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setSelectedCurrency(String? value) async {
    selectedCurrency = value;
    StakingBalanceViewModel stakingBalanceViewModel =
        Provider.of<StakingBalanceViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    stakingBalanceViewModel.getActiveUserStakes(0);
    notifyListeners();
  }

  setSearchControllerText(bool value) async {
    searchControllerText = value;
    notifyListeners();
  }

  setSelectedHistoryCurrency(String? value) async {
    selectedHistoryCurrency = value;
    StakingOrderHistoryViewModel stakingOrderHistoryViewModel =
        Provider.of<StakingOrderHistoryViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    if (stakingOrderHistoryViewModel.tabIndex != 2)
      stakingOrderHistoryViewModel.getUserStakes(0);
    else
      stakingOrderHistoryViewModel.getUserStakeEarns(0);
    notifyListeners();
  }

  //API
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

  getNetwork(String crypto) {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    WalletViewModel walletViewModel =
        Provider.of<WalletViewModel>(context, listen: false);
    return (walletViewModel.viewModelDashBoardBalance ?? [])
        .where((element) => element.currencyCode == crypto)
        .first
        .currencyName;
  }

  setCryptoCurrency(List<GetCurrency>? cryptoCurrency) {
    this.cryptoCurrency = cryptoCurrency;
    this.cryptoCurrency?.forEach((element) {
      element.name = getNetwork(element.currencyCode ?? "");
    });
    setLoading(false);
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    cryptoCurrency = null;
    selectedCurrency = null;
    selectedHistoryCurrency = null;
  }
}
