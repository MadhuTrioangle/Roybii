import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/ConfirmPassword/ViewModel/ConfirmPasswordViewModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/encryptAndDecrypt.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../LoginScreen/Model/LoginModel.dart';
import '../../LoginScreen/Model/verifyNewDeviceLogin.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  int countDown = 30;
  bool noInternet = false;
  Timer? _timer;
  bool needToLoad = false;
  CommonModel? commonModel;
  bool positiveStatus = false;
  LoginModel? userLoginModel;
  VerifyNewDeviceLogin? verifyNewDeviceLogin;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Timer for Button
  startCountDown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDown == 0) {
          countDown = 30;
          timer.cancel();
          notifyListeners();
        } else {
          countDown--;
          notifyListeners();
        }
      },
    );
  }

  /// verifyNewDeviceLogin
  setVerifyNewDeviceLogin(VerifyNewDeviceLogin? newDevice) {
    verifyNewDeviceLogin = newDevice;
    notifyListeners();
  }

  /// Resend Email
  resendEmail(context, String tokenType) async {
    setLoading(true);

    var mutateResendEmailParams = {
      "data": {"tokenType": tokenType, "tokenCode": constant.userToken.value}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.MutateResendEmail(mutateResendEmailParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);

          break;
        case 1:
          setLoading(false);
          customSnackBar.showSnakbar(
              context,
              decodeResponse.data?.statusMessage ?? '',
              decodeResponse.data?.statusCode == 200
                  ? SnackbarType.positive
                  : SnackbarType.negative);
          startCountDown();
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
    }
  }

  /// new device login
  newDeviceLogin(context, String code, String tokenType) async {
    var mutateNewDeviceLogin = {
      "data": {
        "code": code,
        "type": tokenType,
        "token": constant.userToken.value,
        "device_type": "mobile"
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.MutateNewDeviceLogin(mutateNewDeviceLogin);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;

        case 1:
          if ((decodeResponse.data?.statusCode == 200)) {
            constant.pref?.setString(
                "userToken", decodeResponse.data?.result?.token ?? "");
            constant.pref?.setString(
                "userEmail", decodeResponse.data?.result?.email ?? '');
            constant.userToken.value = decodeResponse.data?.result?.token ?? "";
            constant.pref?.setBool('loginStatus', true);
            constant.userLoginStatus.value = true;
            moveToMarket(context);
          } else {}
          setVerifyNewDeviceLogin(decodeResponse.data?.result);
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

  resetPassword(context, int code, String tokenType, String userEmail) async {
    setLoading(true);

    Map<String, dynamic> mutateForgetPasswordVerifyMail = {
      "input": {
        "code": code,
        "token": constant.userToken.value,
        "type": tokenType,
        "email": encryptDecrypt.encryptUsingAESAlgorithm(userEmail)
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutateForgotPasswordVerifyEmail(
          mutateForgetPasswordVerifyMail);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setLoading(false);
          var listenViewModel =
              Provider.of<ConfirmPasswordViewModel>(context, listen: false);
          listenViewModel.closeFocus();
          (decodeResponse.data?.statusCode == 200)
              ? moveToConfirmPassword(context)
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
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
    }
  }

  /// verify register email
  verifyRegisterEmail(context, String code, String tokenType) async {
    setLoading(true);

    Map<String, dynamic> mutateRegisterPasswordVerifyMail = {
      "input": {
        "code": code,
        "token": constant.userToken.value,
        "type": tokenType,
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutateRegisterPasswordVerifyEmail(
          mutateRegisterPasswordVerifyMail);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          (decodeResponse.data?.statusCode == 200)
              ? moveToConfirmPassword(context)
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

  /// reactivateUser
  reactivateUser(context, String code, String tokenType) async {
    var mutuateReactivateAccount = {
      "data": {
        "code": code,
        "type": tokenType,
        "token": constant.userToken.value
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutateActivateAccount(
          mutuateReactivateAccount);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          SharedPreferences prefs = await SharedPreferences.getInstance();
          constant.reactivateMessage.value = response.statusMessage ?? '';
          prefs.setString("reactivate", constant.reactivateMessage.value);
          (decodeResponse.data?.statusCode == 200)
              ? moveToRegister(context, false)
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

  // Send OTP
  verifyEmail(context, String code, String tokenType) async {
    var mutateverifyEmailParams = {
      "data": {
        "code": code,
        "type": tokenType,
        "token": constant.userToken.value
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.MutateVerifyEmail(mutateverifyEmailParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          (decodeResponse.data?.statusCode == 200)
              ? moveToRegister(context, false)
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
}
