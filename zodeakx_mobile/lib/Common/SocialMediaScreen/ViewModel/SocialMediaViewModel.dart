import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../RegisterScreen/Model/ReferralIdModel.dart';
import '../../RegisterScreen/Model/SocialMediaModel.dart';

class SocialMediaViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = false;
  bool checkAlert = false;
  bool accountCreatedFlag = false;
  bool passwordVisible = false;
  bool linkAccount = false;
  bool referralEmpty = true;
  bool ambassadorReferralEmpty = true;
  ReferralId? userReferralId;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setLinkAccount(bool value) async {
    linkAccount = value;
    notifyListeners();
  }

  setReferralEmpty(bool value) async {
    referralEmpty = value;
    notifyListeners();
  }

  setAmbassadorReferralEmpty(bool value) async {
    ambassadorReferralEmpty = value;
    notifyListeners();
  }

  void changeIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  setaccountCreatedFlag(bool value) async {
    accountCreatedFlag = value;
    notifyListeners();
  }

  Future<void> setActive(bool value) async {
    //active = value;
    checkAlert = value;
    notifyListeners(); //  Consumer to rebuild
  }

  socialMediaLogin(String type, String token, String signInType,
      String refferal, String ambassadorReferral) async {
    Map<String, dynamic> queryData = {
      "type": type,
      "token": token,
      "signIn_type": signInType,
      "device_type" : "mobile"
    };
    if (refferal.isNotEmpty) queryData["referral_code"] = refferal;
    if (ambassadorReferral.isNotEmpty)
      queryData["mlm_referralCode"] = ambassadorReferral;
    Map<String, dynamic> mutateUserParams = {"data": queryData};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.socialMediaLogin(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setSocialMediaLogin(decodeResponse.data ?? SocialMediaModel());
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

  toastMessage(String message) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
        message, SnackbarType.negative);
  }

  setSocialMediaLogin(SocialMediaModel socialMediaModel) {
    int statusCode = socialMediaModel.statusCode ?? 0;
    if (statusCode == 200) {
      loginUser(socialMediaModel);
    } else {
      toastMessage(socialMediaModel.statusMessage ?? "");
    }
    notifyListeners();
  }

  loginUser(SocialMediaModel socialMediaModel) {
    accountCreatedFlag = true;
    constant.pref
        ?.setString("userToken", socialMediaModel?.result?.token ?? "");
    constant.pref
        ?.setString("userEmail", socialMediaModel?.result?.email ?? '');
    constant.userEmail.value = socialMediaModel?.result?.email ?? '';
    constant.userToken.value = socialMediaModel?.result?.token ?? "";
    constant.pref?.setBool('loginStatus', true);
    constant.userLoginStatus.value = true;
    constant.notifyListeners();
  }

  getReferralLinkByReferralID(String referral) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "referral_id": referral,
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchReferralLink(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setReferralId(decodeResponse.data?.result);
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

  setReferralId(ReferralId? result) {
    userReferralId = result;
    notifyListeners();
  }
}
