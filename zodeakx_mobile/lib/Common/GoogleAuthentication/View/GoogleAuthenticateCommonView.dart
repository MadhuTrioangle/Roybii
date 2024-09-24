import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTimeLine.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomOtpInputBox.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import '../ViewModel/GoogleAuthenticateCommonViewModel.dart';

class GoogleAuthenticateCommonView extends StatefulWidget {
  const GoogleAuthenticateCommonView({Key? key}) : super(key: key);

  @override
  State<GoogleAuthenticateCommonView> createState() =>
      GoogleAuthenticateCommonViewState();
}

class GoogleAuthenticateCommonViewState
    extends State<GoogleAuthenticateCommonView> {
  int index = 0;
  final TextEditingController password = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fieldOne = TextEditingController();
  final TextEditingController fieldTwo = TextEditingController();
  final TextEditingController fieldThree = TextEditingController();
  final TextEditingController fieldFour = TextEditingController();
  final TextEditingController fieldFifth = TextEditingController();
  final TextEditingController fieldSixth = TextEditingController();
  String fieldOneText = '\u200B';
  String fieldTwoText = '\u200b';
  String fieldThreeText = '\u200b';
  String fieldFourText = '\u200B';
  String fieldFifthText = '\u200B';
  String fieldSixthText = '\u200B';
  final formKey = GlobalKey<FormState>();
  final stateKey = GlobalKey<GoogleAuthenticateCommonViewState>();
  late GoogleAuthenticateCommonViewModel viewModel;
  late SecurityViewModel securityViewModel;
  late FocusNode emailNode;
  GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    viewModel =
        Provider.of<GoogleAuthenticateCommonViewModel>(context, listen: false);
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    securityViewModel.getIdVerification();
    viewModel.getSecretCode();
    emailNode = FocusNode();

    validator(emailFieldKey, emailNode);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setRequestTimer(30);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<GoogleAuthenticateCommonViewModel>();
    bool passwordStatus =
        securityViewModel.viewModelVerification?.passwordStatus ?? false;
    return Provider<GoogleAuthenticateCommonViewModel>(
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
                      Navigator.pop(context, false);
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
                    fontsize: 18,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.googleAutheticate,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: CustomCard(
              outerPadding: 15,
              edgeInsets: 8,
              radius: 25,
              elevation: 0,
              child: CustomTimeLine(
                label2: '2',
                text4: stringVariables.done,
                label1: '1',
                text3: stringVariables.backupKey,
                text2: stringVariables.scanQrcode,
                label3: '3',
                text1: stringVariables.downloadapp,
                label4: '4',
                button1Color: index == 0 ? themeColor : textGrey,
                button2Color: index == 1 ? themeColor : textGrey,
                button3Color: index == 2 ? themeColor : textGrey,
                button4Color: index == 3 ? themeColor : textGrey,
                text1Color: index == 0 ? themeColor : textGrey,
                text2Color: index == 1 ? themeColor : textGrey,
                text3Color: index == 2 ? themeColor : textGrey,
                text4Color: index == 3 ? themeColor : textGrey,
                label1Color: index == 0 ? black : white,
                label2Color: index == 1 ? black : white,
                label3Color: index == 2 ? black : white,
                label4Color: index == 3 ? black : white,
                onTapFirstIndex: () {
                  viewModel.setActive(context, index = 0);
                  constant.googleAuthIndex.value = 0;
                },
                onTapSecondIndex: () {
                  viewModel.setActive(context, index = 1);
                  constant.googleAuthIndex.value = 1;
                },
                onTapThirdIndex: () {
                  viewModel.setActive(context, index = 2);
                  constant.googleAuthIndex.value = 2;
                },
                onTapFourthIndex: () {
                  viewModel.setActive(context, index = 3);
                  constant.googleAuthIndex.value = 3;
                },
                onTap: () {
                  if (index == 0) {
                    viewModel.setActive(context, index = 1);
                    download();
                    constant.googleAuthIndex.value = 1;
                  } else if (index == 1) {
                    viewModel.setActive(context, index = 2);
                    constant.googleAuthIndex.value = 2;
                  } else if (index == 2) {
                    viewModel.setActive(context, index = 3);
                    constant.googleAuthIndex.value = 3;
                  } else if (index == 3) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    if ((password.text != "") &&
                        fieldOne.text.isNotEmpty &&
                        fieldTwo.text.isNotEmpty &&
                        fieldThree.text.isNotEmpty &&
                        fieldFour.text.isNotEmpty &&
                        fieldFifth.text.isNotEmpty &&
                        fieldSixth.text.isNotEmpty) {
                      getUsertypedDetails(context, viewModel);
                    } else if (fieldOne.text == "" ||
                        fieldTwo.text == "" ||
                        fieldThree.text == "" ||
                        fieldFour.text == "" ||
                        fieldFifth.text == "" ||
                        fieldSixth.text == "" ||
                        (password.text.isEmpty)) {
                      customSnackBar.showSnakbar(
                          context,
                          stringVariables.pleaseFillFields,
                          SnackbarType.negative);
                    } else {
                      securedPrint("hiii");
                    }
                  }
                },
                child: index == 0
                    ? download()
                    : index == 1
                        ? qrCode(viewModel)
                        : index == 2
                            ? backUpKey(viewModel)
                            : googleAuthenticate(viewModel),
                text: index == 3
                    ? stringVariables.done.toUpperCase()
                    : stringVariables.next,
              )),
        ),
      ),
    );
  }

  /// index 1
  download() {
    return Center(
      child: Container(
        child: Column(
          children: [
            headerStep1(context),
            appStoreImage(context),
            //  navigateButton(context),
          ],
        ),
      ),
    );
  }

  ///Header of step 1
  Widget headerStep1(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step1,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.downloadAppHeader,
          fontsize: 13,
          color: textGrey,
          align: TextAlign.center,
        ),
        CustomSizedBox(
          height: 0.03,
        ),
      ],
    );
  }

  /// Appstore and Playstore Image
  Widget appStoreImage(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _launchUrl();
              },
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2.45,
                  child: SvgPicture.asset(
                    appStore,
                    fit: BoxFit.fill,
                  )),
            ),
            InkWell(
              onTap: () {
                _launchUrlAndroid();
              },
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2.45,
                  child: SvgPicture.asset(
                    playStore,
                    fit: BoxFit.fill,
                  )),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  void popContext(bool pop) {
    Navigator.pop(context, pop);
  }

  final Uri _url = Uri.parse(
      'https://apps.apple.com/in/app/google-authenticator/id388497605');

  /// iOS AppStore URL
  Future<void> _launchUrl() async {
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      throw '${stringVariables.couldNotLaunch} $_url';
    }
  }

  final Uri url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_IN&gl=US');

  /// Android PlayStore URL
  Future<void> _launchUrlAndroid() async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw '${stringVariables.couldNotLaunch} $url';
    }
  }

  /// index 2
  qrCode(GoogleAuthenticateCommonViewModel viewModel) {
    return Column(children: [
      headerStep2(context),
      qrAndCode(context, viewModel),

      //navigateButton(context,viewModel),
    ]);
  }

  /// header
  Widget headerStep2(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step2,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.qrCodeScannerHeader,
          align: TextAlign.center,
          fontsize: 13,
          color: textGrey,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// User QRCode and SecretCode
  Widget qrAndCode(
    BuildContext context,
    GoogleAuthenticateCommonViewModel viewModel,
  ) {
    Image image = viewModel?.getTFA?.url != null
        ? Image.memory(
            base64.decode('${viewModel?.getTFA?.url}'.split(',').last))
        : Image.asset(
            splash,
          );
    return Center(
      child: Column(
        children: [
          CustomContainer(
            width: 1,
            height: 5,
            child: FadeInImage(
              fit: BoxFit.fitHeight,
              placeholder: AssetImage(splash),
              image: image.image,
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            align: TextAlign.center,
            strutStyleHeight: 1.5,
            text: stringVariables.qrCodeScannerFooter,
            fontsize: 13,
            color: textGrey,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomContainer(
            width: 1.25,
            height: MediaQuery.of(context).size.height / 50,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            child: Center(
                child: CustomText(
              text: '${viewModel.getTFA?.secret ?? stringVariables.loading}',
              fontWeight: FontWeight.w500,
            )),
          ),
          CustomSizedBox(
            height: 0.03,
          ),
        ],
      ),
    );
  }

  ///index 3
  backUpKey(GoogleAuthenticateCommonViewModel viewModel) {
    return Column(
      children: [
        headersetp3(context),
        copyToastSecretCode(context, viewModel),
        // navigateButton(context),
      ],
    );
  }

  /// header
  Widget headersetp3(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step3,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          strutStyleHeight: 1.5,
          align: TextAlign.center,
          text: stringVariables.backupKeyHeader,
          fontsize: 13,
          color: textGrey,
        ),
        CustomSizedBox(
          height: 0.03,
        ),
      ],
    );
  }

  /// copy Secretcode
  Widget copyToastSecretCode(
    BuildContext context,
    GoogleAuthenticateCommonViewModel viewModel,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                          text:
                              '${viewModel.getTFA?.secret ?? stringVariables.loading}'))
                      .then((_) {
                    customSnackBar.showSnakbar(context,
                        stringVariables.copySnackBar, SnackbarType.positive);
                  });
                },
                child: SvgPicture.asset(
                  copySecretcode,
                  height: 25,
                  color: themeColor,
                )),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              align: TextAlign.center,
              strutStyleHeight: 1.5,
              text: '${viewModel.getTFA?.secret ?? stringVariables.loading}',
              fontsize: 14,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.03,
        ),
      ],
    );
  }

  ///index 4
  googleAuthenticate(GoogleAuthenticateCommonViewModel viewModel) {
    return Column(
      children: [
        headerStep4(context),
        passwordAndOtp(context, viewModel),
      ],
    );
  }

  ///Header for Step 4
  Widget headerStep4(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step4,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          strutStyleHeight: 1.2,
          align: TextAlign.center,
          text: stringVariables.googleAuthenticateandPasswordHeader,
          fontsize: 13,
          color: textGrey,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        viewModel.setRequestTimer(viewModel.requestTimer - 1);
        if (viewModel.requestTimer == 0) {
          viewModel.setRequestTimer(30);
          _timer?.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  Widget loginPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 18,
          ),
          child: CustomText(
            text: stringVariables.login + "  " + stringVariables.password,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
            size: 30,
            isContentPadding: false,
            controller: password,
            autovalid: AutovalidateMode.onUserInteraction,
            isBorderedButton: viewModel.passwordVisible,
            validator: (input) =>
                input!.isEmpty ? stringVariables.passwordRequired : null,
            text: stringVariables.hintPassword,
            //  isBorderedButton:registerViewModel.passwordVisible ,
            suffixIcon: CustomIconButton(
              onPress: () {
                viewModel.changeIcon();
              },
              child: Icon(
                viewModel.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: iconColor,
              ),
            )),
      ],
    );
  }

  Widget emailVerification() {
    String emailId = (constant.userEmail.value.substring(0, 2) +
        "*****@" +
        constant.userEmail.value.split("@").last);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 18,
          ),
          child: CustomText(
            text: stringVariables.emailVerificationCode,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
            size: 30,
            isContentPadding: false,
            controller: emailController,
            focusNode: emailNode,
            keys: emailFieldKey,
            autovalid: AutovalidateMode.onUserInteraction,
            text: stringVariables.emailVerificationHint,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            ],
            validator: (input) =>
                input!.isEmpty ? stringVariables.emailVerificationHint : null,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  press: () {
                    viewModel.sendEmailCode();
                    if (viewModel.requestTimer == 30) startTimer();
                  },
                  text: viewModel.requestTimer != 30
                      ? stringVariables.codeSent
                      : stringVariables.getCode,
                  fontsize: 15,
                  fontWeight: FontWeight.bold,
                  color: viewModel.requestTimer != 30 ? hintLight : themeColor,
                ),
                CustomSizedBox(
                  width: 0.04,
                )
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 9,
          ),
          child: Text.rich(
            softWrap: true,
            strutStyle: StrutStyle(height: 1.5),
            TextSpan(
                text: stringVariables.enter6DigitCode,
                style: TextStyle(
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                  fontSize: 15,
                  fontFamily: 'InterTight',
                  fontWeight: FontWeight.w500,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: " ",
                  ),
                  TextSpan(
                    text: emailId,
                    style: TextStyle(
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                      fontSize: 15,
                      fontFamily: 'InterTight',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
          ),
        ),
        if (viewModel.requestTimer != 30)
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              top: 9,
            ),
            child: CustomText(
              text: stringVariables.requestNewCode +
                  " ${viewModel.requestTimer} " +
                  stringVariables.seconds,
              fontsize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  ///user password and Otp
  Widget passwordAndOtp(
    BuildContext context,
    GoogleAuthenticateCommonViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loginPassword(),
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 18,
          ),
          child: CustomText(
            text: stringVariables.googleAuthenticationCode,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  child: CustomOtpInput(
                      controller: fieldOne,
                      autoFocus: true,
                      onChanged: (value) {
                        if (value.length == 1) {
                          if (value == "," ||
                              value == "." ||
                              value == "-" ||
                              value == ' ') {
                            fieldOneText = '\u200b';
                            fieldOne.text = '\u200b';
                            fieldOne.clear();
                          } else {
                            fieldOneText = value;
                          }
                          (fieldOneText == '\u200b')
                              ? (() {})
                              : FocusScope.of(context).nextFocus();
                        } else {
                          fieldOneText = '\u200b';
                          fieldOne.text = '\u200b';
                          fieldOne.clear();
                        }
                      })),
              Flexible(
                child: CustomOtpInput(
                    controller: fieldTwo,
                    autoFocus: true,
                    onChanged: (value) {
                      if (value.length == 1) {
                        fieldTwoText = value;
                        if (value == "," ||
                            value == "." ||
                            value == "-" ||
                            value == ' ') {
                          fieldTwoText = '\u200b';
                          fieldTwo.clear();
                        } else {
                          fieldTwoText = value;
                        }
                        (fieldTwoText == '\u200b')
                            ? (() {
                                fieldTwo.text = '\u200b';
                              })
                            : FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && fieldTwoText != "") {
                        fieldTwo.text = '\u200b';
                        fieldTwoText = '\u200b';
                        (fieldTwoText != '')
                            ? FocusScope.of(context).previousFocus()
                            : () {};
                      }
                    }),
              ),
              Flexible(
                  child: CustomOtpInput(
                      controller: fieldThree,
                      autoFocus: true,
                      onChanged: (value) {
                        if (value.length == 1) {
                          fieldThreeText = value;
                          if (value == "," ||
                              value == "." ||
                              value == "-" ||
                              value == ' ') {
                            fieldThreeText = '\u200b';
                            fieldThree.clear();
                          } else {
                            fieldThreeText = value;
                          }
                          (fieldThreeText == '\u200b')
                              ? (() {
                                  fieldThree.text = '\u200b';
                                })
                              : FocusScope.of(context).nextFocus();
                        } else if (value.length == 0 && fieldThreeText != "") {
                          fieldThree.text = '\u200b';
                          fieldThreeText = '\u200b';
                          (fieldThreeText != '')
                              ? FocusScope.of(context).previousFocus()
                              : () {};
                        }
                      })),
              Flexible(
                  child: CustomOtpInput(
                      controller: fieldFour,
                      autoFocus: true,
                      onChanged: (value) {
                        if (value.length == 1) {
                          fieldFourText = value;
                          if (value == "," ||
                              value == "." ||
                              value == "-" ||
                              value == ' ') {
                            fieldFourText = '\u200b';
                            fieldFour.clear();
                          } else {
                            fieldFourText = value;
                          }
                          (fieldFourText == '\u200b')
                              ? (() {
                                  fieldFour.text = '\u200b';
                                })
                              : FocusScope.of(context).nextFocus();
                        } else if (value.length == 0 && fieldFourText != "") {
                          fieldFour.text = '\u200b';
                          fieldFourText = '\u200b';
                          (fieldFourText != '')
                              ? FocusScope.of(context).previousFocus()
                              : () {};
                        }
                      })),
              Flexible(
                child: CustomOtpInput(
                    controller: fieldFifth,
                    autoFocus: true,
                    onChanged: (value) {
                      if (value.length == 1) {
                        fieldFifthText = value;
                        if (value == "," ||
                            value == "." ||
                            value == "-" ||
                            value == ' ') {
                          fieldFifthText = '\u200b';
                          fieldFifth.clear();
                        } else {
                          fieldFifthText = value;
                        }
                        (fieldFifthText == '\u200b')
                            ? (() {
                                fieldFifth.text = '\u200b';
                              })
                            : FocusScope.of(context).nextFocus();
                      } else if (value.length == 0 && fieldFifthText != "") {
                        fieldFifth.text = '\u200b';
                        fieldFifthText = '\u200b';
                        (fieldFifthText != '')
                            ? FocusScope.of(context).previousFocus()
                            : () {};
                      }
                    }),
              ),
              Flexible(
                child: CustomOtpInput(
                    controller: fieldSixth,
                    autoFocus: true,
                    onChanged: (value) {
                      if (value.length == 1) {
                        fieldSixthText = value;
                        if (value == "," ||
                            value == "." ||
                            value == "-" ||
                            value == ' ') {
                          fieldSixthText = '\u200b';
                          fieldSixth.clear();
                        } else {
                          fieldSixthText = value;
                        }
                      } else if (value.length == 0 && fieldSixthText != "") {
                        fieldSixth.text = '\u200b';
                        fieldSixthText = '\u200b';
                        (fieldSixthText != '')
                            ? FocusScope.of(context).previousFocus()
                            : () {};
                      }
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get user details from User
  getUsertypedDetails(
      BuildContext context, GoogleAuthenticateCommonViewModel viewModel) async {
    bool passwordStatus =
        securityViewModel.viewModelVerification?.passwordStatus ?? false;
    if ((password.text != "") &&
        fieldOne.text != "" &&
        fieldTwo.text != "" &&
        fieldThree.text != "" &&
        fieldFour.text != "" &&
        fieldFifth.text != "" &&
        fieldSixth.text != "") {
      var codeAppend = fieldOne.text +
          fieldTwo.text +
          fieldThree.text +
          fieldFour.text +
          fieldFifth.text +
          fieldSixth.text;
      viewModel.createGoogleAuthenticate(
          password.text, context, codeAppend, stateKey);
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.pleaseFillFields, SnackbarType.negative);
    }
  }
}
