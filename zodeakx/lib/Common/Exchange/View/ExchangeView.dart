import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Exchange/Model/GetBalance.dart';
import 'package:zodeakx_mobile/Common/OrderBook/ViewModel/OrderBookViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../Model/CreateOrder.dart';
import '../ViewModel/ExchangeViewModel.dart';

class ExchangeView extends StatefulWidget {
  final String? pair;

  const ExchangeView({Key? key, this.pair}) : super(key: key);

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView>
    with TickerProviderStateMixin {
  int _selectedScreenIndex = 0;
  late ExchangeViewModel viewModel;
  late OrderBookViewModel orderBookViewModel;
  final TextEditingController _orderTypeController = TextEditingController();
  final TextEditingController _buyTotalController = TextEditingController();
  final TextEditingController _buyStopLimitController = TextEditingController();
  final TextEditingController _buyAmountController = TextEditingController();
  final TextEditingController _sellTotalController = TextEditingController();
  final TextEditingController _sellStopLimitController =
      TextEditingController();
  final TextEditingController _sellAmountController = TextEditingController();
  final _orderType = [
    stringVariables.limit,
    stringVariables.markets,
    stringVariables.stopLimit
  ];
  int zerosValue = 0;
  bool isLogin = false;
  String old_buy_limit = "";
  String old_sell_limit = "";
  final GlobalKey _orderBuyTypeKey = GlobalKey();
  final GlobalKey _orderSellTypeKey = GlobalKey();

  Future<bool> willPopScopeCall() async {
    return false;
  }

  @override
  void initState() {
    viewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    orderBookViewModel =
        Provider.of<OrderBookViewModel>(context, listen: false);
    orderBookViewModel.fetchData(false);
    widget.pair == null ? viewModel.fetchData() : () {};
    viewModel.tabController = TabController(length: 2, vsync: this);

    viewModel.tabController.addListener(() {
      viewModel.setTabView(viewModel.tabController.index == 0);
    });
    _buyTotalController.addListener(() {
      calculateAmountAmount(_buyAmountController);
    });
    viewModel.buyLimitController.addListener(() {
      calculateTotalAmount(_buyTotalController);
    });
    _buyAmountController.addListener(() {
      calculateTotalAmount(_buyTotalController);
    });
    viewModel.sellLimitController.addListener(() {
      calculateTotalAmount(_sellTotalController);
    });
    _sellTotalController.addListener(() {
      calculateAmountAmount(_sellAmountController);
    });
    _sellAmountController.addListener(() {
      calculateTotalAmount(_sellTotalController);
    });
    viewModel.buyLimitController.selection = TextSelection.fromPosition(
        TextPosition(offset: viewModel.buyLimitController.text.length));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setBuySliderValue(0);
      viewModel.setSellSliderValue(0);
      viewModel.setOrderType(0);
      viewModel.setTabView(true);
      widget.pair != null ? viewModel.setTradePair(widget.pair!) : () {};
    });
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.tabController.dispose();
    viewModel.leaveSocket();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ExchangeViewModel>();
    orderBookViewModel = context.watch<OrderBookViewModel>();
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
        appBar: AppHeader(context),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    buildPairAndOrderBook(size),
                    CustomCard(
                      radius: 15,
                      outerPadding: size.width / 60,
                      edgeInsets: size.width / 60,
                      elevation: 0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildPriceDetailsCard(size),
                            buildTabSection(size),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                viewModel.leaveSocket();
                moveToTrade(context, viewModel.pair);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomContainer(
                  padding: 8,
                  width: 10.5,
                  height: 21,
                  child: SvgPicture.asset(
                    filter,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              fontfamily: 'GoogleSans',
              fontsize: 23,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              text: stringVariables.exchange,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPairAndOrderBook(Size size) {
    ListOfTradePairs priceTickers = viewModel.viewModelpriceTickersModel![0];
    return Padding(
      padding: EdgeInsets.only(
        left: size.width / 25,
        right: size.width / 25,
        top: size.height / 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                  viewModel.restartSocketForDrawer();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      exchangeBlack,
                      width: 14,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                    CustomSizedBox(
                      width: size.width * 0.00005,
                    ),
                    CustomText(
                      align: TextAlign.end,
                      fontfamily: 'GoogleSans',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: priceTickers.symbol!,
                      fontsize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              CustomSizedBox(
                width: size.width * 0.000075,
              ),
              CustomText(
                align: TextAlign.end,
                softwrap: true,
                maxlines: 1,
                fontfamily: 'GoogleSans',
                color: double.parse(priceTickers.priceChangePercent!) > 0
                    ? green
                    : red,
                overflow: TextOverflow.ellipsis,
                text: double.parse(priceTickers.priceChangePercent!) > 0
                    ? "+${trimAs2(priceTickers.priceChangePercent.toString())}%"
                    : "${trimAs2(priceTickers.priceChangePercent.toString())}%",
                fontWeight: FontWeight.w700,
                fontsize: 13,
              ),
            ],
          ),
          CustomText(
            press: () {
              viewModel.leaveSocket();
              moveToOrderBook(context, viewModel.pair);
            },
            align: TextAlign.end,
            softwrap: true,
            maxlines: 1,
            fontfamily: 'GoogleSans',
            color: themeColor,
            overflow: TextOverflow.ellipsis,
            text: stringVariables.orderBook,
            fontWeight: FontWeight.w800,
            fontsize: 13,
          ),
        ],
      ),
    );
  }

  Widget buildPriceDetailsCard(Size size) {
    ListOfTradePairs priceTickers = viewModel.viewModelpriceTickersModel![0];
    return CustomCard(
      radius: 15,
      edgeInsets: size.width / 15,
      color: themeSupport().isSelectedDarkMode() ? black : grey,
      outerPadding: size.width / 75,
      elevation: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  overflow: TextOverflow.ellipsis,
                  softwrap: true,
                  text: stringVariables.lastPrice,
                  color: hintLight,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.w700,
                  fontsize: 13),
              Row(
                children: [
                  CustomText(
                    align: TextAlign.end,
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    text: trimDecimalsForBalance(priceTickers.lastPrice!),
                    fontsize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomSizedBox(
                    width: size.width * 0.00002,
                  ),
                  CustomText(
                    align: TextAlign.end,
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    color: green,
                    overflow: TextOverflow.ellipsis,
                    text: trimDecimalsForBalance(viewModel.estimateFiatValue.toString()),
                    fontsize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomSizedBox(
                    width: size.width * 0.00002,
                  ),
                  CustomText(
                    align: TextAlign.end,
                    softwrap: true,
                    maxlines: 1,
                    fontfamily: 'GoogleSans',
                    color: green,
                    overflow: TextOverflow.ellipsis,
                    text:
                        '${constant.pref?.getString("defaultFiatCurrency") ?? 'GBP'}',
                    fontWeight: FontWeight.bold,
                    fontsize: 14.25,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: size.height / 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  overflow: TextOverflow.ellipsis,
                  softwrap: true,
                  text: stringVariables.h24Change,
                  color: hintLight,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.w700,
                  fontsize: 13),
              CustomText(
                align: TextAlign.end,
                fontfamily: 'GoogleSans',
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                text: trimDecimalsForBalance(priceTickers.priceChange!),
                fontsize: 14.5,
                fontWeight: FontWeight.w700,
                color:
                    double.parse(priceTickers.priceChange!) > 0 ? green : red,
              ),
            ],
          ),
          SizedBox(
            height: size.height / 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  overflow: TextOverflow.ellipsis,
                  softwrap: true,
                  text: stringVariables.h24High,
                  color: hintLight,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.w700,
                  fontsize: 13),
              CustomText(
                align: TextAlign.end,
                fontfamily: 'GoogleSans',
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                text: trimDecimalsForBalance(priceTickers.highPrice!),
                fontsize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(
            height: size.height / 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  overflow: TextOverflow.ellipsis,
                  softwrap: true,
                  text: stringVariables.h24Low,
                  color: hintLight,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.w700,
                  fontsize: 13),
              CustomText(
                align: TextAlign.end,
                fontfamily: 'GoogleSans',
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                text: trimDecimalsForBalance(priceTickers.lowPrice!),
                fontsize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(
            height: size.height / 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  overflow: TextOverflow.ellipsis,
                  softwrap: true,
                  text: stringVariables.h24Volume,
                  color: hintLight,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.w700,
                  fontsize: 13),
              Row(
                children: [
                  CustomText(
                    align: TextAlign.end,
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    text: trimDecimalsForBalance(priceTickers.quoteVolume!),
                    fontsize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    align: TextAlign.end,
                    softwrap: true,
                    maxlines: 1,
                    fontfamily: 'GoogleSans',
                    overflow: TextOverflow.ellipsis,
                    text: ' ${viewModel.toCurrency}',
                    fontWeight: FontWeight.bold,
                    fontsize: 14.25,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTabSection(Size size) {
    ListOfTradePairs priceTickers = viewModel.viewModelpriceTickersModel![0];
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height / 35, horizontal: size.width / 50),
        child: Column(
          children: <Widget>[
            CustomContainer(
              padding: 2.5,
              width: 1,
              height: 12.5,
              decoration: BoxDecoration(
                color: themeSupport().isSelectedDarkMode() ? black : grey,
                borderRadius: BorderRadius.circular(
                  50.0,
                ),
              ),
              child: TabBar(
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.zero,
                indicatorWeight: 0,
                indicatorColor: Colors.transparent,
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
                          borderRadius: BorderRadius.circular(50),
                          color: viewModel.tabView
                              ? green
                              : themeSupport().isSelectedDarkMode()
                                  ? black
                                  : grey),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                            color: viewModel.tabView ? white : hintLight,
                            text: stringVariables.buy.toUpperCase()),
                      ),
                    ),
                  ),
                  Tab(
                    height: 250,
                    child: CustomContainer(
                      height: 1,
                      width: 1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: viewModel.tabView
                              ? themeSupport().isSelectedDarkMode()
                                  ? black
                                  : grey
                              : red),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                            color: viewModel.tabView ? hintLight : white,
                            text: stringVariables.sell.toUpperCase()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomContainer(
              width: 1,
              height: viewModel.selectedOrderType == 2
                  ? 1.39
                  : viewModel.selectedOrderType == 1
                      ? 2.24
                      : 1.575,
              child: TabBarView(
                controller: viewModel.tabController,
                children: [
                  Column(
                    children: [
                      CustomSizedBox(
                        height: size.height * 0.0000475,
                      ),
                      buildDropDownField(
                          size, _orderTypeController, _orderBuyTypeKey),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      viewModel.selectedOrderType == 2
                          ? buildAmountField(
                              size,
                              stringVariables.stopLimit +
                                  " (${viewModel.toCurrency})",
                              _buyStopLimitController,
                              0.01)
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType == 2
                          ? CustomSizedBox(
                              height: size.height * 0.000035,
                            )
                          : SizedBox.shrink(),
                      buildAmountField(
                          size,
                          stringVariables.limit + " (${viewModel.toCurrency})",
                          viewModel.buyLimitController,
                          0.01),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      buildAmountField(
                          size,
                          stringVariables.amount +
                              " (${viewModel.fromCurrency})",
                          _buyAmountController,
                          1),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      viewModel.selectedOrderType != 1
                          ? buildSlider(size)
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType != 1
                          ? CustomSizedBox(
                              height: size.height * 0.000035,
                            )
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType != 1
                          ? TextFormField(
                              style: TextStyle(
                                color: themeSupport().isSelectedDarkMode()
                                    ? white
                                    : black,
                                fontWeight: FontWeight.w700,
                              ),
                              controller: _buyTotalController,
                              textAlign: TextAlign.center,
                              readOnly: true,
                              decoration: InputDecoration(
                                counterText: '',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    width: 1.0,
                                  ),
                                ),
                                errorStyle: TextStyle(color: red),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: red, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? white
                                        : enableBorder,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? white
                                        : enableBorder,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: stringVariables.total +
                                    " (${viewModel.toCurrency})",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textGrey,
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 0, top: 0, bottom: 0, right: 0),
                                labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType != 1
                          ? CustomSizedBox(
                              height: size.height * 0.000035,
                            )
                          : SizedBox.shrink(),
                      buildShowBalance(size),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      isLogin
                          ? CustomElevatedButton(
                              buttoncolor: green,
                              color: white,
                              press: () {
                                bool forLimitsFlag =
                                    _buyTotalController.text.isNotEmpty &&
                                        (viewModel.selectedOrderType == 2
                                            ? _buyStopLimitController
                                                .text.isNotEmpty
                                            : true);
                                if (viewModel.selectedOrderType == 1 ||
                                    forLimitsFlag) {
                                  CreateOrder createOrder;
                                  var limit, total, stopLimit;
                                  var amount =
                                      double.parse(_buyAmountController.text);
                                  if (viewModel.selectedOrderType != 1) {
                                    limit = double.parse(
                                        viewModel.buyLimitController.text);
                                    total =
                                        double.parse(_buyTotalController.text);
                                    if (viewModel.selectedOrderType == 2) {
                                      stopLimit = double.parse(
                                          _buyStopLimitController.text);
                                    }
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
                                    case 2:
                                      createOrder = CreateOrder(
                                          order_type: stringVariables.stopLimit,
                                          trade_type: stringVariables.buy,
                                          pair: priceTickers.symbol!,
                                          stop_price: stopLimit,
                                          amount: amount,
                                          limit_price: limit,
                                          total: total);
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
                                  viewModel.createOrder(context, createOrder);
                                }
                              },
                              width: 1.15,
                              isBorderedButton: true,
                              maxLines: 1,
                              icon: null,
                              multiClick: true,
                              text: stringVariables.buy.toUpperCase() +
                                  " ${viewModel.fromCurrency}",
                              radius: 25,
                              height: size.height / 50,
                              icons: false,
                              blurRadius: 0,
                              spreadRadius: 0,
                              offset: Offset(0, 0))
                          : CustomElevatedButton(
                              buttoncolor: themeColor,
                              color: Colors.black,
                              press: () {
                                constant.previousScreen.value =
                                    ScreenType.Exchange;
                                viewModel.leaveSocket();
                                moveToRegister(context, false);
                              },
                              width: 1.15,
                              isBorderedButton: true,
                              maxLines: 1,
                              icon: null,
                              multiClick: true,
                              text: stringVariables.logIn,
                              radius: 25,
                              height: size.height / 50,
                              icons: false,
                              blurRadius: 0,
                              spreadRadius: 0,
                              offset: Offset(0, 0)),
                    ],
                  ),
                  Column(
                    children: [
                      CustomSizedBox(
                        height: size.height * 0.0000475,
                      ),
                      buildDropDownField(
                          size, _orderTypeController, _orderSellTypeKey),
                      //buildOrderDropDown(size),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      viewModel.selectedOrderType == 2
                          ? buildAmountField(
                              size,
                              stringVariables.stopLimit +
                                  " (${viewModel.toCurrency})",
                              _sellStopLimitController,
                              0.01)
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType == 2
                          ? CustomSizedBox(
                              height: size.height * 0.000035,
                            )
                          : SizedBox.shrink(),
                      buildAmountField(
                          size,
                          stringVariables.limit + " (${viewModel.toCurrency})",
                          viewModel.sellLimitController,
                          0.01),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      buildAmountField(
                          size,
                          stringVariables.amount +
                              " (${viewModel.fromCurrency})",
                          _sellAmountController,
                          1),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      viewModel.selectedOrderType != 1
                          ? buildSlider(size)
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType != 1
                          ? CustomSizedBox(
                              height: size.height * 0.000035,
                            )
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType != 1
                          ? TextFormField(
                              style: TextStyle(
                                color: themeSupport().isSelectedDarkMode()
                                    ? white
                                    : black,
                                fontWeight: FontWeight.w700,
                              ),
                              controller: _sellTotalController,
                              textAlign: TextAlign.center,
                              readOnly: true,
                              decoration: InputDecoration(
                                counterText: '',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    width: 1.0,
                                  ),
                                ),
                                errorStyle: TextStyle(color: red),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      BorderSide(color: red, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? white
                                        : enableBorder,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? white
                                        : enableBorder,
                                    width: 1.0,
                                  ),
                                ),
                                hintText: stringVariables.total +
                                    " (${viewModel.toCurrency})",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textGrey,
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 0, top: 0, bottom: 0, right: 0),
                                labelStyle: const TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      viewModel.selectedOrderType != 1
                          ? CustomSizedBox(
                              height: size.height * 0.000035,
                            )
                          : SizedBox.shrink(),
                      buildShowBalance(size),
                      CustomSizedBox(
                        height: size.height * 0.000035,
                      ),
                      isLogin
                          ? CustomElevatedButton(
                              buttoncolor: red,
                              color: white,
                              press: () {
                                bool forLimitsFlag =
                                    _sellTotalController.text.isNotEmpty &&
                                        (viewModel.selectedOrderType == 2
                                            ? _sellStopLimitController
                                                .text.isNotEmpty
                                            : true);
                                if (viewModel.selectedOrderType == 1 ||
                                    forLimitsFlag) {
                                  CreateOrder createOrder;
                                  var limit, total, stopLimit;
                                  var amount =
                                      double.parse(_sellAmountController.text);
                                  if (viewModel.selectedOrderType != 1) {
                                    limit = double.parse(
                                        viewModel.sellLimitController.text);
                                    total =
                                        double.parse(_sellTotalController.text);
                                    if (viewModel.selectedOrderType == 2) {
                                      stopLimit = double.parse(
                                          _sellStopLimitController.text);
                                    }
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
                                    case 2:
                                      createOrder = CreateOrder(
                                          order_type: stringVariables.stopLimit,
                                          trade_type: stringVariables.sell,
                                          pair: priceTickers.symbol!,
                                          stop_price: stopLimit,
                                          amount: amount,
                                          limit_price: limit,
                                          total: total);
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
                                  viewModel.createOrder(context, createOrder);
                                }
                              },
                              width: 1.15,
                              isBorderedButton: true,
                              maxLines: 1,
                              icon: null,
                              text: stringVariables.sell.toUpperCase() +
                                  " ${viewModel.fromCurrency}",
                              multiClick: true,
                              radius: 25,
                              height: size.height / 50,
                              icons: false,
                              blurRadius: 0,
                              spreadRadius: 0,
                              offset: Offset(0, 0))
                          : CustomElevatedButton(
                              buttoncolor: themeColor,
                              color: Colors.black,
                              press: () {
                                constant.previousScreen.value =
                                    ScreenType.Exchange;
                                viewModel.leaveSocket();
                                moveToRegister(context, false);
                              },
                              width: 1.15,
                              isBorderedButton: true,
                              maxLines: 1,
                              icon: null,
                              multiClick: true,
                              text: stringVariables.logIn,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderDropDown(Size size) {
    return CustomContainer(
      width: 1,
      height: 15,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
        ),
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(30.0),
            icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
            isExpanded: true,
            underline: SizedBox(),
            items: _orderType.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      text: val,
                      fontWeight: FontWeight.w700,
                      fontsize: 16,
                    ),
                  ],
                ),
              );
            }).toList(),
            hint: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CustomText(
                        text: _orderType[viewModel.selectedOrderType],
                        fontWeight: FontWeight.w700,
                        fontsize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        dropDownArrowImage,
                        color: hintLight,
                        width: 6,
                        height: 6,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.05,
                    )
                  ],
                )
              ],
            ),
            onChanged: (val) {
              if (viewModel.tabView) {
                if (old_buy_limit.isNotEmpty)
                  viewModel.buyLimitController.text = old_buy_limit;
                calculateTotalAmount(_buyTotalController);
              } else {
                if (old_sell_limit.isNotEmpty)
                  viewModel.sellLimitController.text = old_sell_limit;
                calculateTotalAmount(_sellTotalController);
              }

              old_buy_limit = viewModel.buyLimitController.text;
              old_sell_limit = viewModel.sellLimitController.text;

              if (_orderType.indexOf(val!) == 1) {
                viewModel.tabView
                    ? viewModel.buyLimitController.clear()
                    : viewModel.sellLimitController.clear();
              }
              viewModel.setOrderType(_orderType.indexOf(val));
            }),
      ),
    );
  }

  Widget buildShowBalance(Size size) {
    DashBoardBalance dashBoardBalance =
        viewModel.viewModelDashBoardBalance == null
            ? dummyDashboard
            : viewModel.viewModelDashBoardBalance!
                .where((element) =>
                    element.currencyCode ==
                    (viewModel.tabView
                        ? viewModel.toCurrency
                        : viewModel.fromCurrency))
                .toList()
                .first;
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
            text: stringVariables.avbl,
            color: hintLight,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.w700,
            fontsize: 14),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (!isLogin) {
              constant.previousScreen.value = ScreenType.Exchange;
              viewModel.leaveSocket();
              moveToRegister(context);
            } else {
              viewModel.leaveSocket();
              constant.walletCurrency.value =
                  '${dashBoardBalance.currencyCode}';
              moveToCoinDetailsView(
                  context,
                  dashBoardBalance.currencyName,
                  dashBoardBalance.totalBalance.toString(),
                  dashBoardBalance.availableBalance.toString(),
                  dashBoardBalance.currencyCode,
                  dashBoardBalance.currencyType.toString(),
                  dashBoardBalance.inorderBalance.toString(),dashBoardBalance.mlmStakeBalance.toString());
            }
          },
          child: Row(
            children: [
              Row(
                children: [
                  CustomText(
                    align: TextAlign.end,
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    text: trimDecimalsForBalance(balance),
                    fontsize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    align: TextAlign.end,
                    softwrap: true,
                    maxlines: 1,
                    fontfamily: 'GoogleSans',
                    overflow: TextOverflow.ellipsis,
                    text: viewModel.tabView
                        ? " ${viewModel.toCurrency}"
                        : " ${viewModel.fromCurrency}",
                    fontWeight: FontWeight.bold,
                    fontsize: 15,
                  ),
                ],
              ),
              CustomSizedBox(
                width: size.width * 0.00005,
              ),
              SvgPicture.asset(
                addAmountImage,
                width: 13.5,
                height: 13.5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSlider(Size size) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 7.5,
            trackShape: RoundedRectSliderTrackShape(),
            activeTrackColor: themeColor,
            inactiveTrackColor: grey,
            thumbShape: SliderThumbShape(disabledThumbRadius: 7.5),
            overlayColor: themeColor.withOpacity(0.2),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: 100.0,
            value: viewModel.tabView
                ? viewModel.buySliderValue
                : viewModel.sellSliderValue,
            divisions: 4,
            onChanged: (value) {
              viewModel.tabView
                  ? viewModel.setBuySliderValue(value)
                  : viewModel.setSellSliderValue(value);
              if (viewModel.tabView)
                calculateTotalAmount(_buyTotalController);
              else
                calculateTotalAmount(_sellTotalController);
              switch (value.round()) {
                case 25:
                  setAmountValueUsingSlider(4);
                  break;
                case 50:
                  setAmountValueUsingSlider(2);
                  break;
                case 75:
                  setAmountValueUsingSlider(1.33);
                  break;
                case 100:
                  setAmountValueUsingSlider(1);
                  break;
                default:
                  if (viewModel.tabView)
                    _buyAmountController.text = "";
                  else
                    _sellAmountController.text = "";
                  break;
              }
            },
          ),
        ),
        CustomSizedBox(
          width: size.width * 0.00005,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7.5),
              child: CustomText(
                press: () {
                  if (viewModel.tabView) {
                    viewModel.setBuySliderValue(0);
                    _buyAmountController.text = "";
                  } else {
                    viewModel.setSellSliderValue(0);
                    _sellAmountController.text = "";
                  }
                },
                text: '0%',
                color: viewModel.tabView
                    ? viewModel.buySliderValue == 0.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey
                    : viewModel.sellSliderValue == 0.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey,
                fontsize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17.5),
              child: CustomText(
                press: () {
                  if (viewModel.tabView)
                    viewModel.setBuySliderValue(25);
                  else
                    viewModel.setSellSliderValue(25);
                  setAmountValueUsingSlider(4);
                },
                text: '25%',
                color: viewModel.tabView
                    ? viewModel.buySliderValue == 25.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey
                    : viewModel.sellSliderValue == 25.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey,
                fontsize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: CustomText(
                press: () {
                  if (viewModel.tabView)
                    viewModel.setBuySliderValue(50);
                  else
                    viewModel.setSellSliderValue(50);
                  setAmountValueUsingSlider(2);
                },
                text: '50%',
                color: viewModel.tabView
                    ? viewModel.buySliderValue == 50.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey
                    : viewModel.sellSliderValue == 50.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey,
                fontsize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: CustomText(
                press: () {
                  if (viewModel.tabView)
                    viewModel.setBuySliderValue(75);
                  else
                    viewModel.setSellSliderValue(75);
                  setAmountValueUsingSlider(1.33);
                },
                text: '75%',
                color: viewModel.tabView
                    ? viewModel.buySliderValue == 75.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey
                    : viewModel.sellSliderValue == 75.0
                        ? themeSupport().isSelectedDarkMode()
                            ? white
                            : black
                        : textGrey,
                fontsize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            CustomText(
              press: () {
                if (viewModel.tabView)
                  viewModel.setBuySliderValue(100);
                else
                  viewModel.setSellSliderValue(100);
                setAmountValueUsingSlider(1);
              },
              text: '100%',
              color: viewModel.tabView
                  ? viewModel.buySliderValue == 100.0
                      ? themeSupport().isSelectedDarkMode()
                          ? white
                          : black
                      : textGrey
                  : viewModel.sellSliderValue == 100.0
                      ? themeSupport().isSelectedDarkMode()
                          ? white
                          : black
                      : textGrey,
              fontsize: 15,
              fontWeight: FontWeight.w700,
            ),
          ],
        )
      ],
    );
  }

  Widget buildDropDownField(
      Size size,
      TextEditingController textEditingController,
      GlobalKey<State<StatefulWidget>> _orderTypeKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            dynamic state = _orderTypeKey.currentState;
            state.showButtonMenu();
          },
          child: AbsorbPointer(
            child: CustomContainer(
              width: 1,
              height: 15,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 0.5),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSizedBox(
                    width: 0.15,
                  ),
                  Flexible(
                      child: TextFormField(
                    readOnly: true,
                    controller: textEditingController
                      ..selection = TextSelection.fromPosition(TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: textEditingController.text.length)),
                    cursorColor: themeColor,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: hintLight,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _orderType[viewModel.selectedOrderType],
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: hintLight,
                      ),
                    ),
                  )),
                  PopupMenuButton(
                    key: _orderTypeKey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    offset: Offset(-(size.width / 1.355), 0),
                    constraints: new BoxConstraints(
                      minHeight: (size.height / 12),
                      minWidth: (size.width / 1.175),
                      maxHeight: (size.height / 2),
                      maxWidth: (size.width / 1.175),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: hintLight,
                    ),
                    onSelected: (value) {
                      textEditingController.text = value as String;
                      viewModel.setOrderType(_orderType.indexOf(value));
                    },
                    color: checkBrightness.value == Brightness.dark
                        ? black
                        : white,
                    itemBuilder: (
                      BuildContext context,
                    ) {
                      return _orderType
                          .map<PopupMenuItem<String>>((String? value) {
                        return PopupMenuItem(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: value.toString(),
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            value: value);
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildAmountField(Size size, String hint,
      TextEditingController textEditingController, double inc) {
    double hintWidth = 0;
    switch (hint.toLowerCase().split("(").first) {
      case "limit ":
        hintWidth = 4.15;
        break;
      case "amount ":
        hintWidth = 3.25;
        break;
      case "stop limit ":
        hintWidth = 2.85;
        break;
      default:
        hintWidth = 3;
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          width: 1,
          height: 15,
          decoration: viewModel.selectedOrderType == 1 &&
                  hint == stringVariables.limit + " (${viewModel.toCurrency})"
              ? BoxDecoration()
              : BoxDecoration(
                  border: Border.all(color: borderColor, width: 0.5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
          child: viewModel.selectedOrderType == 1 &&
                  hint == stringVariables.limit + " (${viewModel.toCurrency})"
              ? TextFormField(
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: grey,
                    counterText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        width: 1.0,
                      ),
                    ),
                    errorStyle: TextStyle(color: red),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: red, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: themeSupport().isSelectedDarkMode()
                            ? white
                            : enableBorder,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: themeSupport().isSelectedDarkMode()
                            ? white
                            : enableBorder,
                        width: 1.0,
                      ),
                    ),
                    hintText: stringVariables.marketPrice,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textGrey,
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      radius: 20,
                      onPress: () {
                        viewModel.tabView
                            ? viewModel.setBuySliderValue(0)
                            : viewModel.setSellSliderValue(0);
                        var value = double.parse(textEditingController.text);
                        if (value <= inc) {
                          textEditingController.text = "";
                          textEditingController.value =
                              textEditingController.value.copyWith(
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: textEditingController
                                              .text.length)));
                        } else {
                          zerosValue = 0;
                          if (hasDecimalPlaces(textEditingController.text))
                            zeroTrailing(textEditingController.text);
                          var value = double.parse(textEditingController.text);
                          var decimalPlaces =
                              getDecimalPlaces(value, zerosValue);
                          if (decimalPlaces > 2 &&
                              hasDecimalPlaces(textEditingController.text)) {
                            String decimalToAdd = "0.";
                            for (int i = 0; i < decimalPlaces; i++) {
                              if (i == (decimalPlaces - 1)) {
                                decimalToAdd += "1";
                              } else {
                                decimalToAdd += "0";
                              }
                            }
                            value = value - double.parse(decimalToAdd);
                            textEditingController.text =
                                value.toStringAsFixed(decimalPlaces);
                            textEditingController.value =
                                textEditingController.value.copyWith(
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: textEditingController
                                                .text.length)));
                          } else {
                            value = value - inc;
                            textEditingController.text =
                                value.toStringAsFixed(2);
                            textEditingController.value =
                                textEditingController.value.copyWith(
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: textEditingController
                                                .text.length)));
                          }
                        }
                      },
                      color: grey,
                      child: SvgPicture.asset(
                        minusImage,
                        width: 2.5,
                        height: 2.5,
                      ),
                    ),
                    CustomContainer(
                      width: textEditingController.text.isEmpty ? hintWidth : 2,
                      height: 1,
                      //alignment: Alignment.center,
                      child: TextFormField(
                        controller: textEditingController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        ],
                        cursorColor: themeColor,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textAlign: textEditingController.text.isEmpty
                            ? TextAlign.left
                            : TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: themeSupport().isSelectedDarkMode()
                              ? white
                              : black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: textGrey,
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {});
                        },
                      ),
                    ),
                    CustomIconButton(
                      radius: 20,
                      onPress: () {
                        viewModel.tabView
                            ? viewModel.setBuySliderValue(0)
                            : viewModel.setSellSliderValue(0);
                        if (textEditingController.text.isEmpty) {
                          textEditingController.text = inc.toString();
                          textEditingController.value =
                              textEditingController.value.copyWith(
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: textEditingController
                                              .text.length)));
                        } else {
                          zerosValue = 0;
                          var value = double.parse(textEditingController.text);
                          if (hasDecimalPlaces(textEditingController.text))
                            zeroTrailing(textEditingController.text);
                          var decimalPlaces =
                              getDecimalPlaces(value, zerosValue);
                          if (decimalPlaces > 2 &&
                              hasDecimalPlaces(textEditingController.text)) {
                            String decimalToAdd = "0.";
                            for (int i = 0; i < decimalPlaces; i++) {
                              if (i == (decimalPlaces - 1)) {
                                decimalToAdd += "1";
                              } else {
                                decimalToAdd += "0";
                              }
                            }
                            value = value + double.parse(decimalToAdd);
                            textEditingController.text =
                                value.toStringAsFixed(decimalPlaces);
                            textEditingController.value =
                                textEditingController.value.copyWith(
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: textEditingController
                                                .text.length)));
                          } else {
                            value = value + inc;
                            textEditingController.text =
                                value.toStringAsFixed(2);
                            textEditingController.value =
                                textEditingController.value.copyWith(
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: textEditingController
                                                .text.length)));
                          }
                        }
                      },
                      color: grey,
                      child: SvgPicture.asset(
                        plusImage,
                        width: 13.5,
                        height: 13.5,
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
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
    amountController.text = (amount / value).toStringAsFixed(2);
  }

  TextEditingController sellSliderUpdated() {
    _sellAmountController.text = viewModel.balance!.fcurr.toString();
    if (viewModel.sellLimitController.text.isEmpty) {
      viewModel.sellLimitController.text = trimDecimals(double.parse(
              viewModel.viewModelpriceTickersModel!.first.lastPrice.toString())
          .toString());
    }
    return _sellAmountController;
  }

  TextEditingController buySliderUpdated() {
    _buyTotalController.text = viewModel.balance!.scurr.toString();
    if (viewModel.buyLimitController.text.isEmpty) {
      viewModel.buyLimitController.text = trimDecimals(double.parse(
              viewModel.viewModelpriceTickersModel!.first.lastPrice.toString())
          .toString());
    }
    return _buyTotalController;
  }

  calculateTotalAmount(
    TextEditingController totalController,
  ) {
    TextEditingController limitController = viewModel.tabView
        ? viewModel.buyLimitController
        : viewModel.sellLimitController;
    TextEditingController amountController =
        viewModel.tabView ? _buyAmountController : _sellAmountController;
    if (limitController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        viewModel.selectedOrderType != 1) {
      double limit = double.parse(limitController.text);
      double amount = double.parse(amountController.text);
      totalController.text = trimDecimals((limit * amount).toString());
    } else if (viewModel.selectedOrderType == 1 &&
        amountController.text.isNotEmpty) {
      double amount = double.parse(amountController.text);
      double marktetPrice =
          double.parse(viewModel.viewModelpriceTickersModel!.first.lastPrice!);
      var total = (marktetPrice * amount).toStringAsFixed(2);
      if (total == "0.00") total = (marktetPrice * amount).toStringAsFixed(6);
      totalController.text = total;
    } else {
      totalController.text = "";
    }
  }

  calculateAmountAmount(
    TextEditingController amountController,
  ) {
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
      amountController.text = trimDecimals((total / limit).toString());
    }
  }

  bool isNumeric(String s) {
    return double.parse(s) > 0;
  }

  int getDecimalPlaces(double number, [int zero = 0]) {
    int decimals = 0;
    List<String> substr = number.toString().split('.');
    if (substr[1].length > 0)
      decimals = zero != 0 ? (substr[1].length + zero) : substr[1].length;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel?.setDrawerLabel(widget.pair ?? "ETH");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ListOfTradePairs>? list =
        (widget.pair == "ALT" || widget.pair == "FIAT")
            ? widget.viewModel!.viewModelTradePairs
            : widget.viewModel!.getFilteredList(widget.pair!);
    return CustomContainer(
      width: 1,
      height: 1,
      padding: 15,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (widget.viewModel!.albCounter < 2) {
                        widget.viewModel!
                            .setAlbCount((widget.viewModel!.albCounter + 1));
                        if (widget.viewModel!.albOrder) {
                          widget.viewModel!.setPairIcon(
                              themeSupport().isSelectedDarkMode()
                                  ? upSortLight
                                  : upSort);
                          widget.viewModel!.filteredListWithPair();
                          widget.viewModel!.setAlbOrder(false);
                        } else {
                          widget.viewModel!.setPairIcon(
                              themeSupport().isSelectedDarkMode()
                                  ? downSortLight
                                  : downSort);
                          widget.viewModel!.setfilteredTradePairs(widget
                              .viewModel!.filteredList!.reversed
                              .toList());
                          widget.viewModel!.setAlbOrder(true);
                        }
                      } else {
                        widget.viewModel!.setPairIcon(normalSort);
                        widget.viewModel!.setAlbCount(0);
                        widget.viewModel!.setfilteredTradePairs(
                            widget.viewModel!.viewModelTradePairs!);
                      }
                    },
                    child: buildTextWithSort(
                        stringVariables.pairs, widget.viewModel!.pairIcon)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (widget.viewModel!.lastCounter < 2) {
                            widget.viewModel!.setLastCount(
                                (widget.viewModel!.lastCounter + 1));
                            if (widget.viewModel!.lastOrder) {
                              widget.viewModel!.setLastPriceIcon(
                                  themeSupport().isSelectedDarkMode()
                                      ? upSortLight
                                      : upSort);
                              widget.viewModel!.filteredListWithLastPrice();
                              widget.viewModel!.setfilteredTradePairs(widget
                                  .viewModel!.filteredList!.reversed
                                  .toList());
                              widget.viewModel!.setLastOrder(false);
                            } else {
                              widget.viewModel!.setLastPriceIcon(
                                  themeSupport().isSelectedDarkMode()
                                      ? downSortLight
                                      : downSort);
                              widget.viewModel!.filteredListWithLastPrice();
                              widget.viewModel!.setLastOrder(true);
                            }
                          } else {
                            widget.viewModel!.setLastPriceIcon(normalSort);
                            widget.viewModel!.setLastCount(0);
                            widget.viewModel!.setfilteredTradePairs(
                                widget.viewModel!.viewModelTradePairs!);
                          }
                        },
                        child: buildTextWithSort(stringVariables.lastPrice,
                            widget.viewModel!.lastPriceIcon)),
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
                          if (widget.viewModel!.h24Counter < 2) {
                            widget.viewModel!.set24HCount(
                                (widget.viewModel!.h24Counter + 1));
                            if (widget.viewModel!.h24Order) {
                              widget.viewModel!.set24hChangeIcon(
                                  themeSupport().isSelectedDarkMode()
                                      ? upSortLight
                                      : upSort);
                              widget.viewModel!.filteredListWithChangePercent();
                              widget.viewModel!.setfilteredTradePairs(widget
                                  .viewModel!.filteredList!.reversed
                                  .toList());
                              widget.viewModel!.set24HOrder(false);
                            } else {
                              widget.viewModel!.set24hChangeIcon(
                                  themeSupport().isSelectedDarkMode()
                                      ? downSortLight
                                      : downSort);
                              widget.viewModel!.filteredListWithChangePercent();
                              widget.viewModel!.set24HOrder(true);
                            }
                          } else {
                            widget.viewModel!.set24hChangeIcon(normalSort);
                            widget.viewModel!.set24HCount(0);
                            widget.viewModel!.setfilteredTradePairs(
                                widget.viewModel!.viewModelTradePairs!);
                          }
                        },
                        child: buildTextWithSort(stringVariables.h24Change,
                            widget.viewModel!.h24ChangeIcon)),
                  ],
                ),
              ],
            ),
            list!.isEmpty
                ? Center(child: CustomLoader())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      ListOfTradePairs listOfTradePairs =
                          (widget.pair == "ALT" || widget.pair == "FIAT")
                              ? widget.viewModel!.viewModelTradePairs![index]
                              : widget.viewModel!
                                  .getFilteredList(widget.pair!)![index];
                      return CustomContainer(
                        width: 1,
                        height: 12.5,
                        child: buildDrawerTradePair(listOfTradePairs),
                      );
                    }),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerTradePair(ListOfTradePairs listOfTradePairs) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.viewModel!.setTradePair(listOfTradePairs.symbol!);
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
                    text: listOfTradePairs.symbol!.split("/").first,
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
                    ? "+" + trimAs2(listOfTradePairs.priceChangePercent!) + "%"
                    : trimAs2(listOfTradePairs.priceChangePercent!) + "%",
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 12,
              ),
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
}

class SliderThumbShape extends SliderComponentShape {
  const SliderThumbShape({
    this.enabledThumbRadius = 5.0,
    required this.disabledThumbRadius,
    this.elevation = 0.0,
    this.pressedElevation = 6.0,
  });

  final double enabledThumbRadius;

  final double disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  final double elevation;

  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);
    assert(!sizeWithOverflow.isEmpty);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    {
      final Path path = Path()
        ..addArc(
            Rect.fromCenter(
                center: center, width: 1 * radius, height: 1 * radius),
            0,
            math.pi * 2);

      Paint paint = Paint()..color = white;
      paint.strokeWidth = 4;
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(
        center,
        radius,
        paint,
      );
      {
        Paint paint = Paint()..color = themeColor;
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
          center,
          radius,
          paint,
        );
      }
    }
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
