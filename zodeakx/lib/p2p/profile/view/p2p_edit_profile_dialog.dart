import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../view_model/p2p_profile_view_model.dart';

class P2PEditProfileModal extends ModalRoute {
  late P2PProfileViewModel viewModel;
  late BuildContext context;
  late FocusNode _focusNode;
  GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  TextEditingController _controller = TextEditingController();
  bool isValid = false;

  P2PEditProfileModal(BuildContext context) {
    this.context = context;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _fieldKey.currentState!.validate();
      }
    });
    _controller.addListener(() {
      isValid = _controller.text.isNotEmpty && _controller.text.length <= 20;
    });
    viewModel = Provider.of<P2PProfileViewModel>(context, listen: false);
    viewModel.setDialogLoading(true);
    viewModel.fetchUserActivity();
    viewModel.setDialogValidate(false);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => black.withOpacity(0.6);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  Future<bool> pop() async {
    Navigator.pop(context, false);
    return false;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    viewModel = context.watch<P2PProfileViewModel>();
    bool nickNameFlag = (viewModel.userActivity ?? []).isNotEmpty;
    String date = nickNameFlag
        ? getDateTimeStamp((viewModel.userActivity?.first.modifiedDate ??
                DateTime.parse("2023-02-21T14:08:25.811Z").toString())
            .toString())
        : "";
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: pop,
      child: Provider(
        create: (context) => viewModel,
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CustomContainer(
                          height: nickNameFlag
                              ? 2.75
                              : viewModel.dialogValidate
                                  ? 1.85
                                  : 2,
                          width: 1.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: themeSupport().isSelectedDarkMode()
                                ? card_dark
                                : white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width / 35),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        CustomSizedBox(
                                          height: 0.015,
                                        ),
                                        SvgPicture.asset(
                                          p2pNickName,
                                        ),
                                        CustomSizedBox(
                                          height: 0.015,
                                        ),
                                        CustomText(
                                          text: stringVariables.setNickname,
                                          align: TextAlign.center,
                                          fontWeight: FontWeight.w600,
                                          fontsize: 22,
                                        ),
                                        CustomSizedBox(
                                          height: 0.01,
                                        ),
                                        viewModel.dialogLoader
                                            ? CustomLoader()
                                            : nickNameFlag
                                                ? CustomContainer(
                                                    height: 15,
                                                    child: CustomText(
                                                      text: stringVariables
                                                              .nickNameContent1 +
                                                          date +
                                                          stringVariables
                                                              .nickNameContent2,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontsize: 14,
                                                      align: TextAlign.center,
                                                      strutStyleHeight: 1.3,
                                                    ),
                                                  )
                                                : Column(
                                                    children: [
                                                      CustomText(
                                                        text: stringVariables
                                                            .nickNameContent3,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontsize: 14,
                                                        align: TextAlign.center,
                                                        strutStyleHeight: 1.1,
                                                      ),
                                                      CustomSizedBox(
                                                        height: 0.01,
                                                      ),
                                                      CustomTextFormField(
                                                        keys: _fieldKey,
                                                        autovalid: AutovalidateMode
                                                            .onUserInteraction,
                                                        focusNode: _focusNode,
                                                        suffixIcon: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomContainer(
                                                              width: 7,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  CustomText(
                                                                    fontfamily:
                                                                        'GoogleSans',
                                                                    text:
                                                                        "${_controller.text.length}/20",
                                                                    color:
                                                                        hintLight,
                                                                    fontsize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  CustomSizedBox(
                                                                    width: 0.03,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        validator: (value) {
                                                          if ((value ?? "")
                                                              .isEmpty) {
                                                            WidgetsBinding
                                                                .instance
                                                                .addPostFrameCallback(
                                                                    (_) {
                                                              viewModel
                                                                  .setDialogValidate(
                                                                      true);
                                                            });
                                                            return stringVariables
                                                                .enterNickName;
                                                          } else if ((value ??
                                                                      "")
                                                                  .length >
                                                              20) {
                                                            WidgetsBinding
                                                                .instance
                                                                .addPostFrameCallback(
                                                                    (_) {
                                                              viewModel
                                                                  .setDialogValidate(
                                                                      true);
                                                            });
                                                            return stringVariables
                                                                .nickNameHint;
                                                          }
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            viewModel
                                                                .setDialogValidate(
                                                                    false);
                                                          });
                                                          return null;
                                                        },
                                                        controller: _controller,
                                                        padLeft: 0,
                                                        padRight: 0,
                                                        isContentPadding: false,
                                                        size: 30,
                                                        text: stringVariables
                                                            .enterNickName,
                                                      ),
                                                      CustomSizedBox(
                                                        height: 0.01,
                                                      ),
                                                      CustomText(
                                                        text: stringVariables
                                                            .nickNameContent4,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontsize: 14,
                                                        align: TextAlign.center,
                                                        strutStyleHeight: 1.1,
                                                      ),
                                                    ],
                                                  ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    nickNameFlag
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomElevatedButton(
                                                  blurRadius: 0,
                                                  spreadRadius: 0,
                                                  text: stringVariables.ok,
                                                  color: black,
                                                  press: () {
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  radius: 25,
                                                  buttoncolor: themeColor,
                                                  width: 1.3,
                                                  height: 16,
                                                  isBorderedButton: false,
                                                  maxLines: 1,
                                                  icons: false,
                                                  multiClick: true,
                                                  icon: null),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomElevatedButton(
                                                  buttoncolor: grey,
                                                  color: hintLight,
                                                  press: () {
                                                    Navigator.pop(context);
                                                  },
                                                  width: 2.5,
                                                  isBorderedButton: true,
                                                  maxLines: 1,
                                                  icon: null,
                                                  multiClick: true,
                                                  text: stringVariables.cancel,
                                                  radius: 25,
                                                  height: size.height / 50,
                                                  icons: false,
                                                  blurRadius: 0,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 0)),
                                              CustomElevatedButton(
                                                  buttoncolor: isValid
                                                      ? themeColor
                                                      : grey,
                                                  color: isValid
                                                      ? black
                                                      : hintLight,
                                                  press: () {
                                                    if (isValid) {
                                                      Navigator.pop(context);
                                                      viewModel.editUserName(
                                                          _controller.text);
                                                    } else {
                                                      _fieldKey.currentState!
                                                          .validate();
                                                    }
                                                  },
                                                  width: 2.5,
                                                  isBorderedButton: true,
                                                  maxLines: 1,
                                                  icon: null,
                                                  multiClick: true,
                                                  text: stringVariables.confirm,
                                                  radius: 25,
                                                  height: size.height / 50,
                                                  icons: false,
                                                  blurRadius: 0,
                                                  spreadRadius: 0,
                                                  offset: Offset(0, 0)),
                                            ],
                                          ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom /
                                            3)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
