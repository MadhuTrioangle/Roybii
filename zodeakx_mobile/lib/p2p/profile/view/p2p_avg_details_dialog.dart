import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../view_model/p2p_profile_view_model.dart';

class P2PAvgDetailsModel extends ModalRoute {
  late P2PProfileViewModel viewModel;
  late BuildContext context;

  P2PAvgDetailsModel(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<P2PProfileViewModel>(context, listen: false);
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
                          height: 3,
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
                                    CustomContainer(
                                      width: 1.3,
                                      child: Text.rich(
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        strutStyle: StrutStyle(height: 1.5),
                                        TextSpan(
                                            text:
                                                stringVariables.avgReleaseTime +
                                                    ":",
                                            style: TextStyle(
                                              color: themeSupport()
                                                      .isSelectedDarkMode()
                                                  ? white
                                                  : black,
                                              fontSize: 14,
                                              fontFamily: 'InterTight',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: " ",
                                              ),
                                              TextSpan(
                                                text: stringVariables
                                                    .avgReleaseTimeContent,
                                                style: TextStyle(
                                                  color: themeSupport()
                                                          .isSelectedDarkMode()
                                                      ? white
                                                      : black,
                                                  fontSize: 14,
                                                  fontFamily: 'InterTight',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    CustomSizedBox(
                                      height: 0.025,
                                    ),
                                    CustomContainer(
                                      width: 1.3,
                                      child: Text.rich(
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        strutStyle: StrutStyle(height: 1.5),
                                        TextSpan(
                                            text: stringVariables.avgPayTime +
                                                ":",
                                            style: TextStyle(
                                              color: themeSupport()
                                                      .isSelectedDarkMode()
                                                  ? white
                                                  : black,
                                              fontSize: 14,
                                              fontFamily: 'InterTight',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: " ",
                                              ),
                                              TextSpan(
                                                text: stringVariables
                                                    .avgPayTimeContent,
                                                style: TextStyle(
                                                  color: themeSupport()
                                                          .isSelectedDarkMode()
                                                      ? white
                                                      : black,
                                                  fontSize: 14,
                                                  fontFamily: 'InterTight',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ]),
                                      ),
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
                                            color: themeSupport()
                                                    .isSelectedDarkMode()
                                                ? black
                                                : white,
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
