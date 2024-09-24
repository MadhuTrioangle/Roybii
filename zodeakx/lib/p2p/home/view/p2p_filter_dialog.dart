import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/keyboard_done_widget.dart';
import '../view_model/p2p_home_view_model.dart';

class P2PFilterModel extends ModalRoute {
  late P2PHomeViewModel viewModel;
  late BuildContext context;
  late StreamSubscription<bool> keyboardSubscription;

  P2PFilterModel(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (Platform.isIOS) {
        if (!visible)
          removeOverlay();
        else
          showOverlay(context);
      }
    });
  }

  var overlayEntry;

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState?.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
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
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Padding(
                    padding: EdgeInsets.all(size.width / 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CustomContainer(
                            height: 1.15,
                            width: 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: themeSupport().isSelectedDarkMode()
                                  ? card_dark
                                  : white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(size.width / 30),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      CustomSizedBox(
                                        height: 0.015,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            fontfamily: 'GoogleSans',
                                            text: stringVariables.filter,
                                            color: textHeaderGrey,
                                            fontsize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: SvgPicture.asset(cancel))
                                        ],
                                      ),
                                      buildAmountField(size),
                                      buildPaymentField(size),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomElevatedButton(
                                              buttoncolor: grey,
                                              color: hintLight,
                                              press: () {
                                                viewModel.amountController
                                                    .clear();
                                                viewModel.setSelectedPayment(
                                                    viewModel.cards.indexOf(
                                                        viewModel
                                                            .selectedPayment!));
                                              },
                                              width: 2.45,
                                              isBorderedButton: true,
                                              maxLines: 1,
                                              icon: null,
                                              multiClick: true,
                                              text: stringVariables.reset,
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
                                                if (viewModel.selectedPayment !=
                                                    null) {
                                                  viewModel.updateCard(viewModel
                                                      .selectedPayment);
                                                  viewModel
                                                      .setPaymentMethodFilter(
                                                          true);
                                                } else {
                                                  viewModel.updateCard(null);
                                                  viewModel
                                                      .setPaymentMethodFilter(
                                                          false);
                                                }
                                                if (viewModel.amountController
                                                    .text.isEmpty) {
                                                  viewModel.setAmount(null);
                                                  viewModel
                                                      .setAmountFilter(false);
                                                } else {
                                                  viewModel.setAmount(viewModel
                                                      .amountController.text);
                                                  viewModel
                                                      .setAmountFilter(true);
                                                }
                                                viewModel.fetchAdvertisement();
                                                Navigator.pop(context);
                                              },
                                              width: 2.45,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAmountField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.amount,
          color: textHeaderGrey,
          fontsize: 16,
          fontWeight: FontWeight.w600,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          controller: viewModel.amountController,
          padLeft: 0,
          padRight: 0,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
          ],
          isContentPadding: false,
          contentPadding: EdgeInsets.only(left: 20, right: 10),
          size: 30,
          text: stringVariables.enterTotalAmount,
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                fontfamily: 'GoogleSans',
                text: viewModel.fiatCurrency,
                fontsize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildPaymentField(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.paymentWithMulti,
          color: textHeaderGrey,
          fontsize: 16,
          fontWeight: FontWeight.w600,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (1 / .6),
            shrinkWrap: true,
            children: List.generate(viewModel.cards.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    viewModel.setSelectedPayment(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomContainer(
                        height: 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: viewModel.cards[index] ==
                                    viewModel.selectedPayment
                                ? themeColor
                                : grey),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              fontfamily: 'GoogleSans',
                              text: viewModel.cards[index],
                              fontsize: 14,
                              fontWeight: FontWeight.w400,
                              color: viewModel.cards[index] ==
                                      viewModel.selectedPayment
                                  ? white
                                  : black,
                            ),
                          ],
                        ),
                      ),
                      viewModel.cards[index] == viewModel.selectedPayment
                          ? Transform.translate(
                              offset: Offset(6.5, -6.5),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: SvgPicture.asset(
                                  p2pPaymentTick,
                                ),
                              ),
                            )
                          : CustomSizedBox(
                              height: 0,
                              width: 0,
                            ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.02,
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
