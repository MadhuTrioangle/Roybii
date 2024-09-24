import 'package:flutter/cupertino.dart';

import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Languages/English/StringVariables.dart';

class WalletSelectViewModel extends ChangeNotifier {

  String firstWallet  = stringVariables.spotWallet;
   String secondtWallet  = stringVariables.crossMargin;

  List<Map<String, dynamic>>  walletArray = [
  {
  "title": stringVariables.spotWallet,
  "logo": walletImage,
  "isSelected": false
  },
  {
  "title": stringVariables.crossMargin,
  "logo": crossMargin,
  "isSelected": false
  },
  {
  "title": stringVariables.isolatedMargin,
  "logo": coinFuture,
  "isSelected": false
  },
  {"title": stringVariables.funding, "logo": funding, "isSelected": false},
  {
  "title": stringVariables.usdsfutures,
  "logo": usdFuture,
  "isSelected": false
  },
  {
  "title": stringVariables.coinFuture,
  "logo": coinFuture,
  "isSelected": false
  }
  ];
   String filterFirstWallet = stringVariables.spotWallet;
   String filterSecondWallet = stringVariables.funding;

  WalletSelectViewModel() {
 
  }

 

  selectFilterFirstWallet(String value) {
    filterFirstWallet = value;
    notifyListeners();
  }

  selectFilterSecondWallet(String value) {
    filterSecondWallet = value;
    notifyListeners();
  }

  selectFirstWallet(String value) {
    firstWallet = value;
    notifyListeners();
  }

  selectSecondWallet(String value) {
    secondtWallet = value;
    notifyListeners();
  }

  selectSwapWallet(String value1, String value2) {
    firstWallet = value1;
    secondtWallet = value2;
    securedPrint("firstWallet${firstWallet}");
    securedPrint("secondtWallet${secondtWallet}");
    notifyListeners();
  }

  
  late List<Map<String, dynamic>> tempData = [];

  walletCheck(int firsIndex, String firstwalletName, String secondwalletName) {

    tempData.clear();
    tempData.addAll(walletArray);

    var tempWalletName = firsIndex == 0 ? firstwalletName : secondwalletName;
    var removeFunding = false;

    if (tempWalletName != stringVariables.crossMargin) {
      removeFunding = true;
    } else if (tempWalletName != stringVariables.isolatedMargin) {
      removeFunding = true;
    }

    print(
        'Sample text ${tempData.firstWhere((element) => element["title"] == firstwalletName)}');

    var fisrtMap =
        tempData.firstWhere((element) => element["title"] == firstwalletName);
    tempData.removeWhere((element) => element == fisrtMap);
    var secondMAp =
        tempData.firstWhere((element) => element["title"] == secondwalletName);
    tempData.removeWhere((element) => element == secondMAp);

    if (firsIndex == 0) {
      if (removeFunding &&
          (secondwalletName == stringVariables.crossMargin ||
              secondwalletName == stringVariables.isolatedMargin)) {
        var fundingRemoved = tempData.firstWhere(
            (element) => element["title"] == stringVariables.funding);
        tempData.removeWhere((element) => element == fundingRemoved);
      } else if (secondwalletName == stringVariables.usdsfutures) {
        var removeCoinM = tempData.firstWhere(
            (element) => element["title"] == stringVariables.coinFuture);
        tempData.removeWhere((element) => element == removeCoinM);
      } else if (secondwalletName == stringVariables.coinFuture) {
        var removeUsdm = tempData.firstWhere(
            (element) => element["title"] == stringVariables.usdsfutures);
        tempData.removeWhere((element) => element == removeUsdm);
      } else if (secondtWallet == stringVariables.funding) {
        var removeIsolated = tempData.firstWhere(
            (element) => element["title"] == stringVariables.isolatedMargin);
        tempData.removeWhere((element) => element == removeIsolated);
        var removeCross = tempData.firstWhere(
            (element) => element["title"] == stringVariables.crossMargin);
        tempData.removeWhere((element) => element == removeCross);
      }
    } else {
      if (removeFunding &&
          (firstwalletName == stringVariables.crossMargin ||
              firstwalletName == stringVariables.isolatedMargin)) {
        var fundingRemoved = tempData.firstWhere(
            (element) => element["title"] == stringVariables.funding);
        tempData.removeWhere((element) => element == fundingRemoved);
      } else if (firstwalletName == stringVariables.usdsfutures) {
        var removeCoin = tempData.firstWhere(
            (element) => element["title"] == stringVariables.coinFuture);
        tempData.removeWhere((element) => element == removeCoin);
      } else if (firstwalletName == stringVariables.coinFuture) {
        var removeUsdm = tempData.firstWhere(
            (element) => element["title"] == stringVariables.usdsfutures);
        tempData.removeWhere((element) => element == removeUsdm);
      } else if (firstwalletName == stringVariables.funding) {
        var removeIsolated = tempData.firstWhere(
            (element) => element["title"] == stringVariables.isolatedMargin);
        tempData.removeWhere((element) => element == removeIsolated);
        var removeCross = tempData.firstWhere(
            (element) => element["title"] == stringVariables.crossMargin);
        tempData.removeWhere((element) => element == removeCross);
      }
    }

    return tempData;
  }

  // final List<Map<String, dynamic>> walletArray = [
  //   // {
  //   //   "title": stringVariables.usdsfutures,
  //   //   "logo": usdFuture,
  //   // },
  //   // {
  //   //   "title": stringVariables.coinFuture,
  //   //   "logo": coinFuture,
  //   // },
  //   {
  //     "title": stringVariables.crossMargin,
  //     "logo": crossMargin,
  //   },
  //   {
  //     "title": stringVariables.isolatedMargin,
  //     "logo": coinFuture,
  //   },
  //   {
  //     "title": stringVariables.spotWallet,
  //     "logo": walletImage,
  //   },
  //   // {
  //   //   "title": stringVariables.funding,
  //   //   "logo": funding,
  //   // },
  // ];
  //
  // fundingStatus() {
  //   if (constant.fundingStatus) {
  //     walletArray.insert(3, {
  //       "title": stringVariables.funding,
  //       "logo": funding,
  //     });
  //   }
  // }
  //
  // futureStatus(){
  //   if (constant.fundingStatus) {
  //     walletArray.insert(4, {
  //       "title": stringVariables.usdsfutures,
  //       "logo": usdFuture,
  //     });
  //     walletArray.insert(5, {
  //       "title": stringVariables.coinFuture,
  //       "logo": coinFuture,
  //     });
  //   }
  // }
}
