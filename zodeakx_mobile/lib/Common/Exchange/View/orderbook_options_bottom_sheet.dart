import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../ViewModel/ExchangeViewModel.dart';

class OrderbookOptionsModel extends ModalRoute {
  late ExchangeViewModel viewModel;
  late BuildContext context;
  int type = 0;
  List<String> list = [];

  OrderbookOptionsModel(BuildContext context, int type) {
    this.context = context;
    this.type = type;
    viewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    list = type == 0 ? viewModel.orderBook : viewModel.decimals;
    if (!list.contains(stringVariables.cancel))
      list.add(stringVariables.cancel);
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
    viewModel = context.watch<ExchangeViewModel>();
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
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
                          child: Column(children: buildListItems()),
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

  buildListItems() {
    List<Widget> listItems = [];
    int itemCount = list.length;
    for (var i = 0; i < itemCount; i++) {
      listItems.add(buildListCard(list[i], i == itemCount - 1));
    }
    return listItems;
  }

  buildListCard(String item, bool isLast) {
    int orderBookIndex = viewModel.viewFilter.indexOf(true);
    bool selectedOrderBook =
        viewModel.orderBook.indexOf(item) == orderBookIndex;
    bool selectedDecimals = item == viewModel.selectedDecimals;
    bool isSelected = type == 0 ? selectedOrderBook : selectedDecimals;
    return GestureDetector(
      onTap: () {
        if (isLast) {
          Navigator.pop(context);
          return;
        }
        if (type == 0) {
          bool first = viewModel.orderBook.indexOf(item) == 0;
          bool second = viewModel.orderBook.indexOf(item) == 1;
          bool third = viewModel.orderBook.indexOf(item) == 2;
          viewModel.setViewFilter([first, second, third]);
        } else {
          viewModel.setSelectedDecimals(item);
        }
        Navigator.pop(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                fontfamily: 'InterTight',
                text: item,
                fontsize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? themeColor : textGrey,
              )
            ],
          ),
          isLast
              ? CustomSizedBox(
                  width: 0,
                  height: 0.025,
                )
              : Column(
                  children: [
                    CustomSizedBox(
                      height: 0.02,
                    ),
                    // Divider(
                    //   color: divider,thickness: 0.2,
                    // ),
                  ],
                ),
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
