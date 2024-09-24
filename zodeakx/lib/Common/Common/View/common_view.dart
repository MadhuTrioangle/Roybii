import 'package:flutter/material.dart';
import 'package:flutter_pinned_shortcut/flutter_pinned_shortcut.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSwitch.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomBottomNavigationBar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../ZodeakX/MarketScreen/Views/MarketView.dart';
import '../../Exchange/View/ExchangeView.dart';
import '../../Orders/View/OrdersView.dart';
import '../../Wallets/View/WalletView.dart';
import '../ViewModel/common_view_model.dart';

class CommonView extends StatefulWidget {
  const CommonView({Key? key}) : super(key: key);

  @override
  State<CommonView> createState() => _CommonViewState();
}

class _CommonViewState extends State<CommonView> with TickerProviderStateMixin {
  late CommonViewModel viewModel;
  late MarketViewModel marketViewModel;
  late ExchangeViewModel exchangeViewModel;
  late TabController _drawerTabController;
  bool isLogin = false;
  final GlobalKey<ScaffoldState> commonScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey fiatKey = GlobalKey();
  GlobalKey altKey = GlobalKey();
  late List<Widget> _widgetOptions;
  final FlutterPinnedShortcut flutterPinnedShortcutPlugin =
      FlutterPinnedShortcut();

  void _onItemTapped(int index) {
    viewModel.setActive(index);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _drawerTabController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<CommonViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    _drawerTabController = TabController(length: 5, vsync: this);
    _drawerTabController.addListener(() {
      if (!_drawerTabController.indexIsChanging) {
        Future.delayed(Duration(milliseconds: 500), () {
          exchangeViewModel.restartSocketForDrawer();
        });
      }
    });
    _widgetOptions = <Widget>[
      MarketView(),
      ExchangeView(),
      OrdersView(),
      WalletView(),
    ];
    getIncomingAction();
  }

