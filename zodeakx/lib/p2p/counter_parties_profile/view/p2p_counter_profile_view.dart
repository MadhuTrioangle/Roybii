import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCircleAvatar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/p2p/counter_parties_profile/view_model/p2p_counter_profile_view_model.dart';
import 'package:zodeakx_mobile/p2p/home/model/p2p_advertisement.dart';

import '../../../Common/Wallets/View/MustLoginView.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../home/view/p2p_home_view.dart';
import '../../profile/view/p2p_avg_details_dialog.dart';
import '../model/FeedbackDataModel.dart';

class P2PCounterProfileView extends StatefulWidget {
  final String userId;

  const P2PCounterProfileView({Key? key, required this.userId})
      : super(key: key);

  @override
  State<P2PCounterProfileView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PCounterProfileView>
    with TickerProviderStateMixin {
  late P2PCounterProfileViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  late TabController _tabController;
  late TabController _reviewController;
  int buyCounter = 0;
  int sellCounter = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PCounterProfileViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    constant.userLoginStatus.value
        ? viewModel.findUserCenter(widget.userId)
        : () {};
    _tabController = TabController(length: 3, vsync: this);
    _reviewController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        viewModel.setTabIndex(_tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.setTabIndex(0);
      viewModel.setAdsLoading(true);
      viewModel.setFeedbackLoading(true);
    });
  }

  String getImage(String crypto) {
    List<dynamic> list = [];
    list = constant.userLoginStatus.value
        ? (walletViewModel.viewModelDashBoardBalance != null)
            ? (walletViewModel.viewModelDashBoardBalance!.isNotEmpty)
                ? walletViewModel.viewModelDashBoardBalance!
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

  _showAvgDetailsDialog() async {
    final result =
        await Navigator.of(context).push(P2PAvgDetailsModel(context));
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PCounterProfileViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
          appBar: AppHeader(size),
          child: constant.userLoginStatus.value == false
              ? MustLoginView()
              : viewModel.needToLoad
                  ? Center(child: CustomLoader())
                  : buildP2PProfileView(size)),
    );
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
    return AppBar(
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
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 35, right: 15),
                    child: SvgPicture.asset(
                      backArrow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildP2PProfileView(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: Column(
        children: [
          buildProfileCard(size),
          CustomSizedBox(
            height: 0.015,
          ),
          buildDetailsCard(size),
        ],
      ),
    );
  }

  Widget buildDetailsCard(Size size) {
    int ads = (viewModel.sellAdvertisement?.total ?? 0) +
        (viewModel.buyAdvertisement?.total ?? 0);
    int feedback = (viewModel.userCenter?.negative ?? 0) +
        (viewModel.userCenter?.positive ?? 0);
    return Flexible(
      fit: FlexFit.loose,
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSizedBox(
                  height: 0.02,
                ),
                buildTabBar(size, ads, feedback),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomContainer(
                    width: 1, height: isSmallScreen(context) ? 2 : 2.2, child: buildTabBarView(size)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildTabBarView(Size size) {
    return TabBarView(
      controller: _tabController,
      children: [
        buildInfoItems(size),
        viewModel.adsTabLoader ? CustomLoader() : buildAdsItems(size),
        viewModel.feedbackLoader ? CustomLoader() : buildFeedbackItems(size),
      ],
    );
  }

  Widget buildInfoItems(Size size) {
    int avgRelease = (viewModel.userCenter?.avgReleaseTime ?? 0) != 60
        ? (viewModel.userCenter?.avgReleaseTime ?? 0)
        : 1;
    num avgPay = (viewModel.userCenter?.avgPaymentTime ?? 0) != 60
        ? (viewModel.userCenter?.avgPaymentTime ?? 0)
        : 1;
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTradesHistoryCard(size),
          CustomSizedBox(
            height: 0.02,
          ),
          buildAvgView(
              size,
              stringVariables.avgReleaseTime,
              "$avgRelease",
              avgRelease != 1
                  ? stringVariables.minutesWithBrackets
                  : stringVariables.hoursWithBrackets),
          CustomSizedBox(
            height: 0.02,
          ),
          buildAvgView(
              size,
              stringVariables.avgPayTime,
              "$avgPay",
              avgPay != 1
                  ? stringVariables.minutesWithBrackets
                  : stringVariables.hoursWithBrackets),
          CustomSizedBox(
            height: 0.01,
          ),
          Divider(),
          CustomSizedBox(
            height: 0.01,
          ),
          buildReviewSet(size),
          buildTradeSet(size),
          CustomSizedBox(
            height: 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CustomText(
                    fontfamily: 'GoogleSans',
                    text:
                        "${constant.appName} ${stringVariables.riskManagement}",
                    fontsize: 14,
                    fontWeight: FontWeight.w400,
                    color: hintLight,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomContainer(
                    width: 1.15,
                    child: CustomText(
                      align: TextAlign.center,
                      fontfamily: 'GoogleSans',
                      text: stringVariables.riskManagementContent,
                      fontsize: 14,
                      fontWeight: FontWeight.w400,
                      color: hintLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.005,
          ),
        ],
      ),
    );
  }

  Widget moreWidget(int type) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          press: () {
            if (type == 0) {
              buyCounter++;
              viewModel.fetchUserBuyAdvertisement(widget.userId, buyCounter);
            } else {
              sellCounter++;
              viewModel.fetchUserSellAdvertisement(widget.userId, sellCounter);
            }
          },
          fontfamily: 'GoogleSans',
          text: stringVariables.more,
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: themeColor,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildAdsItems(Size size) {
    List<Widget> buyList = [];
    int buyListCount = (viewModel.buyAdvertisement?.data ?? []).length;
    List<Widget> sellList = [];
    int sellListCount = (viewModel.sellAdvertisement?.data ?? []).length;
    for (var i = 0; i < buyListCount; i++) {
      buyList.add(buildListCard(
        size,
        true,
        viewModel.buyAdvertisement?.data?[i] ?? dummyAdvertisement,
      ));
    }
    for (var i = 0; i < sellListCount; i++) {
      sellList.add(buildListCard(
        size,
        false,
        viewModel.sellAdvertisement?.data?[i] ?? dummyAdvertisement,
      ));
    }
    if (buyListCount != (viewModel.buyAdvertisement?.total ?? 0)) {
      buyList.add(moreWidget(0));
    }
    if (sellListCount != (viewModel.sellAdvertisement?.total ?? 0)) {
      sellList.add(moreWidget(1));
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              height: 0.005,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.onlineBuyAds,
              fontsize: 16,
              fontWeight: FontWeight.bold,
              color: hintLight,
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            buyListCount != 0
                ? Column(
                    children: buyList,
                  )
                : buildNoAdsView(),
            Divider(),
            CustomSizedBox(
              height: 0.01,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.onlineSellAds,
              fontsize: 16,
              fontWeight: FontWeight.bold,
              color: hintLight,
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            sellListCount != 0
                ? Column(
                    children: sellList,
                  )
                : buildNoAdsView(),
          ],
        ),
      ),
    );
  }

  Widget buildNoAdsView() {
    return CustomContainer(
      width: 1,
      height: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            p2pNoAds,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            text: stringVariables.noAds,
            fontsize: 18,
            fontWeight: FontWeight.w400,
            color: hintLight,
          ),
        ],
      ),
    );
  }

  Widget buildFeedbackItems(Size size) {
    int positiveCount = viewModel.userCenter?.positive ?? 0;
    int negativeCount = viewModel.userCenter?.negative ?? 0;
    double positivePercentage =
        (viewModel.userCenter?.positiveFeedback ?? 0).toDouble();
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.005,
        ),
        buildFeedbackRatingCard(
            size, "$positivePercentage", "${positiveCount + negativeCount}"),
        CustomSizedBox(
          height: 0.02,
        ),
        buildReviewTabBar(size, positiveCount, negativeCount),
        CustomSizedBox(
          height: 0.02,
        ),
        buildReviewTabBarView(size)
      ],
    ));
  }

  Widget buildReviewTabBarView(Size size) {
    List<Feedbacks>? allFeedbacks = viewModel.feedbackData?.data;
    int allCount = (allFeedbacks ?? []).length;
    List<Feedbacks>? positiveFeedbacks = viewModel.positiveFeedbacks;
    int positiveCount = (positiveFeedbacks ?? []).length;
    List<Feedbacks>? negativeFeedbacks = viewModel.negativeFeedbacks;
    int negativeCount = (negativeFeedbacks ?? []).length;
    return CustomContainer(
      height: 3.25,
      child: TabBarView(controller: _reviewController, children: [
        allCount != 0
            ? ListView.builder(
                itemCount: allCount,
                itemBuilder: (BuildContext context, int index) {
                  return buildReviewCard(size, allFeedbacks![index]);
                })
            : noRecords(),
        positiveCount != 0
            ? ListView.builder(
                itemCount: positiveCount,
                itemBuilder: (BuildContext context, int index) {
                  return buildReviewCard(size, positiveFeedbacks![index]);
                })
            : noRecords(),
        negativeCount != 0
            ? ListView.builder(
                itemCount: negativeCount,
                itemBuilder: (BuildContext context, int index) {
                  return buildReviewCard(size, negativeFeedbacks![index]);
                })
            : noRecords(),
      ]),
    );
  }

  noRecords() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: stringVariables.notFound,
          fontsize: 15,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget buildReviewCard(Size size, Feedbacks feedbacks) {
    String name = feedbacks.name ?? "";
    bool isPostive =
        feedbacks.feedbackType == stringVariables.positive.toLowerCase();
    String modifiedDate = getDateTimeStamp((feedbacks.modifiedDate ??
            DateTime.parse("2023-02-21T14:08:25.811Z").toString())
        .toString());
    String feedback = feedbacks.feedback ?? "";
    return Column(
      children: [
        CustomContainer(
          decoration: BoxDecoration(
              color:
                  themeSupport().isSelectedDarkMode() ? switchBackground.withOpacity(0.15) : grey,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: themeSupport().isSelectedDarkMode()
                      ? grey
                      : switchBackground)),
          height: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomContainer(
                    width: 12.5,
                    height: 12.5,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: themeColor),
                    child: Center(
                        child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: name.isNotEmpty ? name[0].toUpperCase() : " ",
                      fontWeight: FontWeight.bold,
                      fontsize: 11,
                      color: black,
                    )),
                  ),
                  CustomSizedBox(
                    width: 0.025,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        constraints:
                            BoxConstraints(maxWidth: size.width / 1.75),
                        child: CustomText(
                          fontfamily: 'GoogleSans',
                          text: name,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 15,
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            fontfamily: 'GoogleSans',
                            text: modifiedDate,
                            fontsize: 12,
                            fontWeight: FontWeight.w500,
                            color: hintLight,
                          ),
                          CustomSizedBox(
                            width: 0.015,
                          ),
                          CustomContainer(
                            width: size.width / 1.5,
                            height: 65,
                            color: hintLight,
                          ),
                          CustomSizedBox(
                            width: 0.015,
                          ),
                          CustomContainer(
                            constraints:
                                BoxConstraints(maxWidth: size.width / 2.5),
                            child: CustomText(
                              overflow: TextOverflow.ellipsis,
                              fontfamily: 'GoogleSans',
                              text: feedback,
                              fontsize: 12,
                              fontWeight: FontWeight.w500,
                              color: hintLight,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCard(
                    outerPadding: 0,
                    edgeInsets: 12.5,
                    radius: 25,
                    elevation: 2.5,
                    child: SvgPicture.asset(
                      isPostive ? p2pThumbPositive : p2pThumbNegative,
                      height: 15,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        )
      ],
    );
  }

  Widget buildReviewTabBar(Size size, int positiveCount, int negativeCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 100),
      child: ButtonsTabBar(
        height: size.height / 21,
        controller: _reviewController,
        backgroundColor: themeColor.withOpacity(0.25),
        contentPadding: EdgeInsets.symmetric(horizontal: size.width / 21),
        unselectedBackgroundColor: grey,
        splashColor: Colors.transparent,
        unselectedLabelStyle: TextStyle(
            fontSize: 12,
            color: hintLight,
            fontFamily: 'GoogleSans',
            fontWeight: FontWeight.w400),
        labelStyle: TextStyle(
            fontSize: 12,
            color: themeColor,
            fontFamily: 'GoogleSans',
            fontWeight: FontWeight.w400),
        tabs: [
          Tab(
            text: stringVariables.all,
          ),
          Tab(
            text: stringVariables.positive + "($positiveCount)",
          ),
          Tab(
            text: stringVariables.negative + "($negativeCount)",
          ),
        ],
      ),
    );
  }

  Widget buildFeedbackRatingCard(Size size, String percentage, String reviews) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 50),
      child: CustomContainer(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: themeSupport().isSelectedDarkMode()
                      ? grey
                      : switchBackground)),
          width: 1,
          height: isSmallScreen(context) ? 10 : 11.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                p2pThumbPositive,
                height: 22,
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                text: trimDecimals(percentage) + "%",
                fontsize: 16,
                fontWeight: FontWeight.w500,
                color: hintLight,
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              CustomContainer(
                width: size.width / 1.5,
                height: 40,
                color: hintLight,
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                text: reviews + " ${stringVariables.reviewWithBrackets}",
                fontsize: 16,
                fontWeight: FontWeight.w500,
                color: hintLight,
              ),
            ],
          )),
    );
  }

  buildListCard(
    Size size,
    bool isBuy,
    Advertisement advertisement,
  ) {
    double fiatAmount = advertisement.price!.toDouble();
    String adType = capitalize(advertisement.advertisementType ?? "buy");
    String fiatCurrency = adType == stringVariables.buy
        ? advertisement.fromAsset!
        : advertisement.toAsset!;
    double cryptoAmount = advertisement.amount!.toDouble();
    String cryptoCurrency = adType == stringVariables.buy
        ? advertisement.toAsset!
        : advertisement.fromAsset!;
    double minAmount = advertisement.minTradeOrder!.toDouble();
    double maxAmount = advertisement.maxTradeOrder!.toDouble();
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
    return Column(
      children: [
        CustomContainer(
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
          height: isSmallScreen(context) ? 4.1 : 4.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomCircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.transparent,
                    child: FadeInImage.assetNetwork(
                      image: getImage(cryptoCurrency),
                      placeholder: splash,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomContainer(
                    constraints: BoxConstraints(maxWidth: size.width / 3),
                    child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: cryptoCurrency,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 15,
                    ),
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.015,
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
                        fontfamily: 'GoogleSans',
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
                        fontfamily: 'GoogleSans',
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
                            fontfamily: 'GoogleSans',
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
                height: 0.015,
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
                            fontfamily: 'GoogleSans',
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
                            constraints:
                                BoxConstraints(maxWidth: size.width / 3.5),
                            child: CustomText(
                              fontfamily: 'GoogleSans',
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
                            fontfamily: 'GoogleSans',
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
                                  fontfamily: 'GoogleSans',
                                  text: " $minAmount",
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  fontsize: 13,
                                ),
                              ),
                              CustomText(
                                fontfamily: "GoogleSans",
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
                                  fontfamily: 'GoogleSans',
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
                          moveToOrderCreation(context, isBuy, advertisement, 0);
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
                              fontfamily: 'GoogleSans',
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
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildTradeSet(Size size) {
    int register = viewModel.userCenter?.registered ?? 0;
    int firstTrade = viewModel.userCenter?.firstTrade ?? 0;
    int allTrade = (viewModel.userCenter?.buyOrder ?? 0) +
        (viewModel.userCenter?.sellOrder ?? 0);
    int buyTrade = (viewModel.userCenter?.buyOrder ?? 0);
    int sellTrade = (viewModel.userCenter?.sellOrder ?? 0);
    return Column(
      children: [
        buildItemCard(
            stringVariables.registered, "$register", stringVariables.daysAgo),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(
            stringVariables.firstTrade, "$firstTrade", stringVariables.daysAgo),
        CustomSizedBox(
          height: 0.02,
        ),
        // buildItemCard(stringVariables.tradingParties, "7885"),
        // CustomSizedBox(
        //   height: 0.02,
        // ),
        buildItemCard(stringVariables.allTrades, "$allTrade",
            stringVariables.timesWithBrackets),
        CustomSizedBox(
          height: 0.015,
        ),
        buildSingleSideCard(size, "$buyTrade", "$sellTrade"),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildReviewSet(Size size) {
    double positivePercentage =
        double.parse(trimDecimals((viewModel.userCenter?.positiveFeedback ?? 0).toString()));
    int positive = viewModel.userCenter?.positive ?? 0;
    int negative = viewModel.userCenter?.negative ?? 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 50),
      child: Column(
        children: [
          buildItemCard(
              stringVariables.positiveFeedback, "$positivePercentage%"),
          CustomSizedBox(
            height: 0.02,
          ),
          buildItemCard(stringVariables.positive, "$positive"),
          CustomSizedBox(
            height: 0.02,
          ),
          buildItemCard(stringVariables.negative, "$negative"),
          CustomSizedBox(
            height: 0.01,
          ),
          Divider(),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildSingleSideCard(Size size, String buy, String sell) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomSizedBox(),
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.buy + " $buy",
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.015,
            ),
            CustomContainer(
              width: size.width * 2,
              height: 50,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.015,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.sell + " $sell",
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
          ],
        )
      ],
    );
  }

  Widget buildItemCard(String title, String time, [String? others]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: title,
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: hintLight,
        ),
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: time,
              fontsize: 16,
              fontWeight: FontWeight.w600,
            ),
            others != null
                ? Row(
                    children: [
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: others,
                        fontsize: 16,
                        fontWeight: FontWeight.w400,
                        color: hintLight,
                      ),
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  ),
          ],
        )
      ],
    );
  }

  Widget buildTradesHistoryCard(Size size) {
    int d30Trades = viewModel.userCenter?.last30DayTrade ?? 0;
    double d30Completion =
        (viewModel.userCenter?.completionRate ?? 0).toDouble();
    return CustomCard(
      outerPadding: 0,
      edgeInsets: 0,
      radius: 25,
      elevation: 0,
      color: themeSupport().isSelectedDarkMode() ? null : grey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.width / 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTradeHistoryCard("$d30Trades", stringVariables.d30Trades),
            buildTradeHistoryCard(
                "$d30Completion%", stringVariables.d30CompletionRate),
          ],
        ),
      ),
    );
  }

  Widget buildTradeHistoryCard(String value, String title) {
    return Column(
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: value,
          fontsize: 23,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: title,
          fontsize: 15,
          fontWeight: FontWeight.w400,
          color: hintLight,
        ),
      ],
    );
  }

  Widget buildAvgView(
    Size size,
    String title,
    String time,
    String duration,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            press: _showAvgDetailsDialog,
            fontfamily: 'GoogleSans',
            text: title,
            fontsize: 16,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dashed,
            color: hintLight,
          ),
          Row(
            children: [
              CustomText(
                fontfamily: 'GoogleSans',
                text: time,
                fontsize: 16,
                fontWeight: FontWeight.w600,
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                text: duration,
                fontsize: 16,
                fontWeight: FontWeight.w400,
                color: hintLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileCard(Size size) {
    String email = viewModel.userCenter?.name ?? "";
    String verified = viewModel.userCenter?.emailStatus == "verified" &&
            viewModel.userCenter?.kycStatus == "verified"
        ? stringVariables.verifiedUser
        : stringVariables.regularUser;
    return CustomContainer(
      width: 1,
      height: 4.75,
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomCircleAvatar(
                        radius: 18,
                        backgroundColor:
                            themeSupport().isSelectedDarkMode() ? white : black,
                        child: CustomText(
                          fontfamily: 'GoogleSans',
                          text: email[0].toUpperCase(),
                          fontWeight: FontWeight.bold,
                          fontsize: 16,
                          color: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.025,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: email,
                        fontsize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                children: [
                  CustomCircleAvatar(
                    radius: 18,
                    backgroundColor:
                        themeSupport().isSelectedDarkMode() ? card_dark : white,
                    child: CustomSizedBox(),
                  ),
                  CustomSizedBox(
                    width: 0.025,
                  ),
                  Row(
                    children: [
                      verified == stringVariables.verifiedUser
                          ? Row(
                              children: [
                                SvgPicture.asset(
                                  p2pVerified,
                                  height: 16.5,
                                ),
                                CustomSizedBox(
                                  width: 0.015,
                                ),
                              ],
                            )
                          : CustomSizedBox(
                              width: 0,
                              height: 0,
                            ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: verified,
                        fontsize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCircleAvatar(
                    radius: 18,
                    backgroundColor:
                        themeSupport().isSelectedDarkMode() ? card_dark : white,
                    child: CustomSizedBox(),
                  ),
                  CustomSizedBox(
                    width: 0.025,
                  ),
                  Row(
                    children: [
                      buildVerificationView(stringVariables.email,
                          viewModel.userCenter?.emailStatus == "verified"),
                      CustomSizedBox(
                        width: 0.05,
                      ),
                      buildVerificationView(stringVariables.kyc,
                          viewModel.userCenter?.kycStatus == "verified"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabBar(Size size, int ads, int feedback) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 60),
      child: CustomContainer(
        padding: 4.5,
        height: 16,
        decoration: BoxDecoration(
          color: grey,
          borderRadius: BorderRadius.circular(
            50.0,
          ),
        ),
        child: TabBar(
          labelPadding: EdgeInsets.zero,
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              50.0,
            ),
            color: themeColor,
          ),
          labelStyle: TextStyle(
              fontFamily: 'GoogleSans',
              fontWeight: FontWeight.w600,
              fontSize: 14),
          labelColor: themeSupport().isSelectedDarkMode() ? black : white,
          unselectedLabelColor: hintLight,
          tabs: [
            Tab(
              text: stringVariables.info,
            ),
            Tab(
              text: stringVariables.ads + "($ads)",
            ),
            Tab(
              text: stringVariables.feedback + "($feedback)",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerificationView(String title, bool verified) {
    return Row(
      children: [
        SvgPicture.asset(
          verified ? p2pUserVerified : p2pUserUnverified,
        ),
        CustomSizedBox(
          width: 0.01,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: title,
          fontsize: 14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

const double _kTabHeight = 46.0;

class ButtonsTabBar extends StatefulWidget implements PreferredSizeWidget {
  ButtonsTabBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.duration = 250,
    this.backgroundColor,
    this.unselectedBackgroundColor,
    this.decoration,
    this.unselectedDecoration,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.splashColor,
    this.borderWidth = 0,
    this.borderColor = Colors.black,
    this.unselectedBorderColor = Colors.black,
    this.physics = const BouncingScrollPhysics(),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 4),
    this.buttonMargin = const EdgeInsets.all(4),
    this.labelSpacing = 4.0,
    this.radius = 7.0,
    this.elevation = 0,
    this.height = _kTabHeight,
    this.center = false,
    this.onTap,
  }) : super(key: key) {
    assert(backgroundColor == null || decoration == null);
    assert(unselectedBackgroundColor == null || unselectedDecoration == null);
  }

  /// Typically a list of two or more [Tab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length]
  /// and the length of the [TabBarView.children] list.
  final List<Widget> tabs;

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController? controller;

  /// The duration in milliseconds of the transition animation.
  final int duration;

  /// The background [Color] of the button on its selected state.
  ///
  /// If [Color] is not provided, [Theme.of(context).accentColor] is used.
  final Color? backgroundColor;

  /// The background [Color] of the button on its unselected state.
  ///
  /// If [Color] is not provided, [Colors.grey[300]] is used.
  final Color? unselectedBackgroundColor;

  /// The splash [Color] of the button.
  ///
  /// If [Color] is not provided, the default is used.
  final Color? splashColor;

  /// The [BoxDecoration] of the button on its selected state.
  ///
  /// If [BoxDecoration] is not provided, [backgroundColor] is used.
  final BoxDecoration? decoration;

  /// The [BoxDecoration] of the button on its unselected state.
  ///
  /// If [BoxDecoration] is not provided, [unselectedBackgroundColor] is used.
  final BoxDecoration? unselectedDecoration;

  /// The [TextStyle] of the button's [Text] on its selected state. The color provided
  /// on the TextStyle will be used for the [Icon]'s color.
  ///
  /// The default value is: [TextStyle(color: Colors.white)].
  final TextStyle? labelStyle;

  /// The [TextStyle] of the button's [Text] on its unselected state. The color provided
  /// on the TextStyle will be used for the [Icon]'s color.
  ///
  /// The default value is: [TextStyle(color: Colors.black)].
  final TextStyle? unselectedLabelStyle;

  /// The with of solid [Border] for each button. If no value is provided, the border
  /// is not drawn.
  ///
  /// The default value is: 0.
  final double borderWidth;

  /// The [Color] of solid [Border] for each button.
  ///
  /// The default value is: [Colors.black].
  final Color borderColor;

  /// The [Color] of solid [Border] for each button. If no value is provided, the value of
  /// [this.borderColor] is used.
  ///
  /// The default value is: [Colors.black].
  final Color unselectedBorderColor;

  /// The physics used for the [ScrollController] of the tabs list.
  ///
  /// The default value is [BouncingScrollPhysics].
  final ScrollPhysics physics;

  /// The [EdgeInsets] used for the [Padding] of the buttons' content.
  ///
  /// The default value is [EdgeInsets.symmetric(horizontal: 4)].
  final EdgeInsets contentPadding;

  /// The [EdgeInsets] used for the [Margin] of the buttons.
  ///
  /// The default value is [EdgeInsets.all(4)].
  final EdgeInsets buttonMargin;

  /// The spacing between the [Icon] and the [Text]. If only one of those is provided,
  /// no spacing is applied.
  final double labelSpacing;

  /// The value of the [BorderRadius.circular] applied to each button.
  final double radius;

  /// The value of the [elevation] applied to each button.
  final double elevation;

  /// Override the default height.
  ///
  /// If no value is provided, the material height, 46.0, is used. If height is [null],
  /// the height is computed by summing the material height, 46, and the vertical values
  /// for [contentPadding] and [buttonMargin].
  final double? height;

  /// Center the tab buttons
  final bool center;

  /// An optional callback that's called when the [TabBar] is tapped.
  ///
  /// The callback is applied to the index of the tab where the tap occurred.
  ///
  /// This callback has no effect on the default handling of taps. It's for
  /// applications that want to do a little extra work when a tab is tapped,
  /// even if the tap doesn't change the [TabController]'s index. [TabBar] onTap
  /// callbacks should not make changes to the [TabController] since that would
  /// interfere with the default tap handler.
  final void Function(int)? onTap;

  @override
  Size get preferredSize {
    return Size.fromHeight(height ??
        (_kTabHeight + contentPadding.vertical + buttonMargin.vertical));
  }

  @override
  _ButtonsTabBarState createState() => _ButtonsTabBarState();
}

class _ButtonsTabBarState extends State<ButtonsTabBar>
    with TickerProviderStateMixin {
  TabController? _controller;

  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;

  late List<GlobalKey> _tabKeys;
  final GlobalKey _tabsContainerKey = GlobalKey();
  final GlobalKey _tabsParentKey = GlobalKey();

  int _currentIndex = 0;
  int _prevIndex = -1;
  int _aniIndex = 0;
  double _prevAniValue = 0;

  // check the direction of the text LTR or RTL
  late bool _textLTR;

  EdgeInsets _centerPadding = EdgeInsets.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _getCenterPadding(context));

    _tabKeys = widget.tabs.map((Widget tab) => GlobalKey()).toList();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));

    // so the buttons start in their "final" state (color)
    _animationController.value = 1.0;
    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _updateTabController() {
    final TabController? newController =
        widget.controller ?? DefaultTabController.of(context);
    assert(() {
      if (newController == null) {
        throw FlutterError('No TabController for ${widget.runtimeType}.\n'
            'When creating a ${widget.runtimeType}, you must either provide an explicit '
            'TabController using the "controller" property, or you must ensure that there '
            'is a DefaultTabController above the ${widget.runtimeType}.\n'
            'In this case, there was neither an explicit controller nor a default controller.');
      }
      return true;
    }());

    if (newController == _controller) return;

    if (_controllerIsValid) {
      _controller?.animation!.removeListener(_handleTabAnimation);
      _controller?.removeListener(_handleController);
    }
    _controller = newController;
    _controller?.animation!.addListener(_handleTabAnimation);
    _controller?.addListener(_handleController);
    _currentIndex = _controller!.index;
  }

  // If the TabBar is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
  }

  @override
  void didUpdateWidget(ButtonsTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
    }

    if (widget.tabs.length > oldWidget.tabs.length) {
      final int delta = widget.tabs.length - oldWidget.tabs.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
    } else if (widget.tabs.length < oldWidget.tabs.length) {
      _tabKeys.removeRange(widget.tabs.length, oldWidget.tabs.length);
    }
  }

  void _handleController() {
    if (_controller!.indexIsChanging) {
      // update highlighted index when controller index is changing
      _goToIndex(_controller!.index);
    }
  }

  @override
  void dispose() {
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabAnimation);
      _controller!.removeListener(_handleController);
    }
    _controller = null;
    _scrollController.dispose();
    super.dispose();
  }

  _getCenterPadding(BuildContext context) {
    // get the screen width. This is used to check if we have an element off screen
    final RenderBox tabsParent =
        _tabsParentKey.currentContext!.findRenderObject() as RenderBox;
    final double screenWidth = tabsParent.size.width;

    RenderBox renderBox =
        _tabKeys.first.currentContext?.findRenderObject() as RenderBox;
    double size = renderBox.size.width;
    final double left = (screenWidth - size) / 2;

    renderBox = _tabKeys.last.currentContext?.findRenderObject() as RenderBox;
    size = renderBox.size.width;
    final double right = (screenWidth - size) / 2;
    _centerPadding = EdgeInsets.only(left: left, right: right);
  }

  Widget _buildButton(
    int index,
    Tab tab,
  ) {
    final double animationValue;
    if (index == _currentIndex) {
      animationValue = _animationController.value;
    } else if (index == _prevIndex) {
      animationValue = 1 - _animationController.value;
    } else {
      animationValue = 0;
    }

    final TextStyle? textStyle = TextStyle.lerp(
        widget.unselectedLabelStyle ?? const TextStyle(color: Colors.black),
        widget.labelStyle ?? const TextStyle(color: Colors.white),
        animationValue);
    final Color? borderColor = Color.lerp(
        widget.unselectedBorderColor, widget.borderColor, animationValue);
    final Color foregroundColor = textStyle?.color ?? Colors.black;

    final BoxDecoration? boxDecoration = BoxDecoration.lerp(
        BoxDecoration(
          color: widget.unselectedDecoration?.color ??
              widget.unselectedBackgroundColor ??
              Colors.grey[300],
          boxShadow: widget.unselectedDecoration?.boxShadow,
          gradient: widget.unselectedDecoration?.gradient,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        BoxDecoration(
          color: widget.decoration?.color ??
              widget.backgroundColor ??
              Theme.of(context).colorScheme.secondary,
          boxShadow: widget.decoration?.boxShadow,
          gradient: widget.decoration?.gradient,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        animationValue);

    if (index == 0) {
      //
    } else if (index == widget.tabs.length - 1) {
      //
    }

    return Padding(
      key: _tabKeys[index],
      // padding for the buttons
      padding: widget.buttonMargin,
      child: TextButton(
        onPressed: () {
          _controller?.animateTo(index);
          if (widget.onTap != null) widget.onTap!(index);
        },
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(widget.elevation),
            minimumSize: MaterialStateProperty.all(const Size(40, 40)),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            textStyle: MaterialStateProperty.all(textStyle),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: (widget.borderWidth == 0)
                    ? BorderSide.none
                    : BorderSide(
                        color: borderColor ?? Colors.black,
                        width: widget.borderWidth,
                        style: BorderStyle.solid,
                      ),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
            ),
            overlayColor: MaterialStateProperty.all(widget.splashColor)),
        child: Ink(
          decoration: boxDecoration,
          child: Container(
            padding: widget.contentPadding,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                tab.icon != null
                    ? IconTheme.merge(
                        data: IconThemeData(size: 24.0, color: foregroundColor),
                        child: tab.icon!)
                    : Container(),
                SizedBox(
                  width: tab.icon == null ||
                          (tab.text == null && tab.child == null)
                      ? 0
                      : widget.labelSpacing,
                ),
                tab.text != null
                    ? Text(
                        tab.text!,
                        style: textStyle,
                      )
                    : (tab.child ?? Container())
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (_controller!.length != widget.tabs.length) {
        throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.");
      }
      return true;
    }());
    if (_controller!.length == 0) return Container(height: widget.height);

    _textLTR = Directionality.of(context).index == 1;
    return Opacity(
      // avoid showing the tabBar if centering was request and the centerPadding wasn't calculated yet
      opacity: (!widget.center || _centerPadding != EdgeInsets.zero) ? 1 : 0,
      child: AnimatedBuilder(
        animation: _animationController,
        key: _tabsParentKey,
        builder: (context, child) => SizedBox(
          key: _tabsContainerKey,
          height: widget.preferredSize.height,
          child: SingleChildScrollView(
            physics: widget.physics,
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: widget.center ? _centerPadding : EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.tabs.length,
                (int index) => _buildButton(index, widget.tabs[index] as Tab),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // runs during the switching tabs animation
  _handleTabAnimation() {
    _aniIndex = ((_controller!.animation!.value > _prevAniValue)
            ? _controller!.animation!.value
            : _prevAniValue)
        .round();
    if (!_controller!.indexIsChanging && _aniIndex != _currentIndex) {
      _setCurrentIndex(_aniIndex);
    }
    _prevAniValue = _controller!.animation!.value;
  }

  _goToIndex(int index) {
    if (index != _currentIndex) {
      _setCurrentIndex(index);
      _controller?.animateTo(index);
    }
  }

  _setCurrentIndex(int index) {
    // change the index
    setState(() {
      _prevIndex = _currentIndex;
      _currentIndex = index;
    });
    _scrollTo(index); // scroll TabBar if needed
    _triggerAnimation();
  }

  _triggerAnimation() {
    // reset the animation so it's ready to go
    _animationController.reset();

    // run the animation!
    _animationController.forward();
  }

  _scrollTo(int index) {
    // get the screen width. This is used to check if we have an element off screen
    final RenderBox tabsContainer =
        _tabsContainerKey.currentContext!.findRenderObject() as RenderBox;
    double screenWidth = tabsContainer.size.width;
    final tabsContainerPosition = tabsContainer.localToGlobal(Offset.zero).dx;
    // get the TabsContainer offset (for cases when padding is used)
    final tabsContainerOffset = Offset(-tabsContainerPosition, 0);

    // get the button we want to scroll to
    RenderBox renderBox =
        _tabKeys[index].currentContext?.findRenderObject() as RenderBox;
    // get its size
    double size = renderBox.size.width;
    // and position
    double position = renderBox.localToGlobal(tabsContainerOffset).dx;

    // this is how much the button is away from the center of the screen and how much we must scroll to get it into place
    double offset = (position + size / 2) - screenWidth / 2;

    // if the button is to the left of the middle
    if (offset < 0) {
      // get the first button
      renderBox = (_textLTR ? _tabKeys.first : _tabKeys.last)
          .currentContext
          ?.findRenderObject() as RenderBox;
      //// get the position of the first button of the TabBar
      position = renderBox.localToGlobal(tabsContainerOffset).dx;

      // if the offset pulls the first button away from the left side, we limit that movement so the first button is stuck to the left side
      if (!widget.center && position > offset) offset = position;
    } else {
      // if the button is to the right of the middle

      // get the last button
      renderBox = (_textLTR ? _tabKeys.last : _tabKeys.first)
          .currentContext
          ?.findRenderObject() as RenderBox;
      // get its position
      position = renderBox.localToGlobal(tabsContainerOffset).dx;
      // and size
      size = renderBox.size.width;

      // if the last button doesn't reach the right side, use it's right side as the limit of the screen for the TabBar
      if (position + size < screenWidth) screenWidth = position + size;

      // if the offset pulls the last button away from the right side limit, we reduce that movement so the last button is stuck to the right side limit
      if (!widget.center && position + size - offset < screenWidth) {
        offset = position + size - screenWidth;
      }
    }
    offset *= (_textLTR ? 1 : -1);

    // scroll the calculated ammount
    _scrollController.animateTo(offset + _scrollController.offset,
        duration: Duration(milliseconds: widget.duration),
        curve: Curves.easeInOut);
  }
}
