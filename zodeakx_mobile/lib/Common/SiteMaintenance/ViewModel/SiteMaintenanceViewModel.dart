import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/Networking/GraphQL/Exception/HandleResponse.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../ZodeakX/CurrencyPreferenceScreen/ViewModel/CurrencyPreferenceViewModel.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../Common/ViewModel/common_view_model.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import '../../LoginScreen/ViewModel/LoginViewModel.dart';
import '../../SplashScreen/ViewModel/SplashViewModel.dart';
import '../Model/SiteMaintanenceModel.dart';

class SiteMaintenanceViewModel extends ChangeNotifier {
  GetMaintenanceRoomModelClass? getMaintenanceRoomModelClass;
  MarketViewModel? marketViewModel;

  getSiteMaintenanceStatus() async {
    marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    await marketViewModel?.webSocket?.connect();
    securedPrint("socketConnect${marketViewModel?.webSocket?.connected}");
    marketViewModel?.webSocket?.on('maintenanceRoom', (data) {
      securedPrint("maintenanceRoom$data");
      var decodeResponse =
          HandleResponse.completed(GetMaintenanceRoomModelClass.fromJson(data));
      switch (decodeResponse.status?.index) {
        case 0:
          break;
        case 1:
          updateSocketStatus(decodeResponse.data);
          break;
        default:
          break;
      }
    });
  }

  leaveSocket() {
    marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel?.ws?.close();
    marketViewModel?.webSocket?.clearListeners();
  }

  updateSocketStatus(GetMaintenanceRoomModelClass? data) {
    getMaintenanceRoomModelClass = data;
    constant.siteMaintenanceStatus.value =
        getMaintenanceRoomModelClass?.siteMaintenance ?? false;
    constant.siteMaintenanceStartDate.value =
        getMaintenanceRoomModelClass?.siteMaintenanceSettings?.startDate;
    constant.siteMaintenanceEndDate.value =
        getMaintenanceRoomModelClass?.siteMaintenanceSettings?.endDate;
    if (getMaintenanceRoomModelClass?.siteMaintenance == true) {
      moveToSiteMaintenanceView(NavigationService.navigatorKey.currentContext!);
    } else {
      constant.userLoginStatus.value = false;
      constant.pref?.setBool('loginStatus', false);
      constant.pref?.setString("userEmail", constant.appEmail);
      var splashViewModel = Provider.of<SplashViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      var currencyPreferenceViewModel =
          Provider.of<CurrencyPreferenceViewModel>(
              NavigationService.navigatorKey.currentContext!,
              listen: false);
      currencyPreferenceViewModel.setCurrency(
          splashViewModel.defaultCurrency?.fiatDefaultCurrency ?? "GBP");
      var identityVerificationCommonViewModel =
          Provider.of<IdentityVerificationCommonViewModel>(
              NavigationService.navigatorKey.currentContext!,
              listen: false);
      identityVerificationCommonViewModel.index = 0;
      identityVerificationCommonViewModel.setActive(
          NavigationService.navigatorKey.currentContext!, 0);
      var exchangeViewModel = Provider.of<ExchangeViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      exchangeViewModel.clearData();
      var loginViewModel = Provider.of<LoginViewModel>(
          NavigationService.navigatorKey.currentContext!,
          listen: false);
      loginViewModel.clearData();
      marketViewModel?.clearP2PData();
      marketViewModel?.logoutFromGoogle();
      moveToMarket(NavigationService.navigatorKey.currentContext!);
      Provider.of<CommonViewModel>(
              NavigationService.navigatorKey.currentContext!,
              listen: false)
          .setActive(0);
    }
    notifyListeners();
  }
}
