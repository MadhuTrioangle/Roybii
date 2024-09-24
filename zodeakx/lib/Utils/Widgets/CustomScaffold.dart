import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../Common/Common/ViewModel/common_view_model.dart';
import '../Constant/AppConstants.dart';

class CustomScaffold extends StatelessWidget {
  Color? color = Colors.black; // used for background color
  final Widget? child; //add functionality
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? body;
  final Key? scaffoldKey;
  final AppBar? appBar;

  CustomScaffold(
      {Key? key,
      this.color,
      this.child,
      this.scaffoldKey,
      this.bottomNavigationBar,
      this.drawer,
      this.appBar,
      this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      appBar: appBar,
      backgroundColor: color,
      onDrawerChanged: (isOpen) {
        if (!isOpen) {
          CommonViewModel commonViewModel = Provider.of<CommonViewModel>(
              NavigationService.navigatorKey.currentContext!,
              listen: false);
          commonViewModel.setDrawer(null);
          ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
              NavigationService.navigatorKey.currentContext!,
              listen: false);
          exchangeViewModel.continueSocketForDrawer();
        }
      },
      body: SafeArea(child: child ?? CustomSizedBox()),
    );
  }
}
