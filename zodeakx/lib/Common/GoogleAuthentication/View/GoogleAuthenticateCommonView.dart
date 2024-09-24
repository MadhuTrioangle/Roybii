import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTimeLine.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomOtpInputBox.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
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

  @override
  void initState() {
    viewModel =
        Provider.of<GoogleAuthenticateCommonViewModel>(context, listen: false);
    viewModel.getSecretCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<GoogleAuthenticateCommonViewModel>();
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
                    if (password.text != "" &&
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
                        password.text.isEmpty) {
                      customSnackBar.showSnakbar(context,
                          "Please Fill All Fields", SnackbarType.negative);
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
          text: "Step 1",
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
      throw 'Could not launch $_url';
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
      throw 'Could not launch $url';
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
          text: "Step 2",
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
    Image image = viewModel
        ?.getTFA
        ?.url !=
        null
        ? Image.memory(base64.decode(
        '${viewModel?.getTFA?.url}'
            .split(',')
            .last))
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
              text:
                  '${viewModel.getTFA?.secret ?? stringVariables.loading}',
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
          text: "Step 3",
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
                )),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              align: TextAlign.center,
              strutStyleHeight: 1.5,
              text:
                  '${viewModel.getTFA?.secret ?? stringVariables.loading}',
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
          text: "Step 4",
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

  ///user password and Otp
  Widget passwordAndOtp(
    BuildContext context,
    GoogleAuthenticateCommonViewModel viewModel,
  ) {
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
            fontfamily: 'GoogleSans',
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
                input!.isEmpty ? 'Password is required' : null,
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
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 18,
          ),
          child: CustomText(
            text: stringVariables.googleAuthenticationCode,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
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
                            fieldOneText = '\u200B';
                            fieldOne.text = '\u200B';
                            fieldOne.clear();
                          } else {
                            fieldOneText = value;
                          }
                          (fieldOneText == '\u200B')
                              ? (() {})
                              : FocusScope.of(context).nextFocus();
                        } else {
                          fieldOneText = '\u200B';
                          fieldOne.text = '\u200B';
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
                          fieldTwoText = '\u200B';
                          fieldTwo.clear();
                        } else {
                          fieldTwoText = value;
                        }
                        (fieldTwoText == '\u200B')
                            ? (() {
                                fieldTwo.text = '\u200B';
                              })
                            : FocusScope.of(context).nextFocus();
                      } else if (value.length == 0 && fieldTwoText != "") {
                        fieldTwo.text = '\u200B';
                        fieldTwoText = '\u200B';
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
                            fieldThreeText = '\u200B';
                            fieldThree.clear();
                          } else {
                            fieldThreeText = value;
                          }
                          (fieldThreeText == '\u200B')
                              ? (() {
                                  fieldThree.text = '\u200B';
                                })
                              : FocusScope.of(context).nextFocus();
                        } else if (value.length == 0 && fieldThreeText != "") {
                          fieldThree.text = '\u200B';
                          fieldThreeText = '\u200B';
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
                            fieldFourText = '\u200B';
                            fieldFour.clear();
                          } else {
                            fieldFourText = value;
                          }
                          (fieldFourText == '\u200B')
                              ? (() {
                                  fieldFour.text = '\u200B';
                                })
                              : FocusScope.of(context).nextFocus();
                        } else if (value.length == 0 && fieldFourText != "") {
                          fieldFour.text = '\u200B';
                          fieldFourText = '\u200B';
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
                          fieldFifthText = '\u200B';
                          fieldFifth.clear();
                        } else {
                          fieldFifthText = value;
                        }
                        (fieldFifthText == '\u200B')
                            ? (() {
                                fieldFifth.text = '\u200B';
                              })
                            : FocusScope.of(context).nextFocus();
                      } else if (value.length == 0 && fieldFifthText != "") {
                        fieldFifth.text = '\u200B';
                        fieldFifthText = '\u200B';
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
                          fieldSixthText = '\u200B';
                          fieldSixth.clear();
                        } else {
                          fieldSixthText = value;
                        }
                      } else if (value.length == 0 && fieldSixthText != "") {
                        fieldSixth.text = '\u200B';
                        fieldSixthText = '\u200B';
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
    if (password.text != "" &&
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
      var pop = await viewModel.createGoogleAuthenticate(
          password.text, context, codeAppend, stateKey);
      // Navigator.pop(context,true);
      if (pop) {
        popContext(true);
      }
    } else {
      customSnackBar.showSnakbar(
          context, "Enter Email and code", SnackbarType.negative);
    }
  }
}
