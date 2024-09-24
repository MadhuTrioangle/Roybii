import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Common/SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../p2p/home/view/p2p_home_view.dart';
import '../NewModel/GetFavouriteMarkets.dart';
import '../NewModel/GetSpotMarkets.dart';

class MarketView extends StatefulWidget {
  MarketView({Key? key}) : super(key: key);

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> with TickerProviderStateMixin {
  bool isLogin = false;
  int selectedScreenIndex = 0;
  late MarketViewModel viewModel;
  late RegisterViewModel registerViewModel;
  late WalletViewModel walletViewModel;
  late ExchangeViewModel exchangeViewModel;
  late CommonViewModel commonViewModel;
  SiteMaintenanceViewModel? siteMaintenanceViewModel;
  GlobalKey fiatKey = GlobalKey();
  GlobalKey altKey = GlobalKey();
  List<GetSpotMarket> btcSearchSpotMarkets = [];
  List<MarginTrade> spotSearchFavouriteTrade = [];
  List<MarginTrade> spotSearchFavouriteTradeResult = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<MarketViewModel>(context, listen: false);
    registerViewModel = Provider.of<RegisterViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    commonViewModel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    viewModel.getMarketCurrencies();

    viewModel.spotTabController = TabController(
        length: constant.userLoginStatus.value ? 6 : 5,
        vsync: this,
        initialIndex: 0);
    Future.delayed(Duration(seconds: 0), () {
      String? encodedMap = constant.pref?.getString('mlmAlert');
      Map<String, dynamic> decodedMap =
          (encodedMap == null || encodedMap.isEmpty)
              ? {}
              : json.decode(encodedMap);
      bool alreadyExist = decodedMap.containsKey(constant.userEmail.value);
      if (!alreadyExist) {
        viewModel.setMlmStatus(false);
      } else {
        viewModel.setMlmStatus(true);
      }
    });
    if (constant.userLoginStatus.value) {
      viewModel.spotTabController.addListener(() {
        if (viewModel.spotTabController.index == 0) {
          viewModel.getFav();
        } else if (viewModel.spotTabController.index == 1) {
          viewModel.getSpotMarket(viewModel.defaultCurrencies[0]);
        } else if (viewModel.spotTabController.index == 2) {
          viewModel.getSpotMarket(viewModel.defaultCurrencies[1]);
        } else if (viewModel.spotTabController.index == 3) {
          viewModel.getSpotMarket(viewModel.defaultCurrencies[2]);
        } else if (viewModel.spotTabController.index == 4) {
          viewModel.getSpotMarket(viewModel.selectedMarketCurrency);
        }
      });
    } else {
      viewModel.spotTabController.addListener(() {
        if (viewModel.spotTabController.index == 0) {
          viewModel.getSpotMarket(viewModel.defaultCurrencies[0]);
        } else if (viewModel.spotTabController.index == 1) {
          viewModel.getSpotMarket(viewModel.defaultCurrencies[1]);
        } else if (viewModel.spotTabController.index == 2) {
          viewModel.getSpotMarket(viewModel.defaultCurrencies[2]);
        } else if (viewModel.spotTabController.index == 3) {
          viewModel.getSpotMarket(viewModel.selectedMarketCurrency);
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.getMarketSocket();
      viewModel.searchController.addListener(() {
        viewModel.searchController.text.isEmpty
            ? viewModel.setsearchControllerText(false)
            : viewModel.setsearchControllerText(true);
      });
      if (constant.userLoginStatus.value) viewModel.getFav();
      commonViewModel.getLiquidityStatus("MarketView");
      exchangeViewModel.getCryptoCurrency();
      siteMaintenanceViewModel?.getSiteMaintenanceStatus();
      if (constant.userLoginStatus.value) walletViewModel.getDashBoardBalance();
    });
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

  Widget build(BuildContext context) {
    viewModel = context.watch<MarketViewModel>();
    registerViewModel = context.watch<RegisterViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    exchangeViewModel = context.watch<ExchangeViewModel>();
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();
    isLogin = constant.userLoginStatus.value;
    String email = constant.pref?.getString("userEmail") ?? '';

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   (viewModel.noInternet)
    //       ? customSnackBar.showSnakbar(
    //           context, stringVariables.checkInternet, SnackbarType.negative)
    //       : (viewModel.serverError)
    //           ? customSnackBar.showSnakbar(
    //               context, stringVariables.serverError, SnackbarType.negative)
    //           : "";
    // });

    return Provider<MarketViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return showMarket(context, email);
      },
    );
  }

  /// Market Screen
  Widget showMarket(BuildContext context, String email) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
        color: themeSupport().isSelectedDarkMode()
            ? darkScaffoldColor
            : lightScaffoldColor,
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TradePairs(
                context,
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
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: CustomContainer(
                  width: 11,
                  height: 22,
                  child: SvgPicture.asset(
                    themeSupport().isSelectedDarkMode()
                        ? userDarkImage
                        : userImage,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              fontfamily: 'InterTight',
              fontsize: 23,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              text: stringVariables.market,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }

  /// TradePairs Lists in ListViewBuilder
  Widget TradePairs(
    BuildContext context,
  ) {
    return Expanded(
      child: CustomContainer(

        width: 1.1,
        child: viewModel.needToLoad
            ? CustomLoader()
            : Column(
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  buildTextField(),
                  Expanded(
                    child: tabBarView(),
                  )
                ],
              ),
      ),
    );
  }

  tabBarView() {
    String? fiatCurrency =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';
    String fiatCurrencySym = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
   // var enumFavFiatValue = toCurrencyCodeValues.map[fiatCurrency];
    return spotSection(fiatCurrencySym, fiatCurrency,);
  }

  /// Spot Section Starts

  spotSection(
    String fiatCurrencySym,
    String fiatCurrency,
  //  ToCurrencyCode? enumFavFiatValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSpotTabs(),
        CustomSizedBox(
          height: 0.015,
        ),
        buildSpotTabBarView(fiatCurrencySym, fiatCurrency,),
      ],
    );
  }

