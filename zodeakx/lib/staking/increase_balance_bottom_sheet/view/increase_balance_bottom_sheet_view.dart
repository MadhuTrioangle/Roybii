import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';

class IncreaseBalanceBottomSheet extends ModalRoute {
  late BuildContext context;

  IncreaseBalanceBottomSheet(BuildContext context) {
    this.context = context;
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
    return WillPopScope(
      onWillPop: pop,
      child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
              child: Stack(children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: IgnorePointer(
                ignoring: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomContainer(
                      height: 1.9,
                      width: 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                        color: themeSupport().isSelectedDarkMode()
                            ? card_dark
                            : white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.close,color: stackCardText,)
                              ],
                            ),
                            CustomSizedBox(
                              height: 0.015,
                            ),
                            CustomText(
                              text: stringVariables.increaseBalance,
                              fontsize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                            CustomSizedBox(
                              height: 0.02,
                            ),
                            CustomText(
                              text: stringVariables.increaseBalanceHeader,
                              fontsize: 14,strutStyleHeight: 1.5,
                              color: stackCardText,
                            ),
                            CustomSizedBox(
                              height: 0.03,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(p2pTrading),
                                    CustomSizedBox(
                                      width: 0.04,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: stringVariables.p2p +
                                              " " +
                                              stringVariables.trading,
                                          fontsize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CustomContainer(
                                            width: 1.3,
                                            child: CustomText(
                                              text: stringVariables
                                                  .p2pTradingHeader,
                                              fontsize: 12,fontWeight: FontWeight.w500,
                                              color: stackCardText,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                CustomSizedBox(
                                  height: 0.03,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(depositCryptoStack),
                                    CustomSizedBox(
                                      width: 0.04,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: stringVariables.deposit +
                                              " " +
                                              stringVariables.crypto,
                                          fontsize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        CustomContainer(
                                            width: 1.3,
                                            child: CustomText(
                                              text: stringVariables
                                                  .depositCryptoHeader,
                                              fontsize: 12,fontWeight: FontWeight.w500,
                                              color: stackCardText,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                CustomSizedBox(
                                  height: 0.03,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset(stackingTransfer),
                                      ],
                                    ),
                                    CustomSizedBox(
                                      width: 0.04,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                        moveToTransferView(context);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: stringVariables.transfer,
                                            fontsize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          CustomContainer(
                                              width: 1.3,
                                              child: CustomText(
                                                text: '',
                                                fontsize: 13,
                                                color: stackCardText,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]))),
    );
  }
}
