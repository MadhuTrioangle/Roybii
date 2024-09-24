import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';

import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../home/model/p2p_advertisement.dart';
import '../model/FeedbackDataModel.dart';
import '../model/UserCenterModel.dart';

class P2PCounterProfileViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool adsTabLoader = true;
  bool feedbackLoader = true;
  int tabIndex = 0;
  UserCenter? userCenter;
  P2PAdvertisement? buyAdvertisement;
  P2PAdvertisement? sellAdvertisement;
  FeedbackData? feedbackData;
  List<Feedbacks>? positiveFeedbacks;
  List<Feedbacks>? negativeFeedbacks;

  P2PCounterProfileViewModel() {}

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// Loader
  setAdsLoading(bool loading) async {
    adsTabLoader = loading;
    notifyListeners();
  }

  /// Loader
  setFeedbackLoading(bool loading) async {
    feedbackLoader = loading;
    notifyListeners();
  }

  /// Tab index
  setTabIndex(int value) async {
    tabIndex = value;
    notifyListeners();
  }

  //API
  findUserCenter(String userId) async {
    Map<String, dynamic> mutateUserParams = {
      "UserCenterDetails": {"user_id": userId}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.findUserCenter(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          getUserCenter(decodeResponse.data?.result, userId);
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

  getUserCenter(UserCenter? userCenter, String userId) {
    this.userCenter = userCenter;
    fetchUserBuyAdvertisement(userId);
    notifyListeners();
  }

  fetchUserBuyAdvertisement(String userId, [int page = 0]) async {
    Map<String, dynamic> mutateUserParams = {
      "userAdvertisementData": {
        "queryData": {
          "user_id": userId,
          "advertisement_type": "sell",
          "trade_status": "published"
        },
        "skip": page,
        "limit": 5
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
          getUserBuyAdvertisement(decodeResponse.data?.result, userId, page);
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

  getUserBuyAdvertisement(
      P2PAdvertisement? p2pAdvertisement, String userId, int page) {
    if (buyAdvertisement == null || page == 0)
      this.buyAdvertisement = p2pAdvertisement;
    else
      this.buyAdvertisement?.data?.addAll((p2pAdvertisement?.data ?? []));
    if (page == 0) fetchUserSellAdvertisement(userId);
    notifyListeners();
  }

  fetchUserSellAdvertisement(String userId, [int page = 0]) async {
    Map<String, dynamic> mutateUserParams = {
      "userAdvertisementData": {
        "queryData": {
          "user_id": userId,
          "advertisement_type": "buy",
          "trade_status": "published"
        },
        "skip": page,
        "limit": 5
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
          getUserSellAdvertisement(decodeResponse.data?.result, userId, page);
          setAdsLoading(false);
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

  getUserSellAdvertisement(
      P2PAdvertisement? p2pAdvertisement, String userId, int page) {
    if (sellAdvertisement == null || page == 0)
      this.sellAdvertisement = p2pAdvertisement;
    else
      this.sellAdvertisement?.data?.addAll((p2pAdvertisement?.data ?? []));
    if (page == 0) fetchFeedbackData(userId);
    notifyListeners();
  }

  fetchFeedbackData(String userId) async {
    Map<String, dynamic> mutateUserParams = {
      "fetchFeedbackData": {
        "queryData": {"user_id": userId},
        "limit": (userCenter?.positive ?? 0) + (userCenter?.negative ?? 0)
      }
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

  clearData() {
    noInternet = false;
    needToLoad = true;
    adsTabLoader = true;
    feedbackLoader = true;
    tabIndex = 0;
    userCenter = null;
    buyAdvertisement = null;
    sellAdvertisement = null;
    feedbackData = null;
    positiveFeedbacks = null;
    negativeFeedbacks = null;
    notifyListeners();
  }
}
