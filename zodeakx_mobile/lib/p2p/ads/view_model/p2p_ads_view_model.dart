import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';

import '../../../Common/VerifyGoogleAuthCode/ViewModel/VerifyGoogleAuthenticateViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/DashBoardScreen/Model/ExchangeRateModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../home/model/p2p_advertisement.dart';
import '../../home/model/p2p_currency.dart';
import '../../post_an_ad_view/view/p2p_post_an_ad_view.dart';

class P2PAdsViewModel extends ChangeNotifier {

  bool noInternet = false;
  bool needToLoad = true;
  bool tabLoader = true;
  bool listLoder = false;
  List<String> staticPairs = [
    "ETH",
    "LTC",
    "BTC",
    "LTC",
  ];
  List<String> fiatPairs = [
    "USD",
    "GBP",
    "EUR",
  ];
   List<String>  timeLimit = [
    "15 ${capitalize(stringVariables.min)}",
    "30 ${capitalize(stringVariables.min)}",
    "45 ${capitalize(stringVariables.min)}",
    "1 ${capitalize(stringVariables.hr)}",
  ];
  String selectedCrypto = "ETH";
  String selectedFiat = "USD";

   List<String> typesStaticPairs =  [
  stringVariables.buy,
  stringVariables.sell,
  ];

  P2PAdvertisement? p2pAdvertisement;
  P2PAdvertisement? particularAdvertisement;
  List<P2PCurrency>? p2pCurrency;
  List<P2PCurrency>? fiatCurrencies;
  String? crypto;
  String? side;
  String? status;
  late TabController cryptoTabController;
  int postAdStep = 1;
  double highestPrice = 0;
  PostType postType = PostType.online;
  int priceIndex = 0;
  int sideIndex = 0;
  double yourPrice = 0;
  double floatingPricePercentage = 0;
  bool fixedError = false;
  bool floatingError = false;
  bool paymentError = false;
  TextEditingController fiatPriceController = TextEditingController();
  TextEditingController floatingPriceController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController termsController = TextEditingController();
  TextEditingController autoReplyController = TextEditingController();
  double fiatAmount = 0;
  double minAmount = 0;
  double maxAmount = 0;
  List<String> paymentMethods = [];
  int time = 15;
  String cancelId = "";
  bool buttonLoader = false;
  num? makerFeeValue = 0;
  num? reserveFee = 0;
  List<String>  statusStaticPairs = [
  stringVariables.published,
  stringVariables.offline,
  ];

