import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/VerifyGoogleAuthCode/ViewModel/VerifyGoogleAuthenticateViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomOtpInputBox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class VerifyGoogleAuthView extends StatefulWidget {
  AuthenticationVerificationType screenType;

  VerifyGoogleAuthView({
    Key? key,
    required this.screenType,
  }) : super(key: key);

  @override
  State<VerifyGoogleAuthView> createState() => _VerifyGoogleAuthViewState();
}

class _VerifyGoogleAuthViewState extends State<VerifyGoogleAuthView> {
  final TextEditingController loginPassword = TextEditingController();
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
  late VerifyGoogleAuthenticationViewModel verifyGoogleAuthenticationViewModel;

  @override
  Widget build(BuildContext context) {
    verifyGoogleAuthenticationViewModel =
        context.watch<VerifyGoogleAuthenticationViewModel>();
    return Provider<VerifyGoogleAuthenticationViewModel>(
      create: (context) => VerifyGoogleAuthenticationViewModel(),
      builder: (context, child) {
        return CustomScaffold(
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
                        Navigator.pop(
                            context, AuthenticationVerificationType.dashBoard);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SvgPicture.asset(
                          backArrow,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildAppLogo(),
                CustomCard(
                  radius: 25,
                  edgeInsets: 8,
                  outerPadding: 18,
                  elevation: 0,
                  child: Column(
                    children: [buildGoogleAuthenticationCode()],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// App Logo
  Widget buildAppLogo() {
    return Column(
      children: [
        Center(
          child: themeSupport().isSelectedDarkMode()
              ? CustomContainer(
                  height: 13.0,
                  width: 1.0,
                  child: SvgPicture.asset(
                    lightlogo,
                  ),
                )
              : CustomContainer(
                  height: 13.0,
                  width: 1.0,
                  child: SvgPicture.asset(
                    darklogo,
                  ),
                ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// google Authentication code
  Widget buildGoogleAuthenticationCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: CustomText(
            text: stringVariables.googleAuthenticationCode,
            fontsize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 20),
          child: CustomText(
            text: stringVariables.googleAuthInput,
            fontsize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.04,
        ),
        Row(
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

                      getAllOtpAndMutate(
                        context,
                      );
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
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  getAllOtpAndMutate(
    context,
  ) {
    if (fieldOne.text != "" &&
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
      (widget.screenType == AuthenticationVerificationType.AddPayment ||
              widget.screenType == AuthenticationVerificationType.EditPayment ||
              widget.screenType == AuthenticationVerificationType.PostAd ||
              widget.screenType == AuthenticationVerificationType.CloseAd ||
              widget.screenType == AuthenticationVerificationType.EditAd)
          ? verifyGoogleAuthenticationViewModel.verifiedCode(
              codeAppend, context, widget.screenType)
          : widget.screenType == AuthenticationVerificationType.AntiPhishing
              ? verifyGoogleAuthenticationViewModel.verifiedCode(
                  codeAppend, context, widget.screenType)
              : widget.screenType ==
                      AuthenticationVerificationType.ChangePassword
                  ? verifyGoogleAuthenticationViewModel.changeCode(
                      codeAppend, context)
                  : widget.screenType ==
                          AuthenticationVerificationType.fiatWithdrawSubmit
                      ? verifyGoogleAuthenticationViewModel.verifiedCode(
                          codeAppend, context, widget.screenType)
                      : widget.screenType ==
                              AuthenticationVerificationType.Login
                          ? verifyGoogleAuthenticationViewModel.verifyTfaCode(
                              codeAppend, context)
                          : widget.screenType ==
                                  AuthenticationVerificationType.dashBoard
                              ? verifyGoogleAuthenticationViewModel
                                  .verifiedCode(
                                      codeAppend, context, widget.screenType)
                              : widget.screenType ==
                                      AuthenticationVerificationType
                                          .cryptoWithdraw
                                  ? verifyGoogleAuthenticationViewModel
                                      .verifiedCode(codeAppend, context,
                                          widget.screenType)
                                  : verifyGoogleAuthenticationViewModel
                                      .verifiedCode(codeAppend, context,
                                          widget.screenType);
      FocusScope.of(context).unfocus();
    } else {
      customSnackBar.showSnakbar(
          context, "Enter all fields", SnackbarType.negative);
    }
  }
}
