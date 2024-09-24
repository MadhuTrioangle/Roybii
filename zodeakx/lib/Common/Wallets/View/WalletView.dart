import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/SplashScreen/ViewModel/SplashViewModel.dart';
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
import 'package:zodeakx_mobile/staking/balance/view_model/staking_balance_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/view_model/staking_transaction_view_model.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/Networking/CommonModel/CommonModel.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../funding_wallet/funding_coin_details/model/funding_wallet_balance.dart';
import '../../../p2p/counter_parties_profile/view/p2p_counter_profile_view.dart';
import '../../../p2p/home/view/p2p_home_view.dart';
import '../../../staking/balance/model/ActiveUserStakesModel.dart';
import '../../../staking/search_coins/viewModel/search_coins_view_model.dart';
import '../../CommingSoon/View/ComingSoonView.dart';
import '../../CommingSoon/View/CommonDialog.dart';
import '../../Common/ViewModel/common_view_model.dart';
import '../../Transfer/ViewModel/TransferViewModel.dart';
import '../../wallet_select/viewModel/wallet_select_view_model.dart';
import '../CoinDetailsViewModel/CoinDetailsViewModel.dart';

import '../ViewModel/WalletViewModel.dart';
import 'MustLoginView.dart';

class WalletView extends StatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> with TickerProviderStateMixin {
  List<DashBoardBalance> _searchResult = [];
  List<GetUserFundingWalletDetails> _fundingSearchResult = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController fundingSearchController = TextEditingController();
  String text = "bitcoin";
  List<GetUserFundingWalletDetails>? Result;
  List<DashBoardBalance>? result;
  String defaultFiatCurrency =
      constant.pref?.getString("defaultFiatCurrency") ?? '';
  late WalletViewModel getTotalBalance;
  late MarketViewModel marketViewModel;
  late StakingTransactionViewModel stakingTransactionViewModel;
  late StakingBalanceViewModel stakingBalanceViewModel;
  late SplashViewModel splashViewModel;
  late SearchCoinsViewModel searchCoinsViewModel;
  late WalletSelectViewModel walletSelectViewModel;
  late CoinDetailsViewModel coinDetailsViewModel;
  late TransferViewModel transferViewModel;
  late TabController walletTabController;
  late TabController _marginController;
  late TabController _futureController;

