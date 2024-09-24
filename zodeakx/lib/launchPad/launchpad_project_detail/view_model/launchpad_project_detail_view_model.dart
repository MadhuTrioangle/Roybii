import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/DashBoardScreen/ViewModel/ExchangeRateViewModel.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';
import '../../launch_pad_home_page/model/fetch_projects_model.dart';
import '../model/AvgBalanceModel.dart';
import '../model/ParticipantModel.dart';
import '../model/ProjectCommitedModel.dart';

class LaunchpadProjectDetailViewModel extends ChangeNotifier {
  bool noInternet = false;
  bool needToLoad = true;
  List<Map<String, String>> webLinks = [
    {
      "title": stringVariables.website,
      "logo": launchpadWebsite,
    },
    {
      "title": stringVariables.whitepaper,
      "logo": launchpadWhitepaper,
    },
    {
      "title": stringVariables.gmtResearchReport,
      "logo": launchpadResearchReport,
    },
    {
      "title": stringVariables.viewDetailedRules,
      "logo": launchpadDetailedRules,
    },
    {
      "title": stringVariables.faq,
      "logo": launchpadFaq,
    }
  ];
  int currentStep = 1;
  double exchangeRate = 0;
  FetchProjects? fetchProjects;
  AvgBalance? avgBalance;
  Participant? participant;
  List<ProjectCommited>? projectCommited;
  bool checkAlert = true;
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormFieldState> amountKey = GlobalKey<FormFieldState>();
  Timer? timeLeft;
  late int timeLeftCountDown;
  late String timeLeftDate;
  String day = "00";
  String hour = "00";
  String minute = "00";
  String second = "00";
  var outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setCurrentStep(int value) async {
    currentStep = value;
    notifyListeners();
  }

  Future<void> setActive(bool value) async {
    checkAlert = value;
    notifyListeners(); //  Consumer to rebuild
  }

  setTimeLeftCountDown(int value) async {
    timeLeftCountDown = value;
    notifyListeners();
  }

  setTimeLeftDate(String value) async {
    timeLeftDate = value;
    securedPrint("timeLeftDate${timeLeftDate}");
    notifyListeners();
  }

