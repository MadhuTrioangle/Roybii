import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pinned_shortcut/flutter_pinned_shortcut.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSwitch.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/ViewModel/DashBoardViewModel.dart';

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
import '../../../ZodeakX/HomeScreen/View/HomeScreenView.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../ZodeakX/MarketScreen/Views/MarketView.dart';
import '../../Exchange/View/ExchangeView.dart';
import '../../IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
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
  late DashBoardViewModel dashBoardViewModel;
  late IdentityVerificationCommonViewModel identityVerificationCommonViewModel;
  late ExchangeViewModel exchangeViewModel;
  late TabController _drawerTabController;
  late TabController _futureDrawerTabController;
  bool isLogin = false;
  bool futureStatus = false;
  final GlobalKey<ScaffoldState> commonScaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey fiatKey = GlobalKey();
  GlobalKey altKey = GlobalKey();
  late List<String> icons = [home, market, tradeIcon, order, walletImage];
  late List<String> labels = [
    stringVariables.home,
    stringVariables.markets,
    stringVariables.trades,
    stringVariables.orders,
    stringVariables.wallets
  ];
  late List<Widget> _widgetOptions;
  final FlutterPinnedShortcut flutterPinnedShortcutPlugin =
      FlutterPinnedShortcut();

  void _onItemTapped(int index) {
    viewModel.setActive(index);
    if (index == 2) {
      exchangeViewModel.setTradePair(constant.spotDefaultPair.value);
    }
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
    identityVerificationCommonViewModel =
        Provider.of<IdentityVerificationCommonViewModel>(context,
            listen: false);
    dashBoardViewModel =
        Provider.of<DashBoardViewModel>(context, listen: false);

    isLogin = constant.userLoginStatus.value;

    _drawerTabController = TabController(length: isLogin ? 6 : 5, vsync: this);
    _futureDrawerTabController =
        TabController(length: isLogin ? 4 : 3, vsync: this, initialIndex: 1);
    _drawerTabController.addListener(() {
      exchangeViewModel.setDrawerIndex(_drawerTabController.index);
      if (!_drawerTabController.indexIsChanging) {
        Future.delayed(Duration(milliseconds: 500), () {
          exchangeViewModel.restartSocketForDrawer();
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exchangeViewModel.setDrawerIndex(0);
      dashBoardViewModel.getIdVerification();
    });
    _widgetOptions = <Widget>[
      HomeScreenView(),
      MarketView(),
      ExchangeView(),
      OrdersView(),
      WalletView(),
    ];
    if (Platform.isAndroid) getIncomingAction();
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
    identityVerificationCommonViewModel =
        context.watch<IdentityVerificationCommonViewModel>();
    dashBoardViewModel = context.watch<DashBoardViewModel>();
    isLogin = constant.userLoginStatus.value;
    String email = constant.pref?.getString("userEmail") ?? '';

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            viewModel.setActive(2);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: CustomContainer(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeColor,
              ),
              child: SvgPicture.asset(
                tradeIcon,
                color: Colors.white,
                fit: BoxFit.none,
                height: 50,
                width: 50,
              ),
            ),
          ),
        ),
        drawer: drawerContent(size, email),
        key: commonScaffoldKey,
        bottomNavigationBar: CustomBottomNavigationBar(
          color: themeColor,
          icon: icons,
          onTabSelected: _onItemTapped,
          backgroundColor: Colors.transparent,
          label: labels,
          heigth: 14,
          fit: BoxFit.fill,
          commonViewModel: viewModel,
        ),
        child: _widgetOptions.elementAt(viewModel.id),
      ),
    );
  }

  getCrossMarginPairsList(List<ListOfTradePairs> list) {
    return list.where((element) => element.enableMarginCross ?? false).toList();
  }

  getIsolatedMarginPairsList(List<ListOfTradePairs> list) {
    return list
        .where((element) => element.enableMarginIsolated ?? false)
        .toList();
  }

  ///To tap user icon in APPBAR it shows the SideMenu
  Widget sideMenuExchange(Size size) {
    List<ListOfTradePairs> list =
        exchangeViewModel.drawerFilteredTradePairs ?? [];
    return Drawer(
      backgroundColor: themeSupport().isSelectedDarkMode() ? black : grey,
      width: 350,
      child: DefaultTabController(
        length: isLogin ? 6 : 5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CustomSizedBox(
              height: 0.03,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: stringVariables.market,
                      fontsize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomIconButton(
                      onPress: () {
                        Navigator.pop(context);
                        viewModel.getLiquidityStatus("ExchangeView");
                      },
                      child: Icon(Icons.close_sharp),
                    ),
                  ],
                ),
                CustomTextFormField(
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
              ],
            ),
            exchangeViewModel.searchFilterView
                ? listItemsOfSearch(list)
                : tabBar(size),
            if (!exchangeViewModel.searchFilterView) buildSortingItems(),
            exchangeViewModel.searchFilterView
                ? SizedBox.shrink()
                : Expanded(
                    child: tabBarView(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget tabBar(Size size) {
    return CustomContainer(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: hintLight.withOpacity(0.25)),
        ),
      ),
      width: 1,
      height: 15,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            indicatorWeight: 0,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 5,
                color: themeColor,
              ),
            ),
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            isScrollable: true,
            labelColor: themeSupport().isSelectedDarkMode() ? white : black,
            unselectedLabelColor: hintLight,
            controller: _drawerTabController,
            tabs: [
              if (isLogin) Tab(text: stringVariables.favourite),
              Tab(text: exchangeViewModel.staticPairs[0]),
              Tab(text: exchangeViewModel.staticPairs[1]),
              Tab(text: exchangeViewModel.staticPairs[2]),
              Tab(text: exchangeViewModel.staticPairs[3]),
              // tabItems(size, exchangeViewModel.alt!, altKey,
              //     (value) {
              //   exchangeViewModel.setAlt(value);
              // }, exchangeViewModel.otherPairs, 3),
              tabItems(size, exchangeViewModel.fiat!, fiatKey, (value) {
                exchangeViewModel.setFiat(value);
              }, exchangeViewModel.fiatPairs, isLogin ? 5 : 4),
            ]),
      ),
    );
  }

  Widget buildNoRecord() {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.04,
        ),
        CustomText(
          fontfamily: 'InterTight',
          fontsize: 20,
          fontWeight: FontWeight.bold,
          text: stringVariables.notFound,
          color: hintLight,
        ),
      ],
    );
  }

  Widget listItemsOfSearch(List<ListOfTradePairs> list) {
    return Expanded(
      child: list.isEmpty
          ? buildNoRecord()
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 10, top: 5),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      exchangeViewModel.setTradePair(list[index].symbol!);
                      Scaffold.of(context).closeDrawer();
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: list[index].symbol!.split("/").first,
                                  softwrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  fontsize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                CustomSizedBox(
                                  width: 0.004,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: CustomText(
                                    text: "/",
                                    fontsize: 13,
                                  ),
                                ),
                                CustomSizedBox(
                                  width: 0.002,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: CustomText(
                                    text: list[index].symbol!.split("/").last,
                                    fontsize: 13,
                                  ),
                                ),
                              ],
                            ),
                            CustomText(
                              text: trimDecimals(list[index].lastPrice!),
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
                              color: double.parse(
                                          list[index].priceChangePercent!) >
                                      0
                                  ? green
                                  : red,
                              text: double.parse(
                                          list[index].priceChangePercent!) >
                                      0
                                  ? "+" +
                                      trimAs2(list[index].priceChangePercent!) +
                                      "%"
                                  : trimAs2(list[index].priceChangePercent!) +
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
    );
  }

  Widget buildSortingItems() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (exchangeViewModel!.albCounter < 2) {
                  exchangeViewModel!
                      .setAlbCount((exchangeViewModel!.albCounter + 1));
                  if (exchangeViewModel!.albOrder) {
                    exchangeViewModel!.setPairIcon(
                        themeSupport().isSelectedDarkMode()
                            ? upSortLight
                            : upSort);
                    exchangeViewModel!.filteredListWithPair();
                    exchangeViewModel!.favListWithPair();
                    exchangeViewModel!.setAlbOrder(false);
                  } else {
                    exchangeViewModel!.setPairIcon(
                        themeSupport().isSelectedDarkMode()
                            ? downSortLight
                            : downSort);
                    exchangeViewModel!.setfilteredTradePairs(
                        exchangeViewModel!.filteredList!.reversed.toList());
                    exchangeViewModel!.setFavTradePairs(
                        exchangeViewModel!.favFilteredList!.reversed.toList());
                    exchangeViewModel!.setAlbOrder(true);
                  }
                } else {
                  exchangeViewModel!.setPairIcon(normalSort);
                  exchangeViewModel!.setAlbCount(0);
                  exchangeViewModel!.setfilteredTradePairs(
                      exchangeViewModel!.viewModelTradePairs!);
                  exchangeViewModel!
                      .setFavTradePairs(exchangeViewModel!.favTradePairs);
                }
              },
              child: buildTextWithSort(
                  stringVariables.pairs, exchangeViewModel!.pairIcon)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (exchangeViewModel!.lastCounter < 2) {
                      exchangeViewModel!
                          .setLastCount((exchangeViewModel!.lastCounter + 1));
                      if (exchangeViewModel!.lastOrder) {
                        exchangeViewModel!.setLastPriceIcon(
                            themeSupport().isSelectedDarkMode()
                                ? upSortLight
                                : upSort);
                        exchangeViewModel!.filteredListWithLastPrice();
                        exchangeViewModel!.favListWithLastPrice();
                        exchangeViewModel!.setfilteredTradePairs(
                            exchangeViewModel!.filteredList!.reversed.toList());
                        exchangeViewModel!.setFavTradePairs(exchangeViewModel!
                            .favFilteredList!.reversed
                            .toList());
                        exchangeViewModel!.setLastOrder(false);
                      } else {
                        exchangeViewModel!.setLastPriceIcon(
                            themeSupport().isSelectedDarkMode()
                                ? downSortLight
                                : downSort);
                        exchangeViewModel!.filteredListWithLastPrice();
                        exchangeViewModel!.favListWithLastPrice();
                        exchangeViewModel!.setLastOrder(true);
                      }
                    } else {
                      exchangeViewModel!.setLastPriceIcon(normalSort);
                      exchangeViewModel!.setLastCount(0);
                      exchangeViewModel!.setfilteredTradePairs(
                          exchangeViewModel!.viewModelTradePairs!);
                      exchangeViewModel!
                          .setFavTradePairs(exchangeViewModel!.favTradePairs!);
                    }
                  },
                  child: buildTextWithSort(stringVariables.lastPrice,
                      exchangeViewModel!.lastPriceIcon)),
              CustomSizedBox(
                width: 0.01,
              ),
              CustomText(text: stringVariables.slash),
              CustomSizedBox(
                width: 0.02,
              ),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (exchangeViewModel!.h24Counter < 2) {
                      exchangeViewModel!
                          .set24HCount((exchangeViewModel!.h24Counter + 1));
                      if (exchangeViewModel!.h24Order) {
                        exchangeViewModel!.set24hChangeIcon(
                            themeSupport().isSelectedDarkMode()
                                ? upSortLight
                                : upSort);
                        exchangeViewModel!.filteredListWithChangePercent();
                        exchangeViewModel!.favListWithChangePercent();
                        exchangeViewModel!.setfilteredTradePairs(
                            exchangeViewModel!.filteredList!.reversed.toList());
                        exchangeViewModel!.setFavTradePairs(exchangeViewModel!
                            .favFilteredList!.reversed
                            .toList());
                        exchangeViewModel!.set24HOrder(false);
                      } else {
                        exchangeViewModel!.set24hChangeIcon(
                            themeSupport().isSelectedDarkMode()
                                ? downSortLight
                                : downSort);
                        exchangeViewModel!.filteredListWithChangePercent();
                        exchangeViewModel!.favListWithChangePercent();
                        exchangeViewModel!.set24HOrder(true);
                      }
                    } else {
                      exchangeViewModel!.set24hChangeIcon(normalSort);
                      exchangeViewModel!.set24HCount(0);
                      exchangeViewModel!.setfilteredTradePairs(
                          exchangeViewModel!.viewModelTradePairs!);
                      exchangeViewModel!
                          .setFavTradePairs(exchangeViewModel!.favTradePairs!);
                    }
                  },
                  child: buildTextWithSort(stringVariables.h24Change,
                      exchangeViewModel!.h24ChangeIcon)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextWithSort(String text, String icon) {
    return Row(
      children: [
        CustomText(
          text: text + " ",
          color: hintLight,
          fontsize: 12,
        ),
        SvgPicture.asset(
          icon,
          width: 10,
          height: 10,
        ),
      ],
    );
  }

  tabBarView() {
    return TabBarView(controller: _drawerTabController, children: [
      if (isLogin)
        CustomDrawerTab(
          pair: stringVariables.favourite,
          viewModel: exchangeViewModel,
        ),
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
        pair: exchangeViewModel.staticPairs[3],
        viewModel: exchangeViewModel,
      ),
      // CustomDrawerTab(
      //   pair: exchangeViewModel.alt,
      //   viewModel: exchangeViewModel,
      // ),
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
    bool fiatSelected = exchangeViewModel.drawerIndex == (isLogin ? 5 : 4);
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
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: fiatSelected
                            ? themeSupport().isSelectedDarkMode()
                                ? white
                                : black
                            : hintLight,
                      ),
                      color: themeSupport().isSelectedDarkMode()
                          ? card_dark
                          : grey,
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
      width: 330,
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
          color: divider,
          thickness: 0.2,
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
                          color: sideMenuList[index]["title"] !=
                                  stringVariables.tokenSale
                              ? textGrey
                              : null),
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
    String userLevel =
        dashBoardViewModel.viewModelVerification?.vip_level ?? "";
    String kycStatus = capitalize(
        dashBoardViewModel.viewModelVerification?.kyc?.kycStatus ?? "Verified");
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
              Expanded(
                child: Row(
                  children: [
                    CustomSizedBox(
                      width: 0.095,
                    ),
                    Flexible(
                      child: CustomText(
                        text: marketViewModel.isvisible
                            ? email
                            : Email +
                                '***' +
                                '${email}'.substring('${email} '.indexOf('@')),
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxlines: 1,
                        fontsize: 16,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.01,
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
              ),
              CustomIconButton(
                  child: SvgPicture.asset(cancel, height: 20),
                  onPress: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
        CustomContainer(
          width: 1.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  moveToSecurity(context);
                },
                behavior: HitTestBehavior.opaque,
                child: CustomText(
                  text: "${kycStatus}",
                  fontWeight: FontWeight.bold,
                  color: kycStatus == "Verified" ? green : hintLight,
                ),
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              GestureDetector(
                onTap: () {
                  moveToWebView(context, '${constant.viplink}');
                },
                behavior: HitTestBehavior.opaque,
                child: CustomText(
                  text: "${userLevel}",
                  fontWeight: FontWeight.bold,
                  color: darkThemeColor,
                ),
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
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
                  height: 24,
                  width: 24,
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
      color: themeSupport().isSelectedDarkMode() ? black : white,
      maxLines: 1,
      buttoncolor: themeColor,
      press: () {
        marketViewModel.logoutUser(constant.userToken.value);
      },
      isBorderedButton: true,
      height: 15,
      icons: false,
      width: 1.5,
      text: stringVariables.logout,
      radius: 25,
    );
  }

  drawerContent(Size size, String email) {
    return viewModel.id != 2
        ? sideMenu(context, email)
        : sideMenuExchange(size);
  }
}
