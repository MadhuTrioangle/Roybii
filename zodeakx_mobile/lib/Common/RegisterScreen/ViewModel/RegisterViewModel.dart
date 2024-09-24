import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/Model/ReferralIdModel.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/Model/RegisterModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/encryptAndDecrypt.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../Model/SocialMediaModel.dart';

class RegisterViewModel extends ChangeNotifier {
  bool checkBoxStatus = false;
  bool closedPage = false;
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  bool isLogin = true;
  CreateUser? registeredUserResponse;
  ReferralId? userReferralId;
  bool hasInputError1 = false;
  bool hasInputError2 = false;
  bool hasInputError3 = false;
  bool hasInputError4 = false;
  bool hasInputError5 = false;
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  RegisterViewModel() {
    showSnackbar = false;
    closedPage = false;
    checkFocus();
  }

  /// Loader
  setIsLogin(bool login) async {
    isLogin = login;
    notifyListeners();
  }

  checkFocus() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        hasInputError1 = (closedPage) ? false : !focusNode.hasFocus;
        notifyListeners(); //Check your conditions on text variable
      }
    });
    focusNode2.addListener(() {
      if (!focusNode2.hasFocus) {
        hasInputError2 = (closedPage)
            ? false
            : !focusNode2.hasFocus; //Check your conditions on text variable
        notifyListeners();
      }
    });
    focusNode3.addListener(() {
      if (!focusNode3.hasFocus) {
        hasInputError3 = (closedPage) ? false : !focusNode3.hasFocus;
        notifyListeners(); //Check your conditions on text variable
      }
    });
    focusNode4.addListener(() {
      if (!focusNode4.hasFocus) {
        hasInputError4 = (closedPage) ? false : !focusNode4.hasFocus;
        //Check your conditions on text variable
        notifyListeners();
      }
    });
    focusNode5.addListener(() {
      if (!focusNode5.hasFocus) {
        hasInputError5 = (closedPage) ? false : !focusNode5.hasFocus;
        notifyListeners(); //Check your conditions on text variable
      }
    });
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// checkbox onChanged value using provider

  //bool active = false;
  bool checkAlert = false;

  Future<void> setActive(bool value) async {
    //active = value;
    checkAlert = value;
    setActivestatus(false);
    notifyListeners(); //  Consumer to rebuild
  }

  bool checkAlertstatus = false;

  Future<void> setActivestatus(bool value) async {
    checkAlertstatus = value;
    notifyListeners(); //  Consumer to rebuild
  }

  /// IconButton onChanged value using provider

  bool passwordVisible = false;

  void changeIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  /// set referral Id
  setReferralId(ReferralId? result) {
    userReferralId = result;
    notifyListeners();
  }

  /// Create user response
  getRegisterDetails(context, CreateUser? createUserResponse) {
    registeredUserResponse = createUserResponse;
    getSnackBarstatus(context, createUserResponse);
  }

  getSnackBarstatus(context, CreateUser? createUserResponse) {
    positiveStatus =
        ((registeredUserResponse?.statusCode ?? 200) == 200) ? true : false;
    constant.userToken.value = registeredUserResponse?.result?.token ?? "";
    ((createUserResponse?.statusCode ?? 403) == 200)
        ? moveToEmailVerification(
            context,
            stringVariables.register,
            int.parse(registeredUserResponse?.result?.tempOtp ?? '123456'),
            registeredUserResponse?.result?.email ?? "${constant.appEmail}",
            EmailVerificationType.Register,
            registeredUserResponse?.result?.tokenType ?? "register")
        : () {};
    showSnackbar = true;
  }

  createUser(String userEmail, String userPassCode, String refferal,
      String ambassadorReferral, BuildContext context) async {
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      'data': {
        "type": "email".toLowerCase(),
        "key": encryptDecrypt.encryptUsingAESAlgorithm(userEmail),
        "password": encryptDecrypt.encryptUsingAESAlgorithm(userPassCode),
        "referral_code": refferal,
        "user_lang": "en",
        // "mlm_referralCode": ambassadorReferral
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.MutatecreateUser(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getRegisterDetails(context, decodeResponse.data);
          closeFocus();
          setLoading(false);
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

  /// get referral id

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

  socialMediaLogin(String type, String token, String signInType) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "type": type,
        "token": token,
        "signIn_type": signInType,
        "device_type": "mobile"
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.socialMediaLogin(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setSocialMediaLogin(
              decodeResponse.data ?? SocialMediaModel(), type, token);
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

  setSocialMediaLogin(
      SocialMediaModel socialMediaModel, String type, String token) {
    int statusCode = socialMediaModel.statusCode ?? 0;
    bool linkedAccount = socialMediaModel.result?.linkedAccount ?? false;
    if (statusCode == 400) {
      toastMessage(socialMediaModel.statusMessage ?? "");
    } else {
      if (statusCode == 201)
        navigateToSocialMedia(false, type, token);
      else if (statusCode == 200) {
        if (linkedAccount) {
          constant.userEmail.value = socialMediaModel.result?.email ?? '';
          navigateToSocialMedia(true, type, token);
        } else {
          if (socialMediaModel.result?.accountStatus == "Tfa Enable" ||
              socialMediaModel.result?.mobile_status == "verified") {
            constant.token.value = socialMediaModel.result?.token ?? "";
            navigateTo2FA(socialMediaModel);
          } else {
            loginUser(socialMediaModel);
          }
        }
      } else
        toastMessage(socialMediaModel.statusMessage ?? "");
    }
    notifyListeners();
  }

  navigateTo2FA(SocialMediaModel socialMediaModel) {
    moveToVerifyCode(
      NavigationService.navigatorKey.currentContext!,
      AuthenticationVerificationType.Login,
      socialMediaModel.result?.accountStatus,
      socialMediaModel.result?.mobile_status,
      socialMediaModel.result?.mobile_code,
      socialMediaModel.result?.mobile_number,
    );
  }

  navigateToSocialMedia(bool linkFlag, String type, String token) {
    moveToSocialMediaView(
        NavigationService.navigatorKey.currentContext!, linkFlag, type, token);
  }

  loginUser(SocialMediaModel socialMediaModel) {
    constant.pref
        ?.setString("userToken", socialMediaModel?.result?.token ?? "");
    constant.pref
        ?.setString("userEmail", socialMediaModel?.result?.email ?? '');
    constant.userEmail.value = socialMediaModel?.result?.email ?? '';
    constant.userToken.value = socialMediaModel?.result?.token ?? "";
    constant.pref?.setBool('loginStatus', true);
    constant.userLoginStatus.value = true;
    constant.notifyListeners();
    moveToMarket(NavigationService.navigatorKey.currentContext!);
  }

  closeFocus() {
    hasInputError1 = false;
    hasInputError2 = false;
    hasInputError3 = false;
    hasInputError4 = false;
    hasInputError5 = false;
    notifyListeners();
  }

  openPage() {
    closedPage = false;
    notifyListeners();
  }
}
