import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/p2p/order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../home/model/p2p_advertisement.dart';
import '../../profile/model/UserPaymentDetailsModel.dart';
import '../model/UserOrdersModel.dart';

class P2POrderViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool itemClicked = false;
  bool listLoder = false;

  UserOrders? userOrdersPending;
  List<OrdersData>? unpaidOrders;
  List<OrdersData>? paidOrders;
  List<OrdersData>? appealOrders;
  UserOrders? userOrdersCompleted;
  List<OrdersData>? completedOrders;
  List<OrdersData>? cancelledOrders;
  P2PAdvertisement? particularAdvertisement;

  List<String> completedItems = [
  stringVariables.all,
  stringVariables.completed,
  stringVariables.cancelled,
  ];
  List<String> pendingItems = [
  stringVariables.all,
  stringVariables.unPaid,
  stringVariables.paid,
  stringVariables.appealPending,
  ];

  P2POrderViewModel() {

  }



  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setItemClicked(bool value) async {
    itemClicked = value;
    notifyListeners();
  }

  /// List Loader
  setListLoading(bool loading) async {
    listLoder = loading;
    notifyListeners();
  }

  //API
  //type = 0 - ALL, 1 - Unpaid, 2 - Paid, 3 - Appeal
  fetchUserOrdersPending([int type = 0, int page = 0]) async {
    Map<String, dynamic> queryData = {
      "status": ["unpaid", "paid", "appeal"],
      "start_date": "",
      "end_date": ""
    };

    if (type == 1) {
      queryData = {
        "status": ["unpaid"],
        "start_date": "",
        "end_date": ""
      };
    } else if (type == 2) {
      queryData = {
        "status": ["paid"],
        "start_date": "",
        "end_date": ""
      };
    } else if (type == 3) {
      queryData = {
        "status": ["appeal"],
        "start_date": "",
        "end_date": ""
      };
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
          getUserOrdersPending(decodeResponse.data?.result, type, page);
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

  getUserOrdersPending(UserOrders? userOrders, int type, int page) {
    setLoading(false);
    setListLoading(false);
   
    if (page != 0 && (userOrders?.data ?? []).isEmpty) {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          stringVariables.noMoreRecords, SnackbarType.negative);
      return;
    }
    switch (type) {
      case 0:
        if (userOrdersPending == null || page == 0)
          this.userOrdersPending = userOrders;
        else
          userOrdersPending?.data?.addAll(userOrders?.data ?? []);
        break;
      case 1:
        if (unpaidOrders == null || page == 0)
          unpaidOrders = userOrders?.data;
        else
          unpaidOrders?.addAll(userOrders?.data ?? []);
        break;
      case 2:
        if (paidOrders == null || page == 0)
          paidOrders = userOrders?.data;
        else
          paidOrders?.addAll(userOrders?.data ?? []);
        break;
      case 3:
        if (appealOrders == null || page == 0)
          appealOrders = userOrders?.data;
        else
          appealOrders?.addAll(userOrders?.data ?? []);
        break;
      default:
        this.userOrdersPending = userOrders;
        break;
    }
    notifyListeners();
  }

  //type = 0 - ALL, 1 - Completed, 2 - Cancelled
  fetchUserOrdersCompleted([int type = 0, int page = 0]) async {
    Map<String, dynamic> queryData = {
      "status": ["cancelled", "completed"],
      "start_date": "",
      "end_date": ""
    };

    if (type == 1) {
      queryData = {
        "status": ["completed"],
        "start_date": "",
        "end_date": ""
      };
    } else if (type == 2) {
      queryData = {
        "status": ["cancelled"],
        "start_date": "",
        "end_date": ""
      };
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
          getUserOrdersCompleted(decodeResponse.data?.result, type, page);
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

  getUserOrdersCompleted(UserOrders? userOrders, int type, int page) {
    setLoading(false);
    setListLoading(false);
  
    if (page != 0 && (userOrders?.data ?? []).isEmpty) {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          stringVariables.noMoreRecords, SnackbarType.negative);
      return;
    }
    switch (type) {
      case 0:
        if (userOrdersCompleted == null || page == 0)
          this.userOrdersCompleted = userOrders;
        else
          userOrdersCompleted?.data?.addAll(userOrders?.data ?? []);
        break;
      case 1:
        if (completedOrders == null || page == 0)
          completedOrders = userOrders?.data;
        else
          completedOrders?.addAll(userOrders?.data ?? []);
        break;
      case 2:
        if (cancelledOrders == null || page == 0)
          cancelledOrders = userOrders?.data;
        else
          cancelledOrders?.addAll(userOrders?.data ?? []);
        break;
      default:
        this.userOrdersCompleted = userOrders;
        break;
    }
    notifyListeners();
  }

  fetchParticularUserAdvertisement(String id, OrdersData ordersData) async {
    String userId = ordersData.sellerId ?? "";
    String orderType = capitalize(ordersData.tradeType ?? "");
    if (ordersData.sellerId == ordersData.loggedInUser) {
      userId = orderType == stringVariables.buy
          ? ordersData.sellerId ?? ""
          : ordersData.buyerId ?? "";
    } else {
      userId = orderType == stringVariables.buy
          ? ordersData.sellerId ?? ""
          : ordersData.buyerId ?? "";
    }
    Map<String, dynamic> mutateUserParams = {
      "userAdvertisementData": {
        "queryData": {"ad_id": id, "user_id": userId}
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchUserAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getParticularUserAdvertisement(
              decodeResponse.data?.result, ordersData);
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

  getParticularUserAdvertisement(
      P2PAdvertisement? p2pAdvertisement, OrdersData ordersData) {
    particularAdvertisement = p2pAdvertisement;
    String id = ordersData.id ?? "";
    String status = ordersData.status ?? "";
    String side = ordersData.tradeType ?? "";
    String adId = ordersData.advertisementId ?? "";
    String paymentName = ordersData.paymentMethod?.paymentMethodName ??
        ((p2pAdvertisement?.data ?? []).isNotEmpty
            ? (p2pAdvertisement
                    ?.data?.first.paymentMethod?.first.paymentMethodName ??
                "")
            : "");
    int timeLimit = (p2pAdvertisement?.data ?? []).isEmpty
        ? 0
        : (p2pAdvertisement?.data?.first.paymentTimeLimit ?? 0).toInt();
    bool isBuyFlow = ordersData.buyerId == ordersData.loggedInUser;
    if (isBuyFlow) {
      if (status == stringVariables.unPaid.toLowerCase()) {
        fetchParticularUserOrders(id, ordersData, 0, paymentName);
      } else if (status == stringVariables.paid.toLowerCase()) {
        fetchParticularUserOrders(id, ordersData, 1, paymentName);
      } else if (status == stringVariables.appeal.toLowerCase()) {
        DateTime? modifiedDate = ordersData.modifiedDate!;
        DateTime current = (DateTime.now());
        modifiedDate = modifiedDate?.add(Duration(minutes: 10));
        int? difference = modifiedDate?.difference(current).inSeconds;
        String loggedInUser = ordersData.loggedInUser ?? "";
        itemClicked = false;
        if ((difference ?? 0) > 0) {
          P2POrderCreationViewModel p2pOrderCreationViewModel =
              Provider.of<P2POrderCreationViewModel>(
                  NavigationService.navigatorKey.currentContext!,
                  listen: false);
          p2pOrderCreationViewModel.orderId = id;
          p2pOrderCreationViewModel.leaveOrderLocalSocket(id);
          p2pOrderCreationViewModel.getOrderLocalSocket(id, side);
          moveToAppealView(NavigationService.navigatorKey.currentContext!, id,
              side, loggedInUser);
        } else {
          moveToAppealPendingView(
              NavigationService.navigatorKey.currentContext!, ordersData);
        }
      } else {
        customSnackBar.showSnakbar(
            NavigationService.navigatorKey.currentContext!,
            status,
            SnackbarType.negative);
      }
    } else {
      itemClicked = false;
      if (status == stringVariables.unPaid.toLowerCase() ||
          status == stringVariables.paid.toLowerCase()) {
        P2POrderCreationViewModel p2pOrderCreationViewModel =
            Provider.of<P2POrderCreationViewModel>(
                NavigationService.navigatorKey.currentContext!,
                listen: false);
        p2pOrderCreationViewModel.leaveOrderLocalSocket(id);
        p2pOrderCreationViewModel.getOrderLocalSocket(id, side);
        DateTime? modifiedDate = ordersData.modifiedDate!;
        DateTime current = (DateTime.now());
        if (timeLimit == 1) timeLimit = 60;
        modifiedDate = modifiedDate?.add(Duration(minutes: timeLimit!.toInt()));
        int? difference = modifiedDate?.difference(current).inSeconds;
        if ((difference ?? 0) > 0) {
          p2pOrderCreationViewModel.timer?.cancel();
          p2pOrderCreationViewModel.setCountDown(difference ?? 0);
          p2pOrderCreationViewModel.startCountDown(id);
        } else {
          p2pOrderCreationViewModel.setCountDown(0);
          if (status.toLowerCase() == stringVariables.unPaid.toLowerCase())
            p2pOrderCreationViewModel.cancelOrder(id);
        }
        p2pOrderCreationViewModel.setTimeLimit(timeLimit);
        // p2pOrderCreationViewModel.timer?.cancel();
        // p2pOrderCreationViewModel.setCountDown(difference ?? 0);
        //p2pOrderCreationViewModel.startCountDown(id);
        moveToWaitingPaymentView(NavigationService.navigatorKey.currentContext!,
            adId, id, paymentName, timeLimit);
      } else if (status == stringVariables.appeal.toLowerCase()) {
        DateTime? modifiedDate = ordersData.modifiedDate!;
        DateTime current = (DateTime.now());
        modifiedDate = modifiedDate?.add(Duration(minutes: 10));
        int? difference = modifiedDate?.difference(current).inSeconds;
        String loggedInUser = ordersData.loggedInUser ?? "";
        itemClicked = false;
        if ((difference ?? 0) > 0) {
          P2POrderCreationViewModel p2pOrderCreationViewModel =
              Provider.of<P2POrderCreationViewModel>(
                  NavigationService.navigatorKey.currentContext!,
                  listen: false);
          p2pOrderCreationViewModel.orderId = id;
          p2pOrderCreationViewModel.leaveOrderLocalSocket(id);
          p2pOrderCreationViewModel.getOrderLocalSocket(id, side);
          moveToAppealView(NavigationService.navigatorKey.currentContext!, id,
              side, loggedInUser);
        } else {
          moveToAppealPendingView(
              NavigationService.navigatorKey.currentContext!, ordersData);
        }
      }
    }
    notifyListeners();
  }

  fetchParticularUserOrders(String id, OrdersData ordersData, int type,
      [String? paymentName]) async {
    Map<String, dynamic> mutateUserParams = {
      "fetchUserOrdersData": {
        "queryData": {"order_id": id}
      }
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
          setParticularUserOrders(
              decodeResponse.data, ordersData, type, paymentName);
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

  setParticularUserOrders(
      UserOrdersModel? userOrdersModel, OrdersData ordersData, int type,
      [String? paymentNameByAd]) {
    String id = ordersData.id ?? "";
    String adId = ordersData.advertisementId ?? "";
    String side = ordersData.tradeType ?? "";
    String status = ordersData.status ?? "";
    int timeLimit = (particularAdvertisement?.data ?? []).isEmpty
        ? 0
        : (particularAdvertisement?.data?.first.paymentTimeLimit ?? 0).toInt();
    switch (type) {
      case 0:
        P2POrderCreationViewModel p2pOrderCreationViewModel =
            Provider.of<P2POrderCreationViewModel>(
                NavigationService.navigatorKey.currentContext!,
                listen: false);
        p2pOrderCreationViewModel.leaveOrderLocalSocket(id);
        p2pOrderCreationViewModel.getOrderLocalSocket(id, side);
        DateTime? modifiedDate = ordersData.modifiedDate!;
        DateTime current = (DateTime.now());
        if (timeLimit == 1) timeLimit = 60;
        modifiedDate = modifiedDate?.add(Duration(minutes: timeLimit!.toInt()));
        int? difference = modifiedDate?.difference(current).inSeconds;
        if ((difference ?? 0) > 0) {
          p2pOrderCreationViewModel.timer?.cancel();
          p2pOrderCreationViewModel.setCountDown(difference ?? 0);
          p2pOrderCreationViewModel.startCountDown(id);
        } else {
          p2pOrderCreationViewModel.setCountDown(0);
          if (status.toLowerCase() == stringVariables.unPaid.toLowerCase())
            p2pOrderCreationViewModel.cancelOrder(id);
        }
        itemClicked = false;
        p2pOrderCreationViewModel.setTimeLimit(timeLimit);
        moveToPayTheSellerView(NavigationService.navigatorKey.currentContext!,
            id, paymentNameByAd, adId, userOrdersModel);
        break;
      case 1:
        fetchPaymentMethods(id, userOrdersModel);
        break;
    }
    notifyListeners();
  }

  fetchPaymentMethods(String id, UserOrdersModel? userOrdersModel) async {
    Map<String, dynamic> mutateUserParams = {"UserPaymentDetails": {}};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchUserPaymentDetails(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getPaymentMethods(decodeResponse.data?.result, id, userOrdersModel);
          print(decodeResponse.data?.result?.first.userId);
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

  getPaymentMethods(List<UserPaymentDetails>? paymentMethods, String id,
      UserOrdersModel? userOrdersModel) {
    P2POrderCreationViewModel p2pOrderCreationViewModel =
        Provider.of<P2POrderCreationViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    p2pOrderCreationViewModel.leaveOrderLocalSocket(id);
    p2pOrderCreationViewModel.getOrderLocalSocket(
        id, userOrdersModel?.result?.data?.first.tradeType ?? '');
    DateTime? modifiedDate = userOrdersModel?.result?.data?.first.modifiedDate!;
    int timeLimit = (particularAdvertisement?.data ?? []).isEmpty
        ? 0
        : (particularAdvertisement?.data?.first.paymentTimeLimit ?? 0).toInt();
    DateTime current = (DateTime.now());
    if (timeLimit == 1) timeLimit = 60;
    modifiedDate = modifiedDate?.add(Duration(minutes: timeLimit.toInt()));
    int? difference = modifiedDate?.difference(current).inSeconds;
    p2pOrderCreationViewModel.timer?.cancel();
    p2pOrderCreationViewModel.setCountDown(difference ?? 0);
    p2pOrderCreationViewModel.startCountDown(id);
    itemClicked = false;
    moveToCryptoReleasingView(NavigationService.navigatorKey.currentContext!,
        id, paymentMethods, userOrdersModel);
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    listLoder = false;
    userOrdersPending = null;
    unpaidOrders = null;
    paidOrders = null;
    appealOrders = null;
    userOrdersCompleted = null;
    completedOrders = null;
    cancelledOrders = null;
    notifyListeners();
  }
}
