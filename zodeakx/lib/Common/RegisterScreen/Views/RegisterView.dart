import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
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
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../ForgotPasswordScreen/View/ForgotPasswordView.dart';
import '../../LoginScreen/ViewModel/LoginViewModel.dart';

class RegisterView extends StatefulWidget {
  final bool? isLogin;

  const RegisterView({Key? key, this.isLogin}) : super(key: key);

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
  late RegisterViewModel registerViewModel;
  late LoginViewModel loginViewModel;
  final formKey = GlobalKey<FormState>();
  bool checkAlert = false;
  bool loginClicked = false;

  @override
  void initState() {
    registerViewModel = Provider.of<RegisterViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isLogin != null) {
        (widget.isLogin ?? false)
            ? registerViewModel.setIsLogin(true)
            : registerViewModel.setIsLogin(false);
      }
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
                          registerViewModel.setIsLogin(true);
                          registerViewModel.setActive(false);
                          formKey.currentState!.reset();
                          Navigator.pop(context);
                          registerViewModel.setLoading(false);
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
                          registerViewModel.isLogin
                              ? Column(
                                  children: [
                                    buildEmailView(),
                                    buildPasswordView(),
                                    buildReferralView(),
                                    buildCheckBox(),
                                    buildnavigateregister(),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom)),
                                  ],
                                )
                              : Column(
                                  children: [
                                    buildLoginEmailView(),
                                    buildLoginPasswordView(),
                                    buildLoginNavigatorlogin(),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom)),
                                  ],
                                )
                        ],
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
          validator: (input) => input!.isEmpty && !loginClicked
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
            validator: (input) => input!.isEmpty && !loginClicked
                ? 'Password is required'
                : input.isValidPassword()
                    ? null
                    : "Must contain number, uppercase, special, \nlowercase and min 8 characters",
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

  ///navigate to login screen
  Widget buildLoginNavigatorlogin() {
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
                    getUserTypedLoginDetails();
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
  getUserTypedLoginDetails() {
    if (email.text != "" && password.text != "") {
      loginViewModel.loginUser(email.text, password.text, context);
    } else {
      customSnackBar.showSnakbar(
          context, "Enter Email and password", SnackbarType.negative);
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
                  fontfamily: 'GoogleSans',
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          keys: field3Key,
          controller: registerEmail,
          isContentPadding: false,
          autovalid: AutovalidateMode.onUserInteraction,
          focusNode: focusNode3,
          validator: (input) => input!.isEmpty && !loginClicked
              ? 'Email ID is required'
              : input.isValidEmail()
                  ? null
                  : "Enter valid Email Address",
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
            size: 30,
            keys: field4Key,
            controller: registerPassword,
            focusNode: focusNode4,
            isContentPadding: false,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => input!.isEmpty && !loginClicked
                ? 'Password is required'
                : input.isValidPassword()
                    ? null
                    : "Must contain number, uppercase, special, \nlowercase and min 8 characters",
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
                color: iconColor,
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller: referral,
          isContentPadding: false,
          text: stringVariables.hintReferral,
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
                      'Your commission kickback rate: ${registerViewModel.userReferralId?.friendsReceive} %',
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

  ///navigate to register screen
  Widget buildnavigateregister() {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: (registerViewModel.needToLoad)
              ? CustomLoader()
              : CustomElevatedButton(
                  text: stringVariables.register.toUpperCase(),
                  multiClick: true,
                  color: black,
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
                  radius: 25,
                  buttoncolor: themeColor,
                  width: 0.0,
                  blurRadius: 13,
                  spreadRadius: 1,
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

  /// checkbox with text
  Widget buildCheckBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          width: 0,
          height: 25,
          //  color:Colors.red ,
          child: Row(
            children: [
              Flexible(
                child: Padding(
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
              ),
              Flexible(
                flex: 2,
                child: CustomContainer(
                  width: 1.3,
                  height: 50,
                  child: Text.rich(
                    softWrap: true,
                    TextSpan(
                        text: stringVariables.condition,
                        style: TextStyle(
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                            fontSize: 12),
                        children: <TextSpan>[
                          TextSpan(
                            text: " ",
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                              text: stringVariables.policy,
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
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
        registerViewModel.createUser(
            registerEmail.text, registerPassword.text, referral.text, context);
      }
    } else {
      customSnackBar.showSnakbar(
          context, "Enter Email and password", SnackbarType.negative);
    }
  }
}
