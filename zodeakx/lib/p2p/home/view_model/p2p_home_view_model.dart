import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/p2p/home/model/p2p_advertisement.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../model/p2p_currency.dart';
import '../model/p2p_payment_methods.dart';

class P2PHomeViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool tabLoader = true;
  bool listLoder = false;
  bool checkAlert = false;
  bool amountFilter = false;
  bool paymentMethodFilter = false;
  bool amountSelected = false;
  bool paymentSelected = false;
  List<String> staticPairs = [
    "ETH",
    "LTC",
    "BTC",
    "LTC",
  ];
  int noOfOnBoard = 3;
  int activeOnBoard = 0;
  String fiatCurrency = "GBP";
  List<P2PCurrency>? p2pCurrency;
  P2PAdvertisement? p2pAdvertisement;
  List<PaymentMethods>? paymentMethods;
  late TabController buyTabController;
  late TabController sellTabController;
  TextEditingController amountController = TextEditingController();
  String side = "sell";
  String crypto = "ETH";
  String? amount;
  String? payment;
  String? selectedPayment;
  List<String> cards = [
    stringVariables.paytm,
    stringVariables.imps,
    stringVariables.upi,
    stringVariables.bankTransfer,
  ];

  List<String> menuItems = [
    stringVariables.menu,
    stringVariables.paymentMethods,
    stringVariables.orderHistory,
    stringVariables.p2pUserCenter,
    stringVariables.advertisementMode,
  ];

  List<String> menuIcons = [
    p2pMenuClose,
    p2pPayment,
    p2pOrderHistory,
    p2pUserCenter,
    p2pAdMode,
  ];

  P2PHomeViewModel() {
    setFiatCurrency(constant.pref?.getString("defaultFiatCurrency") ?? "GBP");
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Tab Loader
  setTabLoading(bool loading) async {
    tabLoader = loading;
    notifyListeners();
  }

  /// List Loader
  setListLoading(bool loading) async {
    listLoder = loading;
    notifyListeners();
  }

  setSide(String value) {
    side = value;
    notifyListeners();
  }

  setCrypto(String value) {
    crypto = value;
    notifyListeners();
  }

  setAmount(String? value) {
    amount = value;
    notifyListeners();
  }

  setSelectedPayment(int index) {
    if (selectedPayment != cards[index])
      selectedPayment = cards[index];
    else
      selectedPayment = null;
    notifyListeners();
  }

  /// check Alert
  setCheckAlert(bool value) async {
    checkAlert = value;
    notifyListeners();
  }

  /// amount
  setAmountFilter(bool value) async {
    amountFilter = value;
    notifyListeners();
  }

  updateCard(String? value) {
    payment = value;
    notifyListeners();
  }

  ///  payment methods
  setPaymentMethodFilter(bool value) async {
    paymentMethodFilter = value;
    notifyListeners();
  }

  /// amount
  setAmountSelected(bool value) async {
    amountSelected = value;
    if (amount != null) amountController.text = amount ?? "";
    notifyListeners();
  }

  ///  payment methods
  setPaymentSelected(bool value) async {
    paymentSelected = value;
    if (payment == null)
      selectedPayment = null;
    else
      selectedPayment = payment;
    notifyListeners();
  }

  /// active OnBoard
  setActiveOnBoard(int value) async {
    activeOnBoard = value;
    notifyListeners();
  }

  /// active OnBoard
  setFiatCurrency(String value, [refresh = false]) async {
    fiatCurrency = value;
    if (refresh) fetchAdvertisement();
    notifyListeners();
  }

  //API
  fetchP2PCurrency(VoidCallback initTabController) async {
    Map<String, dynamic> mutateUserParams = {
      "fetchP2PCurrencyData": {"type": "crypto"}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchP2PCurrency(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getP2PCurrency(decodeResponse.data?.result, initTabController);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      setLoading(true);
    }
  }

  getP2PCurrency(
      List<P2PCurrency>? p2pCurrency, VoidCallback initTabController) {
    this.p2pCurrency = p2pCurrency;
    staticPairs.clear();
    p2pCurrency?.forEach((element) {
      staticPairs.add(element.code!);
    });
    initTabController();
    setCrypto(staticPairs[0]);
    fetchPaymentMethods();
    notifyListeners();
  }

  fetchPaymentMethods() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchPaymentMethods();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getPaymentMethods(decodeResponse.data?.result);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      setLoading(true);
    }
  }

  getPaymentMethods(List<PaymentMethods>? paymentMethods) {
    this.paymentMethods = paymentMethods;
    cards.clear();
    paymentMethods?.forEach((element) {
      String title = element.name!;
      if (title == "bank_transfer") title = stringVariables.bankTransfer;
      cards.add(title);
    });
    setLoading(false);
    fetchAdvertisement();
    notifyListeners();
  }

  fetchAdvertisement([int page = 0]) async {
    Map<String, dynamic> queryData = {
      "advertisement_type": side,
      "from_asset":
      capitalize(side) == stringVariables.buy ? fiatCurrency : crypto,
      "to_asset":
      capitalize(side) == stringVariables.buy ? crypto : fiatCurrency
    };

    if (amount != null && payment != null) {
      queryData = {
        "advertisement_type": side,
        "from_asset":
        capitalize(side) == stringVariables.buy ? fiatCurrency : crypto,
        "to_asset":
        capitalize(side) == stringVariables.buy ? crypto : fiatCurrency,
        "payment_method": payment,
        "amount": double.parse(amount ?? "0.0"),
      };
    } else if (amount != null) {
      queryData = {
        "advertisement_type": side,
        "from_asset":
        capitalize(side) == stringVariables.buy ? fiatCurrency : crypto,
        "to_asset":
            capitalize(side) == stringVariables.buy ? crypto : fiatCurrency,
        "amount": double.parse(amount ?? "0.0"),
      };
    } else if (payment != null) {
      queryData = {
        "advertisement_type": side,
        "from_asset":
            capitalize(side) == stringVariables.buy ? fiatCurrency : crypto,
        "to_asset":
            capitalize(side) == stringVariables.buy ? crypto : fiatCurrency,
        "payment_method": payment,
      };
    }

    Map<String, dynamic> mutateUserParams = {
      "fetchAdvertisementData": {
        "queryData": queryData,
        "sort": {"price": side == stringVariables.buy ? -1 : 1},
        "skip": page,
        "limit": 10
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setTabLoading(false);
          break;
        case 1:
          getAdvertisement(decodeResponse.data?.result, page);
          break;
        default:
          setTabLoading(false);
          break;
      }
    } else {
      noInternet = true;
      setTabLoading(true);
    }
  }

  getAdvertisement(P2PAdvertisement? p2pAdvertisement, int page) {
    if (this.p2pAdvertisement == null || page == 0)
      this.p2pAdvertisement = p2pAdvertisement;
    else {
      setListLoading(false);
      if ((p2pAdvertisement?.data ?? []).isEmpty)
        customSnackBar.showSnakbar(
            NavigationService.navigatorKey.currentContext!,
            stringVariables.noMoreRecords,
            SnackbarType.negative);
      else
        this.p2pAdvertisement?.data?.addAll(p2pAdvertisement?.data ?? []);
    }
    setTabLoading(false);
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    tabLoader = true;
    listLoder = false;
    checkAlert = false;
    amountFilter = false;
    paymentMethodFilter = false;
    amountSelected = false;
    paymentSelected = false;
    staticPairs = [
      "ETH",
      "LTC",
      "BTC",
      "LTC",
    ];
    noOfOnBoard = 3;
    activeOnBoard = 0;
    fiatCurrency = "GBP";
    p2pCurrency = null;
    p2pAdvertisement = null;
    paymentMethods = null;
    side = "sell";
    crypto = "ETH";
    amount = null;
    payment = null;
    selectedPayment = null;
    cards = [
      stringVariables.paytm,
      stringVariables.imps,
      stringVariables.upi,
      stringVariables.bankTransfer,
    ];
    notifyListeners();
  }
}
