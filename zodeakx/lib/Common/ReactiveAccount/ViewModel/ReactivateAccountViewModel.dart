import 'package:flutter/foundation.dart';
import 'package:zodeakx_mobile/Common/ReactiveAccount/Model/ReactivateAccountModel.dart';
import 'package:zodeakx_mobile/Common/Repositories/CommonRepository.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class ReactivateAccountViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = false;
  bool checkBoxStatus = false;
  bool checkBoxValue = false;
  ReactivateAccountModel? reactivateAccountModel;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Get api response and move to email verification
  getReactivateRespomse(
      ReactivateAccountModel? reactivateAccountModel, context) {
    reactivateAccountModel = reactivateAccountModel;

    if (reactivateAccountModel?.statusCode == 400 &&
        reactivateAccountModel?.result != null) {
      constant.userToken.value = reactivateAccountModel?.result?.token ?? "";
      moveToEmailVerification(
          context,
          stringVariables.reactivateAccount,
          int.parse(reactivateAccountModel?.result?.tempOtp ?? "123456"),
          constant.userEmail.value,
          EmailVerificationType.ReactivateAccount,
          reactivateAccountModel?.result?.tokenType ?? "register");
      customSnackBar.showSnakbar(context,
          reactivateAccountModel?.statusMessage ?? "", SnackbarType.positive);
    } else {
      customSnackBar.showSnakbar(context,
          reactivateAccountModel?.statusMessage ?? "", SnackbarType.negative);
    }
  }

  /// checkbox2 onChanged value using provider

  bool active = false;

  Future<void> setActive(bool value) async {
    active = value;
    notifyListeners(); //  Consumer to rebuild
  }

  void changeCheckedBox() {
    active = !active;
    checkBoxStatus = !active;
    notifyListeners();
  }

  /// checkbox onChanged value using provider

  bool select = false;

  Future<void> setSelect(bool value) async {
    select = value;
    notifyListeners(); //  Consumer to rebuild
  }

  void changeCheckBox() {
    select = !select;
    checkBoxValue = !select;
    notifyListeners();
  }

  /// Reactivate Account
  reactivateAccount(
    context,
  ) async {
    setLoading(true);

    Map<String, dynamic> mutateDeviceToken = {
      "data": {
        "token": constant.userToken.value,
        "type": "unlockAccount",
        "device_type": "mobile"
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await commonRepository.MutateReactivateAccount(mutateDeviceToken);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getReactivateRespomse(decodeResponse.data, context);
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
    active = false;
    select = false;
    notifyListeners();
  }
}
