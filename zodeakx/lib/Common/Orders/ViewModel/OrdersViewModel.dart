import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Common/Orders/Model/TradeHistoryModel.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../Model/CancelledOrderModel.dart';
import '../Model/TradeOrderModel.dart';

class OrdersViewModel extends ChangeNotifier {

  String pair = "ETH/BTC";
  bool noInternet = false;
  bool needToLoad = true;
  int openCounter = 3;
  bool openReadMoreFlag = false;
  int historyCounter = 3;
  int cancelCounter = 3;
 bool historyReadMoreFlag = false;
 bool cancelReadMoreFlag = false;
  List<Order>? openOrderHistory;
  TradeHistoryModel? tradeHistory;
  int tradeHistoryPageCounter = 0;
  int cancelHistoryPageCounter = 0;
  List<CancelOrder>? cancelOrders;
   int cancelTotal = 0;
  int cancelPage = 0;


  fetchData() {
    getOpenOrders();
    setLoading(true);
  }

  getOpenOrders() async {
    Map<String, dynamic> params = {
      "tradeOrderQueryData": {
        "queryData": {
          "status": [
            "Active",
            "InActive",
            "partially",
            "New",
            "Partially Filled",
            "New Active"
          ]
        },
        "sort": {"ordered_date": -1},
        "skip": 0,
        "limit": 100000
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchOpenOrderHistory(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setOpenOrders(decodeResponse.data?.result?.data);
          //setLoading(false);
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

  /// set open order history
  setOpenOrders(List<Order>? data) {
    openOrderHistory = data;
    setLoading(false);
    notifyListeners();

    //  getTradeHistory(tradeHistoryPageCounter);
  }

  /// cancelled order
  getCancelledOrders(int cancelPageCounter) async {
    Map<String, dynamic> params = {
      "tradeOrderQueryData": {
        "queryData": {
          "status": ["cancelled"]
        },
        "sort": {"ordered_date": -1},
        "skip": cancelPageCounter,
        "limit": 5
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchCancelOrderrHistory(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          (decodeResponse.data!.result!.data == null || decodeResponse.data!.result!.data!.isEmpty)
              ? setCancelReadMoreFlag(false)
              : setCancelledOrders(decodeResponse.data,cancelPageCounter);

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



  /// set cancelled order history
  setCancelledOrders(CancelledOrderModelClass? result, int cancelPageCounter) {
    if (cancelHistoryPageCounter == 0) {
      if (result!.result!.data!.isNotEmpty) {
        result.result!.data!.length > 3
            ? setCancelReadMoreFlag(true)
            : setCancelReadMoreFlag(false);
        result.result!.data!.length > 3
            ? setCancelCounter(3)
            : setCancelCounter(result.result!.data!.length);
      }
      cancelOrders = result.result!.data;
    } else {
      cancelOrders!.addAll(result!.result!.data!);
    }
    notifyListeners();
    // cancelTotal = result?.result?.total ?? 0;
    // if(cancelOrders == null || cancelPageCounter == 0){
    //   cancelOrders = result?.result?.data;
    // }else{
    //   cancelOrders!.addAll(result?.result?.data ?? []);
    //   //cancelTotal = result?.result?.total ?? 0;
    //   cancelPage = result?.result?.page ?? 0;
    // }
    //
    //
    // setLoading(false);
    // notifyListeners();
    // //  getTradeHistory(tradeHistoryPageCounter);
  }

  /// Trade history
  getTradeHistory(int tradeHistoryPageCounter) async {
    Map<String, dynamic> params = {
      "tradeTransactionHistoryData": {
        "queryData": {"trade_type": "All"},
        "sort": {"created_date": -1},
        "skip": tradeHistoryPageCounter,
        "limit": 5
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchTradeHistory(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          (decodeResponse.data!.result!.data == null || decodeResponse.data!.result!.data!.isEmpty)
              ? setHistoryReadMoreFlag(false)
              : setTradeHistory(decodeResponse.data!.result!);
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


  /// set open order history
  setTradeHistory(TradeHistoryModel tradeHistory) {
    if (tradeHistoryPageCounter == 0) {
      if (tradeHistory.data!.isNotEmpty) {
        tradeHistory.data!.length > 3
            ? setHistoryReadMoreFlag(true)
            : setHistoryReadMoreFlag(false);
        tradeHistory.data!.length > 3
            ? setHistoryCounter(3)
            : setHistoryCounter(tradeHistory.data!.length);
      }
      this.tradeHistory = tradeHistory;
    } else {
      this.tradeHistory?.data!.addAll(tradeHistory.data!);
    }
    notifyListeners();
  }

  cancelOrder(String id, BuildContext context) async {
    Map<String, dynamic> params = {
      "data": {"id": id}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.cancelOrder(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCancelOrder(decodeResponse.data!, context);
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

  setCancelOrder(CommonModel model, BuildContext context) {
    if (model.statusCode == 200) {
      setOpenCounter(openCounter - 1);
      CustomSnackBar().showSnakbar(
          NavigationService.navigatorKey.currentContext!,
          model.statusMessage!,
          SnackbarType.positive);
    } else {
      CustomSnackBar().showSnakbar(
          NavigationService.navigatorKey.currentContext!,
          model.statusMessage!,
          SnackbarType.negative);
    }
    fetchData();
    notifyListeners();
  }


  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// pair
  setPair(String pair) async {
    this.pair = pair;
    notifyListeners();
  }

  /// Open Counter
  setOpenCounter(int counter) async {
    openCounter = counter;
    notifyListeners();
  }

  /// History Counter
  setHistoryCounter(int counter) async {
    historyCounter = counter;
    notifyListeners();
  }

  /// Cancel Counter
  setCancelCounter(int counter) async {
    cancelCounter = counter;
    notifyListeners();
  }

  /// Open ReadMore
  setOpenReadMoreFlag(bool flag) async {
    openReadMoreFlag = flag;
    notifyListeners();
  }



  /// History ReadMore
  setHistoryReadMoreFlag(bool flag) async {
    historyReadMoreFlag = flag;
    notifyListeners();
  }

  /// cancel ReadMore
  setCancelReadMoreFlag(bool flag) async {
    cancelReadMoreFlag = flag;
    notifyListeners();
  }

  checkHistoryHasMoreData() {
    tradeHistoryPageCounter++;
    getTradeHistory(tradeHistoryPageCounter);
  }

  checkCancelHasMoreData() {
    cancelHistoryPageCounter++;
    getCancelledOrders(cancelHistoryPageCounter);
  }

}
