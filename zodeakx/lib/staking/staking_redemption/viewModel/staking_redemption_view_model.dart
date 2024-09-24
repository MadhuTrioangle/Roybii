import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/staking/balance/view_model/staking_balance_view_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/CheckInterConnection/checkInternet.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Repositories/ProductRepositories.dart';

class StakingRedemptionViewModel extends ChangeNotifier {
  bool checkAlert = false;
  bool noInternet = false;
  bool needToLoad = true;

  /// Loader
  setLoading(bool loading) async {
    needToLoad = loading;
    notifyListeners();
  }

  setCheckAlert(bool value) async {
    checkAlert = value;
    notifyListeners();
  }

  requestForRedeem(String id) async {
    Map<String, dynamic> mutateUserParams = {
      "data": {"id": id}
    };

    var hasInternet = await checkInternet.hasInternet();
    if (hasInternet) {
      var response = await productRepository.requestForRedeem(mutateUserParams);
      var decodeResponse = HandleResponse.completed(response);
      switch (decodeResponse.status?.index) {
        case 0:
          setLoading(false);
          break;
        case 1:
          setRequestForRedeem(decodeResponse.data);
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

  setRequestForRedeem(CommonModel? commonModel) {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    if (commonModel?.statusCode == 200) {
      moveToRedemptionSuccessful(context);
      StakingBalanceViewModel viewModel =
          Provider.of<StakingBalanceViewModel>(context, listen: false);
      viewModel.getActiveUserStakes(0);
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      customSnackBar.showSnakbar(
          context, commonModel?.statusMessage ?? "", SnackbarType.negative);
    }
    notifyListeners();
  }

  clearData() {
    noInternet = false;
    needToLoad = true;
    checkAlert = false;
  }
}
