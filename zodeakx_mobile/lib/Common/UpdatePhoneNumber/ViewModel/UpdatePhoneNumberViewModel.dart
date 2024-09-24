import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import '../../Repositories/CommonRepository.dart';

class UpdatePhoneNumberViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  String phoneNo = "";
  String otp = "";
  int requestTimer = 30;
  CountryCode? countryCode;
  bool keyboardVisibility = false;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setCountryCode(CountryCode? value) async {
    countryCode = value;
    notifyListeners();
  }

  setPhoneNo(String value) async {
    phoneNo = value;
    notifyListeners();
  }

  setKeyboardVisibility(bool visiblity) async {
    keyboardVisibility = visiblity;
    notifyListeners();
  }

  setOtp(String value) async {
    otp = value;
    notifyListeners();
  }

  setRequestTimer(int value) async {
    requestTimer = value;
    notifyListeners();
  }

  updateMobileNumber() async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"mobile_code": countryCode?.dialCode, "mobile_number": phoneNo}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.updateMobileNumber(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUpdateMobileNumber(decodeResponse.data ?? CommonModel());
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

  setUpdateMobileNumber(
    CommonModel commonModel,
  ) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();

    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel.statusMessage ?? "",
        commonModel.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);

    notifyListeners();
  }

  verifyMobileNumber(bool isUpdate) async {
    Map<String, dynamic> mutateUserParams = isUpdate
        ? {
            "data": {
              "OTP": otp,
              "mobile_code": countryCode?.dialCode,
              "mobile_number": phoneNo
            }
          }
        : {
            "data": {
              "OTP": otp,
            }
          };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.verifyMobileNumber(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setVerifyMobileNumber(decodeResponse.data ?? CommonModel(), isUpdate);
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

  setVerifyMobileNumber(CommonModel commonModel, bool isUpdate) async {
    var securityViewModel = Provider.of<SecurityViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel.statusMessage ?? "",
        commonModel.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel.statusCode == 200) {
      if (isUpdate == true) {
        constant.userLoginStatus.value = false;
        constant.pref?.setBool('loginStatus', false);
        constant.pref?.setString("userEmail", "${constant.appEmail}");
        marketViewModel.clearAllData();
        marketViewModel.clearP2PData();
        marketViewModel.logoutFromGoogle();
        moveToMarket(NavigationService.navigatorKey.currentContext!);
      } else {
        await securityViewModel.getIdVerification();
        Navigator.pop(NavigationService.navigatorKey.currentContext!);
      }
    }

    notifyListeners();
  }

  deleteMobileNumber(String value, String type) async {
    Map<String, dynamic> mutateUserParams = type == "mobile"
        ? {
            "data": {"OTP": value}
          }
        : {
            "data": {"code": value}
          };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.setDeleteMobileNumber(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setDeleteMobileNumber(decodeResponse.data ?? CommonModel());
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

  setDeleteMobileNumber(CommonModel commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    if (commonModel.statusCode == 200) {
      constant.userLoginStatus.value = false;
      constant.pref?.setBool('loginStatus', false);
      constant.pref?.setString("userEmail", "${constant.appEmail}");
      marketViewModel.clearAllData();
      marketViewModel.clearP2PData();
      marketViewModel.logoutFromGoogle();
      moveToMarket(NavigationService.navigatorKey.currentContext!);
    }
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel.statusMessage ?? "",
        commonModel.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
  }
}
