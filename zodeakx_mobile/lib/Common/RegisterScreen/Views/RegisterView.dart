import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCheckedBox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../ForgotPasswordScreen/View/ForgotPasswordView.dart';
import '../../LoginScreen/ViewModel/LoginViewModel.dart';

class RegisterView extends StatefulWidget {
  final bool? canPopup;

  const RegisterView({Key? key, this.canPopup}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  FocusNode? focusNode1;
  FocusNode? focusNode2;
  FocusNode? focusNode3;
  FocusNode? focusNode4;
  GlobalKey<FormFieldState> field1Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field3Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field4Key = GlobalKey<FormFieldState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController referral = TextEditingController();
  final TextEditingController ambassadorReferral = TextEditingController();
  late RegisterViewModel registerViewModel;
  late LoginViewModel loginViewModel;
  final formKey = GlobalKey<FormState>();
  bool checkAlert = false;
  bool loginClicked = false;

  @override
  void initState() {
    registerViewModel = Provider.of<RegisterViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (widget.canPopup != null) {
      //   (widget.canPopup ?? false)
      //       ? registerViewModel.setIsLogin(true)
      //       : registerViewModel.setIsLogin(false);
      // }
    });
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
    focusNode4 = FocusNode();
    focusNode1!.addListener(() {
      if (!focusNode1!.hasFocus) {
        loginClicked = false;
        field1Key.currentState!.validate();
      }
    });
    focusNode2!.addListener(() {
      if (!focusNode2!.hasFocus) {
        loginClicked = false;
        field2Key.currentState!.validate();
      }
    });
    focusNode3!.addListener(() {
      if (!focusNode3!.hasFocus) {
        loginClicked = false;
        field3Key.currentState!.validate();
      }
    });
    focusNode4!.addListener(() {
      if (!focusNode4!.hasFocus) {
        loginClicked = false;
        field4Key.currentState!.validate();
      }
    });
  }

  @override
  void dispose() {
    focusNode1!.dispose();
    focusNode2!.dispose();
    focusNode3!.dispose();
    focusNode4!.dispose();
    resumeSocket();
    super.dispose();
  }

  resumeSocket() {
    if (constant.previousScreen.value == ScreenType.Market)
      marketSocket();
    else if (constant.previousScreen.value == ScreenType.Exchange)
      exchangeSocket();
    else {}
    constant.previousScreen.value = ScreenType.Login;
  }

  exchangeSocket() {
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    exchangeViewModel.initSocket = true;
    exchangeViewModel.fetchData();
  }