  @override
  void initState() {
    getTotalBalance = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    coinDetailsViewModel = Provider.of<CoinDetailsViewModel>(context, listen: false);
    transferViewModel = Provider.of<TransferViewModel>(context, listen: false);
    walletSelectViewModel =
        Provider.of<WalletSelectViewModel>(context, listen: false);

    stakingBalanceViewModel =
        Provider.of<StakingBalanceViewModel>(context, listen: false);
    splashViewModel = Provider.of<SplashViewModel>(context, listen: false);
    stakingTransactionViewModel =
        Provider.of<StakingTransactionViewModel>(context, listen: false);
    searchCoinsViewModel =
        Provider.of<SearchCoinsViewModel>(context, listen: false);
    walletTabController =
        TabController(length: getTotalBalance.walletTabs.length, vsync: this);

    if (constant.userLoginStatus.value == true) {
      //borrowingCoolingPeriodViewModel.fetchUserMarginSetting();
    }

    if (constant.userLoginStatus.value) getTotalBalance.getDashBoardBalance();
    _marginController = TabController(length: 2, vsync: this);
    _futureController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //coinDetailsViewModel.getSpotBalanceSocket();
      //getTotalBalance.getFundingBalanceSocket();
      walletTabController.addListener(() {
        getTotalBalance.setTabIndex(walletTabController.index);
        if (walletTabController.animation?.value == walletTabController.index) {
          if (walletTabController.index == 1) {
            getTotalBalance.setSpotSearch(false);
            if (constant.userLoginStatus.value) {
              getTotalBalance.getDashBoardBalance();
            }
          } else if (walletTabController.index == 2) {
            StakingBalanceViewModel stakingBalanceViewModel =
            Provider.of<StakingBalanceViewModel>(
                NavigationService.navigatorKey.currentContext!,
                listen: false);
            stakingBalanceViewModel.setLoading(true);
            stakingBalanceViewModel.getActiveUserStakes(0);
          } else if (walletTabController.index == 3) {
            getTotalBalance.setFundingSearch(false);
            getTotalBalance.getUserFundingWalletDetails();
          }
        }
      });
    });
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    marketViewModel.leaveSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getTotalBalance = context.watch<WalletViewModel>();
    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    stakingTransactionViewModel = context.watch<StakingTransactionViewModel>();
    stakingBalanceViewModel = context.watch<StakingBalanceViewModel>();
    searchCoinsViewModel = context.watch<SearchCoinsViewModel>();
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
          fontFamily: 'GoogleSans',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          fontFamily: 'GoogleSans',
        ),
        indicatorWeight: 0,
        indicator: TabBarIndicator(color: themeColor, radius: 4),
        isScrollable: true,
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
    bool stakingStatus = constant.stakingStatus;
    bool fundingStatus = constant.fundingStatus;
    return [
      buildCommonView(size),
      getTotalBalance.spotSearch
          ? buildSpotSearchView(size)
          : buildSpotBalanceView(size),
      stakingStatus ? buildStakingView(size) : ComingSoonView(),
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
    String stakeCryptoBalance = trimDecimalsForBalance(stakingBalanceViewModel.estimateTotalStakeConverted.toString());
    String spotFiatBalance =
    trimDecimalsForBalance(getTotalBalance.estimateFiatValue.toString());
    String stakeFiatBalance = trimDecimalsForBalance(
        stakingBalanceViewModel.estimateFiatTotalStakeConverted.toString());
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
            double.parse(stakeCryptoBalance) == 0 &&
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
                          '${item.mlmStakeBalance ?? ""}',);
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
            Divider(),
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
                    fontfamily: 'GoogleSans'),
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
                              stakingMenu,
                              stringVariables.staking,
                              double.parse(stakeCryptoBalance) == 0
                                  ? ""
                                  : stakeCryptoBalance + " $crypto",
                              double.parse(stakeFiatBalance) == 0
                                  ? ""
                                  : "≈ ${currencySymbol}" +
                                  stakeFiatBalance,
                              onStakingPressed),
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
                )
              ],
            ),
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
            fontfamily: 'GoogleSans',
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


  Widget buildTextWithUnderline(String title, String value,
      [bool underLine = false, bool endAlign = false, bool image = false]) {
    return Column(
      crossAxisAlignment:
      endAlign ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
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
              fontfamily: 'SourceSans',
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
        .push(CommonDialog(context, title, content));
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
                fontfamily: 'GoogleSans'))
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
                          fontfamily: 'GoogleSans'),
                    ],
                  ),
                  CustomText(
                      text: getTotalBalance.isvisible
                          ? content2.isEmpty
                          ? "0.0 ${crypto}"
                          : content2
                          : "*****",
                      fontWeight: FontWeight.w500,
                      fontsize: 15,
                      fontfamily: 'GoogleSans'),
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
                      fontfamily: 'SourceSans'),
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

  Widget buildStakingView(Size size) {
    return Column(
      children: [
        commonHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  moveToTransaction(context);
                },
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(stakingTransaction),
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              GestureDetector(
                onTap: () {
                  moveToOrderHistory(context);
                },
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(stakingHistory),
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CustomText(
                      text: stringVariables.assets,
                      fontWeight: FontWeight.w600,
                      fontsize: 16,
                      fontfamily: 'GoogleSans'),
                  CustomSizedBox(
                    height: 0.0025,
                  ),
                  CustomContainer(
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(
                        5.0,
                      ),
                    ),
                    height: size.height / 3,
                    width: 12.5,
                  )
                ],
              ),
              // Row(
              //   children: [
              //     GestureDetector(
              //         onTap: () {
              //           moveToSearchCoinsView(context, false);
              //         },
              //         behavior: HitTestBehavior.opaque,
              //         child: SvgPicture.asset(
              //           stakingSearch,
              //           color: (searchCoinsViewModel.selectedCurrency != null)
              //               ? themeColor
              //               : null,
              //         )),
              //     CustomSizedBox(
              //       width: 0.05,
              //     ),
              //     GestureDetector(
              //         onTap: () {
              //           _showHoldingsModal(context);
              //         },
              //         behavior: HitTestBehavior.opaque,
              //         child: SvgPicture.asset(
              //           stakingFilter,
              //           color: useFilteredList ? themeColor : null,
              //         )),
              //   ],
              // )
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        buildListOfStaking(size)
      ],
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
                  //         fontfamily: 'GoogleSans'),
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
                  //     fontfamily: 'GoogleSans'),
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
                              coinDetailsViewModel.setDropdownvalue(item.currencyCode.toString());
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
                              coinDetailsViewModel.setDropdownvalue(item.currencyCode.toString());
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
                                  context, );
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
            Divider(),
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
                        fontfamily: 'GoogleSans'),
                    GestureDetector(
                      onTap: () {
                        getTotalBalance.setSpotSearch(true);
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
                              List<GetUserFundingWalletDetails> list =
                                  getTotalBalance.userFundingWalletDetails ??
                                      [];
                              list = list
                                  .where((element) =>
                              element.currencyCode == "BTC")
                                  .toList();
                              GetUserFundingWalletDetails item;
                              if (list.isNotEmpty) {
                                item = list.first;
                              } else {
                                item = getTotalBalance
                                    .userFundingWalletDetails?.first ??
                                    GetUserFundingWalletDetails( amount: 0,
                                        inorder: 0,
                                        currencyCode: "",
                                        convertedAmount: 0,
                                        convertedCurrencyCode: "",
                                        currencyLogo: "",currencyType:"");
                              }
                              constant.walletCurrency.value =
                                  item.currencyCode ?? "";
                              //getTotalBalance.getFundingBalanceSocket();
                              moveToFundingWalletView(context,item);
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
                              List<GetUserFundingWalletDetails> list =
                                  getTotalBalance.userFundingWalletDetails ??
                                      [];
                              list = list
                                  .where((element) =>
                              element.currencyCode == "BTC")
                                  .toList();
                              GetUserFundingWalletDetails item;
                              if (list.isNotEmpty) {
                                item = list.first;
                              } else {
                                item = getTotalBalance
                                    .userFundingWalletDetails?.first ??
                                    GetUserFundingWalletDetails( amount: 0,
                                        inorder: 0,
                                        currencyCode: "",
                                        convertedAmount: 0,
                                        convertedCurrencyCode: "",
                                        currencyLogo: "",currencyType:"");
                              }
                              constant.walletCurrency.value =
                                  item.currencyCode ?? "";
                            //  getTotalBalance.getFundingBalanceSocket();
                              moveToFundingWalletView(context,item);
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
                                  context,);
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
            Divider(),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     if (constant.p2pStatus)
                //       buildCircledItems(
                //           p2pMenu, stringVariables.p2p, onP2PClicked),
                //     if (constant.payStatus)
                //       buildCircledItems(
                //           payIcon, stringVariables.pay, onPayClicked),
                //   ],
                // ),
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
                        fontfamily: 'GoogleSans'),
                    GestureDetector(
                      onTap: () {
                        getTotalBalance.setFundingSearch(true);
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
              fontfamily: 'GoogleSans'),
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
    List<GetUserFundingWalletDetails> list =
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
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: listCount,
            itemBuilder: (context, index) {
              GetUserFundingWalletDetails item = list[index];
              String image = item.currencyLogo ?? "";
              String currencyName = getNetworkOfItem(item.currencyCode ?? "");
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
              String totalFiat = trimDecimalsForBalance(a.toString() == "NaN" ? "0.00" : a.toString());
              bool visiblityFlag = getTotalBalance.fundZero
                  ? double.parse(totalBalance) > 0
                  : true;
              return visiblityFlag
                  ? GestureDetector(
                onTap: () {
                  moveToFundingCoinDetailsView(context, currencyCode);
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
                                    fontfamily: 'GoogleSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    text: currencyCode),
                                CustomSizedBox(
                                  height: 0.0075,
                                ),
                                CustomText(
                                    fontfamily: 'SourceSans',
                                    fontsize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textGrey,
                                    text: currencyName),
                                CustomSizedBox(
                                  height: 0.0125,
                                ),
                                CustomText(
                                    fontfamily: 'GoogleSans',
                                    fontsize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: textGrey,
                                    text:
                                    stringVariables.available),
                                CustomSizedBox(
                                  height: 0.0075,
                                ),
                                CustomText(
                                    fontfamily: 'SourceSans',
                                    fontsize: 14,
                                    fontWeight: FontWeight.w500,
                                    text: getTotalBalance.isvisible
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
                            CustomText(
                                fontfamily: 'GoogleSans',
                                fontsize: 16,
                                fontWeight: FontWeight.w500,
                                text: getTotalBalance.isvisible
                                    ? totalBalance +
                                    " $currencyCode"
                                    : "*****"),
                            CustomSizedBox(
                              height: 0.0075,
                            ),
                            Row(
                              children: [
                                CustomText(
                                    fontfamily:
                                    getTotalBalance.isvisible
                                        ? ''
                                        : 'SourceSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textGrey,
                                    text: getTotalBalance.isvisible
                                        ? currencySymbol
                                        : "*"),
                                CustomText(
                                    fontfamily: 'SourceSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textGrey,
                                    text: getTotalBalance.isvisible
                                        ? totalFiat
                                        : "****"),
                              ],
                            ),
                            CustomSizedBox(
                              height: 0.0125,
                            ),
                            CustomText(
                                fontfamily: 'GoogleSans',
                                fontsize: 15,
                                fontWeight: FontWeight.w500,
                                color: textGrey,
                                text: stringVariables.freeze),
                            CustomSizedBox(
                              height: 0.005,
                            ),
                            CustomText(
                                fontfamily: 'SourceSans',
                                fontsize: 14,
                                fontWeight: FontWeight.w500,
                                text: getTotalBalance.isvisible
                                    ? freezeValue
                                    : "*****"),
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
                          Divider(),
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
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: listCount,
            itemBuilder: (context, index) {
              DashBoardBalance item = list[index];
              String image = item.image ?? "";
              String currencyName = item.currencyName ?? "";
              String currencyCode = item.currencyCode ?? "";
              String totalBalance = trimDecimalsForBalance(item.usdValue.toString());
              String availableBalance = item.availableBalance.toString();
              String defaultCryptoValue = trimDecimalsForBalance(item.availableBalance.toString());
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
                      coinDetailsViewModel.setDropdownvalue(item.currencyCode.toString());
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
                                    fontfamily: 'GoogleSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    text: currencyCode),
                                CustomSizedBox(
                                  height: 0.0075,
                                ),
                                CustomText(
                                    fontfamily: 'SourceSans',
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
                            CustomText(
                                fontfamily: 'GoogleSans',
                                fontsize: 16,
                                fontWeight: FontWeight.w500,
                                text: getTotalBalance.isvisible
                                    ? "$defaultCryptoValue $currencyCode"
                                    : "*****"),
                            CustomSizedBox(
                              height: 0.0075,
                            ),
                            Row(
                              children: [
                                CustomText(
                                    fontfamily:
                                    getTotalBalance.isvisible
                                        ? ''
                                        : 'SourceSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textGrey,
                                    text: getTotalBalance.isvisible
                                        ? currencySymbol
                                        : "*"),
                                CustomText(
                                    fontfamily: 'SourceSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textGrey,
                                    text: getTotalBalance.isvisible
                                        ? totalBalance
                                        : "****"),
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
    )
        : noRecords();
  }

  Widget buildListOfStaking(Size size) {
    bool useFilteredList = getUseFilteredList();
    List<StakeData> stakeData = useFilteredList
        ? stakingBalanceViewModel.filteredUserStakeDetails
        : stakingBalanceViewModel.activeUserStakes?.stakeData ?? [];
    int listCount = stakeData.length;
    bool addMore =
        listCount != (stakingBalanceViewModel.activeUserStakes?.total ?? 0);
    int page = (stakingBalanceViewModel.activeUserStakes?.page ?? 0);
    return listCount != 0
        ? Flexible(
      fit: FlexFit.loose,
      child: stakingBalanceViewModel.needToLoad
          ? Center(child: CustomLoader())
          : ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: size.width / 50, vertical: size.width / 35),
          separatorBuilder: (context, index) => CustomSizedBox(
            height: 0.04,
          ),
          itemCount: listCount + (addMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            return addMore && index == listCount
                ? GestureDetector(
              onTap: () {
                stakingBalanceViewModel
                    .getActiveUserStakes(page);
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    fontfamily: 'GoogleSans',
                    text: stringVariables.more,
                    fontsize: 16,
                    fontWeight: FontWeight.w400,
                    color: themeColor,
                  ),
                ],
              ),
            )
                : buildListCard(size, index, stakeData[index]);
          }),
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

  bool getUseFilteredList() {
    return (stakingTransactionViewModel.selectedHoldings !=
        stringVariables.allHoldings) ||
        (stakingTransactionViewModel.sortSet1 != 2) ||
        (stakingTransactionViewModel.sortSet2 != 2 ||
            (searchCoinsViewModel.selectedCurrency != null));
  }

  Widget buildListOfDetails(Size size, StakeData stakeData) {
    List<Widget> stakeList = [];
    int stakeListCount = (stakeData.data ?? []).length;
    for (var i = 0; i < stakeListCount; i++) {
      stakeList.add(buildCardDetails(size, stakeData?.data?[i] ?? StakeItem()));
    }
    return Column(
      children: stakeList,
    );
  }

  Widget buildListCard(Size size, int index, StakeData stakeData) {
    String rewardedCurrency = (stakeData.sId ?? "");
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    int holding = (stakeData.data ?? []).length;
    String cryptoValue =
    trimDecimalsForBalance(stakeData.stakeAmount.toString());
    List<ExchangeRate> exchangeRateList = stakingBalanceViewModel
        .activeUserStakes?.exchangeRate
        ?.where((element) => element.sId == rewardedCurrency)
        .toList() ??
        [];
    num exchangeRate = exchangeRateList.first.exchangeRateByUserPreferred ?? 0;
    if (exchangeRate == 0) {
      exchangeRate = (exchangeRateList.first.usdRate ?? 0) *
          stakingBalanceViewModel.exchangeRate;
    }
    num exchangeValue = (stakeData.stakeAmount ?? 0) * exchangeRate;
    String fiatValue = trimDecimalsForBalance(exchangeValue.toString());
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    bool useFilteredList = getUseFilteredList();
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (useFilteredList) {
              stakingBalanceViewModel.setFilteredUserStackExpand(index);
            } else {
              stakingBalanceViewModel.setUserStackExpand(index);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomCircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.transparent,
                    child: FadeInImage.assetNetwork(
                      image: getImage(rewardedCurrency),
                      placeholder: splash,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: rewardedCurrency,
                          fontWeight: FontWeight.w600,
                          fontsize: 16,
                          fontfamily: 'GoogleSans'),
                      CustomSizedBox(
                        height: 0.0075,
                      ),
                      CustomText(
                          text: holding.toString() +
                              " " +
                              stringVariables.holding,
                          fontWeight: FontWeight.w400,
                          fontsize: 14,
                          color: textGrey,
                          fontfamily: 'SourceSans'),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomText(
                          text:
                          getTotalBalance.isvisible ? cryptoValue : "*****",
                          fontWeight: FontWeight.w600,
                          fontsize: 16,
                          fontfamily: 'GoogleSans'),
                      CustomSizedBox(
                        height: 0.0075,
                      ),
                      CustomText(
                          text: getTotalBalance.isvisible
                              ? currencySymbol + fiatValue
                              : "*****",
                          fontWeight: FontWeight.w400,
                          fontsize: 14,
                          color: textGrey,
                          fontfamily: 'SourceSans'),
                    ],
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  SvgPicture.asset(
                      stakeData.isExpanded ? stakingArrowUp : stakingArrowDown),
                ],
              ),
            ],
          ),
        ),
        stakeData.isExpanded
            ? Column(
          children: [
            CustomSizedBox(
              height: 0.01,
            ),
            buildListOfDetails(size, stakeData),
          ],
        )
            : CustomSizedBox(
          width: 0,
          height: 0,
        )
      ],
    );
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

  Widget buildCardDetails(Size size, StakeItem stakeItem) {
    String stakeCurrency = stakeItem.stakeCurrencyDetails?.code ?? "";
    String rewardCurrency = stakeItem.rewardCurrencyDetails?.code ?? "";
    String type = (stakeItem.isFlexible ?? false)
        ? stringVariables.flexible
        : stringVariables.locked;
    String cryptoValue =
    trimDecimalsForBalance(stakeItem.stakeAmount.toString());
    String percentage = stakeItem.aPR.toString();
    List<EarnBalance> earnBalance =
    (stakingBalanceViewModel.activeUserStakes?.earnBalance ?? [])
        .where((element) => element.sId == stakeItem.sId)
        .toList();
    String interest = earnBalance.length != 0
        ? trimDecimalsForBalance(earnBalance.first.earnBalance.toString())
        : "0.0";
    String status = getStatus(stakeItem.status ?? "");
    return Column(
      children: [
        CustomSizedBox(
          height: 0.005,
        ),
        GestureDetector(
          onTap: () {
            moveToBalance(context, stakeItem);
          },
          child: CustomContainer(
              width: 1,
              height: isSmallScreen(context) ? 6.5 : 8,
              decoration: BoxDecoration(
                color: themeSupport().isSelectedDarkMode()
                    ? switchBackground.withOpacity(0.15)
                    : enableBorder.withOpacity(0.35),
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSizedBox(
                      height: 0.0075,
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
                                text: "$stakeCurrency - $rewardCurrency",
                                fontWeight: FontWeight.w600,
                                fontsize: 14,
                                fontfamily: 'GoogleSans'),
                          ],
                        ),
                        Row(
                          children: [
                            CustomText(
                                text: status,
                                fontWeight: FontWeight.w400,
                                color:
                                status == capitalize(stringVariables.staked)
                                    ? hintLight
                                    : green,
                                fontfamily: 'GoogleSans'),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    buildTextWithColor(
                        type,
                        getTotalBalance.isvisible ? cryptoValue : "*****",
                        null),
                    buildTextWithColor(stringVariables.apr,
                        stringVariables.cumulativeInterest, hintLight, true),
                    buildTextWithColor(
                        getTotalBalance.isvisible ? percentage + "%" : "*****",
                        getTotalBalance.isvisible ? interest : "*****",
                        green),
                  ],
                ),
              )),
        ),
        CustomSizedBox(
          height: 0.01,
        )
      ],
    );
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
                    fontfamily: color == green ? "SourceSans" : 'GoogleSans'),
              ],
            ),
            Row(
              children: [
                CustomText(
                    text: content2,
                    fontWeight: FontWeight.w400,
                    fontsize: isSmall ? 13 : 15,
                    color: color,
                    fontfamily: color == green ? "SourceSans" : 'GoogleSans'),
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
        ? stakingBalanceViewModel.estimateFiatTotalStakeConverted
        : getTotalBalance.tabIndex == 3
        ? getTotalBalance.estimateFundingFiatValue
        : (getTotalBalance.estimateFiatValue +
        stakingBalanceViewModel.estimateFiatTotalStakeConverted +
        estimateCrossFiat +
        estimateIsolatedFiat +
        getTotalBalance.estimateFundingFiatValue +
        getTotalBalance.totalUsdmBalance +
        getTotalBalance.totalCoinmBalance);
    num estimateCrypto = getTotalBalance.tabIndex == 1
        ? getTotalBalance.estimateTotalValue
        : getTotalBalance.tabIndex == 2
        ? stakingBalanceViewModel.estimateTotalStakeConverted
        : getTotalBalance.tabIndex == 3
        ? getTotalBalance.estimateFundingTotalValue
        : (getTotalBalance.estimateTotalValue +
        stakingBalanceViewModel.estimateTotalStakeConverted +
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
                      fontfamily: 'GoogleSans'),
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
                  fontfamily: 'GoogleSans'),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 2),
              //   child: CustomText(
              //       text: " $crypto",
              //       fontWeight: FontWeight.bold,
              //       fontsize: 16,
              //       color: textGrey,
              //       fontfamily: 'GoogleSans'),
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
                  fontfamily: 'SourceSans'),
              CustomText(
                text: getTotalBalance.isvisible ? "$currencySymbol" : "*",
                overflow: TextOverflow.ellipsis,
                fontfamily: getTotalBalance.isvisible ? '' : 'SourceSans',
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
                  fontfamily: 'SourceSans'),
            ],
          ),
        ],
      ),
    );
  }



  Widget buildSpotSearchView(Size size) {
    result = getTotalBalance.viewModelDashBoardBalance;
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    List<DashBoardBalance> list =
    _searchResult.length != 0 || searchController.text.isNotEmpty
        ? _searchResult
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
                controller: searchController,
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
            child: searchController.text.isNotEmpty && _searchResult.isEmpty
                ? CustomText(
              text: "No Search Result Found",
              fontsize: 18,
            )
                : ListView.builder(
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
                          coinDetailsViewModel.setDropdownvalue(item.currencyCode.toString());
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        fontfamily: 'GoogleSans',
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                        text: currencyCode),
                                    CustomSizedBox(
                                      height: 0.0075,
                                    ),
                                    CustomText(
                                        fontfamily: 'SourceSans',
                                        fontsize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textGrey,
                                        text: currencyName)
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                    fontfamily: 'GoogleSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    text: getTotalBalance.isvisible
                                        ? defaultCryptoValue +
                                        " $currencyCode"
                                        : "*****"),
                                CustomSizedBox(
                                  height: 0.0075,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                        fontfamily:
                                        getTotalBalance.isvisible
                                            ? ''
                                            : 'SourceSans',
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textGrey,
                                        text: getTotalBalance.isvisible
                                            ? currencySymbol
                                            : "*"),
                                    CustomText(
                                        fontfamily: 'SourceSans',
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textGrey,
                                        text: getTotalBalance.isvisible
                                            ? totalBalance
                                            : "****"),
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
                }))
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
                    userImage
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
                fontfamily: 'GoogleSans'),
            Padding(
              padding: EdgeInsets.only(bottom: 2.5),
              child: CustomText(
                  text:
                  ' ${constant.pref?.getString("defaultFiatCurrency") ?? ''}',
                  fontWeight: FontWeight.bold,
                  fontsize: 18,
                  color: textGrey,
                  fontfamily: 'GoogleSans'),
            ),
          ],
        ),
        CustomText(
            text: stringVariables.totalPortFolio,
            fontWeight: FontWeight.bold,
            fontsize: 18,
            color: textGrey,
            strutStyleHeight: 2.5,
            fontfamily: 'GoogleSans'),
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
    List<GetUserFundingWalletDetails> list = searchFlag
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
                  text: "No Search Result Found",
                  fontsize: 18,
                ))
                : ListView.builder(
                shrinkWrap: true,
                itemCount: listCount,
                itemBuilder: (context, index) {
                  GetUserFundingWalletDetails item = list[index];
                  String image = item.currencyLogo ?? '';
                  String currencyName = getNetworkOfItem(item.currencyCode ?? '');
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
                  String totalFiat = trimDecimalsForBalance(a.toString() == "NaN" ? "0.00" : a.toString());
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
                                        fontfamily: 'GoogleSans',
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                        text: currencyCode),
                                    CustomSizedBox(
                                      height: 0.0075,
                                    ),
                                    CustomText(
                                        fontfamily: 'SourceSans',
                                        fontsize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textGrey,
                                        text: currencyName),
                                    CustomSizedBox(
                                      height: 0.0125,
                                    ),
                                    CustomText(
                                        fontfamily: 'GoogleSans',
                                        fontsize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: textGrey,
                                        text: stringVariables
                                            .available),
                                    CustomSizedBox(
                                      height: 0.0075,
                                    ),
                                    CustomText(
                                        fontfamily: 'SourceSans',
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
                                CustomText(
                                    fontfamily: 'GoogleSans',
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    text: getTotalBalance.isvisible
                                        ? "$totalBalance $currencyCode"
                                        : "*****"),
                                CustomSizedBox(
                                  height: 0.0075,
                                ),
                                Row(
                                  children: [
                                    CustomText(
                                        fontfamily:
                                        getTotalBalance.isvisible
                                            ? ''
                                            : 'SourceSans',
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textGrey,
                                        text:
                                        getTotalBalance.isvisible
                                            ? currencySymbol
                                            : "*"),
                                    CustomText(
                                        fontfamily: 'SourceSans',
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textGrey,
                                        text:
                                        getTotalBalance.isvisible
                                            ? totalFiat
                                            : "****"),
                                  ],
                                ),
                                CustomSizedBox(
                                  height: 0.0125,
                                ),
                                CustomText(
                                    fontfamily: 'GoogleSans',
                                    fontsize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: textGrey,
                                    text: stringVariables.freeze),
                                CustomSizedBox(
                                  height: 0.005,
                                ),
                                CustomText(
                                    fontfamily: 'SourceSans',
                                    fontsize: 14,
                                    fontWeight: FontWeight.w500,
                                    text: getTotalBalance.isvisible
                                        ? freezeValue
                                        : "*****"),
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
                              Divider(),
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
                }))
      ],
    );
  }

  onSearchTextChanged(
      String text,
      ) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    List<DashBoardBalance> searchResult = Result as List<DashBoardBalance>;
    _searchResult = searchResult
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
    List<GetUserFundingWalletDetails> searchResult =
    Result as List<GetUserFundingWalletDetails>;
    _fundingSearchResult = searchResult
        .where((element) =>
    element.currencyCode!.toLowerCase().contains(text.toLowerCase()) ||
        element.currencyCode!.toLowerCase().contains(text.toLowerCase()))
        .toList();

    setState(() {});
  }
}
