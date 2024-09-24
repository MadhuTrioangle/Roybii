import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/LoginScreen/Model/LoginModel.dart';
import 'package:zodeakx_mobile/Common/ReactiveAccount/ViewModel/ReactivateAccountViewModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/encryptAndDecrypt.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../ZodeakX/Setting/Model/GetUserByJwtModel.dart';
import '../../../p2p/home/view_model/p2p_home_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = false;
  bool closedPage = false;
  LoginModel? userLoginModel;
  String? email;
  String? reactivateMessage;
  ScreenType? verificationType;
  GetUserJwt? viewModelVerification;

  bool hasInputError1 = false;
  bool hasInputError2 = false;
  bool hasInputError3 = false;
  bool hasInputError4 = false;
  bool hasInputError5 = false;
  String buttonValue = 'Enable';

  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  LoginViewModel() {
    closedPage = false;
    checkFocus();
  }

  checkFocus() {
    // focusNode = new FocusNode();
    // focusNode2 = new FocusNode();
    // focusNode3 = new FocusNode();
    // focusNode4 = new FocusNode();
    // focusNode5 = new FocusNode();

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

  /// IconButton onChanged value using provider

  bool passwordVisible = false;

  void changeIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// getLogin User Details
  setLoginUserDetails(LoginModel? loginModel, context) {
    userLoginModel = loginModel;
    if (loginModel?.statusCode == 400) {
      if (loginModel?.result == null) {
      } else {
        constant.userToken.value = userLoginModel?.result?.token ?? "";
        constant.pref
            ?.setString("userToken", userLoginModel?.result?.token ?? "");
        constant.pref?.setString(
            "userEmail", userLoginModel?.result?.email ?? '${email}');
        constant.userEmail.value = '${userLoginModel?.result?.email ?? email}';
        var listenViewModel =
            Provider.of<ReactivateAccountViewModel>(context, listen: false);
        listenViewModel.closeFocus();
        ((userLoginModel?.result?.tokenType ?? "") == "unlockAccount")
            ? moveToReactivateAccount(
                context,
              )
            : moveToEmailVerification(
                context,
                stringVariables.login,
                int.parse(userLoginModel?.result?.tempOtp ?? "123456"),
                userLoginModel?.result?.email ?? email,
                ((userLoginModel?.result?.tokenType ?? "") == "NewDeviceLogin")
                    ? EmailVerificationType.NewdeviceLogin
                    : EmailVerificationType.Register,
                userLoginModel?.result?.tokenType ?? "register");
      }
    } else {
      if (userLoginModel?.result?.accountStatus != "Tfa Enable") {
        constant.userToken.value = userLoginModel?.result?.token ?? "";
        constant.pref
            ?.setString("userToken", userLoginModel?.result?.token ?? "");
        // constant.pref?.setBool('loginStatus', true);
        constant.pref?.setString("userEmail",
            userLoginModel?.result?.email ?? "${constant.appEmail}");
        constant.userEmail.value = '${userLoginModel?.result?.email ?? email}';
      } else {
        constant.pref?.setString("userEmail", email ?? "${constant.appEmail}");
        constant.userEmail.value = '${userLoginModel?.result?.email ?? email}';
      }
      //constant.userLoginStatus.value = true;
      constant.pref
          ?.setString("userToken", userLoginModel?.result?.token ?? "");
      constant.pref
          ?.setString("sessionId", userLoginModel?.result?.sessionId ?? "");
      // constant.pref?.setBool('loginStatus', true);
      constant.pref?.setString(
          "userEmail", userLoginModel?.result?.email ?? "${constant.appEmail}");
      constant.notifyListeners();
      if (viewModelVerification?.tfaStatus == 'verified' ||
          loginModel?.result?.accountStatus == "Tfa Enable") {
        constant.pref
            ?.setString("userToken", userLoginModel?.result?.token ?? "");
        constant.pref
            ?.setString("sessionId", userLoginModel?.result?.sessionId ?? "");
        constant.pref?.setString("userEmail",
            userLoginModel?.result?.email ?? "${constant.appEmail}");
        constant.notifyListeners();
        moveToVerifyCode(context, AuthenticationVerificationType.Login);
      } else {
        constant.pref?.setBool('loginStatus', true);
        constant.userLoginStatus.value = true;
        constant.pref
            ?.setString("userToken", userLoginModel?.result?.token ?? "");
        constant.pref
            ?.setString("sessionId", userLoginModel?.result?.sessionId ?? "");
        constant.pref?.setString("userEmail",
            userLoginModel?.result?.email ?? "${constant.appEmail}");
        constant.notifyListeners();
        moveToMarket(context);
      }
    }
    if ((userLoginModel?.statusCode == 200)) {
      Provider.of<P2PHomeViewModel>(
              NavigationService.navigatorKey.currentContext!,
              listen: false)
          .setFiatCurrency(
              constant.pref?.getString("defaultFiatCurrency") ?? 'GBP');
    }
    customSnackBar.showSnakbar(
        context,
        userLoginModel?.statusMessage ?? "",
        (userLoginModel?.statusCode == 200)
            ? SnackbarType.positive
            : SnackbarType.negative);
  }

  /// Mutate LoginUser

  loginUser(String userEmail, String userPassCode, context) async {
    setLoading(true);
    email = userEmail;

    Map<String, dynamic> mutateUserParams = {
      'data': {
        "type": "email".toLowerCase(),
        "key": encryptDecrypt.encryptUsingAESAlgorithm(userEmail),
        "password": encryptDecrypt.encryptUsingAESAlgorithm(userPassCode),
        "device_type": "mobile"
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var loginResponse =
          await commonRepository.MutateLoginUser(mutateUserParams);
      var decodeResponse = HandleResponse.completed(loginResponse);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setLoading(false);
          setLoginUserDetails(decodeResponse.data, context);
          constant.token.value = '${decodeResponse.data?.result?.token}';
          closeFocus();
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

  getIdVerification() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      constant.buttonValue.value = response.result?.tfaStatus ?? '';
      constant.antiCode.value = response.result?.antiPhishingCode ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          constant.pref?.setString(
              "firstName",
              response.result?.kyc?.idProof?.firstName ??
                  "${constant.appName}");
          buttonValue = response.result?.tfaStatus ?? '';
          constant.QRSecertCode.value = response.result?.tfaEnableKey ?? "";
          constant.buttonValue.value = response.result?.tfaStatus ?? '';
          constant.pref?.setString(
              "buttonValue", response.result?.tfaStatus ?? "UnVerified");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("buttonValue", constant.buttonValue.value);
          constant.antiCode.value = response.result?.antiPhishingCode ?? '';
          prefs.setString("code", constant.antiCode.value);
          setIdVerification(decodeResponse.data?.result);
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
