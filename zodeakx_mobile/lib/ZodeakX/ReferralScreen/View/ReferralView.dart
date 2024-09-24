import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Common/SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomShareMessage.dart';
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
  SiteMaintenanceViewModel? siteMaintenanceViewModel;

  @override
  void initState() {
    viewModel = Provider.of<ReferralViewModel>(context, listen: false);
    viewModel.setcopiedLink(false);
    viewModel.setcopied(false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    viewModel.GenerateReferralLink();
    siteMaintenanceViewModel?.getSiteMaintenanceStatus();
    //TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (constant.previousScreen.value == ScreenType.Market) {
      resumeSocket();
      constant.previousScreen.value = ScreenType.Login;
    }
    siteMaintenanceViewModel?.leaveSocket();
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
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();

    return Provider<ReferralViewModel>(
        create: (context) => viewModel,
        child: CustomScaffold(
            color: themeSupport().isSelectedDarkMode()
                ? darkScaffoldColor
                : lightScaffoldColor,
            child: SingleChildScrollView(
              child: welcome(),
            )));
  }

  welcome() {
    return CustomContainer(
      height: 0.85,
      child: Stack( children: [
        CustomContainer(
            padding: 20,///inside padding
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35)),
              color: themeSupport().isSelectedDarkMode()
                  ? darkThemeColor
                  : darkThemeColor,
            ),
            child: Referal()),
        Positioned(
          top: 90,
          left: 3,
          right: 3,
          child: Column(
            children: [
              inviteNow(),
              centerCard(),
              footer(),
              inviteFriends()],
          ),
        )
      ]),
    );
  }

  inviteNow() {
    return CustomCard(
      elevation: 0.2,
      radius: 25,   ///outer corner curve
      edgeInsets: 20,
      outerPadding: 0,
      color:
          themeSupport().isSelectedDarkMode() ? darkCardColor : lightCardColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomContainer(
                height: 8,
                child: SvgPicture.asset(referral),
                width: 3,
              )
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                  text: "${stringVariables.inviteFriend}",
                  fontWeight: FontWeight.w700,
                  fontsize: 20,
                  color: themeSupport().isSelectedDarkMode()
                      ? lightCardColor
                      : darkScaffoldColor),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                  text: "${stringVariables.cryptotogether}",
                  fontWeight: FontWeight.w700,
                  fontsize: 20,
                  color: themeSupport().isSelectedDarkMode()
                      ? lightCardColor
                      : darkScaffoldColor),
            ],
          ),
          CustomSizedBox(
            height: 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                text: stringVariables.inviteNow,
                radius: 10,
                buttoncolor: Colors.transparent,
                width: 2.5,
                height: 20,
                isBorderedButton: false,
                maxLines: 1,
                icons: false,
                fillColor: themeSupport().isSelectedDarkMode()
                    ? darkThemeColor
                    : themeColor,
                color: themeSupport().isSelectedDarkMode()
                    ? lightCardColor
                    : lightCardColor,
                multiClick: true,
                press: () {
                  onShare(context, '${viewModel.total}',
                      '${constant.referralUrl}${viewModel.total}');
                },
                icon: '',
              )
            ],
          ),
        ],
      ),

    );
  }

  Referal() {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          children: [
            CustomText(
                text: stringVariables.marketScreenHeading,
                fontWeight: FontWeight.w400,
                fontsize: 16,
                color: themeSupport().isSelectedDarkMode()
                    ? lightCardColor
                    : lightCardColor),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  referCancel,
                  height: 10.45,
                  color: themeSupport().isSelectedDarkMode()
                      ? lightCardColor
                      : lightCardColor,
                ))
          ],
        ),
        Row(
          children: [
            CustomText(
                text: stringVariables.reward,
                fontWeight: FontWeight.w700,
                fontsize: 25,
                color: themeSupport().isSelectedDarkMode()
                    ? lightCardColor
                    : lightCardColor),
          ],
        ),
      ],
    );
  }

  ///Traded Friends,Earned Crypto in Center Card
  centerCard() {
    return CustomCard(
        elevation: 0.2,
        radius: 25,
        edgeInsets: 18,
        outerPadding: 0,
        color: themeSupport().isSelectedDarkMode()
            ? darkCardColor
            : lightCardColor,
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
                    color: themeSupport().isSelectedDarkMode()
                        ? contentFontColor
                        : hintTextColor,
                    fontfamily: 'InterTight',
                    fontWeight: FontWeight.w500,
                    fontsize: 16),
                Row(
                  children: [
                    CustomText(
                      align: TextAlign.end,
                      fontfamily: 'InterTight',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text: isDigit(
                          '${viewModel.referralDashBoard?.youEarned ?? stringVariables.coinTotal}'),
                      fontsize: 17,
                      fontWeight: FontWeight.w700,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor,
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      align: TextAlign.end,
                      softwrap: true,
                      maxlines: 1,
                      fontfamily: 'InterTight',
                      overflow: TextOverflow.ellipsis,
                      text:
                          ' ${viewModel.referralDashBoard?.referralDefaultCurrency ?? stringVariables.coinSymbol}',
                      fontWeight: FontWeight.w700,
                      fontsize: 15,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor,
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
                Row(
                  children: [
                    CustomContainer(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color:darkThemeColor, width: 2),
                          shape: BoxShape.circle,
                          color: Colors.transparent),
                    ),
                    CustomSizedBox(
                      width: 0.04,
                    ),
                    CustomText(
                        overflow: TextOverflow.ellipsis,
                        softwrap: true,
                        text: stringVariables.tradedFrnd,
                        color: themeSupport().isSelectedDarkMode()
                            ? contentFontColor
                            : hintTextColor,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.w400,
                        fontsize: 14),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      align: TextAlign.end,
                      fontfamily: 'InterTight',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text:
                          ('${viewModel.referralDashBoard?.totalTradedFriends ?? "0"}'),
                      fontsize: 17,
                      fontWeight: FontWeight.w500,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor,
                    ),
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
                Row(
                  children: [
                    CustomContainer(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color:darkThemeColor, width: 2),
                          shape: BoxShape.circle,
                          color: Colors.transparent),
                    ),
                    CustomSizedBox(
                      width: 0.04,
                    ),
                    CustomText(
                        overflow: TextOverflow.ellipsis,
                        softwrap: true,
                        text: stringVariables.frndsRefer,
                        color: themeSupport().isSelectedDarkMode()
                            ? contentFontColor
                            : hintTextColor,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.w400,
                        fontsize: 14),
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      align: TextAlign.end,
                      fontfamily: 'InterTight',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text:
                          ('${viewModel.referralDashBoard?.totalFriends ?? "0"}'),
                      fontsize: 17,
                      fontWeight: FontWeight.w500,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor,
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }

  footer() {
    return CustomCard(
      elevation: 0.2,
      radius: 25,
      edgeInsets: 10,
      outerPadding: 4,
      color:
          themeSupport().isSelectedDarkMode() ? darkCardColor : lightCardColor,
      child: Column(
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
            fontsize: 16,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.w600,
            color: themeSupport().isSelectedDarkMode()
                ? lightCardColor
                : darkScaffoldColor,
          ),
          referralId(),
          referralLink(),
        ],
      ),
    );
  }

  referralId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: CustomText(
              text: stringVariables.referralPage,
              fontsize: 10,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.w400,
              color: themeSupport().isSelectedDarkMode()
                  ? lightCardColor
                  : darkScaffoldColor),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          width: 1,
          height: MediaQuery.of(context).size.height / 50,
          decoration: BoxDecoration(
            color: themeSupport().isSelectedDarkMode()
                ? marketCardColor
                : lightSearchBarColor,
            border: Border.all(color: Colors.transparent, width: 0.5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  color: themeSupport().isSelectedDarkMode()
                      ? contentFontColor
                      : hintTextColor,
                  align: TextAlign.start,
                  fontfamily: 'InterTight',
                  softwrap: true,
                  overflow: TextOverflow.ellipsis,
                  text: viewModel.total ?? "",
                  fontsize: 15,
                ),
                CustomElevatedButton(
                  press: () {
                    viewModel.setcopied(true);
                    text = viewModel.total ?? "";
                    Clipboard.setData(
                            ClipboardData(text: viewModel.total ?? ""))
                        .then((_) {
                      customSnackBar.showSnakbar(context,
                          stringVariables.copySnackBar, SnackbarType.positive);
                    });
                  },
                  multiClick: true,
                  text: viewModel.copied
                      ? stringVariables.copied
                      : stringVariables.copy,
                  radius: 10,
                  buttoncolor: Colors.transparent,
                  width: 3.5,
                  height: 15,
                  isBorderedButton: false,
                  maxLines: 1,
                  icons: true,
                  color: viewModel.copied
                      ? themeSupport().isSelectedDarkMode()
                          ? contentFontColor
                          : hintTextColor
                      : themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : lightCardColor,
                  fillColor: viewModel.copied
                      ? themeSupport().isSelectedDarkMode()
                          ? hintTextColor
                          : disableButtonLight
                      : themeSupport().isSelectedDarkMode()
                          ? darkThemeColor
                          : themeColor,
                  icon: referCopyPrefix,
                  iconColor: viewModel.copied
                      ? themeSupport().isSelectedDarkMode()
                          ? contentFontColor
                          : hintTextColor
                      : themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : lightCardColor,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///USER Referral Link
  referralLink() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: CustomText(
              text: stringVariables.referralLink,
              fontsize: 10,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.w400,
              color: themeSupport().isSelectedDarkMode()
                  ? lightCardColor
                  : darkScaffoldColor),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          width: 1,
          height: MediaQuery.of(context).size.height / 50,
          decoration: BoxDecoration(
            color: themeSupport().isSelectedDarkMode()
                ? marketCardColor
                : lightSearchBarColor,
            border: Border.all(color: Colors.transparent, width: 0.5),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomContainer(
                  width: 2,
                  child: CustomText(
                    align: TextAlign.start,
                    fontfamily: 'InterTight',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    text: '${constant.referralUrl}${viewModel.total ?? ""}',
                    fontsize: 15,
                    color: themeSupport().isSelectedDarkMode()
                        ? contentFontColor
                        : hintTextColor,
                  ),
                ),
                CustomElevatedButton(
                  press: () {
                    viewModel.setcopiedLink(true);
                    text = viewModel.total ?? "";
                    Clipboard.setData(ClipboardData(
                            text:
                                '${constant.referralUrl}${viewModel.total ?? ""}'))
                        .then((_) {
                      customSnackBar.showSnakbar(context,
                          stringVariables.copySnackBar, SnackbarType.positive);
                    });
                  },
                  multiClick: true,
                  text: viewModel.copiedLink
                      ? stringVariables.copied
                      : stringVariables.copy,
                  radius: 10,
                  buttoncolor: Colors.transparent,
                  width: 3.5,
                  height: 15,
                  isBorderedButton: false,
                  maxLines: 1,
                  icons: true,
                  color: viewModel.copiedLink
                      ? themeSupport().isSelectedDarkMode()
                          ? contentFontColor
                          : hintTextColor
                      : themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : lightCardColor,
                  fillColor: viewModel.copiedLink
                      ? themeSupport().isSelectedDarkMode()
                          ? hintTextColor
                          : disableButtonLight
                      : themeSupport().isSelectedDarkMode()
                          ? darkThemeColor
                          : themeColor,
                  icon: referCopyPrefix,
                  iconColor: viewModel.copiedLink
                      ? themeSupport().isSelectedDarkMode()
                          ? contentFontColor
                          : hintTextColor
                      : themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : lightCardColor,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  inviteFriends() {
    return CustomElevatedButton(
      press: () {
        onShare(context, '${viewModel.total}',
            '${constant.referralUrl}${viewModel.total}');
      },
      buttoncolor: themeColor,
      width: 1.1,
      isBorderedButton: false,
      multiClick: true,
      color:
          themeSupport().isSelectedDarkMode() ? lightCardColor : lightCardColor,
      fillColor:
          themeSupport().isSelectedDarkMode() ? darkThemeColor : themeColor,
      icon: '',
      radius: 16,
      text: stringVariables.inviteFriends,
      height: MediaQuery.of(context).size.height / 50,
      icons: false,
      maxLines: 1,
      spreadRadius: 4,
      blurRadius: 16,
    );
  }
}
