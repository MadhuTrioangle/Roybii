import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/ViewModel/DashBoardViewModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';
import '../../Security/ViewModel/SecurityViewModel.dart';
import '../Model/DashBoardModel.dart';

class DashBoardView extends StatefulWidget {
  String? buttonValue = constant.buttonValue.value;

  DashBoardView({
    Key? key,
    this.buttonValue,
  }) : super(key: key);

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  late DashBoardViewModel getDashBoardBalance;
  late SecurityViewModel securityViewModel;
  String? dashBoard = "DashBoard";
  String defaultCryptoCurrency = constant.cryptoCurrency.value;

  String? defaultFiatCurrency =
      constant.pref?.getString("defaultFiatCurrency") ?? '';

  @override
  void initState() {
    getDashBoardBalance =
        Provider.of<DashBoardViewModel>(context, listen: false);
    getDashBoardBalance.getDashBoardBalance();
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(constant.previousScreen.value == ScreenType.Market) {
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
    getDashBoardBalance = context.watch<DashBoardViewModel>();
    securityViewModel = context.watch<SecurityViewModel>();
    return Provider<DashBoardViewModel>(
      create: (context) => getDashBoardBalance,
      dispose: (context, value) {},
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
                    text: stringVariables.dashboard,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: (getDashBoardBalance.needToLoad)
            ? Center(child: CustomLoader())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    dashBoardUpperCard(
                      context,
                    ),
                    dashBoardLowerCard(context, securityViewModel),
                  ],
                ),
              ),
      ),
    );
  }

  ///Upper Card in DashBoard Screen
  Widget dashBoardUpperCard(
    BuildContext context,
  ) {
    return CustomCard(
        radius: 25,
        edgeInsets: 15,
        outerPadding: 10,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSizedBox(
              height: 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                    fontfamily: 'GoogleSans',
                    text: getDashBoardBalance.isvisible
                        ? trimDecimalsForBalance('${getDashBoardBalance.total}')
                        : "****",
                    fontsize: 25,
                    fontWeight: FontWeight.bold),
                CustomText(
                    fontfamily: 'GoogleSans',
                    text: getDashBoardBalance.isvisible
                        ? ' ${constant.cryptoCurrency.value}'
                        : "****",
                    fontWeight: FontWeight.bold,
                    fontsize: 20,
                    color: textHeaderGrey,
                    strutStyleHeight: 2),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: 5,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        getDashBoardBalance.setVisible();
                      },
                      child: Icon(
                        getDashBoardBalance.isvisible
                            ? Icons.remove_red_eye_rounded
                            : Icons.visibility_off,
                        color: textHeaderGrey,
                        size: 21,
                      )),
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomCard(
              radius: 15,
              edgeInsets: 20,
              outerPadding: 0,
              elevation: 0,
              color: themeSupport().isSelectedDarkMode() ? black : grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: stringVariables.estimatedValue,
                        fontWeight: FontWeight.w600,
                        fontsize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: hintLight,
                      ),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            fontfamily: 'GoogleSans',
                            overflow: TextOverflow.ellipsis,
                            text: getDashBoardBalance.isvisible
                                ? trimDecimalsForBalance(
                                    '${getDashBoardBalance.estimateFiatValue}')
                                : "****",
                            fontsize: 19,
                            fontWeight: FontWeight.w900,
                            strutStyleHeight: 1.5,
                          ),
                          CustomText(
                              fontfamily: 'GoogleSans',
                              overflow: TextOverflow.ellipsis,
                              text: getDashBoardBalance.isvisible
                                  ? ' ${defaultFiatCurrency}'
                                  : "****",
                              fontWeight: FontWeight.w500,
                              fontsize: 15,
                              color: textHeaderGrey),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                      buttoncolor: themeColor,
                      color: black,
                      multiClick: true,
                      press: () {
                        constant.walletCurrency.value = defaultCryptoCurrency;
                        moveToCommonWithdrawView(
                            context,
                            CurrencyType.CRYPTO.toString(),
                            '${defaultCryptoCurrency}',getDashBoardBalance.availableBalanceForDefaultCryptoValue.toString());
                      },
                      width: 2.6,
                      isBorderedButton: true,
                      maxLines: 1,
                      icon: depositIcon,
                      text: stringVariables.withdraw,
                      radius: 25,
                      height: MediaQuery.of(context).size.height / 45,
                      icons: true,
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: Offset(0, 0)),
                  CustomElevatedButton(
                    buttoncolor: grey,
                    color: black,
                    multiClick: true,
                    press: () {
                      displayDialog(context, defaultCryptoCurrency);
                    },
                    width: 2.6,
                    isBorderedButton: true,
                    maxLines: 1,
                    icon: withdrawIcon,
                    text: stringVariables.deposit,
                    radius: 25,
                    height: MediaQuery.of(context).size.height / 45,
                    icons: true,
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            )
          ],
        ));
  }

  ///Lower Card in DashBoard Screen
  Widget dashBoardLowerCard(BuildContext context, SecurityViewModel viewModel) {
    return CustomCard(
        radius: 25,
        edgeInsets: 0,
        outerPadding: 10,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: CustomText(
                fontfamily: 'GoogleSans',
                text: stringVariables.accountSecurity,
                fontsize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 0.2,
              color: divider,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: stringVariables.enable2Fa,
                        fontsize: 14,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        color: themeColor,
                        text: constant.pref?.getString("buttonValue") ==
                                'verified'
                            ? 'Disable'
                            : stringVariables.enable,
                        fontsize: 14,
                        press: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              "buttonValue", constant.buttonValue.value);
                          if (constant.pref?.getString("buttonValue") ==
                              'verified') {
                            moveToDisableGoogleAuthenticator(
                              context,
                              dashBoard,
                              viewModel,
                              getDashBoardBalance,
                            );
                          } else {
                            moveToGoogleAuthenticateView(context, dashBoard,
                                viewModel, getDashBoardBalance);
                          }
                        },
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: stringVariables.identityVerification,
                        fontsize: 14,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        color: themeColor,
                        text: getDashBoardBalance
                                    .viewModelVerification?.kyc?.kycStatus ==
                                "verified"
                            ? stringVariables.view
                            : stringVariables.verify,
                        fontsize: 14,
                        press: () {
                          moveToIdentityVerification(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.2,
              color: divider,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: stringVariables.antiPhispingCode,
                        fontsize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        color: themeColor,
                        text: constant.antiCode.value == ""
                            ? stringVariables.create
                            : "",
                        fontsize: 14,
                        press: () {
                          constant.buttonValue.value == 'verified'
                              ? moveToVerifyCode(
                                  context,
                                  AuthenticationVerificationType.dashBoard,
                                )
                              : customSnackBar.showSnakbar(
                                  context,
                                  "You have not enabled TFA! Enable TFA to continue",
                                  SnackbarType.negative);
                        },
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    fontfamily: 'GoogleSans',
                    color: textGrey,
                    text: stringVariables.antiPhispingHeader,
                    fontsize: 13,
                    strutStyleHeight: 1.8,
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    children: [
                      CustomText(
                          fontfamily: 'GoogleSans',
                          text: stringVariables.antiPhispingCode + " : ",
                          fontsize: 15),
                      constant.antiCode.value == ''
                          ? CustomText(text: stringVariables.notProvided)
                          : CustomText(
                              text:
                                  '${constant.antiCode.value.substring(0, 2)}***'),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  displayDialog(BuildContext context, String defaultCryptoCurrency) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return buildDepositCrypto(context, defaultCryptoCurrency);
        });
  }

  buildDepositCrypto(BuildContext context, String defaultCryptoCurrency) {
    Image image =
        context.watch<DashBoardViewModel>()?.findAddress?.qrCode != null
            ? Image.memory(base64.decode(
                '${context.watch<DashBoardViewModel>()?.findAddress?.qrCode}'
                    .split(',')
                    .last))
            : Image.asset(
                splash,
              );
    return AlertDialog(
      insetPadding: EdgeInsets.only(bottom: 110, top: 70, left: 15, right: 15),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    cancel,
                    height: 18,
                  ))
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                  text: stringVariables.deposit,
                  fontsize: 25,
                  fontWeight: FontWeight.bold,
                  fontfamily: 'GoogleSans'),
              CustomText(
                  text: '  ${constant.cryptoCurrency.value}',
                  fontsize: 21,
                  fontWeight: FontWeight.bold,
                  fontfamily: 'GoogleSans')
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 7.0),
                child: CustomText(
                  text: stringVariables.scanningQr,
                  fontfamily: 'GoogleSans',
                  color: textGrey,
                  fontsize: 12,
                ),
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomContainer(
            width: 1,
            height: 4,
            child: FadeInImage(
              fit: BoxFit.fitHeight,
              placeholder: AssetImage(splash),
              image: image.image,
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9.0),
                child: CustomText(
                  text: stringVariables.useThisAddress,
                  fontfamily: 'GoogleSans',
                  color: textGrey,
                  fontsize: 12,
                ),
              ),
            ],
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
                  Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: CustomText(
                      align: TextAlign.start,
                      fontfamily: 'GoogleSans',
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      text:
                          '${context.watch<DashBoardViewModel>().findAddress?.address}',
                      color: textGrey,
                      fontsize: 13,
                    ),
                  ),
                  CustomIconButton(
                    onPress: () {
                      Clipboard.setData(ClipboardData(
                              text:
                                  '${context.watch<DashBoardViewModel>().findAddress?.address}'))
                          .then((_) {
                        customSnackBar.showSnakbar(
                            context, "Address Copied", SnackbarType.positive);
                      });
                    },
                    child: SvgPicture.asset(
                      copy,
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: stringVariables.important.toUpperCase(),
                fontfamily: 'GoogleSans',
                fontsize: 15,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Deposit ${constant.cryptoCurrency.value} Address Only",
                fontfamily: 'GoogleSans',
                color: textGrey,
                fontsize: 13,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
