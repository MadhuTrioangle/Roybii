import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/p2p/ads/view_model/p2p_ads_view_model.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../payment_methods/view_model/p2p_payment_methods_view_model.dart';

class P2PTimeAndPaymentModel extends ModalRoute {
  late P2PAdsViewModel viewModel;
  late P2PPaymentMethodsViewModel paymentMethodsViewModel;
  late BuildContext context;
  int type = 0;
  List<String> paymentMenthods = [];
  int time = 15;

  P2PTimeAndPaymentModel(BuildContext context, type) {
    this.context = context;
    this.type = type;
    viewModel = Provider.of<P2PAdsViewModel>(context, listen: false);
    paymentMethodsViewModel =
        Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    paymentMenthods = List.of(viewModel.paymentMethods);
    time = viewModel.time;
    paymentMethodsViewModel.getJwtUserResponse();
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
    viewModel = context.watch<P2PAdsViewModel>();
    paymentMethodsViewModel = context.watch<P2PPaymentMethodsViewModel>();
    Size size = MediaQuery.of(context).size;

    int paymentMethodsCount = paymentMethodsViewModel.paymentsList.length;
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
                    viewModel.setPaymentMethods(paymentMenthods);
                    viewModel.setTime(time);
                    Navigator.pop(context);
                  },
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        height: paymentMethodsCount == 0 ? 3 : 1.95,
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
                          padding: EdgeInsets.only(
                              left: size.width / 35,
                              right: size.width / 35,
                              top: size.width / 35),
                          child: paymentMethodsViewModel.needToLoad
                              ? CustomLoader()
                              : type == 0
                                  ? buildPaymentView(size)
                                  : buildTimeView(size),
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

  Widget buildNoPaymentMethod(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          themeSupport().isSelectedDarkMode() ? p2pNoticeDark : p2pNotice,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          fontfamily: 'InterTight',
          text: stringVariables.noPaymentMethod,
          fontsize: 22,
          fontWeight: FontWeight.w600,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomElevatedButton(
            buttoncolor: themeColor,
            color: themeSupport().isSelectedDarkMode() ? black : white,
            press: () {
              Navigator.pop(context);
              moveToPaymentMethods(context);
            },
            width: 1.25,
            isBorderedButton: true,
            maxLines: 1,
            icon: null,
            multiClick: true,
            text: stringVariables.addPaymentMethod,
            radius: 25,
            height: size.height / 50,
            icons: false,
            blurRadius: 0,
            spreadRadius: 0,
            offset: Offset(0, 0)),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildPaymentView(Size size) {
    int paymentMethodsCount = paymentMethodsViewModel.paymentsList.length;
    List<String> paymentsList = paymentMethodsViewModel.paymentsList;
    return paymentMethodsCount == 0
        ? buildNoPaymentMethod(size)
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    text: stringVariables.selectPaymentMethods,
                    fontsize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  )
                ],
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    itemCount: paymentMethodsCount,
                    itemBuilder: (BuildContext context, int index) {
                      bool isInPaymentList = viewModel.paymentMethods
                          .contains(paymentsList[index]);
                      return GestureDetector(
                          onTap: () {
                            viewModel.updatePaymentMethods(paymentsList[index]);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CustomContainer(
                                  height: 16,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          isInPaymentList ? themeColor : grey),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        fontfamily: 'InterTight',
                                        text: paymentMethodsViewModel
                                            .paymentsList[index],
                                        fontsize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: isInPaymentList ? white : black,
                                      ),
                                    ],
                                  ),
                                ),
                                isInPaymentList
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
                          ));
                    }),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedButton(
                          buttoncolor: grey,
                          color: hintLight,
                          press: () {
                            viewModel.setPaymentMethods([]);
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
                          color: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                          press: () {
                            Navigator.pop(context);
                          },
                          width: 2.45,
                          isBorderedButton: true,
                          maxLines: 1,
                          icon: null,
                          multiClick: true,
                          text: stringVariables.done,
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
          );
  }

  Widget buildTimeView(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CustomSizedBox(
              height: 0.01,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.selectPaymentTimeLimit,
              fontsize: 16,
              fontWeight: FontWeight.w600,
            ),
            CustomSizedBox(
              height: 0.01,
            )
          ],
        ),
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
              itemCount: viewModel.timeLimit.length,
              itemBuilder: (BuildContext context, int index) {
                int isThatSelected = viewModel.time == 15
                    ? 0
                    : viewModel.time == 30
                        ? 1
                        : viewModel.time == 45
                            ? 2
                            : 3;
                return GestureDetector(
                    onTap: () {
                      int selectedTime = 15;
                      switch (index) {
                        case 0:
                          selectedTime = 15;
                          break;
                        case 1:
                          selectedTime = 30;
                          break;
                        case 2:
                          selectedTime = 45;
                          break;
                        case 3:
                          selectedTime = 60;
                          break;
                        default:
                          selectedTime = 15;
                          break;
                      }
                      viewModel.setTime(selectedTime);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomContainer(
                            height: 16,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isThatSelected == index
                                    ? themeColor
                                    : grey),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  fontfamily: 'InterTight',
                                  text: viewModel.timeLimit[index],
                                  fontsize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      isThatSelected == index ? white : black,
                                ),
                              ],
                            ),
                          ),
                          isThatSelected == index
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
                    ));
              }),
        ),
        Column(
          children: [
            CustomElevatedButton(
                buttoncolor: themeColor,
                color: themeSupport().isSelectedDarkMode() ? black : white,
                press: () {
                  Navigator.pop(context);
                },
                width: 1,
                isBorderedButton: true,
                maxLines: 1,
                icon: null,
                multiClick: true,
                text: stringVariables.done,
                radius: 25,
                height: size.height / 50,
                icons: false,
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0)),
            CustomSizedBox(
              height: 0.015,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      // add scale animation
      child: child,
    );
  }
}
