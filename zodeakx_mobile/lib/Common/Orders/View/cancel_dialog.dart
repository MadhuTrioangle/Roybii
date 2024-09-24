import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../ViewModel/OrdersViewModel.dart';

class CancelAlert extends ModalRoute {
  late BuildContext context;
  late OrdersViewModel viewModel;
  late int index;

  CancelAlert(BuildContext context, int index) {
    this.context = context;
    this.index = index;
    viewModel = Provider.of<OrdersViewModel>(context, listen: false);
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
    viewModel = context.watch<OrdersViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: WillPopScope(
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
                                padding: EdgeInsets.all(size.width / 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: stringVariables.orderCancellation,
                                      align: TextAlign.center,
                                      fontfamily: 'InterTight',
                                      fontsize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    CustomText(
                                      text: stringVariables
                                          .orderCancellationContent,
                                      align: TextAlign.center,
                                      fontfamily: 'InterTight',
                                      fontsize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomElevatedButton(
                                            text: stringVariables.no
                                                .toUpperCase(),
                                            multiClick: true,
                                            color: black,
                                            press: () {
                                              Navigator.pop(context);
                                            },
                                            radius: 25,
                                            buttoncolor: enableBorder,
                                            width: 2.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            isBorderedButton: false,
                                            maxLines: 1,
                                            icons: false,
                                            blurRadius: 0,
                                            spreadRadius: 0,
                                            icon: null),
                                        CustomElevatedButton(
                                            text: stringVariables.yes
                                                .toUpperCase(),
                                            multiClick: true,
                                            color: black,
                                            press: () {
                                              viewModel.cancelOrder(
                                                  viewModel
                                                      .openOrderHistory![index]
                                                      .id,
                                                  context);
                                              Navigator.pop(context);
                                            },
                                            radius: 25,
                                            buttoncolor: themeColor,
                                            width: 2.8,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            isBorderedButton: false,
                                            maxLines: 1,
                                            icons: false,
                                            blurRadius: 0,
                                            spreadRadius: 0,
                                            icon: null),
                                      ],
                                    )
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
          )),
    );
  }

  buildRowText(String text, [TextAlign align = TextAlign.center]) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CustomText(
        text: text,
        fontfamily: 'InterTight',
        fontsize: 14,
        fontWeight: FontWeight.w400,
        color: stackCardText,
        align: align,
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
