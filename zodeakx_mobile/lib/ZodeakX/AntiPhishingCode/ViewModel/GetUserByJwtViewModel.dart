import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/Model/GetUserByJwt.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

class GetUserByJwtViewModel extends ChangeNotifier {
  GetUserByJwtViewModel? viewModel;

  bool noInternet = false;
  bool needToLoad = false;
  bool positiveStatus = false;
  bool showSnackbar = false;
  GetUserByJwt? jwtUserResponse;

  /// initilizing API
  GetUserByJwtViewModel() {
    //getJwtUserResponse();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// set FiatCurrency
  setJwtUserResponse(GetUserByJwt? jwtUserResponse) {
    jwtUserResponse = jwtUserResponse;
    notifyListeners();
  }

  /// Get FiatCurrency

  getJwtUserResponse() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
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
