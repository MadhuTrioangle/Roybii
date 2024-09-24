import 'package:flutter/cupertino.dart';

import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../Repositories/ProductRepositories.dart';
import '../Model/ReferralLinksModel.dart';
import '../Model/ReferralModel.dart';

class ReferralViewModel extends ChangeNotifier {
  ReferralViewModel? viewModel;
  bool noInternet = false;
  bool needToLoad = true;
  ListofReferral? referralDashBoard;
  List<Result>? UserReferralId;
  CommonModel? commonModel;
  String? total = '';

  var copied = false;
  var copiedLink = false;

  setcopied(bool value) async{
    copied = value;
    notifyListeners();
  }

  setcopiedLink(bool valueLink) async{
    copiedLink = valueLink;
    notifyListeners();
  }

  /// initilizing API
  ReferralViewModel() {
    //GenerateReferralLink();
  }

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  /// set DashBoard List
  setReferralDashboardLists(ListofReferral? referralLists) {
    referralDashBoard = referralLists;
    notifyListeners();
  }

  /// set referral Id
  setReferralId(List<Result>? result) {
    UserReferralId = result;
    notifyListeners();
  }

  removeListner() {
    this.dispose();
  }

  /// set Generate Referral Link
  setGenerateReferralLink(CommonModel? result) {
    commonModel = result;
    notifyListeners();
  }

  /// Get ReferralListDashboard

  getReferralDashboardLists() async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"timing": "all"}
    };
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.fetchReferralList(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setReferralDashboardLists(decodeResponse.data?.result);
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

  ///get ReferralID
  getReferralId() async {
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.fetchReferralId();
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          var match = decodeResponse.data?.result
              ?.where((m) => m.resultDefault == true)
              .toList();
          total = match?.first.referralId;
          decodeResponse.data?.statusCode == 200
              ? getReferralDashboardLists()
              : null;
          setReferralId(decodeResponse.data?.result);
          setLoading(true);
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

  ///Get GenerateReferralLink
  GenerateReferralLink() async {
    Map<String, dynamic> mutateUserParams = {"data": {}};
    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response =
          await productRepository.generateReferralId(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          (decodeResponse.data?.statusCode == 200 ||
                  decodeResponse.data?.statusCode == 400)
              ? getReferralId()
              : null;
          setGenerateReferralLink(decodeResponse.data as CommonModel);
          setLoading(true);
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
}
