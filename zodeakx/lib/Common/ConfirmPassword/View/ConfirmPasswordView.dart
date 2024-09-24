import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/ConfirmPassword/ViewModel/ConfirmPasswordViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';

class ConfirmPasswordView extends StatefulWidget {
  const ConfirmPasswordView({Key? key}) : super(key: key);

  @override
  State<ConfirmPasswordView> createState() => _ConfirmPasswordViewState();
}

class _ConfirmPasswordViewState extends State<ConfirmPasswordView> {
  bool isChecked = false;
  bool confirmPasswordVisible = false;
  FocusNode? focusNode1;
  FocusNode? focusNode2;
  GlobalKey<FormFieldState> field1Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late ConfirmPasswordViewModel confirmPasswordViewModel;

  @override
  void initState() {
    super.initState();
    confirmPasswordViewModel =
        Provider.of<ConfirmPasswordViewModel>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    confirmPasswordViewModel = context.watch<ConfirmPasswordViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (confirmPasswordViewModel.showSnackbar)
          ? customSnackBar.showSnakbar(
              context,
              confirmPasswordViewModel.newPasswordResponse?.statusMessage ?? "",
              (confirmPasswordViewModel.positiveStatus)
                  ? SnackbarType.positive
                  : SnackbarType.negative)
          : '';
      confirmPasswordViewModel.showSnackbar = false;
    });

    return Provider<ConfirmPasswordViewModel>(
      create: (context) => confirmPasswordViewModel,
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
                ],
              ),
            ),
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        buildPasswordView(),
                        buildConfirmPasswordView(),
                        buildSubmitPassword(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Header Text
  Widget buildCustomHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 25, bottom: 15),
          child: CustomText(
            text: stringVariables.newPassword,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 18,
          ),
        ),
      ],
    );
  }

  /// Password TextFormField with Text
  Widget buildPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 18),
          child: CustomText(
            text: stringVariables.password,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4),
          child: CustomTextFormField(
              size: 30,
              text: stringVariables.hintPassword,
              isBorderedButton: confirmPasswordViewModel.passwordVisible,
              controller: password,
              keys: field1Key,
              autovalid: AutovalidateMode.onUserInteraction,
              focusNode: focusNode1,
              validator: (input) => input!.isEmpty
                  ? 'Password is required'
                  : input.isValidPassword()
                      ? null
                      : "Must contain number, uppercase, special, \nlowercase and min 8 characters",
              isContentPadding: false,
              suffixIcon: CustomIconButton(
                onPress: () {
                  confirmPasswordViewModel.changePasswordIcon();
                },
                child: Icon(
                  confirmPasswordViewModel.passwordVisible
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

  /// Confirm Password TextFormField with Text
  Widget buildConfirmPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 10),
          child: CustomText(
            text: stringVariables.confirmPassword,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4),
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              text: stringVariables.hintConfirmPassword,
              keys: field2Key,
              isBorderedButton: confirmPasswordViewModel.confirmPasswordVisible,
              color: DarkAndLightMode().textColor,
              autovalid: AutovalidateMode.onUserInteraction,
              controller: confirmPassword,
              focusNode: focusNode2,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Confirm Password is required';
                }
                if (val != password.text) {
                  return 'New Password and Confirm Password \nMust be Same';
                }
                return null;
              },
              suffixIcon: CustomIconButton(
                onPress: () {
                  confirmPasswordViewModel.changeConfirmPasswordIcon();
                },
                child: Icon(
                  confirmPasswordViewModel.confirmPasswordVisible
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

  /// Get user details from User
  getUsertypedDetails(
      ConfirmPasswordViewModel confirmPasswordViewModel, context) {
    if (confirmPassword.text != "" && password.text != "") {
      confirmPasswordViewModel.confirmPassword(
          confirmPassword.text, password.text, context);
    } else {
      customSnackBar.showSnakbar(
          context, "Enter Correct Password", SnackbarType.negative);
    }
  }

  ///submit new password
  Widget buildSubmitPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 7, right: 7, bottom: 15),
      child: (confirmPasswordViewModel.needToLoad)
          ? const CustomLoader()
          : CustomElevatedButton(
              text: stringVariables.submit,
              color: black,
              multiClick: true,
              press: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                if (formKey.currentState!.validate()) {
                  if (password.text.isNotEmpty &&
                      confirmPassword.text.isNotEmpty &&
                      email.text.isEmpty &&
                      password.text == confirmPassword.text) {
                    getUsertypedDetails(confirmPasswordViewModel, context);
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