  marketSocket() {
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.initSocket = true;
    marketViewModel.getTradePairs();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> willPopScopeCall() async {
      return true; // return true to exit app or return false to cancel exit
    }

    registerViewModel = context.watch<RegisterViewModel>();
    loginViewModel = context.watch<LoginViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (registerViewModel.showSnackbar)
          ? customSnackBar.showSnakbar(
              context,
              registerViewModel.registeredUserResponse?.statusMessage ?? "",
              (registerViewModel.positiveStatus)
                  ? SnackbarType.positive
                  : SnackbarType.negative)
          : '';
      registerViewModel.showSnackbar = false;
    });

    return Provider<RegisterViewModel>(
      create: (context) => RegisterViewModel(),
      child: Builder(builder: (context) {
        return PopScope(
          canPop: widget.canPopup == true ? true : false,
          // onWillPop: willPopScopeCall,
          child: CustomScaffold(
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
                          registerViewModel.setIsLogin(true);
                          registerViewModel.setActive(false);
                          formKey.currentState!.reset();
                          if (widget.canPopup == true) {
                            Navigator.pop(context);
                          }
                          registerViewModel.setLoading(false);
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
              child: CustomContainer(
                height: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAppLogo(),
                    Flexible(
                      child: CustomCard(
                        radius: 25,
                        edgeInsets: 8,
                        outerPadding: 8,
                        elevation: 0,
                        color: themeSupport().isSelectedDarkMode()
                            ? darkCardColor
                            : lightCardColor,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildCustomHeader(),
                              registerViewModel.isLogin
                                  ? buildRegisterView(context)
                                  : buildLoginView(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  onGoogleTapped() {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          Platform.isIOS ? constant.googleIosClientId : constant.googleClientId,
      //   scopes: [
      //    'email',
      //    'https://www.googleapis.com/auth/contacts.readonly',
      //      //you can add extras if you require
      // ],
    );
    _googleSignIn.signIn().then((acc) async {
      acc?.authentication.then((GoogleSignInAuthentication auth) async {
        registerViewModel.socialMediaLogin(
            "google_account", auth.idToken ?? "", "login");
      });
    });
  }

  onAppleTapped() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],

        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.roybits.exchanges',
          redirectUri: Uri.parse('https://zodeak-dev.com/apple_callback'),
        ),
        //nonce: 'example-nonce',
        //state: 'example-state',
      );

      registerViewModel.socialMediaLogin(
          "apple_account", credential.identityToken ?? "", "login");
    } catch (exception) {}
  }

  Widget buildSocialMediaButtons(
      String icon, String title, double size, VoidCallback onTapped) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: onTapped,
        behavior: HitTestBehavior.opaque,
        child: CustomContainer(
          width: 1,
          height: 15,
          decoration: BoxDecoration(
            color:
                themeSupport().isSelectedDarkMode() ? card_dark : enableBorder,
            borderRadius: BorderRadius.circular(
              30.0,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    width: 0.035,
                  ),
                  SvgPicture.asset(
                    icon,
                    height: size,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    overflow: TextOverflow.ellipsis,
                    fontfamily: 'InterTight',
                    fontWeight: FontWeight.bold,
                    fontsize: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginView(BuildContext context) {
    return Column(
      children: [
        buildLoginEmailView(),
        buildLoginPasswordView(),
        buildLoginNavigatorlogin(),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: CustomText(
                  text: stringVariables.resetPassword,
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
                    });
                  },
                  fontsize: 15,
                  color: themeColor,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom)),
      ],
    );
  }

  Widget buildRegisterView(BuildContext context) {
    return Column(
      children: [
        buildEmailView(),
        buildPasswordView(),
        buildReferralView(),
        buildCheckBox(),
        buildnavigateregister(),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom / 2.5)),
      ],
    );
  }

  /// Email TextFormField with Text
  Widget buildLoginEmailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: stringVariables.emailId,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomTextFormField(
          isContentPadding: false,
          color: themeSupport().isSelectedDarkMode()
              ? marketCardColor
              : lightSearchBarColor,
          size: 16,
          controller: email,
          hintColor: themeSupport().isSelectedDarkMode()
              ? contentFontColor
              : hintTextColor,
          keys: field1Key,
          focusNode: focusNode1,
          autovalid: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.isEmpty && !loginClicked
              ? stringVariables.emailRequirement
              : input.isValidEmail()
                  ? null
                  : stringVariables.validEmailAddress,
          text: stringVariables.hintEmail,
        )
      ],
    );
  }

  /// Password TextFormField with Text
  Widget buildLoginPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 18),
          child: CustomText(
            text: stringVariables.password,
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
            isContentPadding: false,
            controller: password,
            keys: field2Key,
            focusNode: focusNode2,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => input!.isEmpty && !loginClicked
                ? stringVariables.passwordRequired
                : input.isValidPassword()
                    ? null
                    : stringVariables.passwordValidation,
            color: themeSupport().isSelectedDarkMode()
                ? marketCardColor
                : lightSearchBarColor,
            size: 16,
            text: stringVariables.hintPassword,
            hintColor: themeSupport().isSelectedDarkMode()
                ? contentFontColor
                : hintTextColor,
            isBorderedButton: loginViewModel.passwordVisible,
            suffixIcon: CustomIconButton(
              onPress: () {
                loginViewModel.changeIcon();
              },
              child: Icon(
                loginViewModel.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            )),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  ///navigate to login screen
  Widget buildLoginNavigatorlogin() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 7, right: 7, bottom: 18),
      child: (loginViewModel.needToLoad)
          ? CustomLoader()
          : CustomElevatedButton(
              text: stringVariables.continues,
              multiClick: true,
              color: white,
              press: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                if (formKey.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  if (email.text.isNotEmpty && password.text.isNotEmpty) {
                    getUserTypedLoginDetails();
                  }
                }
              },
              radius: 16,
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

  /// Get User details
  getUserTypedLoginDetails() {
    if (email.text != "" && password.text != "") {
      loginViewModel.loginUser(email.text, password.text, context);
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.enterEmailPassword, SnackbarType.negative);
    }
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
                  text: registerViewModel.isLogin
                      ? stringVariables.register
                      : stringVariables.logIn,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'InterTight',
                  fontWeight: FontWeight.bold,
                  fontsize: 20,
                ),
              ),
              Flexible(
                child: CustomText(
                  text: registerViewModel.isLogin
                      ? stringVariables.logIn
                      : stringVariables.register,
                  press: () {
                    FocusScope.of(context).unfocus();
                    formKey.currentState!.reset();
                    loginClicked = true;
                    registerViewModel.setActive(false);
                    registerViewModel.setActivestatus(false);
                    email.clear();
                    password.clear();
                    registerEmail.clear();
                    registerPassword.clear();
                    referral.clear();

                    registerViewModel.isLogin
                        ? registerViewModel.setIsLogin(false)
                        : registerViewModel.setIsLogin(true);
                  },
                  overflow: TextOverflow.ellipsis,
                  color: themeColor,
                  fontsize: 15,
                  fontWeight: FontWeight.w600,
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
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 8,
          ),
          child: CustomText(
            text: stringVariables.emailId,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
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
          keys: field3Key,
          hintColor: themeSupport().isSelectedDarkMode()
              ? contentFontColor
              : hintTextColor,
          controller: registerEmail,
          isContentPadding: false,
          autovalid: AutovalidateMode.onUserInteraction,
          focusNode: focusNode3,
          validator: (input) => input!.isEmpty && !loginClicked
              ? stringVariables.emailRequirement
              : input.isValidEmail()
                  ? null
                  : stringVariables.validEmailAddress,
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
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 18,
          ),
          child: CustomText(
            text: stringVariables.password,
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
            hintColor: themeSupport().isSelectedDarkMode()
                ? contentFontColor
                : hintTextColor,
            size: 16,
            keys: field4Key,
            controller: registerPassword,
            focusNode: focusNode4,
            isContentPadding: false,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => input!.isEmpty && !loginClicked
                ? stringVariables.passwordRequired
                : input.isValidPassword()
                    ? null
                    : stringVariables.passwordValidation,
            text: stringVariables.hintPassword,
            isBorderedButton: registerViewModel.passwordVisible,
            suffixIcon: CustomIconButton(
              onPress: () {
                registerViewModel.changeIcon();
              },
              child: Icon(
                registerViewModel.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            )),
      ],
    );
  }

  /// Referral TextFormField with Text
  Widget buildReferralView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 18),
          child: CustomText(
            text: stringVariables.referralId,
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
          controller: referral,
          isContentPadding: false,
          text: stringVariables.hintReferral,
          hintColor: themeSupport().isSelectedDarkMode()
              ? contentFontColor
              : hintTextColor,
          isReadOnly: ambassadorReferral.text.isNotEmpty ? true : false,
          onChanged: (val) {
            registerViewModel.getReferralLinkByReferralID(val);
          },
        ),
        registerViewModel.userReferralId?.friendsReceive == null
            ? CustomSizedBox(
                height: 0.02,
              )
            : Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 8, bottom: 5),
                child: CustomText(
                  text:
                      '${stringVariables.commissionKickbackRate} ${registerViewModel.userReferralId?.friendsReceive} %',
                  color: hintLight,
                  fontsize: 13,
                ),
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
            height: 10.0,
            width: 1.0,
            child: SvgPicture.asset(
              themeSupport().isSelectedDarkMode() ? lightlogo : darklogo,
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: registerViewModel.isLogin
              ? stringVariables.enterEmailToContinue
              : stringVariables.login,
          fontWeight: FontWeight.bold,
          fontsize: 25,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: registerViewModel.isLogin
              ? stringVariables.privacyPriority
              : stringVariables.getYouIntoAccount,
          fontsize: 15.5,
          color: stackCardText,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  ///navigate to register screen
  Widget buildnavigateregister() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: (registerViewModel.needToLoad)
              ? CustomLoader()
              : CustomElevatedButton(
                  text: stringVariables.register,
                  multiClick: true,
                  color: white,
                  press: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    registerViewModel.checkAlert
                        ? registerViewModel.setActivestatus(false)
                        : registerViewModel.setActivestatus(true);
                    if (formKey.currentState!.validate()) {
                      if (registerEmail.text.isNotEmpty &&
                          registerPassword.text.isNotEmpty) {
                        getUsertypedDetails(registerViewModel, context);
                      }
                    }
                  },
                  radius: 16,
                  buttoncolor: themeColor,
                  fillColor: themeColor,
                  width: 0.0,
                  height: MediaQuery.of(context).size.height / 50,
                  isBorderedButton: false,
                  maxLines: 1,
                  icons: false,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w500,
                  icon: null),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// checkbox with text
  Widget buildCheckBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                  left: 2.0,
                ),
                child: CustomCheckBox(
                  checkboxState: registerViewModel.checkAlert,
                  toggleCheckboxState: (val) {
                    registerViewModel.checkBoxStatus = val ?? false;
                    registerViewModel.setActive(val!);
                  },
                  activeColor: themeColor,
                  checkColor: Colors.white,
                  borderColor: enableBorder,
                )),
            CustomContainer(
              width: 1.4,
              height: 13,
              //color: red,
              child: Center(
                child: Text.rich(
                  softWrap: true,
                  TextSpan(
                      text: stringVariables.condition,
                      style: TextStyle(
                          color: themeSupport().isSelectedDarkMode()
                              ? stackCardText
                              : black,
                          fontSize: 12.5),
                      children: <TextSpan>[
                        TextSpan(
                          text: " ",
                          style: TextStyle(
                            color: themeColor,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                            text: capitalize(stringVariables.termsConditions),
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              //decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                moveToWebView(context, constant.privacy);
                              }),
                        TextSpan(
                          text: "  and  ",
                          style: TextStyle(
                            color: themeSupport().isSelectedDarkMode()
                                ? stackCardText
                                : black,
                            fontSize: 12.5,
                          ),
                        ),
                        TextSpan(
                            text: capitalize(stringVariables.policy),
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              //  decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                moveToWebView(context, constant.privacy);
                              }),
                      ]),
                ),
              ),
            ),
          ],
        ),
        Visibility(
            visible: registerViewModel.checkAlertstatus,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 49.0,
              ),
              child: CustomText(
                text: stringVariables.checkboxCondition,
                color: red,
                fontsize: 13,
              ),
            )),
      ],
    );
  }

  /// Get user details from User
  getUsertypedDetails(RegisterViewModel registerViewModel, context) {
    if (registerEmail.text != "" && registerPassword.text != "") {
      if (registerViewModel.checkBoxStatus != false) {
        registerViewModel.createUser(registerEmail.text, registerPassword.text,
            referral.text, ambassadorReferral.text, context);
      }
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.enterEmailPassword, SnackbarType.negative);
    }
  }
}
