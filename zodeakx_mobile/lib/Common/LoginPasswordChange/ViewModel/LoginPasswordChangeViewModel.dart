import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/encryptAndDecrypt.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';

class LoginPasswordChangeViewModel extends ChangeNotifier {
  CommonModel? commonModel;
  bool noInternet = false;
  bool needToLoad = true;
  bool closedPage = false;
  int count = 0;
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

  /// IconButton onPress value using provider
  bool oldPasswordVisible = false;

  void changeOldPasswordIcon() {
    oldPasswordVisible = !oldPasswordVisible;
    notifyListeners();
  }

  bool confirmPasswordVisible = false;

  void changeConfirmPasswordIcon() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  bool newPasswordVisible = false;

  void changeNewPasswordIcon() {
    newPasswordVisible = !newPasswordVisible;
    notifyListeners();
  }

  checkFocus() {
    focusNode = new FocusNode();
    focusNode2 = new FocusNode();
    focusNode3 = new FocusNode();
    focusNode4 = new FocusNode();
    focusNode5 = new FocusNode();

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

  /// set Generate Referral Link
  setPasswordResponse(CommonModel? result, BuildContext context) {
    commonModel = result;
    if (commonModel?.statusCode == 200) {
      constant.userLoginStatus.value = false;
      constant.pref?.setBool('loginStatus', false);
      constant.pref?.setString("userEmail", "${constant.appEmail}");
      moveToRegister(context, false);
    }
    customSnackBar.showSnakbar(
        context,
        commonModel?.statusMessage ?? '',
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    notifyListeners();
  }

  getPasswordResponse(
    String oldPassword,
    String newPassword,
    String confirmPassword,
    BuildContext context,
  ) async {
    // bool socialMediaFlag
    Map<String, dynamic> queryData = {
      "oldPassword": encryptDecrypt.encryptUsingAESAlgorithm(oldPassword),
      "newPassword": encryptDecrypt.encryptUsingAESAlgorithm(newPassword),
      "confirmPassword":
          encryptDecrypt.encryptUsingAESAlgorithm(confirmPassword)
    };
    Map<String, dynamic> mutateUserParams = {"input": queryData};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.updateNewPassword(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setPasswordResponse(decodeResponse.data, context);
          closeFocus();
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
