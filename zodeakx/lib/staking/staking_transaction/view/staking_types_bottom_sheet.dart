import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/staking_transaction_view_model.dart';

class StakingTypesModal extends ModalRoute {
  late BuildContext context;
  late StakingTransactionViewModel viewModel;

  StakingTypesModal(BuildContext context) {
    viewModel =
        Provider.of<StakingTransactionViewModel>(context, listen: false);
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
    reset();
    return false;
  }

  reset() {
    viewModel.setBeforeTypes(viewModel.selectedTypes);
    viewModel.setBeforeDirections(viewModel.selectedDirections);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<StakingTransactionViewModel>();
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
                          height: isSmallScreen(context) ? 1.75 : 2,
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
                                        text: stringVariables.selectTypes,
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
                                      buildTypesItems(),
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
                                                            .selectedTypes !=
                                                        viewModel.beforeTypes)
                                                      viewModel
                                                          .setSelectedTypes(
                                                              viewModel
                                                                  .beforeTypes);
                                                    if (viewModel
                                                            .selectedDirections !=
                                                        viewModel
                                                            .beforeDirections)
                                                      viewModel
                                                          .setSelectedDirections(
                                                              viewModel
                                                                  .beforeDirections);
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
                                                  press: viewModel.resetTypes,
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
    String value =
        set == 1 ? viewModel.beforeDirections : viewModel.beforeTypes;
    return GestureDetector(
      onTap: () {
        if (set == 1) {
          viewModel.setBeforeDirections(title);
        } else {
          viewModel.setBeforeTypes(title);
        }
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

  Widget buildTypesItems() {
    List<Widget> directionsList = [];
    int directionsItemCount = viewModel.directions.length;
    for (var i = 0; i < directionsItemCount; i++) {
      directionsList.add(buildFilterItem(viewModel.directions[i], 1));
    }
    List<Widget> typesList = [];
    int typesItemCount = viewModel.types.length;
    for (var i = 0; i < typesItemCount; i++) {
      typesList.add(buildFilterItem(viewModel.types[i], 2));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            text: stringVariables.directions,
            fontWeight: FontWeight.w400,
            fontsize: 14,
            color: textGrey,
            fontfamily: 'GoogleSans'),
        Column(
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
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
            text: stringVariables.transactionTypes,
            fontWeight: FontWeight.w400,
            fontsize: 14,
            color: textGrey,
            fontfamily: 'GoogleSans'),
        Column(
          children: [
            CustomSizedBox(
              height: 0.015,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: typesList,
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
