import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCircleAvatar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/profile/view/p2p_add_home_bottom_sheet.dart';
import 'package:zodeakx_mobile/p2p/profile/view/p2p_avg_details_dialog.dart';
import 'package:zodeakx_mobile/p2p/profile/view/p2p_edit_profile_dialog.dart';

import '../../../Common/Wallets/View/MustLoginView.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/p2p_profile_view_model.dart';

class P2PProfileView extends StatefulWidget {
  const P2PProfileView({Key? key}) : super(key: key);

  @override
  State<P2PProfileView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PProfileView>
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
    if (constant.userLoginStatus.value) viewModel.findUserCenter();
  }

  _showEditDialog() async {
    final result =
        await Navigator.of(context).push(P2PEditProfileModal(context));
  }

  _showAddHomeDialog() async {
    final result = await Navigator.of(context).push(P2PAddHomeModel(context));
  }

  _showAvgDetailsDialog() async {
    final result =
        await Navigator.of(context).push(P2PAvgDetailsModel(context));
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PProfileViewModel>();

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
                    if (constant.p2pPop.value) {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                      constant.p2pPop.value = false;
                    } else {
                      Navigator.pop(context);
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
    int avgRelease = (viewModel.userCenter?.avgReleaseTime ?? 0) != 60
        ? (viewModel.userCenter?.avgReleaseTime ?? 0)
        : 1;
    num avgPay = (viewModel.userCenter?.avgPaymentTime ?? 0) != 60
        ? (viewModel.userCenter?.avgPaymentTime ?? 0)
        : 1;
    return Flexible(
      fit: FlexFit.loose,
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSizedBox(
                  height: 0.01,
                ),
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
                  height: 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    moveToProfileDetails(context);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        fontfamily: 'InterTight',
                        text: stringVariables.more,
                        fontsize: 16,
                        fontWeight: FontWeight.w400,
                        color: themeColor,
                      ),
                      SvgPicture.asset(
                        p2pRightArrow,
                        height: 25,
                        color: themeColor,
                      ),
                    ],
                  ),
                ),
                CustomSizedBox(
                  height: 0.005,
                ),
                Divider(
                  color: divider,
                  thickness: 0.2,
                ),
                CustomSizedBox(
                  height: 0.005,
                ),
                buildOtherItems(size)
              ],
            ),
          ),
        ),
      ),
    );
  }

  onFeedbackClicked() {
    moveToProfileFeedback(context);
  }

  onPaymentClicked() {
    moveToPaymentMethods(context);
  }

  onAddHomeClicked() {
    _showAddHomeDialog();
  }

  Widget buildOtherItems(Size size) {
    int feedbackCount = (viewModel.userCenter?.positive ?? 0) +
        (viewModel.userCenter?.negative ?? 0);
    int paymentsCount = (viewModel.paymentMethods ?? []).length;
    return Column(
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        buildOthersCard(
            size,
            p2pReceivedFeedback,
            stringVariables.receivedFeedback,
            onFeedbackClicked,
            Row(
              children: [
                CustomText(
                  fontfamily: 'InterTight',
                  text: "$feedbackCount",
                  fontsize: 16,
                  fontWeight: FontWeight.w400,
                  color: hintLight,
                ),
                SvgPicture.asset(
                  p2pRightArrow,
                  height: 25,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            )),
        CustomSizedBox(
          height: 0.02,
        ),
        buildOthersCard(
            size,
            p2pPaymentMethods,
            stringVariables.paymentMethod + "(s)",
            onPaymentClicked,
            Row(
              children: [
                CustomText(
                  fontfamily: 'InterTight',
                  text: paymentsCount == 0
                      ? stringVariables.notAdded
                      : "$paymentsCount",
                  fontsize: 16,
                  fontWeight: FontWeight.w400,
                  color: hintLight,
                ),
                SvgPicture.asset(
                  p2pRightArrow,
                  height: 25,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            )),
        CustomSizedBox(
          height: 0.02,
        ),
        Platform.isAndroid
            ? Column(
                children: [
                  buildOthersCard(size, p2pHomeScreen,
                      stringVariables.addHomeScreen, onAddHomeClicked),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                ],
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
      ],
    );
  }

  Widget buildOthersCard(
      Size size, String icon, String title, VoidCallback onTapped,
      [Widget? arrow]) {
    return Padding(
      padding: EdgeInsets.only(left: size.width / 50),
      child: GestureDetector(
        onTap: onTapped,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  icon,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                CustomSizedBox(
                  width: 0.03,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: title,
                  fontsize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            arrow ??
                SvgPicture.asset(
                  p2pRightArrow,
                  height: 25,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
          ],
        ),
      ),
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
          fontfamily: 'InterTight',
          text: value,
          fontsize: 23,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          fontfamily: 'InterTight',
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
            fontfamily: 'InterTight',
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
                fontfamily: 'InterTight',
                text: time,
                fontsize: 16,
                fontWeight: FontWeight.w600,
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              CustomText(
                fontfamily: 'InterTight',
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
    String name = (viewModel.userCenter?.name ?? "") == " "
        ? (constant.userEmail.value.substring(0, 2) +
            "*****." +
            constant.userEmail.value.split(".").last)
        : (viewModel.userCenter?.name ?? "");
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
                          fontfamily: 'InterTight',
                          text: name.isNotEmpty ? name[0].toUpperCase() : " ",
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
                        fontfamily: 'InterTight',
                        text: name,
                        fontsize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _showEditDialog();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: CustomCircleAvatar(
                      radius: 18,
                      backgroundColor: switchBackground,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomSizedBox(
                            width: 0.01,
                          ),
                          SvgPicture.asset(
                            p2pEditProfile,
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                          ),
                        ],
                      ),
                    ),
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
                        fontfamily: 'InterTight',
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
          fontfamily: 'InterTight',
          text: title,
          fontsize: 14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