  P2PAdsViewModel() {

  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// List Loader
  setListLoading(bool loading) async {
    listLoder = loading;
    notifyListeners();
  }

  setPostAdStep(int value) async {
    if (postAdStep == value) return;
    postAdStep = value;
    paymentError = false;
    notifyListeners();
  }

  setTabLoading(bool loading) async {
    tabLoader = loading;
    notifyListeners();
  }

  setButtonLoading(bool loading) async {
    buttonLoader = loading;
    notifyListeners();
  }

  setTime(int value) async {
    time = value;
    notifyListeners();
  }

  setPaymentMethods(List<String> list) {
    paymentMethods = list;
    notifyListeners();
  }

  updatePaymentMethods(String value) async {
    if (paymentMethods.contains(value))
      paymentMethods.remove(value);
    else
      paymentMethods.add(value);
    paymentError = false;
    notifyListeners();
  }

  setPostType(PostType value) async {
    postType = value;
    notifyListeners();
  }

  setPriceIndex(int value) async {
    priceIndex = value;
    notifyListeners();
  }

  setSideIndex(int value) async {
    sideIndex = value;
    notifyListeners();
  }

  setFixedError(bool value) async {
    fixedError = value;
    notifyListeners();
  }

  setFloatingError(bool value) async {
    floatingError = value;
    notifyListeners();
  }

  setPaymentError(bool value) async {
    paymentError = value;
    notifyListeners();
  }

  setCrypto(String? value) async {
    crypto = value;
    notifyListeners();
  }

  setYourPrice(double value) async {
    yourPrice = value;
    notifyListeners();
  }

  setFiatAmount(double value) async {
    fiatAmount = value;
    notifyListeners();
  }

  setMinAmount(double value) async {
    minAmount = value;
    notifyListeners();
  }

  setMaxAmount(double value) async {
    maxAmount = value;
    notifyListeners();
  }

  setFloatingPercentage(double value) async {
    floatingPricePercentage = value;
    notifyListeners();
  }

  setCancelId(String value) async {
    cancelId = value;
    notifyListeners();
  }

  setSelectedCrypto(String value) async {
    selectedCrypto = value;
    getMakerFeeValue();
    notifyListeners();
  }

  setSelectedFiat(String value) async {
    selectedFiat = value;
    notifyListeners();
  }

  setSide(String? value) async {
    side = value;
    notifyListeners();
  }

  setStatus(String? value) async {
    status = value;
    notifyListeners();
  }

  calculatePercentage(double percentage, double amount) {
    return (percentage / 100) * amount;
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
    setLoading(false);
    setTabLoading(true);
    fetchUserAdvertisement();
    notifyListeners();
  }

  getMakerFeeValue() {
    p2pCurrency?.forEach((element) {
      //contain all currency btc,ltc
      if (element.code == selectedCrypto) {
        makerFeeValue = element
            .p2PMakerFee; //while fetching this ==> fetchP2PCurrency() i got p2PMakerFee
      }
    });
    securedPrint("makerFeeValue${selectedCrypto}${makerFeeValue}");
    notifyListeners();
  }

  updateMakerFeeValue(num val) {
    reserveFee = (val * (num.parse(makerFeeValue.toString())) / 100);
    // makerFeeValue = num.parse(totalAmountController.text) - reserveFee!;
    // print(makerFeeValue);
    notifyListeners();
  }

  fetchUserAdvertisement([int page = 0]) async {
    Map<String, dynamic> queryData = {
      "status": ["active", "partially"],
      "start_date": "",
      "end_date": ""
    };

    if (crypto != null) queryData["from_asset"] = crypto;
    if (side != null) queryData["advertisement_type"] = side;
    if (status != null) queryData["trade_status"] = status;

    Map<String, dynamic> mutateUserParams = {
      "userAdvertisementData": {
        "queryData": queryData,
        "skip": page,
        "limit": 5
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchUserAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserAdvertisement(decodeResponse.data?.result, page);
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

  getUserAdvertisement(P2PAdvertisement? p2pAdvertisement, int page) {
  
    if (this.p2pAdvertisement == null || page == 0) {
      this.p2pAdvertisement = p2pAdvertisement;
    } else {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .removeCurrentSnackBar();
      setListLoading(false);
      if ((p2pAdvertisement?.data ?? []).isEmpty) {
        customSnackBar.showSnakbar(
            NavigationService.navigatorKey.currentContext!,
            stringVariables.noMoreRecords,
            SnackbarType.negative);
      } else {
        this.p2pAdvertisement?.data?.addAll(p2pAdvertisement?.data ?? []);
      }
    }

    setTabLoading(false);
    setLoading(false);
    getFiatCurrency();
    notifyListeners();
  }

  fetchParticularUserAdvertisement(String id, [bool isEdit = false]) async {
    Map<String, dynamic> mutateUserParams = {
      "userAdvertisementData": {
        "queryData": {"ad_id": id}
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchUserAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getParticularUserAdvertisement(decodeResponse.data?.result, isEdit);
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

  getParticularUserAdvertisement(P2PAdvertisement? p2pAdvertisement,
      [bool isEdit = false]) {
    particularAdvertisement = p2pAdvertisement;
    Advertisement advertisement =
        particularAdvertisement?.data?.first ?? dummyAdvertisement;
    String adType = capitalize(advertisement.advertisementType!);
    String cryptoCurrency = adType == stringVariables.buy
        ? advertisement.toAsset!
        : advertisement.fromAsset!;
    String fiatCurrency = adType == stringVariables.buy
        ? advertisement.fromAsset!
        : advertisement.toAsset!;
    setSelectedFiat(fiatCurrency);
    setSelectedCrypto(cryptoCurrency);
    if (isEdit) {
      fetchHighestPrice(isEdit);
    } else {
      fetchHighestPrice();
    }
    notifyListeners();
  }

  editAdTradeStatus(String id, String status, VoidCallback updateStatus) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"_id": id, "trade_status": status}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.editAdTradeStatus(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setEditAdTradeStatus(decodeResponse.data, updateStatus);
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

  setEditAdTradeStatus(CommonModel? commonModel, VoidCallback updateStatus) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200) updateStatus();
    notifyListeners();
  }

  getFiatCurrency() async {
    Map<String, dynamic> mutateUserParams = {
      "fetchP2PCurrencyData": {"type": "fiat"}
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
          setFiatCurrency(decodeResponse.data?.result);
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

  setFiatCurrency(List<P2PCurrency>? fiatCurrencies) {
    this.fiatCurrencies = fiatCurrencies;
    fiatPairs.clear();
    fiatCurrencies?.forEach((element) {
      fiatPairs.add(element.code!);
    });
    setSelectedCrypto(staticPairs[0]);
    setSelectedFiat(fiatPairs[0]);
    notifyListeners();
  }

  fetchHighestPrice([bool isEdit = false]) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "from_currency": selectedCrypto,
        "to_currency": selectedFiat,
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchExchangeRate(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setHighestPrice(decodeResponse.data?.result, isEdit);
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

  setHighestPrice(GetExchangeResult? highestPrice, [bool isEdit = false]) {
    this.highestPrice = double.parse(trimDecimalsForBalance(
        ((highestPrice ?? GetExchangeResult()).exchangeRate ?? 0.0)
            .toString()));
    if (isEdit) {
      Advertisement advertisement =
          particularAdvertisement?.data?.first ?? dummyAdvertisement;
      String priceType = capitalize(advertisement.priceType!);
      bool isFixed = priceType == stringVariables.fixed;
      String price = isFixed
          ? advertisement.price.toString()
          : advertisement.floatingPrice.toString();
      fiatPriceController.text = trimAsLength(price, 2);
      setYourPrice(double.parse(price));
    } else {
      fiatPriceController.text = trimAsLength(this.highestPrice.toString(), 2);
      if (priceIndex == 1 && floatingPriceController.text != "100") {
        double value = double.parse(trimDecimals(calculatePercentage(
                double.parse(floatingPriceController.text), this.highestPrice)
            .toString()));
        setYourPrice(value);
      } else {
        setYourPrice(this.highestPrice);
      }
    }
    setLoading(false);
    notifyListeners();
  }

  setCreateAdvertisement(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    if (commonModel?.statusCode == 200) {
      Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
      moveToSuccessfullyPostedView(
          NavigationService.navigatorKey.currentContext!);
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
    notifyListeners();
  }

  createAdvertisement(
      String code, List<Map<String, dynamic>> paymentMethods) async {
    var verifyGoogleAuthenticationViewModel =
        Provider.of<VerifyGoogleAuthenticationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    String tfaType = verifyGoogleAuthenticationViewModel.mobileOtp == true
        ? "mobile_number"
        : "tfa";
    Map<String, dynamic> queryData = {
      "advertisement_type": sideIndex == 0
          ? stringVariables.buy.toLowerCase()
          : stringVariables.sell.toLowerCase(),
      "tfa_code": code,
      "from_asset": sideIndex == 0 ? selectedFiat : selectedCrypto,
      "to_asset": sideIndex == 0 ? selectedCrypto : selectedFiat,
      "price_type": priceIndex == 0
          ? stringVariables.fixed.toLowerCase()
          : stringVariables.floating.toLowerCase(),
      "price": yourPrice,
      "tfa_type": tfaType,
      "amount": double.parse(totalAmountController.text),
      "trade_status": postType == PostType.online
          ? stringVariables.published.toLowerCase()
          : stringVariables.offline.toLowerCase(),
      "total": fiatAmount,
      "min_trade_order": minAmount,
      "max_trade_order": maxAmount,
      "payment_method": paymentMethods,
      "payment_time_limit": time
    };

    if (priceIndex == 1)
      queryData["floating_price_margin"] = floatingPricePercentage;
    if (termsController.text.isNotEmpty)
      queryData["remarks"] = termsController.text;
    if (autoReplyController.text.isNotEmpty)
      queryData["auto_reply"] = autoReplyController.text;

    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.createAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCreateAdvertisement(decodeResponse.data);
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

  setCloseAdvertisement(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    cancelId = "";
    if (commonModel?.statusCode == 200) fetchUserAdvertisement();
    notifyListeners();
  }

  closeAdvertisement(String code) async {
    var verifyGoogleAuthenticationViewModel =
        Provider.of<VerifyGoogleAuthenticationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    String tfaType = verifyGoogleAuthenticationViewModel.mobileOtp == true
        ? "mobile_number"
        : "tfa";

    Map<String, dynamic> mutateUserParams = {
      "data": {"id": cancelId, "tfaCode": code, "tfa_type": tfaType}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.closeAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCloseAdvertisement(decodeResponse.data);
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

  setEditAdvertisement(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    int count = 0;
    Navigator.of(NavigationService.navigatorKey.currentContext!)
        .popUntil((_) => count++ >= 2);
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200) {
      fetchUserAdvertisement();
      cancelId = "";
    }
    buttonLoader = false;
    notifyListeners();
  }

  editAdvertisement(
      String code, List<Map<String, dynamic>> paymentMethods) async {
    Map<String, dynamic> queryData = {
      "amount": double.parse(totalAmountController.text),
      "max_trade_order": maxAmount,
      "min_trade_order": minAmount,
      "payment_method": paymentMethods,
      "payment_time_limit": time,
      "price": yourPrice,
      "tfa_code": code,
      "total": fiatAmount,
      "trade_status": postType == PostType.online
          ? stringVariables.published.toLowerCase()
          : stringVariables.offline.toLowerCase(),
      "_id": cancelId,
    };

    if (priceIndex == 1)
      queryData["floating_price_margin"] = floatingPricePercentage;
    if (termsController.text.isNotEmpty)
      queryData["remarks"] = termsController.text;
    if (autoReplyController.text.isNotEmpty)
      queryData["auto_reply"] = autoReplyController.text;

    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.editAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setEditAdvertisement(decodeResponse.data);
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

  clearData() {
    noInternet = false;
    needToLoad = true;
    tabLoader = true;
    listLoder = false;
    staticPairs = [
      "ETH",
      "LTC",
      "BTC",
      "LTC",
    ];
    fiatPairs = [
      "USD",
      "GBP",
      "EUR",
    ];
    selectedCrypto = "ETH";
    selectedFiat = "USD";
    p2pAdvertisement = null;
    particularAdvertisement = null;
    p2pCurrency = null;
    crypto = null;
    side = null;
    status = null;
    fiatCurrencies = null;
    postAdStep = 1;
    highestPrice = 0;
    priceIndex = 0;
    sideIndex = 0;
    floatingError = false;
    fixedError = false;
    paymentError = false;
    paymentMethods = [];
    yourPrice = 0;
    floatingPricePercentage = 0;
    fiatAmount = 0;
    minAmount = 0;
    maxAmount = 0;
    time = 15;
    cancelId = "";
    notifyListeners();
  }
}
