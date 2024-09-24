import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

class P2PCancelAppealModal extends ModalRoute {
  late P2POrderCreationViewModel viewModel;
  late BuildContext context;

  P2PCancelAppealModal(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
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
    viewModel = context.watch<P2POrderCreationViewModel>();
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
                          height: 1.55,
                          width: 1.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: themeSupport().isSelectedDarkMode()
                                ? card_dark
                                : white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width / 25),
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
                                      height: 0.02,
                                    ),
                                    CustomText(
                                      text: stringVariables.cancelAppeal + "?",
                                      align: TextAlign.center,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 16,
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    CustomText(
                                      text:
                                          stringVariables.cancelAppealContent1,
                                      fontWeight: FontWeight.w400,
                                      fontsize: 14,
                                      strutStyleHeight: 1.3,
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    CustomText(
                                      text:
                                          stringVariables.cancelAppealContent2,
                                      fontWeight: FontWeight.w400,
                                      fontsize: 14,
                                      strutStyleHeight: 1.3,
                                    ),
                                    CustomText(
                                      text:
                                          stringVariables.cancelAppealContent3,
                                      fontWeight: FontWeight.w400,
                                      fontsize: 14,
                                      strutStyleHeight: 1.3,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomElevatedButton(
                                        blurRadius: 0,
                                        spreadRadius: 0,
                                        text: stringVariables.cancelAppeal,
                                        color: black,
                                        press: () {
                                          Navigator.pop(context);
                                          viewModel.cancelAppeal();

                                        },
                                        radius: 25,
                                        buttoncolor: themeColor,
                                        width: 1,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                43,
                                        isBorderedButton: false,
                                        maxLines: 1,
                                        icons: false,
                                        multiClick: true,
                                        icon: null),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    CustomElevatedButton(
                                        blurRadius: 0,
                                        spreadRadius: 0,
                                        text: stringVariables.notNow,
                                        color: black,
                                        press: () {
                                          Navigator.pop(context);
                                        },
                                        radius: 25,
                                        buttoncolor: switchBackground,
                                        width: 1,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                43,
                                        isBorderedButton: false,
                                        maxLines: 1,
                                        icons: false,
                                        multiClick: true,
                                        icon: null),
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
