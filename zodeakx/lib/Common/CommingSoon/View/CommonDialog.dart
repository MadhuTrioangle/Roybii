import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';

class CommonDialog extends ModalRoute {
  late BuildContext context;
  String title = "";
  String content = "";
  String submit = "";
  bool cancel = false;

  CommonDialog(this.context, this.title, this.content,
      [this.submit = "", this.cancel = false]);

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
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: pop,
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
                                  CustomText(
                                    text: title,
                                    align: TextAlign.center,
                                    fontfamily: 'GoogleSans',
                                    fontsize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: CustomText(
                                      strutStyleHeight: 1.75,
                                      text: content,
                                      align: TextAlign.center,
                                      fontfamily: 'GoogleSans',
                                      fontsize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  CustomSizedBox(
                                    height: 0.025,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Row(
                                      children: [
                                        if (cancel)
                                          Flexible(
                                            child: CustomElevatedButton(
                                                text: stringVariables.cancel,
                                                multiClick: true,
                                                color: themeSupport()
                                                        .isSelectedDarkMode()
                                                    ? black
                                                    : white,
                                                press: () {
                                                  Navigator.pop(context, false);
                                                },
                                                radius: 25,
                                                buttoncolor: themeColor,
                                                width: 1,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    50,
                                                isBorderedButton: false,
                                                maxLines: 1,
                                                blurRadius: 0,
                                                spreadRadius: 0,
                                                icons: false,
                                                icon: null),
                                          ),
                                        if (cancel)
                                          CustomSizedBox(
                                            width: 0.02,
                                          ),
                                        Flexible(
                                          child: CustomElevatedButton(
                                              text: submit.isEmpty
                                                  ? stringVariables.ok
                                                      .toUpperCase()
                                                  : submit,
                                              multiClick: true,
                                              color: themeSupport()
                                                      .isSelectedDarkMode()
                                                  ? black
                                                  : white,
                                              press: () {
                                                Navigator.pop(context, true);
                                              },
                                              radius: 25,
                                              buttoncolor: themeColor,
                                              width: 1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  50,
                                              isBorderedButton: false,
                                              maxLines: 1,
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              icons: false,
                                              icon: null),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomSizedBox(
                                    height: 0.005,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
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
