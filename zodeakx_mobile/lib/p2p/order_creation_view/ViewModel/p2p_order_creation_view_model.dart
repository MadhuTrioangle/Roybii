import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/p2p/chat_view/model/MessageHistoryModel.dart';
import 'package:zodeakx_mobile/p2p/order_details_view/model/FeedbackModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../appeal_progress_view/Model/p2p_appeal_progress_model.dart';
import '../../cancel_order_view/view/p2p_cancel_order_view.dart';
import '../../confirm_payment_view/view/p2p_confirm_payment_bottom_sheet.dart';
import '../../home/model/p2p_advertisement.dart';
import '../../orders/model/UserOrdersModel.dart';
import '../../profile/model/UserPaymentDetailsModel.dart';
import '../model/OrderCreationModel.dart';

class P2POrderCreationViewModel extends ChangeNotifier {
  FetchAppealHistory? appealHistory;
  bool isConfirmPayView = false;

  bool isProvide = false;
  bool consenses = false;
  String statusValue = '';
  String? appealId = '';
  bool isNegotiatied = false;
  int? timeLimitForOrder = 0;
  int count = 0;
  Timer? appealTimer;
  int appealCountDown = 0;
  dynamic? viewModel;
  int countDown = 0;
  bool noInternet = false;
  bool needToLoad = false;
  bool checkAlert = false;
  bool isPaymentView = false;
  bool releaseExpandFlag = false;
  bool completedExpandFlag = false;
  bool moreExpandFlag = false;
  bool? isRated = true;
  int tabIndex = 0;
  String quantity = "";
  String id = "";
  String userId = "";
  String orderId = "";
  String seller_id = "";
  String amount = "";
  OrderCreation? orderCreation;
  P2PAdvertisement? p2pAdvertisement;
  List<Advertisement>? advertisement;
  CancelReason reason = CancelReason.reason1;
  ReceivedPayment receivedPayment = ReceivedPayment.reason1;
  OrderCreationModel? orderCreationModel;
  UserOrdersModel? userOrdersModel;
  List<UserPaymentDetails>? paymentMethods;
  List<String> bankNames = [];
  List<String> appealDesc = [];

  String? selectedFiat = "UPI";
  String? selectedPayment = "UPI";
  Timer? timer;
  TextEditingController cmtController = TextEditingController();
  P2PFeedback? p2pFeedback;
  String cmtText = "";
  List<MessageHistory> messageHistory = [];
  String chatTime = "";
  XFile? imageChat;
  final ImagePicker imagePicker = ImagePicker();
  String? imageChatEncoded;
  int reportReason = 0;
  bool photoError = false;
  XFile? imageReport;
  List<String> imageReportEncoded = [];
  bool buttonLoader = false;

  P2POrderCreationViewModel() {
    cmtController.addListener(() {
      setCmtText(cmtController.text);
    });

  }



  getP2pSocket(){
    getChatLocalSocket(orderId);
  }

  offP2pSocket(){
    leaveChatLocalSocket(orderId);
}
  setAppealCountDown(int value) async {
    appealCountDown = value;
    notifyListeners();
  }

