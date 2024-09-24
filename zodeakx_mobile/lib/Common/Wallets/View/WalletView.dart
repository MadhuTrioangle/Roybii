import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/PhoneNumber/View/phone_dialog.dart';
import 'package:zodeakx_mobile/Common/SplashScreen/ViewModel/SplashViewModel.dart';
import 'package:zodeakx_mobile/Common/Wallets/FutureModel/FutureWalletModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNetworkImage.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../p2p/counter_parties_profile/view/p2p_counter_profile_view.dart';
import '../../../p2p/home/view/p2p_home_view.dart';
import '../../Common/ViewModel/common_view_model.dart';
import '../../SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../../transfer/viewModel/transfer_view_model.dart';
import '../../wallet_select/viewModel/wallet_select_view_model.dart';
import '../CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../FutureModel/FuturePositionsModel.dart';
import '../ViewModel/WalletViewModel.dart';
import '../funding_coin_details/model/UserFundingWalletDetailsModel.dart';
import 'ComingSoonView.dart';
import 'MustLoginView.dart';

class WalletView extends StatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> with TickerProviderStateMixin {
  List<UserFundingWalletDetails> _fundingSearchResult = [];

  TextEditingController fundingSearchController = TextEditingController();
  String text = "bitcoin";
  List<UserFundingWalletDetails>? Result;
  List<DashBoardBalance>? result;
  String defaultFiatCurrency =
      constant.pref?.getString("defaultFiatCurrency") ?? '';
  late WalletViewModel getTotalBalance;
  late MarketViewModel marketViewModel;

  late SplashViewModel splashViewModel;

  late CoinDetailsViewModel coinDetailsViewModel;
  late WalletSelectViewModel walletSelectViewModel;
  late TransferViewModel transferViewModel;
  late TabController walletTabController;
  late TabController _marginController;
  late TabController _futureController;
  late TabController _usdmController;
  late TabController _coinmController;
  SiteMaintenanceViewModel? siteMaintenanceViewModel;
  @override
  void initState() {
    getTotalBalance = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);

    transferViewModel = Provider.of<TransferViewModel>(context, listen: false);

    walletSelectViewModel =
        Provider.of<WalletSelectViewModel>(context, listen: false);

    walletTabController = TabController(
        length: getTotalBalance.walletTabs.length,
        vsync: this,
        initialIndex: getTotalBalance.walletIndex);

    if (constant.userLoginStatus.value) getTotalBalance.getDashBoardBalance();
    _marginController = TabController(length: 2, vsync: this);
    _futureController = TabController(length: 2, vsync: this);
    _usdmController = TabController(length: 2, vsync: this);
    _coinmController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      coinDetailsViewModel.getSpotBalanceSocket();
      getTotalBalance.getFundingBalanceSocket();
      getTotalBalance.setMarginTabIndex(0);
      getTotalBalance.setCoinmTabIndex(0);
      getTotalBalance.setFutureTabIndex(0);
      getTotalBalance.setUsdmTabIndex(0);

      _marginController.addListener(() {
        getTotalBalance.setMarginTabIndex(_marginController.index);
      });

