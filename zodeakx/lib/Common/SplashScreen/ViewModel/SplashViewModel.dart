import 'package:flutter/cupertino.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../Model/SplashModel.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel? splashViewModel;
  DefaultCurrency? defaultCurrency;
  bool noInternet = false;
  bool needToLoad = true;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// set  Default Currency
  setDefaultCurrency(DefaultCurrency? currency) {
    defaultCurrency = currency;
    constant.pref?.setString(
        "defaultCryptoCurrency", defaultCurrency?.cryptoDefaultCurrency ?? "");
    if (!(constant.pref?.containsKey("defaultFiatCurrency") ?? false)) {
      constant.pref?.setString(
          "defaultFiatCurrency", defaultCurrency?.fiatDefaultCurrency ?? "");
    }
    constant.cryptoCurrency.value =
        constant.pref?.getString("defaultCryptoCurrency") ?? '';
    constant.contactMail.value =
        currency!.joinUs!.supportMail ?? 'sales@cryptocurrencyscript.com';
    constant.binanceStatus.value = currency.binanceStatus ?? false;
    notifyListeners();
  }

  ///Get Default Currency
  getDefault() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchDefaultCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setDefaultCurrency(decodeResponse.data?.result);
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
}
