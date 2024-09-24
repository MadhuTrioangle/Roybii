import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/encryptAndDecrypt.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/FiatDepositScreen/Model/FiatCommonDepositModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../DeleteAccount/ViewModel/DeleteAccountViewModel.dart';

class DeletePasswordViewModel extends ChangeNotifier {
  final TextEditingController password = TextEditingController();
  bool passwordVisible = false;
  bool loading = false;
  bool noInternet = false;
  CreateFiatDepositModel? createFiatDepositModel;
  bool checkBoxStatus = false;

  setCheckBoxStatus() {
    checkBoxStatus = !checkBoxStatus;
    notifyListeners();
  }

  setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  changeIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  createDeleteAccount() async {
    var deleteAccountViewModel = Provider.of<DeleteAccountViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    String? reason = '';
    if (deleteAccountViewModel.reason.text.isNotEmpty) {
      reason = deleteAccountViewModel.reason.text.toString();
    } else {
      reason = stringVariables.noLongerUserAccount;
    }
    setLoading(true);
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "deleted_reason": reason,
        "password": encryptDecrypt.encryptUsingAESAlgorithm(password.text),
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await ProductRepository().fetchVerifyDeleteAccount(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setDeleteAccount(decodeResponse.data);
          setLoading(false);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          stringVariables.internetNotAvailable, SnackbarType.negative);
      notifyListeners();
    }
  }

  setDeleteAccount(CreateFiatDepositModel? data) {
    createFiatDepositModel = data;
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        '${createFiatDepositModel?.statusMessage}',
        createFiatDepositModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (createFiatDepositModel?.statusCode == 200) {
      moveToAccountDeletedView(NavigationService.navigatorKey.currentContext!);
    }

    notifyListeners();
  }
}