      walletTabController.addListener(() {
        getTotalBalance.setTabIndex(walletTabController.index);
        if (walletTabController.animation?.value == walletTabController.index) {
          if (walletTabController.index == 1) {
            getTotalBalance.setSpotSearch(false);
            if (constant.userLoginStatus.value) {
              getTotalBalance.getDashBoardBalance();
            }
          } else if (walletTabController.index == 3) {
            getTotalBalance.setFundingSearch(false);
            getTotalBalance.getUserFundingWalletDetails();
          } else if (walletTabController.index == 4) {
          } else if (walletTabController.index == 5) {}
        }
      });
    });
    getTotalBalance.setWalletIndex(0);
    siteMaintenanceViewModel?.getSiteMaintenanceStatus();
    super.initState();
    getTotalBalance.searchController.clear();
    getTotalBalance.searchResult.clear();
    fundingSearchController.clear();
    _fundingSearchResult.clear();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //   marketViewModel.leaveSocket();
    //  siteMaintenanceViewModel?.leaveSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getTotalBalance = context.watch<WalletViewModel>();
    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    walletSelectViewModel = context.watch<WalletSelectViewModel>();
    transferViewModel = context.watch<TransferViewModel>();

    Size size = MediaQuery.of(context).size;
    bool isLogin = constant.userLoginStatus.value;
    return Provider<WalletViewModel>(
        create: (context) => getTotalBalance,
        child: WillPopScope(
          onWillPop: () async => false,
          child: CustomScaffold(
              appBar: isLogin ? null : AppHeader(context),
              child: !constant.userLoginStatus.value
                  ? MustLoginView()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [walletTabBar(), walletTabBarView(size)],
                      ),
                    )),
        ));
  }

  walletTabBar() {
    return DecoratedTabBar(
      tabBar: TabBar(
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        indicatorWeight: 0,
        indicator: TabBarIndicator(color: themeColor, radius: 4),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: themeSupport().isSelectedDarkMode() ? white : black,
        labelPadding: EdgeInsets.only(right: 8, left: 8),
        unselectedLabelColor: hintLight,
        controller: walletTabController,
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

  buildTabBar() {
    List<Tab> tabs = [];
    getTotalBalance.walletTabs.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }

  walletTabBarView(Size size) {
    return Flexible(
      child: CustomContainer(
        width: 1,
        height: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CustomCard(
            radius: 15,
            outerPadding: 0,
            edgeInsets: 8,
            elevation: 0,
            child: TabBarView(
              controller: walletTabController,
              children: buildWalletTabBarView(size),
            ),
          ),
        ),
      ),
    );
  }

  buildWalletTabBarView(Size size) {
    bool fundingStatus = constant.fundingStatus;
    return [
      buildCommonView(size),
      getTotalBalance.spotSearch
          ? buildSpotSearchView(size)
          : buildSpotBalanceView(size),
      fundingStatus
          ? (getTotalBalance.fundingSearch
              ? buildFundingSearchView(size)
              : buildFundingView(size))
          : ComingSoonView(),
    ];
  }

  Widget buildCommonView(Size size) {
    String spotCryptoBalance =
        trimDecimalsForBalance(getTotalBalance.estimateTotalValue.toString());

    String spotFiatBalance =
        trimDecimalsForBalance(getTotalBalance.estimateFiatValue.toString());

    String fiat = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiat)
        .value;
    String crypto = constant.pref?.getString("defaultCryptoCurrency") ?? '';
    num estimateCrossCrypto =
        getTotalBalance.totalCrossDebt + getTotalBalance.totalCrossEquity;
    num estimateCrossFiat = estimateCrossCrypto * getTotalBalance.fiatValue;
    num estimateIsolatedCrypto =
        getTotalBalance.totalIsolatedDebt + getTotalBalance.totalIsolatedEquity;
    num estimateIsolatedFiat =
        estimateIsolatedCrypto * getTotalBalance.fiatValue;
    String usdmFiatValue =
        trimDecimalsForBalance(getTotalBalance.totalUsdmBalance.toString());
    String coinmFiatValue =
        trimDecimalsForBalance(getTotalBalance.totalCoinmBalance.toString());
    String usdmCryptoValue = trimDecimalsForBalance(
        getTotalBalance.totalUsdmCryptoBalance.toString());
    String coinmCryptoValue = trimDecimalsForBalance(
        getTotalBalance.totalCoinmCryptoBalance.toString());
    String fundingTotalValue = trimDecimalsForBalance(
        getTotalBalance.estimateFundingTotalValue.toString());
    String fundingFiatValue = trimDecimalsForBalance(
        getTotalBalance.estimateFundingFiatValue.toString());
    String fiatCrossValue =
        trimDecimalsForBalance(estimateCrossFiat.toString());
    String cryptoCrossValue =
        trimDecimalsForBalance(estimateCrossCrypto.toString());
    String fiatIsolatedValue =
        trimDecimalsForBalance(estimateIsolatedFiat.toString());
    String cryptoIsolatedValue =
        trimDecimalsForBalance(estimateIsolatedCrypto.toString());

    bool listVisibility = getTotalBalance.overviewZero &&
        (double.parse(cryptoIsolatedValue) == 0 &&
            double.parse(cryptoCrossValue) == 0 &&
            double.parse(spotCryptoBalance) == 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonHeader(),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              children: [
                if (constant.p2pStatus)
                  Flexible(
                    child: CustomElevatedButton(
                        buttoncolor: enableBorder,
                        color: black,
                        press: () {
                          moveToP2P(context);
                        },
                        width: 1,
                        isBorderedButton: true,
                        maxLines: 1,
                        icon: null,
                        multiClick: true,
                        text: stringVariables.buy,
                        radius: 25,
                        height: size.height / 40,
                        icons: false,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        blurRadius: 0,
                        spreadRadius: 0,
                        offset: Offset(0, 0)),
                  ),
                if (constant.p2pStatus)
                  CustomSizedBox(
                    width: 0.03,
                  ),
                Flexible(
                  child: CustomElevatedButton(
                      buttoncolor: themeColor,
                      color:
                          themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        List<DashBoardBalance> list =
                            getTotalBalance.viewModelDashBoardBalance ?? [];
                        list = list
                            .where((element) => element.currencyCode == "BTC")
                            .toList();
                        DashBoardBalance item;
                        if (list.isNotEmpty)
                          item = list.first;
                        else {
                          item = getTotalBalance
                                  .viewModelDashBoardBalance?.first ??
                              DashBoardBalance();
                        }
                        String currencyName = item.currencyName ?? "";
                        String currencyCode = item.currencyCode ?? "";
                        String totalBalance = trimDecimalsForBalance(
                            item.totalBalance.toString());
                        String availableBalance =
                            item.availableBalance.toString();
                        constant.walletCurrency.value = item.currencyCode ?? "";
                        moveToCoinDetailsView(
                          context,
                          currencyName,
                          totalBalance,
                          availableBalance,
                          currencyCode,
                          "${item.currencyType ?? " "}",
                          '${item.inorderBalance ?? ""}',
                          '${item.mlmStakeBalance ?? ""}',
                        );
                      },
                      width: 1,
                      isBorderedButton: true,
                      maxLines: 1,
                      icon: null,
                      multiClick: true,
                      text: stringVariables.deposit,
                      radius: 25,
                      height: size.height / 40,
                      icons: false,
                      blurRadius: 0,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      spreadRadius: 0,
                      offset: Offset(0, 0)),
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            Divider(
              color: divider,
              thickness: 0.2,
            ),
            CustomSizedBox(
              height: 0.01,
            ),
          ],
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: stringVariables.portfolio,
                    fontWeight: FontWeight.bold,
                    fontsize: 22,
                    fontfamily: 'InterTight'),
                checkBoxWithText(
                    getTotalBalance.overviewZero,
                    stringVariables.hide0BalanceWallet,
                    getTotalBalance.setOverviewZero),
                CustomSizedBox(
                  height: 0.01,
                ),
                listVisibility
                    ? noRecords()
                    : Flexible(
                        child: CustomContainer(
                          height: 1,
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  buildCommonTextItems(
                                      spotIcon,
                                      stringVariables.spot,
                                      double.parse(spotCryptoBalance) == 0
                                          ? ""
                                          : spotCryptoBalance + " $crypto",
                                      double.parse(spotFiatBalance) == 0
                                          ? ""
                                          : "≈ ${currencySymbol}" +
                                              spotFiatBalance,
                                      onSpotPressed),
                                  buildCommonTextItems(
                                      fundIcon,
                                      stringVariables.funding,
                                      double.parse(fundingTotalValue) == 0
                                          ? ""
                                          : fundingTotalValue + " $crypto",
                                      double.parse(fundingFiatValue) == 0
                                          ? ""
                                          : "≈ ${currencySymbol}" +
                                              fundingFiatValue,
                                      onFundingPressed),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPosTabBar() {
    return ButtonsTabBar(
      buttonMargin: EdgeInsets.zero,
      labelSpacing: 0,
      height: 30,
      controller: getTotalBalance.futureTabIndex == 0
          ? _usdmController
          : _coinmController,
      backgroundColor: themeColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      unselectedBackgroundColor: Colors.transparent,
      splashColor: Colors.transparent,
      unselectedLabelStyle: TextStyle(
          fontSize: 14,
          color: themeSupport().isSelectedDarkMode() ? white : black,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w500),
      labelStyle: TextStyle(
          fontSize: 14,
          color: themeSupport().isSelectedDarkMode() ? black : white,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w500),
      tabs: [
        Tab(
          text: stringVariables.positions,
        ),
        Tab(
          text: stringVariables.assets,
        ),
      ],
    );
  }

  Widget buildTabBarView() {
    bool firstTab = getTotalBalance.futureTabIndex == 0
        ? getTotalBalance.usdmTabIndex == 0
        : getTotalBalance.coinmTabIndex == 0;
    return firstTab
        ? Column(
            children: [
              CustomSizedBox(
                height: 0.01,
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: checkBoxWithText(
                    getTotalBalance.futureTabIndex == 0
                        ? getTotalBalance.futureUsdmZero
                        : getTotalBalance.futureCoinmZero,
                    stringVariables.hide0Balance,
                    getTotalBalance.futureTabIndex == 0
                        ? getTotalBalance.setFutureUsdmZero
                        : getTotalBalance.setFutureCoinmZero),
              ),
              buildFutureAssets(),
            ],
          );
  }

  Widget buildFutureCardTitle(
      String title, String value, CrossAxisAlignment crossAxisAlignment,
      [bool percentage = false]) {
    num valueInNum = num.parse(value);
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          text: title,
          fontsize: 14,
          fontWeight: FontWeight.w500,
          color: textGrey,
        ),
        CustomSizedBox(
          height: 0.0075,
        ),
        CustomText(
          fontfamily: 'InterTight',
          text: "${percentage ? "" : ""}$value${percentage ? "%" : ""}",
          fontsize: 16,
          fontWeight: FontWeight.w600,
          color: valueInNum > 0 ? green : red,
        ),
      ],
    );
  }

  unrealizedPnl(num markPrice, num entryPrice, num quantity, String side) {
    num pnlValue = 0;
    if (side == stringVariables.long.toLowerCase()) {
      pnlValue = (((markPrice - entryPrice) * quantity) * 1);
    } else {
      pnlValue = (((markPrice - entryPrice) * quantity) * -1);
    }
    return pnlValue;
  }

  unrealizedPnlCoinm(num markPrice, num entryPrice, num quantity, String side) {
    num pnlValue = 0;
    if (side == stringVariables.long.toLowerCase()) {
      pnlValue =
          ((((1 / entryPrice) - (1 / markPrice)) * (quantity * entryPrice)) *
              1);
    } else {
      pnlValue =
          ((((1 / entryPrice) - (1 / markPrice)) * (quantity * entryPrice)) *
              -1);
    }
    return pnlValue;
  }

  roeValue(num pnlValue, num entryPrice, num quantity, num leverage) {
    num roe = 0;
    roe = (pnlValue / ((quantity * entryPrice) * (1 / leverage)) * 100);
    return roe;
  }

  roeValueCoin(num pnlValue, num entryPrice, num quantity, num leverage) {
    num roe = 0;
    roe = ((pnlValue - entryPrice) * leverage / entryPrice) * 100;
    // roe = (pnlValue / ((quantity * entryPrice) * (1 / leverage)) * 100);
    return roe;
  }

  Widget buildFuturePositionsItem(
      FuturePositionsData futurePositionsData, bool isLast) {
    String type = futurePositionsData.side == stringVariables.long.toLowerCase()
        ? "B"
        : "S";
    String firstCoin = futurePositionsData.fromCurrency ?? "";
    String lastCoin = futurePositionsData.toCurrency ?? "";
    String contractType = futurePositionsData.contractType ?? " ";
    String marginType = futurePositionsData.margnumype ?? "";
    String size =
        trimDecimalsForBalance((futurePositionsData.quantity ?? 0).toString());
    String entryPrice = trimDecimalsForBalance(
        (futurePositionsData.entryPrice ?? 0).toString());
    String markPrice =
        trimDecimalsForBalance((futurePositionsData.markPrice ?? 0).toString());
    String margin =
        trimDecimalsForBalance((futurePositionsData.margin ?? 0).toString());
    String risk = trimDecimalsForBalance(
        (futurePositionsData.marginRatio ?? 0).toString());
    String liqPrice = trimDecimalsForBalance(
        (futurePositionsData.liquidationPrice ?? 0).toString());
    String leverage = (futurePositionsData.leverage ?? 0).toString();
    List<TpSlOrder> tpSlOrders = futurePositionsData.tpSlOrders ?? [];
    List<TpSlOrder> tpList = tpSlOrders.isEmpty
        ? []
        : tpSlOrders
            .where((element) => element.takeProfitOrder == "true")
            .toList();
    List<TpSlOrder> slList = tpSlOrders.isEmpty
        ? []
        : tpSlOrders
            .where((element) => element.stopLossOrder == "true")
            .toList();
    String tp = tpList.isEmpty
        ? "--"
        : trimDecimalsForBalance(tpList.first.stopPrice.toString());
    String sl = slList.isEmpty
        ? "--"
        : trimDecimalsForBalance(slList.first.stopPrice.toString());
    String tpsl = "$tp/$sl";
    String pnl = getTotalBalance.futureTabIndex == 0
        ? trimDecimalsForBalance(unrealizedPnl(
                (futurePositionsData.markPrice ?? 0),
                (futurePositionsData.entryPrice ?? 0),
                (futurePositionsData.quantity ?? 0),
                (futurePositionsData.side ?? ""))
            .toString())
        : trimDecimalsForBalance(unrealizedPnlCoinm(
                (futurePositionsData.markPrice ?? 0),
                (futurePositionsData.entryPrice ?? 0),
                (futurePositionsData.quantity ?? 0),
                (futurePositionsData.side ?? ""))
            .toString());
    String roe = getTotalBalance.futureTabIndex == 0
        ? trimAs2(roeValue(
                num.parse(pnl),
                (futurePositionsData.entryPrice ?? 0),
                (futurePositionsData.quantity ?? 0),
                (futurePositionsData.leverage ?? 0))
            .toString())
        : trimAs2(roeValueCoin(
                num.parse(markPrice),
                (futurePositionsData.entryPrice ?? 0),
                (futurePositionsData.quantity ?? 0),
                (futurePositionsData.leverage ?? 0))
            .toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        CustomContainer(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: type == "B" ? green : red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 3.0),
                            child: CustomText(
                              fontfamily: 'InterTight',
                              text: type,
                              fontWeight: FontWeight.w600,
                              color: white,
                            ),
                          ),
                        ),
                        CustomText(
                          fontfamily: 'InterTight',
                          text:
                              "$firstCoin$lastCoin ${capitalize(contractType)}",
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              fontfamily: 'InterTight',
                              text: "$marginType ${leverage}X",
                              fontWeight: FontWeight.w500,
                              color: textGrey,
                            ),
                            // CustomSizedBox(
                            //   width: 0.02,
                            // ),
                            // buildLevelCardsSet(2),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Icon(
                  //   Icons.exit_to_app,
                  //   color: textGrey,
                  // )
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildFutureCardTitle(
                  stringVariables.pnl +
                      " (${getTotalBalance.futureTabIndex == 1 ? firstCoin : lastCoin})",
                  pnl,
                  CrossAxisAlignment.start),
              buildFutureCardTitle(
                  stringVariables.roe, roe, CrossAxisAlignment.end, true),
            ],
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: buildTextWithUnderline(
                        stringVariables.size + " (${firstCoin})",
                        trimDecimalsForBalance(size)),
                  ),
                  Flexible(
                    child: buildTextWithUnderline(
                        stringVariables.margin + " (${lastCoin})",
                        trimDecimalsForBalance(margin)),
                  ),
                  Flexible(
                    child: buildTextWithUnderline(
                        stringVariables.risk, "${risk}%", false, true),
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: buildTextWithUnderline(
                        stringVariables.entryPrice + " (${lastCoin})",
                        trimDecimalsForBalance(entryPrice)),
                  ),
                  Flexible(
                    child: buildTextWithUnderline(
                        stringVariables.markPrice + " (${lastCoin})",
                        trimDecimalsForBalance(markPrice)),
                  ),
                  Flexible(
                    child: buildTextWithUnderline(
                        stringVariables.liquidationPrice + " (${lastCoin})",
                        trimDecimalsForBalance(liqPrice),
                        false,
                        true),
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              Row(
                children: [
                  CustomText(
                    fontfamily: 'InterTight',
                    text: stringVariables.tpsl,
                    fontsize: 14,
                    fontWeight: FontWeight.w500,
                    color: textGrey,
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    text: getTotalBalance.isvisible ? tpsl : "*****",
                    fontsize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          if (!isLast)
            Column(
              children: [
                CustomSizedBox(
                  height: 0.01,
                ),
                Divider(
                  color: divider,
                  thickness: 0.2,
                ),
              ],
            ),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildLevelCardsSet(int count) {
    List<Widget> cards = [];
    int levelListCount = 4;
    for (var i = 0; i < levelListCount; i++) {
      cards.add(buildLevelCards(count > i));
    }
    return Row(
      children: cards,
    );
  }

  Widget buildLevelCards(bool filled) {
    return Column(
      children: [
        CustomContainer(
          width: 125,
          height: 65,
          decoration: BoxDecoration(
            color: filled
                ? green
                : themeSupport().isSelectedDarkMode()
                    ? enableBorder.withOpacity(0.25)
                    : enableBorder.withOpacity(0.75),
          ),
        ),
        CustomSizedBox(
          width: 0.015,
          height: 0.003,
        ),
        CustomContainer(
          width: 125,
          height: 350,
          decoration: BoxDecoration(
            color: filled
                ? green
                : themeSupport().isSelectedDarkMode()
                    ? enableBorder.withOpacity(0.25)
                    : enableBorder.withOpacity(0.75),
          ),
        ),
      ],
    );
  }

  Widget noOrderHistory() {
    return Center(
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.02,
          ),
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
          CustomSizedBox(
            height: 0.02,
          ),
        ],
      ),
    );
  }

  Widget buildFutureAssets() {
    List<FutureWallet>? list = getTotalBalance.futureTabIndex == 0
        ? getTotalBalance.futureUsdmZero
            ? getTotalBalance.usdmWalletZero
            : getTotalBalance.usdmWallet
        : getTotalBalance.futureCoinmZero
            ? getTotalBalance.coinmWalletZero
            : getTotalBalance.coinmWallet;
    int itemCount = list.length;
    return itemCount == 0
        ? noOrderHistory()
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return buildFutureAssetsItem(list[index], itemCount - 1 == index);
            },
          );
  }

  Widget buildFutureAssetsItem(FutureWallet futureWallet, bool isLast) {
    String currency = futureWallet.currencyCode ?? "";
    num walletBalance = futureWallet.totalBalance ?? 0;
    num unrealizedPnl = futureWallet.unrealizedPnl ?? 0;
    num marginBalance = walletBalance + unrealizedPnl;
    num avblForWithdrawal = futureWallet.availableBalance ?? 0;
    String image = futureWallet.image ?? "";
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomCircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 10,
                  child: CustomNetworkImage(
                    image: image,
                  ),
                ),
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: currency,
                  fontsize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextWithUnderline(stringVariables.walletBalance,
                          trimDecimalsForBalance(walletBalance.toString())),
                      CustomSizedBox(
                        height: 0.015,
                      ),
                      buildTextWithUnderline(stringVariables.marginBalance,
                          trimDecimalsForBalance(marginBalance.toString())),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextWithUnderline(stringVariables.unrealizedPnl,
                          trimDecimalsForBalance(unrealizedPnl.toString())),
                      CustomSizedBox(
                        height: 0.015,
                      ),
                      buildTextWithUnderline(stringVariables.avblForWithdrawal,
                          trimDecimalsForBalance(avblForWithdrawal.toString())),
                    ],
                  ),
                ),
              ],
            ),
            if (!isLast)
              Column(
                children: [
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  Divider(
                    color: divider,
                    thickness: 0.2,
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

  Widget buildTextWithUnderline(String title, String value,
      [bool underLine = false, bool endAlign = false, bool image = false]) {
    return Column(
      crossAxisAlignment:
          endAlign ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          align: endAlign ? TextAlign.right : null,
          text: title,
          fontsize: 13,
          fontWeight: FontWeight.w500,
          color: textGrey,
          decoration: underLine ? TextDecoration.underline : null,
        ),
        CustomSizedBox(
          height: 0.0075,
        ),
        Row(
          mainAxisAlignment:
              endAlign ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: getTotalBalance.isvisible ? value : "*****",
              fontsize: 13.5,
              fontWeight: FontWeight.w500,
            ),
            image
                ? Row(
                    children: [
                      CustomSizedBox(
                        width: 0.015,
                      ),
                      SvgPicture.asset(
                        exchangeMargin,
                        height: 13,
                        color: hintLight,
                      ),
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ],
    );
  }

  _showAlertModel(String title, String content) async {
    final result = await Navigator.of(context)
        .push(PhoneNumberDialog(context, title, content));
  }

  Widget checkBoxWithText(
      bool checkedStatus, String label, ValueChanged toggled,
      [bool underline = false]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: Offset(-15, 0),
          child: CustomCheckBox(
            checkboxState: checkedStatus,
            toggleCheckboxState: toggled,
            activeColor: themeColor,
            checkColor: white,
            borderColor: enableBorder,
          ),
        ),
        Transform.translate(
            offset: Offset(-21, 0),
            child: CustomText(
                press: () {
                  if (underline) {
                    _showAlertModel(stringVariables.hide0Accounts,
                        stringVariables.hide0AccountsContent);
                  }
                },
                text: label,
                fontWeight: FontWeight.w500,
                fontsize: 14,
                decoration: underline ? TextDecoration.underline : null,
                fontfamily: 'InterTight'))
      ],
    );
  }

  onSpotPressed() {
    walletTabController.index = 1;
  }

  onStakingPressed() {
    walletTabController.index = 2;
  }

  onFundingPressed() {
    walletTabController.index = 3;
  }

  onMarginCrossPressed() {
    walletTabController.index = 4;
    _marginController.index = 0;
  }

  onMarginIsolatedPressed() {
    walletTabController.index = 4;
    _marginController.index = 1;
  }

  onUsdmFuturePressed() {
    _futureController.index = 0;
    walletTabController.index = 5;
  }

  onCoinmFuturePressed() {
    _futureController.index = 1;
    walletTabController.index = 5;
  }

  buildCommonTextItems(String icon, String content1,
      [String content2 = "", String content3 = "", VoidCallback? onTapped]) {
    String crypto = constant.pref?.getString("defaultCryptoCurrency") ?? '';
    bool visiblityFlag =
        getTotalBalance.overviewZero ? content2.isNotEmpty : true;
    return visiblityFlag
        ? Column(
            children: [
              GestureDetector(
                onTap: onTapped,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              icon,
                              height: 15,
                            ),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            CustomText(
                                text: content1,
                                fontWeight: FontWeight.w500,
                                fontsize: 15,
                                fontfamily: 'InterTight'),
                          ],
                        ),
                        Row(
                          children: [
                            CustomText(
                                text: getTotalBalance.isvisible
                                    ? content2.isEmpty
                                        ? "0.0 ${crypto}"
                                        : content2
                                    : "*****",
                                fontWeight: FontWeight.w500,
                                fontsize: 15,
                                fontfamily: 'InterTight'),
                            CustomSizedBox(
                              width: 0.0275,
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(
                            text: getTotalBalance.isvisible
                                ? content3
                                : content2.isEmpty
                                    ? ""
                                    : "*****",
                            fontWeight: FontWeight.w500,
                            fontsize: 15,
                            color: textGrey,
                            fontfamily: 'InterTight'),
                        CustomSizedBox(
                          width: 0.0275,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomSizedBox(
                height: content3.isEmpty ? 0.02 : 0.03,
              ),
            ],
          )
        : CustomSizedBox(
            width: 0,
            height: 0,
          );
  }

  Widget buildSpotBalanceView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonHeader(true),
            CustomSizedBox(
              height: 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     CustomText(
                  //         text: stringVariables.todaysPNL,
                  //         fontWeight: FontWeight.w500,
                  //         fontsize: 14,
                  //         color: textGrey,
                  //         fontfamily: 'InterTight'),
                  //     CustomSizedBox(
                  //       width: 0.02,
                  //     ),
                  //     SvgPicture.asset(toolTip),
                  //   ],
                  // ),
                  // CustomSizedBox(
                  //   height: 0.015,
                  // ),
                  // CustomText(
                  //     text: "+₹6.5/+2.56%",
                  //     fontWeight: FontWeight.w500,
                  //     fontsize: 14,
                  //     color: textGrey,
                  //     fontfamily: 'InterTight'),
                  // CustomSizedBox(
                  //   height: 0.02,
                  // ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomElevatedButton(
                            buttoncolor: themeColor,
                            color: themeSupport().isSelectedDarkMode()
                                ? black
                                : white,
                            press: () {
                              List<DashBoardBalance> list =
                                  getTotalBalance.viewModelDashBoardBalance ??
                                      [];
                              list = list
                                  .where((element) =>
                                      element.currencyCode == "BTC")
                                  .toList();
                              DashBoardBalance item;
                              if (list.isNotEmpty) {
                                item = list.first;
                              } else {
                                item = getTotalBalance
                                        .viewModelDashBoardBalance?.first ??
                                    DashBoardBalance();
                              }
                              String currencyName = item.currencyName ?? "";
                              String currencyCode = item.currencyCode ?? "";
                              String totalBalance = trimDecimalsForBalance(
                                  item.totalBalance.toString());
                              String availableBalance =
                                  item.availableBalance.toString();
                              constant.walletCurrency.value =
                                  item.currencyCode ?? "";
                              coinDetailsViewModel.setDropdownvalue(
                                  item.currencyCode.toString());
                              moveToCoinDetailsView(
                                  context,
                                  currencyName,
                                  totalBalance,
                                  availableBalance,
                                  currencyCode,
                                  "${item.currencyType ?? " "}",
                                  '${item.inorderBalance ?? ""}',
                                  '${item.mlmStakeBalance ?? ''}');
                            },
                            width: 1,
                            isBorderedButton: true,
                            maxLines: 1,
                            icon: null,
                            multiClick: true,
                            text: stringVariables.deposit,
                            radius: 25,
                            height: size.height / 40,
                            icons: false,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            blurRadius: 0,
                            spreadRadius: 0,
                            offset: Offset(0, 0)),
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      Flexible(
                        child: CustomElevatedButton(
                            buttoncolor: enableBorder,
                            color: black,
                            press: () {
                              List<DashBoardBalance> list =
                                  getTotalBalance.viewModelDashBoardBalance ??
                                      [];
                              list = list
                                  .where((element) =>
                                      element.currencyCode == "BTC")
                                  .toList();
                              DashBoardBalance item;
                              if (list.isNotEmpty)
                                item = list.first;
                              else {
                                item = getTotalBalance
                                        .viewModelDashBoardBalance?.first ??
                                    DashBoardBalance();
                              }
                              String currencyName = item.currencyName ?? "";
                              String currencyCode = item.currencyCode ?? "";
                              String totalBalance = trimDecimalsForBalance(
                                  item.totalBalance.toString());
                              String availableBalance =
                                  item.availableBalance.toString();
                              constant.walletCurrency.value =
                                  item.currencyCode ?? "";
                              coinDetailsViewModel.setDropdownvalue(
                                  item.currencyCode.toString());
                              moveToCoinDetailsView(
                                  context,
                                  currencyName,
                                  totalBalance,
                                  availableBalance,
                                  currencyCode,
                                  "${item.currencyType ?? " "}",
                                  '${item.inorderBalance ?? ""}',
                                  '${item.mlmStakeBalance}');
                            },
                            width: 1,
                            isBorderedButton: true,
                            maxLines: 1,
                            icon: null,
                            multiClick: true,
                            text: stringVariables.withdraw,
                            radius: 25,
                            height: size.height / 40,
                            icons: false,
                            blurRadius: 0,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            spreadRadius: 0,
                            offset: Offset(0, 0)),
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      Flexible(
                        child: CustomElevatedButton(
                            buttoncolor: enableBorder,
                            color: black,
                            press: () {
                              moveToTransferView(
                                  context, transferViewModel.currency);
                            },
                            width: 1,
                            isBorderedButton: true,
                            maxLines: 1,
                            icon: null,
                            multiClick: true,
                            text: stringVariables.transfer,
                            radius: 25,
                            height: size.height / 40,
                            icons: false,
                            blurRadius: 0,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            spreadRadius: 0,
                            offset: Offset(0, 0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            Divider(
              color: divider,
            ),
            CustomSizedBox(
              height: 0.01,
            ),
          ],
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        text: stringVariables.balance,
                        fontWeight: FontWeight.bold,
                        fontsize: 22,
                        fontfamily: 'InterTight'),
                    GestureDetector(
                      onTap: () {
                        getTotalBalance.setSpotSearch(true);
                        getTotalBalance.searchController.clear();
                        getTotalBalance.searchResult.clear();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomContainer(
                        padding: 2,
                        width: 18,
                        height: 26,
                        child: SvgPicture.asset(
                          stakingSearch,
                          height: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                checkBoxWithText(getTotalBalance.spotZero,
                    stringVariables.hide0Balance, getTotalBalance.setSpotZero),
                CustomSizedBox(
                  height: 0.005,
                ),
                buildSpotMainList()
              ],
            ),
          ),
        ),
      ],
    );
  }

  onP2PClicked() {
    moveToP2P(context);
  }

  Widget buildFundingView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonHeader(false, true),
            CustomSizedBox(
              height: 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: CustomElevatedButton(
                            buttoncolor: themeColor,
                            color: themeSupport().isSelectedDarkMode()
                                ? black
                                : white,
                            press: () {
                              List<UserFundingWalletDetails> list =
                                  getTotalBalance.userFundingWalletDetails ??
                                      [];
                              list = list
                                  .where((element) =>
                                      element.currencyCode == "BTC")
                                  .toList();
                              UserFundingWalletDetails item;
                              if (list.isNotEmpty) {
                                item = list.first;
                              } else {
                                item = getTotalBalance
                                        .userFundingWalletDetails?.first ??
                                    UserFundingWalletDetails(
                                        amount: 0,
                                        inorder: 0,
                                        currencyCode: "",
                                        convertedAmount: 0,
                                        convertedCurrencyCode: "",
                                        currencyLogo: "",
                                        currency_type: "");
                              }
                              constant.walletCurrency.value =
                                  item.currencyCode ?? "";
                              getTotalBalance.getFundingBalanceSocket();
                              moveToFundingWalletView(context, item);
                            },
                            width: 1,
                            isBorderedButton: true,
                            maxLines: 1,
                            icon: null,
                            multiClick: true,
                            text: stringVariables.deposit,
                            radius: 25,
                            height: size.height / 40,
                            icons: false,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            blurRadius: 0,
                            spreadRadius: 0,
                            offset: Offset(0, 0)),
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      Flexible(
                        child: CustomElevatedButton(
                            buttoncolor: enableBorder,
                            color: black,
                            press: () {
                              List<UserFundingWalletDetails> list =
                                  getTotalBalance.userFundingWalletDetails ??
                                      [];
                              list = list
                                  .where((element) =>
                                      element.currencyCode == "BTC")
                                  .toList();
                              UserFundingWalletDetails item;
                              if (list.isNotEmpty) {
                                item = list.first;
                              } else {
                                item = getTotalBalance
                                        .userFundingWalletDetails?.first ??
                                    UserFundingWalletDetails(
                                        amount: 0,
                                        inorder: 0,
                                        currencyCode: "",
                                        convertedAmount: 0,
                                        convertedCurrencyCode: "",
                                        currencyLogo: "",
                                        currency_type: "");
                              }
                              constant.walletCurrency.value =
                                  item.currencyCode ?? "";
                              getTotalBalance.getFundingBalanceSocket();
                              moveToFundingWalletView(context, item);
                            },
                            width: 1,
                            isBorderedButton: true,
                            maxLines: 1,
                            icon: null,
                            multiClick: true,
                            text: stringVariables.withdraw,
                            radius: 25,
                            height: size.height / 40,
                            icons: false,
                            blurRadius: 0,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            spreadRadius: 0,
                            offset: Offset(0, 0)),
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      Flexible(
                        child: CustomElevatedButton(
                            buttoncolor: enableBorder,
                            color: black,
                            press: () {
                              securedPrint("funding");
                              walletSelectViewModel.selectFirstWallet(
                                  stringVariables.spotWallet);
                              walletSelectViewModel
                                  .selectSecondWallet(stringVariables.funding);
                              moveToTransferView(
                                  context, transferViewModel.currency);
                            },
                            width: 1,
                            isBorderedButton: true,
                            maxLines: 1,
                            icon: null,
                            multiClick: true,
                            text: stringVariables.transfer,
                            radius: 25,
                            height: size.height / 40,
                            icons: false,
                            blurRadius: 0,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            spreadRadius: 0,
                            offset: Offset(0, 0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            Divider(
              color: divider,
            ),
            CustomSizedBox(
              height: 0.01,
            ),
          ],
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (constant.p2pStatus)
                      buildCircledItems(
                          p2pMenu, stringVariables.p2p, onP2PClicked),
                  ],
                ),
                CustomSizedBox(
                  height: 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        text: stringVariables.availableBalances,
                        fontWeight: FontWeight.bold,
                        fontsize: 22,
                        fontfamily: 'InterTight'),
                    GestureDetector(
                      onTap: () {
                        getTotalBalance.setFundingSearch(true);
                        fundingSearchController.clear();
                        _fundingSearchResult.clear();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomContainer(
                        padding: 2,
                        width: 18,
                        height: 26,
                        child: SvgPicture.asset(
                          stakingSearch,
                          height: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                checkBoxWithText(getTotalBalance.fundZero,
                    stringVariables.hide0Balance, getTotalBalance.setFundZero),
                CustomSizedBox(
                  height: 0.005,
                ),
                buildFundMainList()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCircledItems(String icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          CustomCircleAvatar(
            backgroundColor: enableBorder,
            radius: 25,
            child: SvgPicture.asset(
              icon,
              color: themeColor,
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomText(
              text: title,
              fontWeight: FontWeight.w500,
              fontfamily: 'InterTight'),
        ],
      ),
    );
  }

  getNetworkOfItem(String item) {
    String network = "";
    List<DashBoardBalance> list = getTotalBalance.viewModelDashBoardBalance
            ?.where((element) => element.currencyCode == item)
            .toList() ??
        [];
    if (list.isNotEmpty) network = list.first.currencyName ?? "";
    return network;
  }

  Widget buildFundMainList() {
    String crypto = constant.pref?.getString("defaultCryptoCurrency") ?? '';
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    List<UserFundingWalletDetails> list =
        getTotalBalance.userFundingWalletDetails;
    bool listVisiblity = list
            .where(
                (element) => (element.amount ?? 0) + (element.inorder ?? 0) > 0)
            .isEmpty &&
        getTotalBalance.fundZero;
    int listCount = listVisiblity ? 0 : list.length;
    return listCount != 0
        ? Flexible(
            child: CustomContainer(
              height: 1,
              child: Scrollbar(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listCount,
                    itemBuilder: (context, index) {
                      UserFundingWalletDetails item = list[index];
                      String image = item.currencyLogo ?? "";
                      String currencyName =
                          getNetworkOfItem(item.currencyCode ?? "");
                      String currencyCode = item.currencyCode ?? '';
                      String availableBalance =
                          trimDecimalsForBalance(item.amount.toString());
                      String freezeValue =
                          trimDecimalsForBalance(item.inorder.toString());
                      num inorderExchange =
                          (item.inorder ?? 0) * (item.exchangeRate ?? 0);
                      String totalBalance =
                          trimDecimalsForBalance(item.totalAmount.toString());
                      var a = (((item.convertedAmount ?? 0) + inorderExchange) *
                          getTotalBalance.fiatValue);
                      String totalFiat = trimDecimalsForBalance(
                          a.toString() == "NaN" ? "0.00" : a.toString());
                      bool visiblityFlag = getTotalBalance.fundZero
                          ? double.parse(totalBalance) > 0
                          : true;
                      return visiblityFlag
                          ? GestureDetector(
                              onTap: () {
                                moveToFundingCoinDetailsView(
                                    context, currencyCode);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomCircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 11,
                                            child: CustomNetworkImage(
                                              image: image,
                                            ),
                                          ),
                                          CustomSizedBox(
                                            width: 0.02,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  text: currencyCode),
                                              CustomSizedBox(
                                                height: 0.0075,
                                              ),
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text: currencyName),
                                              CustomSizedBox(
                                                height: 0.0125,
                                              ),
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text: stringVariables
                                                      .available),
                                              CustomSizedBox(
                                                height: 0.0075,
                                              ),
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  text:
                                                      getTotalBalance.isvisible
                                                          ? availableBalance
                                                          : "*****"),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  text:
                                                      getTotalBalance.isvisible
                                                          ? totalBalance +
                                                              " $currencyCode"
                                                          : "*****"),
                                              CustomSizedBox(
                                                width: 0.0275,
                                              )
                                            ],
                                          ),
                                          CustomSizedBox(
                                            height: 0.0075,
                                          ),
                                          Row(
                                            children: [
                                              CustomText(
                                                  fontfamily:
                                                      getTotalBalance.isvisible
                                                          ? ''
                                                          : 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text:
                                                      getTotalBalance.isvisible
                                                          ? currencySymbol
                                                          : "*"),
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text:
                                                      getTotalBalance.isvisible
                                                          ? totalFiat
                                                          : "****"),
                                              CustomSizedBox(
                                                width: 0.0275,
                                              )
                                            ],
                                          ),
                                          CustomSizedBox(
                                            height: 0.0125,
                                          ),
                                          Row(
                                            children: [
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text: stringVariables.freeze),
                                              CustomSizedBox(
                                                width: 0.0275,
                                              )
                                            ],
                                          ),
                                          CustomSizedBox(
                                            height: 0.005,
                                          ),
                                          Row(
                                            children: [
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  text:
                                                      getTotalBalance.isvisible
                                                          ? freezeValue
                                                          : "*****"),
                                              CustomSizedBox(
                                                width: 0.0275,
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  if (!(listCount - 1 == index))
                                    Column(
                                      children: [
                                        CustomSizedBox(
                                          height: 0.01,
                                        ),
                                        Divider(
                                          color: divider,
                                        ),
                                      ],
                                    ),
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                ],
                              ),
                            )
                          : CustomSizedBox(
                              width: 0,
                              height: 0,
                            );
                    }),
              ),
            ),
          )
        : noRecords();
  }

  Widget buildSpotMainList() {
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    List<DashBoardBalance> list =
        getTotalBalance.viewModelDashBoardBalance ?? [];
    bool listVisiblity =
        list.where((element) => (element.usdValue ?? 0) > 0).isEmpty &&
            getTotalBalance.spotZero;

    int listCount = listVisiblity ? 0 : list.length;
    return listCount != 0
        ? Flexible(
            child: CustomContainer(
              height: 1,
              child: Scrollbar(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listCount,
                    itemBuilder: (context, index) {
                      DashBoardBalance item = list[index];
                      String image = item.image ?? "";
                      String currencyName = item.currencyName ?? "";
                      String currencyCode = item.currencyCode ?? "";
                      String totalBalance =
                          trimDecimalsForBalance(item.usdValue.toString());
                      String availableBalance =
                          item.availableBalance.toString();
                      String defaultCryptoValue = trimDecimalsForBalance(
                          item.availableBalance.toString());
                      bool visiblityFlag = getTotalBalance.spotZero
                          ? double.parse(totalBalance) > 0
                          : true;
                      return visiblityFlag
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    constant.walletCurrency.value =
                                        item.currencyCode ?? "";
                                    coinDetailsViewModel.setDropdownvalue(
                                        item.currencyCode.toString());
                                    moveToCoinDetailsView(
                                        context,
                                        currencyName,
                                        totalBalance,
                                        availableBalance,
                                        currencyCode,
                                        "${item.currencyType ?? " "}",
                                        '${item.inorderBalance ?? ""}',
                                        '${item.mlmStakeBalance}');
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CustomCircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 11,
                                            child: CustomNetworkImage(
                                              image: image,
                                            ),
                                          ),
                                          CustomSizedBox(
                                            width: 0.02,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  text: currencyCode),
                                              CustomSizedBox(
                                                height: 0.0075,
                                              ),
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text: currencyName)
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  text: getTotalBalance
                                                          .isvisible
                                                      ? "$defaultCryptoValue $currencyCode"
                                                      : "*****"),
                                              CustomSizedBox(
                                                width: 0.0275,
                                              ),
                                            ],
                                          ),
                                          CustomSizedBox(
                                            height: 0.0075,
                                          ),
                                          Row(
                                            children: [
                                              CustomText(
                                                  fontfamily:
                                                      getTotalBalance.isvisible
                                                          ? ''
                                                          : 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text:
                                                      getTotalBalance.isvisible
                                                          ? currencySymbol
                                                          : "*"),
                                              CustomText(
                                                  fontfamily: 'InterTight',
                                                  fontsize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGrey,
                                                  text:
                                                      getTotalBalance.isvisible
                                                          ? totalBalance
                                                          : "****"),
                                              CustomSizedBox(
                                                width: 0.0275,
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                CustomSizedBox(
                                  height: 0.02,
                                )
                              ],
                            )
                          : CustomSizedBox(
                              width: 0,
                              height: 0,
                            );
                    }),
              ),
            ),
          )
        : noRecords();
  }

  String getImage(String crypto) {
    List<dynamic> list = [];
    list = constant.userLoginStatus.value
        ? (getTotalBalance.viewModelDashBoardBalance != null)
            ? (getTotalBalance.viewModelDashBoardBalance!.isNotEmpty)
                ? getTotalBalance.viewModelDashBoardBalance!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : []
        : (marketViewModel.getCurrencies != null)
            ? (marketViewModel.getCurrencies!.isNotEmpty)
                ? marketViewModel.getCurrencies!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : [];
    return (list == null || list.isEmpty) ? "" : list.first.image;
  }

  getStatus(String status) {
    String value;
    if (status == stringVariables.readyForRedeem) {
      value = capitalize(stringVariables.staked);
    } else if (status == stringVariables.redeemRequest) {
      value = stringVariables.redeemProcessing;
    } else {
      value = capitalize(status);
    }
    return value;
  }

  buildTextWithColor(String content1, String content2, Color? color,
      [isSmall = false]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomText(
                    text: content1,
                    fontWeight: FontWeight.w400,
                    fontsize: isSmall ? 13 : 15,
                    color: color,
                    fontfamily: color == green ? "InterTight" : 'InterTight'),
              ],
            ),
            Row(
              children: [
                CustomText(
                    text: content2,
                    fontWeight: FontWeight.w400,
                    fontsize: isSmall ? 13 : 15,
                    color: color,
                    fontfamily: color == green ? "InterTight" : 'InterTight'),
                CustomSizedBox(
                  width: 0.02,
                ),
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.0075,
        )
      ],
    );
  }

  noRecords() {
    return Center(
      child: Column(
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
          CustomSizedBox(
            height: 0.05,
          ),
        ],
      ),
    );
  }

  Widget commonHeader([bool spot = false, bool fund = false]) {
    String crypto = constant.pref?.getString("defaultCryptoCurrency") ?? '';
    String fiat = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiat)
        .value;
    num estimateCrossCrypto =
        getTotalBalance.totalCrossDebt + getTotalBalance.totalCrossEquity;
    num estimateCrossFiat = estimateCrossCrypto * getTotalBalance.fiatValue;
    num estimateIsolatedCrypto =
        getTotalBalance.totalIsolatedDebt + getTotalBalance.totalIsolatedEquity;
    num estimateIsolatedFiat =
        estimateIsolatedCrypto * getTotalBalance.fiatValue;
    num estimateFiat = getTotalBalance.tabIndex == 1
        ? getTotalBalance.estimateFiatValue
        : getTotalBalance.tabIndex == 2
            ? getTotalBalance.estimateFundingFiatValue
            : (getTotalBalance.estimateFiatValue +
                estimateCrossFiat +
                estimateIsolatedFiat +
                getTotalBalance.estimateFundingFiatValue +
                getTotalBalance.totalUsdmBalance +
                getTotalBalance.totalCoinmBalance);
    num estimateCrypto = getTotalBalance.tabIndex == 1
        ? getTotalBalance.estimateTotalValue
        : getTotalBalance.tabIndex == 2
            ? getTotalBalance.estimateFundingTotalValue
            : (getTotalBalance.estimateTotalValue +
                estimateCrossCrypto +
                estimateIsolatedCrypto +
                getTotalBalance.estimateFundingTotalValue +
                getTotalBalance.totalUsdmCryptoBalance +
                getTotalBalance.totalCoinmCryptoBalance);
    String fiatValue = trimDecimalsForBalance(estimateFiat.toString());
    String cryptoValue = trimDecimalsForBalance(estimateCrypto.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
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
                  CustomText(
                      text: "${stringVariables.totalBalance} ($crypto)",
                      fontWeight: FontWeight.w500,
                      fontsize: 14,
                      color: textGrey,
                      fontfamily: 'InterTight'),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  GestureDetector(
                      onTap: () {
                        getTotalBalance.setVisible();
                      },
                      child: Icon(
                        getTotalBalance.isvisible
                            ? Icons.remove_red_eye_rounded
                            : Icons.visibility_off,
                        color: textHeaderGrey,
                        size: 20,
                      )),
                ],
              ),
              (spot || fund)
                  ? GestureDetector(
                      onTap: () {
                        if (spot)
                          Provider.of<CommonViewModel>(
                                  NavigationService
                                      .navigatorKey.currentContext!,
                                  listen: false)
                              .setActive(2);
                        else
                          moveToFundingHistoryView(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomContainer(
                        padding: 2,
                        width: 18,
                        height: 26,
                        child: SvgPicture.asset(
                          walletHistory,
                        ),
                      ),
                    )
                  : CustomSizedBox(),
            ],
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                  text: getTotalBalance.isvisible ? cryptoValue : "*****",
                  fontWeight: FontWeight.bold,
                  fontsize: 24,
                  fontfamily: 'InterTight'),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 2),
              //   child: CustomText(
              //       text: " $crypto",
              //       fontWeight: FontWeight.bold,
              //       fontsize: 16,
              //       color: textGrey,
              //       fontfamily: 'InterTight'),
              // ),
            ],
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                  text: getTotalBalance.isvisible ? "≈ " : "*",
                  fontWeight: getTotalBalance.isvisible
                      ? FontWeight.w500
                      : FontWeight.bold,
                  fontsize: 16,
                  color: textGrey,
                  fontfamily: 'InterTight'),
              CustomText(
                text: getTotalBalance.isvisible ? "$currencySymbol" : "*",
                overflow: TextOverflow.ellipsis,
                fontfamily: getTotalBalance.isvisible ? '' : 'InterTight',
                fontWeight: getTotalBalance.isvisible
                    ? FontWeight.w500
                    : FontWeight.bold,
                fontsize: 16,
                color: textGrey,
              ),
              CustomText(
                  text: getTotalBalance.isvisible ? fiatValue : "***",
                  fontWeight: FontWeight.bold,
                  fontsize: 16,
                  color: textGrey,
                  fontfamily: 'InterTight'),
            ],
          ),
        ],
      ),
    );
  }

  buildMarginTabBar(Size size) {
    return ButtonsTabBar(
      buttonMargin: EdgeInsets.zero,
      labelSpacing: 0,
      height: size.height / 26,
      controller: _marginController,
      backgroundColor:
          themeSupport().isSelectedDarkMode() ? switchBackground : enableBorder,
      contentPadding: EdgeInsets.symmetric(horizontal: size.width / 24),
      unselectedBackgroundColor: Colors.transparent,
      splashColor: Colors.transparent,
      unselectedLabelStyle: TextStyle(
          fontSize: 14,
          color: themeSupport().isSelectedDarkMode() ? white : black,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w400),
      labelStyle: TextStyle(
          fontSize: 14,
          color: themeSupport().isSelectedDarkMode() ? white : black,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w400),
      tabs: [
        Tab(
          text: stringVariables.cross,
        ),
        Tab(
          text: stringVariables.isolated,
        ),
      ],
    );
  }

  buildFutureTabBar(Size size) {
    return ButtonsTabBar(
      buttonMargin: EdgeInsets.zero,
      labelSpacing: 0,
      height: size.height / 26,
      controller: _futureController,
      backgroundColor:
          themeSupport().isSelectedDarkMode() ? switchBackground : enableBorder,
      contentPadding: EdgeInsets.symmetric(horizontal: size.width / 24),
      unselectedBackgroundColor: Colors.transparent,
      splashColor: Colors.transparent,
      unselectedLabelStyle: TextStyle(
          fontSize: 14,
          color: themeSupport().isSelectedDarkMode() ? white : black,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w400),
      labelStyle: TextStyle(
          fontSize: 14,
          color: themeSupport().isSelectedDarkMode() ? white : black,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w400),
      tabs: [
        Tab(
          text: stringVariables.usdm,
        ),
        Tab(
          text: stringVariables.coinm,
        ),
      ],
    );
  }

  String riskStatusForGauges(
      num data, num initialRiskRatio, num mcr, num liquidationRatio) {
    String icon =
        themeSupport().isSelectedDarkMode() ? gaugesLowDark : gaugesLow;
    if (data > initialRiskRatio) {
      icon = themeSupport().isSelectedDarkMode() ? gaugesLowDark : gaugesLow;
    } else if ((initialRiskRatio > data && data > mcr)) {
      icon = themeSupport().isSelectedDarkMode() ? gaugesMidDark : gaugesMid;
    } else if (mcr > data && data > liquidationRatio) {
      icon = themeSupport().isSelectedDarkMode() ? gaugesHighDark : gaugesHigh;
    } else {
      icon = themeSupport().isSelectedDarkMode() ? gaugesHighDark : gaugesHigh;
    }
    return icon;
  }

  String riskStatus(
      num data, num initialRiskRatio, num mcr, num liquidationRatio) {
    String status = stringVariables.highRisk;
    if (data > initialRiskRatio) {
      status = stringVariables.lowRisk;
    } else if ((initialRiskRatio > data && data > mcr)) {
      status = stringVariables.mediumRisk;
    } else if (mcr > data && data > liquidationRatio) {
      status = stringVariables.highRisk;
    } else {
      status = stringVariables.highRisk;
    }
    return status;
  }

  Color riskColor(
      num data, num initialRiskRatio, num mcr, num liquidationRatio) {
    Color color = red;
    if (data > initialRiskRatio) {
      color = green;
    } else if ((initialRiskRatio > data && data > mcr)) {
      color = gaugesYellow;
    } else if (mcr > data && data > liquidationRatio) {
      color = red;
    } else {
      color = red;
    }
    return color;
  }

  Widget buildSpotSearchView(Size size) {
    result = getTotalBalance.viewModelDashBoardBalance;
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    List<DashBoardBalance> list = getTotalBalance.searchResult.length != 0 ||
            getTotalBalance.searchController.text.isNotEmpty
        ? getTotalBalance.searchResult
        : getTotalBalance.viewModelDashBoardBalance ?? [];
    int listCount = list.length;
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 4,
              child: CustomTextFormField(
                size: 30,
                isContentPadding: false,
                prefixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.search,
                      color: textGrey,
                      size: 25,
                    )),
                text: stringVariables.search,
                hintfontsize: 16,
                controller: getTotalBalance.searchController,
                onChanged: onSearchTextChanged,
              ),
            ),
            Flexible(
                child: CustomElevatedButton(
                    buttoncolor:
                        themeSupport().isSelectedDarkMode() ? card_dark : white,
                    color: themeColor,
                    press: () {
                      getTotalBalance.setSpotSearch(false);
                    },
                    width: 1,
                    isBorderedButton: true,
                    maxLines: 1,
                    icon: null,
                    multiClick: true,
                    text: stringVariables.cancel,
                    radius: 25,
                    height: size.height / 35,
                    icons: false,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: Offset(0, 0))),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Flexible(
            child: getTotalBalance.searchController.text.isNotEmpty &&
                    getTotalBalance.searchResult.isEmpty
                ? CustomText(
                    text: stringVariables.noResultFound,
                    fontsize: 18,
                  )
                : Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listCount,
                        itemBuilder: (context, index) {
                          DashBoardBalance item = list[index];
                          String image = item.image ?? "";
                          String currencyName = item.currencyName ?? "";
                          String currencyCode = item.currencyCode ?? "";
                          String totalBalance =
                              trimDecimalsForBalance(item.usdValue.toString());
                          String availableBalance =
                              item.availableBalance.toString();
                          String defaultCryptoValue = trimDecimalsForBalance(
                              item.availableBalance.toString());
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  constant.walletCurrency.value =
                                      item.currencyCode ?? "";
                                  coinDetailsViewModel.setDropdownvalue(
                                      item.currencyCode.toString());
                                  moveToCoinDetailsView(
                                      context,
                                      currencyName,
                                      totalBalance,
                                      availableBalance,
                                      currencyCode,
                                      "${item.currencyType ?? " "}",
                                      '${item.inorderBalance ?? ""}',
                                      '${item.mlmStakeBalance}');
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CustomCircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 11,
                                          child: CustomNetworkImage(
                                            image: image,
                                          ),
                                        ),
                                        CustomSizedBox(
                                          width: 0.02,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                                fontfamily: 'InterTight',
                                                fontsize: 16,
                                                fontWeight: FontWeight.w500,
                                                text: currencyCode),
                                            CustomSizedBox(
                                              height: 0.0075,
                                            ),
                                            CustomText(
                                                fontfamily: 'InterTight',
                                                fontsize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: textGrey,
                                                text: currencyName)
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            CustomText(
                                                fontfamily: 'InterTight',
                                                fontsize: 16,
                                                fontWeight: FontWeight.w500,
                                                text: getTotalBalance.isvisible
                                                    ? defaultCryptoValue +
                                                        " $currencyCode"
                                                    : "*****"),
                                            CustomSizedBox(
                                              width: 0.0275,
                                            ),
                                          ],
                                        ),
                                        CustomSizedBox(
                                          height: 0.0075,
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                                fontfamily:
                                                    getTotalBalance.isvisible
                                                        ? ''
                                                        : 'InterTight',
                                                fontsize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: textGrey,
                                                text: getTotalBalance.isvisible
                                                    ? currencySymbol
                                                    : "*"),
                                            CustomText(
                                                fontfamily: 'InterTight',
                                                fontsize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: textGrey,
                                                text: getTotalBalance.isvisible
                                                    ? totalBalance
                                                    : "****"),
                                            CustomSizedBox(
                                              width: 0.0275,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              CustomSizedBox(
                                height: 0.02,
                              )
                            ],
                          );
                        }),
                  ))
      ],
    );
  }

  Widget buildFundingSearchView(Size size) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // walletHeader(
            //   context,
            // ),
            listViewForFunding(size),
          ],
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
                child: SvgPicture.asset(
                  themeSupport().isSelectedDarkMode()
                      ? userDarkImage
                      : userImage,
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
              text: stringVariables.wallets,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }

  /// Total portfolio value
  Widget walletHeader(
    BuildContext context,
  ) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
                text: trimDecimalsForBalance(
                    '${getTotalBalance.estimateFiatValue}'),
                fontWeight: FontWeight.w800,
                fontsize: 28,
                fontfamily: 'InterTight'),
            Padding(
              padding: EdgeInsets.only(bottom: 2.5),
              child: CustomText(
                  text:
                      ' ${constant.pref?.getString("defaultFiatCurrency") ?? ''}',
                  fontWeight: FontWeight.bold,
                  fontsize: 18,
                  color: textGrey,
                  fontfamily: 'InterTight'),
            ),
          ],
        ),
        CustomText(
            text: stringVariables.totalPortFolio,
            fontWeight: FontWeight.bold,
            fontsize: 18,
            color: textGrey,
            strutStyleHeight: 2.5,
            fontfamily: 'InterTight'),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget listViewForFunding(Size size) {
    Result = getTotalBalance.userFundingWalletDetails;
    bool searchFlag = _fundingSearchResult.length != 0 ||
        fundingSearchController.text.isNotEmpty;
    int listCount = searchFlag
        ? _fundingSearchResult.length
        : getTotalBalance.userFundingWalletDetails.length ?? 0;
    String crypto = constant.pref?.getString("defaultCryptoCurrency") ?? '';
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    List<UserFundingWalletDetails> list = searchFlag
        ? _fundingSearchResult
        : getTotalBalance.userFundingWalletDetails;
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 4,
              child: CustomTextFormField(
                size: 30,
                isContentPadding: false,
                prefixIcon: Icon(
                  Icons.search,
                  color: textGrey,
                  size: 25,
                ),
                text: stringVariables.search,
                hintfontsize: 16,
                controller: fundingSearchController,
                onChanged: onFundingSearchTextChanged,
              ),
            ),
            Flexible(
                child: CustomElevatedButton(
                    buttoncolor:
                        themeSupport().isSelectedDarkMode() ? card_dark : white,
                    color: themeColor,
                    press: () {
                      getTotalBalance.setFundingSearch(false);
                      fundingSearchController.clear();
                      _fundingSearchResult.clear();
                    },
                    width: 1,
                    isBorderedButton: true,
                    maxLines: 1,
                    icon: null,
                    multiClick: true,
                    text: stringVariables.cancel,
                    radius: 25,
                    height: size.height / 35,
                    icons: false,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: Offset(0, 0))),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
            width: 1,
            height: 1.65,
            child: fundingSearchController.text.isNotEmpty &&
                    _fundingSearchResult.isEmpty
                ? Center(
                    child: CustomText(
                    text: stringVariables.noResultFound,
                    fontsize: 18,
                  ))
                : Scrollbar(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listCount,
                        itemBuilder: (context, index) {
                          UserFundingWalletDetails item = list[index];
                          String image = item.currencyLogo ?? '';
                          String currencyName =
                              getNetworkOfItem(item.currencyCode ?? '');
                          String currencyCode = item.currencyCode ?? '';
                          String availableBalance =
                              trimDecimalsForBalance(item.amount.toString());
                          String freezeValue =
                              trimDecimalsForBalance(item.inorder.toString());
                          num inorderExchange =
                              (item.inorder ?? 0) * (item.exchangeRate ?? 0);
                          String totalBalance = trimDecimalsForBalance(
                              item.totalAmount.toString());
                          var a =
                              (((item.convertedAmount ?? 0) + inorderExchange) *
                                  getTotalBalance.fiatValue);
                          String totalFiat = trimDecimalsForBalance(
                              a.toString() == "NaN" ? "0.00" : a.toString());
                          bool visiblityFlag = getTotalBalance.fundZero
                              ? double.parse(totalBalance) > 0
                              : true;
                          return visiblityFlag
                              ? GestureDetector(
                                  onTap: () {
                                    moveToFundingCoinDetailsView(
                                        context, currencyCode);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomCircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 11,
                                                child: CustomNetworkImage(
                                                  image: image,
                                                ),
                                              ),
                                              CustomSizedBox(
                                                width: 0.02,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      text: currencyCode),
                                                  CustomSizedBox(
                                                    height: 0.0075,
                                                  ),
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: textGrey,
                                                      text: currencyName),
                                                  CustomSizedBox(
                                                    height: 0.0125,
                                                  ),
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: textGrey,
                                                      text: stringVariables
                                                          .available),
                                                  CustomSizedBox(
                                                    height: 0.0075,
                                                  ),
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      text: getTotalBalance
                                                              .isvisible
                                                          ? availableBalance
                                                          : "*****"),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      text: getTotalBalance
                                                              .isvisible
                                                          ? "$totalBalance $currencyCode"
                                                          : "*****"),
                                                  CustomSizedBox(
                                                    width: 0.0275,
                                                  )
                                                ],
                                              ),
                                              CustomSizedBox(
                                                height: 0.0075,
                                              ),
                                              Row(
                                                children: [
                                                  CustomText(
                                                      fontfamily:
                                                          getTotalBalance
                                                                  .isvisible
                                                              ? ''
                                                              : 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: textGrey,
                                                      text: getTotalBalance
                                                              .isvisible
                                                          ? currencySymbol
                                                          : "*"),
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: textGrey,
                                                      text: getTotalBalance
                                                              .isvisible
                                                          ? totalFiat
                                                          : "****"),
                                                  CustomSizedBox(
                                                    width: 0.0275,
                                                  )
                                                ],
                                              ),
                                              CustomSizedBox(
                                                height: 0.0125,
                                              ),
                                              Row(
                                                children: [
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: textGrey,
                                                      text: stringVariables
                                                          .freeze),
                                                  CustomSizedBox(
                                                    width: 0.0275,
                                                  )
                                                ],
                                              ),
                                              CustomSizedBox(
                                                height: 0.005,
                                              ),
                                              Row(
                                                children: [
                                                  CustomText(
                                                      fontfamily: 'InterTight',
                                                      fontsize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      text: getTotalBalance
                                                              .isvisible
                                                          ? freezeValue
                                                          : "*****"),
                                                  CustomSizedBox(
                                                    width: 0.0275,
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      if (!(listCount - 1 == index))
                                        Column(
                                          children: [
                                            CustomSizedBox(
                                              height: 0.01,
                                            ),
                                            Divider(
                                              color: divider,
                                            ),
                                          ],
                                        ),
                                      CustomSizedBox(
                                        height: 0.01,
                                      ),
                                    ],
                                  ),
                                )
                              : CustomSizedBox(
                                  width: 0,
                                  height: 0,
                                );
                        }),
                  ))
      ],
    );
  }

  onSearchTextChanged(
    String text,
  ) async {
    getTotalBalance.searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    List<DashBoardBalance> searchResult =
        result as List<DashBoardBalance>; //set result to search result
    getTotalBalance.searchResult = searchResult
        .where((element) =>
            element.currencyName!.toLowerCase().contains(text.toLowerCase()) ||
            element.currencyCode!.toLowerCase().contains(text.toLowerCase()))
        .toList();

    setState(() {});
  }

  onFundingSearchTextChanged(
    String text,
  ) async {
    _fundingSearchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    List<UserFundingWalletDetails> searchResult =
        Result as List<UserFundingWalletDetails>;
    _fundingSearchResult = searchResult
        .where((element) =>
            element.currencyCode!.toLowerCase().contains(text.toLowerCase()) ||
            element.currencyCode!.toLowerCase().contains(text.toLowerCase()))
        .toList();

    setState(() {});
  }
}
