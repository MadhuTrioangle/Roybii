import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/EmailVerificationScreen/ViewModel/EmailVerificationViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomOtpInputBox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';

class EmailVerificationScreen extends StatefulWidget {
  String screenTitle;
  String userEmail;
  int tempOTP;
  EmailVerificationType verficationType;
  String tokenType;

  EmailVerificationScreen(
      {Key? key,
      required this.screenTitle,
      required this.tempOTP,
      required this.userEmail,
      required this.verficationType,
      required this.tokenType})
      : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController fieldOne = TextEditingController(text: "\u200B");
  final TextEditingController fieldTwo = TextEditingController(text: "\u200b");
  final TextEditingController fieldThree =
      TextEditingController(text: "\u200b");
  final TextEditingController fieldFour = TextEditingController(text: "\u200B");
  final TextEditingController fieldFifth =
      TextEditingController(text: "\u200B");
  final TextEditingController fieldSixth =
      TextEditingController(text: "\u200B");

  String fieldOneText = '\u200B';
  String fieldTwoText = '\u200b';
  String fieldThreeText = '\u200b';
  String fieldFourText = '\u200B';
  String fieldFifthText = '\u200B';
  String fieldSixthText = '\u200B';

  FocusNode? focusNode = FocusNode();
  late EmailVerificationViewModel eamilVerificationViewModel;

  @override
  void initState() {
    super.initState();
    fieldTwo.addListener(() {
      getDataFromTextField();
    });
  }

  getDataFromTextField() {}

  @override
  Widget build(BuildContext context) {
    eamilVerificationViewModel = context.watch<EmailVerificationViewModel>();
    return Provider<EmailVerificationViewModel>(
      create: (context) => eamilVerificationViewModel,
      builder: (context, child) {
        return CustomScaffold(
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
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        eamilVerificationViewModel.setLoading(false);

                        int count = 0;
                        if (widget.verficationType ==
                            EmailVerificationType.ReactivateAccount) {
                          eamilVerificationViewModel.countDown = 30;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        } else {
                          eamilVerificationViewModel.countDown = 30;
                          Navigator.pop(
                            context,
                          );
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
                  ),
                ],
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildImageWithText(),
                buildVerificationCode(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// imageWithText
  Widget buildImageWithText() {
    String maskedMail = widget.userEmail.substring(0, 2);

    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Center(
          child: CustomContainer(
            padding: 10,
            height: 8.0,
            width: 1.0,
            child: SvgPicture.asset(
              envelope,
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        CustomText(
          text: widget.screenTitle,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
          fontsize: 22,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: stringVariables.emailVerification,
          overflow: TextOverflow.ellipsis,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.sendMail,
          overflow: TextOverflow.ellipsis,
          fontsize: 14,
          color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text:
              '${stringVariables.addressLower}: ${maskedMail == '' ? "ab@gmail.com" : '$maskedMail****${widget.userEmail.substring(widget.userEmail.indexOf('@'))}'}',
          color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
          overflow: TextOverflow.ellipsis,
          fontsize: 14,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: stringVariables.instructionMail,
          overflow: TextOverflow.ellipsis,
          fontsize: 14,
          color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
        ),
        CustomSizedBox(
          height: 0.04,
        ),
      ],
    );
  }

  ///OTP Verification with Text
  Widget buildVerificationCode() {
    return CustomCard(
      radius: 25,
      edgeInsets: 2,
      outerPadding: 8,
      elevation: 0,
      color: themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.04,
          ),
          CustomText(
            text: stringVariables.verificationCode,
            fontsize: 18,
            fontWeight: FontWeight.bold,
          ),
          CustomSizedBox(
            height: 0.04,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
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
                          } else if (value.length == 0 &&
                              fieldThreeText != "") {
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
          ),
          buildInstruction(),
          buildResendMail(),
          CustomSizedBox(
            height: 0.03,
          ),
        ],
      ),
    );
  }

  /// Instruction
  Widget buildInstruction() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: stringVariables.instruction,
            align: TextAlign.center,
            strutStyleHeight: 1.3,
            fontsize: 11,
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
        ],
      ),
    );
  }

  /// Resend Mail
  Widget buildResendMail() {
    return (eamilVerificationViewModel.needToLoad)
        ? CustomLoader()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CustomText(
                    text: stringVariables.resendMail +
                        ((eamilVerificationViewModel.countDown != 30 &&
                                eamilVerificationViewModel.countDown != 0)
                            ? " (${eamilVerificationViewModel.countDown}) "
                            : ""),
                    press: () {
                      (eamilVerificationViewModel.countDown == 30)
                          ? eamilVerificationViewModel.resendEmail(
                              context, widget.tokenType)
                          : () {};
                    },
                    fontsize: 18,
                    color: themeColor,
                  ),
                ),
              ),
              CustomIconButton(
                onPress: () {
                  (eamilVerificationViewModel.countDown == 30)
                      ? eamilVerificationViewModel.resendEmail(
                          context, widget.tokenType)
                      : () {};
                },
                child: SvgPicture.asset(
                  arrowCircle,
                  color: themeColor,
                ),
              )
            ],
          );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    if (LogicalKeyboardKey.period.keyLabel.toLowerCase() == event.logicalKey) {
    } else {}
    return event.logicalKey == LogicalKeyboardKey.keyQ
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
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

      widget.verficationType == EmailVerificationType.ReactivateAccount
          ? eamilVerificationViewModel.reactivateUser(
              context, codeAppend, widget.tokenType)
          : (widget.verficationType == EmailVerificationType.NewdeviceLogin)
              ? eamilVerificationViewModel.newDeviceLogin(
                  context, codeAppend, widget.tokenType)
              : (widget.verficationType == EmailVerificationType.ResetPassword)
                  ? constant.tokenType.value == 'ForgetPassword'
                      ? eamilVerificationViewModel.resetPassword(
                          context,
                          int.parse(codeAppend),
                          widget.tokenType,
                          widget.userEmail)
                      : eamilVerificationViewModel.verifyRegisterEmail(
                          context, codeAppend, widget.tokenType)
                  : eamilVerificationViewModel.verifyEmail(
                      context, codeAppend, widget.tokenType);
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      customSnackBar.showSnakbar(
          context, stringVariables.allFields, SnackbarType.negative);
    }
  }
}
