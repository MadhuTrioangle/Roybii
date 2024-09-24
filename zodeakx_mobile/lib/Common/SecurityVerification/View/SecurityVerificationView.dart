import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/Security/ViewModel/SecurityViewModel.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../ViewModel/SecurityVerificationViewModel.dart';

class SecurityVerificationView extends StatefulWidget {
  const SecurityVerificationView({Key? key}) : super(key: key);

  @override
  State<SecurityVerificationView> createState() =>
      SecurityVerificationViewState();
}

class SecurityVerificationViewState extends State<SecurityVerificationView> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final stateKey = GlobalKey<SecurityVerificationViewState>();
  late SecurityViewModel securityViewModel;
  late SecurityVerificationViewModel viewModel;
  late FocusNode emailNode;
  GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  late Timer _timer;

  @override
  void initState() {
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    securityViewModel.getIdVerification();
    emailNode = FocusNode();

    validator(emailFieldKey, emailNode);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setRequestTimer(30);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<SecurityVerificationViewModel>();
    return Provider<SecurityVerificationViewModel>(
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
                          emailVerification(),
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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        viewModel.setRequestTimer(viewModel.requestTimer - 1);
        if (viewModel.requestTimer == 0) {
          viewModel.setRequestTimer(30);
          _timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
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
            validator: (input) =>
                input!.isEmpty ? stringVariables.emailVerificationHint : null,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            ],
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
        CustomSizedBox(
          height: 0.04,
        ),
      ],
    );
  }

  /// app logo
  Widget buildAppLogo() {
    return Column(
      children: [
        Center(
          child: CustomContainer(
            padding: 10,
            height: 13.0,
            width: 1.0,
            child: SvgPicture.asset(
              themeSupport().isSelectedDarkMode() ? lightlogo : darklogo,
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
            text: stringVariables.securityVerification,
            fontsize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  void popContext(bool pop) {
    Navigator.pop(context, pop);
  }

  /// Get user details from User
  getUsertypedDetails() async {
    if (emailController.text != "") {
      viewModel.verifyEmailCode(emailController.text);
    } else {
      customSnackBar.showSnakbar(context, stringVariables.emailVerificationHint,
          SnackbarType.negative);
    }
  }

  ///submit Disable Changes
  Widget buildSubmitConfirmChanges() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: CustomElevatedButton(
          multiClick: true,
          text: stringVariables.submit,
          color: themeSupport().isSelectedDarkMode() ? black : white,
          press: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (formKey.currentState!.validate()) {
              if (emailController.text != "") {
                getUsertypedDetails();
              } else if (emailController.text.isEmpty) {
                customSnackBar.showSnakbar(context,
                    stringVariables.pleaseFillFields, SnackbarType.negative);
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
