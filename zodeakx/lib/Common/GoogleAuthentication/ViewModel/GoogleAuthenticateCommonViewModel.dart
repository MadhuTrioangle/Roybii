import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/GoogleAuthentication/View/GoogleAuthenticateCommonView.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/encryptAndDecrypt.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../Repositories/CommonRepository.dart';
import '../View/GoogleAuthenticate/Model/GoogleAutheticateModel.dart';
import '../View/QRCode/Model/QRCodeModel.dart';

class GoogleAuthenticateCommonViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = false;
  Verifytfa? verifytfa;
  bool positiveStatus = false;
  bool showSnackbar = false;
  GetTFA? getTFA;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleAuthenticateCommonViewModel? viewModel;
  int index = 0;

  /// radiobutton onChanged value using provider
  int id = 0;

  Future<void> setActive(BuildContext context, int index) async {
    id = index;
    notifyListeners(); //  Consumer to rebuild
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// initilizing API
  GoogleAuthenticateCommonViewModel() {
    //getSecretCode();
  }

  /// set SecretCode
  setSecretCode(GetTFA? getSecretCode) {
    getTFA = getSecretCode;
    constant.QRSecertCode.value = getTFA?.secret ?? '';
    notifyListeners();
  }

  /// IconButton onChanged value using provider
  bool passwordVisible = false;

  void changeIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  /// IconButton onPress value using provider

  bool loginPasswordVisible = false;

  void loginPasswordIcon() {
    loginPasswordVisible = !loginPasswordVisible;
    notifyListeners();
  }

  /// enable google authenticate
  getEnableStatus(context, Verifytfa? enableReseponse) {
    verifytfa = enableReseponse;
    enableReseponse?.statusMessage == 200
        ? customSnackBar.showSnakbar(
            context,
            verifytfa?.statusMessage ?? "",
            (verifytfa?.statusCode == 200)
                ? SnackbarType.positive
                : SnackbarType.negative)
        : null;

    getSnackBarstatus(context, enableReseponse);
  }

  Future<bool> createGoogleAuthenticate(
      String userPassCode,
      BuildContext context,
      String codeAppend,
      GlobalKey<GoogleAuthenticateCommonViewState> stateKey) async {
    var popFlag = false;
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      "data": {
        "tfaenablekey": constant.QRSecertCode.value,
        "tfaonecode": codeAppend,
        "password": encryptDecrypt.encryptUsingAESAlgorithm(userPassCode)
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("buttonValue", constant.buttonValue.value);
          if (decodeResponse.data?.statusCode == 200) {
            popFlag = true;
            constant.buttonValue.value =
                response.result?.buttonvalue == 'Disable'
                    ? 'verified'
                    : 'unverified';
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("buttonValue", constant.buttonValue.value);
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

  /// Get SecretCode

  getSecretCode() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchSecretCode();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          constant.QRSecertCode.value = response.result?.secret ?? '';
          setSecretCode(decodeResponse.data?.result);
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
