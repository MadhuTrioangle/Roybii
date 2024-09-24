import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../ForgotPasswordScreen/View/ForgotPasswordView.dart';
import '../../LoginScreen/ViewModel/LoginViewModel.dart';
import '../ViewModel/SocialMediaViewModel.dart';

class SocialMediaView extends StatefulWidget {
  final bool linkAccount;
  final String type;
  final String token;

  const SocialMediaView(
      {Key? key,
      required this.linkAccount,
      required this.type,
      required this.token})
      : super(key: key);

  @override
  State<SocialMediaView> createState() => _SocialMediaViewState();
}

class _SocialMediaViewState extends State<SocialMediaView> {
  final TextEditingController referral = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController ambassadorReferral = TextEditingController();
  final TextEditingController password = TextEditingController();
  late SocialMediaViewModel viewModel;
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();
  late FocusNode focusNode2;
  bool firstTime = false;

  @override
  void initState() {
    viewModel = Provider.of<SocialMediaViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setaccountCreatedFlag(false);
      viewModel.setAmbassadorReferralEmpty(true);
      viewModel.setReferralEmpty(true);
      viewModel.setLinkAccount(widget.linkAccount);
    });
    referral.addListener(() {
      viewModel.setReferralEmpty(referral.text.isEmpty);
    });
    ambassadorReferral.addListener(() {
      viewModel.setAmbassadorReferralEmpty(ambassadorReferral.text.isEmpty);
    });
    email.text = constant.userEmail.value;
    focusNode2 = FocusNode();
    validator(field2Key, focusNode2);
    super.initState();
  }

  @override
  void dispose() {
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

  Future<bool> willPopScopeCall() async {
    return true; // return true to exit app or return false to cancel exit
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<SocialMediaViewModel>();
    return Provider<SocialMediaViewModel>(
      create: (context) => SocialMediaViewModel(),
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            viewModel.linkAccount
                                ? viewModel.accountCreatedFlag
                                    ? buildWelcomeBackView()
                                    : buildLinkAccountView()
                                : viewModel.accountCreatedFlag
                                    ? buildAccountCreatedView()
                                    : buildCreateAccountView(),
                          ],
                        ),
                      ),
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

  Widget buildButtonView(String name, VoidCallback onPressed) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: (viewModel.needToLoad)
              ? CustomLoader()
              : CustomElevatedButton(
                  text: name,
                  multiClick: true,
                  color: themeSupport().isSelectedDarkMode() ? black : white,
                  press: onPressed,
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

  Widget buildCreateAccountView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCustomHeader(stringVariables.createYourAccount),
        buildReferralView(),
        buildCheckBox(),
        buildButtonView(
            stringVariables.confirm.toUpperCase(), onConfirmPressed),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom)),
      ],
    );
  }

  Widget buildLinkAccountView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCustomHeader(stringVariables.linkExistingAccount),
        buildEmailView(),
        buildButtonView(stringVariables.next.toUpperCase(), onNextPressed),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom)),
      ],
    );
  }

  Widget buildAccountCreatedView() {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.03,
        ),
        SvgPicture.asset(
          themeSupport().isSelectedDarkMode()
              ? accountCreatedDark
              : accountCreated,
          height: 75,
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        CustomText(
          strutStyleHeight: 2.5,
          align: TextAlign.center,
          text: stringVariables.accountSuccessfullyCreated,
          fontfamily: 'InterTight',
          fontWeight: FontWeight.bold,
          fontsize: 24,
        ),
        buildButtonView(stringVariables.done.toUpperCase(), onDonePressed),
      ],
    );
  }

  Widget buildWelcomeBackView() {
    String emailId = (constant.userEmail.value.substring(0, 2) +
        "*****@" +
        constant.userEmail.value.split("@").last);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCustomHeader(stringVariables.welcomeBack),
        CustomSizedBox(
          height: 0.005,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12),
          child: CustomText(
            align: TextAlign.center,
            text: emailId,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.w500,
            fontsize: 16,
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        buildLoginPasswordView(),
        CustomSizedBox(
          height: 0.015,
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
                    Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ForgotPasswordView()))
                        .then((value) {
                      field2Key.currentState?.reset();
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
          height: 0.005,
        ),
        buildButtonView(stringVariables.done.toUpperCase(), onLinkDonePressed),
      ],
    );
  }

  onConfirmPressed() {
    if (viewModel.checkAlert) {
      viewModel.socialMediaLogin(widget.type, widget.token, "register",
          referral.text, ambassadorReferral.text);
    } else {
      firstTime = true;
      viewModel.notifyListeners();
    }
  }

  onDonePressed() {
    moveToMarket(context);
  }

  onLinkDonePressed() {
    LoginViewModel loginViewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    if (password.text != "") {
      loginViewModel.loginUser(
          constant.userEmail.value, password.text, context);
    } else {
      field2Key.currentState?.validate();
    }
  }

  onNextPressed() {
    viewModel.setaccountCreatedFlag(true);
  }

  /// Header Text
  Widget buildCustomHeader(String title) {
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
                  text: title,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'InterTight',
                  fontWeight: FontWeight.bold,
                  fontsize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
                      checkboxState: viewModel.checkAlert,
                      toggleCheckboxState: (val) {
                        firstTime = true;
                        viewModel.setActive(val ?? false);
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
            visible: firstTime && !viewModel.checkAlert,
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
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller: referral,
          isContentPadding: false,
          text: stringVariables.hintReferral,
          isReadOnly: !viewModel.ambassadorReferralEmpty,
          onChanged: (val) {
            viewModel.getReferralLinkByReferralID(val);
          },
        ),
        viewModel.userReferralId?.friendsReceive == null
            ? CustomSizedBox(
                height: 0.02,
              )
            : Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 8, bottom: 5),
                child: CustomText(
                  text:
                      '${stringVariables.commissionKickbackRate} ${viewModel.userReferralId?.friendsReceive} %',
                  color: hintLight,
                  fontsize: 13,
                ),
              ),
      ],
    );
  }

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
          height: 0.02,
        ),
        CustomTextFormField(
            isContentPadding: false,
            controller: password,
            keys: field2Key,
            focusNode: focusNode2,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => input!.isEmpty
                ? stringVariables.passwordRequired
                : input.isValidPassword()
                    ? null
                    : stringVariables.passwordValidation,
            size: 30,
            text: stringVariables.hintPassword,
            isBorderedButton: viewModel.passwordVisible,
            suffixIcon: CustomIconButton(
              onPress: () {
                viewModel.changeIcon();
              },
              child: Icon(
                viewModel.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: iconColor,
              ),
            )),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildEmailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 18),
          child: CustomText(
            text: stringVariables.email,
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
          controller: email,
          isContentPadding: false,
          text: stringVariables.hintEmail,
          isReadOnly: true,
        ),
        viewModel.userReferralId?.friendsReceive == null
            ? CustomSizedBox(
                height: 0.02,
              )
            : Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 8, bottom: 5),
                child: CustomText(
                  text:
                      '${stringVariables.commissionKickbackRate} ${viewModel.userReferralId?.friendsReceive} %',
                  color: hintLight,
                  fontsize: 13,
                ),
              ),
      ],
    );
  }

  ///Ambassador TextFormField with Text
  Widget buildAmbassadorView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: stringVariables.AmbassadorReferralId,
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
          controller: ambassadorReferral,
          isContentPadding: false,
          isReadOnly: !viewModel.referralEmpty,
          text: stringVariables.ambassadorReferral,
          onChanged: (val) {
            viewModel.getReferralLinkByReferralID(val);
          },
        ),
        CustomSizedBox(
          height: 0.02,
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
      ],
    );
  }
}