  void getIncomingAction() {
    flutterPinnedShortcutPlugin.getLaunchAction((action) {
      switch (action) {
        case "p2p":
          constant.p2pPop.value = true;
          moveToP2P(context);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<CommonViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    exchangeViewModel = context.watch<ExchangeViewModel>();
    isLogin = constant.userLoginStatus.value;
    String email = constant.pref?.getString("userEmail") ?? '';
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        drawer: viewModel.id != 1
            ? sideMenu(context, email)
            : sideMenuExchange(size),
        key: commonScaffoldKey,
        bottomNavigationBar: CustomBottomNavigationBar(
          color: themeColor,itemsCount: 4,
          icon: [market, exchangeImage, order, walletImage],
          onTabSelected: _onItemTapped,
          backgroundColor: Colors.transparent,
          label: [
            stringVariables.market.toUpperCase(),
            stringVariables.exchange.toUpperCase(),
            stringVariables.orders.toUpperCase(),
            stringVariables.wallet.toUpperCase()
          ],
          heigth: 14,
          fit: BoxFit.fill,
          commonViewModel: viewModel,
        ),
        child: _widgetOptions.elementAt(viewModel.id),
      ),
    );
  }

  ///To tap user icon in APPBAR it shows the SideMenu
  Widget sideMenuExchange(Size size) {
    return Drawer(
      child: DefaultTabController(
        length: 5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomSizedBox(
              height: 0.02,
            ),
            CustomContainer(
              width: 1,
              height: exchangeViewModel.searchFilterView ? 7.65 : 6.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomIconButton(
                        onPress: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close_sharp),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: CustomTextFormField(
                      press: () {
                        viewModel.searchPairController.clear();
                        onSearchTextChanged(
                          viewModel.searchPairController.text,
                        );
                        onSearchTextChanged('');
                      },
                      onChanged: onSearchTextChanged,
                      controller: viewModel.searchPairController,
                      prefixIcon: Icon(
                        Icons.search,
                        color: hintLight,
                      ),
                      size: 30,
                      text: stringVariables.search,
                      isContentPadding: false,
                    ),
                  ),
                ],
              ),
            ),
            exchangeViewModel.searchFilterView
                ? CustomContainer(
                    width: 1,
                    height: 1.25,
                    padding: 15,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            exchangeViewModel.drawerFilteredTradePairs!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomContainer(
                            width: 1,
                            height: 12.5,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                exchangeViewModel.setTradePair(exchangeViewModel
                                    .drawerFilteredTradePairs![index].symbol!);
                                Scaffold.of(context).closeDrawer();
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text: exchangeViewModel
                                                .drawerFilteredTradePairs![
                                                    index]
                                                .symbol!
                                                .split("/")
                                                .first,
                                            softwrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            fontsize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          CustomSizedBox(
                                            width: 0.004,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: CustomText(
                                              text: "/",
                                              fontsize: 13,
                                            ),
                                          ),
                                          CustomSizedBox(
                                            width: 0.002,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: CustomText(
                                              text: exchangeViewModel
                                                  .drawerFilteredTradePairs![
                                                      index]
                                                  .symbol!
                                                  .split("/")
                                                  .last,
                                              fontsize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      CustomText(
                                        text: trimDecimals(exchangeViewModel
                                            .drawerFilteredTradePairs![index]
                                            .lastPrice!),
                                        softwrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        fontsize: 15,
                                        fontWeight: FontWeight.w400,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomSizedBox(
                                        height: 0.02,
                                      ),
                                      CustomText(
                                        color: double.parse(exchangeViewModel
                                                    .drawerFilteredTradePairs![
                                                        index]
                                                    .priceChangePercent!) >
                                                0
                                            ? green
                                            : red,
                                        text: double.parse(exchangeViewModel
                                                    .drawerFilteredTradePairs![
                                                        index]
                                                    .priceChangePercent!) >
                                                0
                                            ? "+" +
                                                trimAs2(exchangeViewModel
                                                    .drawerFilteredTradePairs![
                                                        index]
                                                    .priceChangePercent!) +
                                                "%"
                                            : trimAs2(exchangeViewModel
                                                    .drawerFilteredTradePairs![
                                                        index]
                                                    .priceChangePercent!) +
                                                "%",
                                        softwrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        fontsize: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : CustomContainer(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: hintLight.withOpacity(0.25)),
                      ),
                    ),
                    width: 1,
                    height: 15,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: TabBar(
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                          indicatorWeight: 0,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 5,
                              color: themeColor,
                            ),
                          ),
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                          isScrollable: true,
                          labelColor: themeSupport().isSelectedDarkMode()
                              ? white
                              : black,
                          unselectedLabelColor: hintLight,
                          controller: _drawerTabController,
                          tabs: [
                            Tab(text: exchangeViewModel.staticPairs[0]),
                            Tab(text: exchangeViewModel.staticPairs[1]),
                            Tab(text: exchangeViewModel.staticPairs[2]),
                            tabItems(size, exchangeViewModel.alt!, altKey,
                                (value) {
                              exchangeViewModel.setAlt(value);
                            }, exchangeViewModel.otherPairs, 3),
                            tabItems(size, exchangeViewModel.fiat!, fiatKey,
                                (value) {
                              exchangeViewModel.setFiat(value);
                            }, exchangeViewModel.fiatPairs, 4),
                          ]),
                    ),
                  ),
            exchangeViewModel.searchFilterView
                ? SizedBox.shrink()
                : Expanded(
                    child: CustomContainer(
                      width: 1,
                      height: 1,
                      child: tabBarView(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  tabBarView() {
    return TabBarView(controller: _drawerTabController, children: [
      CustomDrawerTab(
        pair: exchangeViewModel.staticPairs[0],
        viewModel: exchangeViewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.staticPairs[1],
        viewModel: exchangeViewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.staticPairs[2],
        viewModel: exchangeViewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.alt,
        viewModel: exchangeViewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.fiat,
        viewModel: exchangeViewModel,
      ),
    ]);
  }

  onSearchTextChanged(
    String text,
  ) async {
    text.isEmpty
        ? exchangeViewModel.setsearchFilterView(false)
        : exchangeViewModel.setsearchFilterView(true);
    exchangeViewModel.setSearchText(text);
    var filtered = exchangeViewModel.viewModelTradePairs!
        .where((element) =>
            element.symbol!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    exchangeViewModel.setDrawerFilteredTradePairs(filtered);
  }

  Widget tabItems(Size size, String text, GlobalKey key,
      ValueChanged onSelected, List<String> list, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _drawerTabController.index = index;
        dynamic state = key.currentState;
        state.showButtonMenu();
      },
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomText(
                  fontsize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  text: text,
                ),
              ],
            ),
            Row(
              children: [
                CustomContainer(
                  width: 30,
                  height: 30,
                  child: AbsorbPointer(
                    child: PopupMenuButton(
                      key: key,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minWidth: (size.width / 3.45),
                        maxWidth: (size.width / 3.45),
                        minHeight: (size.height / 12),
                        maxHeight: (size.height / 3.75),
                      ),
                      offset: Offset((size.width / 15), (size.width / 12)),
                      onSelected: onSelected,
                      icon: Icon(Icons.arrow_drop_down),
                      itemBuilder: (
                        BuildContext context,
                      ) {
                        return list.map<PopupMenuItem<String>>((String? value) {
                          return PopupMenuItem(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    align: TextAlign.center,
                                    fontsize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    text: value.toString(),
                                  ),
                                ],
                              ),
                              value: value);
                        }).toList();
                      },
                    ),
                  ),
                ),
                CustomSizedBox(
                  height: 0.005,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///To tap user icon in APPBAR it shows the SideMenu
  Widget sideMenu(BuildContext context, String email) {
    return Drawer(
      backgroundColor: themeSupport().isSelectedDarkMode() ? black : grey,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            isLogin != false
                ? HeaderLogin(context, email)
                : HeaderLogout(context),
            Login(
              context,
              isLogin
                  ? marketViewModel.LoginArray
                  : marketViewModel.LogoutArray,
            ),
            Column(
              children: [
                CustomSizedBox(
                  height: 0.01,
                ),
                DividerLine(context),
              ],
            ),
            isLogin != false
                ? Footer(
                    context,
                  )
                : CustomSizedBox(),
          ],
        ),
      ),
    );
  }

  ///SideMenu Divider
  Widget DividerLine(BuildContext context) {
    return Column(
      children: [
        Divider(
          indent: 30,
          endIndent: 30,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  ///SideMenu Lists
  Widget Login(
    BuildContext context,
    List<Map<String, dynamic>> sideMenuList,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return index + 1 != sideMenuList.length + 1
              ? ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -3.5),
                  title: Padding(
                    padding: EdgeInsets.only(right: 20, bottom: 1),
                    child: CustomText(text: sideMenuList[index]["title"]),
                  ),
                  leading: Container(
                    height: 16,
                    width: 40,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SvgPicture.asset(sideMenuList[index]["logo"],
                          color: textGrey),
                    ),
                  ),
                  onTap: () {
                    //navigation(index,sideMenuList);
                    marketViewModel.navigation(index, sideMenuList, context);
                  },
                )
              : ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -3.5),
                  title: Padding(
                    padding: EdgeInsets.only(right: 20, top: 4),
                    child: CustomText(text: stringVariables.darkMode),
                  ),
                  leading: Container(
                    height: 14,
                    width: 40,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 8),
                      child: Icon(Icons.nights_stay_outlined,
                          color: textGrey, size: 20),
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: CustomSwitch(
                        activeColor: themeColor,
                        inactiveColor: switchBackground,
                        toggleColor: white,
                        value: marketViewModel.active,
                        onToggle: (value) {
                          marketViewModel.active = value;
                          marketViewModel.toggleStatus(value, context);
                        }),
                  ));
        },
        itemCount: (sideMenuList.length) + 1,
      ),
    );
  }

  ///SideMenu Footer contain version
  Widget Footer(
    BuildContext context,
  ) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        viewModel.needToLoad
            ? CustomLoader()
            : LogOutButton(
                context,
              ),
        CustomSizedBox(
          height: 0.02,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
                text: stringVariables.version, color: textGrey, fontsize: 13)
          ],
        ),
      ],
    );
  }

  ///SideMenu Header when user Login
  Widget HeaderLogin(BuildContext context, String email) {
    String Email = '${email}'.substring(0, 2);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        CustomContainer(
          height: 20,
          width: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    width: 0.095,
                  ),
                  CustomContainer(
                    constraints: BoxConstraints(maxWidth: size.width / 2.15),
                    child: CustomText(
                      text: marketViewModel.isvisible
                          ? email
                          : Email +
                              '***' +
                              '${email}'.substring('${email} '.indexOf('@')),
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxlines: 2,
                      fontsize: 16,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.015,
                  ),
                  GestureDetector(
                      onTap: () {
                        marketViewModel.setVisible();
                      },
                      child: Icon(
                        marketViewModel.isvisible
                            ? Icons.remove_red_eye_rounded
                            : Icons.visibility_off,
                        color: textHeaderGrey,
                        size: 19,
                      )),
                ],
              ),
              CustomIconButton(
                  child: SvgPicture.asset(cancel, height: 20),
                  onPress: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  ///SideMenu Header when User Logout
  Widget HeaderLogout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.075,
                ),
                SvgPicture.asset(
                  checkBrightness.value == Brightness.dark
                      ? lightlogo
                      : darklogo,
                  height: 35,
                  width: 35,
                  fit: BoxFit.fill,
                ),
              ],
            ),
            CustomIconButton(
                child: SvgPicture.asset(
                  cancel,
                  height: 20,
                ),
                onPress: () {
                  Navigator.pop(context);
                })
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.095,
            ),
            CustomText(
              text: stringVariables.loginOrRegister,
              fontsize: 20,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        )
      ],
    );
  }

  ///SideMenu Logout Button
  Widget LogOutButton(
    BuildContext context,
  ) {
    return CustomElevatedButton(
      icon: null,
      color: black,
      maxLines: 1,
      buttoncolor: themeColor,
      press: () {
        marketViewModel.logoutUser(constant.userToken.value);
      },
      isBorderedButton: true,
      height: 15,
      icons: false,
      width: 1.35,
      text: 'LOG OUT',
      radius: 25,
    );
  }
}
