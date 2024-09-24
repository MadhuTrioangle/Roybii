import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/staking/balance/model/ActiveUserStakesModel.dart';
import 'package:zodeakx_mobile/staking/balance/view/staking_auto_subscribe_dialog.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSwitch.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../model/balance_model.dart';
import '../view_model/staking_balance_view_model.dart';

class StakingBalanceView extends StatefulWidget {
  final StakeItem userStakeDetail;

  const StakingBalanceView({Key? key, required this.userStakeDetail})
      : super(key: key);

  @override
  State<StakingBalanceView> createState() => _CommonViewState();
}

class _CommonViewState extends State<StakingBalanceView>
    with TickerProviderStateMixin {
  late StakingBalanceViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<StakingBalanceViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StakeItem userStakeDetail = widget.userStakeDetail;
      viewModel.getParticluarStackDetails(userStakeDetail.sId ?? "");
      bool status = (userStakeDetail.isAutoRestake ?? false);
      viewModel.setAutoSubscribeStatus(status);
      viewModel.setLoading(true);
      viewModel.setButtonLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<StakingBalanceViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildBalanceView(size),
      ),
    );
  }

  Widget buildBalanceView(Size size) {
    StakeItem userStakeDetail = widget.userStakeDetail;
    bool isFlexible = (userStakeDetail.isFlexible ?? false);
    bool redeemStatus =
        !((userStakeDetail.status ?? "") == stringVariables.redeemed);
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(child: balanceView(size)),
              ),
              Column(
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  viewModel.buttonLoading
                      ? CustomLoader()
                      : CustomElevatedButton(
                          buttoncolor: themeColor,
                          color: black,
                          press: () async {
                            if (isFlexible && redeemStatus)
                              moveToRedemption(context, widget.userStakeDetail);
                            else {
                              String id = widget.userStakeDetail.stakeId ?? "";
                              viewModel.setButtonLoading(true);
                              viewModel.getActiveStatus(id);
                            }
                          },
                          width: 1.15,
                          isBorderedButton: true,
                          maxLines: 1,
                          icon: null,
                          multiClick: true,
                          text: (isFlexible && redeemStatus)
                              ? stringVariables.redeem
                              : stringVariables.subscribe,
                          radius: 25,
                          height: size.height / 50,
                          icons: false,
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0)),
                  CustomSizedBox(
                    height: 0.02,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget balanceView(Size size) {
    ParticularDetails particularDetails =
        viewModel.particularDetailsId!.result!.data!.first;
    String cryptoCurrency = particularDetails.stakeCurrencyDetails!.code ?? "";
    bool isFlexible = widget.userStakeDetail.isFlexible ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomCircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              child: FadeInImage.assetNetwork(
                image: getImage(cryptoCurrency),
                placeholder: splash,
              ),
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
                text: cryptoCurrency,
                fontWeight: FontWeight.w500,
                fontsize: 20,
                fontfamily: 'GoogleSans'),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        isFlexible ? buildTextSet2(size) : buildTextSet3(size),
      ],
    );
  }

  Widget buildTextSet1(Size size) {
    String cryptoCurrency = "BTC";
    String totalAmount = "448.74030762";
    String estAnnualYield = "0.9";
    String accruingInterest = "0.0075692";
    String cumulativeInterest = "0.00015074";
    String todaysSubscription = "0.0000000";
    String redeeming = "0.0000000";
    String estNextDistributionAmount = "0.00007537";
    return Column(
      children: [
        buildTextForBalance(size, stringVariables.totalAmount,
            totalAmount + " $cryptoCurrency", null, true),
        buildTextForBalance(
            size, stringVariables.estAnnualYield, estAnnualYield + "%", null),
        buildTextForBalance(
            size, stringVariables.accruingInterest, accruingInterest, green),
        buildTextForBalance(size, stringVariables.cumulativeInterest,
            cumulativeInterest, textGrey),
        buildTextForBalance(size, stringVariables.todaysSubscription,
            todaysSubscription, textGrey),
        buildTextForBalance(
            size, stringVariables.redeeming, redeeming, textGrey),
        buildTextForBalance(size, stringVariables.estNextDistributionAmount,
            estNextDistributionAmount, textGrey),
      ],
    );
  }

  Widget buildTextSet2(Size size) {
    ParticularDetails particularDetails =
        viewModel.particularDetailsId!.result!.data!.first;
    UserEarnDatum userEarnDatum =
        viewModel.particularDetailsId!.result!.userEarnData!.first;
    String cryptoCurrency = particularDetails.stakeCurrencyDetails!.code ?? "";
    String totalAmount = particularDetails.stakeAmount.toString();
    String realTimeAPR = particularDetails.apr.toString();
    String yesterdaysAPRRewards =
        trimDecimals(userEarnDatum.lastEarnAmount.toString());
    String cumulativeAPRRewards =
        trimDecimals(userEarnDatum.totalEarnAmount.toString());
    bool isFlexible = widget.userStakeDetail.isFlexible ?? false;
    return Column(
      children: [
        buildTextForBalance(size, stringVariables.totalAmount,
            totalAmount + " $cryptoCurrency", null, true),
        buildTextForBalance(
            size, stringVariables.realTimeAPR, realTimeAPR + "%", null),
        buildTextForBalance(size, stringVariables.yesterdaysAPRRewards,
            yesterdaysAPRRewards, null, false, true),
        buildTextForBalance(size, stringVariables.cumulativeAPRRewards,
            cumulativeAPRRewards, null),
        // buildTextForBalance(
        //     size, stringVariables.bonusTieredAPR, bonusTieredAPR, null),
        // buildTextForBalance(size, stringVariables.cumulativeBonusAPRRewards,
        //     cumulativeBonusAPRRewards, null),
        // buildTextForBalance(size, stringVariables.cumulativeTotalReward,
        //     cumulativeTotalReward, null),
        CustomSizedBox(
          height: 0.015,
        ),
        isFlexible
            ? CustomSizedBox(
                width: 0,
                height: 0,
              )
            : buildAutoSubcribeView(size)
      ],
    );
  }

  Widget buildTextSet3(Size size) {
    ParticularDetails particularDetails =
        viewModel.particularDetailsId!.result!.data!.first;
    UserEarnDatum userEarnDatum =
        viewModel.particularDetailsId!.result!.userEarnData!.first;
    String cryptoCurrency = particularDetails.stakeCurrencyDetails?.code ?? "";
    String totalAmount = particularDetails.stakeAmount.toString();
    String estAnnualYield = particularDetails.apr.toString();
    String subscriptionDate =
        getTimeForstake(particularDetails.stakedAt.toString());
    String lockedPeriod = particularDetails.lockedDuration.toString();
    String interestEndDate =
        getTimeForstake(particularDetails.interestEndAt.toString());
    String accrueDays = particularDetails.redemptionPeriod.toString();
    String cumulativeInterest = userEarnDatum.totalEarnAmount.toString();
    String interestDate =
        getTimeForstake(particularDetails.interestStartAt.toString());
    String redemptionDate =
        getTimeForstake(particularDetails.redemptionDate.toString());
    bool isFlexible = widget.userStakeDetail.isFlexible ?? false;
    return Column(
      children: [
        buildTextForBalance(size, stringVariables.totalAmount,
            totalAmount + " $cryptoCurrency", null, true),
        buildTextForBalance(
            size, stringVariables.estAnnualYield, estAnnualYield + "%", null),
        buildTextForBalance(size, stringVariables.subscriptionDate,
            subscriptionDate, null, false, true),
        buildTextForBalance(size, stringVariables.lockedPeriod,
            lockedPeriod + " " + stringVariables.daywiths, null),
        buildTextForBalance(
            size, stringVariables.interestEndDate, interestEndDate, null),
        buildTextForBalance(
            size, stringVariables.cumulativeInterest, cumulativeInterest, null),
        buildTextForBalance(
            size, stringVariables.interestDate, interestDate, null),
        buildTextForBalance(
            size, stringVariables.redemptionDate, redemptionDate, null),
        buildTextForBalance(size, stringVariables.redemptionPeriod,
            accrueDays + " " + stringVariables.daywiths, null),
        CustomSizedBox(
          height: 0.015,
        ),
        isFlexible
            ? CustomSizedBox(
                width: 0,
                height: 0,
              )
            : buildAutoSubcribeView(size)
      ],
    );
  }

  Widget buildAutoSubcribeView(size) {
    String startTime = "02:00";
    String endTime = "16:00";
    return CustomContainer(
        width: 1,
        height: isSmallScreen(context) ? 6 : 8,
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15)
              : enableBorder.withOpacity(0.35),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomSizedBox(
                      width: 0.04,
                    ),
                    CustomText(
                        text: stringVariables.autoSubscribe,
                        fontWeight: FontWeight.w500,
                        fontsize: 16,
                        fontfamily: 'GoogleSans'),
                  ],
                ),
                Row(
                  children: [
                    CustomSwitch(
                        activeColor: themeColor,
                        inactiveColor: switchBackground,
                        toggleColor: white,
                        width: 30,
                        toggleSize: 15,
                        padding: 3,
                        value: viewModel.autoSubscribeStatus,
                        onToggle: (value) {
                          String id = widget.userStakeDetail.sId ?? "";
                          if (!viewModel.autoSubscribeStatus) {
                            _showDialog();
                          } else {
                            viewModel.updateUserRestake(
                                id, !viewModel.autoSubscribeStatus);
                          }
                        }),
                    CustomSizedBox(
                      width: 0.04,
                    ),
                  ],
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.005,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 25),
              child: CustomText(
                  text: stringVariables.autoSubscribeContent1 +
                      startTime +
                      " " +
                      stringVariables.and +
                      " " +
                      endTime +
                      stringVariables.autoSubscribeContent2,
                  fontWeight: FontWeight.w400,
                  fontsize: 12,
                  strutStyleHeight: 1.4,
                  color: hintLight,
                  fontfamily: 'GoogleSans'),
            ),
          ],
        ));
  }

  _showDialog() async {
    StakeItem userStakeDetail = widget.userStakeDetail;
    String id = userStakeDetail.sId ?? "";
    bool status = !viewModel.autoSubscribeStatus;
    final result = await Navigator.of(context)
        .push(StakingAutoSubscribeModel(context, id, status));
  }

  Widget buildTextForBalance(
      Size size, String content1, String content2, Color? color,
      [bool isBig = false, bool isBold = false]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 2),
              child: CustomText(
                  text: content1,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                  color: textGrey,
                  fontfamily: 'GoogleSans'),
            ),
            CustomText(
                text: content2,
                fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
                fontsize: isBig ? 16 : 14,
                color: color,
                fontfamily: 'GoogleSans'),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
    );
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
          Align(
            alignment: Alignment.center,
            child: CustomText(
              overflow: TextOverflow.ellipsis,
              maxlines: 1,
              softwrap: true,
              fontfamily: 'GoogleSans',
              fontsize: 21,
              fontWeight: FontWeight.bold,
              text: stringVariables.balance,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}
