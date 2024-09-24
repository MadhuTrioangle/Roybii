import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/profile/view_model/p2p_profile_view_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';

class P2PProfileDetailsView extends StatefulWidget {
  const P2PProfileDetailsView({Key? key}) : super(key: key);

  @override
  State<P2PProfileDetailsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PProfileDetailsView>
    with TickerProviderStateMixin {
  late P2PProfileViewModel viewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PProfileViewModel>(context, listen: false);
/*
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
*/
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PProfileViewModel>();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PProfileDetailView(size),
      ),
    );
  }

  Widget buildP2PProfileDetailView(Size size) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSizedBox(
                height: 0.03,
              ),
              buildFirstSet(),
              buildSecondSet(),
              buildThirdSet(),
              buildFourthSet(size),
              // buildFifthSet(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstSet() {
    int d30Trades = viewModel.userCenter?.last30DayTrade ?? 0;
    double d30Completion =
        (viewModel.userCenter?.completionRate ?? 0).toDouble();
    return Column(
      children: [
        buildItemCard(
            stringVariables.d30Trades, "$d30Trades", stringVariables.times),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(stringVariables.d30CompletionRate, "$d30Completion%"),
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
    );
  }

  Widget buildSecondSet() {
    int avgRelease = (viewModel.userCenter?.avgReleaseTime ?? 0) != 60
        ? (viewModel.userCenter?.avgReleaseTime ?? 0)
        : 1;
    num avgPay = (viewModel.userCenter?.avgPaymentTime ?? 0) != 60
        ? (viewModel.userCenter?.avgPaymentTime ?? 0)
        : 1;
    return Column(
      children: [
        buildItemCard(
            stringVariables.avgReleaseTime,
            "$avgRelease",
            avgRelease != 1
                ? stringVariables.minutesWithBrackets
                : stringVariables.hoursWithBrackets),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(
            stringVariables.avgPayTime,
            "$avgPay",
            avgPay != 1
                ? stringVariables.minutesWithBrackets
                : stringVariables.hoursWithBrackets),
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
    );
  }

  Widget buildThirdSet() {
    int positiveCount = viewModel.userCenter?.positive ?? 0;
    int negativeCount = viewModel.userCenter?.negative ?? 0;
    double positivePercentage =
        (viewModel.userCenter?.positiveFeedback ?? 0).toDouble();
    return Column(
      children: [
        buildItemCard(stringVariables.positiveFeedback, "$positivePercentage%"),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(stringVariables.positive, "$positiveCount"),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(stringVariables.negative, "$negativeCount"),
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
    );
  }

  Widget buildFourthSet(Size size) {
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
        // buildItemCard(stringVariables.tradingParties, "0"),
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
          height: 0.02,
        ),
        // Divider(
        //   color: divider,thickness: 0.2,
        // ),
        // CustomSizedBox(
        //   height: 0.01,
        // ),
      ],
    );
  }

  Widget buildFifthSet(Size size) {
    return Column(
      children: [
        buildItemCard(stringVariables.approx30dVolume, "0.000000", ""),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(stringVariables.approxTotalVolume, "0.000000", ""),
        CustomSizedBox(
          height: 0.015,
        ),
        buildSingleSideCard(size, "0.000000", "0.000000"),
        CustomSizedBox(
          height: 0.03,
        ),
      ],
    );
  }

  Widget buildItemCard(String title, String time, [String? others]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          text: title,
          fontsize: 16,
          fontWeight: FontWeight.w400,
          color: hintLight,
        ),
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
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
                        fontfamily: 'InterTight',
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

  Widget buildSingleSideCard(Size size, String buy, String sell) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomSizedBox(),
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
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
              fontfamily: 'InterTight',
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
    String name = (viewModel.userCenter?.name ?? "") == " "
        ? (constant.userEmail.value.substring(0, 2) +
            "*****." +
            constant.userEmail.value.split(".").last)
        : (viewModel.userCenter?.name ?? "");
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: name,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.bold,
              fontsize: 20,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}
