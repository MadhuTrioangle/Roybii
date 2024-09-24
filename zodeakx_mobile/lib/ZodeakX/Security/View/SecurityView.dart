import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/ViewModel/SecurityViewModel.dart';

import '../../../Common/SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../DashBoardScreen/ViewModel/DashBoardViewModel.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';

class SecurityView extends StatefulWidget {
  SecurityView({
    Key? key,
  }) : super(key: key);

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  late SecurityViewModel securityViewModel;
  late DashBoardViewModel getDashBoardBalance;
  SiteMaintenanceViewModel? siteMaintenanceViewModel;

  @override
  void initState() {
    // TODO: implement initState
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    getDashBoardBalance =
        Provider.of<DashBoardViewModel>(context, listen: false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    securityViewModel.getIdVerification();
    siteMaintenanceViewModel?.getSiteMaintenanceStatus();

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
    securityViewModel = context.watch<SecurityViewModel>();
    getDashBoardBalance = context.watch<DashBoardViewModel>();
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();

    return Provider<SecurityViewModel>(
      create: (context) => SecurityViewModel(),
      child: CustomScaffold(
        color: themeSupport().isSelectedDarkMode()
            ? darkScaffoldColor
            : lightScaffoldColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: CustomContainer(
            width: 1,
            height: 1,
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
                      height: 30,
                      child: SvgPicture.asset(
                        backArrow,
                      ),
                    ),
                  ),
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  fontsize: 23,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  text: stringVariables.setting,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                upperCard(),
                middleCard(),
                lowerCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  upperCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CustomText(
            text: stringVariables.notification,
            color: stackCardText,
            fontsize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomCard(
          outerPadding: 0,
          edgeInsets: 0,
          radius: 15,
          elevation: 0,
          color:
              themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                buildRowText(
                    "${stringVariables.email} ${stringVariables.notification}",
                    buildEmailButton(),
                    true),
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        )
      ],
    );
  }

  middleCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CustomText(
            text: "${stringVariables.security} & ${stringVariables.privacy}",
            color: stackCardText,
            fontsize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomCard(
          outerPadding: 0,
          edgeInsets: 0,
          radius: 15,
          elevation: 0,
          color:
              themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                buildRowText(stringVariables.google2Fa, buildTfaButton()),
                buildRowText(
                    stringVariables.changePassword, buildPasswordButton()),
                buildAntiPhishingCode()
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  buildTfaButton() {
    return Row(
      children: [
        CustomText(
          text: securityViewModel.viewModelVerification?.tfaStatus == 'verified'
              ? "${stringVariables.off.toUpperCase()}  "
              : "${stringVariables.on.toUpperCase()}  ",
          color: stackCardText,
        ),
        Icon(
          Icons.arrow_forward_ios,
          color: contentFontColor,
          size: 13,
        ),
      ],
    );
  }

  buildPasswordButton() {
    return Icon(
      Icons.arrow_forward_ios,
      color: contentFontColor,
      size: 13,
    );
  }

  buildAntiPhisingButton() {
    return securityViewModel.viewModelVerification?.antiPhishingCode == ""
        ? CustomText(
            text: stringVariables.create,
            color: themeColor,
          )
        : Icon(
            Icons.arrow_forward_ios,
            color: contentFontColor,
            size: 13,
          );
  }

  buildEmailButton() {
    return CustomText(
      text: (stringVariables.on.toUpperCase()),
      color: stackCardText,
    );
  }

  buildRowText(String title, Widget custom, [bool? isLast = false]) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (title == stringVariables.deleteAccount) {
              moveToManageAccountView(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: title,
                      fontsize: 14.5,
                      fontWeight: FontWeight.w500,
                      color:
                          title == stringVariables.deleteAccount ? red : null,
                    )
                  ],
                ),
                custom
              ],
            ),
          ),
        ),
        if (isLast == false)
          Divider(
            color: themeSupport().isSelectedDarkMode()
                ? marketCardColor
                : lightSearchBarColor,
          )
      ],
    );
  }

  lowerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CustomText(
            text: stringVariables.advanced,
            color: stackCardText,
            fontsize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomCard(
          outerPadding: 0,
          edgeInsets: 0,
          radius: 15,
          elevation: 0,
          color:
              themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                buildRowText(
                    stringVariables.deleteAccount, buildPasswordButton(), true),
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        )
      ],
    );
  }

  // buildGoogleAuthentication(),
  // buildPhoneNumber(),
  // buildLoginPassword(),
  // buildIdVerification(),
  // buildAntiPhishingCode(),
  // buildManageAccount(),

  Widget buildGoogleAuthentication() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.twoFactor,
                fontWeight: FontWeight.bold,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
              CustomText(
                text: securityViewModel.viewModelVerification?.tfaStatus ==
                        'verified'
                    ? stringVariables.disableCaps
                    : stringVariables.enableCaps,
                fontWeight: FontWeight.bold,
                color: themeColor,
                press: () async {
                  if (securityViewModel.viewModelVerification?.tfaStatus ==
                      'verified') {
                    moveToDisableGoogleAuthenticator(context);
                  } else {
                    moveToGoogleAuthenticateView(context);
                  }
                },
                decoration: TextDecoration.underline,
              )
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            text: stringVariables.googleAuthentication,
            fontWeight: FontWeight.bold,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            text: stringVariables.securityNotification,
            fontsize: 12,
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
          ),
          CustomSizedBox(
            height: 0.03,
          ),
        ],
      ),
    );
  }

  Widget buildLoginPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.loginPassword,
                fontWeight: FontWeight.bold,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
              CustomText(
                text: stringVariables.change,
                decoration: TextDecoration.underline,
                color: themeColor,
                fontWeight: FontWeight.bold,
                press: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();

                  if (securityViewModel.viewModelVerification?.tfaStatus ==
                          "verified" ||
                      securityViewModel.viewModelVerification?.tfaAuthentication
                              ?.mobileNumber?.status ==
                          "verified") {
                    moveToVerifyCode(
                        context,
                        AuthenticationVerificationType.ChangePassword,
                        securityViewModel.viewModelVerification?.tfaStatus,
                        securityViewModel.viewModelVerification
                            ?.tfaAuthentication?.mobileNumber?.status,
                        securityViewModel.viewModelVerification
                            ?.tfaAuthentication?.mobileNumber?.phoneCode,
                        securityViewModel.viewModelVerification
                            ?.tfaAuthentication?.mobileNumber?.phoneNumber);
                  } else {
                    customSnackBar.showSnakbar(context,
                        stringVariables.enableTfa, SnackbarType.negative);
                  }
                },
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
      ],
    );
  }

  Widget buildManageAccount() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          moveToManageAccountView(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: divider,
              thickness: 0.2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: stringVariables.manageAccount,
                    fontWeight: FontWeight.bold,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                  Icon(
                    size: 15,
                    Icons.arrow_forward_ios,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.03,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPhoneNumber() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        moveToPhoneNumber(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: divider,
            thickness: 0.2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: stringVariables.phoneNumber,
                  fontWeight: FontWeight.bold,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                securityViewModel.viewModelVerification?.tfaAuthentication
                            ?.mobileNumber?.status ==
                        "verified"
                    ? CustomText(
                        text: (stringVariables.verified.toUpperCase()),
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        decoration: TextDecoration.underline,
                      )
                    : CustomText(
                        text: stringVariables.unVerified.toUpperCase(),
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        decoration: TextDecoration.underline,
                      ),
              ],
            ),
          ),
          CustomSizedBox(
            height: 0.03,
          ),
        ],
      ),
    );
  }

  Widget buildIdVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.identityVerification,
                fontWeight: FontWeight.bold,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
              CustomText(
                text: securityViewModel.viewModelVerification?.kyc?.kycStatus ==
                        "verified"
                    ? stringVariables.view.toUpperCase()
                    : stringVariables.verify.toUpperCase(),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: themeColor,
                press: () {
                  moveToIdentityVerification(context);
                },
              ),
            ],
          ),
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
      ],
    );
  }

  Widget buildAntiPhishingCode() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.antiPhispingCode,
                fontWeight: FontWeight.w500,
              ),
              securityViewModel.viewModelVerification?.antiPhishingCode == ""
                  ? CustomText(
                      text: stringVariables.create,
                      color: themeColor,
                      press: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        (securityViewModel.viewModelVerification?.tfaStatus == "verified" ||
                                securityViewModel.viewModelVerification
                                        ?.tfaAuthentication?.mobileNumber?.status ==
                                    "verified")
                            ? moveToVerifyCode(
                                context,
                                AuthenticationVerificationType.AntiPhishing,
                                securityViewModel
                                    .viewModelVerification?.tfaStatus,
                                securityViewModel.viewModelVerification
                                    ?.tfaAuthentication?.mobileNumber?.status,
                                securityViewModel
                                    .viewModelVerification
                                    ?.tfaAuthentication
                                    ?.mobileNumber
                                    ?.phoneCode,
                                securityViewModel
                                    .viewModelVerification
                                    ?.tfaAuthentication
                                    ?.mobileNumber
                                    ?.phoneNumber)
                            : customSnackBar.showSnakbar(
                                context,
                                stringVariables.enableTfa,
                                SnackbarType.negative);
                      },
                    )
                  : CustomSizedBox(),
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 58.0),
            child: CustomText(
              text: stringVariables.instructAntiPhising,
              strutStyleHeight: 1.3,
              color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
              fontsize: 12,
            ),
          ),
          (securityViewModel.viewModelVerification?.tfaStatus == "verified" ||
                      securityViewModel.viewModelVerification?.tfaAuthentication
                              ?.mobileNumber?.status ==
                          "verified") &&
                  securityViewModel.viewModelVerification?.antiPhishingCode ==
                      ''
              ? CustomText(text: '')
              : Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: securityViewModel
                              .viewModelVerification?.antiPhishingCode ==
                          ''
                      ? CustomText(text: "")
                      : CustomText(
                          text: '${stringVariables.antiPhisingCode} '
                              '${securityViewModel.viewModelVerification?.antiPhishingCode?.substring(0, 2)}***',
                          fontWeight: FontWeight.bold,
                          color: themeSupport().isSelectedDarkMode()
                              ? white
                              : black,
                          fontsize: 12,
                        ),
                ),
          CustomSizedBox(
            height: 0.02,
          ),
        ],
      ),
    );
  }
}
