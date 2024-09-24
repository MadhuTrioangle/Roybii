import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';

import '../../SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../ViewModel/SplashViewModel.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late SplashViewModel viewModel;
  late SiteMaintenanceViewModel siteMaintenanceViewModel;

  @override
  void initState() {
    viewModel = Provider.of<SplashViewModel>(context, listen: false);

    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    viewModel.getDefault(true);
    siteMaintenanceViewModel.getSiteMaintenanceStatus();
    String languageCode = constant.pref?.getString("defaultLanguage") ?? "en";

    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
    super.initState();
    constant.p2pPop.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: null,
    );
  }
}
