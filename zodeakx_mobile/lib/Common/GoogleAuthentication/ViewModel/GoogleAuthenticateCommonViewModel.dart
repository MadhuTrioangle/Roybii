import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/GoogleAuthentication/View/GoogleAuthenticateCommonView.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/encryptAndDecrypt.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import '../../Repositories/CommonRepository.dart';
import '../Model/GoogleAutheticateModel.dart';
import '../Model/QRCodeModel.dart';
import '../Model/SendEmailCodeModel.dart';

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
  int requestTimer = 30;
  SendEmailCodeModel? sendEmailCodeModel;

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

  setRequestTimer(int value) async {
    requestTimer = value;
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

  createGoogleAuthenticate(
      String userPassCode,
      BuildContext context,
      String codeAppend,
      GlobalKey<GoogleAuthenticateCommonViewState> stateKey) async {
    var securityViewModel = Provider.of<SecurityViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    setLoading(true);

    Map<String, dynamic> queryData = {
      "tfaenablekey": constant.QRSecertCode.value,
      "tfaonecode": codeAppend,
    };

    queryData["password"] =
        encryptDecrypt.encryptUsingAESAlgorithm(userPassCode);

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
