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
import '../../../p2p/home/view/p2p_onboarding_bottom_sheet.dart';
import '../view_model/staking_transaction_view_model.dart';

class StakingHoldingsModal extends ModalRoute {
  late BuildContext context;
  late StakingTransactionViewModel viewModel;
  final _controller = PageController(viewportFraction: 1);
  List<Widget> items = [];

  StakingHoldingsModal(BuildContext context) {
    viewModel =
        Provider.of<StakingTransactionViewModel>(context, listen: false);
    this.context = context;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToPage(viewModel.activePage);
    });
  }

  buildFilter() {
    Size size = MediaQuery.of(context).size;
    List<Widget> itemList = [];
    int itemCount = viewModel.holdings.length;
    for (var i = 0; i < itemCount; i++) {
      itemList.add(buildFilterItem(size, viewModel.holdings[i]));
    }
    return Padding(
      padding: EdgeInsets.only(left: size.width / 25, right: size.width / 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CustomSizedBox(
                height: 0.015,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: itemList,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFilterItem(size, String title) {
    return GestureDetector(
      onTap: () {
        viewModel.setBeforeHoldings(title);
      },
      child: CustomContainer(
        decoration: BoxDecoration(
          color: viewModel.beforeHoldings == title
              ? enableBorder.withOpacity(0.75)
              : enableBorder.withOpacity(0.15),
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomText(
              color: viewModel.beforeHoldings == title ? null : hintLight,
              text: title,
              fontWeight: FontWeight.w500,
              fontsize: 14,
              fontfamily: 'GoogleSans'),
        ),
      ),
    );
  }

  buildSort() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildTitleForSortItems(stringVariables.holdingValue),
          buildTextWithTick(stringVariables.sortOption1, 0, 1),
          buildTextWithTick(stringVariables.sortOption2, 1, 1),
          buildTitleForSortItems(stringVariables.subscriptionDate),
          buildTextWithTick(stringVariables.sortOption3, 0, 2),
          buildTextWithTick(stringVariables.sortOption4, 1, 2),
        ],
      ),
    );
  }

  Widget buildTitleForSortItems(String title) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        CustomContainer(
          width: 1,
          height: 35,
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15)
              : enableBorder.withOpacity(0.25),
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width / 25,
              right: size.width / 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: title,
                    fontsize: 14,
                    color: hintLight,
                    fontWeight: FontWeight.w400,
                    fontfamily: 'GoogleSans'),
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildTextWithTick(String title, int index, int set) {
    Size size = MediaQuery.of(context).size;
    int selectedIndex = 0;
    if (set == 1)
      selectedIndex = viewModel.beforeSet1;
    else if (set == 2) selectedIndex = viewModel.beforeSet2;
    return Padding(
      padding: EdgeInsets.only(
        left: size.width / 25,
        right: size.width / 25,
      ),
      child: GestureDetector(
        onTap: () {
          if (set == 1) {
            if (viewModel.beforeSet1 != index) {
              viewModel.setBeforeSet1(index);
            } else {
              viewModel.setBeforeSet1(2);
            }
          } else if (set == 2) {
            if (viewModel.beforeSet2 != index) {
              viewModel.setBeforeSet2(index);
            } else {
              viewModel.setBeforeSet2(2);
            }
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                    text: title,
                    fontWeight: FontWeight.w500,
                    fontsize: 14,
                    fontfamily: 'GoogleSans'),
                CustomSizedBox(
                  width: 0.002,
                ),
                index == selectedIndex
                    ? Transform.translate(
                        offset: Offset(0, -2),
                        child: Icon(
                          Icons.done,
                          size: 15,
                          color: themeColor,
                        ),
                      )
                    : CustomSizedBox(
                        width: 0,
                        height: 0,
                      )
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
          ],
        ),
      ),
    );
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
    viewModel.setBeforeHoldings(viewModel.selectedHoldings);
    viewModel.setBeforeSet1(viewModel.sortSet1);
    viewModel.setBeforeSet2(viewModel.sortSet2);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<StakingTransactionViewModel>();
    items = [buildFilter(), buildSort()];
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
                          height: viewModel.activePage == 0
                              ? isSmallScreen(context)
                                  ? 3.7
                                  : 4
                              : isSmallScreen(context)
                                  ? 2.15
                                  : 2.25,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.width / 25,
                                    right: size.width / 25,
                                    top: size.width / 35),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        CustomSizedBox(
                                          height: 0.015,
                                        ),
                                        Row(
                                          children: [
                                            buildTitleForTab(
                                                size,
                                                stringVariables.filterBy,
                                                viewModel.activePage == 0,
                                                0),
                                            CustomSizedBox(
                                              width: 0.04,
                                            ),
                                            buildTitleForTab(
                                                size,
                                                stringVariables.sortBy,
                                                viewModel.activePage == 1,
                                                1),
                                          ],
                                        ),
                                      ],
                                    ),
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
                              ),
                              CustomSizedBox(
                                height: 0.02,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomWidgetSlider(
                                      height:
                                          viewModel.activePage == 0 ? 11 : 3.5,
                                      items: items,
                                      pageController: _controller,
                                      onPageChanged: (page) {
                                        viewModel.setActivePage(page);
                                      },
                                      activePage: viewModel.activePage),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: size.width / 25,
                                        right: size.width / 25),
                                    child: Column(
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
                                                          .selectedHoldings !=
                                                      viewModel.beforeHoldings)
                                                    viewModel
                                                        .setSelectedHoldings(
                                                            viewModel
                                                                .beforeHoldings);
                                                  if (viewModel.sortSet1 !=
                                                      viewModel.beforeSet1) {
                                                    viewModel.setSortSet1(
                                                        viewModel.beforeSet1);
                                                  }
                                                  if (viewModel.sortSet2 !=
                                                      viewModel.beforeSet2) {
                                                    viewModel.setSortSet2(
                                                        viewModel.beforeSet2);
                                                  }
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
                                                press: viewModel.resetHoldings,
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
                                          height: 0.015,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
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

  void navigateToPage(int page) {
    _controller.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  buildTitleForTab(Size size, String title, bool highlight, int page) {
    return GestureDetector(
      onTap: () {
        navigateToPage(page);
        viewModel.setActivePage(page);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          CustomText(
              text: title,
              fontWeight: FontWeight.w500,
              fontsize: 16,
              fontfamily: 'GoogleSans'),
          CustomSizedBox(
            height: 0.0025,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: highlight
                  ? themeColor
                  : themeSupport().isSelectedDarkMode()
                      ? card_dark
                      : white,
              borderRadius: BorderRadius.circular(
                5.0,
              ),
            ),
            height: size.height / 3,
            width: page == 0 ? 9 : 10.5,
          )
        ],
      ),
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
