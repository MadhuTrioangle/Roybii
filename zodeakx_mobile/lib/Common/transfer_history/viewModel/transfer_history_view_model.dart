import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../transfer/viewModel/transfer_view_model.dart';
import '../model/funding_transfer_history_details.dart';

class TransferHistoryViewModel extends ChangeNotifier {


  bool noInternet = false;
  bool needToLoad = false;
  String orderStartDate = "";
  String orderEndDate = "";
  int tabIndex = 0;
   String   firstWallet = stringVariables.spotWallet;
   String secondWallet= stringVariables.fundingWallet;
  var endDate;
  var startDate;
  GetUserFundingWalletTransferDetailsClass?
      getUserFundingWalletTransferDetailsClass;
  String startFilterDate = "";
  String endFilterDate = "";
  TransferViewModel? transferViewModel;
  List<GetUserFundingWalletTransferDetails>? cryptoHistory = [];
  List<GetUserFundingWalletTransferDetails>? fiatHistory = [];

  setDate([bool isReset = false]) {
    final now = DateTime.now();
    final week = now.subtract(Duration(days: 7));
    securedPrint("now$now");
    securedPrint("week$week");
    if (startFilterDate.isEmpty || isReset)
      setStartFilterDate(DateFormat('yyyy-MM-dd').format(week));
    if (endFilterDate.isEmpty || isReset)
      setEndFilterDate(DateFormat('yyyy-MM-dd').format(now));
    notifyListeners();
    securedPrint('startDate$startDate');
    securedPrint('endDate$endDate');
  }

  TransferHistoryViewModel() {
  }

  setStartFilterDate(String value) {
    startFilterDate = value;
    notifyListeners();
  }

  setEndFilterDate(String value) {
    endFilterDate = value;
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setTabIndex(int value) async {
    tabIndex = value;
    notifyListeners();
  }

  setFirstWallet(String value) {
    firstWallet = value;
    notifyListeners();
  }

  setSecondWallet(String value) {
    secondWallet = value;
    notifyListeners();
  }

  setOrderStartDate(String value) {
    orderStartDate = value;
    notifyListeners();
  }

  setOrderEndDate(String value) {
    orderEndDate = value;
    notifyListeners();
  }

  //API
  fetchTransferHistory(int page) async {
    Map<String, dynamic> params = {
      "transferHistoryData": {
        "queryData": {
          "wallet":
              tabIndex == 0 ? stringVariables.cross : stringVariables.isolated,
        },
        "skip": page,
        "limit": 5
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchTransferHistory(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          // setTransferHistory(decodeResponse.data?.result, page);
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

  // setTransferHistory(TransferHistory? result, int page) {
 
  //   if (crossTransferHistory == null ||
  //       isolatedTransferHistory == null ||
  //       page == 0) {
  //     if (tabIndex == 0)
  //       crossTransferHistory = result ?? TransferHistory();
  //     else
  //       isolatedTransferHistory = result ?? TransferHistory();
  //   } else {
  //     if ((result?.data ?? []).isEmpty) {
  //       ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
  //           .removeCurrentSnackBar();
  //       customSnackBar.showSnakbar(
  //           NavigationService.navigatorKey.currentContext!,
  //           stringVariables.noMoreRecords,
  //           SnackbarType.negative);
  //     } else {
  //       if (tabIndex == 0) {
  //         crossTransferHistory?.data?.addAll(result?.data ?? []);
  //         crossTransferHistory?.total = result?.total;
  //         crossTransferHistory?.page = result?.page;
  //       } else {
  //         isolatedTransferHistory?.data?.addAll(result?.data ?? []);
  //         isolatedTransferHistory?.total = result?.total;
  //         isolatedTransferHistory?.page = result?.page;
  //       }
  //     }
  //   }
  //   needToLoad = false;
  //   notifyListeners();
  // }

  fetchTransferHistoryForFunding() async {
    transferViewModel = Provider.of<TransferViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    Map<String, dynamic> params = {
      "input": {
        "from": firstWallet == stringVariables.spotWallet
            ? "spot_wallet"
            : "funding_wallet",
        "to": secondWallet == stringVariables.spotWallet
            ? "spot_wallet"
            : "funding_wallet",
        "currency_code": (transferViewModel?.setCurrencyForFilter == '' ||
                transferViewModel?.setCurrencyForFilter == stringVariables.all)
            ? []
            : transferViewModel?.setCurrencyForFilter,
        "date": {"start_date": startFilterDate, "end_date": endFilterDate}
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchTransferHistoryForFunding(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setTransferHistoryForFunding(decodeResponse.data);
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

  setTransferHistoryForFunding(GetUserFundingWalletTransferDetailsClass? data) {
    cryptoHistory?.clear();
    fiatHistory?.clear();
    getUserFundingWalletTransferDetailsClass = data;
    cryptoHistory = getUserFundingWalletTransferDetailsClass?.result
        ?.where((element) => element.currencyType == "crypto")
        .toList();
    fiatHistory = getUserFundingWalletTransferDetailsClass?.result
        ?.where((element) => element.currencyType != "crypto")
        .toList();
    securedPrint("cryptoHistory${cryptoHistory?.length}");
    securedPrint("fiatHistory${fiatHistory?.length}");
    setLoading(false);
    notifyListeners();
  }
}
