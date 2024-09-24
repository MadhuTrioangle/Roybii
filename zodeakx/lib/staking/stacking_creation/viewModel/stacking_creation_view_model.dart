import 'package:flutter/cupertino.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../home_page/model/stacking_home_page_model.dart';

class StackingCreationViewModel extends ChangeNotifier {
  bool checkAlert = false;
  bool checkBoxStatus = false;
  bool checkAlertstatus = false;
  bool noInternet = false;
  bool needToLoad = true;
  num availableBalance = 0;
  num stakeBalance = 0;
  num totalPersonalQuota = 0;
  num minStakeAmount = 0;
  num maxStakeAmount = 0;
  num availableQuota = 0;
  int selectPlan = 0;
  num aprValue = 0;
  num apr = 0;
  num aprInYear = 0;
  String? planId = '';
  num interestAmount = 0;
  int lockedDurationValue = 0;
  var coinDetails;
  List<String> planDetails = [];
  GetActiveStakesClass? getActiveStakesClass;
  GetBalance? getBalance;

  Future<void> setActive(bool value) async {
    checkAlert = value;
    setActivestatus(false);
    notifyListeners(); //  Consumer to rebuild
  }

  Future<void> setActivestatus(bool value) async {
    checkAlertstatus = value;
    notifyListeners(); //  Consumer to rebuild
  }

  setSelectPlan(int value) async {
    selectPlan = value;
    notifyListeners();
  }

  setAprValue(num value) async {
    aprValue = value;
    notifyListeners();
  }

  setlockedDurationValue(int value) async {
    lockedDurationValue = value;
    notifyListeners();
  }

  setPlanId(String value) async {
    planId = value;
    notifyListeners();
  }

  setEstimatedValue(String amount) {
    apr = aprValue / 100;
    aprInYear = aprValue / 365;
    interestAmount =
        double.parse('${amount}') * aprInYear * lockedDurationValue;
    securedPrint('interestAmount${interestAmount.toStringAsFixed(6)}');
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
    notifyListeners();
  }

  getDashBoardBalance(GetAllActiveStatus? activeStakesList) async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchBalance();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setBalance(decodeResponse.data, activeStakesList);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  setBalance(
    GetBalance? data,
    GetAllActiveStatus? activeStakesList,
  ) {
    getBalance = data;
    coinDetails = getBalance?.result
        ?.where((e) =>
            e.currencyCode == activeStakesList?.stakeCurrencyDetails?.code)
        .toList();
    if (activeStakesList!.isFlexible == true) {}
    if (activeStakesList!.childs!.length != 0) {
      planDetails = [];
      if (activeStakesList.isFlexible == true) {
        planDetails.add(stringVariables.flexbile);
      }
      activeStakesList.childs?.forEach((element) {
        if (element.lockedDuration != null) {
          planDetails.add(element.lockedDuration.toString());
        }
      });
    }

    totalPersonalQuota = activeStakesList!.totalPersonalQuota ?? 0;
    minStakeAmount = activeStakesList.minStakeAmount ?? 0;
    maxStakeAmount = activeStakesList.maxStakeAmount ?? 0;
    availableBalance = coinDetails[0].availableBalance;
    stakeBalance = coinDetails[0].stakeBalance;
    availableQuota = totalPersonalQuota - stakeBalance;

    setLoading(false);
    notifyListeners();
  }

  /// stacking creation
  stackingCreation(
      String amount,
      bool isFlexible,
      String id,
      String? interestDistributionDate,
      String? planId,
      String? interestEndDate,
      String? redemptionDate,
      String code) async {
    Map<String, dynamic> params = {
      "data": isFlexible == true
          ? {
              "stakeAmount": double.parse(amount),
              "isFlexible": isFlexible,
              "id": id,
              "interestDistributeDate": interestDistributionDate
            }
          : {
              "stakeAmount": double.parse(amount),
              "isFlexible": isFlexible,
              "id": id,
              "interestDistributeDate": interestDistributionDate,
              "planId": planId,
              "interestEndDate": interestEndDate,
              "redemptionEndDate": redemptionDate
            }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getStakeCreation(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCreation(decodeResponse.data, amount, code);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  setCreation(CommonModel? commonModel, String amount, String code) {
    if (commonModel?.statusCode == 200) {
      checkAlert = false;
       checkBoxStatus = false;
       checkAlertstatus = false;
      moveToStackingSuccessfulView(
          NavigationService.navigatorKey.currentContext!, amount, code);
    } else {
      CustomSnackBar().showSnakbar(
          NavigationService.navigatorKey.currentContext!,
          '${commonModel?.statusMessage}',
          SnackbarType.negative);
    }
  }

  clearData() {
     checkAlert = false;
     checkBoxStatus = false;
     checkAlertstatus = false;
     noInternet = false;
     needToLoad = true;
     availableBalance = 0;
     stakeBalance = 0;
     totalPersonalQuota = 0;
     minStakeAmount = 0;
     maxStakeAmount = 0;
     availableQuota = 0;
     selectPlan = 0;
     aprValue = 0;
     apr = 0;
     aprInYear = 0;
    planId = '';
     interestAmount = 0;
     lockedDurationValue = 0;
     coinDetails = null;
     planDetails = [];
     getActiveStakesClass = null;
     getBalance = null;
  }
}
