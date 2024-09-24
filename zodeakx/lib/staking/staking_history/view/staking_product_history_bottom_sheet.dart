import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/staking_order_history_view_model.dart';

class StakingProductHistoryModal extends ModalRoute {
  late BuildContext context;
  late StakingOrderHistoryViewModel viewModel;
  late VoidCallback changeTab;

  StakingProductHistoryModal(BuildContext context, VoidCallback changeTab) {
    viewModel =
        Provider.of<StakingOrderHistoryViewModel>(context, listen: false);
    this.context = context;
    this.changeTab = changeTab;
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
    reset();
    return false;
  }

  reset() {
    viewModel.setBeforeOrder(viewModel.selectedOrder);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<StakingOrderHistoryViewModel>();
    return Provider(
      create: (context) => viewModel,
      child: WillPopScope(
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
                      reset();
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
                          height: 3.5,
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
                                left: size.width / 25,
                                right: size.width / 25,
                                top: size.width / 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        reset();
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Icon(
                                        Icons.close,
                                        color: hintLight,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                        text: stringVariables
                                            .selectProductHistory,
                                        fontWeight: FontWeight.w500,
                                        fontsize: 18,
                                        fontfamily: 'GoogleSans'),
                                  ],
                                ),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildProductItems(),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomElevatedButton(
                                                  width: 2.25,
                                                  buttoncolor: themeColor,
                                                  color: black,
                                                  press: () {
                                                    if (viewModel
                                                            .selectedOrder !=
                                                        viewModel.beforeOrder)
                                                      viewModel
                                                          .setSelectedOrder(
                                                              viewModel
                                                                  .beforeOrder);
                                                    changeTab();
                                                    Navigator.pop(context);
                                                  },
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
                                              CustomElevatedButton(
                                                  width: 2.25,
                                                  buttoncolor: grey,
                                                  color: black,
                                                  press: viewModel.resetProduct,
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
                                            ],
                                          ),
                                          CustomSizedBox(
                                            height: 0.02,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
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
      ),
    );
  }

  Widget buildFilterItem(String title, int set) {
    String value = viewModel.beforeOrder;
    return GestureDetector(
      onTap: () {
        viewModel.setBeforeOrder(title);
      },
      child: CustomContainer(
        decoration: BoxDecoration(
          color: value == title
              ? themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.5)
              : enableBorder.withOpacity(0.15)
              : enableBorder.withOpacity(0.15),
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: CustomText(
              color: value == title ? null : hintLight,
              text: title,
              fontWeight: FontWeight.w500,
              fontsize: 14,
              fontfamily: 'GoogleSans'),
        ),
      ),
    );
  }

  Widget buildProductItems() {
    List<Widget> directionsList = [];
    int directionsItemCount = viewModel.product.length;
    for (var i = 0; i < directionsItemCount; i++) {
      directionsList.add(buildFilterItem(viewModel.product[i], 1));
    }
    return Column(
      children: [
        CustomSizedBox(
          height: 0.015,
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: directionsList,
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
