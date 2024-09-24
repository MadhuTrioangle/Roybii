import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/staking/search_coins/viewModel/search_coins_view_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../staking_transaction/model/UserStakeEarnModel.dart';
import '../../staking_transaction/model/UserStakeModel.dart';

class StakingOrderHistoryViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool tabLoading = false;
  String? startDate;
  String? endDate;
  bool dateFilterApplied = false;
  int tabIndex = 0;
  String selectedOrder = stringVariables.flexible;
  String beforeOrder = stringVariables.flexible;
  List<String> tabs = [
    stringVariables.subscription,
    stringVariables.redemption,
    stringVariables.realTimeAprRewards
  ];
  List<String> product = [stringVariables.flexible, stringVariables.locked];
  UserStake? userStake;
  UserStakeEarn? userStakeEarn;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setTabLoading(bool loading) async {
    tabLoading = loading;
    notifyListeners();
  }

  setSelectedOrder(String value) async {
    selectedOrder = value;
    if (tabIndex != 2)
      getUserStakes(0);
    else
      getUserStakeEarns(0);
    notifyListeners();
  }

  setBeforeOrder(String value) async {
    beforeOrder = value;
    notifyListeners();
  }

  setTabs(List<String> value) async {
    tabs = value;
    notifyListeners();
  }

  /// tab index
  setTabIndex(int value) async {
    tabIndex = value;
    notifyListeners();
  }

  /// start Date
  setStartDate(String? value) async {
    startDate = value;
    notifyListeners();
  }

  /// end Date
  setEndDate(String? value) async {
    endDate = value;
    notifyListeners();
  }

  /// date filter Applied
  setDateFilterApplied(bool value) async {
    dateFilterApplied = value;
    if (!value) {
      resetDates();
      if (tabIndex != 2)
        getUserStakes(0);
      else
        getUserStakeEarns(0);
    }
    notifyListeners();
  }

  resetDates() {
    startDate = null;
    endDate = null;
  }

  resetProduct() async {
    beforeOrder = stringVariables.flexible;
    notifyListeners();
  }

  //API
  getUserStakes(int page) async {
    SearchCoinsViewModel searchCoinsViewModel =
        Provider.of<SearchCoinsViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    Map<String, dynamic> queryData = {"skip": page, "limit": 5};
    Map<String, dynamic> searchData = {};
    searchData["isFlexible"] = selectedOrder == stringVariables.flexible;
    if (tabIndex != 2)
      searchData["status"] = tabIndex == 0
          ? [stringVariables.staked]
          : [stringVariables.redeemed, stringVariables.redeemRequest];
    if (searchCoinsViewModel.selectedHistoryCurrency != null)
      searchData["stakeCurrency"] =
          searchCoinsViewModel.selectedHistoryCurrency;
    if (startDate != null && endDate != null) {
      searchData["startDate"] = startDate;
      searchData["endDate"] = endDate;
    }
    if (searchData.keys.isNotEmpty) {
      queryData["searchData"] = searchData;
    }
    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getUserStakes(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUserStakes(decodeResponse.data?.result, page);
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

  setUserStakes(UserStake? userStake, int page) {
    if (page == 0) {
      this.userStake = userStake;
    } else {
      this.userStake?.data?.addAll(userStake?.data ?? []);
      this.userStake?.page = userStake?.page;
      this.userStake?.total = userStake?.total;
    }
    setTabLoading(false);
    setLoading(false);
    notifyListeners();
  }

  getUserStakeEarns(int page) async {
    SearchCoinsViewModel searchCoinsViewModel =
    Provider.of<SearchCoinsViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    Map<String, dynamic> queryData = {"skip": page, "limit": 5};
    Map<String, dynamic> searchData = {};
    searchData["isFlexible"] = selectedOrder == stringVariables.flexible;
    if (searchCoinsViewModel.selectedHistoryCurrency != null)
      searchData["rewardCurrency"] =
          searchCoinsViewModel.selectedHistoryCurrency;
    if (startDate != null && endDate != null) {
      searchData["startDate"] = startDate;
      searchData["endDate"] = endDate;
    }
    if (searchData.keys.isNotEmpty) {
      queryData["searchData"] = searchData;
    }
    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.getUserStakeEarns(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUserStakeEarns(decodeResponse.data?.result, page);
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

  setUserStakeEarns(UserStakeEarn? userStakeEarn, int page) {
    if (page == 0) {
      this.userStakeEarn = userStakeEarn;
    } else {
      this.userStakeEarn?.data?.addAll(userStakeEarn?.data ?? []);
      this.userStakeEarn?.page = userStakeEarn?.page;
      this.userStakeEarn?.total = userStakeEarn?.total;
    }
    setTabLoading(false);
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    dateFilterApplied = false;
    tabIndex = 0;
    selectedOrder = stringVariables.flexible;
    beforeOrder = stringVariables.flexible;
    userStake = null;
    userStakeEarn = null;
  }
}
