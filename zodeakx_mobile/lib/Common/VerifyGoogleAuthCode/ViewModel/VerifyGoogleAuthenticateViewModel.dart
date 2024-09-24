import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Common/VerifyGoogleAuthCode/Model/VerifyGoogleAuthenticateModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/p2p/profile/model/UserPaymentDetailsModel.dart';

import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../p2p/ads/view_model/p2p_ads_view_model.dart';
import '../../../p2p/payment_methods/view_model/p2p_payment_methods_view_model.dart';
import '../../LoginScreen/Model/verifyTfaLogin.dart';
import '../../Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';

class VerifyGoogleAuthenticationViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  AntiPhishingCodeVerification? verifyAuthCode;
  GetCurrencyViewModel? getCurrencyViewModel;
  bool mobileOtp = false;
  bool isPassCodeEnabled = true;
  int requestTimer = 30;
  TfaLogin? tfaLogin;
  int count = 0;
  CommonModel? commonModel;

  setRequestTimer(int value) async {
    requestTimer = value;
    notifyListeners();
  }

  switchMobileMethod(bool value) {
    mobileOtp = value;
    notifyListeners();
  }

  VerifyGoogleAuthenticationViewModel() {
    showSnackbar = false;
  }

  setPasscodeStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPasscodeEnabled', status);
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  ///Mutate Tfa Login
  setVerifyTfaCode(TfaLogin? tfaCodeLogin) {
    tfaLogin = tfaCodeLogin;
    notifyListeners();
  }

  /// Create user response
  getVerification(AntiPhishingCodeVerification? verifiedResponse, context) {
    verifyAuthCode = verifiedResponse;
  }

  getSnackBarstatus() {
    positiveStatus =
        ((verifyAuthCode?.statusCode ?? 200) == 200) ? true : false;
    showSnackbar = true;
  }

  /// antiphishing code
  verifiedCode(String code, BuildContext context,
      AuthenticationVerificationType screenType) async {
    securedPrint(screenType);
    setLoading(true);
    String tfaType = mobileOtp == true ? "mobile_number" : "tfa";

    Map<String, dynamic> mutateUserParams = {
      "input": {"verifyCode": code, "tfa_type": tfaType}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.verifiedCode(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          constant.googleAuthentciate.value = code;
          customSnackBar.showSnakbar(
              context,
              decodeResponse.data?.statusMessage ?? '',
              decodeResponse.data?.statusCode == 200
                  ? SnackbarType.positive
                  : SnackbarType.negative);
          getVerification(verifyAuthCode, context);
          (decodeResponse.data?.statusCode == 200)
              ? screenType == AuthenticationVerificationType.ForgotPayPinModal
                  ? move()
                  : screenType == AuthenticationVerificationType.AntiPhishing
                      ? moveToAntiPhishingCode(
                          context, AuthenticationVerificationType.AntiPhishing)
                      : screenType == AuthenticationVerificationType.dashBoard
                          ? moveToAntiPhishingCode(
                              context, AuthenticationVerificationType.dashBoard)
                          : (screenType ==
                                      AuthenticationVerificationType
                                          .AddPayment ||
                                  screenType ==
                                      AuthenticationVerificationType
                                          .EditPayment)
                              ? moveToPayment(context, code, screenType)
                              : screenType ==
                                      AuthenticationVerificationType.PostAd
                                  ? moveToPostCompleted(context, code)
                                  : screenType ==
                                          AuthenticationVerificationType.CloseAd
                                      ? moveToCloseAd(context, code)
                                      : screenType ==
                                              AuthenticationVerificationType
                                                  .EditAd
                                          ? moveToEditAd(context, code)
                                          : screenType ==
                                                  AuthenticationVerificationType
                                                      .ForgotPin
                                              ? Navigator.pop(
                                                  context, screenType)
                                              : Timer(
                                                  Duration(seconds: 2),
                                                  () => Navigator.pop(
                                                      context, screenType))
              : () => () {};
          notifyListeners();
          break;
        default:
          break;
      }
    } else {
      noInternet = true;
    }
  }

  move() {
    getCurrencyViewModel = Provider.of<GetCurrencyViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    Navigator.pop(
      NavigationService.navigatorKey.currentContext!,
    );
    getCurrencyViewModel?.setForgotPinView(true);
  }

  moveToPostCompleted(
    BuildContext context,
    String code,
  ) {
    P2PAdsViewModel viewModel =
        Provider.of<P2PAdsViewModel>(context, listen: false);
    P2PPaymentMethodsViewModel paymentMethodsViewModel =
        Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    List<UserPaymentDetails> userPaymentDetails = [];
    List<Map<String, dynamic>> paymentMethods = [];
    for (int i = 0; i < viewModel.paymentMethods.length; i++) {
      for (int j = 0;
          j < (paymentMethodsViewModel.paymentMethods ?? []).length;
          j++) {
        String title = viewModel.paymentMethods[i];
        if (title == stringVariables.bankTransfer) title = "bank_transfer";
        if (title == paymentMethodsViewModel.paymentMethods?[j].paymentName) {
          userPaymentDetails.add(paymentMethodsViewModel.paymentMethods?[j] ??
              UserPaymentDetails());
        }
      }
    }
    userPaymentDetails.forEach((element) {
      Map<String, dynamic> queryData = {
        "payment_method_id": element.id,
        "payment_method_name": element.paymentName
      };
      paymentMethods.add(queryData);
    });
    viewModel.createAdvertisement(code, paymentMethods);
  }

  moveToCloseAd(
    BuildContext context,
    String code,
  ) {
    P2PAdsViewModel viewModel =
        Provider.of<P2PAdsViewModel>(context, listen: false);
    Navigator.pop(context);
    viewModel.closeAdvertisement(code);
  }

  moveToEditAd(
    BuildContext context,
    String code,
  ) {
    P2PAdsViewModel viewModel =
        Provider.of<P2PAdsViewModel>(context, listen: false);
    P2PPaymentMethodsViewModel paymentMethodsViewModel =
        Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    List<UserPaymentDetails> userPaymentDetails = [];
    List<Map<String, dynamic>> paymentMethods = [];
    for (int i = 0; i < viewModel.paymentMethods.length; i++) {
      for (int j = 0;
          j < (paymentMethodsViewModel.paymentMethods ?? []).length;
          j++) {
        if (viewModel.paymentMethods[i] ==
            paymentMethodsViewModel.paymentMethods?[j].paymentName) {
          userPaymentDetails.add(paymentMethodsViewModel.paymentMethods?[j] ??
              UserPaymentDetails());
        }
      }
    }
    userPaymentDetails.forEach((element) {
      Map<String, dynamic> queryData = {
        "payment_method_id": element.id,
        "payment_method_name": element.paymentName
      };
      paymentMethods.add(queryData);
    });
    viewModel.setButtonLoading(true);
    viewModel.editAdvertisement(code, paymentMethods);
  }

  moveToPayment(BuildContext context, String code,
      AuthenticationVerificationType screenType) {
    bool isAdd = screenType == AuthenticationVerificationType.AddPayment;
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= (isAdd ? 3 : 2));
    P2PPaymentMethodsViewModel viewModel =
        Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    if (isAdd) {
      viewModel.addUserPaymentMethod(code, viewModel.paymentDetails ?? "");
    } else {
      viewModel.updateUserPaymentMethod(code, viewModel.paymentDetails ?? "");
    }
  }

  /// verify TFA code
  verifyTfaCode(String code, BuildContext context) async {
    setLoading(true);
    String tfaType = mobileOtp == true ? "mobile_number" : "tfa";
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "onecode": code,
        "token": constant.token.value,
        "device_type": "mobile",
        "tfa_type": tfaType
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.verifyTfaCode(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          if (decodeResponse.data?.statusCode == 200) {
            constant.userToken.value = decodeResponse.data?.result?.token ?? "";
            constant.userLoginStatus.value = true;
            constant.pref?.setString(
                "userToken", decodeResponse.data?.result?.token ?? "");
            constant.pref?.setBool('loginStatus', true);
            constant.pref?.setString("userEmail",
                decodeResponse.data?.result?.email ?? "${constant.appEmail}");
            constant.pref?.setString(
                "sessionId", decodeResponse.data?.result?.sessionId ?? "");
          }
          customSnackBar.showSnakbar(
              context,
              decodeResponse.data?.statusMessage ?? '',
              decodeResponse.data?.statusCode == 200
                  ? SnackbarType.positive
                  : SnackbarType.negative);
          decodeResponse.data?.statusCode == 200
              ? moveToMarket(context)
              : decodeResponse.data?.statusCode == 400
                  ? moveToEmailVerification(
                      context,
                      stringVariables.login,
                      int.parse(decodeResponse.data?.result?.tempOtp ?? ""),
                      decodeResponse.data?.result?.email ?? "",
                      ((decodeResponse.data?.result?.tokenType ?? "") ==
                              "NewDeviceLogin")
                          ? EmailVerificationType.NewdeviceLogin
                          : EmailVerificationType.Register,
                      decodeResponse.data?.result?.tokenType ?? "register")
                  : () {};
          setVerifyTfaCode(decodeResponse.data?.result);
          notifyListeners();
          break;
        default:
          break;
      }
    } else {
      noInternet = true;
    }
  }

  ///  change login password
  changeCode(String code, BuildContext context) async {
    setLoading(true);
    String tfaType = mobileOtp == true ? "mobile_number" : "tfa";
    Map<String, dynamic> mutateUserParams = {
      "input": {"verifyCode": code, "tfa_type": tfaType}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.verifiedCode(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          (decodeResponse.data?.statusCode == 200)
              ? moveToLoginPasswordChange(context)
              : () {};
          customSnackBar.showSnakbar(
              context,
              decodeResponse.data?.statusMessage ?? '',
              decodeResponse.data?.statusCode == 200
                  ? SnackbarType.positive
                  : SnackbarType.negative);
          notifyListeners();
          break;
        default:
          break;
      }
    } else {
      noInternet = true;
    }
  }

  /// Get Otp from mobile
  getOtpFromMobile(String? mobile_code, String? mobile_number) async {
    setLoading(true);
    Map<String, dynamic> mutateUserParams = {
      "data": {"mobile_code": mobile_code, "mobile_number": mobile_number}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.mutateOtpCodeFromMobile(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          setOtpFromMobile(decodeResponse.data);
          break;
        default:
          break;
      }
    } else {
      noInternet = true;
    }
  }

  setOtpFromMobile(CommonModel? data) {
    commonModel = data;
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        "${commonModel?.statusMessage}",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    notifyListeners();
  }
}
