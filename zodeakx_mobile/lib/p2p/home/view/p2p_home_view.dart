import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/common_view/view_model/p2p_common_view_model.dart';
import 'package:zodeakx_mobile/p2p/home/view_model/p2p_home_view_model.dart';

import '../../../Common/SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../model/p2p_advertisement.dart';
import 'p2p_filter_dialog.dart';
import 'p2p_onboarding_bottom_sheet.dart';
import 'p2p_risk_notice.dart';

class P2PHomeView extends StatefulWidget {
  const P2PHomeView({Key? key}) : super(key: key);

  @override
  State<P2PHomeView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PHomeView>
    with TickerProviderStateMixin {
  late P2PHomeViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  late TabController _tabController;
  final GlobalKey _menuKey = GlobalKey();
  SiteMaintenanceViewModel? siteMaintenanceViewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.animation?.value == _tabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setSide(_tabController.index == 0
              ? stringVariables.sell.toLowerCase()
              : stringVariables.buy.toLowerCase());
          viewModel.setCrypto(viewModel.staticPairs[_tabController.index == 0
              ? viewModel.buyTabController.index
              : viewModel.sellTabController.index]);
          viewModel.setTabLoading(true);
          viewModel.fetchAdvertisement();
        });
      }
    });
    Future.delayed(Duration(seconds: 0), () {
      String? encodedMap = constant.pref?.getString('p2pRiskNotice');
      Map<String, dynamic> decodedMap =
          (encodedMap == null || encodedMap.isEmpty)
              ? {}
              : json.decode(encodedMap);
      bool alreadyExist = decodedMap.containsKey(constant.userEmail.value);
      if (!alreadyExist) {
        _showDialog();
      } else {
        String? encodedMap = constant.pref?.getString('p2pOnBoarding');
        Map<String, dynamic> decodedMap =
            (encodedMap == null || encodedMap.isEmpty)
                ? {}
                : json.decode(encodedMap);
        bool alreadyExist = decodedMap.containsKey(constant.userEmail.value);
        if (!alreadyExist) {
          _showModal(context);
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setAmountSelected(false);
      viewModel.setPaymentSelected(false);
      viewModel.setTabLoading(true);
      viewModel.setSide(stringVariables.sell.toLowerCase());
      _tabController.index = 0;
      siteMaintenanceViewModel?.getSiteMaintenanceStatus();
    });
    viewModel.fetchP2PCurrency(initTabController);
  }

  initTabController() {
    viewModel.buyTabController =
        TabController(length: viewModel.staticPairs.length, vsync: this);
    viewModel.sellTabController =
        TabController(length: viewModel.staticPairs.length, vsync: this);
    viewModel.buyTabController.addListener(() {
      if (viewModel.buyTabController.animation?.value ==
          viewModel.buyTabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setCrypto(
              viewModel.staticPairs[viewModel.buyTabController.index]);
          viewModel.setTabLoading(true);
          viewModel.setListLoading(false);
          viewModel.fetchAdvertisement();
        });
      }
    });
    viewModel.sellTabController.addListener(() {
      if (viewModel.sellTabController.animation?.value ==
          viewModel.sellTabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setCrypto(
              viewModel.staticPairs[viewModel.sellTabController.index]);
          viewModel.setTabLoading(true);
          viewModel.setListLoading(false);
          viewModel.fetchAdvertisement();
        });
      }
    });
  }

  dynamic _showModal(BuildContext context) async {
    final result =
        await Navigator.of(context).push(P2POnBoardingModal(context));
    if (result ?? false) {
      String? encodedMap = constant.pref?.getString('p2pOnBoarding');
      Map<String, dynamic> decodedMap =
          (encodedMap == null || encodedMap.isEmpty)
              ? {}
              : json.decode(encodedMap);
      decodedMap.addAll({constant.userEmail.value: "true"});
      String entryAddedMap = json.encode(decodedMap);
      constant.pref?.setString("p2pOnBoarding", entryAddedMap);///setting key  and value ==>"" : true
    } else {
      Navigator.pop(context);
    }
  }

  _showDialog() async {
    final result = await Navigator.of(context).push(P2PNoticeModal(context));
    if (result ?? false) {///risk notice check box ticked means true
      String? encodedMap = constant.pref?.getString('p2pRiskNotice');
      Map<String, dynamic> decodedMap =
          (encodedMap == null || encodedMap.isEmpty)
              ? {}
              : json.decode(encodedMap);
      decodedMap.addAll({constant.userEmail.value: "true"});///just adding true
      String entryAddedMap = json.encode(decodedMap);
      constant.pref?.setString("p2pRiskNotice", entryAddedMap);
      _showModal(context);
    } else {
      Navigator.pop(context);
    }
  }

  _showFilterDialog() async {
    viewModel.setPaymentSelected(false);
    viewModel.setAmountSelected(false);
    final result = await Navigator.of(context).push(P2PFilterModel(context));
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PHomeViewModel>();
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PHomeView(size),
      ),
    );
  }

  Widget buildP2PHomeView(Size size) {
    return viewModel.needToLoad
        ? CustomLoader()
        : DefaultTabController(
            length: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 35),
                    child: CustomContainer(
                      padding: 6,
                      width: 2.15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: themeSupport().isSelectedDarkMode()
                            ? card_dark
                            : white,
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                      ),
                      child: TabBar(
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            50.0,
                          ),
                          color: themeColor,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: TextStyle(
                            fontFamily: 'InterTight',
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                        labelColor:
                            themeSupport().isSelectedDarkMode() ? black : white,
                        unselectedLabelColor: hintLight,
                        tabs: [
                          Tab(
                            text: stringVariables.buy,
                          ),
                          Tab(
                            text: stringVariables.sell,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width / 35, vertical: 10),
                    child: CustomContainer(
                      width: 1,
                      height: 1,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          CustomCard(
                            outerPadding: 0,
                            edgeInsets: 0,
                            radius: 25,
                            elevation: 0,
                            child: buildBuyTab(size),
                          ),
                          CustomCard(
                            outerPadding: 0,
                            edgeInsets: 0,
                            radius: 25,
                            elevation: 0,
                            child: buildSellTab(size),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildBuyTab(Size size) {
    return DefaultTabController(
      length: viewModel.staticPairs.length,
      child: Column(
        children: <Widget>[
          CustomSizedBox(
            height: 0.01,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 35),
            child: CustomContainer(
              width: 1,
              height: 17.5,
              child: buyTabBar(),
            ),
          ),
          buildStaticFields(size),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 35),
                child: CustomContainer(
                    width: 1,
                    height: isSmallScreen(context) ? 1.975 : 2.15,
                    child:
                        viewModel.tabLoader ? CustomLoader() : buyTabBarView()),
              ),
              buildAnimatedDialog(size),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSellTab(Size size) {
    return DefaultTabController(
      length: viewModel.staticPairs.length,
      child: Column(
        children: <Widget>[
          CustomSizedBox(
            height: 0.01,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 35),
            child: CustomContainer(
              width: 1,
              height: 17.5,
              child: sellTabBar(),
            ),
          ),
          buildStaticFields(size),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 35),
                child: CustomContainer(
                    width: 1,
                    height: isSmallScreen(context) ? 1.975 : 2.15,
                    child: viewModel.tabLoader
                        ? CustomLoader()
                        : sellTabBarView()),
              ),
              buildAnimatedDialog(size),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedDialog(Size size) {
    double height = viewModel.amountSelected
        ? size.height / 5
        : viewModel.paymentSelected
            ? size.height / 2.1
            : 0;
    double shadowHeight = viewModel.amountSelected
        ? 7.5
        : viewModel.paymentSelected
            ? 4
            : 0;
    double containerHeight = viewModel.amountSelected
        ? 5
        : viewModel.paymentSelected
            ? 2.5
            : 0;
    Widget currentView = viewModel.amountSelected
        ? buildAmountField(size)
        : viewModel.paymentSelected
            ? buildPaymentField(size)
            : CustomSizedBox();
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: height,
      width: size.width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: CustomContainer(
              width: 1.175,
              height: shadowHeight,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: themeSupport().isSelectedDarkMode()
                        ? white70.withOpacity(0.25)
                        : black12.withOpacity(0.5),
                    blurRadius: 15.0,
                    offset: Offset(
                      0,
                      25,
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomContainer(
            width: 1,
            height: containerHeight,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode() ? card_dark : white,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 35),
                child: currentView,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAmountField(Size size) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        CustomTextFormField(
          controller: viewModel.amountController,
          padLeft: 0,
          padRight: 0,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            //  FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          isContentPadding: false,
          contentPadding: EdgeInsets.only(left: 20, right: 10),
          size: 30,
          text: stringVariables.enterTotalAmount,
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                fontfamily: 'InterTight',
                text: viewModel.fiatCurrency,
                fontsize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomElevatedButton(
                buttoncolor: grey,
                color: hintLight,
                press: () {
                  viewModel.amountController.clear();
                },
                width: 2.45,
                isBorderedButton: true,
                maxLines: 1,
                icon: null,
                multiClick: true,
                text: stringVariables.reset,
                radius: 25,
                height: size.height / 50,
                icons: false,
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0)),
            CustomElevatedButton(
                buttoncolor: themeColor,
                color: themeSupport().isSelectedDarkMode() ? black : white,
                press: () {
                  if (viewModel.amountController.text.isEmpty) {
                    viewModel.setAmount(null);
                    viewModel.setAmountFilter(false);
                  } else {
                    viewModel.setAmount(viewModel.amountController.text);
                    viewModel.setAmountFilter(true);
                  }
                  viewModel.fetchAdvertisement();
                  viewModel.setAmountSelected(false);
                },
                width: 2.45,
                isBorderedButton: true,
                maxLines: 1,
                icon: null,
                multiClick: true,
                text: stringVariables.confirm,
                radius: 25,
                height: size.height / 50,
                icons: false,
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0)),
          ],
        ),
      ],
    );
  }

  Widget buildPaymentField(Size size) {
    return CustomContainer(
      height: 2.65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              CustomSizedBox(
                height: 0.01,
              ),
              CustomContainer(
                height: 4,
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: (1 / .6),
                  shrinkWrap: true,
                  children: List.generate(viewModel.cards.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          viewModel.setSelectedPayment(index);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomContainer(
                              height: 1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: viewModel.cards[index] ==
                                          viewModel.selectedPayment
                                      ? themeColor
                                      : grey),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomContainer(
                                    width: 4.8,
                                    child: Center(
                                      child: CustomText(
                                        fontfamily: 'InterTight',
                                        text: viewModel.cards[index],
                                        fontsize: 12,
                                        maxlines: 2,
                                        softwrap: true,
                                        align: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w400,
                                        color: viewModel.cards[index] ==
                                                viewModel.selectedPayment
                                            ? white
                                            : black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            viewModel.cards[index] == viewModel.selectedPayment
                                ? Transform.translate(
                                    offset: Offset(6.5, -6.5),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: SvgPicture.asset(
                                        p2pPaymentTick,
                                      ),
                                    ),
                                  )
                                : CustomSizedBox(
                                    height: 0,
                                    width: 0,
                                  ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomContainer(
                    width: 2,
                    child: CustomText(
                      fontfamily: 'InterTight',
                      text: stringVariables.paymentMethodHint,
                      fontsize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomElevatedButton(
                      buttoncolor: themeColor,
                      color:
                          themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        if (viewModel.selectedPayment != null) {
                          viewModel.updateCard(viewModel.selectedPayment);
                          viewModel.setPaymentMethodFilter(true);
                        } else {
                          viewModel.updateCard(null);
                          viewModel.setPaymentMethodFilter(false);
                        }
                        viewModel.fetchAdvertisement();
                        viewModel.setPaymentSelected(false);
                      },
                      width: 3,
                      isBorderedButton: true,
                      maxLines: 1,
                      icon: null,
                      multiClick: true,
                      text: stringVariables.confirm,
                      radius: 25,
                      height: size.height / 50,
                      icons: false,
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: Offset(0, 0)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildStaticFields(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
      child: CustomContainer(
        width: 1,
        height: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              height: 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          viewModel
                              .setAmountSelected(!viewModel.amountSelected);
                          viewModel.setPaymentSelected(false);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: buildStaticCard(size, 5, stringVariables.amount,
                            viewModel.amountFilter)),
                    CustomSizedBox(
                      width: 0.025,
                    ),
                    GestureDetector(
                      onTap: () {
                        viewModel
                            .setPaymentSelected(!viewModel.paymentSelected);
                        viewModel.setAmountSelected(false);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: buildStaticCard(
                          size,
                          3,
                          stringVariables.paymentMethod,
                          viewModel.paymentMethodFilter),
                    ),
                    CustomSizedBox(
                      width: 0.025,
                    ),
                    CustomContainer(
                      width: size.width * 2,
                      height: 50,
                      color: hintLight,
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showFilterDialog();
                      },
                      child: CustomContainer(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black),
                        width: 6,
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              p2pFilter,
                              color: viewModel.amountFilter ||
                                      viewModel.paymentMethodFilter
                                  ? themeColor
                                  : themeSupport().isSelectedDarkMode()
                                      ? black
                                      : white,
                            ),
                            CustomSizedBox(
                              width: 0.01,
                            ),
                            CustomText(
                              text: stringVariables.filter,
                              overflow: TextOverflow.ellipsis,
                              fontfamily: 'InterTight',
                              fontWeight: FontWeight.w400,
                              fontsize: 13,
                              color: viewModel.amountFilter ||
                                      viewModel.paymentMethodFilter
                                  ? themeColor
                                  : themeSupport().isSelectedDarkMode()
                                      ? black
                                      : white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.015,
            ),
            CustomContainer(
              width: 1,
              height: size.height * 2,
              color: hintLight,
            ),
            CustomSizedBox(
              height: 0.01,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStaticCard(
      Size size, double width, String title, bool isApplied) {
    return CustomContainer(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isApplied ? themeColor.withOpacity(0.25) : grey),
      width: width,
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: title,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.w400,
            fontsize: 13,
            color: isApplied ? themeColor : hintLight,
          ),

          // CustomSizedBox(
          //   width: 0.01,
          // ),
          // SvgPicture.asset(
          //   dropDownArrowImage,
          //   color: isApplied ? themeColor : hintLight,
          //   width: 5,
          //   height: 5,
          // )
        ],
      ),
    );
  }

  buildTabBar() {
    List<Tab> tabs = [];
    viewModel.staticPairs.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }

  buyTabBar() {
    return DecoratedTabBar(
      tabBar: TabBar(
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        indicatorWeight: 0,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        indicator: TabBarIndicator(color: themeColor, radius: 4),
        isScrollable: true,
        labelColor: themeColor,
        unselectedLabelColor: hintLight,
        controller: viewModel.buyTabController,
        tabs: buildTabBar(),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: hintLight.withOpacity(0.25),
            width: 2.0,
          ),
        ),
      ),
    );
  }

  sellTabBar() {
    return DecoratedTabBar(
      tabBar: TabBar(
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        indicatorWeight: 0,
        indicator: TabBarIndicator(color: themeColor, radius: 4),
        isScrollable: true,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        labelColor: themeColor,
        unselectedLabelColor: hintLight,
        controller: viewModel.sellTabController,
        tabs: buildTabBar(),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: hintLight.withOpacity(0.25),
            width: 2.0,
          ),
        ),
      ),
    );
  }

  buildBuyTabBarView() {
    List<Widget> tabs = [];
    viewModel.staticPairs.forEach((element) {
      tabs.add(CustomDrawerTab(
        isBuy: true,
        pair: element,
        viewModel: viewModel,
      ));
    });
    return tabs;
  }

  buildSellTabBarView() {
    List<Widget> tabs = [];
    viewModel.staticPairs.forEach((element) {
      tabs.add(CustomDrawerTab(
        isBuy: false,
        pair: element,
        viewModel: viewModel,
      ));
    });
    return tabs;
  }

  buyTabBarView() {
    return TabBarView(
      controller: viewModel.buyTabController,
      children: buildBuyTabBarView(),
    );
  }

  sellTabBarView() {
    return TabBarView(
      controller: viewModel.sellTabController,
      children: buildSellTabBarView(),
    );
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
    return AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: buildHeader(size));
  }

  Widget buildHeader(Size size) {
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    siteMaintenanceViewModel?.leaveSocket();
                    if (constant.p2pPop.value) {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                      constant.p2pPop.value = false;
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: CustomContainer(
                      padding: 7.5,
                      width: 12,
                      height: 24,
                      child: SvgPicture.asset(
                        backArrow,
                      ),
                    ),
                  ),
                ),
                CustomText(
                  text: stringVariables.p2p,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'InterTight',
                  fontWeight: FontWeight.bold,
                  fontsize: 20,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            ),
          ),
          buildHeaderCard(viewModel.fiatCurrency, size),
        ],
      ),
    );
  }

  Widget buildHeaderCard(
    String currency,
    Size size,
  ) {
    return Align(
        alignment: Alignment.centerRight,
        child: CustomCard(
          outerPadding: size.width / 35,
          edgeInsets: 0,
          radius: 7.5,
          elevation: 0.5,
          child: CustomContainer(
            width: (isSmallScreen(context) ? 2.85 : 2.9) -
                (currency.length > 3 ? (currency.length - 3) * 0.16 : 0),
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    moveToCurrency(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      CustomCircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.transparent,
                        child: FadeInImage.assetNetwork(
                          image: getImage(viewModel.fiatCurrency),
                          placeholder: splash,
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.01,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: currency,
                            overflow: TextOverflow.ellipsis,
                            fontfamily: 'InterTight',
                            fontWeight: FontWeight.w600,
                            fontsize: 16,
                          ),
                          CustomSizedBox(
                            width: 0.01,
                          ),
                          SvgPicture.asset(
                            p2pDownArrow,
                            height: 5,
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                          ),
                          CustomSizedBox(
                            width: 0.025,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomContainer(
                  width: 300,
                  height: 40,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                CustomSizedBox(
                  width: 0.005,
                ),
                CustomContainer(
                  width: 15,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      key: _menuKey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      offset: Offset((size.width / 100), (size.height / 15)),
                      constraints: BoxConstraints(
                        minWidth: (size.width *
                            (isSmallScreen(context) ? 0.61 : 0.6)),
                        maxWidth: (size.width *
                            (isSmallScreen(context) ? 0.61 : 0.6)),
                        minHeight: (size.height / 12),
                        maxHeight: (size.height / 2.625),
                      ),
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                        weight: 10,
                        size: 35,
                      ),
                      color: themeSupport().isSelectedDarkMode()
                          ? card_dark
                          : white,
                      itemBuilder: (_) {
                        return [
                          PopupItem(
                              value: viewModel.menuItems.first,
                              child: Column(
                                children: [
                                  CustomSizedBox(height: 0.01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        fontfamily: 'InterTight',
                                        align: TextAlign.center,
                                        fontsize: 22,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                        text: viewModel.menuItems.first,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          viewModel.menuIcons.first,
                                          height: 20,
                                          color: themeSupport()
                                                  .isSelectedDarkMode()
                                              ? white
                                              : black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomSizedBox(height: 0.02),
                                  CustomContainer(
                                    height: size.height,
                                    color: grey,
                                  )
                                ],
                              )),
                          buildPopupItem(size, viewModel.menuIcons[1],
                              viewModel.menuItems[1], grey),
                          buildPopupItem(size, viewModel.menuIcons[2],
                              viewModel.menuItems[2], grey),
                          buildPopupItem(size, viewModel.menuIcons[3],
                              viewModel.menuItems[3], grey),
                          buildPopupItem(
                              size,
                              viewModel.menuIcons[4],
                              viewModel.menuItems[4],
                              themeSupport().isSelectedDarkMode()
                                  ? card_dark
                                  : white),
                        ];
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  PopupItem buildPopupItem(
      Size size, String menuIcon, String menuItem, Color color) {
    return PopupItem(
        value: menuItem,
        child: Column(
          children: [
            CustomSizedBox(height: 0.02),
            Row(
              children: [
                SvgPicture.asset(
                  menuIcon,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                CustomSizedBox(
                  width: 0.025,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  align: TextAlign.center,
                  fontsize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  text: menuItem,
                ),
              ],
            ),
            CustomSizedBox(height: 0.025),
            // CustomContainer(
            //   height: size.height,
            //   color: color,
            // )
          ],
        ));
  }

  String getImage(String fiat) {
    List<dynamic> list = [];
    list = constant.userLoginStatus.value
        ? (walletViewModel.viewModelDashBoardBalance != null)
            ? (walletViewModel.viewModelDashBoardBalance!.isNotEmpty)
                ? walletViewModel.viewModelDashBoardBalance!
                    .where((element) => element.currencyCode == fiat)
                    .toList()
                : []
            : []
        : (marketViewModel.getCurrencies != null)
            ? (marketViewModel.getCurrencies!.isNotEmpty)
                ? marketViewModel.getCurrencies!
                    .where((element) => element.currencyCode == fiat)
                    .toList()
                : []
            : [];
    return (list == null || list.isEmpty) ? "" : list.first.image;
  }
}

class CustomDrawerTab extends StatefulWidget {
  String? pair;
  bool? isBuy;
  P2PHomeViewModel? viewModel;

  CustomDrawerTab({Key? key, this.pair, this.isBuy, this.viewModel})
      : super(key: key);

  @override
  CustomDrawerTabState createState() => new CustomDrawerTabState();
}

class CustomDrawerTabState extends State<CustomDrawerTab> {
  final _controller = ScrollController();
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge &&
          !(widget.viewModel?.listLoder ?? false)) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.viewModel?.setListLoading(true);
            currentPage++;
            widget.viewModel?.fetchAdvertisement(currentPage);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    P2PHomeViewModel? viewModel = widget.viewModel;
    int listCount = viewModel?.p2pAdvertisement?.data?.length ?? 0;

    List<Advertisement> advertisementList =
        viewModel?.p2pAdvertisement?.data ?? [];
    print("list count");
    print(listCount);
    return listCount != 0
        ? ListView.separated(
            padding: EdgeInsets.only(top: size.width / 50),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.02,
                ),
            controller: _controller,
            itemCount: listCount + ((viewModel?.listLoder ?? false) ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              print("index:::$index");
              print(viewModel?.listLoder);
              print("listcount:$listCount");
              print(index >= listCount);
              Advertisement advertisement = index >= listCount
                  ? Advertisement()
                  : advertisementList[index];
              return index >= listCount
                  ? CustomLoader()
                  : buildListCard(
                      size,
                      (widget.isBuy ?? true),
                      advertisement,
                    );
            })
        : buildNoAdsView();
  }

  Widget buildNoAdsView() {
    return CustomContainer(
      width: 1,
      height: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            themeSupport().isSelectedDarkMode() ? p2pNoAdsDark : p2pNoAds,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'InterTight',
            text: stringVariables.noAds,
            fontsize: 18,
            fontWeight: FontWeight.w400,
            color: hintLight,
          ),
        ],
      ),
    );
  }

  buildListCard(
    Size size,
    bool isBuy,
    Advertisement advertisement,
  ) {
    String? name = advertisement.name;
    String adType = capitalize(advertisement.advertisementType!);
    int noOfTrades = advertisement.totalOrders?.toInt() ?? 0;
    double percentage = advertisement.completionRate!.toDouble();
    double fiatAmount =
        double.parse(trimDecimals(advertisement.price!.toString()));
    String cryptoCurrency = adType == stringVariables.buy
        ? advertisement.toAsset!
        : advertisement.fromAsset!;
    String fiatCurrency = adType == stringVariables.buy
        ? advertisement.fromAsset!
        : advertisement.toAsset!;
    double cryptoAmount =
        double.parse(trimDecimals(advertisement.amount!.toString()));
    double minAmount =
        double.parse(trimDecimals(advertisement.minTradeOrder!.toString()));
    double maxAmount =
        double.parse(trimDecimals(advertisement.maxTradeOrder!.toString()));
    List<PaymentMethod> paymentMethod = (advertisement.paymentMethod ?? []);
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    List<Widget> paymentCard = [];
    int paymentCardListCount = paymentMethod.length;
    for (var i = 0; i < paymentCardListCount; i++) {
      paymentCard
          .add(paymentMethodsCard(size, paymentMethod[i].paymentMethodName!));
    }
    print("ad:::${advertisement.name}");

    return GestureDetector(
      onTap: () {
        moveToOrderCreation(
            context, widget.isBuy ?? true, advertisement, currentPage);
      },
      child: CustomContainer(
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15)
              : enableBorder.withOpacity(0.25),
          border: Border.all(color: hintLight, width: 1),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        width: 1,
        height: isSmallScreen(context) ? 3.89 : 4.35,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    moveToCounterProfile(context, advertisement.userId ?? "");
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomContainer(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: themeColor),
                        child: Center(
                            child: CustomText(
                          fontfamily: 'InterTight',
                          text: name!.isNotEmpty ? name[0].toUpperCase() : " ",
                          fontWeight: FontWeight.bold,
                          fontsize: 11,
                          color: black,
                        )),
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomContainer(
                        constraints: BoxConstraints(maxWidth: size.width / 2.4),
                        child: CustomText(
                          fontfamily: 'InterTight',
                          text: name,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 15,
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.005,
                      ),
                      SvgPicture.asset(
                        p2pVerified,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CustomText(
                      fontfamily: 'InterTight',
                      text: "$noOfTrades ${stringVariables.trades}",
                      fontWeight: FontWeight.w400,
                      fontsize: 11,
                    ),
                    CustomSizedBox(
                      width: 0.015,
                    ),
                    CustomContainer(
                      width: size.width * 2,
                      height: 60,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                    CustomSizedBox(
                      width: 0.015,
                    ),
                    CustomText(
                      fontfamily: 'InterTight',
                      text: '$percentage%',
                      fontWeight: FontWeight.w400,
                      fontsize: 11,
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      fontfamily: 'InterTight',
                      text: stringVariables.price,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 13,
                      color: hintLight,
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      fontfamily: 'InterTight',
                      text: "$fiatAmount",
                      fontWeight: FontWeight.w500,
                      fontsize: 25,
                    ),
                    CustomSizedBox(
                      width: 0.015,
                    ),
                    Column(
                      children: [
                        CustomSizedBox(
                          height: 0.01,
                        ),
                        CustomText(
                          fontfamily: 'InterTight',
                          text: fiatCurrency,
                          fontWeight: FontWeight.w400,
                          fontsize: 13,
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                  ],
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        CustomText(
                          fontfamily: 'InterTight',
                          text: stringVariables.cryptoAmount,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 13,
                          color: hintLight,
                        ),
                        CustomSizedBox(
                          width: 0.015,
                        ),
                        CustomContainer(
                          constraints: BoxConstraints(maxWidth: size.width / 4),
                          child: CustomText(
                            fontfamily: 'InterTight',
                            text: "$cryptoAmount $cryptoCurrency",
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 13,
                          ),
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.015,
                    ),
                    Row(
                      children: [
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        CustomText(
                          fontfamily: 'InterTight',
                          text: stringVariables.limit,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 13,
                          color: hintLight,
                        ),
                        CustomSizedBox(
                          width: 0.015,
                        ),
                        Row(
                          children: [
                            CustomText(
                              fontfamily: "",
                              text: currencySymbol,
                              fontWeight: FontWeight.bold,
                              fontsize: 13,
                            ),
                            CustomContainer(
                              constraints:
                                  BoxConstraints(maxWidth: size.width / 5),
                              child: CustomText(
                                fontfamily: 'InterTight',
                                text: " $minAmount",
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontsize: 13,
                              ),
                            ),
                            CustomText(
                              fontfamily: "InterTight",
                              text: " - ",
                              fontWeight: FontWeight.bold,
                              fontsize: 13,
                            ),
                            CustomText(
                              fontfamily: "",
                              text: currencySymbol,
                              fontWeight: FontWeight.bold,
                              fontsize: 13,
                            ),
                            CustomContainer(
                              constraints:
                                  BoxConstraints(maxWidth: size.width / 5),
                              child: CustomText(
                                fontfamily: 'InterTight',
                                text: " $maxAmount",
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                fontsize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        moveToOrderCreation(context, widget.isBuy ?? true,
                            advertisement, currentPage);
                      },
                      child: CustomContainer(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isBuy ? green : red,
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            fontfamily: 'InterTight',
                            text: isBuy
                                ? stringVariables.buy
                                : stringVariables.sell,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 13,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                  ],
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(children: paymentCard),
            CustomSizedBox(
              width: 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({required this.tabBar, required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        Theme(
            data: ThemeData().copyWith(splashColor: Colors.transparent),
            child: tabBar),
      ],
    );
  }
}

class TabBarIndicator extends Decoration {
  final BoxPainter _painter;

  TabBarIndicator({required Color color, required double radius})
      : _painter = _TabBarIndicator(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _TabBarIndicator extends BoxPainter {
  final Paint _paint;
  final double radius;

  _TabBarIndicator(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Offset customOffset = offset +
        Offset(configuration.size!.width / 2, configuration.size!.height - 1);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(
              center: customOffset,
              width: configuration.size!.width,
              height: 2.5),
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
        _paint);
  }
}

Widget paymentMethodsCard(Size size, String title, [bool startingGap = true]) {
  Color cardColor = randomColor();

  if (title == "bank_transfer") title = stringVariables.bankTransfer;
  return Row(
    children: [
      startingGap
          ? CustomSizedBox(
              width: 0.02,
            )
          : CustomSizedBox(
              width: 0,
              height: 0,
            ),
      CustomContainer(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(
            500.0,
          ),
        ),
        width: size.width / 3,
        height: size.height / 14,
      ),
      CustomSizedBox(
        width: 0.01,
      ),
      CustomText(
        fontfamily: 'InterTight',
        text: title,
        fontWeight: FontWeight.w400,
        overflow: TextOverflow.ellipsis,
        fontsize: 13,
        color: hintLight,
      ),
    ],
  );
}

class PopupItem extends PopupMenuItem {
  PopupItem({
    required Widget child,
    required dynamic value,
    Key? key,
  }) : super(key: key, child: child, value: value);

  @override
  _PopupItemState createState() => _PopupItemState();
}

class _PopupItemState extends PopupMenuItemState {
  @override
  void handleTap() {
    switch (widget.value) {
      case "Menu":
        break;
      case "Payment Methods":
        Navigator.pop(context);
        if (constant.userLoginStatus.value)
          moveToPaymentMethods(context);
        else
          customSnackBar.showSnakbar(
              context, stringVariables.loginToContinue, SnackbarType.negative);
        break;
      case "Order History":
        Navigator.pop(context);
        Provider.of<P2PCommonViewModel>(context, listen: false).setActive(1);
        break;
      case "P2P User Center":
        Navigator.pop(context);
        Provider.of<P2PCommonViewModel>(context, listen: false).setActive(3);
        break;
      case "Advertisement Mode":
        Navigator.pop(context);
        Provider.of<P2PCommonViewModel>(context, listen: false).setActive(2);
        break;
      default:
        break;
    }
  }
}