  Future pickImageForReport() async {
  
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
      source: source,
    );
    if (image == null) return;
    imageReport = XFile(image!.path);
    final bytes = File(imageReport!.path).readAsBytesSync();
    String value = base64Encode(bytes);
    if (!(imageReportEncoded ?? []).contains(value))
      imageReportEncoded.add(value);
    else {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .removeCurrentSnackBar();
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          stringVariables.imageAlready, SnackbarType.negative);
    }
    photoError = false;
    if (Platform.isAndroid) {
      getOrderLocalSocket(orderId, "sell");
    }
    notifyListeners();
  }

  Future pickImage(String id) async {
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
      source: source,
    );
    if (image == null) return;
    imageChat = XFile(image!.path);
    final bytes = File(imageChat!.path).readAsBytesSync();
    imageChatEncoded = base64Encode(bytes);
    // MessageHistory message = MessageHistory(
    //     userId: userId,
    //     image: imageChatEncoded,
    //     createdDate: DateTime.now().toUtc(),
    //     message: "");
    // message.sending = true;
    // updateChatHistory(message);
    MessageHistory messageHistory = MessageHistory(
      adminId: null,
      userId: userId,
      image: "data:image/jpeg;base64," + imageChatEncoded!,
      message: null,
    );
    sendMessageSocket(id, messageHistory);
    createMessage(id, "", imageChatEncoded);
    if (Platform.isAndroid) {
      leaveChatLocalSocket(id);
      getChatLocalSocket(id);
    }
    notifyListeners();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setTimeLimit(int value) {
    timeLimitForOrder = value;
    notifyListeners();
  }

  /// Tab index
  setTabIndex(int value) async {
    tabIndex = value;
    notifyListeners();
  }

  /// dropdown
  setSelectedFiat(String value) async {
    selectedFiat = value;
    notifyListeners();
  }

  setPaymentType(String value) async {
    selectedPayment = value;
    notifyListeners();
  }

  setCmtText(String value) async {
    cmtText = value;
    notifyListeners();
  }

  setReleaseExpandFlag(bool value) async {
    releaseExpandFlag = value;
    notifyListeners();
  }

  setReceivedPayment(ReceivedPayment value) async {
    receivedPayment = value;
    notifyListeners();
  }

  setCompletedExpandFlag(bool value) async {
    completedExpandFlag = value;
    notifyListeners();
  }

  setMoreExpandFlag(bool value) async {
    moreExpandFlag = value;
    notifyListeners();
  }

  setisProvide(bool value) async {
    isProvide = value;
    notifyListeners();
  }

  setIsConfirmPayView(bool value) async {
    isConfirmPayView = value;
    notifyListeners();
  }

  setCheckAlert(bool value) async {
    checkAlert = value;
    notifyListeners();
  }

  setIsRated(bool? value) async {
    isRated = value;
    notifyListeners();
  }

  setIsPaymentView(bool value) async {
    isPaymentView = value;
    notifyListeners();
  }

  setIsConsenses(bool value) async {
    consenses = value;
    notifyListeners();
  }

  setReason(CancelReason value) {
    reason = value;
    notifyListeners();
  }

  /// quantity
  setQuantity(String value) async {
    quantity = value;
    notifyListeners();
  }

  /// amount
  setAmount(String value) async {
    amount = value;
    notifyListeners();
  }

  setCountDown(int value) async {
    countDown = value;
    notifyListeners();
  }

  setChatTime(String value) async {
    chatTime = value;
    notifyListeners();
  }

  setReportReason(int value) async {
    reportReason = value;
    notifyListeners();
  }

  setPhotoError(bool value) async {
    photoError = value;
    notifyListeners();
  }

  setButtonLoader(bool value) async {
    buttonLoader = value;
    notifyListeners();
  }

  setImageReport(XFile? file) async {
    imageReport = file;
    notifyListeners();
  }

  setImageReportEncoded(List<String> list) async {
    imageReportEncoded = list;
    notifyListeners();
  }

  updateImageReportEncoded(String value) async {
    imageReportEncoded.remove(value);
    notifyListeners();
  }

  //API
  setViewModel(dynamic value) async {
    viewModel = value;
    notifyListeners();
  }

  ///appealConsensus
  appealConsensus(bool consensus, String description, String? side) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "order_id": orderId,
        "consensus": consensus,
        "description": description
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.appealConsensus(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getAppealConsensus(decodeResponse.data, consensus, side);
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

  getAppealConsensus(CommonModel? commonModel, bool consensus, String? side) {
    if (commonModel?.statusCode == 200) {
      count = 0;
      if (consensus == true) {
        appealTimer?.cancel();
        // fetchAppealHistory(orderId, false, side);
        customSnackBar.showSnakbar(
            NavigationService.navigatorKey.currentContext!,
            commonModel?.statusMessage ?? "",
            SnackbarType.positive);
      } else if (consensus == false) {
        //Navigator.of(NavigationService.navigatorKey.currentContext!).pop()
        appealTimer?.cancel();
        // fetchAppealHistory(orderId, false, side);
      }
    } else if (commonModel?.statusCode == 400) {
      //fetchAppealHistory(orderId, true, side);
      appealTimer?.cancel();
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
    notifyListeners();
  }

  /// fetch appeal history
  fetchAppealHistory([String? id, bool isSocket = false, String? side]) async {
    Map<String, dynamic> mutateUserParams = {
      "fetchAppealHistoryData": {"order_id": id ?? orderId}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchAppealHistory(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getAppealHistory(decodeResponse.data, isSocket, side, id);
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

  getAppealHistory(
      FetchAppealHistory? appeal, bool isSocket, String? side, String? id) {
    this.appealHistory = appeal;
    if (appealHistory!.statusCode == 200) {
      OrdersData ordersData =
          userOrdersModel?.result?.data?.first ?? OrdersData();
      seller_id = userOrdersModel?.result?.data?.first.sellerId ?? "";
      if (isSocket) {
        int len = appealHistory!.result!
            .where((element) => element.status == 'active')
            .length;
        appealHistory!.result?.forEach((element) {
          if (element.status == 'active') {
            appealId = appealHistory!.result!
                .where((element) => element.reasonForAppeal != null)
                .first
                .userId;
          }
        });
        if (len > 1) {
          if (isProvide == false) {
            if (userOrdersModel?.result?.data?[0].sellerId ==
                    userOrdersModel?.result?.data?[0].loggedInUser ||
                consenses == true) {
              // Navigator.of(NavigationService.navigatorKey.currentContext!)
              //     .pop();
              if (consenses == true) {
                isNegotiatied = true;
                timer?.cancel();
                appealTimer?.cancel();
                Navigator.of(NavigationService.navigatorKey.currentContext!)
                    .pop();
              } else {
                appealTimer?.cancel();
                DateTime? modifiedDate =
                    userOrdersModel?.result?.data?[0].modifiedDate;
                DateTime current = (DateTime.now());
                modifiedDate = modifiedDate?.add(Duration(minutes: 10));
                int? difference = modifiedDate?.difference(current).inSeconds;
                appealTimer?.cancel();
                setAppealCountDown(difference ?? 0);
                startAppealCountDown(orderCreationModel?.result?.id);
              }
            } else {
              appealTimer?.cancel();
              DateTime? modifiedDate =
                  userOrdersModel?.result?.data?[0].modifiedDate;
              DateTime current = (DateTime.now());
              modifiedDate = modifiedDate?.add(Duration(minutes: 10));
              int? difference = modifiedDate?.difference(current).inSeconds;
              appealTimer?.cancel();
              setAppealCountDown(difference ?? 0);
              startAppealCountDown(orderCreationModel?.result?.id);
            }
          } else {
            DateTime? modifiedDate =
                userOrdersModel?.result?.data?[0].modifiedDate;
            DateTime current = (DateTime.now());
            modifiedDate = modifiedDate?.add(Duration(minutes: 10));
            int? difference = modifiedDate?.difference(current).inSeconds;
            appealTimer?.cancel();
            setAppealCountDown(difference ?? 0);
            startAppealCountDown(orderCreationModel?.result?.id);
            if (ordersData.tradeType == stringVariables.buy.toLowerCase()) {
              if (userOrdersModel?.result?.data?[0].sellerId !=
                  userOrdersModel?.result?.data?[0].loggedInUser) {
                Navigator.of(NavigationService.navigatorKey.currentContext!)
                    .pop();
              } else {
                securedPrint("hiiii");
              }
            } else {
              if (userOrdersModel?.result?.data?[0].sellerId ==
                  userOrdersModel?.result?.data?[0].loggedInUser) {
                Navigator.of(NavigationService.navigatorKey.currentContext!)
                    .pop();
              }
            }
          }
        } else {
          if (isProvide == false) {
            timer?.cancel();
            //  setStatus('appeal');
            moveToAppealView(NavigationService.navigatorKey.currentContext!,
                id!, side, '${userOrdersModel?.result?.data?[0].loggedInUser}');
            DateTime? modifiedDate =
                userOrdersModel?.result?.data?[0].modifiedDate;
            DateTime current = (DateTime.now());
            modifiedDate = modifiedDate?.add(Duration(minutes: 10));
            int? difference = modifiedDate?.difference(current).inSeconds;
            appealTimer?.cancel();
            setAppealCountDown(difference ?? 0);
            startAppealCountDown(orderCreationModel?.result?.id);
          } else {
            Navigator.pop(NavigationService.navigatorKey.currentContext!);
          }
        }
      }
    } else {
      int len = appealHistory!.result!
          .where((element) => element.status == 'active')
          .length;
      if (len > 1) {
        timer?.cancel();
        appealTimer?.cancel();
        isNegotiatied = true;
        Navigator.pop(NavigationService.navigatorKey.currentContext!);
      }
    }
    setLoading(false);
    notifyListeners();
  }

  getOrderLocalSocket(String? id, String side) {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    securedPrint("orderId${marketViewModel.webSocket?.connected}");
    securedPrint(
        "socket count ---->>>>>${marketViewModel.webSocket?.connected}");
    marketViewModel.webSocket?.emit("joinOrderRoom", '${id}_order');
    marketViewModel.webSocket?.on('orderUpdate', (data) {
      securedPrint('øøøø $data');
      var decodeResponse = HandleResponse.completed(OrdersData.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          updateOrderDetails(decodeResponse.data!, side);
          //setLoading(false);
          break;
        default:
          //setLoading(false);
          break;
      }
    });

    //fetchOrderDetails(id!,"","");
  }

  getChatLocalSocket(String id) {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    print(marketViewModel.webSocket?.connected);
    marketViewModel.webSocket?.emit("joinChatRoom", id);
    marketViewModel.webSocket?.on('message', (data) {
      var decodeResponse =
          HandleResponse.completed(MessageHistory.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          //setLoading(false);
          break;
        case 1:
          updateChatHistory(decodeResponse.data!);
          //setLoading(false);
          break;
        default:
          //setLoading(false);
          break;

      }
    });
    marketViewModel.setViewModel(this);
  }

  getFeedbackLocalSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocket?.emit("joinOrderRoom", "${orderId}_order");
    marketViewModel.webSocket?.on('feedback', (data) {
      fetchFeedback();
    });
  }

  updateChatHistory(MessageHistory messageHistory) {
    this.messageHistory.insert(0, messageHistory);
    notifyListeners();
  }

  updateFeebackData(MessageHistory messageHistory) {
    this.messageHistory.insert(0, messageHistory);
    notifyListeners();
  }

  sendMessageSocket(String id, MessageHistory messageHistory) {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocket?.emit(id, messageHistory);
  }

  leaveChatLocalSocket(String id) {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocket?.emit("leaveChatRoom", id);
    marketViewModel.webSocket?.clearListeners();
  }

  leaveOrderLocalSocket(String id) {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocket?.emit("joinOrderRoom", '${id}_order');
    marketViewModel.webSocket?.clearListeners();
  }

  leaveFeedbackLocalSocket() {
    var marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.webSocket?.emit("leaveFeedbackRoom", orderId);
    marketViewModel.webSocket?.clearListeners();
  }

  updateOrderDetails(OrdersData ordersData, String side) {
    String id = userOrdersModel?.result?.data?[0].loggedInUser ?? '';
    String counterParty = userOrdersModel?.result?.data?[0].counterParty ?? '';

    if (ordersData.id == null) {
      timer?.cancel();
      appealTimer?.cancel();
      Navigator.pop(
        NavigationService.navigatorKey.currentContext!,
      );
      moveToOrderDetailsView(
          NavigationService.navigatorKey.currentContext!,
          '${userOrdersModel?.result?.data?[0].id}',
          userId,
          userOrdersModel?.result?.data?[0].advertisementId,
          userOrdersModel?.result?.data?[0].paymentMethod?.paymentMethodName,
          'creationView');
      return;
    }

    userOrdersModel?.result?.data?[0] = ordersData;
    userOrdersModel?.result?.data?[0].loggedInUser = id;
    userOrdersModel?.result?.data?[0].counterParty = counterParty;

    securedPrint("ID${id}");

    String status = userOrdersModel?.result?.data?[0].status ?? '';
    if (ordersData.sellerId == ordersData.loggedInUser) {
      id = ordersData.buyerId ?? "";
      userId = ordersData.sellerId ?? "";
    } else {
      id = ordersData.sellerId ?? "";
      userId = ordersData.buyerId ?? "";
    }

    // securedPrint('status------${status}');
    if (ordersData.sellerId != ordersData.loggedInUser) {
      securedPrint('status------${status}');
      print('status------${status}');
      // int len = appealHistory!.result!
      //     .where((element) => element.status == 'active')
      //     .length;
      if (status == 'completed') {
        timer?.cancel();
        appealTimer?.cancel();
        Navigator.pop(
          NavigationService.navigatorKey.currentContext!,
        );
        moveToOrderDetailsView(
            NavigationService.navigatorKey.currentContext!,
            '${userOrdersModel?.result?.data?[0].id}',
            userId,
            userOrdersModel?.result?.data?[0].advertisementId,
            userOrdersModel?.result?.data?[0].paymentMethod?.paymentMethodName,
            'creationView');
      } else if (status == 'appeal') {
        fetchAppealHistory(
          orderId,
          true,
          side,
        );
      } else if (status == 'paid') {
        appealTimer?.cancel();
        // if (appealId == userOrdersModel?.result?.data?[0].loggedInUser || side == 'buy') {
        //
        // } else {
        //   Navigator.of(NavigationService.navigatorKey.currentContext!).pop();
        // }
        DateTime? modifiedDate =
            userOrdersModel?.result?.data?.first.modifiedDate!;
        securedPrint("modii$modifiedDate");
        String status = userOrdersModel?.result?.data?.first.status ?? '';
        DateTime current = (DateTime.now());
        if (timeLimitForOrder == 1) timeLimitForOrder = 60;
        modifiedDate = modifiedDate?.add(Duration(
            minutes: (status == 'appeal') ? 10 : timeLimitForOrder!.toInt()));
        int? difference = modifiedDate?.difference(current).inSeconds;
        timer?.cancel();
        setCountDown(difference ?? 0);
        startCountDown(orderCreationModel?.result?.id);

        moveToCryptoReleasingView(
            NavigationService.navigatorKey.currentContext!,
            orderId,
            paymentMethods,
            userOrdersModel);
      } else if (status == 'unpaid') {
        count = 0;
        Navigator.of(NavigationService.navigatorKey.currentContext!)
            .popUntil((_) => count++ >= 4);
        statusValue = '';
        appealTimer?.cancel();
        DateTime? modifiedDate =
            userOrdersModel?.result?.data?.first.modifiedDate!;
        String status = userOrdersModel?.result?.data?.first.status ?? '';
        DateTime current = (DateTime.now());
        if (timeLimitForOrder == 1) timeLimitForOrder = 60;
        modifiedDate = modifiedDate?.add(Duration(
            minutes: (status == 'appeal') ? 10 : timeLimitForOrder!.toInt()));
        int? difference = modifiedDate?.difference(current).inSeconds;
        timer?.cancel();
        setCountDown(difference ?? 0);
        startCountDown(orderCreationModel?.result?.id);
        if (userOrdersModel?.result?.data?[0].status == 'completed') {
          timer?.cancel();
          appealTimer?.cancel();
          moveToOrderDetailsView(
            NavigationService.navigatorKey.currentContext!,
            '${userOrdersModel?.result?.data?[0].id}',
            userId,
            userOrdersModel?.result?.data?[0].advertisementId,
            userOrdersModel?.result?.data?[0].paymentMethod?.paymentMethodName,
          );
        }
      }
    } else {
      if (status == 'paid') {
        DateTime? modifiedDate =
            userOrdersModel?.result?.data?.first.modifiedDate!;
        String status = userOrdersModel?.result?.data?.first.status ?? '';
        DateTime current = (DateTime.now());
        if (timeLimitForOrder == 1) timeLimitForOrder = 60;
        modifiedDate = modifiedDate?.add(Duration(
            minutes: (status == 'appeal') ? 10 : timeLimitForOrder!.toInt()));
        int? difference = modifiedDate?.difference(current).inSeconds;
        timer?.cancel();
        setCountDown(difference ?? 0);
        startCountDown(orderCreationModel?.result?.id);
      } else if (status == 'completed') {
        timer?.cancel();
        appealTimer?.cancel();

        moveToOrderDetailsView(
            NavigationService.navigatorKey.currentContext!,
            '${userOrdersModel?.result?.data?[0].id}',
            userId,
            userOrdersModel?.result?.data?[0].advertisementId,
            userOrdersModel?.result?.data?[0].paymentMethod?.paymentMethodName,
            'sell');
      } else if (status == 'cancelled') {
        timer?.cancel();
        moveToOrderDetailsView(
            NavigationService.navigatorKey.currentContext!,
            '${userOrdersModel?.result?.data?[0].id}',
            userId,
            userOrdersModel?.result?.data?[0].advertisementId,
            userOrdersModel?.result?.data?[0].paymentMethod?.paymentMethodName,
            'sell');
        // Navigator.pop(
        //   NavigationService.navigatorKey.currentContext!,
        // );
      } else if (status == 'appeal') {
        fetchAppealHistory(orderId, true, side);
      } else if (status == 'unpaid') {
        count = 0;
        Navigator.of(NavigationService.navigatorKey.currentContext!)
            .popUntil((_) => count++ >= 2);
        DateTime? modifiedDate =
            userOrdersModel?.result?.data?.first.modifiedDate!;
        String status = userOrdersModel?.result?.data?.first.status ?? '';
        DateTime current = (DateTime.now());
        if (timeLimitForOrder == 1) timeLimitForOrder = 60;
        modifiedDate = modifiedDate?.add(Duration(
            minutes: (status == 'appeal') ? 10 : timeLimitForOrder!.toInt()));
        int? difference = modifiedDate?.difference(current).inSeconds;
        timer?.cancel();
        setCountDown(difference ?? 0);
        startCountDown(orderCreationModel?.result?.id);
      }
    }
    notifyListeners();
  }

  fetchOrderCreation(
      String adId,
      String side,
      String fiat,
      String crypto,
      double price,
      double amount,
      double total,
      String? paymentMethodName,
      int? timeLimit,
      [String? paymentId]) async {
    Map<String, dynamic> mutateUserParams = side == 'buy'
        ? {
            "data": {
              "advertisement_id": adId,
              "trade_type": side,
              "from_asset": fiat,
              "to_asset": crypto,
              "price": price,
              "amount": amount,
              "total": total
            }
          }
        : {
            "data": {
              "advertisement_id": adId,
              "trade_type": side,
              "from_asset": fiat,
              "to_asset": crypto,
              "price": price,
              "amount": amount,
              "total": total,
              "payment_method": {
                "payment_method_id": paymentId,
                "payment_method_name": paymentMethodName
              }
            }
          };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchOrderCreation(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getOrderCreation(
            decodeResponse.data,
            adId,
            side,
            timeLimit,
            paymentMethodName,
          );
          setButtonLoader(false);
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

  getOrderCreation(OrderCreationModel? orderCreation, String adId, String side,
      int? timeLimit,
      [String? paymentMethodName]) {
    timeLimitForOrder = timeLimit;
    this.orderCreationModel = orderCreation;
    UserOrdersModel tempUserOrdersModel = UserOrdersModel(
        result: UserOrders(data: [
      OrdersData(
          id: orderCreationModel?.result?.id,
          price: orderCreationModel?.result?.price,
          amount: orderCreationModel?.result?.amount,
          fromAsset: orderCreationModel?.result?.fromAsset,
          toAsset: orderCreationModel?.result?.toAsset,
          total: orderCreationModel?.result?.total,
          createdDate: orderCreationModel?.result?.createdDate,
          modifiedDate: orderCreationModel?.result?.modifiedDate)
    ]));
    this.userOrdersModel = tempUserOrdersModel;
    if (orderCreationModel?.statusCode == 200) {
      if (side == 'buy') {
        moveToOrderCreatedView(
          NavigationService.navigatorKey.currentContext!,
          orderCreationModel?.result?.id ?? "",
          adId,
          timeLimit,
          paymentMethodName,
        );
        //fetchAppealHistory();
        getOrderLocalSocket(orderCreationModel?.result?.id, side);
        UserOrdersModel tempUserOrdersModel = UserOrdersModel(
            result: UserOrders(data: [
          OrdersData(
              id: orderCreationModel?.result?.id,
              price: orderCreationModel?.result?.price,
              amount: orderCreationModel?.result?.amount,
              fromAsset: orderCreationModel?.result?.fromAsset,
              toAsset: orderCreationModel?.result?.toAsset,
              total: orderCreationModel?.result?.total,
              createdDate: orderCreationModel?.result?.createdDate,
              modifiedDate: orderCreationModel?.result?.modifiedDate)
        ]));
        this.userOrdersModel = tempUserOrdersModel;
        DateTime? modifiedDate =
            userOrdersModel?.result?.data?.first.modifiedDate!;
        String status = userOrdersModel?.result?.data?.first.status ?? '';
        if (status == 'appeal') {
          DateTime current = (DateTime.now());
          if (timeLimit == 1) timeLimit = 60;
          modifiedDate = modifiedDate?.add(Duration(minutes: 10));
          int? difference = modifiedDate?.difference(current).inSeconds;
          appealTimer?.cancel();
          setAppealCountDown(difference ?? 0);
          startAppealCountDown(orderCreationModel?.result?.id);
        } else {
          DateTime current = (DateTime.now());
          if (timeLimit == 1) timeLimit = 60;
          modifiedDate =
              modifiedDate?.add(Duration(minutes: timeLimit!.toInt()));
          int? difference = modifiedDate?.difference(current).inSeconds;
          timer?.cancel();
          setCountDown(difference ?? 0);
          startCountDown(orderCreationModel?.result?.id);
        }
      } else {
        moveToWaitingPaymentView(NavigationService.navigatorKey.currentContext!,
            adId, '${orderCreation?.result?.id}', paymentMethodName, timeLimit);
        getOrderLocalSocket(orderCreationModel?.result?.id, side);
        DateTime? modifiedDate =
            userOrdersModel?.result?.data?.first.modifiedDate!;
        String status = userOrdersModel?.result?.data?.first.status ?? '';
        DateTime current = (DateTime.now());
        if (timeLimit == 1) timeLimit = 60;
        modifiedDate = modifiedDate?.add(
            Duration(minutes: (status == 'appeal') ? 10 : timeLimit!.toInt()));
        int? difference = modifiedDate?.difference(current).inSeconds;
        timer?.cancel();
        setCountDown(difference ?? 0);
        startCountDown(orderCreationModel?.result?.id);
      }
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          '${orderCreationModel?.statusMessage}', SnackbarType.negative);
    }
    notifyListeners();
  }

  formatedTime({required int time}) {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  setStatus(String value) {
    statusValue = value;
    notifyListeners();
  }

  startCountDown(String? id) {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDown <= 0) {
          timer.cancel();
          notifyListeners();
        } else {
          countDown--;
          notifyListeners();
        }
      },
    );
  }

  startAppealCountDown(String? id) {
    const oneSec = Duration(seconds: 1);
    appealTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (appealCountDown <= 0) {
          timer.cancel();
          if (appealCountDown == 0) {
            //Navigator.pop(NavigationService.navigatorKey.currentContext!);
            moveToAppealPendingView(
                NavigationService.navigatorKey.currentContext!,
                userOrdersModel?.result?.data?.first ?? OrdersData());
          }
          notifyListeners();
        } else {
          appealCountDown--;
          notifyListeners();
        }
      },
    );
  }

  fetchAdvertisement(String side, String crypto, String fiat,
      VoidCallback updateAd, String? payment, String? amount,
      [int page = 0]) async {
    Map<String, dynamic> queryData = {
      "advertisement_type": side,
      "from_asset": crypto,
      "to_asset": fiat
    };

    if (amount != null && payment != null) {
      queryData = {
        "advertisement_type": side,
        "from_asset": crypto,
        "payment_method": payment,
        "amount": double.parse(amount ?? "0.0"),
        "to_asset": fiat
      };
    } else if (amount != null) {
      queryData = {
        "advertisement_type": side,
        "from_asset": crypto,
        "amount": double.parse(amount ?? "0.0"),
        "to_asset": fiat
      };
    } else if (payment != null) {
      queryData = {
        "advertisement_type": side,
        "from_asset": crypto,
        "payment_method": payment,
        "to_asset": fiat
      };
    }

    Map<String, dynamic> mutateUserParams = {
      "fetchAdvertisementData": {
        "queryData": queryData,
        "sort": {"price": side == stringVariables.buy ? -1 : 1},
        "skip": page,
        "limit": 10
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchAdvertisement(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getAdvertisement(decodeResponse.data?.result, updateAd);
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

  getAdvertisement(P2PAdvertisement? p2pAdvertisement, VoidCallback updateAd) {
    this.p2pAdvertisement = p2pAdvertisement;
    updateAd();
    notifyListeners();
  }

  /// fetch payment details
  fetchPaymentMethods(String? loggedInUser, String banktype, String adId,
      [String? seller_id]) async {
    Map<String, dynamic> mutateUserParams = {
      "UserPaymentDetails": {"type": banktype, "user_id": loggedInUser}
    };
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
          getPaymentMethods(decodeResponse.data?.result, adId, seller_id);
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

  getPaymentMethods(List<UserPaymentDetails>? paymentMethods, String adId,
      [String? seller_id]) {
    this.paymentMethods = paymentMethods;
    fetchUserAdvertisemets(adId, seller_id);
    notifyListeners();
  }

  /// fetch user order details
  fetchOrderDetails(String id, String banktype, String adId,
      [bool isChatFlow = false]) async {
    orderId = id;
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
          getUserOrderDetails(decodeResponse.data, banktype, adId, isChatFlow);
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

  getUserOrderDetails(
      UserOrdersModel? userOrderDetail, String banktype, String adId,
      [bool isChatFlow = false]) {
    this.userOrdersModel = userOrderDetail;
    if (userOrdersModel?.statusCode != 200) {
      CustomSnackBar().showSnakbar(
          NavigationService.navigatorKey.currentContext!,
          "${userOrdersModel?.statusMessage}",
          SnackbarType.negative);
    } else {
      OrdersData ordersData =
          userOrdersModel?.result?.data?.first ?? OrdersData();
      seller_id = userOrdersModel?.result?.data?.first.sellerId ?? "";
      if (ordersData.sellerId == ordersData.loggedInUser) {
        id = ordersData.buyerId ?? "";
        userId = ordersData.sellerId ?? "";
      } else {
        id = ordersData.sellerId ?? "";
        userId = ordersData.buyerId ?? "";
      }

      if (!isChatFlow)
        fetchPaymentMethods(
          id,
          banktype,
          adId,
          seller_id,
        );
      else
        setLoading(false);
    }
  }

  fetchUserAdvertisemets(String adId, [String? seller_id]) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "queryData": {"ad_id": adId, "user_id": seller_id}
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchUserAdvertisements(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserAdvertisement(decodeResponse.data?.result?.data);
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

  getUserAdvertisement(List<Advertisement>? data) {
    this.advertisement = data;
    bankNames.clear();
    if (advertisement?.length != 0) {
      advertisement?.first.paymentMethod?.forEach((element) {
        bankNames.add(element.paymentMethodName ?? "");
      });
    }
    fetchFeedback();
  }

  fetchFeedback() async {
    Map<String, dynamic> mutateUserParams = {
      "fetchFeedbackData": {
        "queryData": {"order_id": orderId, "user_id": userId}
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchFeedback(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setFeedback(
            decodeResponse.data?.result,
          );
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

  setFeedback(P2PFeedback? result) {
    p2pFeedback = result;
    if (result == null) {
      setIsRated(null);
      cmtController.clear();
    } else {
      List<FeedbackData>? list =
          result?.data?.where((element) => element.userId == userId).toList();
      if (list != null && list.isNotEmpty) {
        FeedbackData feedbackData =
            result?.data?.where((element) => element.userId == userId).first ??
                FeedbackData();
        setIsRated(feedbackData.feedbackType ==
            stringVariables.positive.toLowerCase());
        cmtController.text = feedbackData.feedback ?? "";
      } else {
        setIsRated(null);
        cmtController.clear();
      }
    }
    setLoading(false);
    notifyListeners();
  }

  cancelOrder(String id, [int? reason, String? description]) async {
    Map<String, dynamic> queryData = {"id": id};
    if (description != null) queryData["description"] = description;
    if (reason != null) queryData["reason"] = reason;
    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.cancelP2POrder(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getCancelOrderDetails(decodeResponse.data);
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

  getCancelOrderDetails(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    if (commonModel?.statusCode == 200) {
      // count = 0;
      // Navigator.of(NavigationService.navigatorKey.currentContext!)
      //     .popUntil((_) => count++ >= 3);
      moveToOrderDetailsView(
          NavigationService.navigatorKey.currentContext!,
          '${userOrdersModel?.result?.data?[0].id}',
          userId,
          userOrdersModel?.result?.data?[0].advertisementId,
          userOrdersModel?.result?.data?[0].paymentMethod?.paymentMethodName,
          "creationView");
      timer?.cancel();
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.positive);
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
  }

  addFeedback() async {
    Map<String, dynamic> queryData = {
      "order_id": orderId,
      "feedback_type": (isRated ?? false)
          ? stringVariables.positive.toLowerCase()
          : stringVariables.negative.toLowerCase(),
    };
    if (cmtController.text.isNotEmpty)
      queryData["feedback"] = cmtController.text;
    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.addFeedback(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setAddFeedback(decodeResponse.data);
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

  setAddFeedback(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    if (commonModel?.statusCode == 200) {
      setLoading(true);
      fetchFeedback();
      moveToFeedbackView(NavigationService.navigatorKey.currentContext!);
    } else {
      if (p2pFeedback != null) {
        FeedbackData feedbackData = p2pFeedback?.data
                ?.where((element) => element.userId == userId)
                .first ??
            FeedbackData();
        setIsRated(feedbackData.feedbackType ==
            stringVariables.positive.toLowerCase());
      }
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
    notifyListeners();
  }

  setEditFeedback(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200)
      fetchFeedback();
    else {
      if (p2pFeedback != null) {
        FeedbackData feedbackData = p2pFeedback?.data
                ?.where((element) => element.userId == userId)
                .first ??
            FeedbackData();
        setIsRated(feedbackData.feedbackType ==
            stringVariables.positive.toLowerCase());
      }
    }
    notifyListeners();
  }

  editFeedback([int type = 0]) async {
    Map<String, dynamic> queryData = {
      "order_id": orderId,
      "feedback_type": (isRated ?? false)
          ? stringVariables.positive.toLowerCase()
          : stringVariables.negative.toLowerCase(),
    };
    if (cmtController.text.isNotEmpty)
      queryData["feedback"] = cmtController.text;
    Map<String, dynamic> mutateUserParams = {"data": queryData};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.editFeedback(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          if (type == 0)
            setEditFeedback(decodeResponse.data);
          else
            setAddFeedback(decodeResponse.data);
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

  /// Release crypto
  releaseCrypto(
    String id,
    String? user_id,
    String? adid,
    String? paymentMethodName,
  ) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"id": id, "cryptoReleaseTime": 0}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.ReleaseCrypto(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getReleaseCrypto(
              decodeResponse.data, id, user_id, adid, paymentMethodName);
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

  getReleaseCrypto(CommonModel? commonModel, String id, String? user_id,
      String? adid, String? paymentMethodName) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    if (commonModel?.statusCode == 200) {
      setReceivedPayment(ReceivedPayment.reason1);
      // moveToOrderDetailsView(NavigationService.navigatorKey.currentContext!, id,
      //     user_id, adid, paymentMethodName);
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
  }

  ///fiatTransferred
  fiatTransferred(
    String name,
    String paymentMethodId,
    String order_id,
    List<UserPaymentDetails>? paymentMethods,
    UserOrdersModel? userOrdersModel,
  ) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "id": order_id,
        "payment_method": {
          "payment_method_id": paymentMethodId,
          "payment_method_name": name
        },
        "payment_time": 0
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fiatTransferred(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getFiatTransferredDetails(
              decodeResponse.data, order_id, paymentMethods, userOrdersModel);
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

  getFiatTransferredDetails(
      CommonModel? commonModel,
      String order_id,
      List<UserPaymentDetails>? paymentMethods,
      UserOrdersModel? userOrdersModel) {
    // getOrderLocalSocket(order_id, 'buy');
    // if (commonModel?.statusCode == 200) {
    //   moveToCryptoReleasingView(
    //       NavigationService.navigatorKey.currentContext!,
    //       orderId,
    //       paymentMethods,
    //       userOrdersModel);
    // } else {
    //   customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
    //       commonModel?.statusMessage ?? "", SnackbarType.negative);
    // }
  }

  fetchMessageHistory(String id, [bool updateOrder = true]) async {
    Map<String, dynamic> mutateUserParams = {
      "fetchMessageHistoryData": {"order_id": id}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchMessageHistory(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setMessageHistory(response.result ?? [], id, updateOrder);
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

  setMessageHistory(List<MessageHistory> result, String id, bool updateOrder) {
    messageHistory = result;
    if (updateOrder) fetchOrderDetails(id, "", "", true);
    notifyListeners();
  }

  createMessage(String id, String msg, [String? image]) async {
    Map<String, dynamic> data = {};
    if (msg.isNotEmpty) data["text"] = msg;
    if (image != null) data["image"] = image;
    Map<String, dynamic> mutateUserParams = {
      "data": {"order_id": id, "message": data}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.createMessage(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCreateMessage(response, id);
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

  setCreateMessage(CommonModel? commonModel, String id) {
    if (messageHistory.first.image == imageChatEncoded) {
      messageHistory.first.sending = false;
    }
    if (commonModel?.statusCode != 200) {
      if (messageHistory.first.image == imageChatEncoded) {
        messageHistory.first.sendingFailed = true;
      }
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .removeCurrentSnackBar();
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
    notifyListeners();
  }

  reportUser(String id, String email, String desc) async {
    List<Map<String, dynamic>> imageList = [];
    imageReportEncoded.forEach((element) {
      Map<String, dynamic> image = {};
      image["proof_url"] = element;
      imageList.add(image);
    });
    Map<String, dynamic> mutateUserParams = {
      "data": {
        "order_id": id,
        "reporter_email": email,
        "reason_for_report": reportReason,
        "description": desc,
        "proof": imageList
      }
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.reportUser(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setReportUserDetails(decodeResponse.data);
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

  setReportUserDetails(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    if (commonModel?.statusCode == 200) {
      Navigator.pop(NavigationService.navigatorKey.currentContext!);
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.positive);
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
    setButtonLoader(false);
  }

  appealCreation(String description, isProvide, String side) async {
    List<Map<String, dynamic>> imageList = [];
    imageReportEncoded.forEach((element) {
      Map<String, dynamic> image = {};
      image["proof_url"] = element;
      imageList.add(image);
    });
    Map<String, dynamic> mutateUserParams = isProvide == true
        ? {
            "appealCreationInput": {
              "order_id": orderId,
              "description": description,
              "proof": imageList
            }
          }
        : {
            "appealCreationInput": {
              "order_id": orderId,
              "description": description,
              "reason_for_appeal": "Payment not received",
              "proof": imageList
            }
          };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.appealCreate(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setAppealCreation(decodeResponse.data, isProvide, side);
          setButtonLoader(false);
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

  setAppealCreation(CommonModel? commonModel, isProvide, String side) {
    if (commonModel?.statusCode == 200) {
      // if (isProvide == true) {
      // Navigator.pop(NavigationService.navigatorKey.currentContext!);
      //fetchAppealHistory(orderId, true, side);

      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          '${commonModel?.statusMessage}', SnackbarType.positive);
      //  }
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          '${commonModel?.statusMessage}', SnackbarType.negative);
    }
  }

  cancelAppeal() async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"order_id": orderId}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.cancelAppeal(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setCancelAppeal(decodeResponse.data);
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

  setCancelAppeal(CommonModel? commonModel) {
    if (commonModel?.statusCode == 200) {
      count = 0;
      appealTimer?.cancel();
      Navigator.of(NavigationService.navigatorKey.currentContext!)
          .popUntil((_) => count++ >= 2);
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          '${commonModel?.statusMessage}', SnackbarType.positive);
    } else {
      customSnackBar.showSnakbar(NavigationService.navigatorKey.currentContext!,
          '${commonModel?.statusMessage}', SnackbarType.negative);
    }
  }

  clearData() {
    p2pFeedback = null;
    orderCreation = null;
    p2pAdvertisement = null;
    isRated = null;
    userOrdersModel = null;
    orderCreationModel = null;
    reason = CancelReason.reason1;
    messageHistory = [];
    chatTime = "";
    imageChat = null;
    imageChatEncoded = null;
    reportReason = 0;
    photoError = false;
    buttonLoader = false;
    imageReport = null;
    imageReportEncoded = [];
    appealHistory = null;
    isProvide = false;
    isNegotiatied = false;
    timeLimitForOrder = 0;
    count = 0;

    appealCountDown = 0;

    countDown = 0;
    noInternet = false;
    needToLoad = false;
    checkAlert = false;
    isPaymentView = false;
    releaseExpandFlag = false;
    completedExpandFlag = false;
    moreExpandFlag = false;
    isRated = true;
    tabIndex = 0;
    quantity = "";
    id = "";
    userId = "";
    orderId = "";
    seller_id = "";
    amount = "";
    orderCreation = null;
    p2pAdvertisement = null;
    advertisement = null;
    reason = CancelReason.reason1;
    receivedPayment = ReceivedPayment.reason1;
    orderCreationModel = null;
    userOrdersModel = null;
    paymentMethods = null;
    bankNames = [];
    selectedFiat = "UPI";
    selectedPayment = "UPI";

    cmtText = "";
    messageHistory = [];
    chatTime = "";
    consenses = false;
    reportReason = 0;
    photoError = false;
    imageReportEncoded = [];
    buttonLoader = false;
    statusValue = '';
    notifyListeners();
  }
}
