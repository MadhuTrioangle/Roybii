import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/staking/balance/model/StakedBalanceModel.dart';
import 'package:zodeakx_mobile/staking/balance/model/balance_model.dart';
import 'package:zodeakx_mobile/staking/search_coins/viewModel/search_coins_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/view_model/staking_transaction_view_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../home_page/model/stacking_home_page_model.dart';
import '../model/ActiveUserStakesModel.dart';

class StakingBalanceViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool buttonLoading = false;
  bool autoSubscribeStatus = false;
  ActiveUserStakes? activeUserStakes;
  GetActiveStakesClass? getActiveStakesClass;
  List<GetAllActiveStatus>? activityStatus;
  List<StakeData> filteredUserStakeDetails = [];
  GetUserStakesByIdClass? particularDetailsId;
  StakedBalance? stakedBalance;
  num estimateTotalStakeBalance = 0;
  num earningTotalStakeBalance = 0;
  num estimateFiatTotalStakeBalance = 0;
  num estimateTotalStakeConverted = 0;
  num estimateFiatTotalStakeConverted = 0;
  num exchangeRate = 0;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setButtonLoading(bool loading) async {
    buttonLoading = loading;
    notifyListeners();
  }

  setAutoSubscribeStatus(bool value) async {
    autoSubscribeStatus = value;
    notifyListeners();
  }

  setUserStackExpand(int index) async {
    activeUserStakes!.stakeData![index].isExpanded =
        !activeUserStakes!.stakeData![index].isExpanded;
    notifyListeners();
  }

  setFilteredUserStackExpand(int index) async {
    filteredUserStakeDetails[index].isExpanded =
        !filteredUserStakeDetails[index].isExpanded;
    notifyListeners();
  }

  setSortedUserStakeDetails() {
    StakingTransactionViewModel stakingTransactionViewModel =
        Provider.of<StakingTransactionViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    filteredUserStakeDetails = activeUserStakes?.stakeData ?? [];

    if (stakingTransactionViewModel.sortSet1 != 2) {
      if (stakingTransactionViewModel.sortSet1 == 0) {
        filteredUserStakeDetails = List.of(filteredUserStakeDetails)
          ..sort((a, b) => (b.stakeAmount!).compareTo(a.stakeAmount!));
      } else {
        filteredUserStakeDetails = List.of(filteredUserStakeDetails)
          ..sort((a, b) => (a.stakeAmount!).compareTo(b.stakeAmount!));
      }
    }
    if (stakingTransactionViewModel.sortSet2 != 2) {
      if (stakingTransactionViewModel.sortSet2 == 0) {
        filteredUserStakeDetails = List.of(filteredUserStakeDetails)
          ..sort((a, b) => (b.stakedAt!).compareTo(a.stakedAt!));
      } else {
        filteredUserStakeDetails = List.of(filteredUserStakeDetails)
          ..sort((a, b) => (a.stakedAt!).compareTo(b.stakedAt!));
      }
    }
    notifyListeners();
  }

  //API
  getActiveUserStakes(int page) async {
    String fiat = constant.pref?.getString("defaultFiatCurrency") ?? '';
    SearchCoinsViewModel searchCoinsViewModel =
        Provider.of<SearchCoinsViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    StakingTransactionViewModel stakingTransactionViewModel =
        Provider.of<StakingTransactionViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    String selectedHolding = stakingTransactionViewModel.selectedHoldings;

    Map<String, dynamic> queryData = {
      "skip": page,
      "limit": 5,
      "userPreferredCurrency": fiat,
    };
    Map<String, dynamic> searchData = {};

    if (searchCoinsViewModel.selectedCurrency != null)
      searchData["stakeCurrency"] = searchCoinsViewModel.selectedCurrency;

    if (stakingTransactionViewModel.selectedHoldings !=
        stringVariables.allHoldings)
      searchData["isFlexible"] = selectedHolding == stringVariables.flexible;

    if (searchData.keys.isNotEmpty) {
      queryData["searchData"] = searchData;
    }

    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.getActiveUserStakes(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setActiveUserStakes(decodeResponse.data?.result, page);
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

  setActiveUserStakes(ActiveUserStakes? activeUserStakes, int page) {
    if (page == 0) {
      this.activeUserStakes = activeUserStakes;
    } else {
      this
          .activeUserStakes
          ?.stakeData
          ?.addAll(activeUserStakes?.stakeData ?? []);
      this.activeUserStakes?.page = activeUserStakes?.page;
    }
    this.activeUserStakes?.stakeData?.forEach((element) {
      num total = 0;
      num addedTotal = 0;
      List<DateTime> dateList = [];
      element?.data?.forEach((e) {
        total = e.stakeAmount ?? 0;
        addedTotal = addedTotal! + total!;
        dateList.add(DateTime.parse(e.stakedAt ?? DateTime.now().toString()));
      });
      element.stakedAt = calcMaxDate(dateList).toString();
      element.stakeAmount = addedTotal;
    });
    filteredUserStakeDetails = activeUserStakes?.stakeData ?? [];
    setSortedUserStakeDetails();
    getStakeBalance();
    notifyListeners();
  }

  DateTime calcMaxDate(List<DateTime> dates) {
    DateTime maxDate = dates[0];
    dates.forEach((date) {
      if (date.isAfter(maxDate)) {
        maxDate = date;
      }
    });
    return maxDate;
  }

  updateUserRestake(String id, bool status) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"id": id, "restakeStatus": status}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.updateUserRestake(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setUpdateUserRestake(decodeResponse.data, status);
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

  setUpdateUserRestake(CommonModel? commonModel, bool status) {
    if (commonModel?.statusCode == 200) {
      setAutoSubscribeStatus(status);
      getActiveUserStakes(0);
    } else {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .removeCurrentSnackBar();
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
    notifyListeners();
  }

  getActiveStatus(String id) async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchActiveStatus();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setActiveStatus(decodeResponse.data!, id);
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

  setActiveStatus(GetActiveStakesClass _getActiveStakesClass, String id) {
    getActiveStakesClass = _getActiveStakesClass;
    activityStatus = getActiveStakesClass?.result;
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    List<GetAllActiveStatus>? filteredList =
        activityStatus?.where((element) => element.id == id).toList();
    if ((filteredList ?? []).isNotEmpty) {
      GetAllActiveStatus? getAllActiveStatus = filteredList?.first;
      String viewType = (getAllActiveStatus?.isFlexible ?? false)
          ? stringVariables.locked
          : stringVariables.flexible;
      moveToStackingCreationView(context, viewType, getAllActiveStatus!);
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      customSnackBar.showSnakbar(
          context, stringVariables.planNotAvailable, SnackbarType.negative);
    }
    setButtonLoading(false);
    notifyListeners();
  }

  getParticluarStackDetails(String id) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"id": id}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.getParticularStake(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setParticluarStackDetails(decodeResponse.data);
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

  setParticluarStackDetails(GetUserStakesByIdClass? result) {
    particularDetailsId = result;
    setLoading(false);
    notifyListeners();
  }

  getStakeBalance() async {
    String fiat = constant.pref?.getString("defaultFiatCurrency") ?? '';
    Map<String, dynamic> mutateUserParams = {
      "data": {"userPreferredCurrency": fiat}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getStakeBalance(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setStakeBalance(decodeResponse.data?.result);
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

  setStakeBalance(StakedBalance? stakedBalance) {
    this.stakedBalance = stakedBalance;
    WalletViewModel walletViewModel = Provider.of<WalletViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    walletViewModel.setLoading(false);
    setLoading(false);
    estimateTotalStakeBalance = 0;
    estimateFiatTotalStakeBalance = 0;
    earningTotalStakeBalance = 0;
    stakedBalance?.stakeBalance?.forEach((element) {
      estimateTotalStakeBalance += element.stakeBalanceByDefaultCurrency ?? 0;
      estimateFiatTotalStakeBalance += element.stakeBalanceByUserPreferred ?? 0;
    });
    stakedBalance?.earnBalance?.forEach((element) {
      earningTotalStakeBalance +=
          element.stakeEarnBalanceByDefaultCurrency ?? 0;
    });
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    autoSubscribeStatus = false;
    autoSubscribeStatus = false;
    buttonLoading = false;
    constant.pref?.setBool("balanceUpdateStatus", true);
    activeUserStakes = null;
    getActiveStakesClass = null;
    activityStatus = null;
    particularDetailsId = null;
    stakedBalance = null;
    estimateTotalStakeBalance = 0;
    estimateFiatTotalStakeBalance = 0;
    earningTotalStakeBalance = 0;
  }
}
