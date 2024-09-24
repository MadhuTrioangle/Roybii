import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/p2p/ads/view/p2p_ads_view.dart';
import 'package:zodeakx_mobile/p2p/home/view/p2p_home_view.dart';
import 'package:zodeakx_mobile/p2p/orders/view/p2p_order_view.dart';
import 'package:zodeakx_mobile/p2p/profile/view/p2p_profile_view.dart';


import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomBottomNavigationBar.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../view_model/p2p_common_view_model.dart';

class P2PCommonView extends StatefulWidget {
  const P2PCommonView({Key? key}) : super(key: key);

  @override
  State<P2PCommonView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PCommonView>
    with TickerProviderStateMixin {
  late P2PCommonViewModel viewModel;
  bool isLogin = false;
  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    viewModel.setActive(index);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    resumeSocket();
    super.dispose();
  }

  resumeSocket() {
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.initSocket = true;
    marketViewModel.getTradePairs();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PCommonViewModel>(context, listen: false);
    _widgetOptions = <Widget>[
      P2PHomeView(),
      P2POrderView(),
      P2PAdsView(),
      P2PProfileView()
    ];
  }

  Future<bool> pop() async {
    if(constant.p2pPop.value) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      constant.p2pPop.value = false;
    } else {
      Navigator.pop(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PCommonViewModel>();
    isLogin = constant.userLoginStatus.value;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: pop,
      child: Provider(
        create: (context) => viewModel,
        child: CustomScaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            color: themeColor,
            icon: [market, exchangeImage, order, walletImage],
            onTabSelected: _onItemTapped,
            backgroundColor: Colors.transparent,
            label: [
              stringVariables.home.toUpperCase(),
              stringVariables.orders.toUpperCase(),
              stringVariables.ads.toUpperCase(),
              stringVariables.profile.toUpperCase()
            ],
            heigth: 14,
            fit: BoxFit.fill,
            commonViewModel: viewModel,
          ),
          child: _widgetOptions.elementAt(viewModel.id),
        ),
      ),
    );
  }
}
