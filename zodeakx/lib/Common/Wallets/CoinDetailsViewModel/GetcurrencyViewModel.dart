import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/FiatDepositScreen/Model/FiatCommonDepositModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../ZodeakX/Setting/Model/GetUserByJwtModel.dart';
import '../../BankDetailsHistory/Model/BankDetailHistoryModel.dart';
import '../CoinDetailsModel/FiatCurrencyModel.dart';
import '../CoinDetailsModel/get_currency.dart';
import '../CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';

class GetCurrencyViewModel extends ChangeNotifier {
  GetCurrencyViewModel? getCurrencyViewModel;
  bool noInternet = false;
  bool needToLoad = true;
  bool positiveStatus = false;
  bool showSnackbar = false;
  List<GetCurrency>? getCurrency;
  List<GetFiatCurrencies>? getFiatCurrency;
  CreateFiatDepositModel? createFiatDepositModel;
  List<GetBankHistoryDetails>? bankDetail;
  num minWithdrawLimit = 0.0;
  num fiatMinWithdrawLimit = 0.0;
  num withdrawFee = 0.0;
  num withdraw = 0.0;
  num withdrawFiat = 0.0;
  num fiatWithdrawFee = 0.0;
  num transactionFee = 0.0;
  num youWillGet = 0.0;
  num fiatTransactionFee = 0.0;
  num fiatYouWillGet = 0.0;
  List<String>? bankName = [];
  String buttonValue = 'Enable';
  GetUserJwt? viewModelVerification;
  String? network = "ETH";
  List<String> networkDropDown = [];
  List<GetCurrency>? getCurrencyDetails;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setNetwork(String? value){
    network = value;
    notifyListeners();
  }

  /// set Crypto Withdraw
  setCurrencyForCryptoWithdraw(List<GetCurrency>? getCryptoCurrency) {
    networkDropDown.clear();
    getCurrency = getCryptoCurrency;
    getCurrency?.forEach((element) {
      if (element.currencyCode == constant.walletCurrency.value) {
        networkDropDown = element.network!;
      }
    });
    setNetwork(networkDropDown[0]);
    var amount = getCurrency
        ?.where((c) => c.currencyCode == constant.walletCurrency.value)
        .toList();
    minWithdrawLimit = amount?.first.minWithdrawLimit ?? 0;
    withdraw = amount?.first.withdrawFee ?? 0;
    withdrawFee = double.parse('${amount?.first.withdrawFee}') / 100.0;
    notifyListeners();
  }

  /// set Fiat Withdraw
  setCurrencyForFiatWithdraw(List<GetFiatCurrencies>? FiatCurrency) {
    var mat = FiatCurrency?.where(
        (e) => e.currencyCode == constant.walletCurrency.value).toList();
    fiatMinWithdrawLimit = mat?.first.minWithdrawLimit ?? 0;
    getFiatCurrency = FiatCurrency;
    var amo = getFiatCurrency
        ?.where((c) => c.currencyCode == constant.walletCurrency.value)
        .toList();
    withdrawFiat = amo?.first.withdrawFee ?? 0;
    fiatWithdrawFee = withdrawFiat / 100.0;
    notifyListeners();
  }

  /// set Bank Details
  setBankDetails(List<GetBankHistoryDetails>? bank) {
    bankDetail = bank;
    bankDetail?[0].bankDetails?.forEach((e) {
      bankName?.add('${e.bankName}');
    });
    notifyListeners();
  }

  /// set Crypto Withdraw
  setMinimumWithdrawAmount(List<GetCurrency>? getCryptoCurrency) {
    minWithdrawLimit = getCryptoCurrency?.first.minWithdrawLimit ?? 0;
    notifyListeners();
  }

  /// set Fiat Withdraw
  setMinimumWithdrawAmountForFiat(List<GetFiatCurrencies>? FiatCurrency) {
    fiatMinWithdrawLimit = FiatCurrency?.first.minWithdrawLimit ?? 0;
    notifyListeners();
  }

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// crypto
  updateExchangeRate(double givenValue) {
    transactionFee = givenValue * withdrawFee;

    youWillGet = givenValue - transactionFee;
    notifyListeners();
  }

  /// fiat
  updateFiatExchangeRate(double givenValue) {
    fiatTransactionFee = givenValue * fiatWithdrawFee;
    fiatYouWillGet = givenValue - fiatTransactionFee;
    notifyListeners();
  }

  /// set  Create Crypto Withdraw
  setCreateCryptoWithdraw(CreateFiatDepositModel? getCryptoWithdraw) {
    createFiatDepositModel = getCryptoWithdraw;
    notifyListeners();
  }

  ///Get Currency
  getCurrencyForCryptoWithdraw([currencyType]) async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          (decodeResponse.data?.statusCode == 200 &&
                  currencyType == "CurrencyType.FIAT")
              ? getCurrencyForFiatWithdraw()
              : getBankDetails();
          setCurrencyForCryptoWithdraw(decodeResponse.data?.result);
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

