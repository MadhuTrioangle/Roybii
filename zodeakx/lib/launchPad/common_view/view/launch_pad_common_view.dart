import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/launchPad/launchpad_history/view/launchpad_history_view.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomBottomNavigationBar.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../launch_pad/view/launch_pad_view.dart';
import '../../launch_pad_home_page/view/launch_pad_home_page_view.dart';
import '../view_model/launch_pad_commom_view_model.dart';

class LaunchPadCommonView extends StatefulWidget {
  const LaunchPadCommonView({Key? key}) : super(key: key);

  @override
  State<LaunchPadCommonView> createState() => _LaunchPadCommonViewState();
}

class _LaunchPadCommonViewState extends State<LaunchPadCommonView>
    with TickerProviderStateMixin {
  late LaunchPadCommonViewModel viewModel;
  bool isLogin = false;

  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    viewModel.setActive(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<LaunchPadCommonViewModel>(context, listen: false);
    _widgetOptions = <Widget>[
      LaunchPadHomePageView(),
      LaunchPadView(),
      //VotingView(),
      LaunchpadHistoryView()
    ];
  }

  Future<bool> pop() async {
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<LaunchPadCommonViewModel>();
    isLogin = constant.userLoginStatus.value;
    return WillPopScope(
      onWillPop: pop,
      child: Provider(
        create: (context) => viewModel,
        child: CustomScaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            color: themeColor,itemsCount: 3,
            icon: [home, launchPad, history],
            onTabSelected: _onItemTapped,
            backgroundColor: Colors.transparent,
            label: [
              stringVariables.home.toUpperCase(),
              stringVariables.launchPad.toUpperCase(),
              //stringVariables.vote.toUpperCase(),
              stringVariables.history_orders.toUpperCase()
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
