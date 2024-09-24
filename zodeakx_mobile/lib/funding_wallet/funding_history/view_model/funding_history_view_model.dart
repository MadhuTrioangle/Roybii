import 'package:flutter/material.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../../p2p/orders/model/UserOrdersModel.dart';

class FundingHistoryViewModel extends ChangeNotifier {

  String statusPending = stringVariables.all;
  String statusCompleted = stringVariables.all;
  List<String> walletTabs = [
    stringVariables.pending,
    stringVariables.completed,
  ];

  List<String> payTabs = [
  stringVariables.paid,
  stringVariables.received,];
  int statusIndex = 0;
  int walletIndex = 0;
  int payIndex = 0;
  bool noInternet = false;
  bool needToLoad = true;
  UserOrders? userOrders;
  String startDate = "";
  String endDate = "";

  bool filterApplied = false;



  FundingHistoryViewModel() {

  }
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  void setStatusTabIndex(int value) async {
    statusIndex = value;
    notifyListeners();
  }

  void setStatusPending(String value) async {
    statusPending = value;
    notifyListeners();
  }

  void setStatusCompleted(String value) async {
    statusCompleted = value;
    notifyListeners();
  }

  void setWalletTabIndex(int value) async {
    walletIndex = value;
    notifyListeners();
  }

  void setPayTabIndex(int value) async {
    payIndex = value;
    notifyListeners();
  }

  setFilterApplied(bool value) async {
    filterApplied = value;
    notifyListeners();
  }

  /// API
  fetchUserOrders([int page = 0]) async {
    List<String> filter = [
      "unpaid",
      "paid",
      "appeal",
      "cancelled",
      "completed"
    ];

    if (walletIndex == 0) {
      if (statusIndex == 0) {
        if (statusPending == stringVariables.all) {
          filter = ["unpaid", "paid", "appeal"];
        } else {
          String value = statusPending.toLowerCase();
          if (filter.contains(value)) {
            filter = [value];
          } else {
            filter = ["appeal"];
          }
        }
      } else {
        if (statusCompleted == stringVariables.all) {
          filter = ["cancelled", "completed"];
        } else {
          String value = statusCompleted.toLowerCase();
          filter = [value];
        }
      }
    }

    Map<String, dynamic> queryData = {"status": filter};

    if (statusIndex == 1 && startDate.isNotEmpty && endDate.isNotEmpty) {
      queryData["start_date"] = startDate;
      queryData["end_date"] = endDate;
    }

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

  setStartDate(String value) async {
    startDate = value;
    notifyListeners();
  }

  setEndDate(String value) async {
    endDate = value;
    notifyListeners();
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
