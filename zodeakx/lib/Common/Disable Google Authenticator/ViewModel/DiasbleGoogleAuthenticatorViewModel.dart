import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Disable%20Google%20Authenticator/View/DiasbleGoogleAuthenticatorView.dart';
import 'package:zodeakx_mobile/Common/GoogleAuthentication/View/GoogleAuthenticate/Model/GoogleAutheticateModel.dart';
import 'package:zodeakx_mobile/Common/GoogleAuthentication/View/GoogleAuthenticate/ViewModel/GoogleAuthenticateViewModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/ViewModel/SecurityViewModel.dart';

class DisableGoogleAuthenticatorChangeViewModel extends ChangeNotifier {
  /// IconButton onPress value using provider
  bool loginPasswordVisible = false;

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

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// enable google authenticate
  getEnableStatus(context, Verifytfa? enableReseponse) {
    verifytfa = enableReseponse;
    getSnackBarstatus(context, enableReseponse);
  }

  Future<bool> createGoogleAuthenticate(
      BuildContext context,
      String codeAppend,
      GlobalKey<DiableGoogleAuthenticatorViewState> stateKey) async {
    var popFlag = false;
    setLoading(true);
    var securityViewModel = Provider.of<SecurityViewModel>(NavigationService.navigatorKey.currentContext!,listen:false);
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "tfa_type" : "tfa",
        "tfaonecode": codeAppend,
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutateVerifyTFA(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          if (decodeResponse.data?.statusCode == 200) {
            popFlag = true;
            securityViewModel.getIdVerification();
            // constant.buttonValue.value =
            //     response.result?.buttonvalue == 'Disable'
            //         ? 'verified'
            //         : 'unverified';
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // prefs.setString("buttonValue", constant.buttonValue.value);
          } else {
            popFlag = false;
          }
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
    return popFlag;
  }

  getSnackBarstatus(context, Verifytfa? enableReseponse) {
    positiveStatus =
        ((enableReseponse?.statusCode ?? 200) == 200) ? true : false;
  }
}
