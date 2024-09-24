import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomText.dart';

class ToolTipDialog extends ModalRoute {
  late BuildContext context;
  final String holdingCurrency;

  ToolTipDialog(
    BuildContext context,this.holdingCurrency
  ) {
    this.context = context;
  }

  TextEditingController voteController = TextEditingController();

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
                    Navigator.of(context).pop();
                  },
                ),
                IgnorePointer(
                    ignoring: false,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            height: isSmallScreen(context) ? 1.875 : 2,
                            width: 1,
                            child: CustomCard(
                              radius: 15,
                              outerPadding: 4,
                              edgeInsets: 15,
                              elevation: 0,
                              color: themeSupport().isSelectedDarkMode()
                                  ? black
                                  : white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  toolTipRow(stringVariables.one,stringVariables
                                      .preparationPeriod,"$holdingCurrency "+stringVariables.adaCalculation),
                                  toolTipRow(stringVariables.two,stringVariables
                                      .subPeriod,stringVariables.commitAda + " $holdingCurrency"),
                                  toolTipRow(stringVariables.three,stringVariables
                                      .rewardCal,stringVariables.allocationCal),
                                  toolTipRow(stringVariables.four,stringVariables
                                      .resultAnnounce,"$holdingCurrency "+stringVariables.deduction),
                                  CustomSizedBox(height: 0.015,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: CustomText(text:stringVariables.tooltipFooter1 + " $holdingCurrency " + stringVariables.tooltipFooter2),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }

  Widget toolTipRow(String num, String head, String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomContainer(
                height: 25,
                width: 13,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(100)),
                    color: textGrey,
                    border: Border.all(width:0)),
                child: Center(
                    child: CustomText(
                      text: num,
                      color: black,
                    )),
              ),
            ),
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: head,
                  color: themeSupport()
                      .isSelectedDarkMode()
                      ? white
                      : black,
                ),
                CustomContainer(
                  width: 1.5,
                  child: CustomText(
                    text:value,maxlines: 2,
                    color: themeSupport()
                        .isSelectedDarkMode()
                        ? white
                        : black,
                  ),
                ),
              ],
            )
          ],
        ),
        num == stringVariables.four ? CustomSizedBox(height: 0,width: 0,) :
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CustomContainer(
            height: 25,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: themeColor,
            ),
          ),
        )
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
