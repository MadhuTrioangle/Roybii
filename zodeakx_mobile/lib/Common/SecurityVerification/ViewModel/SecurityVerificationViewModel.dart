import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../GoogleAuthentication/Model/SendEmailCodeModel.dart';

class SecurityVerificationViewModel extends ChangeNotifier {
  int requestTimer = 30;
  SendEmailCodeModel? sendEmailCodeModel;
  bool noInternet = false;
  bool needToLoad = false;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setRequestTimer(int value) async {
    requestTimer = value;
    notifyListeners();
  }

  sendEmailCode() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.sendEmailCode();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setSendEmailCode(decodeResponse.data);
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

  setSendEmailCode(SendEmailCodeModel? sendEmailCodeModel) {
    this.sendEmailCodeModel = sendEmailCodeModel;
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        sendEmailCodeModel?.statusMessage ?? "",
        sendEmailCodeModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
  }

  verifyEmailCode(String code) async {
    Map<String, dynamic> mutateUserParams = {
      "input": {
        "code": code,
        "token": sendEmailCodeModel?.result?.token,
        "type": sendEmailCodeModel?.result?.tokenType
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.verifyEmailCode(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setVerifyEmailCode(decodeResponse.data);
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

  setVerifyEmailCode(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200) {
      moveToLoginPasswordChange(
          NavigationService.navigatorKey.currentContext!, true);
    }
  }
}
