import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetUserByJwtModel.dart';

import '../../../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Common/GoogleAuthentication/Model/GoogleAutheticateModel.dart';

class SecurityViewModel extends ChangeNotifier {
  SecurityViewModel? viewModel;
  bool noInternet = false;
  bool needToLoad = false;
  Verifytfa? verifytfa;
  GetUserJwt? viewModelVerification;
  bool positiveStatus = false;
  bool showSnackbar = false;
  bool buttonEnable = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// initilizing API
  SecurityViewModel() {}

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setButtonValue(bool buttonEnable) async {
    this.buttonEnable = buttonEnable;
    notifyListeners();
  }

  /// IconButton onChanged value using provider

  bool passwordVisible = false;

  void changeIcon() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  /// IconButton onPress value using provider

  bool loginPasswordVisible = false;

  void loginPasswordIcon() {
    loginPasswordVisible = !loginPasswordVisible;
    notifyListeners();
  }

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// Get IdVerification

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
