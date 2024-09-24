import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Exchange/Model/GetBalance.dart';
import 'package:zodeakx_mobile/Common/OrderBook/ViewModel/OrderBookViewModel.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomExchangeSlider.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../Utils/Widgets/keyboard_done_widget.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../../p2p/home/view/p2p_home_view.dart';
import '../../Common/ViewModel/common_view_model.dart';
import '../../Orders/ViewModel/OrdersViewModel.dart';
import '../../SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../Model/AllOpenOrderHistoryModel.dart';
import '../Model/CreateOrder.dart';
import '../ViewModel/ExchangeViewModel.dart';
import 'orderbook_options_bottom_sheet.dart';

class ExchangeView extends StatefulWidget {
  const ExchangeView({
    Key? key,
  }) : super(key: key);

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView>
    with TickerProviderStateMixin {
  late ExchangeViewModel viewModel;
  late OrderBookViewModel orderBookViewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  final TextEditingController _orderTypeController = TextEditingController();
  final TextEditingController _buyTotalController = TextEditingController();
  final TextEditingController _sellTotalController = TextEditingController();
  final TextEditingController _buyMarketController = TextEditingController();
  final TextEditingController _sellMarketController = TextEditingController();
  final GlobalKey orderBuySpotType = GlobalKey();
  final GlobalKey orderSellSpotType = GlobalKey();
  late StreamSubscription<bool> keyboardSubscription;
  int zerosValue = 0;
  bool isLogin = false;
  String old_buy_limit = "";
  String old_sell_limit = "";
  late TabController _spotTabController;
  bool isLite = false;
  String? previousLastPrice = "0";
  FocusNode _buyAmountFocus = FocusNode();
  FocusNode _sellAmountFocus = FocusNode();
  var overlayEntry;
  SiteMaintenanceViewModel? siteMaintenanceViewModel;
  Future<bool> willPopScopeCall() async {
    return false;
  }

  late CommonViewModel commonViewModel;
  @override
  void initState() {
    viewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    orderBookViewModel =
        Provider.of<OrderBookViewModel>(context, listen: false);
    commonViewModel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    isLogin = constant.userLoginStatus.value;
    viewModel.tabController = TabController(length: 2, vsync: this);
    viewModel.tradeTabController = TabController(
        length: 1, vsync: this, initialIndex: viewModel.tradeTabIndex);
    orderBookViewModel.fetchData(false);
    viewModel.fetchData();
    viewModel.tabController.addListener(() {
      clearDatas();
      viewModel.setTabView(viewModel.tabController.index == 0);
      if (viewModel.tradeTabController?.index == 0) {
        if (viewModel.tradeTabIndex == 0) {
          if (viewModel.tabView) {
            viewModel.setOrderType(
                viewModel.orderType.indexOf(viewModel.buySpotOrder));
          } else {
            viewModel.setOrderType(
                viewModel.orderType.indexOf(viewModel.sellSpotOrder));
          }
        }
      }
    });
    _buyTotalController.addListener(() {
      calculateAmountAmount(viewModel.buyAmountController);
    });

    viewModel.buyLimitController.addListener(() {
      calculateTotalAmount(_buyTotalController);
    });

    viewModel.buyAmountController.addListener(() {
      calculateTotalAmount(_buyTotalController);
    });

    viewModel.sellLimitController.addListener(() {
      calculateTotalAmount(_sellTotalController);
    });

    _sellTotalController.addListener(() {
      calculateAmountAmount(viewModel.sellAmountController);
    });
    viewModel.sellAmountController.addListener(() {
      calculateTotalAmount(_sellTotalController);
    });

    _spotTabController = TabController(length: 1, vsync: this);
    viewModel.tradeTabController?.addListener(() {
      viewModel.setTradeTabIndex(viewModel.tradeTabController?.index ?? 0);
      if (viewModel.tradeTabController?.index == 0) {}
    });

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      viewModel.setKeyboardVisibility(visible);
      if (Platform.isIOS) {
        if (!visible) {
          removeOverlay();
        } else {
          showOverlay(context);
        }
      }
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonViewModel.getLiquidityStatus("ExchangeView");
      viewModel.setTradeTabIndex(0);
      siteMaintenanceViewModel?.getSiteMaintenanceStatus();
      clearDatas();
      viewModel.setOrderType(0);
      viewModel.setTabView(true);
    });
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (constant.okxStatus.value) {
      viewModel.unSubscribeChannel();
    } else if (constant.binanceStatus.value) {
      viewModel.leaveSocket();
    }
    siteMaintenanceViewModel?.leaveSocket();
    super.dispose();
  }

  clearDatas() {
    _orderTypeController.clear();
    _buyTotalController.clear();
    viewModel.buyAmountController.clear();
    _sellTotalController.clear();
    viewModel.sellAmountController.clear();
    _buyMarketController.clear();
    _sellMarketController.clear();
    viewModel.setBuySliderValue(0);
    viewModel.setSellSliderValue(0);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ExchangeViewModel>();
    orderBookViewModel = context.watch<OrderBookViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();
    isLogin = constant.userLoginStatus.value;
    Size size = MediaQuery.of(context).size;
    return Provider<ExchangeViewModel>(
      create: (context) => viewModel,
      child: buildExchangeView(size),
    );
  }

  Widget buildExchangeView(Size size) {
    return WillPopScope(
      onWillPop: willPopScopeCall,
      child: CustomScaffold(
        color: themeSupport().isSelectedDarkMode()
            ? darkScaffoldColor
            : lightScaffoldColor,
        appBar: AppHeader(context),
        child: viewModel.needToLoad || orderBookViewModel.needToLoad
            ? const Center(child: CustomLoader())
            : buildProView(size),
      ),
    );
  }

  Widget buildProView(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
      child: CustomContainer(
        width: 1,
        height: 1,
        child: Column(
          children: [
            Flexible(
              child: TabBarView(
                controller: viewModel.tradeTabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildSpotTab(size),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSpotTab(Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: CustomContainer(
        width: 1,
        height: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPairAndTrade(size),
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSpotRightContent(size),
                      CustomSizedBox(
                        width: 0.03,
                      ),
                      buildSpotLeftContent(size),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spotTabBar(size),
                  viewModel.tabLoader
                      ? Flexible(
                          child: CustomContainer(
                              width: 1, height: 1, child: CustomLoader()),
                        )
                      : spotTabBarView(size),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget noOrderHistory() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: 0.03,
          ),
          CustomText(
            fontfamily: 'InterTight',
            fontsize: 18,
            fontWeight: FontWeight.w500,
            text: stringVariables.noOpenOrders,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'InterTight',
            fontsize: 14,
            fontWeight: FontWeight.w400,
            text: stringVariables.newOpenOrdersWillAppear,
            color: themeSupport().isSelectedDarkMode()
                ? contentFontColor
                : hintTextColor,
          ),
        ],
      ),
    );
  }

  Widget spotTabBarView(Size size) {
    int? openOrderHistoryCount = viewModel.allOpenOrderHistory!.isNotEmpty
        ? viewModel.allOpenOrderHistory!.length >= 3
            ? 3
            : viewModel.allOpenOrderHistory?.length
        : 0;
    List<AllOpenOrderHistory> allOpenOrderHistory =
        viewModel.allOpenOrderHistory ?? [];
    List<Widget> historyCards = [];
    for (var i = 0; i < (openOrderHistoryCount ?? 0); i++) {
      historyCards
          .add(buildOpenOrdersCard(size, allOpenOrderHistory[i], i == 3));
    }
    return Flexible(
      child: CustomContainer(
        width: 1,
        height: 1,
        child: openOrderHistoryCount != 0
            ? TabBarView(controller: _spotTabController, children: [
                SingleChildScrollView(
                  child: Column(
                    children: historyCards,
                  ),
                )
              ])
            : noOrderHistory(),
      ),
    );
  }

  Widget buildOpenOrdersCard(
      Size size, AllOpenOrderHistory allOpenOrderHistory, bool isLast,
      [bool isMargin = false]) {
    String id = allOpenOrderHistory.id ?? "";
    String tradeType = allOpenOrderHistory.tradeType ?? "";
    String orderedDate = allOpenOrderHistory.orderedDate.toString();
    String status = allOpenOrderHistory.status ?? "";
    String pair = allOpenOrderHistory.pair ?? "/";
    String fromCurrency = pair.split("/").first;
    String toCurrency = pair.split("/").last;
    num initialAmo = allOpenOrderHistory.initialAmount ?? 0;
    num amou = allOpenOrderHistory.amount ?? 0;
    String initialAmount = allOpenOrderHistory.initialAmount.toString();
    String amount = allOpenOrderHistory.amount.toString();
    num filled = initialAmo - amou;

    num marketPrice = allOpenOrderHistory.marketPrice ?? 0;
    num total = allOpenOrderHistory.total ?? 0;

    num amountFilled = filled + amou;
    num percentageAmount = filled / amountFilled;

    String percentage =
        double.parse(trimDecimals((filled / initialAmo * 100).toString()))
            .toInt()
            .toString();
    return GestureDetector(
      onTap: () {
        moveToExchangeOrderDetailsView(context, allOpenOrderHistory);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: CustomContainer(
              width: 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: themeSupport().isSelectedDarkMode()
                    ? darkCardColor
                    : lightCardColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: tradeType,
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 17,
                          color: tradeType.toLowerCase() ==
                                  stringVariables.buy.toLowerCase()
                              ? green
                              : red,
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          text: getDate(orderedDate),
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 14,
                          fontWeight: FontWeight.w500,
                          color: textGrey,
                        ),
                      ],
                    ),
                    Divider(
                      color: themeSupport().isSelectedDarkMode()
                          ? minusDarkColor
                          : minusLightColor,
                      thickness: 1,
                    ),
                    CustomSizedBox(
                      height: 0.002,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: fromCurrency,
                              softwrap: true,
                              overflow: TextOverflow.ellipsis,
                              fontsize: 16.5,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomSizedBox(
                              width: 0.004,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: CustomText(
                                text: "/",
                                fontsize: 15,
                                color: stackCardText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CustomSizedBox(
                              width: 0.002,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: CustomText(
                                text: toCurrency,
                                fontsize: 15.5,
                                color: stackCardText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            CustomContainer(
                              height: 40,
                              width: 9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: newButtonColor,
                              ),
                              child: Center(
                                child: CustomText(
                                  text: status.toLowerCase() ==
                                          stringVariables.filled.toLowerCase()
                                      ? "  " + stringVariables.completed
                                      : capitalize(status),
                                  softwrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  fontsize: 13,
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomElevatedButton(
                          press: () {
                            OrdersViewModel ordersViewModel =
                                Provider.of<OrdersViewModel>(context,
                                    listen: false);
                            ordersViewModel.setOpenCounter(
                                ordersViewModel.openCounter - 1);
                            ordersViewModel.cancelOrder(id, context);
                          },
                          color: white,
                          text: stringVariables.cancel,
                          width: 5,
                          isBorderedButton: false,
                          maxLines: 1,
                          icon: null,
                          radius: 15,
                          height: MediaQuery.of(context).size.height / 25,
                          icons: false,
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                          buttoncolor: cancelRed,
                        )
                      ],
                    ),
                    Divider(
                      color: themeSupport().isSelectedDarkMode()
                          ? minusDarkColor
                          : minusLightColor,
                      thickness: 1,
                    ),
                    CustomSizedBox(
                      height: 0.002,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: CustomContainer(
                            width: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildOpenOrderAmount(
                                  stringVariables.amount,
                                  trimDecimals(filled.toString()),
                                  fromCurrency,
                                  trimDecimals(initialAmount.toString()),
                                ),
                                CustomSizedBox(
                                  height: 0.005,
                                ),
                                buildOpenOrderAmount(
                                    stringVariables.price,
                                    trimDecimals(marketPrice.toString()),
                                    toCurrency),
                                CustomSizedBox(
                                  height: 0.005,
                                ),
                                buildOpenOrderAmount(stringVariables.total,
                                    trimDecimals(total.toString()), toCurrency),
                              ],
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.03,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomSizedBox(
                              height: 0.05,
                              width: 0.12,
                              child: CircularProgressIndicator(
                                value: double.parse(percentage) / 100,
                                backgroundColor:
                                    themeSupport().isSelectedDarkMode()
                                        ? minusDarkColor
                                        : minusLightColor,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.green),
                                strokeWidth: 3.5,
                              ),
                            ),
                            CustomText(
                              color: green,
                              text: percentage + "%",
                              softwrap: true,
                              overflow: TextOverflow.ellipsis,
                              fontsize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
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

  buildOpenOrderAmount(String content1, String content2, String content3,
      [String? content4]) {
    return Row(
      children: [
        Flexible(
          flex: 6,
          child: CustomContainer(
            width: 1,
            child: CustomText(
              fontfamily: 'InterTight',
              text: content1 + ":",
              fontsize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          flex: 11,
          child: CustomContainer(
            width: 1,
            child: content4 != null
                ? Row(
                    children: [
                      CustomText(
                        fontfamily: 'InterTight',
                        text: content2,
                        fontsize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: CustomText(
                          text: "/",
                          fontsize: 13.5,
                          fontfamily: 'InterTight',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.005,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: CustomText(
                          text: content4,
                          fontsize: 13.5,
                          fontfamily: 'InterTight',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.005,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: CustomText(
                          fontfamily: 'InterTight',
                          text: content3,
                          fontsize: 13,
                          color: textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CustomText(
                        fontfamily: 'InterTight',
                        text: content2,
                        fontsize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomSizedBox(
                        width: 0.005,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        text: content3,
                        fontsize: 13.5,
                        color: textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget spotTabBar(Size size) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        DecoratedTabBar(
          tabBar: TabBar(
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              fontFamily: 'InterTight',
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: 'InterTight',
            ),
            indicatorWeight: 0,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            indicator: TabBarIndicator(color: themeColor, radius: 1),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            automaticIndicatorColorAdjustment: true,
            labelColor:
                themeSupport().isSelectedDarkMode() ? white : themeColor,
            unselectedLabelColor: hintLight,
            controller: _spotTabController,
            tabAlignment: TabAlignment.start,
            tabs: buildSpotBar(),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
          ),
        ),
        CustomContainer(
          height: size.width,
          color: hintLight.withOpacity(0.25),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Provider.of<CommonViewModel>(
                        NavigationService.navigatorKey.currentContext!,
                        listen: false)
                    .setActive(2);
              },
              behavior: HitTestBehavior.opaque,
              child: CustomContainer(
                  padding: 4,
                  width: 15,
                  height: 22,
                  child: SvgPicture.asset(history)),
            ),
            CustomSizedBox(
              width: 0.01,
            ),
          ],
        )
      ],
    );
  }

  buildSpotBar() {
    int count = viewModel.allOpenOrderHistory?.length ?? 0;
    return [
      Tab(
        text: stringVariables.openOrders + " ($count)",
      ),
    ];
  }

  Widget noRecords() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSizedBox(
          height: 0.025,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomText(
            align: TextAlign.center,
            text: stringVariables.notFound,
            fontsize: 15,
            fontWeight: FontWeight.bold,
            fontfamily: 'InterTight',
          ),
        ),
        CustomSizedBox(
          height: 0.025,
        ),
      ],
    );
  }

  Widget buildSpotRightContent(Size size) {
    String order =
        viewModel.tabView ? viewModel.buySpotOrder : viewModel.sellSpotOrder;
    return Flexible(
        flex: 4,
        child:
            CustomContainer(width: 1, child: buildMiniOrderBook(size, order)));
  }

  Widget buildMiniOrderBook(Size size, String order) {
    int bothCount = (order == stringVariables.limit) ? 6 : 5;
    int singleCount = (order == stringVariables.limit) ? 12 : 10;
    int itemCount = (viewModel.viewFilter[0] ? bothCount : singleCount);
    int buyOrdersSize = (orderBookViewModel.getOpenOrders != null)
        ? orderBookViewModel.getOpenOrders!.bids!.length > itemCount
            ? itemCount
            : orderBookViewModel.getOpenOrders!.bids!.length
        : 0;
    int sellOrdersSize = (orderBookViewModel.getOpenOrders != null)
        ? orderBookViewModel.getOpenOrders!.asks!.length >
                (viewModel.viewFilter[0] ? bothCount : singleCount)
            ? (viewModel.viewFilter[0] ? bothCount : singleCount)
            : orderBookViewModel.getOpenOrders!.asks!.length
        : 0;
    List<List<dynamic>>? buyOrders = (orderBookViewModel.getOpenOrders != null)
        ? orderBookViewModel.getOpenOrders!.bids!.reversed.toList()
        : [];
    List<List<dynamic>>? sellOrders = (orderBookViewModel.getOpenOrders != null)
        ? (viewModel.viewFilter[1]
            ? orderBookViewModel.getOpenOrders!.asks!.toList()
            : orderBookViewModel.getOpenOrders!.asks!.reversed
                .take(300)
                .toList())
        : [];
    ListOfTradePairs priceTickers =
        viewModel.viewModelpriceTickersModel?[0] ?? ListOfTradePairs();
    // securedPrint("priceTickers.lastPrice${priceTickers.lastPrice}");
    if (double.parse(previousLastPrice!) !=
        double.parse(priceTickers.lastPrice ?? "0")) {
      if (double.parse(previousLastPrice!) <
          double.parse(priceTickers.lastPrice ?? "0")) {
        orderBookViewModel.setBuySellFlag(true);
      } else {
        orderBookViewModel.setBuySellFlag(false);
      }
      previousLastPrice = priceTickers.lastPrice ?? "0";
    }
    String? fiatCurrency =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';

    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    List<Widget> buyCards = [];

    for (var i = 0; i < itemCount; i++) {
      buyCards.add(buildOrderBookText(buyOrders, i));
    }
    List<Widget> sellCards = [];
    for (var i = 0; i < itemCount; i++) {
      sellCards.add(buildOrderBookText(sellOrders, i, false));
    }
    String orderBook = viewModel.viewFilter[0]
        ? showBuySell
        : viewModel.viewFilter[1]
            ? showBuyOnly
            : showSellOnly;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHeaderForOrder(stringVariables.price, viewModel.toCurrency),
            buildHeaderForOrder(
                stringVariables.amount, viewModel.fromCurrency, false),
          ],
        ),
        CustomSizedBox(
          height: 0.0075,
        ),
        viewModel.viewFilter[1]
            ? SizedBox.shrink()
            : sellOrdersSize == 0
                ? noRecords()
                : Column(
                    verticalDirection: VerticalDirection.up,
                    children: sellCards,
                  ),
        viewModel.viewFilter[0]
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSizedBox(
                    height: 0.0095,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    fontsize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    text: trimDecimals(priceTickers.lastPrice ?? '0'),
                    color: orderBookViewModel.buySellFlag ? green : red,
                  ),
                  CustomSizedBox(
                    height: 0.0095,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        fontfamily: '',
                        fontsize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        text: currencySymbol,
                        color: textGrey,
                      ),
                      CustomSizedBox(
                        width: 0.0025,
                      ),
                      CustomText(
                        fontfamily: "InterTight",
                        fontsize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        text:
                            "${trimDecimals(viewModel.estimateFiatValue.toString() ?? "0")}",
                        color: textGrey,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.018,
                  ),
                ],
              )
            : SizedBox.shrink(),
        viewModel.viewFilter[2]
            ? SizedBox.shrink()
            : buyOrdersSize == 0
                ? noRecords()
                : Column(
                    children: buyCards,
                  ),
        viewModel.viewFilter[0]
            ? SizedBox.shrink()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    fontsize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    text: trimDecimals(priceTickers.lastPrice ?? '0'),
                    color: orderBookViewModel.buySellFlag ? green : red,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        fontfamily: '',
                        fontsize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        text: currencySymbol,
                        color: textGrey,
                      ),
                      CustomSizedBox(
                        width: 0.0025,
                      ),
                      CustomText(
                        fontfamily: "InterTight",
                        fontsize: 12,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                        text:
                            "${trimDecimals(viewModel.estimateFiatValue.toString() ?? "0")}",
                        color: textGrey,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.005,
                  ),
                ],
              ),
        CustomSizedBox(
          height: 0.0075,
        ),
        Row(
          children: [
            Flexible(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  _showOrderbookModel(1);
                },
                behavior: HitTestBehavior.opaque,
                child: CustomContainer(
                  width: 1,
                  height: size.height / 30,
                  decoration: BoxDecoration(
                    color: themeSupport().isSelectedDarkMode()
                        ? marketCardColor
                        : inputColor,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          fontfamily: 'InterTight',
                          text: viewModel.selectedDecimals,
                          fontsize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        SvgPicture.asset(
                          dropDownArrowImage,
                          color: hintLight,
                          width: 5,
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  _showOrderbookModel(0);
                },
                behavior: HitTestBehavior.opaque,
                child: CustomContainer(
                  padding: 7,
                  width: 1,
                  height: size.height / 30,
                  decoration: BoxDecoration(
                    color: themeSupport().isSelectedDarkMode()
                        ? marketCardColor
                        : inputColor,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: SvgPicture.asset(
                    orderBook,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildOrderBookText(List<List<dynamic>> ordersList, int index,
      [bool isBuy = true]) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _buyAmountFocus.unfocus();
            _sellAmountFocus.unfocus();
            if (ordersList.length < (index + 1)) {
            } else {
              if (viewModel.selectedOrderType == 1) {
                return;
              }
              if (isBuy) {
                viewModel.setTabView(true);
                viewModel.tabController.index = 0;
                if (viewModel.tradeTabIndex == 0) {
                  viewModel.buyLimitController.text =
                      trimDecimals(ordersList[index].first.toString());
                }
              } else {
                viewModel.setTabView(false);
                viewModel.tabController.index = 1;
                if (viewModel.tradeTabIndex == 0) {
                  viewModel.sellLimitController.text =
                      trimDecimals(ordersList[index].first.toString());
                }
              }
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: ordersList.length < (index + 1)
                    ? ""
                    : trimAsLength(ordersList[index].first.toString(),
                        viewModel.selectedDecimals.split(".").last.length),
                color: isBuy ? green : red,
                fontfamily: 'InterTight',
                fontsize: 11.5,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              CustomText(
                text: ordersList.length < (index + 1)
                    ? ""
                    : trimAsLength(
                        ordersList[index].last.toString(),
                        (ordersList[index]
                                        .last
                                        .toString()
                                        .split(".")
                                        .first
                                        .length >
                                    3 &&
                                viewModel.selectedDecimals
                                        .split(".")
                                        .last
                                        .length >
                                    4)
                            ? 2
                            : viewModel.selectedDecimals
                                .split(".")
                                .last
                                .length),
                color: themeSupport().isSelectedDarkMode() ? white : black,
                fontfamily: 'InterTight',
                fontsize: 11.5,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.005,
        )
      ],
    );
  }

  Widget buildHeaderForOrder(String title, String currency,
      [bool isStart = true]) {
    return Column(
      crossAxisAlignment:
          isStart ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        CustomText(
            fontfamily: 'InterTight',
            fontsize: 13,
            color: textGrey,
            fontWeight: FontWeight.w500,
            text: title),
        CustomSizedBox(
          height: 0.005,
        ),
        CustomText(
            fontfamily: "InterTight",
            fontsize: 13,
            color: textGrey,
            fontWeight: FontWeight.w500,
            text: "(${currency})"),
      ],
    );
  }

  Widget buildSpotLeftContent(Size size) {
    return Flexible(
        flex: 6,
        child: CustomContainer(
          width: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomContainer(
                height: size.height / 38,
                decoration: BoxDecoration(
                  color: themeSupport().isSelectedDarkMode()
                      ? marketCardColor
                      : inputColor,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                child: TabBar(
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorWeight: 0,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  controller: viewModel.tabController,
                  indicator: BoxDecoration(),
                  labelColor: white,
                  unselectedLabelColor: hintLight,
                  tabs: [
                    Tab(
                      height: 250,
                      child: CustomContainer(
                        height: 1,
                        width: 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: viewModel.tabView
                                ? green
                                : themeSupport().isSelectedDarkMode()
                                    ? null
                                    : enableBorder.withOpacity(0.35)),
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomText(
                              fontfamily: 'InterTight',
                              fontsize: 13,
                              color: viewModel.tabView ? white : hintLight,
                              text: stringVariables.buy),
                        ),
                      ),
                    ),
                    Tab(
                      height: 250,
                      child: CustomContainer(
                        height: 1,
                        width: 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: viewModel.tabView
                                ? themeSupport().isSelectedDarkMode()
                                    ? null
                                    : enableBorder.withOpacity(0.35)
                                : red),
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomText(
                              fontfamily: 'InterTight',
                              fontsize: 13,
                              color: viewModel.tabView ? hintLight : white,
                              text: stringVariables.sell),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              CustomContainer(
                height: (viewModel.selectedOrderType == 1)
                    ? isSmallScreen(context)
                        ? 3.9
                        : 4.65
                    : isSmallScreen(context)
                        ? 3.4
                        : 4,
                //  color: red,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: viewModel.tabController,
                  children: [
                    buildProBuyView(
                      size,
                      orderBuySpotType,
                      onBuySpotSelected,
                      viewModel.buySpotOrder,
                      viewModel.buyLimitController,
                      viewModel.buyAmountController,
                      _buyTotalController,
                    ),
                    buildProSellView(
                      size,
                      orderSellSpotType,
                      onSellSpotSelected,
                      viewModel.sellSpotOrder,
                      viewModel.sellLimitController,
                      viewModel.sellAmountController,
                      _sellTotalController,
                    ),
                  ],
                ),
              ),
              CustomSizedBox(
                height: 0.0075,
              ),
              buildProShowBalance(size),
              CustomSizedBox(
                height: 0.015,
              ),
              buildProSpotButton(size)
            ],
          ),
        ));
  }

  Widget buildProSpotButton(size) {
    ListOfTradePairs priceTickers =
        viewModel.viewModelpriceTickersModel?[0] ?? ListOfTradePairs();
    return isLogin
        ? CustomElevatedButton(
            text: viewModel.tabView
                ? stringVariables.buy + " " + viewModel.fromCurrency
                : stringVariables.sell + " " + viewModel.fromCurrency,
            radius: 10,
            buttoncolor: viewModel.tabView ? green : red,
            fillColor: viewModel.tabView ? green : red,
            width: 1.95,
            height: 18,
            isBorderedButton: false,
            blurRadius: 0,
            spreadRadius: 0,
            maxLines: 1,
            icons: false,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            icon: null,
            color: white,
            multiClick: true,
            press: () {
              if (viewModel.tabView) {
                CreateOrder createOrder;
                var limit, total;
                var amount = viewModel.buyAmountController.text.isEmpty
                    ? double.parse("0")
                    : double.parse(viewModel.buyAmountController.text);
                if (viewModel.selectedOrderType != 1) {
                  limit = viewModel.buyLimitController.text.isEmpty
                      ? double.parse("0")
                      : double.parse(viewModel.buyLimitController.text);
                  total = _buyTotalController.text.isEmpty
                      ? double.parse("0")
                      : double.parse(_buyTotalController.text);
                }

                switch (viewModel.selectedOrderType) {
                  case 0:
                    createOrder = CreateOrder(
                        order_type: stringVariables.limit,
                        trade_type: stringVariables.buy,
                        pair: priceTickers.symbol!,
                        amount: amount,
                        market_price: limit,
                        total: total);
                    break;
                  case 1:
                    createOrder = CreateOrder(
                      order_type: stringVariables.markets,
                      trade_type: stringVariables.buy,
                      pair: priceTickers.symbol!,
                      amount: amount,
                    );
                    break;
                  default:
                    createOrder = CreateOrder(
                        order_type: stringVariables.limit,
                        trade_type: stringVariables.buy,
                        pair: priceTickers.symbol!,
                        amount: amount,
                        market_price: limit,
                        total: total);
                    break;
                }

                if (viewModel.selectedOrderType == 0) {
                  if (viewModel.buyLimitController.text.isNotEmpty &&
                      viewModel.buyAmountController.text.isNotEmpty) {
                    viewModel.createMarginOrder(context, createOrder);
                  } else {
                    customSnackBar.showSnakbar(
                        context,
                        stringVariables.provideValidData,
                        SnackbarType.negative);
                  }
                } else if (viewModel.selectedOrderType == 1) {
                  if (viewModel.buyAmountController.text.isNotEmpty) {
                    viewModel.createMarginOrder(context, createOrder);
                  } else {
                    customSnackBar.showSnakbar(
                        context,
                        stringVariables.provideValidData,
                        SnackbarType.negative);
                  }
                } else {
                  customSnackBar.showSnakbar(context,
                      stringVariables.provideValidData, SnackbarType.negative);
                }
              } else {
                CreateOrder createOrder;
                var limit, total;
                var amount = viewModel.sellAmountController.text.isEmpty
                    ? double.parse("0")
                    : double.parse(viewModel.sellAmountController.text);
                if (viewModel.selectedOrderType != 1) {
                  limit = viewModel.sellLimitController.text.isEmpty
                      ? double.parse("0")
                      : double.parse(viewModel.sellLimitController.text);
                  total = _sellTotalController.text.isEmpty
                      ? double.parse("0")
                      : double.parse(_sellTotalController.text);
                }

                switch (viewModel.selectedOrderType) {
                  case 0:
                    createOrder = CreateOrder(
                        order_type: stringVariables.limit,
                        trade_type: stringVariables.sell,
                        pair: priceTickers.symbol!,
                        amount: amount,
                        market_price: limit,
                        total: total);
                    break;
                  case 1:
                    createOrder = CreateOrder(
                      order_type: stringVariables.markets,
                      trade_type: stringVariables.sell,
                      pair: priceTickers.symbol!,
                      amount: amount,
                    );
                    break;
                  default:
                    createOrder = CreateOrder(
                        order_type: stringVariables.limit,
                        trade_type: stringVariables.sell,
                        pair: priceTickers.symbol!,
                        amount: amount,
                        market_price: limit,
                        total: total);
                    break;
                }
                if (viewModel.selectedOrderType == 0) {
                  if (viewModel.sellLimitController.text.isNotEmpty &&
                      viewModel.sellAmountController.text.isNotEmpty) {
                    viewModel.createMarginOrder(context, createOrder);
                  } else {
                    customSnackBar.showSnakbar(
                        context,
                        stringVariables.provideValidData,
                        SnackbarType.negative);
                  }
                } else if (viewModel.selectedOrderType == 1) {
                  if (viewModel.sellAmountController.text.isNotEmpty) {
                    viewModel.createMarginOrder(context, createOrder);
                  } else {
                    customSnackBar.showSnakbar(
                        context,
                        stringVariables.provideValidData,
                        SnackbarType.negative);
                  }
                } else {
                  customSnackBar.showSnakbar(context,
                      stringVariables.provideValidData, SnackbarType.negative);
                }
              }
            },
          )
        : CustomElevatedButton(
            text: stringVariables.login,
            radius: 10,
            buttoncolor: themeColor,
            fillColor: themeColor,
            width: 1.95,
            height: 18,
            isBorderedButton: false,
            blurRadius: 0,
            spreadRadius: 0,
            maxLines: 1,
            icons: false,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            icon: null,
            color: white,
            multiClick: true,
            press: navigateToLogin,
          );
  }

  navigateToLogin() {
    constant.previousScreen.value = ScreenType.Exchange;
    if (constant.binanceStatus.value) {
      viewModel.leaveSocket();
    }
    moveToRegister(context, true);
  }

  onBuySpotSelected(value) {
    viewModel.setBuySpotOrder(value);
    viewModel.setOrderType(viewModel.orderType.indexOf(value));
  }

  onSellSpotSelected(value) {
    viewModel.setSellSpotOrder(value);
    viewModel.setOrderType(viewModel.orderType.indexOf(value));
  }

  Widget buildProBuyView(
    Size size,
    GlobalKey orderType,
    ValueChanged onSelected,
    String order,
    TextEditingController buyLimitController,
    TextEditingController buyAmountController,
    TextEditingController buyTotalController,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            dynamic state = orderType.currentState;
            state.showButtonMenu();
          },
          behavior: HitTestBehavior.opaque,
          child: CustomContainer(
            height: size.height / 36,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? marketCardColor
                  : inputColor,
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SvgPicture.asset(
                      toolTipIcon,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                      fontWeight: FontWeight.w500,
                      fontfamily: 'InterTight',
                      fontsize: 13,
                      text: order),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: AbsorbPointer(
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      key: orderType,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      offset: Offset(0, size.height / 22.5),
                      constraints: new BoxConstraints(
                        minWidth: size.width / 1.9,
                        maxWidth: size.width / 1.9,
                        minHeight: (size.height / 12),
                        maxHeight: (size.height / 3.75),
                      ),
                      onSelected: onSelected,
                      iconSize: 0,
                      color: themeSupport().isSelectedDarkMode()
                          ? card_dark
                          : grey,
                      itemBuilder: (
                        BuildContext context,
                      ) {
                        return viewModel.orderType
                            .map<PopupMenuItem<String>>((String? value) {
                          return PopupMenuItem(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    fontsize: 16,
                                    fontfamily: 'InterTight',
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: SvgPicture.asset(
                      dropDownArrowImage,
                      color: hintLight,
                      height: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        order != stringVariables.markets
            ? CustomContainer(
                height: size.height / 36,
                decoration: BoxDecoration(
                  color: themeSupport().isSelectedDarkMode()
                      ? marketCardColor
                      : inputColor,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                child: Center(
                  child: buildProAmountField(
                      size,
                      "${stringVariables.limit} (${viewModel.toCurrency})",
                      buyLimitController,
                      0.01),
                ))
            : CustomContainer(
                height: size.height / 36,
                decoration: BoxDecoration(
                  color: themeSupport().isSelectedDarkMode()
                      ? marketCardColor
                      : inputColor,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                child: Center(
                  child: CustomText(
                    text: stringVariables.marketPrice,
                    color: stackCardText,
                    fontsize: 13,
                  ),
                )),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomContainer(
            height: size.height / 36,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? marketCardColor
                  : inputColor,
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Center(
              child: buildProAmountField(
                  size,
                  "${stringVariables.amount} (${viewModel.fromCurrency})",
                  buyAmountController,
                  0.0001,
                  _buyAmountFocus),
            )),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomContainer(
            height: size.height / 36,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? marketCardColor
                  : inputColor,
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Center(
              child: TextFormField(
                style: TextStyle(
                  fontFamily: 'InterTight',
                  fontSize: 13,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                  fontWeight: FontWeight.w500,
                ),
                controller: buyTotalController,
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.only(bottom: 13.5),
                  errorStyle: TextStyle(color: red),
                  hintText:
                      stringVariables.total + " (${viewModel.toCurrency})",
                  hintStyle: TextStyle(
                    fontFamily: "InterTight",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textGrey,
                  ),
                ),
              ),
            )),
        CustomSizedBox(
          height: 0.03,
        ),
        if (order != stringVariables.markets)
          buildSliderWithLabel(size, viewModel.buySliderValue),
        // Column(
        //   children: [
        //
        //     // CustomContainer(
        //     //   width: 1,
        //     //   child: Row(
        //     //     children: [
        //     //       buildSliderCard(1),
        //     //       CustomSizedBox(
        //     //         width: 0.02,
        //     //       ),
        //     //       buildSliderCard(2),
        //     //       CustomSizedBox(
        //     //         width: 0.02,
        //     //       ),
        //     //       buildSliderCard(3),
        //     //       CustomSizedBox(
        //     //         width: 0.02,
        //     //       ),
        //     //       buildSliderCard(4),
        //     //       CustomSizedBox(
        //     //         width: 0.02,
        //     //       ),
        //     //     ],
        //     //   ),
        //     // ),
        //   ],
        // ),
      ],
    );
  }

  Widget buildSliderWithLabel(Size size, double sliderValue) {
    return buildSliderBuy(size, sliderValue);
  }

  Widget buildSliderBuy(Size size, double sliderValue) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              trackHeight: 1,
              trackShape: GradientRectSliderTrackShape(
                  gradient: LinearGradient(
                    colors: themeSupport().isSelectedDarkMode()
                        ? darkButtonGradient
                        : lightButtonGradient,
                  ),
                  darkenInactive: false),
              activeTrackColor: themeSupport().isSelectedDarkMode()
                  ? minusDarkColor
                  : minusLightColor,
              inactiveTrackColor: themeSupport().isSelectedDarkMode()
                  ? minusDarkColor
                  : minusLightColor,
              thumbShape: SliderThumbShape(disabledThumbRadius: 3),
              overlayColor: hintTextColor.withOpacity(0.2),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
              tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 6),
              activeTickMarkColor: themeColor,
              inactiveTickMarkColor: themeSupport().isSelectedDarkMode()
                  ? minusDarkColor
                  : minusLightColor),
          child: Slider(
              min: 0.0,
              max: 100.0,
              value: sliderValue,
              divisions: 4,
              onChanged: (value) {
                viewModel.tabView
                    ? viewModel.setBuySliderValue(value)
                    : viewModel.setSellSliderValue(value);
                switch (value.round()) {
                  case 25:
                    setAmountValueUsingSlider(4);
                    break;
                  case 50:
                    setAmountValueUsingSlider(2);
                    break;
                  case 75:
                    setAmountValueUsingSlider(0);
                    break;
                  case 100:
                    setAmountValueUsingSlider(1);
                    break;
                  default:
                    if (viewModel.tabView) {
                      _buyTotalController.text = "";
                    } else {
                      _sellTotalController.text = "";
                    }
                    break;
                }
              }),
        ),
      ],
    );
  }

  Widget buildProSellView(
    Size size,
    GlobalKey orderType,
    ValueChanged onSelected,
    String order,
    TextEditingController sellLimitController,
    TextEditingController sellAmountController,
    TextEditingController sellTotalController,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            dynamic state = orderType.currentState;
            state.showButtonMenu();
          },
          behavior: HitTestBehavior.opaque,
          child: CustomContainer(
            height: size.height / 36,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? marketCardColor
                  : inputColor,
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SvgPicture.asset(
                      toolTipIcon,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                      fontWeight: FontWeight.w500,
                      fontfamily: 'InterTight',
                      fontsize: 13,
                      text: order),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: AbsorbPointer(
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      key: orderType,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      offset: Offset(0, size.height / 22.5),
                      constraints: new BoxConstraints(
                        minWidth: size.width / 1.9,
                        maxWidth: size.width / 1.9,
                        minHeight: (size.height / 12),
                        maxHeight: (size.height / 3.75),
                      ),
                      onSelected: onSelected,
                      iconSize: 0,
                      color: themeSupport().isSelectedDarkMode()
                          ? card_dark
                          : grey,
                      itemBuilder: (
                        BuildContext context,
                      ) {
                        return viewModel.orderType
                            .map<PopupMenuItem<String>>((String? value) {
                          return PopupMenuItem(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    fontsize: 16,
                                    fontfamily: 'InterTight',
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: SvgPicture.asset(
                      dropDownArrowImage,
                      color: hintLight,
                      height: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        order != stringVariables.markets
            ? CustomContainer(
                height: size.height / 36,
                decoration: BoxDecoration(
                  color: themeSupport().isSelectedDarkMode()
                      ? marketCardColor
                      : inputColor,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                child: Center(
                  child: buildProAmountField(
                      size,
                      stringVariables.limit + " (${viewModel.toCurrency})",
                      sellLimitController,
                      0.01),
                ))
            : CustomContainer(
                height: size.height / 36,
                decoration: BoxDecoration(
                  color: themeSupport().isSelectedDarkMode()
                      ? marketCardColor
                      : inputColor,
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                child: Center(
                  child: CustomText(
                    text: stringVariables.marketPrice,
                    color: stackCardText,
                    fontsize: 13,
                  ),
                )),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomContainer(
            height: size.height / 36,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? marketCardColor
                  : inputColor,
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Center(
              child: buildProAmountField(
                  size,
                  stringVariables.amount + " (${viewModel.fromCurrency})",
                  sellAmountController,
                  0.0001,
                  _sellAmountFocus),
            )),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomContainer(
            height: size.height / 36,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? marketCardColor
                  : inputColor,
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Center(
              child: TextFormField(
                style: TextStyle(
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'InterTight',
                  fontSize: 13,
                ),
                controller: sellTotalController,
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  errorStyle: TextStyle(color: red),
                  contentPadding: EdgeInsets.only(bottom: 13.5),
                  hintText:
                      stringVariables.total + " (${viewModel.toCurrency})",
                  hintStyle: TextStyle(
                    fontFamily: "InterTight",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textGrey,
                  ),
                ),
              ),
            )),
        CustomSizedBox(
          height: 0.03,
        ),
        if (order != stringVariables.markets)
          buildSliderWithLabel(size, viewModel.sellSliderValue),
        // CustomContainer(
        //   width: 1,
        //   child: Row(
        //     children: [
        //       buildSliderCard(1),
        //       CustomSizedBox(
        //         width: 0.02,
        //       ),
        //       buildSliderCard(2),
        //       CustomSizedBox(
        //         width: 0.02,
        //       ),
        //       buildSliderCard(3),
        //       CustomSizedBox(
        //         width: 0.02,
        //       ),
        //       buildSliderCard(4),
        //       CustomSizedBox(
        //         width: 0.02,
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget buildSpotView(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35, vertical: 10),
      child: CustomContainer(
        width: 1,
        height: 1,
        child: CustomCard(
          outerPadding: 0,
          edgeInsets: 0,
          radius: 25,
          elevation: 0,
          child: buildSpotTab(size),
        ),
      ),
    );
  }

  ///Market Screen APPBAR
  AppBar AppHeader(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: buildHeader());
  }

  Widget buildHeader() {
    return CustomContainer(
      width: 1,
      height: 1,
      child: buildProHeader(),
    );
  }

  Widget buildLiteHeader() {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!isLogin) {
                    navigateToLogin();
                  } else {
                    viewModel.updateFavTradePair();
                  }
                },
                child: CustomContainer(
                  padding: 2.5,
                  width: 16,
                  height: 24,
                  child: SvgPicture.asset(
                    viewModel.isFav ? favouriteFilled : favourite,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (constant.okxStatus.value) {
                    await viewModel.unSubscribeChannel();
                  }
                  if (constant.binanceStatus.value) {
                    viewModel.leaveSocket();
                  }
                  moveToTrade(context, viewModel.pair);
                },
                child: CustomContainer(
                  padding: 2.5,
                  width: 16,
                  height: 24,
                  child: SvgPicture.asset(
                    filter,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ),
              CustomSizedBox(
                width: 0.02,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CustomText(
            fontfamily: 'InterTight',
            fontsize: 23,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            text: stringVariables.trades,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
        ),
      ],
    );
  }

  Widget buildSpotHeader() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: CustomText(
            fontfamily: 'InterTight',
            fontsize: 23,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            text: stringVariables.trades,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
        ),
      ],
    );
  }

  Widget buildProHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 50,
          //  color: red,
          child: TabBar(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            controller: viewModel.tradeTabController,
            indicatorColor: themeColor,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
                fontFamily: 'InterTight',
                fontWeight: FontWeight.w600,
                fontSize: 14),
            labelColor:
                themeSupport().isSelectedDarkMode() ? white : themeColor,
            unselectedLabelColor: stackCardText,
            tabs: [
              Tab(
                text: stringVariables.spot,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            moveToP2P(context);
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: CustomText(
                text: stringVariables.p2p,
                fontfamily: 'InterTight',
                fontWeight: FontWeight.w600,
                color: stackCardText,
                fontsize: 14),
          ),
        )
      ],
    );
  }

  Widget buildPairAndTrade(Size size) {
    ListOfTradePairs priceTickers =
        viewModel.viewModelpriceTickersModel?[0] ?? ListOfTradePairs();
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height / 100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CustomSizedBox(
                width: 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (constant.binanceStatus.value) {
                        marketViewModel.ws?.close();
                        marketViewModel.webSocket?.clearListeners();
                      } else if (constant.okxStatus.value) {
                        viewModel.unSubscribeChannel();
                      }
                      Scaffold.of(context).openDrawer();
                      viewModel.setDrawerFlag(true);
                      viewModel.restartSocketForDrawer();
                    },
                    child: Row(
                      children: [
                        CustomText(
                          align: TextAlign.end,
                          fontfamily: 'InterTight',
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          text: "${priceTickers.symbol ?? "BTC/USDT"} ",
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomContainer(
                    height: 35,
                    width: 6.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: themeSupport().isSelectedDarkMode()
                            ? marketCardColor
                            : inputColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_drop_up,
                          size: 18,
                          color: double.parse(
                                      priceTickers.priceChangePercent ?? "0") >=
                                  0
                              ? green
                              : red,
                        ),
                        CustomText(
                          softwrap: true,
                          maxlines: 1,
                          fontfamily: 'InterTight',
                          color: double.parse(
                                      priceTickers.priceChangePercent ?? "0") >=
                                  0
                              ? green
                              : red,
                          overflow: TextOverflow.ellipsis,
                          text: double.parse(
                                      priceTickers.priceChangePercent ?? "0") >=
                                  0
                              ? "${trimAs2((priceTickers.priceChangePercent ?? "0").toString())}%"
                              : "${trimAs2((priceTickers.priceChangePercent ?? "0").toString())}%",
                          fontWeight: FontWeight.w500,
                          fontsize: 11.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (constant.okxStatus.value) {
                    await viewModel.unSubscribeChannel();
                  } else if (constant.binanceStatus.value) {
                    viewModel.leaveSocket();
                  }
                  moveToTrade(context, viewModel.pair);
                  // if (!isLogin) {
                  //   navigateToLogin();
                  // } else {
                  //   viewModel.updateFavTradePair();
                  // }
                },
                child: CustomContainer(
                  padding: 2.5,
                  width: 10,
                  height: 24,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeSupport().isSelectedDarkMode()
                          ? marketCardColor
                          : inputColor),
                  child: Icon(
                    Icons.candlestick_chart_outlined,
                    size: 25,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  // if (constant.okxStatus.value) {
                  //   await viewModel.unSubscribeChannel();
                  // } else if (constant.binanceStatus.value) {
                  //   viewModel.leaveSocket();
                  // }
                  // moveToTrade(context, viewModel.pair);
                },
                child: CustomContainer(
                  padding: 2.5,
                  width: 10,
                  height: 24,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeSupport().isSelectedDarkMode()
                          ? marketCardColor
                          : inputColor),
                  child: Icon(
                    Icons.more_horiz,
                    size: 25,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ),
              CustomSizedBox(
                width: 0.01,
              )
            ],
          ),
        ],
      ),
    );
  }

  _showOrderbookModel(int type) async {
    final result =
        await Navigator.of(context).push(OrderbookOptionsModel(context, type));
  }

  Widget buildProShowBalance(Size size, [bool isMargin = false]) {
    String balance = viewModel.tabView
        ? viewModel.balance == null
            ? dummyBalance.scurr.toString()
            : viewModel.balance!.scurr.toString()
        : viewModel.balance == null
            ? dummyBalance.fcurr.toString()
            : viewModel.balance!.fcurr.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
            overflow: TextOverflow.ellipsis,
            softwrap: true,
            text: stringVariables.available,
            color: hintLight,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 13),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          // onTap: () {
          //   if (!isLogin) {
          //     navigateToLogin();
          //   } else {
          //     if (constant.binanceStatus.value) {
          //       viewModel.leaveSocket();
          //     }
          //
          //     constant.walletCurrency.value =
          //         '${dashBoardBalance.currencyCode}';
          //     moveToCoinDetailsView(
          //         context,
          //         dashBoardBalance.currencyName,
          //         dashBoardBalance.totalBalance.toString(),
          //         dashBoardBalance.availableBalance.toString(),
          //         dashBoardBalance.currencyCode,
          //         dashBoardBalance.currencyType.toString(),
          //         dashBoardBalance.inorderBalance.toString(),
          //         dashBoardBalance.mlmStakeBalance.toString());
          //   }
          // },
          child: Row(
            children: [
              Row(
                children: [
                  CustomContainer(
                    width: 3.9,
                    child: CustomText(
                      align: TextAlign.end,
                      fontfamily: 'InterTight',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: trimDecimalsForBalance(balance),
                      fontsize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomText(
                    align: TextAlign.end,
                    softwrap: true,
                    maxlines: 1,
                    fontfamily: 'InterTight',
                    overflow: TextOverflow.ellipsis,
                    text: viewModel.tabView
                        ? " ${viewModel.toCurrency}"
                        : " ${viewModel.fromCurrency}",
                    fontWeight: FontWeight.bold,
                    fontsize: 12,
                  ),
                ],
              ),

              // SvgPicture.asset(
              //   addAmountImage,
              //   width: 11.5,
              //   height: 11.5,
              //   color: themeColor,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProAmountField(Size size, String hint,
      TextEditingController textEditingController, double inc,
      [FocusNode? focusNode, bool? decimal = true]) {
    return TextFormField(
      textAlign: TextAlign.center,
      focusNode: focusNode,
      controller: textEditingController,
      inputFormatters: [
        // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        decimal == true
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            : FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      ],
      cursorColor: themeColor,
      keyboardType: decimal == true
          ? const TextInputType.numberWithOptions(decimal: true)
          : const TextInputType.numberWithOptions(decimal: false),
      style: TextStyle(
        fontFamily: "InterTight",
        fontWeight: FontWeight.w500,
        fontSize: 13,
        color: themeSupport().isSelectedDarkMode() ? white : black,
      ),
      decoration: InputDecoration(
        prefixIconConstraints: BoxConstraints(
          minWidth: 35,
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: 35,
        ),
        isDense: true,
        //contentPadding: EdgeInsets.only(top: 5),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 4.0, top: 4, bottom: 4),
          child: CustomContainer(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: themeColor, borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () {
                if (textEditingController.text.isNotEmpty) {
                  plusIconPressed(textEditingController, inc);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.add,
                color: white,
                size: 17.5,
              ),
            ),
          ),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4),
          child: CustomContainer(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                color: themeSupport().isSelectedDarkMode()
                    ? minusDarkColor
                    : minusLightColor,
                borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () {
                if (textEditingController.text.isNotEmpty) {
                  minusIconPressed(textEditingController, inc);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.remove,
                color: themeSupport().isSelectedDarkMode() ? white : black,
                size: 17.5,
              ),
            ),
          ),
        ),
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: "InterTight",
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: textGrey,
        ),
      ),
    );
  }

  plusIconPressed(TextEditingController textEditingController, double inc) {
    FocusScope.of(context).unfocus();
    _buyAmountFocus.unfocus();
    _sellAmountFocus.unfocus();
    if (viewModel.tradeTabIndex == 0) {
      if (viewModel.tabView) {
        viewModel.setBuySliderValue(0);
      } else {
        viewModel.setSellSliderValue(0);
      }
    }
    if (textEditingController.text.isEmpty) {
      textEditingController.text = inc.toString();
    } else {
      zerosValue = 0;
      var value = double.parse(textEditingController.text);
      if (hasDecimalPlaces(textEditingController.text)) {
        zeroTrailing(textEditingController.text);
      }
      var decimalPlaces = getDecimalPlaces(value, zerosValue);
      if (decimalPlaces > 2 && hasDecimalPlaces(textEditingController.text)) {
        String decimalToAdd = "0.";
        for (int i = 0; i < decimalPlaces; i++) {
          if (i == (decimalPlaces - 1)) {
            decimalToAdd += "1";
          } else {
            decimalToAdd += "0";
          }
        }
        value = value + double.parse(decimalToAdd);
        textEditingController.text = value.toStringAsFixed(decimalPlaces);
      } else {
        value = value + inc;
        textEditingController.text = value.toStringAsFixed(2);
      }
    }
  }

  minusIconPressed(TextEditingController textEditingController, double inc) {
    FocusScope.of(context).unfocus();
    _buyAmountFocus.unfocus();
    _sellAmountFocus.unfocus();
    if (viewModel.tradeTabIndex == 0) {
      if (viewModel.tabView) {
        viewModel.setBuySliderValue(0);
      } else {
        viewModel.setSellSliderValue(0);
      }
    }
    var value = double.parse(textEditingController.text);
    if (value <= inc) {
      textEditingController.text = "";
    } else {
      zerosValue = 0;
      if (hasDecimalPlaces(textEditingController.text)) {
        zeroTrailing(textEditingController.text);
      }
      var value = double.parse(textEditingController.text);
      var decimalPlaces = getDecimalPlaces(value, zerosValue);
      if (decimalPlaces > 2 && hasDecimalPlaces(textEditingController.text)) {
        String decimalToAdd = "0.";
        for (int i = 0; i < decimalPlaces; i++) {
          if (i == (decimalPlaces - 1)) {
            decimalToAdd += "1";
          } else {
            decimalToAdd += "0";
          }
        }
        value = value - double.parse(decimalToAdd);
        textEditingController.text = value.toStringAsFixed(decimalPlaces);
      } else {
        value = value - inc;
        textEditingController.text = value.toStringAsFixed(2);
      }
    }
  }

  setAmountValueUsingSlider(double value) {
    String balance = viewModel.tabView
        ? viewModel.balance == null
            ? dummyBalance.scurr.toString()
            : viewModel.balance!.scurr.toString()
        : viewModel.balance == null
            ? dummyBalance.fcurr.toString()
            : viewModel.balance!.fcurr.toString();
    var amount = double.parse(balance);
    TextEditingController amountController =
        viewModel.tabView ? buySliderUpdated() : sellSliderUpdated();
    if (value == 0) {
      double half = amount / 2;
      double quarter = amount / 4;
      amountController.text =
          trimDecimalsForBalance((half + quarter).toString());
    } else {
      amountController.text =
          trimDecimalsForBalance((amount / value).toString());
    }
  }

  TextEditingController buySliderUpdated() {
    _buyTotalController.text = viewModel.balance!.scurr.toString();
    if (viewModel.buyLimitController.text.isEmpty) {
      viewModel.buyLimitController.text = trimDecimalsForBalance(double.parse(
              viewModel.viewModelpriceTickersModel!.first.lastPrice.toString())
          .toString());
    }
    return _buyTotalController;
  }

  TextEditingController sellSliderUpdated() {
    viewModel.sellAmountController.text = viewModel.balance!.fcurr.toString();
    if (viewModel.sellLimitController.text.isEmpty) {
      viewModel.sellLimitController.text = trimDecimalsForBalance(double.parse(
              viewModel.viewModelpriceTickersModel!.first.lastPrice.toString())
          .toString());
    }
    return viewModel.sellAmountController;
  }

  calculateTotalAmount(
    TextEditingController totalController,
  ) {
    TextEditingController limitController = viewModel.tabView
        ? viewModel.buyLimitController
        : viewModel.sellLimitController;
    TextEditingController amountController = viewModel.tabView
        ? viewModel.buyAmountController
        : viewModel.sellAmountController;
    if (limitController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        viewModel.selectedOrderType != 1) {
      double limit = double.parse(limitController.text);
      double amount = double.parse(amountController.text);
      totalController.text =
          trimDecimalsForBalance((limit * amount).toString());
    } else if (viewModel.selectedOrderType == 1 &&
        amountController.text.isNotEmpty) {
      double amount = double.parse(amountController.text);
      double marktetPrice =
          double.parse(viewModel.viewModelpriceTickersModel!.first.lastPrice!);
      var total = trimDecimalsForBalance((marktetPrice * amount).toString());
      if (total == "0.00") {
        total = trimDecimalsForBalance((marktetPrice * amount).toString());
      }
      totalController.text = total;
    } else {
      totalController.text = "";
    }
  }

  calculateAmountAmount(
    TextEditingController amountController,
  ) {
    bool currentFocus = viewModel.tabView
        ? _buyAmountFocus.hasFocus
        : _sellAmountFocus.hasFocus;
    if (currentFocus) return;
    TextEditingController limitController = viewModel.tabView
        ? viewModel.buyLimitController
        : viewModel.sellLimitController;
    TextEditingController totalController =
        viewModel.tabView ? _buyTotalController : _sellTotalController;
    if (limitController.text.isNotEmpty &&
        totalController.text.isNotEmpty &&
        isNumeric(limitController.text)) {
      double limit = double.parse(limitController.text);
      double total = double.parse(totalController.text);
      amountController.text =
          trimDecimalsForBalance((total / limit).toString());
    }
  }

  bool isNumeric(String s) {
    return double.parse(s) > 0;
  }

  int getDecimalPlaces(double number, [int zero = 0]) {
    int decimals = 0;
    List<String> substr = number.toString().split('.');
    if (substr[1].length > 0) {
      decimals = zero != 0 ? (substr[1].length + zero) : substr[1].length;
    }
    return decimals;
  }

  bool hasDecimalPlaces(var number) {
    List<String> substr = number.toString().split('.');
    return (substr.length > 1);
  }

  zeroTrailing(String text) {
    var zeroTrail = text.substring(text.length - 1, text.length);
    if (zeroTrail == "0") {
      zerosValue++;
      zeroTrailing(text.substring(0, text.length - 1));
    } else if (zeroTrail == ".") {
      zerosValue--;
    }
  }
}

class CustomDrawerTab extends StatefulWidget {
  String? pair;
  ExchangeViewModel? viewModel;

  CustomDrawerTab({Key? key, this.pair, this.viewModel}) : super(key: key);

  @override
  CustomDrawerTabState createState() => new CustomDrawerTabState();
}

class CustomDrawerTabState extends State<CustomDrawerTab> {
  late MarketViewModel marketViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel?.setDrawerLabel(widget.pair ?? "ETH");
    });
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

  @override
  Widget build(BuildContext context) {
    marketViewModel = context.watch<MarketViewModel>();
    List<ListOfTradePairs>? list =
        (widget.pair == stringVariables.alt.toUpperCase() ||
                widget.pair == stringVariables.fiat.toUpperCase())
            ? widget.viewModel!.viewModelTradePairs
            : (widget.pair == stringVariables.favourite)
                ? widget.viewModel!.favFilteredList
                : widget.viewModel!.getFilteredList(widget.pair!);
    return list!.isEmpty
        ? buildNoRecord()
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 5),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              ListOfTradePairs listOfTradePairs = (widget.pair ==
                          stringVariables.alt.toUpperCase() ||
                      widget.pair == stringVariables.fiat.toUpperCase())
                  ? widget.viewModel!.viewModelTradePairs![index]
                  : (widget.pair == stringVariables.favourite)
                      ? widget.viewModel!.favFilteredList[index]
                      : widget.viewModel!.getFilteredList(widget.pair!)![index];
              return buildDrawerTradePair(listOfTradePairs);
            });
  }

  Widget buildDrawerTradePair(ListOfTradePairs listOfTradePairs) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (constant.okxStatus.value) {
            await widget.viewModel!.unSubscribeAllTradePairsChannel();
          } else if (constant.binanceStatus.value) {
            marketViewModel.ws?.close();
            marketViewModel.webSocket?.clearListeners();
          }
          widget.viewModel!.setTradePair(listOfTradePairs.symbol!);
          widget.viewModel!.restartSocketForDrawer();
          Scaffold.of(context).closeDrawer();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: listOfTradePairs.symbol!.split("/").first,
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomSizedBox(
                      width: 0.005,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: CustomText(
                        text: "/",
                        fontsize: 13,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.005,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: CustomText(
                        text: listOfTradePairs.symbol!.split("/").last,
                        fontsize: 13,
                      ),
                    ),
                  ],
                ),
                CustomText(
                  text: trimDecimalsForBalance(listOfTradePairs.lastPrice!),
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
                  color: double.parse(listOfTradePairs.priceChangePercent!) > 0
                      ? green
                      : red,
                  text: double.parse(listOfTradePairs.priceChangePercent!) > 0
                      ? "+" +
                          trimAs2(listOfTradePairs.priceChangePercent!) +
                          "%"
                      : trimAs2(listOfTradePairs.priceChangePercent!) + "%",
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
  }
}