  buildSpotTabs() {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      child: DecoratedTabBar(
        tabBar: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            fontFamily: 'InterTight',
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            fontFamily: 'InterTight',
          ),
          indicatorWeight: 0,
          padding: EdgeInsets.zero,
          indicator: TabBarIndicator(color: themeColor, radius: 4),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: themeSupport().isSelectedDarkMode() ? white : themeColor,
          unselectedLabelColor: stackCardText,
          physics: const ScrollPhysics(),
          dividerColor: Colors.transparent,
          controller: viewModel.spotTabController,
          tabs: [
            if (isLogin)
              Tab(
                text: stringVariables.favourite,
              ),
            Tab(
              text: viewModel.defaultCurrencies[0],
            ),
            Tab(
              text: viewModel.defaultCurrencies[1],
            ),
            Tab(
              text: viewModel.defaultCurrencies[2],
            ),
            tabItems(size, viewModel.selectedMarketCurrency, altKey, (value) {
              viewModel.setSelectedMarketCurrency(value);
              viewModel.getSpotMarket(value);
            }, viewModel.defaultCurrenciesCards, 3),
            tabItems(size, viewModel.selectedMarketFiatCurrency, fiatKey,
                (value) {
              viewModel.setSelectedMarketFiatCurrency(value);
              viewModel.getSpotMarket(value);
            }, viewModel.defaultCurrenciesFiatCards, 4),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: hintLight.withOpacity(0.25),
              // width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  btcSpotSection(String fiatCurrencySym, String enumFiatValue,
      List<GetSpotMarket>? spotMarkets) {
    int length = spotMarkets?.length ?? 0;
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 8, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text:
                    "${stringVariables.name}", // / ${stringVariables.h24Volume}
                color: textGrey,
                fontWeight: FontWeight.w600,
                fontsize: 11,
              ),
              Row(
                children: [
                  CustomText(
                    text: stringVariables.lastPrice,
                    color: textGrey,
                    fontWeight: FontWeight.w600,
                    fontsize: 11,
                  ),
                  CustomSizedBox(
                    width: 0.035,
                  ),
                  CustomText(
                    text: stringVariables.h24chgPercent,
                    color: textGrey,
                    fontWeight: FontWeight.w600,
                    fontsize: 11,
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: CustomContainer(
            height: 1,
            width: 1,
            child: viewModel.searchController.text.isNotEmpty &&
                    btcSearchSpotMarkets.isEmpty
                ? noRecords()
                : btcSearchSpotMarkets.isNotEmpty ||
                        viewModel.searchController.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: btcSearchSpotMarkets.length,
                        itemBuilder: (context, index) {
                          List<ExchangeRate>? exchangeRateList =
                              btcSearchSpotMarkets[index]
                                  .exchangeRates
                                  ?.where((element) =>
                                      element.toCurrencyCode == enumFiatValue)
                                  .toList();
                          num lastPrice = num.parse(
                                  btcSearchSpotMarkets[index].price ?? "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          num volume = num.parse(
                                  btcSearchSpotMarkets[index].volume24H ??
                                      "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                moveExchange("spot0",
                                    "${btcSearchSpotMarkets[index].pair}");
                              },
                              behavior: HitTestBehavior.opaque,
                              child: CustomContainer(
                                decoration: BoxDecoration(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? marketCardColor
                                        : lightSearchBarColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 9.0, top: 9, right: 6, left: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (isLogin)
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    viewModel.updateFavTradePair(
                                                        "${btcSearchSpotMarkets[index].pair}",
                                                        btcSearchSpotMarkets[
                                                                        index]
                                                                    .fav ==
                                                                true
                                                            ? false
                                                            : true,
                                                        viewModel
                                                            .defaultCurrencies[0]);
                                                  },
                                                  child: Icon(
                                                    btcSearchSpotMarkets[index]
                                                                .fav ==
                                                            true
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: favouriteColor,
                                                  ),
                                                ),
                                                CustomSizedBox(
                                                  width: 0.025,
                                                ),
                                              ],
                                            ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (!isLogin)
                                                CustomSizedBox(
                                                  width: 0.02,
                                                ),
                                              Row(
                                                children: [
                                                  CustomText(
                                                    text: btcSearchSpotMarkets[
                                                                index]
                                                            .pair
                                                            ?.split("/")
                                                            .first ??
                                                        "",
                                                    fontWeight: FontWeight.bold,
                                                    fontsize: 13,
                                                  ),
                                                  CustomText(
                                                    text:
                                                        "  /${btcSearchSpotMarkets[index].pair?.split("/").last ?? ""}",
                                                    fontWeight: FontWeight.bold,
                                                    fontsize: 11.5,
                                                    color: stackCardText,
                                                  ),
                                                ],
                                              ),
                                              // CustomSizedBox(
                                              //   height: 0.005,
                                              // ),
                                              // CustomText(
                                              //   text:
                                              //       "$fiatCurrencySym ${trimDecimalsForVolume("$volume")}",
                                              //   fontWeight: FontWeight.w400,
                                              //   fontsize: 11,
                                              //   color: stackCardText,
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            width: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                CustomText(
                                                  text: trimDecimalsForBalance(
                                                      "${btcSearchSpotMarkets[index].price}"),
                                                  fontWeight: FontWeight.w600,
                                                  fontsize: 13,
                                                  align: TextAlign.end,
                                                ),
                                                CustomSizedBox(
                                                  height: 0.005,
                                                ),
                                                CustomText(
                                                  text:
                                                      "$fiatCurrencySym ${trimDecimals("$lastPrice")}",
                                                  fontWeight: FontWeight.w400,
                                                  fontsize: 12,
                                                  color: stackCardText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            width: 5.6,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomContainer(
                                                width: 7,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                    color:
                                                        "${btcSearchSpotMarkets[index].changePercent}"
                                                                .contains("-")
                                                            ? red
                                                            : green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                6))),
                                                child: Center(
                                                  child: CustomText(
                                                    text:
                                                        "${trimAs2("${btcSearchSpotMarkets[index].changePercent}")}%",
                                                    fontWeight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: white,
                                                    align: TextAlign.end,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                    : ListView.builder(
                        itemCount: length,
                        itemBuilder: (context, index) {
                          List<ExchangeRate>? exchangeRateList =
                              spotMarkets?[index]
                                  .exchangeRates
                                  ?.where((element) =>
                                      element.toCurrencyCode == enumFiatValue)
                                  .toList();
                          num lastPrice = num.parse(
                                  spotMarkets?[index].price ?? "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          num volume = num.parse(
                                  spotMarkets?[index].volume24H ?? "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                moveExchange(
                                    "spot0", "${spotMarkets?[index].pair}");
                              },
                              behavior: HitTestBehavior.opaque,
                              child: CustomContainer(
                                decoration: BoxDecoration(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? marketCardColor
                                        : lightSearchBarColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 9.0, top: 9, right: 8, left: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (isLogin)
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    viewModel.updateFavTradePair(
                                                        "${spotMarkets?[index].pair}",
                                                        viewModel
                                                                    .btcSpotMarkets?[
                                                                        index]
                                                                    .fav ==
                                                                true
                                                            ? false
                                                            : true,
                                                        viewModel
                                                            .defaultCurrencies[0]);
                                                  },
                                                  child: Icon(
                                                    spotMarkets?[index].fav ==
                                                            true
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: favouriteColor,
                                                  ),
                                                ),
                                                CustomSizedBox(
                                                  width: 0.025,
                                                ),
                                              ],
                                            ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  if (!isLogin)
                                                    CustomSizedBox(
                                                      width: 0.02,
                                                    ),
                                                  CustomText(
                                                    text: spotMarkets?[index]
                                                            .pair
                                                            ?.split("/")
                                                            .first ??
                                                        "",
                                                    fontWeight: FontWeight.bold,
                                                    fontsize: 13,
                                                  ),
                                                  CustomText(
                                                    text:
                                                        "  /${spotMarkets?[index].pair?.split("/").last ?? ""}",
                                                    fontWeight: FontWeight.bold,
                                                    fontsize: 11.5,
                                                    color: stackCardText,
                                                  ),
                                                ],
                                              ),
                                              // CustomSizedBox(
                                              //   height: 0.005,
                                              // ),
                                              // CustomText(
                                              //   text:
                                              //       "$fiatCurrencySym ${trimDecimalsForVolume("$volume")}",
                                              //   fontWeight: FontWeight.w400,
                                              //   fontsize: 11,
                                              //   color: stackCardText,
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            width: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                CustomText(
                                                  text: trimDecimalsForBalance(
                                                      "${spotMarkets?[index].price}"),
                                                  fontWeight: FontWeight.w600,
                                                  fontsize: 13,
                                                  align: TextAlign.end,
                                                ),
                                                CustomSizedBox(
                                                  height: 0.005,
                                                ),
                                                CustomText(
                                                  text:
                                                      "$fiatCurrencySym ${trimDecimals("$lastPrice")}",
                                                  fontWeight: FontWeight.w400,
                                                  fontsize: 12,
                                                  color: stackCardText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            width: 5.6,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomContainer(
                                                width: 7,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                    color:
                                                        "${spotMarkets?[index].changePercent}"
                                                                .contains("-")
                                                            ? red
                                                            : green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                6))),
                                                child: Center(
                                                  child: CustomText(
                                                    text:
                                                        "${trimAs2("${spotMarkets?[index].changePercent}")}%",
                                                    fontWeight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: white,
                                                    align: TextAlign.end,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
          ),
        )
      ],
    );
  }

  buildSpotTabBarView(
    String fiatCurrencySym,
    String fiatCurrency,
  ) {
    return Flexible(
      child: CustomContainer(
        width: 1,
        height: 1,
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? darkCardColor
              : lightCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(controller: viewModel.spotTabController, children: [
            if (isLogin)
              favSpotSection(
                fiatCurrencySym,fiatCurrency
              ),
            btcSpotSection(
                fiatCurrencySym, fiatCurrency, viewModel.btcSpotMarkets),
            btcSpotSection(
                fiatCurrencySym, fiatCurrency, viewModel.usdtSpotMarkets),
            btcSpotSection(
                fiatCurrencySym, fiatCurrency, viewModel.ethSpotMarkets),
            btcSpotSection(
                fiatCurrencySym, fiatCurrency, viewModel.altSpotMarkets),
            btcSpotSection(
                fiatCurrencySym, fiatCurrency, viewModel.fiatSpotMarkets),
          ]),
        ),
      ),
    );
  }

  /// Spot Section ends

  /// Favourite Section Starts

  favSpotSection(
    String fiatCurrencySym, String enumFiatValue,
  ) {
    int length = viewModel.spotFavouriteTrade?.length ?? 0;
    spotSearchFavouriteTradeResult = viewModel.spotFavouriteTrade ?? [];
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 8, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text:
                    "${stringVariables.all}", // / ${stringVariables.h24Volume}
                color: textGrey,
                fontWeight: FontWeight.w600,
                fontsize: 11,
              ),
              Row(
                children: [
                  CustomText(
                    text: stringVariables.lastPrice,
                    color: textGrey,
                    fontWeight: FontWeight.w600,
                    fontsize: 11,
                  ),
                  CustomSizedBox(
                    width: 0.035,
                  ),
                  CustomText(
                    text: stringVariables.h24chgPercent,
                    color: textGrey,
                    fontWeight: FontWeight.w600,
                    fontsize: 11,
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: CustomContainer(
            height: 1,
            width: 1,
            child: viewModel.searchController.text.isNotEmpty &&
                    spotSearchFavouriteTrade.isEmpty
                ? noRecords()
                : spotSearchFavouriteTrade.isNotEmpty ||
                        viewModel.searchController.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: spotSearchFavouriteTrade.length,
                        itemBuilder: (context, index) {
                          List<FavExchangeRate>? exchangeRateList =
                              spotSearchFavouriteTrade[index]
                                  .exchangeRates
                                  ?.where((element) =>
                                      element.toCurrencyCode ==
                                          enumFiatValue)
                                  .toList();
                          num lastPrice = num.parse(
                                  spotSearchFavouriteTrade[index].price ??
                                      "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          num volume = num.parse(
                                  spotSearchFavouriteTrade[index].volume24H ??
                                      "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                moveExchange("favSpot",
                                    "${spotSearchFavouriteTrade[index].pair}");
                              },
                              behavior: HitTestBehavior.opaque,
                              child: CustomContainer(
                                decoration: BoxDecoration(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? marketCardColor
                                        : lightSearchBarColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 9.0, top: 9, right: 8, left: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              viewModel.updateFavTradePair(
                                                  "${spotSearchFavouriteTrade[index].pair}",
                                                  false,
                                                  "favourite");
                                            },
                                            child: Icon(
                                              Icons.star,
                                              color: favouriteColor,
                                            ),
                                          ),
                                          CustomSizedBox(
                                            width: 0.025,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                    text:
                                                        "${spotSearchFavouriteTrade[index].pair?.split("/").first ?? ""}",
                                                    fontWeight: FontWeight.bold,
                                                    fontsize: 13,
                                                  ),
                                                  CustomText(
                                                    text:
                                                        " /${spotSearchFavouriteTrade[index].pair?.split("/").last ?? " "}",
                                                    fontsize: 11.5,
                                                    color: stackCardText,
                                                  ),
                                                ],
                                              ),
                                              // CustomSizedBox(
                                              //   height: 0.005,
                                              // ),
                                              // CustomText(
                                              //   text:
                                              //       "$fiatCurrencySym ${trimDecimalsForVolume(volume.toString())}",
                                              //   fontWeight: FontWeight.w400,
                                              //   fontsize: 11,
                                              //   color: stackCardText,
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            width: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                CustomText(
                                                  text: trimDecimalsForBalance(
                                                      "${spotSearchFavouriteTrade[index].price}"),
                                                  fontWeight: FontWeight.w600,
                                                  align: TextAlign.end,
                                                  fontsize: 13,
                                                ),
                                                CustomSizedBox(
                                                  height: 0.005,
                                                ),
                                                CustomText(
                                                  text:
                                                      "$fiatCurrencySym ${trimDecimals(lastPrice.toString())}",
                                                  fontWeight: FontWeight.w400,
                                                  fontsize: 12,
                                                  color: stackCardText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            width: 5.6,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomContainer(
                                                width: 7,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                    color:
                                                        "${spotSearchFavouriteTrade[index].changePercent}"
                                                                .contains("-")
                                                            ? red
                                                            : green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                6))),
                                                child: Center(
                                                  child: CustomText(
                                                    text:
                                                        "${trimAs2("${spotSearchFavouriteTrade[index].changePercent}")}%",
                                                    fontWeight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: white,
                                                    align: TextAlign.end,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                    : ListView.builder(
                        itemCount: length,
                        itemBuilder: (context, index) {
                          List<FavExchangeRate>? exchangeRateList = viewModel
                              .spotFavouriteTrade?[index].exchangeRates
                              ?.where((element) =>
                                  element.toCurrencyCode == enumFiatValue)
                              .toList();
                          num lastPrice = num.parse(
                                  viewModel.spotFavouriteTrade?[index].price ??
                                      "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          num volume = num.parse(viewModel
                                      .spotFavouriteTrade?[index].volume24H ??
                                  "0") *
                              num.parse(
                                  exchangeRateList?.first.exchangeRate ?? "0");
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                moveExchange("favSpot",
                                    "${viewModel.spotFavouriteTrade?[index].pair}");
                              },
                              behavior: HitTestBehavior.opaque,
                              child: CustomContainer(
                                decoration: BoxDecoration(
                                    color: themeSupport().isSelectedDarkMode()
                                        ? marketCardColor
                                        : lightSearchBarColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 9.0, top: 9, right: 8, left: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              viewModel.updateFavTradePair(
                                                  "${viewModel.spotFavouriteTrade?[index].pair}",
                                                  false,
                                                  "favourite");
                                            },
                                            child: Icon(
                                              Icons.star,
                                              color: favouriteColor,
                                            ),
                                          ),
                                          CustomSizedBox(
                                            width: 0.025,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                    text:
                                                        "${viewModel.spotFavouriteTrade?[index].pair?.split("/").first ?? ""}",
                                                    fontWeight: FontWeight.bold,
                                                    fontsize: 13,
                                                  ),
                                                  CustomText(
                                                    text:
                                                        " /${viewModel.spotFavouriteTrade?[index].pair?.split("/").last ?? " "}",
                                                    fontsize: 11.5,
                                                    color: stackCardText,
                                                  ),
                                                ],
                                              ),
                                              // CustomSizedBox(
                                              //   height: 0.005,
                                              // ),
                                              // CustomText(
                                              //   text:
                                              //       "$fiatCurrencySym ${trimDecimalsForVolume(volume.toString())}",
                                              //   fontWeight: FontWeight.w400,
                                              //   fontsize: 11,
                                              //   color: stackCardText,
                                              // )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            width: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                CustomText(
                                                  text: trimDecimalsForBalance(
                                                      "${viewModel.spotFavouriteTrade?[index].price}"),
                                                  fontWeight: FontWeight.w600,
                                                  align: TextAlign.end,
                                                  fontsize: 13,
                                                ),
                                                CustomSizedBox(
                                                  height: 0.005,
                                                ),
                                                CustomText(
                                                  text:
                                                      "$fiatCurrencySym ${trimDecimals(lastPrice.toString())}",
                                                  fontWeight: FontWeight.w400,
                                                  fontsize: 12,
                                                  color: stackCardText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            width: 5.6,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomContainer(
                                                width: 7,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                    color:
                                                        "${viewModel.spotFavouriteTrade?[index].changePercent}"
                                                                .contains("-")
                                                            ? red
                                                            : green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                6))),
                                                child: Center(
                                                  child: CustomText(
                                                    text:
                                                        "${trimAs2("${viewModel.spotFavouriteTrade?[index].changePercent}")}%",
                                                    fontWeight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: white,
                                                    align: TextAlign.end,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
          ),
        )
      ],
    );
  }

  /// Favourite Section ends

  displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              text: stringVariables.address,
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async {},
                  child: CustomText(text: stringVariables.getLocation)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: CustomText(text: stringVariables.submit)),
            ],
          );
        });
  }

  noRecords() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            fontsize: 18,
            fontWeight: FontWeight.w400,
            text: stringVariables.notFound,
            color: textGrey,
          ),
        ],
      ),
    );
  }

  Widget buildTextField() {
    return CustomContainer(
      height: 22,
      child: CustomTextFormField(
        color: themeSupport().isSelectedDarkMode()
            ? darkCardColor
            : lightSearchBarColor,
        press: () {
          viewModel.searchController.clear();
          onSearchTextChanged(
            viewModel.searchController.text,
          );
          onSearchTextChanged('');
        },
        onChanged: onSearchTextChanged,
        controller: viewModel.searchController,
        prefixIcon: Icon(
          Icons.search,
          color: hintLight,
        ),
        size: 90,
        text: stringVariables.searchCoins,
        isContentPadding: false,
      ),
    );
  }

  onSearchTextChanged(String text) {
    if (viewModel.spotTabController.index == 0) {
      spotSearchFavouriteTrade.clear();
      if (!viewModel.searchControllerText) {
        return;
      }
      List<MarginTrade> searchResult = spotSearchFavouriteTradeResult;
      spotSearchFavouriteTrade = searchResult
          .where((element) =>
              element.pair!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    } else {
      btcSearchSpotMarkets.clear();
      if (!viewModel.searchControllerText) {
        return;
      }
      securedPrint("spot 1");
      List<GetSpotMarket> searchResult =
          viewModel.btcSearchSpotMarketsResult ?? [];
      btcSearchSpotMarkets = searchResult
          .where((element) =>
              element.pair!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
  }

  Widget tabItems(Size size, String text, GlobalKey key,
      ValueChanged onSelected, List<String> list, int index) {
    bool fiatSelected = exchangeViewModel.drawerIndex == (isLogin ? 6 : 5);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        viewModel.spotTabController.index = index;
        dynamic state = key.currentState;
        state.showButtonMenu();
      },
      child: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CustomText(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
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
                        minWidth: (size.width / 4.5),
                        maxWidth: (size.width / 4.5),
                        minHeight: (size.height / 15),
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
                      color: themeSupport().isSelectedDarkMode() ? black : grey,
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
                                    color: themeSupport().isSelectedDarkMode()
                                        ? white
                                        : black,
                                  ),
                                ],
                              ),
                              value: value);
                        }).toList();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void moveExchange(String section, String pair) {
    CommonViewModel commonViewModel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    viewModel.searchController.clear();

    if (section == "favMargin") {
      exchangeViewModel.setTradeTabIndex(1);
    } else {
      exchangeViewModel.setTradeTabIndex(0);
    }
    exchangeViewModel.setTradePair(pair);
    commonViewModel.setActive(1);
  }
}
