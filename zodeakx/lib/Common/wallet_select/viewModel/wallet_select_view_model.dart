import 'package:flutter/cupertino.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Languages/English/StringVariables.dart';

class WalletSelectViewModel extends ChangeNotifier{

  final List<Map<String, dynamic>> walletArray = [
    {
      "title": stringVariables.usdsfutures,
      "logo": usdFuture,
    },
    {
      "title": stringVariables.crossMargin,
      "logo": crossMargin,
    },
    {
      "title": stringVariables.funding,
      "logo": funding,
    },
    {
      "title": stringVariables.coinFuture,
      "logo": coinFuture,
    },
    {
      "title": stringVariables.isolatedMargin,
      "logo": coinFuture,
    },
  ];

  String firstWallet = stringVariables.spotWallet;
  String secondtWallet = stringVariables.crossMargin;

  selectFirstWallet(String value){
    firstWallet = value;
    notifyListeners();
  }
  selectSecondWallet(String value){
    secondtWallet = value;
    notifyListeners();
  }

}