  ///Get Fiat Currency
  getCurrencyForFiatWithdraw() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getFiatCurrency();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCurrencyForFiatWithdraw(decodeResponse.data?.result);
          decodeResponse.data?.statusCode == 200 ? getBankDetails() : () {};
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

  ///Get Currency
  getBankDetails() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchBankDetailsHistory();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setBankDetails(decodeResponse.data?.result);
          getIdVerification();
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

  getMinWithdrawDetails(){
    var commonWithdrawViewModel = Provider.of<CommonWithdrawViewModel>(NavigationService.navigatorKey.currentContext!, listen: false);
    getCurrencyDetails = getCurrency?.where((element) => element.currencyCode == constant.walletCurrency.value).toList();
    if(getCurrencyDetails!.first.networkDetails!.isEmpty){
      minWithdrawLimit = getCurrencyDetails?.first.minWithdrawLimit ?? 0;
      withdraw = getCurrencyDetails?.first.withdrawFee ?? 0;
      withdrawFee = double.parse('${getCurrencyDetails?.first.withdrawFee}') / 100.0;
      securedPrint("Hiii");
    }else{
      securedPrint("network${commonWithdrawViewModel?.netwoksDropDownValue}");
      getCurrencyDetails?.forEach((element) {
        for( var i = 0; i < element.networkDetails!.length; i++){
          if(element.networkDetails![i].network ==commonWithdrawViewModel?.netwoksDropDownValue.toString() ){
            minWithdrawLimit = element.networkDetails![i].minWithdrawLimit ?? 0;
            withdraw = element.networkDetails![i].withdrawFee ?? 0;
            withdrawFee = double.parse('${element.networkDetails![i].withdrawFee}') / 100.0;
            securedPrint("Biii");
          }else{
            securedPrint("GGGGiiiii");
          }
        }

      });

    }
    notifyListeners();
  }

  /// Create Crypto Withdraw
  CreateCryptoWithdraw(
      String currency,
      String recepientAddress,
      double sent_amount,
      num fees,
      num fee_percent,
      num receive_amount,
      BuildContext context) async {
    String? network = getCurrency
        ?.where((element) => element.currencyCode == currency)
        .first
        .network!.first;
    Map<String, dynamic> queryData = {
      "currency": currency,
        "tfa_code": constant.googleAuthentciate.value.toString(),
        "receipient_Address": recepientAddress,
        "sent_amount": sent_amount,
        "fees": fees,
        "fee_percent": fee_percent,
        "network": network,
        "receive_amount": receive_amount
    };
    // if(currency == "XRP"){
    //   queryData[ "to_tag_id"] = tagId;
    // }
    queryData[ "tfa_type"] = "tfa";
    Map<String, dynamic> mutateUserParams = {"data": queryData};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.mutateCryptoWithdraw(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCreateCryptoWithdraw(decodeResponse.data);
          customSnackBar.showSnakbar(
              context,
              decodeResponse.data?.statusMessage ?? '',
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

  /// Create Fiat Withdraw
  CreateFiatWithdraw(String currency, double sentAmount, num adminFee,
      num feePercent, BuildContext context, String? bankID) async {
    num admin = sentAmount * adminFee;
    num receivedAmount = sentAmount - admin;
    String receive = receivedAmount.toStringAsFixed(2);
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "currency": currency,
        "tfa_code": constant.googleAuthentciate.value,
        "fee_percent": feePercent,
        "admin_fee": admin,
        "received_amount": double.parse('${receive}'),
        "bank_details_id": bankID,
        "sent_amount": sentAmount,
        "tfa_type":"tfa",
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.mutateFiatWithdraw(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCreateCryptoWithdraw(decodeResponse.data);
          customSnackBar.showSnakbar(
              context,
              decodeResponse.data?.statusMessage ?? '',
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

  /// Get IdVerification

  getIdVerification() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      constant.buttonValue.value = response.result?.tfaStatus ?? '';
      constant.antiCode.value = response.result?.antiPhishingCode ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          constant.pref?.setString(
              "firstName",
              response.result?.kyc?.idProof?.firstName ??
                  "${constant.appName}");
          buttonValue = response.result?.tfaStatus ?? '';
          constant.QRSecertCode.value = response.result?.tfaEnableKey ?? "";
          constant.buttonValue.value = response.result?.tfaStatus ?? '';
          constant.pref?.setString(
              "buttonValue", response.result?.tfaStatus ?? "UnVerified");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("buttonValue", constant.buttonValue.value);
          constant.antiCode.value = response.result?.antiPhishingCode ?? '';
          prefs.setString("code", constant.antiCode.value);
          setIdVerification(decodeResponse.data?.result);
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
