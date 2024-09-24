import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/LoginPasswordChange/ViewModel/LoginPasswordChangeViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';

import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';

class LoginPasswordChangeView extends StatefulWidget {
  final bool socialMediaFlag;

  const LoginPasswordChangeView({Key? key, required this.socialMediaFlag})
      : super(key: key);

  @override
  State<LoginPasswordChangeView> createState() =>
      _LoginPasswordChangeViewState();
}

class _LoginPasswordChangeViewState extends State<LoginPasswordChangeView> {
  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  FocusNode? focusNode1;
  FocusNode? focusNode2;
  FocusNode? focusNode3;
  GlobalKey<FormFieldState> field1Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field3Key = GlobalKey<FormFieldState>();
  final formKey = GlobalKey<FormState>();
  int count = 0;

  @override
  void initState() {
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode1!.addListener(() {
      if (!focusNode1!.hasFocus) {
        field1Key.currentState!.validate();
      }
    });
    focusNode2!.addListener(() {
      if (!focusNode2!.hasFocus) {
        field2Key.currentState!.validate();
      }
    });
  }

  @override
  void dispose() {
    focusNode1!.dispose();
    focusNode2!.dispose();
    super.dispose();
  }

  late LoginPasswordChangeViewModel loginPasswordChangeViewModel;

  Widget build(BuildContext context) {
    loginPasswordChangeViewModel =
        context.watch<LoginPasswordChangeViewModel>();
    return Provider<LoginPasswordChangeViewModel>(
        create: (context) => LoginPasswordChangeViewModel(),
        child: Builder(
          builder: (context) {
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
                            Navigator.of(context).popUntil((_) => count++ >= 2);
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
                          fontsize: 22,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          text: stringVariables.security,
                          color: themeSupport().isSelectedDarkMode()
                              ? white
                              : black,
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
                      CustomCard(
                        radius: 25,
                        edgeInsets: 4,
                        outerPadding: 8,
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildCustomHeader(),
                            // if (!widget.socialMediaFlag)
                            buildOldPasswordView(),
                            buildNewPasswordView(),
                            buildConfirmNewPasswordView(),
                            buildSubmitConfirmChanges(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  /// Custom header
  Widget buildCustomHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 20),
          child: CustomText(
            text: stringVariables.loginPassword,
            fontWeight: FontWeight.bold,
            fontsize: 20,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
        ),
        CustomSizedBox(
          height: 0.03,
        )
      ],
    );
  }

  /// oldPassword TextFormField with Text
  Widget buildOldPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 15),
          child: CustomText(
            text: stringVariables.oldPassword,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: CustomTextFormField(
              size: 30,
              keys: field1Key,
              isContentPadding: false,
              text: stringVariables.hintOldPassword,
              isBorderedButton: loginPasswordChangeViewModel.oldPasswordVisible,
              controller: oldPassword,
              autovalid: AutovalidateMode.onUserInteraction,
              focusNode: focusNode1,
              validator: (input) => input!.isEmpty
                  ? stringVariables.passwordRequired
                  : input.isValidPassword()
                      ? null
                      : stringVariables.passwordValidation,
              suffixIcon: CustomIconButton(
                onPress: () {
                  loginPasswordChangeViewModel.changeOldPasswordIcon();
                },
                child: Icon(
                  loginPasswordChangeViewModel.oldPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
              )),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// newPassword TextFormField with Text
  Widget buildNewPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10),
          child: CustomText(
            text: stringVariables.newPassword,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              keys: field2Key,
              text: stringVariables.hintNewPassword,
              isBorderedButton: loginPasswordChangeViewModel.newPasswordVisible,
              controller: newPassword,
              autovalid: AutovalidateMode.onUserInteraction,
              focusNode: focusNode2,
              validator: (input) => input!.isEmpty
                  ? stringVariables.passwordRequired
                  : input.isValidPassword()
                      ? null
                      : stringVariables.passwordValidation,
              suffixIcon: CustomIconButton(
                onPress: () {
                  loginPasswordChangeViewModel.changeNewPasswordIcon();
                },
                child: Icon(
                  loginPasswordChangeViewModel.newPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
              )),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// confirmNewPassword TextFormField with Text
  Widget buildConfirmNewPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 10),
          child: CustomText(
            text: stringVariables.confirmNewPassword,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              keys: field3Key,
              text: stringVariables.hintNewConfirmPassword,
              isBorderedButton:
                  loginPasswordChangeViewModel.confirmPasswordVisible,
              controller: confirmPassword,
              autovalid: AutovalidateMode.onUserInteraction,
              focusNode: focusNode3,
              validator: (val) {
                if (val!.isEmpty) {
                  return stringVariables.confirmPasswordRequired;
                }
                if (val != newPassword.text) {
                  return stringVariables.newConfirmPasswordSame;
                }
                return null;
              },
              suffixIcon: CustomIconButton(
                onPress: () {
                  loginPasswordChangeViewModel.changeConfirmPasswordIcon();
                },
                child: Icon(
                  loginPasswordChangeViewModel.confirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: iconColor,
                ),
              )),
        ),
        CustomSizedBox(
          height: 0.04,
        ),
      ],
    );
  }

  ///submit Confirm Changes
  Widget buildSubmitConfirmChanges() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: CustomElevatedButton(
              text: stringVariables.confirmChanges,
              color: themeSupport().isSelectedDarkMode() ? black : white,
              multiClick: true,
              press: () {
                loginPasswordChangeViewModel.hasInputError1 =
                    true; //Check your conditions on text variable
                loginPasswordChangeViewModel.hasInputError2 =
                    true; //Check your conditions on text variable

                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                if (formKey.currentState!.validate()) {
                  if (oldPassword.text.isNotEmpty &&
                      newPassword.text.isNotEmpty &&
                      confirmPassword.text.isNotEmpty) {
                    getUsertypedDetails(context, loginPasswordChangeViewModel);
                  }
                }
              },
              radius: 25,
              buttoncolor: themeColor,
              width: 1.13,
              height: MediaQuery.of(context).size.height / 50,
              isBorderedButton: false,
              maxLines: 1,
              icons: false,
              icon: null),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  getUsertypedDetails(
    BuildContext context,
    LoginPasswordChangeViewModel loginPasswordChangeViewModel,
  ) {
    if (newPassword.text != "" &&
        oldPassword.text != "" &&
        confirmPassword.text != "" &&
        newPassword.text == confirmPassword.text &&
        oldPassword.text != confirmPassword.text &&
        newPassword.text == confirmPassword.text) {
      loginPasswordChangeViewModel.getPasswordResponse(
        oldPassword.text,
        newPassword.text,
        confirmPassword.text,
        context,
      ); //widget.socialMediaFlag
      Navigator.of(context);
    }
  }
}