  startTimeLeft() {
    const oneSec = Duration(seconds: 1);
    timeLeft = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timeLeftCountDown <= 0) {
          timer.cancel();
          notifyListeners();
        } else {
          timeLeftCountDown--;
          prettyDuration(timeLeftDate);
          notifyListeners();
        }
      },
    );
    securedPrint("timeLeft${timeLeft}");
    notifyListeners();
  }

  //API
  fetchProject(String id) async {
    Map<String, dynamic> params = {
      "fetchProjectdata": {
        "queryData": {"_id": id}
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
          setProjectData(decodeResponse.data, id);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      noInternet = true;

    }
    notifyListeners();
  }

  setProjectData(FetchProjects? data, String id) {
    fetchProjects = data;
    String from = fetchProjects?.result?.data?.first.holdingCurrency ?? "";
    String to = fetchProjects?.result?.data?.first.fiatCurrency ?? "";
    String status = fetchProjects?.result?.data?.first.projectStatus ?? "";
    currentStep = getStatus(status);
    setupTimer(status);
    updateUrl();
    getEstimateFiatValue(from, to, id);
    notifyListeners();
  }

  prettyDuration(String toDate) {
    String date = outputFormat.format(DateTime.now());
    Duration duration =
        outputFormat.parse(toDate).difference(outputFormat.parse(date));
    var dy = duration.inDays;
    day = dy.toString();
    var hr = duration.inHours % 24;
    hour = hr.toString().length <= 1 ? "0$hr" : hr.toString();
    var mins = duration.inMinutes % 60;
    minute = mins.toString().length <= 1 ? "0$mins" : mins.toString();
    var seconds = duration.inSeconds % 60;
    second = seconds.toString().length <= 1 ? "0$seconds" : seconds.toString();
    securedPrint("day$day hour$hour minute$minute second$second");
    notifyListeners();
  }

  setupTimer(String status) {
    int step = getTimerStatus(status);
    Duration differnceTime = Duration(days: 0);
    Datum datum = fetchProjects?.result?.data?.first ?? Datum();
    String toDate = "";
    if (step == 1) {
      String holdingCalculationPeriodEnd = getDate(
          (datum.holdCalculationPeriod?.endDate ?? DateTime.now()).toString());
      toDate = holdingCalculationPeriodEnd;
      String date = outputFormat.format(DateTime.now());
      differnceTime = outputFormat
          .parse(holdingCalculationPeriodEnd)
          .difference(outputFormat.parse(date));
    } else if (step == 2) {
      String subscriptionPeriodEnd = getDate(
          (datum.subscriptionPeriod?.endDate ?? DateTime.now()).toString());
      toDate = subscriptionPeriodEnd;
      String date = outputFormat.format(DateTime.now());
      differnceTime = outputFormat
          .parse(subscriptionPeriodEnd)
          .difference(outputFormat.parse(date));
    } else if (step == 3) {
      String allocationPeriodEnd = getDate(
          (datum.allocationPeriod?.endDate ?? DateTime.now()).toString());
      toDate = allocationPeriodEnd;
      String date = outputFormat.format(DateTime.now());
      differnceTime = outputFormat
          .parse(allocationPeriodEnd)
          .difference(outputFormat.parse(date));
    } else {
      day = "00";
      hour = "00";
      minute = "00";
      second = "00";
      return;
    }
    setTimeLeftCountDown(differnceTime.inSeconds);
    setTimeLeftDate(toDate);
    startTimeLeft();
    notifyListeners();
  }

  updateUrl() {
    webLinks.forEach((element) {
      if (element["title"] == stringVariables.website) {
        element["url"] =
            fetchProjects?.result?.data?.first.tokenLink?.websiteLink ?? "";
      } else if (element["title"] == stringVariables.whitepaper) {
        element["url"] =
            fetchProjects?.result?.data?.first.tokenLink?.whitePaperLink ?? "";
      } else if (element["title"] == stringVariables.gmtResearchReport) {
        element["url"] =
            fetchProjects?.result?.data?.first.tokenLink?.researchReportLink ??
                "";
      } else if (element["title"] == stringVariables.viewDetailedRules) {
        element["url"] = constant.launchpadAnnuncement +
            (fetchProjects?.result?.data?.first.id ?? "");
      } else if (element["title"] == stringVariables.faq) {
        element["url"] = constant.launchpadFaq;
      }
    });
    notifyListeners();
  }

  getEstimateFiatValue(String from, String to, String id) async {
    Map<String, dynamic> params = {
      "data": {
        "from_currency": from,
        "to_currency": to,
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchExchangeRate(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setEstimateFiatValue(decodeResponse?.data?.result, id);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;

    }
    notifyListeners();
  }

  setEstimateFiatValue(GetExchangeResult? result, String id) {
    exchangeRate = result?.exchangeRate ?? 0;
    if (constant.userLoginStatus.value) {
      String status = fetchProjects?.result?.data?.first.projectStatus ?? "";
      if (getStatus(status) == 4) {
        fetchParticipantData(id, getStatus(status));
      } else {
        fetchAvgBalance(id);
      }
    } else {
      setLoading(false);
    }
    notifyListeners();
  }

  fetchAvgBalance(String id) async {
    Map<String, dynamic> params = {
      "data": {"project_id": id}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchAvgBalance(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setAvgBalance(decodeResponse?.data?.result, id);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;

    }
    notifyListeners();
  }

  setAvgBalance(AvgBalance? result, String id) {
    avgBalance = result;
    String status = fetchProjects?.result?.data?.first.projectStatus ?? "";
    if (getStatus(status) == 1) {
      setLoading(false);
    } else {
      if (getStatus(status) == 3) {
        fetchProjectCommitedData(id);
      } else {
        fetchParticipantData(id, getStatus(status));
      }
    }
    notifyListeners();
  }

  fetchParticipantData(String id, int status) async {
    Map<String, dynamic> params = {
      "data": {"project_id": id}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchParticipantData(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setParticipantData(decodeResponse?.data?.result, id, status);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;

    }
    notifyListeners();
  }

  setParticipantData(Participant? result, String id, int status) {
    participant = result;
    fetchProjectCommitedData(id);
    notifyListeners();
  }

  fetchProjectCommitedData(String id) async {
    Map<String, dynamic> params = {
      "data": {"project_id": id}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchProjectCommitedData(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setProjectCommitedData(decodeResponse?.data?.result);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;

    }
    notifyListeners();
  }

  setProjectCommitedData(List<ProjectCommited>? result) {
    projectCommited = result;
    setLoading(false);
    notifyListeners();
  }

  subscribeProject(String id) async {
    Map<String, dynamic> params = {
      "data": {
        "project_id": id,
        "commit_amount": double.parse(amountController.text)
      }
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.subscribeProject(params);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setSubscribeProject(decodeResponse.data, id);
          break;
        default:
          setLoading(false);
          break;
      }
    } else {
      setLoading(true);
      noInternet = true;

    }
    notifyListeners();
  }

  setSubscribeProject(CommonModel? commonModel, String projectId) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
        .removeCurrentSnackBar();
    customSnackBar.showSnakbar(
        NavigationService.navigatorKey.currentContext!,
        commonModel?.statusMessage ?? "",
        commonModel?.statusCode == 200
            ? SnackbarType.positive
            : SnackbarType.negative);
    if (commonModel?.statusCode == 200) {
      timeLeft?.cancel();
      fetchProject(projectId);
    }
    notifyListeners();
  }

  int getStatus(String text) {
    int status = 1;
    if (text == 'holding' || text == 'active') {
      status = 1;
    } else if (text == 'subscription') {
      status = 2;
    } else if (text == 'allocation') {
      status = 3;
    } else {
      status = 4;
    }
    return status;
  }

  int getTimerStatus(String text) {
    int status = 1;
    if (text == 'holding') {
      status = 1;
    } else if (text == 'subscription') {
      status = 2;
    } else if (text == 'allocation') {
      status = 3;
    } else {
      status = 4;
    }
    return status;

  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    currentStep = 1;
    exchangeRate = 0;
    fetchProjects = null;
    avgBalance = null;
    participant = null;
    projectCommited = null;
    checkAlert = true;
  }
}
