import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../view_model/p2p_home_view_model.dart';

class P2PNoticeModal extends ModalRoute {
  late P2PHomeViewModel viewModel;
  late BuildContext context;

  P2PNoticeModal(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    viewModel.setCheckAlert(false);
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
    viewModel = context.watch<P2PHomeViewModel>();
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
                  onTap: () {},
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
                          height: isSmallScreen(context) ? 1.6 : 2,
                          width: 1.15,
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
                                Column(
                                  children: [
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    SvgPicture.asset(
                                      p2pNotice,
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    CustomText(
                                      text: stringVariables.riskNotice,
                                      align: TextAlign.center,
                                      fontWeight: FontWeight.w600,
                                      fontsize: 22,
                                    ),
                                    CustomSizedBox(
                                      height: 0.01,
                                    ),
                                    CustomContainer(
                                      height: isSmallScreen(context) ? 3.5 : 5,
                                      child: SingleChildScrollView(
                                        child: CustomText(
                                          text:
                                              stringVariables.riskNoticeContent,
                                          fontWeight: FontWeight.w400,
                                          fontsize: 14,
                                          align: TextAlign.center,
                                          strutStyleHeight: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    buildCheckBox(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomElevatedButton(
                                            blurRadius: 0,
                                            spreadRadius: 0,
                                            text: stringVariables.confirm,
                                            color: viewModel.checkAlert
                                                ? black
                                                : hintLight,
                                            press: () {
                                              if (viewModel.checkAlert)
                                                Navigator.pop(context, true);
                                            },
                                            radius: 25,
                                            buttoncolor: viewModel.checkAlert
                                                ? themeColor
                                                : switchBackground,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                120,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                43,
                                            isBorderedButton: false,
                                            maxLines: 1,
                                            icons: false,
                                            multiClick: true,
                                            icon: null),
                                      ],
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
  }

  /// checkbox with text
  Widget buildCheckBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              width: 0.06,
              height: 0.025,
              child: CustomCheckBox(
                checkboxState: viewModel.checkAlert,
                toggleCheckboxState: (value) {
                  viewModel.setCheckAlert(value ?? false);
                },
                activeColor: themeColor,
                checkColor: Colors.white,
                borderColor: enableBorder,
              ),
            ),
            CustomSizedBox(
              width: 0.015,
            ),
            CustomContainer(
              width: 1.375,
              child: CustomText(
                text: stringVariables.riskNoticeAlert,
                fontWeight: FontWeight.w400,
                fontsize: 14,
                strutStyleHeight: 1.3,
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
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
