import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/ForgotPasswordScreen/ViewModel/ForgotPasswordViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../LoginScreen/ViewModel/LoginViewModel.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late ForgotPasswordViewModel forgotPasswordViewModel;

  @override
  void initState() {
    super.initState();
    forgotPasswordViewModel =
        Provider.of<ForgotPasswordViewModel>(context, listen: false);
    email.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    forgotPasswordViewModel = context.watch<ForgotPasswordViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (forgotPasswordViewModel.showSnackbar)
          ? customSnackBar.showSnakbar(
              context,
              forgotPasswordViewModel
                      .forgotPasswordUserResponse?.statusMessage ??
                  "",
              (forgotPasswordViewModel.positiveStatus)
                  ? SnackbarType.positive
                  : SnackbarType.negative)
          : '';
      forgotPasswordViewModel.showSnackbar = false;
    });

    return Provider<ForgotPasswordViewModel>(
      create: (context) => forgotPasswordViewModel,
      child: Builder(builder: (context) {
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
                        var listenViewModel =
                            Provider.of<LoginViewModel>(context, listen: false);
                        listenViewModel.closeFocus();
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
                    edgeInsets: 2,
                    outerPadding: 8,
                    elevation: 0,
                    color: themeSupport().isSelectedDarkMode()
                        ? darkCardColor
                        : lightCardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCustomHeader(),
                        buildEmailView(),
                        buildNavigatorEmailVerification(),
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
          padding: const EdgeInsets.only(left: 15.0, top: 15, bottom: 15),
          child: CustomText(
            text: stringVariables.resetYourPassword,
            overflow: TextOverflow.visible,
            maxlines: 1,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 20,
          ),
        ),
      ],
    );
  }

  /// Email TextFormField with Text
  Widget buildEmailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 12),
          child: CustomText(
            text: stringVariables.emailId,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomTextFormField(
            color: themeSupport().isSelectedDarkMode()
                ? marketCardColor
                : lightSearchBarColor,
            size: 16,
            hintColor: stackCardText,
            isContentPadding: false,
            controller: email,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => input!.isEmpty
                ? stringVariables.emailRequirement
                : input.isValidEmail()
                    ? null
                    : stringVariables.validEmailAddress,
            text: stringVariables.emailId),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// App logo
  Widget buildAppLogo() {
    return Column(
      children: [
        Center(
          child: CustomContainer(
            padding: 10,
            height: 8.0,
            width: 1.0,
            child: SvgPicture.asset(
              reset,
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.resetPassword,
          fontWeight: FontWeight.bold,
          fontsize: 25,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.registeredEmailToResetPassword,
          fontsize: 15.5,
          color: stackCardText,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  /// Get forgot password details from User
  getForgotPasswordDetails(
      ForgotPasswordViewModel forgotPasswordViewModel, context) {
    if (email.text != "") {
      forgotPasswordViewModel.forgotPassword(email.text, context);
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.validEmail, SnackbarType.negative);
    }
  }

  ///navigate to email verification screen
  Widget buildNavigatorEmailVerification() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 12, right: 12, bottom: 22),
      child: (forgotPasswordViewModel.needToLoad)
          ? const CustomLoader()
          : CustomElevatedButton(
              text: stringVariables.submit,
              color: white,
              multiClick: true,
              press: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                if (formKey.currentState!.validate()) {
                  if (email.text.isNotEmpty) {
                    getForgotPasswordDetails(forgotPasswordViewModel, context);
                  }
                }
              },
              radius: 25,
              buttoncolor: themeColor,
              fillColor: themeColor,
              width: 0.0,
              height: MediaQuery.of(context).size.height / 50,
              isBorderedButton: false,
              maxLines: 1,
              fontSize: 16.5,
              fontWeight: FontWeight.w500,
              icons: false,
              icon: null),
    );
  }
}
