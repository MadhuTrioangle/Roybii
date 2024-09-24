import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Disable%20Google%20Authenticator/View/DiasbleGoogleAuthenticatorView.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import '../../GoogleAuthentication/Model/GoogleAutheticateModel.dart';
import '../../GoogleAuthentication/Model/SendEmailCodeModel.dart';
import '../../GoogleAuthentication/ViewModel/GoogleAuthenticateViewModel.dart';
import '../../VerifyGoogleAuthCode/ViewModel/VerifyGoogleAuthenticateViewModel.dart';

class DisableGoogleAuthenticatorChangeViewModel extends ChangeNotifier {
  /// IconButton onPress value using provider
  bool loginPasswordVisible = false;
  int requestTimer = 30;
  SendEmailCodeModel? sendEmailCodeModel;

  void loginPasswordIcon() {
    loginPasswordVisible = !loginPasswordVisible;
    notifyListeners();
  }

  GoogleAuthenticateViewModel? disableModel;
  bool noInternet = false;
  bool needToLoad = false;
  Verifytfa? verifytfa;
  bool positiveStatus = false;
  bool showSnackbar = false;
  bool keyboardVisibility = false;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setKeyboardVisibility(bool visiblity) async {
    keyboardVisibility = visiblity;
    notifyListeners();
  }

  setRequestTimer(int value) async {
    requestTimer = value;
    notifyListeners();
  }

  /// enable google authenticate
  getEnableStatus(context, Verifytfa? enableReseponse) {
    verifytfa = enableReseponse;
    getSnackBarstatus(context, enableReseponse);
  }

  createGoogleAuthenticate(
      BuildContext context,
      String codeAppend,
      GlobalKey<DiableGoogleAuthenticatorViewState> stateKey,
      String code) async {
    var securityViewModel = Provider.of<SecurityViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var verifyGoogleAuthenticationViewModel =
        Provider.of<VerifyGoogleAuthenticationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    String tfaType = verifyGoogleAuthenticationViewModel.mobileOtp == true
        ? "mobile_number"
        : "tfa";
    setLoading(true);
    Map<String, dynamic> queryData = {
      "tfa_type": tfaType,
      "tfaonecode": codeAppend,
    };

    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutateVerifyTFA(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          securityViewModel.getIdVerification();
          Navigator.pop(
            NavigationService.navigatorKey.currentContext!,
          );
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
      noInternet = true;
      setLoading(true);
    }
  }

  getSnackBarstatus(context, Verifytfa? enableReseponse) {
    positiveStatus =
        ((enableReseponse?.statusCode ?? 200) == 200) ? true : false;
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
}
