import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/ZodeakX/CurrencyPreferenceScreen/Model/CurrencyPreferenceModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../p2p/home/view_model/p2p_home_view_model.dart';

class CurrencyPreferenceViewModel extends ChangeNotifier {
  CurrencyPreferenceViewModel? viewModel;

  bool noInternet = false;
  bool needToLoad = true;
  List<FiatCurrency>? viewModelCurrencyPairs;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// radiobutton onChanged value using provider
  int id = 0;

  Future<void> setActive(int index) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }

  setCurrency(
    String currencyCode,
  ) async {
    constant.userCurrency.value = '${currencyCode}';
    constant.pref?.setString("defaultFiatCurrency", '${currencyCode}');
    Provider.of<P2PHomeViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false)
        .setFiatCurrency(currencyCode, true);
    notifyListeners();
  }

  /// set FiatCurrency
  setFiatCurrency(List<FiatCurrency>? fiatCurrency) {
    viewModelCurrencyPairs = fiatCurrency;
    for (int i = 0; i < (viewModelCurrencyPairs ?? []).length; i++) {
      if (viewModelCurrencyPairs?[i].currencyCode ==
          constant.pref?.getString("defaultFiatCurrency")) {
        setActive(i);
      }
    }
    notifyListeners();
  }

  /// Get FiatCurrency
  getFiatCurrency() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchFiatCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFiatCurrency(decodeResponse.data?.result);
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
