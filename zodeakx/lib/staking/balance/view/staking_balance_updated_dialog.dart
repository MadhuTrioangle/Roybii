import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/staking_balance_view_model.dart';

class StakingBalanceUpdatedModel extends ModalRoute {
  late StakingBalanceViewModel viewModel;
  late BuildContext context;

  StakingBalanceUpdatedModel(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<StakingBalanceViewModel>(context, listen: false);
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
    viewModel = context.watch<StakingBalanceViewModel>();
    Size size = MediaQuery.of(context).size;
    String amount = "0.02173";
    String fiat = constant.pref?.getString("defaultFiatCurrency") ?? "GBP";
    String content = stringVariables.balanceUpdateContent1 +
        "$amount $fiat" +
        stringVariables.balanceUpdateContent2;
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
                          height: 2.45,
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
                                      height: 0.02,
                                    ),
                                    SvgPicture.asset(
                                      stakingBalanceUpdated,
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 25),
                                      child: CustomText(
                                          align: TextAlign.center,
                                          text: content,
                                          fontWeight: FontWeight.w500,
                                          fontsize: 16,
                                          strutStyleHeight: 1.5,
                                          fontfamily: 'GoogleSans'),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomElevatedButton(
                                        blurRadius: 0,
                                        spreadRadius: 0,
                                        text: stringVariables.ok,
                                        color: black,
                                        press: () {
                                          Navigator.pop(context, true);
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
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        constant.pref?.setBool("balanceUpdateStatus", false);
                                        Navigator.pop(context, true);
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: CustomText(
                                          align: TextAlign.center,
                                          text: stringVariables.dontRemindAgain,
                                          fontWeight: FontWeight.w500,
                                          fontsize: 20,
                                          color: themeColor,
                                          fontfamily: 'GoogleSans'),
                                    ),
                                    CustomSizedBox(
                                      height: 0.02,
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
