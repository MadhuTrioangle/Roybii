import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetActivityModel.dart';

import '../Model/GetUserByJwtModel.dart';

class GetActivityViewModel extends ChangeNotifier {
  GetActivityViewModel? viewModel;
  bool noInternet = false;
  bool needToLoad = true;
  List<TimeAndIp>? viewModelTimeIP;
  GetUserJwt? viewModelVerification;

  /// initilizing API
  GetActivityViewModel() {}

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// set TimeAndIp
  setIpAndTime(List<TimeAndIp>? ipAndTime) {
    viewModelTimeIP = ipAndTime;
    notifyListeners();
  }

  /// set IdVerification
  setIdVerification(GetUserJwt? status) {
    viewModelVerification = status;
    notifyListeners();
  }

  /// Get TimeAndIp

  getIpAndTime() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIpAndTime();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setIpAndTime(decodeResponse.data?.result);
          decodeResponse.data?.statusCode == 200 ? getIdVerification() : () {};
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

  /// Get IdVerification

  getIdVerification() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchIdVerification();
      var decodeResponse = HandleResponse.completed(response);
      constant.antiCode.value = response.result?.antiPhishingCode ?? '';
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          constant.buttonValue.value = response.result?.tfaStatus ?? '';
          constant.antiCode.value = response.result?.antiPhishingCode ?? '';
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
