import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/staking/search_coins/viewModel/search_coins_view_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../balance/view_model/staking_balance_view_model.dart';
import '../model/UserStakeEarnModel.dart';
import '../model/UserStakeModel.dart';

class StakingTransactionViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  List<String> holdings = [
    stringVariables.allHoldings,
    stringVariables.flexible,
    stringVariables.locked
  ];
  List<String> directions = [
    stringVariables.all,
    stringVariables.earnings,
    stringVariables.spendings
  ];
  List<String> types = [
    stringVariables.allTransactions,
    stringVariables.subscription,
    stringVariables.redemption,
    stringVariables.internalTransfer,
    stringVariables.income
  ];
  String selectedHoldings = stringVariables.allHoldings;
  String beforeHoldings = stringVariables.allHoldings;
  String selectedTypes = stringVariables.allTransactions;
  String beforeTypes = stringVariables.allTransactions;
  String selectedProduct = stringVariables.allHoldings;
  String beforeProduct = stringVariables.allHoldings;
  String selectedDirections = stringVariables.all;
  String beforeDirections = stringVariables.all;
  int activePage = 0;
  int sortSet1 = 2;
  int sortSet2 = 2;
  int beforeSet1 = 2;
  int beforeSet2 = 2;
  bool dateFilterApplied = false;
  String? startDate = null;
  String? endDate = null;
  UserStake? userStake;
  UserStakeEarn? userStakeEarn;
  List<dynamic> transactionList = [];
  List<dynamic> filteredTransactionList = [];

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setDateFilterApplied(bool value) async {
    dateFilterApplied = value;
    if (!value) {
      resetDates();
      getUserStakes(0);
    }
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

  setSelectedHoldings(String value) async {
    selectedHoldings = value;
    StakingBalanceViewModel stakingBalanceViewModel =
        Provider.of<StakingBalanceViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    stakingBalanceViewModel.getActiveUserStakes(0);
    notifyListeners();
  }

  setSelectedTypes(String value) async {
    selectedTypes = value;
    getUserStakes(0);
    notifyListeners();
  }

  setSelectedDirections(String value) async {
    selectedDirections = value;
    getUserStakes(0);
    notifyListeners();
  }

  setBeforeHoldings(String value) async {
    beforeHoldings = value;
    notifyListeners();
  }

  setBeforeTypes(String value) async {
    beforeTypes = value;
    notifyListeners();
  }

  setBeforeDirections(String value) async {
    beforeDirections = value;
    notifyListeners();
  }

  setSelectedProduct(String value) async {
    selectedProduct = value;
    getUserStakes(0);
    notifyListeners();
  }

  setBeforeProduct(String value) async {
    beforeProduct = value;
    notifyListeners();
  }

  setActivePage(int value) async {
    activePage = value;
    notifyListeners();
  }

  setSortSet1(int value) async {
    sortSet1 = value;
    StakingBalanceViewModel stakingBalanceViewModel =
        Provider.of<StakingBalanceViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    stakingBalanceViewModel.setSortedUserStakeDetails();
    notifyListeners();
  }

  setSortSet2(int value) async {
    sortSet2 = value;
    StakingBalanceViewModel stakingBalanceViewModel =
        Provider.of<StakingBalanceViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    stakingBalanceViewModel.setSortedUserStakeDetails();
    notifyListeners();
  }

  resetDates() {
    startDate = null;
    endDate = null;
  }

  setBeforeSet1(int value) async {
    beforeSet1 = value;
    notifyListeners();
  }

  setBeforeSet2(int value) async {
    beforeSet2 = value;
    notifyListeners();
  }

  resetHoldings() async {
    beforeHoldings = stringVariables.allHoldings;
    beforeSet1 = 2;
    beforeSet2 = 2;
    notifyListeners();
  }

  resetProduct() async {
    beforeProduct = stringVariables.allHoldings;
    notifyListeners();
  }

  resetTypes() async {
    beforeTypes = stringVariables.allTransactions;
    beforeDirections = stringVariables.all;
    notifyListeners();
  }

  setFilteredTransactionList() {
    filteredTransactionList = transactionList
        .where((element) => (element is UserStakeDetails)
            ? element.isFlexible ==
                (selectedProduct == stringVariables.flexible)
            : false)
        .toList();
    notifyListeners();
  }

  //API
  getUserStakes(int page) async {
    int limit = 5;
    if (selectedDirections == stringVariables.spendings ||
        (selectedTypes == stringVariables.earnings ||
            selectedTypes == stringVariables.spendings)) limit = 10;
    Map<String, dynamic> queryData = {"skip": page, "limit": limit};
    Map<String, dynamic> searchData = {};
    if (selectedProduct != stringVariables.allHoldings)
      searchData["isFlexible"] = selectedProduct == stringVariables.flexible;
    if (selectedDirections != stringVariables.all ||
        selectedTypes != stringVariables.allTransactions) {
      if (selectedTypes != stringVariables.allTransactions) {
        List<String> list = [];
        if (selectedDirections == stringVariables.earnings &&
            selectedTypes == stringVariables.redemption)
          list = [stringVariables.redeemed, stringVariables.redeemRequest];
        else if (selectedDirections == stringVariables.spendings &&
            selectedTypes == stringVariables.subscription)
          list = [stringVariables.staked];
        else if (selectedDirections == stringVariables.all) {
          list = selectedTypes == stringVariables.subscription
              ? [stringVariables.staked]
              : selectedTypes == stringVariables.redemption
                  ? [stringVariables.redeemed, stringVariables.redeemRequest]
                  : [stringVariables.redeem];
        } else
          list = [stringVariables.redeem];
        searchData["status"] = list;
      } else {
        searchData["status"] = selectedDirections == stringVariables.spendings
            ? [stringVariables.staked]
            : [stringVariables.redeemed, stringVariables.redeemRequest];
      }
    }
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
      transactionList.clear();
      transactionList.addAll(userStake?.data ?? []);
    } else {
      this.userStake?.data?.addAll(userStake?.data ?? []);
      this.userStake?.page = userStake?.page;
      this.userStake?.total = userStake?.total;
      transactionList.addAll(userStake?.data ?? []);
    }
    List<UserStakeEarnDetails> userStakeEarnDetails = userStakeEarn?.data ?? [];
    int listCount = userStakeEarnDetails.length;
    bool hasRecord = listCount != (userStakeEarn?.total ?? 0);
    if ((page == 0 || hasRecord) &&
        (selectedDirections != stringVariables.spendings) &&
        (selectedTypes == stringVariables.allTransactions ||
            selectedTypes == stringVariables.income))
      getUserStakeEarns(page);
    else
      setLoading(false);
    notifyListeners();
  }

  getUserStakeEarns(int page) async {
    int limit = 5;
    if (selectedDirections != stringVariables.all &&
        selectedTypes == stringVariables.income) limit = 10;
    Map<String, dynamic> queryData = {"skip": page, "limit": limit};
    Map<String, dynamic> searchData = {};
    if (selectedProduct != stringVariables.allHoldings)
      searchData["isFlexible"] = selectedProduct == stringVariables.flexible;
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
      transactionList.addAll(userStakeEarn?.data ?? []);
      transactionList = List.of(transactionList)
        ..sort((a, b) => (b is UserStakeEarnDetails ? b.createdAt : b.stakedAt)!
            .compareTo(a is UserStakeEarnDetails ? a.createdAt : a.stakedAt));
    } else {
      this.userStakeEarn?.data?.addAll(userStakeEarn?.data ?? []);
      this.userStakeEarn?.page = userStakeEarn?.page;
      this.userStakeEarn?.total = userStakeEarn?.total;
      transactionList.addAll(userStakeEarn?.data ?? []);
      transactionList = List.of(transactionList)
        ..sort((a, b) => (b is UserStakeEarnDetails ? b.createdAt : b.stakedAt)!
            .compareTo(a is UserStakeEarnDetails ? a.createdAt : a.stakedAt));
    }
    setLoading(false);
    notifyListeners();
  }

  getEarnings() async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"limit": 5}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getUserStakes(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setEarnings(decodeResponse.data?.result);
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

  setEarnings(UserStake? userStake) {
    setLoading(false);
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    selectedHoldings = stringVariables.allHoldings;
    selectedTypes = stringVariables.allTypes;
    selectedDirections = stringVariables.all;
    beforeHoldings = stringVariables.allHoldings;
    beforeTypes = stringVariables.allTransactions;
    beforeDirections = stringVariables.all;
    activePage = 0;
    sortSet1 = 2;
    sortSet2 = 2;
    beforeSet1 = 2;
    beforeSet2 = 2;
    dateFilterApplied = false;
    startDate = null;
    endDate = null;
    userStake = null;
    userStakeEarn = null;
    transactionList = [];
  }
}
