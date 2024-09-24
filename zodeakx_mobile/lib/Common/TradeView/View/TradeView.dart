import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Common/TradeView/ViewModel/TradeViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../Model/TradeHistoryModel.dart';

class TradeView extends StatefulWidget {
  final String pair;

  const TradeView({Key? key, required this.pair}) : super(key: key);

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> with TickerProviderStateMixin {
  late TabController _tabController;
  late TradeViewModel viewModel;
  late MarketViewModel marketViewModel;
  late ExchangeViewModel exchangeViewModel;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _drawerTabController;
  final TextEditingController _searchPairController = TextEditingController();
  GlobalKey fiatKey = GlobalKey();
  GlobalKey altKey = GlobalKey();
  String url = "";
  String? previousLastPrice = "0";
  bool isLogin = false;
  late InAppWebViewController _webViewController;
  CommonViewModel? commonViewModel;

  @override
  void initState() {
    viewModel = Provider.of<TradeViewModel>(context, listen: false);
    exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    isLogin = constant.userLoginStatus.value;
    //   viewModel.fetchData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {});
    _drawerTabController = TabController(length: isLogin ? 6 : 5, vsync: this);
    _drawerTabController.addListener(() {
      viewModel.setDrawerIndex(_drawerTabController.index);
      if (!_drawerTabController.indexIsChanging) {
        Future.delayed(Duration(milliseconds: 500), () {
          exchangeViewModel.restartSocketForDrawer();
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setDrawerIndex(0);
      viewModel.setLoading(true);
      viewModel.setTradePair(widget.pair);
      exchangeViewModel.setsearchFilterView(false);
      exchangeViewModel.setSearchText("");
      Provider.of<CommonViewModel>(context, listen: false)
          .searchPairController
          .clear();
      viewModel.setsearchFilterView(false);
      viewModel.setLoaderForChart(true);
      viewModel.setSearchText("");
      commonViewModel?.getLiquidityStatus("TradeView");
    });
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exchangeViewModel.pairIcon = normalSort;
      exchangeViewModel.lastPriceIcon = normalSort;
      exchangeViewModel.h24ChangeIcon = normalSort;
      exchangeViewModel.albOrder = true;
      exchangeViewModel.albCounter = 0;
      exchangeViewModel.lastOrder = true;
      exchangeViewModel.lastCounter = 0;
      exchangeViewModel.h24Order = true;
      exchangeViewModel.set24HCount(0);
      viewModel.setWebLoad(false);
    });
    if (constant.okxStatus.value) {
      await viewModel.unSubscribeChannel();
      await viewModel.unSubscribeAllTradePairsChannel();
    } else if (constant.binanceStatus.value) {
      viewModel.leaveSocket();
    }
    _tabController.dispose();

    _drawerTabController.dispose();
  }

  navigateToLogin() {
    moveToRegister(context, true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<TradeViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    exchangeViewModel = context.watch<ExchangeViewModel>();
    isLogin = constant.userLoginStatus.value;
    return Provider<TradeViewModel>(
      create: (context) => viewModel,
      child: buildTradeView(size),
    );
  }

  Widget buildTradeView(Size size) {
    String value = constant.isLive ? "prod" : "demo";
    var dark = themeSupport().isSelectedDarkMode() ? "Dark" : "Light";
    return WillPopScope(
      onWillPop: () async => true,
      child: CustomScaffold(
        scaffoldKey: scaffoldKey,
        drawer: sideMenuTrade(size),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Builder(builder: (context) {
            return CustomContainer(
              width: 1,
              height: 1,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (isLogin) {
                              exchangeViewModel.updateFavTradePair();
                            } else {
                              navigateToLogin();
                            }
                          },
                          child: CustomContainer(
                            padding: 2.5,
                            width: 16,
                            height: 24,
                            child: SvgPicture.asset(
                              exchangeViewModel.isFav
                                  ? favouriteFilled
                                  : favourite,
                              color: themeSupport().isSelectedDarkMode()
                                  ? white
                                  : black,
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.025,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                        if (constant.okxStatus.value) {
                          viewModel.unSubscribeChannel();
                          viewModel.unSubscribeAllTradePairsChannel();
                        } else if (constant.binanceStatus.value) {
                          viewModel.leaveSocket();
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
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        if (constant.binanceStatus.value) {
                          marketViewModel.ws?.close();
                          marketViewModel.webSocket?.clearListeners();
                        } else if (constant.okxStatus.value) {
                          viewModel.unSubscribeChannel();
                        }
                        scaffoldKey.currentState?.openDrawer();
                        viewModel.setDrawerFlag(true);
                        viewModel.getTradeSocket();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomContainer(
                        width: 2,
                        height: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              exchangeBlack,
                              width: 14,
                              color: themeSupport().isSelectedDarkMode()
                                  ? white
                                  : black,
                            ),
                            CustomSizedBox(
                              width: size.width * 0.00005,
                            ),
                            CustomText(
                              text: viewModel.pair,
                              fontsize: 20,
                              color: themeSupport().isSelectedDarkMode()
                                  ? white
                                  : black,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        //buildHeader(),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildHeader(),
                          Column(children: <Widget>[
                            CustomContainer(
                                width: 1,
                                height: 1.6,
                                //color: Colors.amber,
                                child: Container(
                                  //color: Colors.red,
                                  child: InAppWebView(
                                    initialUrlRequest: URLRequest(
                                        url: Uri.parse(
                                          'http://localhost:8082/assets/index.html',
                                        ),
                                        headers: {
                                          'Access-Control-Allow-Origin': '*'
                                        }),

                                    // onReceivedHttpError:
                                    //     (controller, request, errorResponse) {
                                    //   print(errorResponse.reasonPhrase);
                                    //   print(errorResponse.statusCode);
                                    // },

                                    onLoadStart: (controller, url) {
                                      print(url);
                                    },
                                    // onReceivedError:
                                    //     (controller, request, error) {
                                    //   _webViewController = controller;
                                    //   print(
                                    //       "***********************************************");
                                    //   //print(url);
                                    //   print(request.url);
                                    //   print(error.description);
                                    // },

                                    onLoadError:
                                        (controller, url, code, message) {
                                      _webViewController = controller;
                                      print(url);
                                      print(code);
                                      print(message);
                                    },
                                    onConsoleMessage:
                                        (controller, consoleMessage) {
                                      print(consoleMessage.messageLevel
                                          .toString());
                                      print(consoleMessage.message);
                                      print(consoleMessage.toJson());
                                    },
                                    onProgressChanged:
                                        (controller, progress) async {
                                      _webViewController = controller;
                                      viewModel.webViewController = controller;
                                      if (progress == 100) {
                                        var money = json.encode({});

                                        print(jsonDecode(viewModel
                                            .SAMPLE_TRADE_SYMBOLS
                                            .toString()));
                                        print(jsonDecode(viewModel
                                            .SAMPLE_TRADE_SYMBOLS
                                            .toString()));
                                        //${viewModel.pair}
                                        var apiDemo = await _webViewController
                                            .evaluateJavascript(
                                                source:
                                                    'TradeViewChart("Zodeakx","${viewModel.pair}",${constant.binanceStatus.value},${constant.okxStatus.value},${viewModel.SAMPLE_TRADE_SYMBOLS},"$value","${constant.baseUrl}","${constant.baseSocketUrl}",)');
                                        var dark = checkBrightness.value ==
                                                Brightness.dark
                                            ? "Dark"
                                            : "Light";
                                        securedPrint("dark1${dark}");
                                        Future.delayed(
                                            Duration(milliseconds: 500),
                                            () async {
                                          _webViewController.evaluateJavascript(
                                              source:
                                                  'changeTradeViewTheme("$dark")');
                                        });

                                        // print(apiDemo.toString());
                                      }
                                    },

                                    shouldOverrideUrlLoading:
                                        (controller, navigationAction) async {
                                      return NavigationActionPolicy.ALLOW;
                                    },

                                    // initialSettings: InAppWebViewSettings(
                                    //   javaScriptEnabled: true,
                                    //   supportZoom: false,
                                    //   javaScriptCanOpenWindowsAutomatically:
                                    //       true,
                                    //   cacheEnabled: false,
                                    //   allowFileAccessFromFileURLs: false,
                                    //   useShouldOverrideUrlLoading: true,
                                    // ),

                                    initialOptions: InAppWebViewGroupOptions(
                                      crossPlatform: InAppWebViewOptions(
                                          javaScriptEnabled: true,
                                          javaScriptCanOpenWindowsAutomatically:
                                              true,
                                          cacheEnabled: false,
                                          allowFileAccessFromFileURLs: false,
                                          useShouldOverrideUrlLoading: true),
                                    ),
                                    gestureRecognizers: Set()
                                      ..add(
                                          Factory<OneSequenceGestureRecognizer>(
                                              () => EagerGestureRecognizer())),
                                  ),
                                )),
                          ]),
                          tab(size),
                        ],
                      ),
                    ),
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  Row(
                    children: [
                      CustomSizedBox(
                        width: 0.03,
                      ),
                      Flexible(
                        child: CustomElevatedButton(
                            text: stringVariables.buy.toUpperCase(),
                            multiClick: true,
                            color: white,
                            press: () {
                              exchangeViewModel.setTabView(true);
                              if (constant.okxStatus.value) {
                                viewModel.unSubscribeChannel();
                                viewModel.unSubscribeAllTradePairsChannel();
                              } else if (constant.binanceStatus.value) {
                                viewModel.leaveSocket();
                              }
                              Navigator.pop(context);
                            },
                            radius: 25,
                            buttoncolor: green,
                            width: 1,
                            height: MediaQuery.of(context).size.height / 40,
                            isBorderedButton: false,
                            maxLines: 1,
                            icons: false,
                            blurRadius: 0,
                            spreadRadius: 0,
                            icon: null),
                      ),
                      CustomSizedBox(
                        width: 0.04,
                      ),
                      Flexible(
                        child: CustomElevatedButton(
                            text: stringVariables.sell.toUpperCase(),
                            multiClick: true,
                            color: white,
                            press: () {
                              exchangeViewModel.setTabView(false);
                              if (constant.okxStatus.value) {
                                viewModel.unSubscribeChannel();
                                viewModel.unSubscribeAllTradePairsChannel();
                              } else if (constant.binanceStatus.value) {
                                viewModel.leaveSocket();
                              }
                              Navigator.pop(context);
                            },
                            radius: 25,
                            buttoncolor: red,
                            width: 1,
                            height: MediaQuery.of(context).size.height / 40,
                            isBorderedButton: false,
                            maxLines: 1,
                            blurRadius: 0,
                            spreadRadius: 0,
                            icons: false,
                            icon: null),
                      ),
                      CustomSizedBox(
                        width: 0.03,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                ],
              ),
      ),
    );
  }

  Widget tab(Size size) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            height: 50,
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: themeColor,
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
              ),
              unselectedLabelColor: Colors.grey,
              labelColor:
                  checkBrightness.value == Brightness.dark ? white : black,
              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              tabs: [
                Tab(
                  text: stringVariables.orderBook,
                ),
                Tab(
                  text: stringVariables.trades,
                ),
              ],
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          tabBarView4(size),
        ],
      ),
    );
  }

  tabBarView4(Size size) {
    return CustomContainer(
      width: 1,
      height: 2.5,
      child: TabBarView(
        controller: _tabController,
        children: [
          orderBook(),
          tradesHistory(size),
        ],
      ),
    );
  }

  noRecords() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSizedBox(
          height: 0.05,
        ),
        CustomText(
          text: stringVariables.notFound,
          fontsize: 15,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  orderBook() {
    int? buyOrdersSize = viewModel.getOpenOrders!.bids!.isEmpty
        ? 0
        : viewModel.getOpenOrders?.bids?.length;
    int sellOrdersSize = viewModel.getOpenOrders!.asks!.isEmpty
        ? 0
        : viewModel.getOpenOrders!.asks!.length;
    List<List<dynamic>>? buyOrders =
        viewModel.getOpenOrders!.bids!.reversed.toList();
    List<List<dynamic>>? sellOrders =
        viewModel.getOpenOrders!.asks!.reversed.toList();
    return CustomContainer(
      height: 2,
      child: Row(
        children: [
          CustomSizedBox(
            width: 0.03,
          ),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(text: stringVariables.bid),
                    CustomContainer(
                      height: 25,
                    )
                  ],
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                Flexible(
                  child: buyOrdersSize == 0
                      ? noRecords()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: buyOrdersSize,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    exchangeViewModel.tabController.index = 0;
                                    exchangeViewModel.buyLimitController.text =
                                        buyOrders[index].first.toString();
                                    exchangeViewModel.setTabView(true);
                                    if (constant.okxStatus.value) {
                                      viewModel.unSubscribeChannel();
                                      viewModel
                                          .unSubscribeAllTradePairsChannel();
                                    } else if (constant.binanceStatus.value) {
                                      viewModel.leaveSocket();
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: trimAsLength(
                                            buyOrders[index].first.toString(),
                                            viewModel.selectedDecimal
                                                .split(".")
                                                .last
                                                .length),
                                        color: green,
                                        fontsize: 15 -
                                            ((buyOrders[index]
                                                            .first
                                                            .toString()
                                                            .split(".")
                                                            ?.first
                                                            .length ??
                                                        0) /
                                                    1.5)
                                                .toDouble(),
                                      ),
                                      CustomText(
                                        text: trimDecimalsForBalance(
                                            buyOrders[index].last.toString()),
                                        fontsize: (buyOrders[index]
                                                        .first
                                                        .toString()
                                                        .split(".")
                                                        ?.first
                                                        .length ??
                                                    0) >
                                                3
                                            ? 12
                                            : 14,
                                      )
                                    ],
                                  ),
                                ),
                                CustomSizedBox(
                                  height: 0.01,
                                )
                              ],
                            );
                          }),
                )
              ],
            ),
          ),
          CustomSizedBox(
            width: 0.05,
          ),
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(text: stringVariables.ask),
                    CustomSizedBox(
                      width: 0.06,
                    ),
                    CustomContainer(
                      padding: 0,
                      width: 4,
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 0.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                      ),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(30.0),
                            isExpanded: true,
                            icon: Visibility(
                                visible: false,
                                child: Icon(Icons.arrow_downward)),
                            underline: SizedBox(),
                            items: viewModel.decimals.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CustomText(
                                      text: val,
                                      fontWeight: FontWeight.w700,
                                      fontsize: 10,
                                      color: themeSupport().isSelectedDarkMode()
                                          ? white
                                          : black,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            hint: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: viewModel.selectedDecimal,
                                  fontWeight: FontWeight.w700,
                                  fontsize: 9,
                                  color: themeSupport().isSelectedDarkMode()
                                      ? white
                                      : black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: SvgPicture.asset(
                                    dropDownArrowImage,
                                    color: hintLight,
                                    width: 6,
                                    height: 6,
                                  ),
                                ),
                              ],
                            ),
                            onChanged: (val) {
                              viewModel.setSelectedDecimal(val.toString());
                            }),
                      ),
                    ),
                  ],
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                Flexible(
                  child: sellOrdersSize == 0
                      ? noRecords()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: sellOrdersSize,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    exchangeViewModel.tabController.index = 1;
                                    exchangeViewModel.sellLimitController.text =
                                        sellOrders[index].first.toString();
                                    exchangeViewModel.setTabView(false);
                                    if (constant.okxStatus.value) {
                                      viewModel.unSubscribeChannel();
                                      viewModel
                                          .unSubscribeAllTradePairsChannel();
                                    } else if (constant.binanceStatus.value) {
                                      viewModel.leaveSocket();
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: trimAsLength(
                                            sellOrders![index].first.toString(),
                                            viewModel.selectedDecimal
                                                .split(".")
                                                .last
                                                .length),
                                        color: red,
                                        fontsize: 15 -
                                            ((sellOrders[index]
                                                            .first
                                                            .toString()
                                                            .split(".")
                                                            ?.first
                                                            .length ??
                                                        0) /
                                                    1.5)
                                                .toDouble(),
                                      ),
                                      CustomText(
                                        text: trimDecimalsForBalance(
                                            sellOrders[index].last.toString()),
                                        fontsize: (sellOrders[index]
                                                        .first
                                                        .toString()
                                                        .split(".")
                                                        ?.first
                                                        .length ??
                                                    0) >
                                                3
                                            ? 12
                                            : 14,
                                      )
                                    ],
                                  ),
                                ),
                                CustomSizedBox(
                                  height: 0.01,
                                ),
                              ],
                            );
                          }),
                )
              ],
            ),
          ),
          CustomSizedBox(
            width: 0.03,
          ),
        ],
      ),
    );
  }

  tradesHistory(Size size) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              CustomSizedBox(
                width: 0.03,
              ),
              CustomText(
                text: stringVariables.tradeHistory,
                fontsize: 15,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Row(
            children: [
              CustomElevatedButton(
                  buttoncolor: viewModel.marketFlag ? themeColor : enableBorder,
                  color: viewModel.marketFlag
                      ? themeSupport().isSelectedDarkMode()
                          ? black
                          : white
                      : black,
                  press: () {
                    viewModel.marketFlag ? () {} : viewModel.setMarketView();
                  },
                  width: 5,
                  isBorderedButton: true,
                  maxLines: 1,
                  icon: null,
                  multiClick: true,
                  text: stringVariables.markets,
                  radius: 25,
                  height: 30,
                  fontSize: 12,
                  icons: false,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, 0)),
              CustomSizedBox(
                width: 0.04,
              ),
              CustomElevatedButton(
                  buttoncolor: viewModel.marketFlag ? enableBorder : themeColor,
                  color: viewModel.marketFlag
                      ? black
                      : themeSupport().isSelectedDarkMode()
                          ? black
                          : white,
                  press: () {
                    viewModel.marketFlag ? viewModel.setMarketView() : () {};
                  },
                  width: 5,
                  isBorderedButton: true,
                  maxLines: 1,
                  icon: null,
                  multiClick: true,
                  text: stringVariables.yours,
                  radius: 25,
                  height: 30,
                  fontSize: 12,
                  icons: false,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, 0)),
              CustomSizedBox(
                width: 0.03,
              ),
            ],
          )
        ]),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(children: [
          CustomSizedBox(
            width: 0.03,
          ),
          Flexible(
            child: Row(
              children: [
                CustomText(
                    text: stringVariables.price +
                        " (" +
                        viewModel.pair.split("/").last +
                        ")"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    text: stringVariables.amount +
                        " (" +
                        viewModel.pair.split("/").first +
                        ")"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                    text: stringVariables.total +
                        " (" +
                        viewModel.pair.split("/").last +
                        ")"),
              ],
            ),
          ),
          CustomSizedBox(
            width: 0.03,
          ),
        ]),
        CustomSizedBox(
          height: 0.01,
        ),
        (viewModel.marketFlag
                ? viewModel.tradeHistory.isNotEmpty
                : viewModel.yoursTradeHistory.isNotEmpty)
            ? Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.marketFlag
                        ? viewModel.tradeHistory!.length
                        : viewModel.yoursTradeHistory!.length,
                    itemBuilder: (BuildContext context, int index) {
                      TradesHistory? tradeHistory = viewModel.marketFlag
                          ? viewModel.tradeHistory[index]
                          : viewModel.yoursTradeHistory[index];
                      double total = double.parse(tradeHistory.price ?? "0") *
                          double.parse(tradeHistory.qty ?? "0");
                      return Column(
                        children: [
                          Row(children: [
                            CustomSizedBox(
                              width: 0.03,
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  CustomText(
                                    text: trimDecimalsForBalance(
                                        tradeHistory.price ?? "0"),
                                    color: tradeHistory.side!.toLowerCase() ==
                                            stringVariables.buy.toLowerCase()
                                        ? green
                                        : red,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: trimDecimalsForBalance(
                                        tradeHistory.qty ?? "0"),
                                    color: tradeHistory.side!.toLowerCase() ==
                                            stringVariables.buy.toLowerCase()
                                        ? green
                                        : red,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    text: trimDecimalsForBalance(
                                        total.toString()),
                                    color: tradeHistory.side!.toLowerCase() ==
                                            stringVariables.buy.toLowerCase()
                                        ? green
                                        : red,
                                  ),
                                ],
                              ),
                            ),
                            CustomSizedBox(
                              width: 0.03,
                            ),
                          ]),
                          CustomSizedBox(
                            height: 0.01,
                          ),
                        ],
                      );
                    }),
              )
            : noRecords(),
      ],
    );
  }

  Widget buildHeader() {
    ListOfTradePairs? priceTickers = viewModel.viewModelpriceTickersModel?[0];

    if (double.parse(previousLastPrice!) !=
        double.parse(priceTickers?.lastPrice ?? "0")) {
      if (double.parse(previousLastPrice!) <
          double.parse(priceTickers?.lastPrice ?? "0")) {
        viewModel.setBuySellFlag(true);
      } else {
        viewModel.setBuySellFlag(false);
      }
      previousLastPrice = priceTickers?.lastPrice ?? "0";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                child: CustomContainer(
                  width: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: trimDecimalsForBalance(
                            priceTickers?.lastPrice.toString() ?? "0"),
                        color: viewModel.buySellFlag ? green : red,
                        fontsize: 28,
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text:
                                '${"~\$${trimDecimals(viewModel.estimateFiatValue.toString())}"}',
                            fontsize: 15,
                          ),
                          CustomSizedBox(
                            width: 0.02,
                          ),
                          CustomText(
                            text:
                                '${'${trimAs2(priceTickers?.priceChangePercent.toString() ?? "0")}%'}',
                            color: double.parse(
                                        priceTickers?.priceChangePercent ??
                                            "0") >
                                    0
                                ? green
                                : red,
                            fontsize: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: CustomContainer(
                  width: 1,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextWithData(
                              stringVariables.h24High,
                              trimDecimalsForBalance(
                                  priceTickers?.highPrice ?? "0")),
                          CustomSizedBox(
                            width: 0.05,
                          ),
                          buildTextWithData(
                              stringVariables.h24Low,
                              trimDecimalsForBalance(
                                  priceTickers?.lowPrice ?? "0")),
                        ],
                      ),
                      CustomSizedBox(
                        width: 0.025,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextWithData(
                              '${stringVariables.h24Vol}(${viewModel.pair.split("/").last})',
                              trimDecimals(priceTickers?.quoteVolume ?? "0")),
                          CustomSizedBox(
                            width: 0.05,
                          ),
                          buildTextWithData(
                            stringVariables.h24Change,
                            trimDecimalsForBalance(
                                priceTickers?.priceChange ?? "0"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CustomSizedBox(
                width: 0.01,
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

  Column buildTextWithData(
    String label,
    String txt,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: textGrey,
          fontsize: 15,
        ),
        CustomSizedBox(
          height: 0.005,
        ),
        CustomText(
          text: txt,
        )
      ],
    );
  }

  ///To tap user icon in APPBAR it shows the SideMenu
  Widget sideMenuTrade(Size size) {
    return Drawer(
      backgroundColor: themeSupport().isSelectedDarkMode() ? black : grey,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconButton(
                      onPress: () {
                        Navigator.pop(context);
                        commonViewModel?.getLiquidityStatus("TradeView");
                        viewModel.getTradeSocket();
                      },
                      child: Icon(Icons.close_sharp),
                    ),
                  ],
                ),
                CustomTextFormField(
                  press: () {
                    _searchPairController.clear();
                    onSearchTextChanged(
                      _searchPairController.text,
                    );
                    onSearchTextChanged('');
                  },
                  onChanged: onSearchTextChanged,
                  controller: _searchPairController,
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
                ? listItemsOfSearch(
                    exchangeViewModel.drawerFilteredTradePairs ?? [])
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

  tabBarView() {
    return TabBarView(controller: _drawerTabController, children: [
      if (isLogin)
        CustomDrawerTab(
          pair: stringVariables.favourite,
          viewModel: exchangeViewModel,
          tradeViewModel: viewModel,
        ),
      CustomDrawerTab(
        pair: exchangeViewModel.staticPairs[0],
        viewModel: exchangeViewModel,
        tradeViewModel: viewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.staticPairs[1],
        viewModel: exchangeViewModel,
        tradeViewModel: viewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.staticPairs[2],
        viewModel: exchangeViewModel,
        tradeViewModel: viewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.staticPairs[3],
        viewModel: exchangeViewModel,
        tradeViewModel: viewModel,
      ),
      // CustomDrawerTab(
      //   pair: exchangeViewModel.alt,
      //   viewModel: exchangeViewModel,
      // ),
      CustomDrawerTab(
        pair: exchangeViewModel.fiat,
        viewModel: exchangeViewModel,
        tradeViewModel: viewModel,
      ),
    ]);
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
                    onTap: () async {
                      if (constant.okxStatus.value) {
                        viewModel.unSubscribeAllTradePairsChannel();
                      } else if (constant.binanceStatus.value) {
                        marketViewModel.ws?.close();
                        marketViewModel.webSocket?.clearListeners();
                      }
                      viewModel.setDrawerFlag(false);
                      await viewModel.setTradePair(list[index].symbol!);
                      Scaffold.of(context).closeDrawer();
                      viewModel.setLoaderForChart(true);
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

  onSearchTextChanged(
    String text,
  ) async {
    text.isEmpty
        ? viewModel.setsearchFilterView(false)
        : viewModel.setsearchFilterView(true);
    viewModel.setSearchText(text);
    var filtered = exchangeViewModel.viewModelTradePairs!
        .where((element) =>
            element.symbol!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    exchangeViewModel.setDrawerFilteredTradePairs(filtered);
  }

  Widget tabItems(Size size, String text, GlobalKey key,
      ValueChanged onSelected, List<String> list, int index) {
    bool fiatSelected = viewModel.drawerIndex == (isLogin ? 5 : 4);
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
}

class CustomDrawerTab extends StatefulWidget {
  String? pair;
  ExchangeViewModel? viewModel;
  TradeViewModel? tradeViewModel;

  CustomDrawerTab({Key? key, this.pair, this.viewModel, this.tradeViewModel})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    marketViewModel = context.watch<MarketViewModel>();
    List<ListOfTradePairs>? list =
        (widget.pair == "ALT" || widget.pair == "FIAT")
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
              ListOfTradePairs listOfTradePairs = (widget.pair == "ALT" ||
                      widget.pair == "FIAT")
                  ? widget.viewModel!.viewModelTradePairs![index]
                  : (widget.pair == stringVariables.favourite)
                      ? widget.viewModel!.favFilteredList[index]
                      : widget.viewModel!.getFilteredList(widget.pair!)![index];
              return buildDrawerTradePair(listOfTradePairs);
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

  Widget buildDrawerTradePair(ListOfTradePairs listOfTradePairs) {
    num leverage = (listOfTradePairs.enableMarginCross ?? false)
        ? 3
        : (listOfTradePairs.enableMarginIsolated ?? false)
            ? int.parse(listOfTradePairs.leverageIsolated ?? "0")
            : 0;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (constant.okxStatus.value) {
            widget.tradeViewModel!.unSubscribeAllTradePairsChannel();
          } else if (constant.binanceStatus.value) {
            marketViewModel.ws?.close();
            marketViewModel.webSocket?.clearListeners();
          }
          widget.tradeViewModel?.setDrawerFlag(false);
          await widget.tradeViewModel!.setTradePair(listOfTradePairs.symbol!);
          Scaffold.of(context).closeDrawer();
          widget.tradeViewModel!.setLoaderForChart(true);
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
                    CustomSizedBox(
                      width: 0.01,
                    ),
                    if (leverage != 0)
                      CustomContainer(
                        decoration: BoxDecoration(
                          color: themeSupport().isSelectedDarkMode()
                              ? enableBorder.withOpacity(0.25)
                              : enableBorder.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.75),
                          child: CustomText(
                            text: "${leverage}x",
                            softwrap: true,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 12,
                            fontWeight: FontWeight.w600,
                            color: themeColor,
                          ),
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
