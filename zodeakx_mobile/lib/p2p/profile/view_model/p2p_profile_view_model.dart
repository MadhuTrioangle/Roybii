import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/Networking/CommonModel/CommonModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../counter_parties_profile/model/FeedbackDataModel.dart';
import '../../counter_parties_profile/model/UserCenterModel.dart';
import '../model/UserActivityModel.dart';
import '../model/UserPaymentDetailsModel.dart';

class P2PProfileViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool dialogLoader = true;
  bool feedbackLoader = true;
  int tabIndex = 0;
  UserCenter? userCenter;
  List<UserPaymentDetails>? paymentMethods;
  List<UserActivity>? userActivity;
  FeedbackData? feedbackData;
  List<Feedbacks>? positiveFeedbacks;
  List<Feedbacks>? negativeFeedbacks;
  bool dialogValidate = false;

  P2PProfileViewModel() {}

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Loader
  setFeedbackLoading(bool loading) async {
    feedbackLoader = loading;
    notifyListeners();
  }

  /// Loader
  setDialogLoading(bool loading) async {
    dialogLoader = loading;
    notifyListeners();
  }

  setDialogValidate(bool value) async {
    dialogValidate = value;
    notifyListeners();
  }

  /// Tab index
  setTabIndex(int value) async {
    tabIndex = value;
    notifyListeners();
  }

  //API
  findUserCenter() async {
    Map<String, dynamic> mutateUserParams = {"UserCenterDetails": {}};

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.findUserCenter(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserCenter(decodeResponse.data?.result);
          setLoading(false);
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

  getUserCenter(UserCenter? userCenter) {
    this.userCenter = userCenter;
    //  fetchPaymentMethods();
    notifyListeners();
  }

  fetchPaymentMethods() async {
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
          getPaymentMethods(decodeResponse.data?.result);
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

  getPaymentMethods(List<UserPaymentDetails>? paymentMethods) {
    this.paymentMethods = paymentMethods;
    notifyListeners();
  }

  fetchUserActivity() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchUserActivity();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserActivity(decodeResponse.data?.result);
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

  getUserActivity(List<UserActivity>? userActivity) {
    this.userActivity = userActivity;
    setDialogLoading(false);
    notifyListeners();
  }

  fetchFeedbackData(int limit) async {
    Map<String, dynamic> mutateUserParams = {
      "fetchFeedbackData": {"queryData": {}, "limit": limit}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchFeedbackData(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getFeedbackData(decodeResponse.data?.result);
          setFeedbackLoading(false);
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

  getFeedbackData(FeedbackData? feedbackData) {
    this.feedbackData = feedbackData;
    positiveFeedbacks?.clear();
    positiveFeedbacks = feedbackData?.data
        ?.where((element) =>
            element.feedbackType == stringVariables.positive.toLowerCase())
        .toList();
    negativeFeedbacks = feedbackData?.data
        ?.where((element) =>
            element.feedbackType == stringVariables.negative.toLowerCase())
        .toList();
    notifyListeners();
  }

  editUserName(String name) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"name": name}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.editUserName(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getEditUserName(decodeResponse.data);
          setFeedbackLoading(false);
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

  getEditUserName(CommonModel? commonModel) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200) findUserCenter();
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    dialogLoader = true;
    feedbackLoader = true;
    dialogValidate = false;
    tabIndex = 0;
    userCenter = null;
    paymentMethods = null;
    userActivity = null;
    feedbackData = null;
    positiveFeedbacks = null;
    negativeFeedbacks = null;
    notifyListeners();
  }
}
