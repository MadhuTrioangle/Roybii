import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Common/TradeView/ViewModel/TradeViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/NativeChannelListener.dart';
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
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';
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
  late ExchangeViewModel exchangeViewModel;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _drawerTabController;
  final TextEditingController _searchPairController = TextEditingController();
  GlobalKey fiatKey = GlobalKey();
  GlobalKey altKey = GlobalKey();
  List<String> decimals = [
    "0.000001",
    "0.0000001",
    "0.00000001",
    "0.000000001"
  ];
  String url = "";
  double progress = 0;
  late Uri uri;

  

  @override
  void initState() {
    viewModel = Provider.of<TradeViewModel>(context, listen: false);
    exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    widget.pair == null ? viewModel.fetchData() : () {};
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {});
    _drawerTabController = TabController(length: 5, vsync: this);
    _drawerTabController.addListener(() {
      if (!_drawerTabController.indexIsChanging) {
        Future.delayed(Duration(milliseconds: 500), () {
          exchangeViewModel.restartSocketForDrawer();
        });
      }
    });


    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.pair != null ? viewModel.setTradePair(widget.pair!) : () {};
      exchangeViewModel.setsearchFilterView(false);
      exchangeViewModel.setSearchText("");
      Provider
          .of<CommonViewModel>(context, listen: false)
          .searchPairController
          .clear();
      viewModel.setsearchFilterView(false);
      viewModel.setSearchText("");
        FlutterNativeCodeListenerMethodChannel.instance.methodChannel!
        .setMethodCallHandler(viewModel.methodHandler);
    });
  }

  @override
  void dispose() {
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
    _tabController.dispose();
    viewModel.leaveSocket();
    _drawerTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    viewModel = context.watch<TradeViewModel>();
    exchangeViewModel = context.watch<ExchangeViewModel>();
    return Provider<TradeViewModel>(
      create: (context) => viewModel,
      child: buildTradeView(size),
    );
  }

  Widget buildTradeView(Size size) {
           // This is used in the platform side to register the view.
  const String viewType = '<platform-view-type>';
  // Pass parameters to the platform side.
  final Map<String, dynamic> creationParams = <String, dynamic>{};

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
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SvgPicture.asset(
                          backArrow,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        scaffoldKey.currentState?.openDrawer();
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
            ? const Center(child: CustomLoader())
            : GestureDetector(
              onVerticalDragDown: (details) {
                print("Done");
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                      child: Column(
              children: [
                buildHeader(),
                Container(
                  child: Column(children: <Widget>[
                    CustomContainer(
                      width: 1,
                      height: 2,
                      // child: InAppWebView(
                      //   gestureRecognizers: Set()
                      //     ..add(Factory<OneSequenceGestureRecognizer>(
                      //             () => EagerGestureRecognizer())),
                      //   initialUrlRequest: URLRequest(
                      //       url: Uri.parse(
                      //           "${constant.chartUrl}${viewModel.pair
                      //               .split("/")
                      //               .first}_${viewModel.pair
                      //               .split("/")
                      //               .last}/chart?theme=${themeSupport()
                      //               .isSelectedDarkMode() ? "dark" : "light"}")),
                      //   initialOptions: InAppWebViewGroupOptions(
                      //       crossPlatform: InAppWebViewOptions(
                      //           cacheEnabled: false,
                      //           clearCache: true,
                      //           javaScriptEnabled: true,
                      //           javaScriptCanOpenWindowsAutomatically:
                      //           true)),
                      //   onWebViewCreated:
                      //       (InAppWebViewController controller) {
                      //     viewModel.webViewController = controller;
                      //   },
                      //   onLoadStart:
                      //       (InAppWebViewController controller, Uri? uri) {
                      //     setState(() {
                      //       this.uri = uri!;
                      //     });
                      //   },
                      //   onLoadStop:
                      //       (InAppWebViewController controller, Uri? uri) {
                      //     setState(() {
                      //       this.uri = uri!;
                      //     });
                      //     if (viewModel.webLoad) {
                      //       viewModel.webViewController?.loadUrl(
                      //         urlRequest: URLRequest(url: Uri.parse(
                      //             "${constant.chartUrl}${viewModel.pair
                      //                 .split("/")
                      //                 .first}_${viewModel.pair
                      //                 .split("/")
                      //                 .last}/chart?theme=${themeSupport()
                      //                 .isSelectedDarkMode()
                      //                 ? "dark"
                      //                 : "light"}"))
                      //     );
                      //     viewModel.setWebLoad(false);
                      //     }
                      //     },
                      //   onProgressChanged:
                      //       (InAppWebViewController controller,
                      //       int progress) {
                      //     setState(() {
                      //       this.progress = progress / 100;
                      //     });
                      //   },
                      // ),
                      child: UiKitView(viewType: viewType,
                          layoutDirection: TextDirection.ltr,
                          creationParams: {
                            "width" : MediaQuery.of(context).size.width / (1),
                            "height": MediaQuery.of(context).size.height / (2),
                            "platform": Platform.isIOS ? "iOS" : "Android",
                            "intialData": {}
                          },
                          onPlatformViewCreated: (id) {
                            securedPrint("Created");
                          },
                          creationParamsCodec: const StandardMessageCodec(),),
                    ),
                  ]),
                ),
                tab(size),
              ],
                      ),
                    ),
            ),
      ),
    );
  }

  Widget tab(Size size) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // the tab bar with two items
          Container(
            height: 50,
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: themeColor,
              labelColor:
              checkBrightness.value == Brightness.dark ? white : black,
              labelStyle: TextStyle(
                fontSize: 12,
              ),
              tabs: [
                Tab(
                  text: stringVariables.orderBook,
                ),
                Tab(
                  text: "Trades",
                ),
              ],
            ),
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
          viewModel.getOpenOrders != null
              ? Column(
            children: [
              orderBook(),
            ],
          )
              : Center(child: CustomLoader()),
          (viewModel.tradeHistory != null &&
              (viewModel.tradeHistory?.length ?? 0) > 0)
              ? Column(
            children: [
              tradesHistory(size),
            ],
          )
              : Center(child: CustomLoader()),
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
    int buyOrdersSize = viewModel.getOpenOrders!.bids!.length;
    int sellOrdersSize = viewModel.getOpenOrders!.asks!.length;
    List<List<dynamic>>? buyOrders =
    viewModel.getOpenOrders!.bids!.reversed.toList();
    List<List<dynamic>>? sellOrders =
    viewModel.getOpenOrders!.asks!.reversed.toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CustomText(text: stringVariables.bid),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomContainer(
                  height: 4,
                  width: 2.5,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: buyOrdersSize,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            CustomSizedBox(
                              height: 0.025,
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
                        );
                      }),
                )
              ],
            ),
            Column(
              children: [
                Row(
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
                            items: decimals.map((String val) {
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
                CustomContainer(
                  height: 4,
                  width: 2.5,
                  child: ListView.builder(
                      itemCount: sellOrdersSize,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                CustomSizedBox(
                                  height: 0.025,
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
                            CustomSizedBox(
                              height: 0.01,
                            ),
                          ],
                        );
                      }),
                )
              ],
            ),
          ],
        )
      ],
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
                width: 0.075,
              ),
              CustomText(text: stringVariables.tradeHistory),
            ],
          ),
          Row(
            children: [
              CustomElevatedButton(
                  buttoncolor: viewModel.marketFlag ? themeColor : enableBorder,
                  color: viewModel.marketFlag ? white : black,
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
              CustomSizedBox(width: 0.05),
              CustomElevatedButton(
                  buttoncolor: viewModel.marketFlag ? enableBorder : themeColor,
                  color: viewModel.marketFlag ? black : white,
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
                width: 0.075,
              ),
            ],
          )
        ]),
        CustomSizedBox(
          height: 0.01,
        ),
        Table(
          children: [
            TableRow(children: [
              Center(
                child: CustomText(
                    text: stringVariables.price +
                        " (" +
                        viewModel.pair
                            .split("/")
                            .last +
                        ")"),
              ),
              Center(
                child: CustomText(
                    text: stringVariables.amount +
                        " (" +
                        viewModel.pair
                            .split("/")
                            .first +
                        ")"),
              ),
              Center(
                child: CustomText(
                    text: stringVariables.total +
                        " (" +
                        viewModel.pair
                            .split("/")
                            .last +
                        ")"),
              ),
            ])
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomContainer(
          width: 1,
          height: 4,
          child: (viewModel.marketFlag
              ? (viewModel.tradeHistory != null &&
              viewModel.tradeHistory!.length != 0)
              : (viewModel.yoursTradeHistory != null &&
              viewModel.yoursTradeHistory!.length != 0))
              ? ListView.builder(
              shrinkWrap: true,
              itemCount: viewModel.marketFlag
                  ? viewModel.tradeHistory!.length
                  : viewModel.yoursTradeHistory!.length,
              itemBuilder: (BuildContext context, int index) {
                TradesHistory? tradeHistory = viewModel.marketFlag
                    ? viewModel.tradeHistory![index]
                    : viewModel.yoursTradeHistory![index];
                double total =
                    double.parse(tradeHistory.price!.toString()) *
                        double.parse(tradeHistory.qty!.toString());
                return Column(
                  children: [
                    Table(
                      children: [
                        TableRow(children: [
                          Center(
                            child: CustomText(
                              text: trimDecimalsForBalance(
                                  tradeHistory.price.toString()),
                              color: tradeHistory.side!.toLowerCase() ==
                                  stringVariables.buy.toLowerCase()
                                  ? green
                                  : red,
                            ),
                          ),
                          Center(
                            child: CustomText(
                              text:
                              trimDecimalsForBalance(tradeHistory.qty.toString()),
                              color: tradeHistory.side!.toLowerCase() ==
                                  stringVariables.buy.toLowerCase()
                                  ? green
                                  : red,
                            ),
                          ),
                          Center(
                            child: CustomText(
                              text: trimDecimalsForBalance(total.toString()),
                              color: tradeHistory.side!.toLowerCase() ==
                                  stringVariables.buy.toLowerCase()
                                  ? green
                                  : red,
                            ),
                          ),
                        ])
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                  ],
                );
              })
              : noRecords(),
        ),
      ],
    );
  }

  Widget buildHeader() {
    ListOfTradePairs priceTickers = viewModel.viewModelpriceTickersModel![0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          width: 0.0,
          height: 6.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSizedBox(
                width: 0.01,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: trimDecimalsForBalance(priceTickers.lastPrice.toString()),
                    color: green,
                    fontsize: 30,
                  ),
                  CustomSizedBox(
                    height: 0.005,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text:
                        '${"~\$${trimDecimalsForBalance(
                            viewModel.estimateFiatValue.toString())}"}',
                        fontsize: 15,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomText(
                        text:
                        '${'${trimAs2(
                            priceTickers.priceChangePercent.toString())}%'}',
                        color:
                        double.parse(priceTickers.priceChangePercent!) > 0
                            ? green
                            : red,
                        fontsize: 15,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.035,
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextWithData(
                          '24h High', trimDecimalsForBalance(priceTickers.highPrice!)),
                      CustomSizedBox(
                        width: 0.05,
                      ),
                      buildTextWithData(
                          '24h Low', trimDecimalsForBalance(priceTickers.lowPrice!)),
                    ],
                  ),
                  CustomSizedBox(
                    width: 0.025,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextWithData(
                          '24h Vol(${viewModel.pair
                              .split("/")
                              .last})',
                          trimDecimalsForBalance(priceTickers.quoteVolume!)),
                      CustomSizedBox(
                        width: 0.05,
                      ),
                      buildTextWithData(
                        '24h Change',
                        trimDecimalsForBalance(priceTickers.priceChange!),
                      ),
                    ],
                  ),
                ],
              ),
              CustomSizedBox(
                width: 0.01,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildTextWithData(String label,
      String txt,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: textGrey,
          fontsize: 16,
        ),
        CustomSizedBox(
          height: 0.005,
        ),
        CustomText(
          text: txt,
          fontsize: 16,
        )
      ],
    );
  }

  ///To tap user icon in APPBAR it shows the SideMenu
  Widget sideMenuTrade(Size size) {
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
              height: viewModel.searchFilterView ? 7.65 : 6.5,
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
                  ),
                ],
              ),
            ),
            viewModel.searchFilterView
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
                          viewModel.setTradePair(exchangeViewModel
                              .drawerFilteredTradePairs![index].symbol!);
                          scaffoldKey.currentState?.closeDrawer();
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
                                  text: trimDecimalsForBalance(exchangeViewModel
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
            viewModel.searchFilterView
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
        pair: exchangeViewModel.alt,
        viewModel: exchangeViewModel,
        tradeViewModel: viewModel,
      ),
      CustomDrawerTab(
        pair: exchangeViewModel.fiat,
        viewModel: exchangeViewModel,
        tradeViewModel: viewModel,
      ),
    ]);
  }

  onSearchTextChanged(String text,) async {
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
                      itemBuilder: (BuildContext context,) {
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
        widget.tradeViewModel!.setTradePair(listOfTradePairs.symbol!);
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
