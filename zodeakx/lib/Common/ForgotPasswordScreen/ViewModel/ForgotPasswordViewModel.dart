import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Common/ForgotPasswordScreen/Model/ForgotPasswordModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/encryptAndDecrypt.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  SendForgetPasswordVerifyMail? forgotPasswordUserResponse;

  ForgotPasswordViewModel() {
    showSnackbar = false;
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Create user response
  getForgotPasswordDetails(
      SendForgetPasswordVerifyMail? forgotPasswordResponse, context) {
    forgotPasswordUserResponse = forgotPasswordResponse;
    if (forgotPasswordUserResponse?.statusCode == 200) {
      constant.userToken.value =
          forgotPasswordUserResponse?.result?.token ?? "";
      constant.tokenType.value =
          forgotPasswordUserResponse?.result?.tokenType ?? "";

      /// change movetoverifypassword to moveToEmailVerification
      moveToEmailVerification(
          context,
          constant.tokenType.value == 'ForgetPassword'
              ? stringVariables.resetPassword
              : stringVariables.register,
          int.parse("${forgotPasswordResponse?.result?.tempOtp ?? 123456}"),
          constant.userEmail.value,
          EmailVerificationType.ResetPassword,
          forgotPasswordResponse?.result?.tokenType ?? "Reset Password");
      customSnackBar.showSnakbar(
          context,
          forgotPasswordUserResponse?.statusMessage ?? '',
          forgotPasswordUserResponse?.statusCode == 200
              ? SnackbarType.positive
              : SnackbarType.negative);
    } else {
      getSnackBarstatus();
    }
  }

  getSnackBarstatus() {
    positiveStatus =
        ((forgotPasswordUserResponse?.statusCode ?? 200) == 200) ? true : false;
    showSnackbar = true;
  }

  forgotPassword(String userEmail, BuildContext context) async {
    setLoading(true);
    Map<String, dynamic> mutateUserParams = {
      'input': {
        "key": encryptDecrypt.encryptUsingAESAlgorithm(userEmail),
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await commonRepository.forgotPassword(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          constant.userEmail.value = userEmail;
          getForgotPasswordDetails(decodeResponse.data, context);
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
}
