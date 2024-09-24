import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/staking_balance_view_model.dart';

class StakingAutoSubscribeModel extends ModalRoute {
  late StakingBalanceViewModel viewModel;
  late BuildContext context;

  StakingAutoSubscribeModel(BuildContext context, String id, bool status) {
    this.context = context;
    viewModel = Provider.of<StakingBalanceViewModel>(context, listen: false);
    viewModel.updateUserRestake(id, status);
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
                          height: isSmallScreen(context) ? 1.9 : 2.25,
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
                                      stakingAutoSubscribe,
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width / 25),
                                      child: CustomText(
                                          align: TextAlign.center,
                                          text: stringVariables
                                              .autoSubscribeDialog,
                                          fontWeight: FontWeight.w400,
                                          fontsize: 16,
                                          strutStyleHeight: 1.5,
                                          fontfamily: 'GoogleSans'),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
