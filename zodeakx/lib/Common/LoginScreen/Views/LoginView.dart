import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/ForgotPasswordScreen/View/ForgotPasswordView.dart';
import 'package:zodeakx_mobile/Common/LoginScreen/ViewModel/LoginViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../RegisterScreen/Views/RegisterView.dart';

class LoginView extends StatefulWidget {
  ScreenType? verficationType;

  LoginView({Key? key, this.verficationType}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isChecked = false;
  FocusNode? focusNode1;
  FocusNode? focusNode2;
  GlobalKey<FormFieldState> field1Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  late LoginViewModel loginViewModel;
  final formKey = GlobalKey<FormState>();
  var clicked = true;

  @override
  void initState() {
    loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    loginViewModel.getIdVerification();
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  getReactivateMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    constant.reactivateMessage.value = prefs.getString("reactivate").toString();
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    Future<bool> willPopScopeCall() async {
      return true; // return true to exit app or return false to cancel exit
    }

    loginViewModel = context.watch<LoginViewModel>();
    loginViewModel.verificationType = widget.verficationType;

    return Provider<LoginViewModel>(
        create: (context) => loginViewModel,
        builder: (context, child) {
          return WillPopScope(
            onWillPop: willPopScopeCall,
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
                            widget.verficationType ==
                                    ScreenType.ReactivateAccount
                                ? Navigator.of(context).popUntil(
                                    (_) => count++ >= 5,
                                  )
                                : Navigator.pop(context);
                            loginViewModel.setLoading(false);
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
                            buildEmailView(),
                            buildPasswordView(),
                            buildNavigatorlogin(),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Header Text
  Widget buildCustomHeader() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 20, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: CustomText(
                text: stringVariables.logIn,
                overflow: TextOverflow.ellipsis,
                fontfamily: 'GoogleSans',
                fontWeight: FontWeight.bold,
                fontsize: 20,
              )),
              Flexible(
                child: CustomText(
                  text: stringVariables.register,
                  press: () {
                    widget.verficationType == ScreenType.Register
                        ? Navigator.pop(context)
                        : Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => RegisterView()))
                            .then((value) {
                            formKey.currentState!.reset();
                            email.clear();
                            password.clear();
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          });
                  },
                  overflow: TextOverflow.ellipsis,
                  color: themeColor,
                  fontsize: 15,
                ),
              ),
            ],
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
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: stringVariables.emailId,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          isContentPadding: false,
          controller: email,
          keys: field1Key,
          focusNode: focusNode1,
          autovalid: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.isEmpty
              ? 'Email ID is required'
              : input.isValidEmail()
                  ? null
                  : "Enter valid Email Address",
          size: 30,
          text: stringVariables.hintEmail,
        )
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
        CustomTextFormField(
            isContentPadding: false,
            controller: password,
            keys: field2Key,
            focusNode: focusNode2,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) =>
                input!.isEmpty ? 'Password is required' : null,
            size: 30,
            text: stringVariables.hintPassword,
            isBorderedButton: loginViewModel.passwordVisible,
            suffixIcon: CustomIconButton(
              onPress: () {
                loginViewModel.changeIcon();
              },
              child: Icon(
                loginViewModel.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: iconColor,
              ),
            )),
        CustomSizedBox(
          height: 0.04,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: CustomText(
                  text: stringVariables.forgotPassword,
                  press: () {
                    formKey.currentState!.reset();
                    Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ForgotPasswordView()))
                        .then((value) {
                      formKey.currentState!.reset();
                      email.clear();
                      password.clear();
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  },
                  fontsize: 12,
                  color: themeColor,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.04,
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

  ///navigate to login screen
  Widget buildNavigatorlogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 7, right: 7, bottom: 15),
      child: (loginViewModel.needToLoad)
          ? CustomLoader()
          : CustomElevatedButton(
              text: stringVariables.logIn.toUpperCase(),
              multiClick: true,
              color: black,
              press: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                if (formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  if (email.text.isNotEmpty && password.text.isNotEmpty) {
                    getUserTypedDetails(loginViewModel);
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

  /// Get User details
  getUserTypedDetails(LoginViewModel loginViewModel) {
    if (email.text != "" && password.text != "") {
      loginViewModel.loginUser(email.text, password.text, context);
    } else {
      customSnackBar.showSnakbar(
          context, "Enter Email and password", SnackbarType.negative);
    }
  }
}
