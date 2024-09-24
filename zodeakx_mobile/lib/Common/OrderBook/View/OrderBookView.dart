import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Common/OrderBook/ViewModel/OrderBookViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/MarketScreen/Model/TradePairsModel.dart';

class OrderBookView extends StatefulWidget {
  final String pair;

  const OrderBookView({Key? key, required this.pair}) : super(key: key);

  @override
  State<OrderBookView> createState() => _OrderBookViewState();
}

class _OrderBookViewState extends State<OrderBookView> {
  List<String> decimals = [
    "0.000001",
    "0.0000001",
    "0.00000001",
    "0.000000001"
  ];
  late OrderBookViewModel viewModel;
  final GlobalKey _stateKey = GlobalKey();
  String? previousLastPrice = "0";
  late ExchangeViewModel exchangeViewModel;

  @override
  void initState() {
    super.initState();
    exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    viewModel = Provider.of<OrderBookViewModel>(context, listen: false);
    viewModel.fetchData();
    viewModel.tradePairs.clear();
    exchangeViewModel.viewModelTradePairs!.forEach((element) {
      viewModel.tradePairs.add(element.symbol!);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setTradePair(widget.pair);
      viewModel.setSelectedTradePair(viewModel.tradePairs.indexOf(widget.pair));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //viewModel.leaveSocket();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<OrderBookViewModel>();
    exchangeViewModel = context.watch<ExchangeViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider<OrderBookViewModel>(
        create: (context) => viewModel,
        child: buildOrderBookView(context, size));
  }

  Future<bool> willPopScopeCall() async {
    return true; // return true to exit app or return false to cancel exit
  }

  Widget buildOrderBookView(BuildContext context, Size size) {
    return WillPopScope(
      onWillPop: willPopScopeCall,
      child: CustomScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: CustomContainer(
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
                  alignment: AlignmentDirectional.center,
                  child: GestureDetector(
                    onTap: () {
                      dynamic state = _stateKey.currentState;
                      state.showButtonMenu();
                    },
                    child: AbsorbPointer(
                      child: CustomContainer(
                        width: 3,
                        height: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              fontfamily: 'InterTight',
                              fontsize: 20,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w800,
                              text: viewModel.tradePairs.isNotEmpty
                                  ? viewModel
                                      .tradePairs[viewModel.selectedTradePair]
                                  : viewModel.tradePair,
                              color: themeSupport().isSelectedDarkMode()
                                  ? white
                                  : black,
                            ),
                            CustomContainer(
                              width: 25,
                              height: 25,
                              child: PopupMenuButton(
                                padding: EdgeInsets.zero,
                                key: _stateKey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                offset: Offset(
                                    (MediaQuery.of(context).size.width / 15),
                                    0),
                                constraints: new BoxConstraints(
                                  minWidth: (MediaQuery.of(context).size.width /
                                      2.75),
                                  maxWidth: (MediaQuery.of(context).size.width /
                                      2.75),
                                  minHeight:
                                      (MediaQuery.of(context).size.height / 12),
                                  maxHeight:
                                      (MediaQuery.of(context).size.height /
                                          3.75),
                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: themeSupport().isSelectedDarkMode()
                                      ? white
                                      : black,
                                ),
                                onSelected: (value) {
                                  viewModel.setSelectedTradePair(viewModel
                                      .tradePairs
                                      .indexOf(value.toString()));
                                  viewModel.setTradePair(value.toString());
                                },
                                color: checkBrightness.value == Brightness.dark
                                    ? black
                                    : white,
                                itemBuilder: (
                                  BuildContext context,
                                ) {
                                  return viewModel.tradePairs
                                      .map<PopupMenuItem<String>>(
                                          (String? value) {
                                    return PopupMenuItem(
                                        onTap: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              align: TextAlign.center,
                                              fontfamily: 'InterTight',
                                              fontsize: 15,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : CustomContainer(
                width: 1,
                height: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildHeading(size),
                    buildOrderBookCard(size),
                    buildBottomView(size),
                  ],
                ),
              ),
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

  Widget buildHeading(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          fontsize: 16,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
          text: stringVariables.orderBook,
        ),
      ],
    );
  }

  Widget buildOrderBookCard(Size size) {
    int buyOrdersSize = (viewModel.getOpenOrders != null)
        ? viewModel.getOpenOrders!.bids!.length
        : 0;
    int sellOrdersSize = (viewModel.getOpenOrders != null)
        ? viewModel.getOpenOrders!.asks!.length
        : 0;
    String? fiatCurrency =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';
    List<List<dynamic>>? buyOrders = (viewModel.getOpenOrders != null)
        ? viewModel.getOpenOrders!.bids!.reversed.take(300).toList()
        : [];
    List<List<dynamic>>? sellOrders = (viewModel.getOpenOrders != null)
        ? (viewModel.viewFilter[1]
            ? viewModel.getOpenOrders!.asks!.take(300).toList()
            : viewModel.getOpenOrders!.asks!.reversed.take(300).toList())
        : [];
    String fromCurrency =
        viewModel.tradePairs[viewModel.selectedTradePair].split("/")[0];
    String toCurrency =
        viewModel.tradePairs[viewModel.selectedTradePair].split("/")[1];
    ListOfTradePairs priceTickers = viewModel.viewModelpriceTickersModel![0];
    if (double.parse(previousLastPrice!) !=
        double.parse(priceTickers.lastPrice!)) {
      if (double.parse(previousLastPrice!) <
          double.parse(priceTickers.lastPrice!)) {
        viewModel.setBuySellFlag(true);
      } else {
        viewModel.setBuySellFlag(false);
      }
      previousLastPrice = priceTickers.lastPrice!;
    }

    return CustomCard(
      outerPadding: 15,
      edgeInsets: 0,
      radius: 25,
      elevation: 0,
      child: CustomContainer(
        width: 1,
        height: 1.45,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: size.width / 25,
                  left: size.width / 25,
                  right: size.width / 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    fontfamily: 'InterTight',
                    fontsize: 16,
                    overflow: TextOverflow.ellipsis,
                    text: stringVariables.price + " ($toCurrency)",
                    color: textGrey,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    fontsize: 16,
                    overflow: TextOverflow.ellipsis,
                    text: stringVariables.amount + " ($fromCurrency)",
                    color: textGrey,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                viewModel.viewFilter[1]
                    ? SizedBox.shrink()
                    : CustomContainer(
                        width: 1,
                        height: viewModel.viewFilter[0] ? 4.125 : 2.02,
                        child: sellOrdersSize == 0
                            ? noRecords()
                            : ListView.builder(
                                reverse: viewModel.viewFilter[1] ? false : true,
                                itemCount: sellOrdersSize,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      exchangeViewModel.setTabView(false);
                                      exchangeViewModel.tabController.index = 1;
                                      exchangeViewModel
                                              .sellLimitController.text =
                                          trimDecimals(sellOrders[index]
                                              .first
                                              .toString());
                                      Navigator.pop(context);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Column(
                                      children: [
                                        CustomContainer(
                                          //leading: const Icon(Icons.list),
                                          width: 1,
                                          height: 20,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: size.width / 30,
                                                  left: size.width / 25,
                                                  right: size.width / 25,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomText(
                                                      text: trimAsLength(
                                                          sellOrders[index]
                                                              .first
                                                              .toString(),
                                                          decimals[viewModel
                                                                  .selectedDecimal]
                                                              .split(".")
                                                              .last
                                                              .length),
                                                      color: red,
                                                      fontfamily: 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    CustomText(
                                                      text: trimAsLength(
                                                          sellOrders[index]
                                                              .last
                                                              .toString(),
                                                          decimals[viewModel
                                                                  .selectedDecimal]
                                                              .split(".")
                                                              .last
                                                              .length),
                                                      color: themeSupport()
                                                              .isSelectedDarkMode()
                                                          ? white
                                                          : black,
                                                      fontfamily: 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        index !=
                                                (viewModel.viewFilter[0]
                                                    ? 0
                                                    : (sellOrdersSize - 1))
                                            ? Divider(
                                                thickness: 0.2,
                                                color: divider,
                                              )
                                            : CustomSizedBox(),
                                      ],
                                    ),
                                  );
                                }),
                      ),
                viewModel.viewFilter[0]
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomSizedBox(
                            height: 0.015,
                          ),
                          CustomText(
                            fontfamily: 'InterTight',
                            fontsize: 16,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            text:
                                "${trimAs2(priceTickers.priceChangePercent.toString()) ?? "0"}%",
                            color: textGrey,
                          ),
                          CustomSizedBox(
                            height: 0.002,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(
                                fontfamily: 'InterTight',
                                fontsize: 24,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                                text:
                                    "${trimDecimals(priceTickers.lastPrice ?? '0')}",
                                color: viewModel.buySellFlag ? green : red,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.0),
                                child: CustomText(
                                  fontfamily: 'InterTight',
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                  text: " $toCurrency",
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 0.002,
                          ),
                          CustomText(
                            fontfamily: 'InterTight',
                            fontsize: 16,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            text:
                                "${trimDecimals(viewModel.estimateFiatValue.toString() ?? "0")}" +
                                    " ${fiatCurrency}",
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                          ),
                          CustomSizedBox(
                            height: 0.002,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                viewModel.viewFilter[2]
                    ? SizedBox.shrink()
                    : CustomContainer(
                        width: 1,
                        height: viewModel.viewFilter[0] ? 4.125 : 2.02,
                        child: buyOrdersSize == 0
                            ? noRecords()
                            : ListView.builder(
                                reverse: viewModel.viewFilter[1] ? true : false,
                                itemCount: buyOrdersSize,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      exchangeViewModel.setTabView(true);
                                      exchangeViewModel.tabController.index = 0;
                                      exchangeViewModel
                                              .buyLimitController.text =
                                          trimDecimals(buyOrders[index]
                                              .first
                                              .toString());
                                      Navigator.pop(context);
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Column(
                                      children: [
                                        CustomContainer(
                                          //leading: const Icon(Icons.list),
                                          width: 1,
                                          height: 20,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: size.width / 30,
                                                  left: size.width / 25,
                                                  right: size.width / 25,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomText(
                                                      text: trimAsLength(
                                                          buyOrders[index]
                                                              .first
                                                              .toString(),
                                                          decimals[viewModel
                                                                  .selectedDecimal]
                                                              .split(".")
                                                              .last
                                                              .length),
                                                      color: green,
                                                      fontfamily: 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    CustomText(
                                                      text: trimAsLength(
                                                          buyOrders[index]
                                                              .last
                                                              .toString(),
                                                          decimals[viewModel
                                                                  .selectedDecimal]
                                                              .split(".")
                                                              .last
                                                              .length),
                                                      color: themeSupport()
                                                              .isSelectedDarkMode()
                                                          ? white
                                                          : black,
                                                      fontfamily: 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        index != (buyOrdersSize - 1)
                                            ? Divider(
                                                thickness: 0.2,
                                                color: divider,
                                              )
                                            : CustomSizedBox(),
                                      ],
                                    ),
                                  );
                                }),
                      ),
                viewModel.viewFilter[0]
                    ? SizedBox.shrink()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomSizedBox(
                            height: 0.015,
                          ),
                          CustomText(
                            fontfamily: 'InterTight',
                            fontsize: 16,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            text:
                                "${trimAs2(priceTickers.priceChangePercent.toString()) ?? "0"}%",
                            color: textGrey,
                          ),
                          CustomSizedBox(
                            height: 0.002,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(
                                fontfamily: 'InterTight',
                                fontsize: 24,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                                text:
                                    "${trimDecimals(priceTickers.lastPrice ?? '0')}",
                                color: viewModel.buySellFlag ? green : red,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.0),
                                child: CustomText(
                                  fontfamily: 'InterTight',
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                  text: " $toCurrency",
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 0.002,
                          ),
                          CustomText(
                            fontfamily: 'InterTight',
                            fontsize: 16,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                            text:
                                "${trimDecimals(viewModel.estimateFiatValue.toString() ?? "0")}" +
                                    " ${constant.walletCurrency.value}",
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                          ),
                          CustomSizedBox(
                            height: 0.005,
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomView(Size size) {
    return CustomContainer(
      width: 1,
      height: 13,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomSizedBox(
            width: 0.000005,
          ),
          CustomContainer(
            padding: 5,
            width: 3,
            height: 17,
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
                  isExpanded: true,
                  icon: Visibility(
                      visible: false, child: Icon(Icons.arrow_downward)),
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
                            fontsize: 12,
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
                        text: decimals[viewModel.selectedDecimal],
                        fontWeight: FontWeight.w700,
                        fontsize: 13,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
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
                    viewModel.setSelectedDecimal(decimals.indexOf(val!));
                  }),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  viewModel.setViewFilter([true, false, false]);
                },
                child: CustomCard(
                    elevation: viewModel.viewFilter[0] ? 10 : 0,
                    radius: 5,
                    child: SvgPicture.asset(
                      buySellOrderImage,
                      width: 15,
                      height: 20,
                    ),
                    edgeInsets: 7.5,
                    outerPadding: 0),
              ),
              CustomSizedBox(
                width: 0.0005,
              ),
              GestureDetector(
                onTap: () {
                  viewModel.setViewFilter([false, true, false]);
                },
                child: CustomCard(
                    elevation: viewModel.viewFilter[1] ? 10 : 0,
                    radius: 5,
                    child: SvgPicture.asset(
                      buyOrderImage,
                      width: 15,
                      height: 20,
                    ),
                    edgeInsets: 7.5,
                    outerPadding: 0),
              ),
              CustomSizedBox(
                width: 0.005,
              ),
              GestureDetector(
                onTap: () {
                  viewModel.setViewFilter([false, false, true]);
                },
                child: CustomCard(
                    elevation: viewModel.viewFilter[2] ? 10 : 0,
                    radius: 5,
                    child: SvgPicture.asset(
                      sellOrderImage,
                      width: 15,
                      height: 20,
                    ),
                    edgeInsets: 7.5,
                    outerPadding: 0),
              )
            ],
          ),
          CustomSizedBox(
            width: 0.000005,
          ),
        ],
      ),
    );
  }
}
