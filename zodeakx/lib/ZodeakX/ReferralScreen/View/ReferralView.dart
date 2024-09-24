import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomShareMessage.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';
import '../ViewModel/ReferralViewModel.dart';

class ReferralView extends StatefulWidget {
  const ReferralView({Key? key}) : super(key: key);

  @override
  State<ReferralView> createState() => _ReferralViewState();
}

class _ReferralViewState extends State<ReferralView> {
  String text = '';
  late ReferralViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<ReferralViewModel>(context, listen: false);
    viewModel.GenerateReferralLink();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (constant.previousScreen.value == ScreenType.Market) {
      resumeSocket();
      constant.previousScreen.value = ScreenType.Login;
    }
    super.dispose();
  }

  resumeSocket() {
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.initSocket = true;
    marketViewModel.getTradePairs();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ReferralViewModel>();
    return Provider<ReferralViewModel>(
      create: (context) => viewModel,
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
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SvgPicture.asset(
                        backArrow,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    overflow: TextOverflow.ellipsis,
                    maxlines: 1,
                    softwrap: true,
                    fontfamily: 'GoogleSans',
                    fontsize: 23,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.referral,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: (viewModel.needToLoad)
            ? Center(child: CustomLoader())
            : SingleChildScrollView(
                child: CustomCard(
                  radius: 25,
                  outerPadding: 10,
                  edgeInsets: 20,
                  elevation: 0,
                  child: Column(
                    children: [
                      imageWithButton(
                        context,
                      ),
                      centerCard(
                        context,
                      ),
                      footer(
                        context,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  ///Referral Image and Invite Button
  Widget imageWithButton(
    BuildContext context,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxlines: 1,
                  softwrap: true,
                  text: stringVariables.inviteFriends + ".",
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.bold,
                  fontsize: 17,
                ),
                CustomSizedBox(
                  height: 0.01,
                ),
                CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxlines: 1,
                  softwrap: true,
                  text: stringVariables.earnCryptoTogether,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.bold,
                  fontsize: 17,
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomElevatedButton(
                  press: () {
                    onShare(context, '${viewModel.total}',
                        '${'${constant.referralUrl}${viewModel.total}'}');
                  },
                  buttoncolor: themeColor,
                  width: 3,
                  isBorderedButton: true,
                  multiClick: true,
                  icon: '',
                  radius: 25,
                  text: stringVariables.inviteNow,
                  height: MediaQuery.of(context).size.height / 40,
                  icons: false,
                  maxLines: 1,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                  blurRadius: 0,
                  color: black,
                )
              ],
            ),
            SvgPicture.asset(
              referralFriendImage,
              height: 85,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  ///Traded Friends,Earned Crypto in Center Card
  Widget centerCard(
    BuildContext context,
  ) {
    return CustomCard(
        radius: 25,
        edgeInsets: 18,
        outerPadding: 0,
        elevation: 0,
        color: themeSupport().isSelectedDarkMode() ? black : grey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                    overflow: TextOverflow.ellipsis,
                    softwrap: true,
                    text: stringVariables.youEarned,
                    color: hintLight,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w600,
                    fontsize: 14),
                Row(
                  children: [
                    CustomText(
                      align: TextAlign.end,
                      fontfamily: 'GoogleSans',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: trimDecimalsForBalance(
                          '${viewModel.referralDashBoard?.youEarned ?? stringVariables.coinTotal}'),
                      fontsize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    CustomText(
                      align: TextAlign.end,
                      softwrap: true,
                      maxlines: 1,
                      fontfamily: 'GoogleSans',
                      overflow: TextOverflow.ellipsis,
                      text:
                          ' ${viewModel.referralDashBoard?.referralDefaultCurrency ?? stringVariables.coinSymbol}',
                      fontWeight: FontWeight.bold,
                      fontsize: 15,
                    ),
                  ],
                )
              ],
            ),
            CustomSizedBox(
              height: 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                    overflow: TextOverflow.ellipsis,
                    softwrap: true,
                    text: stringVariables.totaltradeFriends,
                    color: hintLight,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w600,
                    fontsize: 14),
                Row(
                  children: [
                    CustomText(
                      align: TextAlign.end,
                      fontfamily: 'GoogleSans',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: (
                          '${viewModel.referralDashBoard?.totalTradedFriends ?? "0"}'),
                      fontsize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    // CustomText(
                    //   align: TextAlign.end,
                    //   softwrap: true,
                    //   maxlines: 1,
                    //   fontfamily: 'GoogleSans',
                    //   overflow: TextOverflow.ellipsis,
                    //   text:
                    //       ' ${viewModel.referralDashBoard?.referralDefaultCurrency ?? stringVariables.coinSymbol}',
                    //   fontWeight: FontWeight.bold,
                    //   fontsize: 15,
                    // ),
                  ],
                )
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                    overflow: TextOverflow.ellipsis,
                    softwrap: true,
                    text: stringVariables.totalFriends,
                    color: hintLight,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w600,
                    fontsize: 14),
                Row(
                  children: [
                    CustomText(
                      align: TextAlign.end,
                      fontfamily: 'GoogleSans',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: (
                          '${viewModel.referralDashBoard?.totalFriends ?? "0"}'),
                      fontsize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    // CustomText(
                    //   align: TextAlign.end,
                    //   softwrap: true,
                    //   maxlines: 1,
                    //   fontfamily: 'GoogleSans',
                    //   overflow: TextOverflow.ellipsis,
                    //   text:
                    //       ' ${viewModel.referralDashBoard?.referralDefaultCurrency ?? stringVariables.coinSymbol}',
                    //   fontWeight: FontWeight.bold,
                    //   fontsize: 15,
                    // ),
                  ],
                )
              ],
            ),
          ],
        ));
  }

  ///Footer Part in Referral Screen
  Widget footer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.025,
        ),
        CustomText(
          overflow: TextOverflow.ellipsis,
          maxlines: 1,
          softwrap: true,
          text: stringVariables.defaultReferral,
          fontsize: 15,
          fontfamily: 'GoogleSans',
          fontWeight: FontWeight.w400,
        ),
        referralId(
          context,
        ),
        referralLink(context),
        CustomSizedBox(
          height: 0.03,
        ),
        CustomElevatedButton(
          press: () {
            onShare(context, '${viewModel.total}',
                '${'${constant.referralUrl}${viewModel.total}'}');
          },
          buttoncolor: themeColor,
          width: 1,
          isBorderedButton: true,
          multiClick: true,
          color: black,
          icon: '',
          radius: 25,
          text: stringVariables.inviteFriends.toUpperCase(),
          height: MediaQuery.of(context).size.height / 50,
          icons: false,
          maxLines: 1,
          offset: Offset(2, 2),
          spreadRadius: 4,
          blurRadius: 16,
        )
      ],
    );
  }

  ///USER Referral ID
  Widget referralId(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: CustomText(
              text: stringVariables.referralPage,
              fontsize: 15,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'GoogleSans',
              fontWeight: FontWeight.normal,
              color: textGrey),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          width: 1,
          height: MediaQuery.of(context).size.height / 50,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 0.5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  align: TextAlign.start,
                  fontfamily: 'GoogleSans',
                  softwrap: true,
                  overflow: TextOverflow.ellipsis,
                  text:
                      '${viewModel.total ?? stringVariables.referralIdExample}',
                  fontsize: 15,
                ),
                CustomIconButton(
                  onPress: () {
                    text =
                        '${viewModel.total ?? stringVariables.referralIdExample}';
                    Clipboard.setData(ClipboardData(
                            text:
                                '${viewModel.total ?? stringVariables.referralIdExample}'))
                        .then((_) {
                      customSnackBar.showSnakbar(
                          context,
                          stringVariables.copySnackBar,
                          SnackbarType.positive);
                    });
                  },
                  child: SvgPicture.asset(
                    copy,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///USER Referral Link
  Widget referralLink(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: CustomText(
              text: stringVariables.referralLink,
              fontsize: 15,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'GoogleSans',
              fontWeight: FontWeight.normal,
              color: textGrey),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          width: 1,
          height: MediaQuery.of(context).size.height / 50,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 0.5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomContainer(
                    width: 1.9,
                    height: MediaQuery.of(context).size.height / 38,
                    child: Center(
                        child: CustomText(
                      align: TextAlign.start,
                      fontfamily: 'GoogleSans',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text:
                          '${constant.referralUrl}${viewModel.total ?? stringVariables.referralIdExample}',
                      fontsize: 15,
                    ))),
                CustomIconButton(
                  onPress: () {
                    text =
                        '${constant.referralUrl}${viewModel.total ?? stringVariables.referralIdExample}';
                    Clipboard.setData(ClipboardData(
                            text:
                                '${constant.referralUrl}${viewModel.total ?? stringVariables.referralIdExample}'))
                        .then((_) {
                      customSnackBar.showSnakbar(
                          context,
                          stringVariables.copySnackBar,
                          SnackbarType.positive);
                    });
                  },
                  child: SvgPicture.asset(
                    copy,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
