import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/ViewModel/DashBoardViewModel.dart';

import '../../../Common/SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../../../Common/Wallets/CommonWithdraw/View/SelectWalletBottomSheet.dart';
import '../../../Common/Wallets/CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
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
  DashBoardView({
    Key? key,
  }) : super(key: key);

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  late DashBoardViewModel getDashBoardBalance;
  late CoinDetailsViewModel coinDetailsViewModel;
  late CommonWithdrawViewModel commonWithdrawViewModel;
  late SecurityViewModel securityViewModel;
  SiteMaintenanceViewModel? siteMaintenanceViewModel;
  String defaultCryptoCurrency = constant.cryptoCurrency.value;
  String? defaultFiatCurrency =
      constant.pref?.getString("defaultFiatCurrency") ?? '';

  @override
  void initState() {
    getDashBoardBalance =
        Provider.of<DashBoardViewModel>(context, listen: false);
    commonWithdrawViewModel =
        Provider.of<CommonWithdrawViewModel>(context, listen: false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    getDashBoardBalance.getDashBoardBalance();
    constant.walletCurrency.value = defaultCryptoCurrency;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      coinDetailsViewModel.getCryptoCurrency(CurrencyType.CRYPTO.toString());
      securityViewModel.getIdVerification();
      siteMaintenanceViewModel?.getSiteMaintenanceStatus();
    });
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
    getDashBoardBalance = context.watch<DashBoardViewModel>();
    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();
    commonWithdrawViewModel = context.watch<CommonWithdrawViewModel>();
    securityViewModel = context.watch<SecurityViewModel>();
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();

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
                ),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    fontfamily: 'InterTight',
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
                    fontfamily: 'InterTight',
                    text: getDashBoardBalance.isvisible
                        ? trimDecimalsForBalance('${getDashBoardBalance.total}')
                        : "****",
                    fontsize: 25,
                    fontWeight: FontWeight.bold),
                CustomText(
                    fontfamily: 'InterTight',
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
                        fontfamily: 'InterTight',
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
                            fontfamily: 'InterTight',
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
                              fontfamily: 'InterTight',
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
                      color:
                          themeSupport().isSelectedDarkMode() ? black : white,
                      multiClick: true,
                      press: () {
                        constant.walletCurrency.value = defaultCryptoCurrency;

                        commonWithdrawViewModel.setRadioValue(
                            SelectWallet.spot,
                            getDashBoardBalance
                                .availableBalanceForDefaultCryptoValue
                                .toString());
                        moveToCommonWithdrawView(
                            context,
                            CurrencyType.CRYPTO.toString(),
                            '${defaultCryptoCurrency}',
                            getDashBoardBalance
                                .availableBalanceForDefaultCryptoValue
                                .toString());
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
                      moveToCryptoDepositView(
                          context, CurrencyType.CRYPTO.toString());
                      // displayDialog(context, defaultCryptoCurrency);
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
                fontfamily: 'InterTight',
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
                        fontfamily: 'InterTight',
                        text: stringVariables.enable2Fa,
                        fontsize: 14,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        color: themeColor,
                        text: securityViewModel
                                    .viewModelVerification?.tfaStatus ==
                                'verified'
                            ? stringVariables.disable
                            : stringVariables.enable,
                        fontsize: 14,
                        press: () async {
                          if (securityViewModel
                                  .viewModelVerification?.tfaStatus ==
                              'verified') {
                            moveToDisableGoogleAuthenticator(
                              context,
                            );
                          } else {
                            moveToGoogleAuthenticateView(context);
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
                        fontfamily: 'InterTight',
                        text: stringVariables.identityVerification,
                        fontsize: 14,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
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
                        fontfamily: 'InterTight',
                        text: stringVariables.antiPhispingCode,
                        fontsize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        color: themeColor,
                        text: constant.antiCode.value == ""
                            ? stringVariables.create
                            : "",
                        fontsize: 14,
                        press: () {
                          if (securityViewModel
                                      .viewModelVerification?.tfaStatus ==
                                  "verified" ||
                              securityViewModel
                                      .viewModelVerification
                                      ?.tfaAuthentication
                                      ?.mobileNumber
                                      ?.status ==
                                  "verified") {
                            moveToVerifyCode(
                                context,
                                AuthenticationVerificationType.dashBoard,
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
                                    ?.phoneNumber);
                          } else {
                            customSnackBar.showSnakbar(
                                context,
                                stringVariables.enableTfa,
                                SnackbarType.negative);
                          }
                        },
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
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
                          fontfamily: 'InterTight',
                          text: stringVariables.antiPhispingCode + " : ",
                          fontsize: 15),
                      securityViewModel
                                  .viewModelVerification?.antiPhishingCode ==
                              ''
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
        context.watch<DashBoardViewModel>().findAddress?.qrCode != null
            ? Image.memory(base64.decode(
                '${context.watch<DashBoardViewModel>().findAddress?.qrCode}'
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
                  fontfamily: 'InterTight'),
              CustomText(
                  text: '  ${constant.cryptoCurrency.value}',
                  fontsize: 21,
                  fontWeight: FontWeight.bold,
                  fontfamily: 'InterTight')
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
                  fontfamily: 'InterTight',
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
                  fontfamily: 'InterTight',
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
                      fontfamily: 'InterTight',
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
                            context,
                            stringVariables.addressCopied,
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
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: stringVariables.important.toUpperCase(),
                fontfamily: 'InterTight',
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
                text:
                    "${stringVariables.deposit} ${constant.cryptoCurrency.value} ${stringVariables.addressOnly}",
                fontfamily: 'InterTight',
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
