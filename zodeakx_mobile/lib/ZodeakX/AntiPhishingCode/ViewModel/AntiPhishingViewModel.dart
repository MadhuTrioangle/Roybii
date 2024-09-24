import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/Model/AntiPhishingModel.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/View/DashBoardview.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/View/SecurityView.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetUserByJwtModel.dart';

class AntiPhishingViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  AntiPhishingCode? antiPhshingUserResponse;
  GetUserJwt? viewModelVerification;
  int count = 0;

  AntiPhishingViewModel() {
    showSnackbar = false;
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Create user response
  getAntiPhishingDetails(context, AntiPhishingCode? createUserResponse) {
    antiPhshingUserResponse = createUserResponse;
    getSnackBarstatus(context, createUserResponse);
  }

  getSnackBarstatus(context, AntiPhishingCode? createUserResponse) {
    positiveStatus =
        ((antiPhshingUserResponse?.statusCode ?? 200) == 200) ? true : false;
    ((createUserResponse?.statusCode ?? 403) == 200)
        ? moveToSecurity(context)
        : () {};
    showSnackbar = true;
  }

  createAntiphishingCode(String code, BuildContext context, screenType) async {
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      "data": {"anti_phishing_code": code}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.MutatecreateAntiPhishingCode(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      constant.antiCodeStatus.value = response.statusMessage ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setLoading(false);
          constant.antiCodeStatus.value = response.statusMessage ?? '';
          (decodeResponse.data?.statusCode == 200)
              ? getIdVerification(context, screenType)
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

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// Get IdVerification

  getIdVerification(BuildContext context, screenType) async {
    var securityViewModel = Provider.of<SecurityViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setLoading(false);
          securityViewModel.getIdVerification();
          (decodeResponse.data?.statusCode == 200)
              ? screenType == AuthenticationVerificationType.dashBoard
                  ? Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => DashBoardView()),
                      (route) => count++ >= 4)
                  : Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => SecurityView()),
                      (route) => count++ >= 4)
              : () {};
          count = 0;
          notifyListeners();
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
