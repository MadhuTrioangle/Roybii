import 'package:flutter/cupertino.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/launchPad/launch_pad_home_page/model/banner_data_model.dart';
import 'package:zodeakx_mobile/launchPad/launch_pad_home_page/model/fetch_projects_model.dart';
import 'package:zodeakx_mobile/launchPad/launch_pad_home_page/model/project_commitedData_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';

class LaunchPadHomePageViewModel extends ChangeNotifier {
  num? currentFundLocked = 0;
  num? totalFundsRaised = 0;
  int? projectsLaunched = 0;
  int? uniQueParticipants = 0;
  bool needToLoad = true;
  bool noInternet = false;
  FetchBannerData? fetchBannerDatas;
  FetchProjects? fetchProjects;
  FetchProjectCommitedData? fetchProjectCommitedDatas;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  fetchBannerData() async {
    String? fiatCurrency =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';
    Map<String, dynamic> params = {
      "data": {"user_preferred_currency": fiatCurrency}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getBannerData(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setBannerData(
            decodeResponse.data,
          );
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  setBannerData(FetchBannerData? data) {
    fetchBannerDatas = data;
    if (fetchBannerDatas?.statusCode == 200) {
      totalFundsRaised = fetchBannerDatas?.result?.fundRaised;
      projectsLaunched = fetchBannerDatas?.result?.noOfProjects;
      uniQueParticipants = fetchBannerDatas?.result?.totalParticipants;
      currentFundLocked = fetchBannerDatas?.result?.totalCommitted;
      fetchProject(0);
    } else {
      CustomSnackBar().showSnakbar(
          NavigationService.navigatorKey.currentContext!,
          '${fetchBannerDatas?.statusMessage}',
          SnackbarType.negative);
    }

    notifyListeners();
  }

  fetchProject(int limit) async {
    Map<String, dynamic> params = {
      "fetchProjectdata": {
        "queryData": {
          "project_status": [
            "holding",
            "subscription",
            "allocation",
            "completed",
            "active"
          ]
        },
        "limit": 3,
        "skip": limit,
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.getProjectData(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setProjectData(decodeResponse.data, limit);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  setProjectData(FetchProjects? data, int limit) {

    if (data?.statusCode == 200) {
      if (limit == 0) {
        fetchProjects = data;
      } else {
        fetchProjects?.result?.data?.addAll(data?.result?.data ?? []);
        fetchProjects?.result?.page = data?.result?.page;
       fetchProjects?.result?.total = data?.result?.total;
      }
    }
    fetchProjectCommitedData();
    setLoading(false);
    notifyListeners();
  }

  fetchProjectCommitedData() async {
    Map<String, dynamic> params = {"data": {}};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.ProjectCommitedData(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setProjectCommitedData(
            decodeResponse.data,
          );
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;
      notifyListeners();
    }
  }

  setProjectCommitedData(FetchProjectCommitedData? data) {
    fetchProjectCommitedDatas = data;
    notifyListeners();
  }
}
