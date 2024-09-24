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
import '../viewModel/transfer_history_view_model.dart';

class SelectWalletTransferHistoryBottomSheet extends ModalRoute {
  late TransferHistoryViewModel viewModel;
  late BuildContext context;
  String? whichWallet;

  SelectWalletTransferHistoryBottomSheet(
    BuildContext context,
    String whichWallet,
  ) {
    this.context = context;
    this.whichWallet = whichWallet;
    viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
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
    viewModel = context.watch<TransferHistoryViewModel>();

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
                  onTap: () {},
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
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: themeSupport().isSelectedDarkMode()
                              ? card_dark
                              : white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 8, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomSizedBox(
                                height: 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    cancel,
                                    color: Colors.transparent,
                                  ),
                                  CustomText(
                                    text: stringVariables.changeWallet,
                                    fontWeight: FontWeight.w600,
                                    fontsize: 17,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(cancel)),
                                ],
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              ((viewModel.firstWallet ==
                                              stringVariables.spotWallet ||
                                          viewModel.firstWallet ==
                                              stringVariables.fundingWallet) &&
                                      whichWallet == "from")
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        viewModel.setFirstWallet(
                                            viewModel.firstWallet ==
                                                    stringVariables.spotWallet
                                                ? stringVariables.fundingWallet
                                                : stringVariables.spotWallet);
                                        Navigator.pop(context);
                                      },
                                      child: CustomText(
                                        text: viewModel.firstWallet ==
                                                stringVariables.spotWallet
                                            ? stringVariables.fundingWallet
                                            : stringVariables.spotWallet,
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : CustomSizedBox(
                                      height: 0,
                                    ),
                              ((viewModel.secondWallet ==
                                              stringVariables.fundingWallet ||
                                          viewModel.secondWallet ==
                                              stringVariables.spotWallet) &&
                                      whichWallet == "to")
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        viewModel.setSecondWallet(viewModel
                                                    .secondWallet ==
                                                stringVariables.fundingWallet
                                            ? stringVariables.spotWallet
                                            : stringVariables.fundingWallet);
                                        Navigator.pop(context);
                                      },
                                      child: CustomText(
                                        text: viewModel.secondWallet ==
                                                stringVariables.fundingWallet
                                            ? stringVariables.spotWallet
                                            : stringVariables.fundingWallet,
                                        fontsize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : CustomSizedBox(
                                      height: 0,
                                    ),
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
