import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/ViewModel/SecurityViewModel.dart';

import '../../../Utils/Widgets/CustomContainer.dart';
import '../../DashBoardScreen/ViewModel/DashBoardViewModel.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';

class SecurityView extends StatefulWidget {
  String? buttonValue = constant.buttonValue.value;

  SecurityView({
    Key? key,
    this.buttonValue,
  }) : super(key: key);

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  String loginPage = "loginPage";
  String? security = "Security";
  String? buttonValue;
  int count = 0;
  late SecurityViewModel securityViewModel;
  late DashBoardViewModel getDashBoardBalance;

  @override
  void initState() {
    constant.antiCode.value;
    constant.buttonValue.value;
    getAllSavedData();
    getAntiPhishingCode();
    // TODO: implement initState
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    getDashBoardBalance =
        Provider.of<DashBoardViewModel>(context, listen: false);
    securityViewModel.getIdVerification();
    super.initState();
  }

  getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    constant.buttonValue.value = prefs.getString("buttonValue").toString();
  }

  getAntiPhishingCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    constant.antiCode.value = prefs.getString("code").toString();
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
    return Provider<SecurityViewModel>(
      create: (context) => SecurityViewModel(),
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
                    fontfamily: 'GoogleSans',
                    fontsize: 23,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.security,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSizedBox(
                height: 0.02,
              ),
              CustomCard(
                radius: 25,
                edgeInsets: 4,
                outerPadding: 8,
                elevation: 0,
                child: Column(
                  children: [
                    buildGoogleAuthentication(),
                    buildLoginPassword(),
                    buildIdVerification(),
                    buildAntiPhishingCode(),
                    buildManageAccount(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGoogleAuthentication() {
    if (kDebugMode) {
      securityViewModel.viewModelVerification?.tfaStatus =
          constant.buttonValue.value;
      securityViewModel.viewModelVerification?.antiPhishingCode =
          constant.antiCode.value;
    }

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
                text: securityViewModel.buttonEnable
                    ? 'DISABLE'
                    : stringVariables.enableCaps,
                fontWeight: FontWeight.bold,
                color: themeColor,
                press: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("buttonValue", constant.buttonValue.value);
                  if (securityViewModel.viewModelVerification?.tfaStatus ==
                      'verified') {
                    moveToDisableGoogleAuthenticator(context, security,
                        securityViewModel, getDashBoardBalance);
                  } else {
                    moveToGoogleAuthenticateView(context, security,
                        securityViewModel, getDashBoardBalance);
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
          height: 5,
          thickness: 1,
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
                      'verified') {
                    moveToVerifyCode(
                        context, AuthenticationVerificationType.ChangePassword);
                  } else {
                    customSnackBar.showSnakbar(
                        context,
                        "You have not enabled TFA! Enable TFA to continue",
                        SnackbarType.negative);
                  }
                },
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        const Divider(
          height: 5,
          thickness: 1,
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
          moveToManageAccount(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 5,
              thickness: 1,
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
            const Divider(
              height: 5,
              thickness: 1,
            ),
          ],
        ),
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
        const Divider(
          height: 5,
          thickness: 1,
        ),
      ],
    );
  }

  Widget buildAntiPhishingCode() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 22, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.antiPhispingCode,
                fontWeight: FontWeight.bold,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
              securityViewModel.viewModelVerification?.antiPhishingCode == ""
                  ? CustomText(
                      text: stringVariables.create.toUpperCase(),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: themeColor,
                      press: () {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        securityViewModel.viewModelVerification?.tfaStatus ==
                                'verified'
                            ? moveToVerifyCode(context,
                                AuthenticationVerificationType.AntiPhishing)
                            : customSnackBar.showSnakbar(
                                context,
                                "You have not enabled TFA! Enable TFA to continue",
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
          securityViewModel.viewModelVerification?.tfaStatus == 'verified' &&
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
                          text: 'Anti Phishining Code '
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
