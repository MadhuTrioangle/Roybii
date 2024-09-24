import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';

import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../Repositories/ProductRepositories.dart';
import '../Model/FIatDepositModel.dart';
import '../Model/FiatCommonDepositModel.dart';
import '../Model/GetPaymentCurrencyExchangeRateModel.dart';
import '../Model/braintree_client_token.dart';

class FiatDepositViewModel extends ChangeNotifier {
  FiatDepositViewModel? fiatDepositViewModel;
  bool noInternet = false;
  bool needToLoad = true;
  bool paypalLoader = false;
  XFile? imagePic;
  String? imagePicName;
  String? imgUrl;
  dynamic exchangeRate;
  bool tabView = true;
  dynamic fiatExchangeRate;
  List<GetAdminDetails>? getAdminDetails;
  CreateFiatDepositModel? createFiatDepositModel;
  PaymentCurrencyExchangeRate? paymentCurrencyExchangeRate;
  String splitText = '/image_picker_';
  BraintreeClientToken? braintreeClientToken;
  final ImagePicker imagePicker = ImagePicker();

  Future imagePath() async {
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front);
    imagePic = XFile(image!.path);
    if (Platform.isAndroid) splitText = '/scaled_image_picker';
    imagePicName = imagePic?.path.split(splitText).last;
    final bytes = File(imagePic!.path).readAsBytesSync();
    imgUrl = base64Encode(bytes);
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Loader
  setPaypalLoading(bool loading) async {
    paypalLoader = loading;
    notifyListeners();
  }

  setTabView(bool tab) async {
    tabView = tab;
    notifyListeners();
  }

  /// initilizing API
  FiatDepositViewModel() {
    /* getAdminBankDetails();
    getPaymentCurrencyExchangeRate();*/
  }

  /// set Admin Details
  setAdminDetails(List<GetAdminDetails>? adminDetails) {
    getAdminDetails = adminDetails;
    notifyListeners();
  }

  /// set Fiat Deposit
  setFiatDeposit(CreateFiatDepositModel? fiatDeposit) {
    createFiatDepositModel = fiatDeposit;
    notifyListeners();
  }

  /// set Fiat Deposit
  setFiatTransaction(
      CommonModel? fiatDeposit, TextEditingController textEditingController) {
    setPaypalLoading(false);
    textEditingController.clear();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        '${fiatDeposit?.statusMessage}',
        fiatDeposit?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    notifyListeners();
  }

  /// set Payment Currency Exchange Rate
  setPaymentCurrencyExchangeRate(PaymentCurrencyExchangeRate? exchange) {
    paymentCurrencyExchangeRate = exchange;
    fiatExchangeRate = paymentCurrencyExchangeRate?.exchangeRate;
    getBraintreeToken();
    notifyListeners();
  }

  updateExchangeRate(double givenValue) {
    exchangeRate = (givenValue * fiatExchangeRate).toStringAsFixed(2);
    notifyListeners();
  }

  setBraintreeToken(BraintreeClientToken? braintreeToken) {
    braintreeClientToken = braintreeToken;
    notifyListeners();
  }

  getBraintreeToken() async {
    var response = await productRepository.fetchBraintreeClientToken();
    var decodeResponse = HandleResponse.completed(response);
    switch (decodeResponse.status?.index) {
      case 0:
        break;
      case 1:
        setBraintreeToken(decodeResponse.data?.result);
        break;
      default:
        break;
    }
  }

  /// Get Admin Details

  getAdminBankDetails() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchAdminDetails();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setAdminDetails(decodeResponse.data?.result);
          getPaymentCurrencyExchangeRate();
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

  /// update Fiat Deposit
  UpdateFiatDeposit(int amount, String transactionId, String? imgUrl,
      BuildContext context) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "transaction_id": transactionId,
        "amount": amount,
        "transaction_receipt": {"image": imgUrl, "type": imagePicName},
        "currency_code": constant.walletCurrency.value,
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.updateFiatDeposit(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFiatDeposit(decodeResponse.data);
          customSnackBar.showSnakbar(
              context,
              '${decodeResponse.data?.statusMessage}',
              decodeResponse.data?.statusCode == 200
                  ? SnackbarType.positive
                  : SnackbarType.negative);
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

  /// get Payment Currency Exchange Rate
  getPaymentCurrencyExchangeRate() async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"from_currency": constant.walletCurrency.value}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchPaymentExchangeRate(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setPaymentCurrencyExchangeRate(decodeResponse.data?.result);
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

  /// update Fiat Deposit
  UpdateFiatTrasaction(String amount, String userAmount, String nonce,
      TextEditingController textEditingController, BuildContext context) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "amount": double.parse(amount),
        "user_amount": double.parse(userAmount),
        "user_currency": constant.walletCurrency.value,
        "nonce": nonce
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.updateFiatTransaction(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFiatTransaction(decodeResponse.data, textEditingController);
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
