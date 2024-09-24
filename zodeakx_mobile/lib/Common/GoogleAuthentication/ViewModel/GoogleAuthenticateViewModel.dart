import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetUserByJwtModel.dart';
import '../../../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../../../Utils/Core/appFunctons/encryptAndDecrypt.dart';
import '../../../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../Repositories/CommonRepository.dart';
import '../Model/GoogleAutheticateModel.dart';

class GoogleAuthenticateViewModel extends ChangeNotifier{
  GoogleAuthenticateViewModel? viewModel;
  bool noInternet = false;
  bool needToLoad = false;
  Verifytfa? verifytfa;
  GetUserJwt? viewModelVerification;
  bool positiveStatus = false;
  bool showSnackbar = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  /// initilizing API
  GoogleAuthenticateViewModel(){
    getIdVerification();
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

  /// IconButton onPress value using provider

  bool loginPasswordVisible = false;
  void loginPasswordIcon() {
    loginPasswordVisible = !loginPasswordVisible;
    notifyListeners();
  }

  /// enable google authenticate
  getEnableStatus(context,Verifytfa? enableReseponse){
    verifytfa = enableReseponse;
    constant.pref?.setBool('buttonStatus', true);
    constant.pref?.setString("userEmail", verifytfa?.result?.buttonvalue ??"",);
    constant.userLoginStatus.value = true;
    enableReseponse?.statusMessage == 200 ?
    customSnackBar.showSnakbar(context, verifytfa?.statusMessage ?? "",
        (verifytfa?.statusCode == 200) ? SnackbarType.positive : SnackbarType.negative) : null;

    getSnackBarstatus(context, enableReseponse);
  }
  createGoogleAuthenticate( String userPassCode, BuildContext context, String codeAppend) async{
    setLoading(true);

    Map<String,dynamic> mutateUserParams = {
      "data": {
        "tfaenablekey": constant.QRSecertCode.value,
        "tfaonecode": codeAppend,
        "password": encryptDecrypt.encryptUsingAESAlgorithm(userPassCode),
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet){
      var response = await commonRepository.MutateVerifyTFA(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
    //  response.result?.buttonvalue = constant.buttonValue.value;
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:

  constant.buttonValue.value= response.result?.buttonvalue == 'Disable'? 'verified' : 'unverified';

    SharedPreferences prefs =
    await SharedPreferences.getInstance();
    prefs.setString("buttonValue", constant.buttonValue.value);
          (decodeResponse.data?.statusMessage == 200) ?Navigator.of(scaffoldKey.currentContext!).pop(true) : (){};
          customSnackBar.showSnakbar(context, decodeResponse.data?.statusMessage ?? '',
              decodeResponse.data?.statusCode == 200 ? SnackbarType.positive  : SnackbarType.negative);
          notifyListeners();
          break;
        default:
          setLoading(false);
          break;
      }
    }else{
      noInternet = true;
      setLoading(true);
    }
  }


  getSnackBarstatus(context, Verifytfa? enableReseponse){
    positiveStatus = ((enableReseponse?.statusCode ?? 200) == 200) ? true : false;
  }

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// Get IdVerification

  getIdVerification() async{
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet){
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      constant.antiCode.value= response.result?.antiPhishingCode  ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          constant.antiCode.value= response.result?.antiPhishingCode  ?? '';
        setIdVerification(decodeResponse.data?.result);
          setLoading(false);
          break;
        default: setLoading(false); break;
      }
    }else{
      setLoading(true);
      noInternet = true;
      notifyListeners();
    }
  }


}