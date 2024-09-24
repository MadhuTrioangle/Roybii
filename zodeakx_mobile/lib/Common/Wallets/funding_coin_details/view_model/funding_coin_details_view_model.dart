import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import 'package:zodeakx_mobile/ZodeakX/Repositories/ProductRepositories.dart';

import '../../../../Utils/Constant/AppConstants.dart';

import '../../../../Utils/Languages/English/StringVariables.dart';
import '../../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../../p2p/orders/model/UserOrdersModel.dart';

class FundingCoinDetailsViewModel extends ChangeNotifier {

  TextEditingController platformController = TextEditingController();
  bool noInternet = false;
  bool needToLoad = true;
  UserOrders? userOrders;

  FundingCoinDetailsViewModel() {}

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// API
  fetchUserOrders([int page = 0, String coin = ""]) async {
    Map<String, dynamic> queryData = {
      "status": ["unpaid", "paid", "appeal", "cancelled", "completed"],
      "start_date": "",
      "end_date": ""
    };

    if (coin.isNotEmpty) queryData["from_asset"] = coin;

    Map<String, dynamic> mutateUserParams = {
      "fetchUserOrdersData": {"queryData": queryData, "skip": page, "limit": 5}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchUserOrders(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUserOrders(decodeResponse.data?.result, page);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      setLoading(true);
    }
  }

  setUserOrders(UserOrders? userOrders, int page) {

    setLoading(false);

    if (page != 0 && (userOrders?.data ?? []).isEmpty) {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          stringVariables.noMoreRecords, SnackbarType.negative);
      return;
    }

    if (userOrders == null || page == 0)
      this.userOrders = userOrders;
    else {
      this.userOrders?.data?.addAll(userOrders.data ?? []);
      this.userOrders?.total = userOrders.total;
      this.userOrders?.page = userOrders.page;
    }

    notifyListeners();
  }
}
