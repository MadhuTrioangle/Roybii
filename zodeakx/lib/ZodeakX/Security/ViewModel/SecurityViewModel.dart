import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/GoogleAuthentication/View/GoogleAuthenticate/Model/GoogleAutheticateModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetUserByJwtModel.dart';
import '../../../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';

class SecurityViewModel extends ChangeNotifier {
  SecurityViewModel? viewModel;
  bool noInternet = false;
  bool needToLoad = false;
  Verifytfa? verifytfa;
  GetUserJwt? viewModelVerification;
  bool positiveStatus = false;
  bool showSnackbar = false;
  bool buttonEnable = false;
  String buttonValue = 'Enable';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// initilizing API
  SecurityViewModel() {
    //getIdVerification();
  }

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
          if (decodeResponse.data?.statusCode == 200) {
            constant.pref?.setString(
                "firstName",
                response.result?.kyc?.idProof?.firstName ??
                    "${constant.appName}");
            buttonValue = response.result?.tfaStatus ?? '';
            constant.QRSecertCode.value = response.result?.tfaEnableKey ?? "";
            constant.buttonValue.value = response.result?.tfaStatus ?? '';
            constant.pref?.setString(
                "buttonValue", response.result?.tfaStatus ?? "UnVerified");
            if (constant.buttonValue.value == 'verified') {
              setButtonValue(true);
            } else {
              setButtonValue(false);
            }
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("buttonValue", constant.buttonValue.value);
            constant.antiCode.value = response.result?.antiPhishingCode ?? '';
            prefs.setString("code", constant.antiCode.value);
          }
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
