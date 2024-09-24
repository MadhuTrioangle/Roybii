import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/p2p/payment_methods/view_model/p2p_payment_methods_view_model.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';

class P2PDeletePaymentModel extends ModalRoute {
  late P2PPaymentMethodsViewModel viewModel;
  late BuildContext context;
  late String id;

  P2PDeletePaymentModel(BuildContext context, String id) {
    this.context = context;
    this.id = id;
    viewModel = Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
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
    viewModel = context.watch<P2PPaymentMethodsViewModel>();
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
                    Navigator.pop(context, false);
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
                          height: 3.5,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  p2pNotice,
                                ),
                                CustomSizedBox(
                                  height: 0.015,
                                ),
                                CustomText(
                                  text: stringVariables.deletePaymentAlert,
                                  align: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                  fontsize: 16,
                                ),
                                CustomSizedBox(
                                  height: 0.015,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomElevatedButton(
                                        buttoncolor: grey,
                                        color: hintLight,
                                        press: () {
                                          Navigator.pop(context);
                                        },
                                        width: 2.75,
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
                                        buttoncolor: themeColor,
                                        color: black,
                                        press: () {
                                          Navigator.pop(context);
                                          viewModel.deleteUserPaymentMethod(id);
                                        },
                                        width: 2.75,
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
