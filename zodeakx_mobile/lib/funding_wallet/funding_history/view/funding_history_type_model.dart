import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/funding_history_view_model.dart';

class FundingHistoryTypeModel extends ModalRoute {
  late FundingHistoryViewModel viewModel;
  late BuildContext context;

  FundingHistoryTypeModel(
    BuildContext context,
  ) {
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
    viewModel = context.watch<FundingHistoryViewModel>();
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
                          color: themeSupport().isSelectedDarkMode()
                              ? card_dark
                              : white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 12.0, top: 12.0),
                                    child: SvgPicture.asset(
                                      marginClose,
                                      color: stackCardText,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            buildListItems(size),
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
    );
  }

  Widget buildListItems(Size size) {
    List<Widget> listCard = [];
    List<String> status = viewModel.statusIndex == 0
        ? [
            stringVariables.all,
            stringVariables.unPaid,
            stringVariables.paid,
            stringVariables.appealPending
          ]
        : [
            stringVariables.all,
            stringVariables.completed,
            stringVariables.cancelled
          ];
    int itemCount = status.length;
    for (var i = 0; i < itemCount; i++) {
      listCard.add(buildListCard(status[i], itemCount == i + 1));
    }
    return Column(children: listCard);
  }

  Widget buildListCard(String label, [bool isLast = false]) {
    String value = viewModel.statusIndex == 0
        ? viewModel.statusPending
        : viewModel.statusCompleted;
    return GestureDetector(
      onTap: () {
        if (viewModel.statusIndex == 0) {
          viewModel.setStatusPending(label);
          viewModel.fetchUserOrders();
        } else {
          viewModel.setStatusCompleted(label);
          viewModel.fetchUserOrders();
        }
        Navigator.pop(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                fontfamily: 'InterTight',
                text: label,
                fontsize: 16,
                fontWeight: value == label ? FontWeight.w600 : FontWeight.w500,
                color: value == label ? themeColor : stackCardText,
              )
            ],
          ),
          CustomSizedBox(
            height: isLast ? 0.02 : 0.01,
          ),
          if (!isLast)
            Column(
              children: [
                Divider(),
                CustomSizedBox(
                  height: 0.01,
                ),
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
