import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomOtpInputBox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/ViewModel/SecurityViewModel.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../ViewModel/DiasbleGoogleAuthenticatorViewModel.dart';

class DiableGoogleAuthenticatorView extends StatefulWidget {
  const DiableGoogleAuthenticatorView({Key? key}) : super(key: key);

  @override
  State<DiableGoogleAuthenticatorView> createState() =>
      DiableGoogleAuthenticatorViewState();
}

class DiableGoogleAuthenticatorViewState
    extends State<DiableGoogleAuthenticatorView> {
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
  final formKey = GlobalKey<FormState>();
  final stateKey = GlobalKey<DiableGoogleAuthenticatorViewState>();
  bool otp = false;
  late SecurityViewModel securityViewModel;
  late DisableGoogleAuthenticatorChangeViewModel viewModel;

  @override
  void initState() {
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    securityViewModel.getIdVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<DisableGoogleAuthenticatorChangeViewModel>();
    return Provider<DisableGoogleAuthenticatorChangeViewModel>(
        create: (context) => viewModel,
        child: Builder(builder: (context) {
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
                  ],
                ),
              ),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildAppLogo(),
                    CustomCard(
                      radius: 25,
                      edgeInsets: 8,
                      outerPadding: 8,
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildCustomHeader(),
                        //  buildLoginPasswordView(context),
                          buildGoogleAuthenticationCode(),
                          buildSubmitConfirmChanges(),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  /// app logo
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

  /// customHeader
  Widget buildCustomHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 15,
          ),
          child: CustomText(
            text: stringVariables.disableGoogleAuthenticator,
            fontsize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  /// loginPassword TextFormField with Text
  Widget buildLoginPasswordView(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 25),
          child: CustomText(
            text: stringVariables.loginPassword,
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
            text: stringVariables.hintPassword,
            isBorderedButton: viewModel.loginPasswordVisible,
            controller: loginPassword,
            autovalid: AutovalidateMode.onUserInteraction,
            suffixIcon: CustomIconButton(
              onPress: () {
                viewModel.loginPasswordIcon();
              },
              child: Icon(
                viewModel.loginPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: iconColor,
              ),
            )),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  void popContext(bool pop) {
    Navigator.pop(context, pop);
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
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: CustomText(
            text: stringVariables.googleAuthenticationCode,
            fontsize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.04,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
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
        // CustomSizedBox(
        //   height: 0.03,
        // ),
      ],
    );
  }

  /// Get user details from User
  getUsertypedDetails(
      DisableGoogleAuthenticatorChangeViewModel viewModel, context) async {
    if (
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
      constant.googleAuthentciate.value = codeAppend;
      var pop = await viewModel.createGoogleAuthenticate(
           context, codeAppend, stateKey);
      if (pop) {
        popContext(true);
      }
    } else {
      customSnackBar.showSnakbar(
          context, "Enter Email and code", SnackbarType.negative);
    }
  }

  ///submit Disable Changes
  Widget buildSubmitConfirmChanges() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: CustomElevatedButton(
          multiClick: true,
          text: stringVariables.disable,
          color: black,
          press: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (formKey.currentState!.validate()) {
              if (
                  fieldOne.text != "" &&
                  fieldTwo.text != "" &&
                  fieldThree.text != "" &&
                  fieldFour.text != "" &&
                  fieldFifth.text != "" &&
                  fieldSixth.text != "") {
                getUsertypedDetails(viewModel, context);
              } else if (fieldOne.text == "" ||
                  fieldTwo.text == "" ||
                  fieldThree.text == "" ||
                  fieldFour.text == "" ||
                  fieldFifth.text == "" ||
                  fieldSixth.text == "" ) {
                customSnackBar.showSnakbar(
                    context, "Please Fill All Fields", SnackbarType.negative);
              }
            }
          },
          radius: 25,
          buttoncolor: themeColor,
          width: 0.0,
          height: MediaQuery.of(context).size.height / 50,
          isBorderedButton: false,
          maxLines: 1,
          icons: false,
          icon: null),
    );
  }
}
