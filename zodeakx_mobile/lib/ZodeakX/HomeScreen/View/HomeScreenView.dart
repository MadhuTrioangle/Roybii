import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/customAppBar.dart';
import 'package:zodeakx_mobile/ZodeakX/HomeScreen/Model/HomeModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Common/Common/ViewModel/common_view_model.dart';
import '../../../Common/Exchange/ViewModel/ExchangeViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../p2p/home/view/p2p_home_view.dart';
import '../../MarketScreen/NewModel/GetFavouriteMarkets.dart';
import '../ViewModel/HomeViewModel.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView>
    with TickerProviderStateMixin {
  late HomeViewModel viewModel;
  late MarketViewModel marketViewModel; //fav api call
  late ExchangeViewModel exchangeViewModel;

  bool isLogin = false;
  List<dynamic> img=[homeSlider,homeSlider1];

  ///fav tab shows in login mode
  String name = "Madhumggggggggggitha";
  int bal = 68847567;
  final TextEditingController mynew = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<MarginTrade> spotFavouritePairResult = [];

  @override
  initState() {
    viewModel = Provider.of<HomeViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent = scrollController.position.minScrollExtent;
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      animateToMaxMin(maxScrollExtent, minScrollExtent, maxScrollExtent, 1,
          scrollController);
    });
    viewModel.getMarketOverview();
    marketViewModel.getFav();

    viewModel.homeTabController = TabController(
        length: constant.userLoginStatus.value ? 4 : 3,
        vsync: this,
        initialIndex: 0);

    if (constant.userLoginStatus.value) {
      viewModel.homeTabController.addListener(() {
        if (viewModel.homeTabController.index == 0) {
          marketViewModel.getFav();
        } else {
          viewModel.getMarketOverview();
        }
      });
    } else {
      viewModel.homeTabController.addListener(() {
        ///all tab call 1 api
        viewModel.getMarketOverview();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getHomeSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<HomeViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    exchangeViewModel = context.watch<ExchangeViewModel>();
    isLogin = constant.userLoginStatus.value;
    // return Provider<HomeViewModel>(
    //   create: (context) => viewModel,
    //   builder: (context, child) {
    //     return searchBar();
    //   },
    // );
    return CustomScaffold(
      color: themeSupport().isSelectedDarkMode()
          ? darkScaffoldColor
          : lightScaffoldColor,
      child: SingleChildScrollView(
        child: Padding(
            //to leave space outside a container
            padding: const EdgeInsets.all(0.0),
            child: CustomContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  searchBar(),
                  overAllBalance(),
                  banner(),
                  pairSection(),
                  CustomSizedBox(height: 0.05)
                ],
              ),
            )),
      ),
    );
  }

  searchBar() {
    return CustomAppBar(
      containerHeight: 14,
      containerWidth: 1,
      prefixIconpress: () {},
      suffixIconpress: () {},
      text: "${stringVariables.greet}${name}",
      suffixIcon: googleIcon,
      prefixIcon: accountCreated,
      isPrefixIcon: true,
      isSuffixIcon: true,
      prefixIconHeight: 25,
      prefixIconWidth: 40,
      suffixIconHeight: 5,
      suffixIconWidth: 1,
      circleFill:
          themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
      padding: 4,
      fontSize: 16,
      textFormFieldSize: 30,
      textFormFieldcontentpadding: false,
      textFormFieldController: mynew,
      fill: themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
      textFormFieldPrefixIcon: const Icon(
        Icons.search,
        color: Colors.grey,
        size: 20,
      ),
      textFormFieldPSuffixIcon: const Icon(
        Icons.qr_code_scanner_rounded,
        color: Colors.grey,
        size: 20,
      ),
      textFormFieldtext: stringVariables.search,
      borderColor: themeSupport().isSelectedDarkMode()
          ? marketCardColor
          : lightSearchBarColor,
    );
  }

  overAllBalance() { //Growable card
    return CustomCard(
        radius: 20,
        edgeInsets: 7,
        outerPadding: 4,
        color: themeSupport().isSelectedDarkMode()
            ? darkCardColor
            : lightCardColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CustomText(
                    text: stringVariables.overAllBalance,
                    color: themeSupport().isSelectedDarkMode()
                        ? contentFontColor
                        : hintTextColor,
                    height: 0),
                CustomSizedBox(
                  width: 0.01,
                ),
                GestureDetector(
                    onTap: () {
                      viewModel.changeIcon();
                    },
                    child: Icon(
                      viewModel.passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: themeSupport().isSelectedDarkMode()
                          ? hintTextColor
                          : contentFontColor,
                      size: 14,
                    )),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                      height: 0.002,
                      text:
                          viewModel.passwordVisible ? "\$${bal}" : "*********",
                      fontWeight: FontWeight.bold,
                      fontsize: 20,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor),
                  CustomSizedBox(
                    width: 0.30,
                  ),
                  CustomElevatedButton(
                    text: stringVariables.transactions,
                    radius: 15,
                    buttoncolor: themeSupport().isSelectedDarkMode()
                        ? marketCardColor
                        : lightSearchBarColor,
                    width: MediaQuery.of(context).size.width / 89,
                    height: 25,
                    isBorderedButton: true,
                    fontSize: 10,
                    maxLines: 1,
                    icons: true,
                    icon: order,
                    IconHeight: 9,
                    color: themeSupport().isSelectedDarkMode()
                        ? contentFontColor
                        : hintTextColor,
                    multiClick: true,
                    press: () {},
                    iconColor: themeSupport().isSelectedDarkMode()
                        ? hintTextColor
                        : contentFontColor,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomElevatedButton(
                    text: stringVariables.p2p,
                    radius: 8,
                    buttoncolor: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 87,
                    height: 20,
                    isBorderedButton: false,
                    fontSize: 11,
                    maxLines: 1,
                    icons: true,
                    icon: marketImage,
                    IconHeight: 9,
                    color: themeSupport().isSelectedDarkMode()
                        ? lightCardColor
                        : darkScaffoldColor,
                    multiClick: true,
                    press: () {},
                    fillColor: themeSupport().isSelectedDarkMode()
                        ? marketCardColor
                        : inputColor,
                    iconColor: themeSupport().isSelectedDarkMode()
                        ? lightCardColor
                        : darkScaffoldColor,
                  ),
                  CustomSizedBox(
                    width: 0.03,
                  ),
                  CustomElevatedButton(
                    text: stringVariables.deposit,
                    radius: 8,
                    buttoncolor: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 87,
                    height: 20,
                    isBorderedButton: false,
                    fontSize: 11,
                    maxLines: 1,
                    icons: true,
                    icon: referralImage,
                    IconHeight: 9,
                    color: themeSupport().isSelectedDarkMode()
                        ? lightCardColor
                        : darkScaffoldColor,
                    multiClick: true,
                    press: () {},
                    fillColor: themeSupport().isSelectedDarkMode()
                        ? marketCardColor
                        : inputColor,
                    iconColor: themeSupport().isSelectedDarkMode()
                        ? lightCardColor
                        : darkScaffoldColor,
                  ),
                  CustomSizedBox(
                    width: 0.03,
                  ),
                  CustomElevatedButton(
                    text: stringVariables.withdraw,
                    radius: 8,
                    buttoncolor: Colors.transparent,
                    width: MediaQuery.of(context).size.width / 87,
                    height: 20,
                    isBorderedButton: false,
                    fontSize: 11,
                    maxLines: 1,
                    icons: true,
                    icon: backArrow,
                    IconHeight: 9,
                    color: themeSupport().isSelectedDarkMode()
                        ? lightCardColor
                        : darkScaffoldColor,
                    multiClick: true,
                    press: () {},
                    fillColor: themeSupport().isSelectedDarkMode()
                        ? marketCardColor
                        : inputColor,
                    iconColor: themeSupport().isSelectedDarkMode()
                        ? lightCardColor
                        : darkScaffoldColor,
                  ),
                ],
              )
            ]));
  }

  banner() {
    return CustomContainer(
        width: 1,
        height: 6, // Set the width to occupy the entire width of the screen
        padding: 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          itemCount: img.length,
          separatorBuilder: (BuildContext context, int index) {
            return CustomSizedBox(
              width: 0.02,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return CustomContainer(
              child: SvgPicture.asset(img[index]),
              width: 1.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23),),
            );
          },
        ));
  }

  void animateToMaxMin(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    ///Wait for 4 seconds before changing slide automatically
    scrollController
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.easeInOut)
        .then((value) {
      Future.delayed(Duration(seconds: 4), () {
        direction = direction == max ? min : max;
        animateToMaxMin(max, min, direction, seconds, scrollController);
      });
    });
  }

  pairSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMarketTabs(),
        CustomSizedBox(
          height: 0.015,
        ),
        buildMarketTabBarView(),
      ],
    );
  }

  buildMarketTabs() {
    return DecoratedTabBar(
      tabBar: TabBar(
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
        indicator: TabBarIndicator(color: themeColor, radius: 4),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: themeColor,
        unselectedLabelColor: hintLight,
        controller: viewModel.homeTabController,
        tabs: [
          if (isLogin)
            Tab(
              text: stringVariables.favourite,
            ),
          Tab(
            text: stringVariables.hot,
          ),
          Tab(
            text: stringVariables.gainer,
          ),
          Tab(
            text: stringVariables.h24Volume,
          ),
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
    );
  }

  buildMarketTabBarView() {
    String? fiatCurrencyName =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';

    ///from admin panel site
    String fiatCurrencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrencyName)
        .value;

    return CustomContainer(
      width: 1,
      height: 2,
      decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? darkCardColor
              : lightCardColor,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(controller: viewModel.homeTabController, children: [
          if (isLogin) favSpotSection(fiatCurrencySymbol, fiatCurrencyName),
          marketTabBarView(
              viewModel.highlight, viewModel.highlight?.length ?? 0),
          marketTabBarView(viewModel.gainer, viewModel.gainer?.length ?? 0),
          marketTabBarView(viewModel.vol, viewModel.vol?.length ?? 0)
        ]),
      ),
    );
  }

  marketTabBarView(List<Gainer>? marketOverview, int length) {
    String? fiatCurrency =
        constant.pref?.getString("defaultFiatCurrency") ?? 'GBP';///from admin panel site
    String fiatCurrencySym = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    return CustomContainer(
      height: 1,
      child: Column(children: [
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
                width: 1,
                height: 1,
                child: marketOverview!.isEmpty
                    ? noRecords()
                :ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: length,
                    itemBuilder: (context, index) {
                      List<ExchangeRate>? exchangeRate = marketOverview?[index]
                          .exchangeRates
                          .where((element) =>
                              element.toCurrencyCode == fiatCurrency)
                          .toList();

                      num lastPrice = num.parse(
                              marketOverview?[index].price ?? "0") *
                          num.parse(exchangeRate?.first.exchangeRate ?? "0");

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        //how much space around each list
                        child: GestureDetector(
                          onTap: () {
                            // moveExchange(
                            //     "spot0", "${spotMarkets?[index].pair}");
                          },
                          behavior: HitTestBehavior.opaque,
                          child: CustomContainer(
                            padding: 4, //each list inside padding
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              CustomText(
                                                text:
                                                    marketOverview![index].code,
                                                fontWeight: FontWeight.bold,
                                                fontsize: 13,
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
                                              text:
                                                  "$fiatCurrencySym ${trimDecimals(lastPrice.toString())}",
                                              fontWeight: FontWeight.w500,
                                              fontsize: 13,
                                              align: TextAlign.end,
                                            ),
                                            CustomSizedBox(
                                              height: 0.005,
                                            ),
                                            // CustomText(
                                            //   text:
                                            //   " ${trimDecimals("$marketOverview.first.c")}",
                                            //   fontWeight: FontWeight.w400,
                                            //   fontsize: 12,
                                            //   color: stackCardText,
                                            // ),
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
                                                    "${marketOverview.first.changePercent}"
                                                            .contains("-")
                                                        ? red
                                                        : green,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6))),
                                            child: Center(
                                              child: CustomText(
                                                text:
                                                    "${trimAs2("${marketOverview![index].changePercent}")}%",
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
                    })))
      ]),
    );
  }

  favSpotSection(fiatCurrencySym, fiatCurrency) {
    int length = marketViewModel.spotFavouriteTrade?.length ?? 0;

    ///set fav result is stores in this list
    spotFavouritePairResult = marketViewModel.spotFavouriteTrade ?? [];
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 8, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "${stringVariables.all}", // / ${stringVariables.h24Volume}
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
          child: spotFavouritePairResult.isEmpty
              ? noRecords()
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: length > 5 ? 5 : length,
                  itemBuilder: (context, index) {
                    List<FavExchangeRate>? exchangeRateList = marketViewModel
                        .spotFavouriteTrade?[index].exchangeRates
                        ?.where(
                            (element) => element.toCurrencyCode == fiatCurrency)
                        .toList();
                    num lastPrice = num.parse(
                            marketViewModel.spotFavouriteTrade?[index].price ??
                                "0") *
                        num.parse(exchangeRateList?.first.exchangeRate ?? "0");
                    num volume = num.parse(marketViewModel
                                .spotFavouriteTrade?[index].volume24H ??
                            "0") *
                        num.parse(exchangeRateList?.first.exchangeRate ?? "0");
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          moveToExchange("favSpot",
                              "${marketViewModel.spotFavouriteTrade?[index].pair}");
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        marketViewModel.updateFavTradePair(
                                            "${marketViewModel.spotFavouriteTrade?[index].pair}",
                                            true,
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
                                                  "${marketViewModel.spotFavouriteTrade?[index].pair?.split("/").first ?? ""}",
                                              fontWeight: FontWeight.bold,
                                              fontsize: 13,
                                            ),
                                            CustomText(
                                              text:
                                                  " /${marketViewModel.spotFavouriteTrade?[index].pair?.split("/").last ?? " "}",
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
                                                "${marketViewModel.spotFavouriteTrade?[index].price}"),
                                            fontWeight: FontWeight.w500,
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
                                                  "${marketViewModel.spotFavouriteTrade?[index].changePercent}"
                                                          .contains("-")
                                                      ? red
                                                      : green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6))),
                                          child: Center(
                                            child: CustomText(
                                              text:
                                                  "${trimAs2("${marketViewModel.spotFavouriteTrade?[index].changePercent}")}%",
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
      ),
      spotFavouritePairResult.isNotEmpty && spotFavouritePairResult.length > 5
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  press: () {
                    CommonViewModel commonViewModel =
                        Provider.of<CommonViewModel>(
                            NavigationService.navigatorKey.currentContext!,
                            listen: false);
                    commonViewModel.setActive(1);
                  },

                  text: "${stringVariables.viewMore}",
                  // / ${stringVariables.h24Volume}
                  color: themeSupport().isSelectedDarkMode()
                      ? darkThemeColor
                      : themeColor,
                  fontWeight: FontWeight.w200,
                  fontsize: 12,
                ),
              ],
            )
          : CustomSizedBox()
    ]);
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

  void moveToExchange(String section, String pair) {
    CommonViewModel commonViewModel = Provider.of<CommonViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);

    if (section == "favMargin") {
      exchangeViewModel.setTradeTabIndex(1);
    } else {
      exchangeViewModel.setTradeTabIndex(0);

      ///spot tab in exchange screen
    }
    exchangeViewModel.setTradePair(pair);
    commonViewModel.setActive(2);

    ///exchange screen
  }

  void moveMarket() {}
}
