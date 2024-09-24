import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Common/ConfirmPassword/Model/ConfirmPasswordModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/encryptAndDecrypt.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';

class ConfirmPasswordViewModel extends ChangeNotifier {
  bool checkBoxStatus = false;
  bool closedPage = false;
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  NewPasswordClass? newPasswordResponse;
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

  ConfirmPasswordViewModel() {
    showSnackbar = false;
    closedPage = false;
    checkFocus();
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

  /// IconButton onPress value using provider
  bool passwordVisible = false;
  void changePasswordIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  bool confirmPasswordVisible = false;

  void changeConfirmPasswordIcon() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  /// Create user response
  getNewPasswordDetails(NewPasswordClass? passwordResponse, context) {
    newPasswordResponse = passwordResponse;
    if (newPasswordResponse?.statusCode == 200) {
      moveToRegister(context, false);
      customSnackBar.showSnakbar(
          context,
          newPasswordResponse?.statusMessage ?? '',
          newPasswordResponse?.statusCode == 200
              ? SnackbarType.positive
              : SnackbarType.negative);
    } else {
      getSnackBarstatus();
    }
  }

  getSnackBarstatus() {
    positiveStatus =
        ((newPasswordResponse?.statusCode ?? 200) == 200) ? true : false;
    showSnackbar = true;
  }

  /// add params
  confirmPassword(
      String confirmPassword, String userPassCode, BuildContext context) async {
    setLoading(true);

    Map<String, dynamic> mutateUserParams = {
      'input': {
        "new_password": encryptDecrypt.encryptUsingAESAlgorithm(userPassCode),
        "retype_newPassword":
            encryptDecrypt.encryptUsingAESAlgorithm(confirmPassword),
        "email":
            encryptDecrypt.encryptUsingAESAlgorithm(constant.userEmail.value)
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.createPassword(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getNewPasswordDetails(decodeResponse.data, context);
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
