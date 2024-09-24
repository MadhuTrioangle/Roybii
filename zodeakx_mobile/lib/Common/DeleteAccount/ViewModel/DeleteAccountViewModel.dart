import 'package:flutter/cupertino.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class DeleteAccountViewModel extends ChangeNotifier {

  int currentlength=0;
  bool noInternet = false;
  bool needToLoad = true;
  bool buttonClick = true;
  final TextEditingController reason = TextEditingController();

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setButtonClick(bool value) {
    buttonClick = value;
    notifyListeners();
  }

  setCurrentLength(int value){
    currentlength=value;
    notifyListeners();
  }
  /// Get IdVerification

  // deleteUserRequest() async {
  //   var hasInternet = await checkInternet.hasInternet();
  //   if (hasInternet) {
  //     var response = await ProductRepository.deleteUserRequest();
  //     var decodeResponse = HandleResponse.completed(response);
  //     switch (decodeResponse.status?.index) {
  //       case 0:
  //         setLoading(false);
  //         break;
  //       case 1:
  //         setDeleteUserRequest(decodeResponse.data);
  //         break;
  //       default:
  //         setLoading(false);
  //         break;
  //     }
  //   } else {
  //     setLoading(true);
  //     noInternet = true;
  //     customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
  //         stringVariables.internetNotAvailable, SnackbarType.negative);
  //     notifyListeners();
  //   }
  // }

  setDeleteUserRequest(CommonModel? result) {
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        result?.statusMessage ?? "",
        result?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    needToLoad = false;
    notifyListeners();
  }
}
