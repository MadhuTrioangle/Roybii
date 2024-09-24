import 'package:flutter/cupertino.dart';

import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../model/stacking_home_page_model.dart';

class StackingHomePageViewModel extends ChangeNotifier {
  GetActiveStakesClass? getActiveStakesClass;
  List<GetAllActiveStatus>? activityStatus;
  bool releaseExpandFlag = false;
  bool needToLoad = true;
  bool noInternet = false;
  bool searchControllerText = false;

  setReleaseExpandFlag(int value) async {
    GetAllActiveStatus getAllActiveStatus =
        getActiveStakesClass!.result![value];
    getAllActiveStatus.isExpand = !getAllActiveStatus.isExpand;
    notifyListeners();
  }

  setsearchControllerText(bool value) async {
    searchControllerText = value;
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// getActiveStatus
  getActiveStatus() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchActiveStatus();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setActiveStatus(decodeResponse.data!);
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

  setActiveStatus(GetActiveStakesClass _getActiveStakesClass) {
    getActiveStakesClass = _getActiveStakesClass;
    activityStatus = getActiveStakesClass?.result;
    setLoading(false);
    notifyListeners();
  }

  clearData() {
    getActiveStakesClass = null;
    activityStatus = null;
    releaseExpandFlag = false;
    needToLoad = true;
    noInternet = false;
    searchControllerText = false;
  }
}
