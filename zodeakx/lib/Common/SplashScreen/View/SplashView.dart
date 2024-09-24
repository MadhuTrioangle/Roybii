import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';

import '../ViewModel/SplashViewModel.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<SplashViewModel>(context, listen: false);
    viewModel.getDefault();
    super.initState();
    constant.p2pPop.value = false;
    Timer(const Duration(seconds: 0), () {
      moveToMarket(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(child: null);
  }
}
