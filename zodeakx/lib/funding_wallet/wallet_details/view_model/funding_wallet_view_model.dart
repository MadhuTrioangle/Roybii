import 'package:flutter/cupertino.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsModel/get_currency.dart';


import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/CurrencyPreferenceScreen/Model/CurrencyPreferenceModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';

class FundingWalletViewModel extends ChangeNotifier{

  bool needToLoad = false;
  bool noInternet = false;
  List<FiatCurrency>? viewModelCurrencyPairs;
  List<GetCurrency>? getCurrency;
  List<String> fiat = [];
  List<String> getAllCoins = [];
  List<String> getCoins = [];

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

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

  /// set FiatCurrency
  setFiatCurrency(List<FiatCurrency>? fiatCurrency) {
    viewModelCurrencyPairs = fiatCurrency;
    fiat.clear();
    getAllCoins?.clear();
    for (var currencyPairs in viewModelCurrencyPairs ?? []) {
      fiat.add('${currencyPairs.currencyCode}');
      getAllCoins.add('${currencyPairs.currencyCode}');
    }

    notifyListeners();
  }


  /// Get Crypto Currency
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

  /// set  Crypto Currency
  setCryptoCurrency(List<GetCurrency>? CryptoCurrency) {
    getCurrency = CryptoCurrency;
    getCoins.clear();
    getCurrency?.forEach((element) {
      getCoins.add(element.currencyCode!);
      getAllCoins.add(element.currencyCode!);
    });
    notifyListeners();
  }



}