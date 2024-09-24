import 'package:flutter/cupertino.dart';
import 'package:zodeakx_mobile/launchPad/launchpad_history/model/LaunchpadHistoryModel.dart';
import 'package:zodeakx_mobile/launchPad/launchpad_history/model/UserVoteEarnModel.dart';
import 'package:zodeakx_mobile/launchPad/launchpad_history/model/UserVoteModel.dart';

import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';

class LaunchpadHistoryViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  bool tabLoading = false;
  int tabIndex = 0;
  List<String> tabs = [
    stringVariables.launchPad,
    stringVariables.voting,
    stringVariables.airdrop,
  ];
  List<LaunchpadHistory> launchpadHistory = [];
  UserVote? userVote;
  UserVoteEarn? userVoteEarn;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setTabLoading(bool loading) async {
    tabLoading = loading;
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

  //API
  fetchLaunchpadHistory() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchLaunchpadHistory();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setLaunchpadHistory(decodeResponse.data?.result);
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

  setLaunchpadHistory(List<LaunchpadHistory>? list) {
    launchpadHistory = list ?? [];
    setTabLoading(false);
    setLoading(false);
    notifyListeners();
  }

  fetchVotingHistory(int page) async {
    Map<String, dynamic> params = {
      "data": {"skip": page, "limit": 5}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getUserVotes(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setVotingHistory(decodeResponse.data?.result, page);
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

  setVotingHistory(UserVote? result, int page) {
    if (userVote == null || page == 0) {
      userVote = result;
    } else {
      userVote?.data?.addAll(result?.data ?? []);
      userVote?.count?.first.total = result?.count?.first.total;
      userVote?.count?.first.page = result?.count?.first.page;
    }
    setTabLoading(false);
    setLoading(false);
    notifyListeners();
  }

  fetchAirdropHistory(int page) async {
    Map<String, dynamic> params = {
      "data": {"skip": page, "limit": 5, "searchData": {}}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getUserVotesEarn(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setAirdropHistory(decodeResponse.data?.result, page);
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

  setAirdropHistory(UserVoteEarn? result, int page) {
    if (userVoteEarn == null || page == 0) {
      userVoteEarn = result;
    } else {
      userVoteEarn?.data?.addAll(result?.data ?? []);
      userVoteEarn?.total = result?.total;
      userVoteEarn?.page = result?.page;
    }
    setTabLoading(false);
    setLoading(false);
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    tabIndex = 0;
    launchpadHistory = [];
    userVote = null;
    userVoteEarn = null;
  }
}
