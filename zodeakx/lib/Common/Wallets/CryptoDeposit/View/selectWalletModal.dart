import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CryptoDeposit/View/selectWalletBottomSheet.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../../Utils/Languages/English/StringVariables.dart';
import '../../../../Utils/Widgets/CustomElevatedButton.dart';
import '../ViewModel/crypto_deposit_view_model.dart';

class SelectWalletModal extends ModalRoute {
  late CryptoDepositViewModel viewModel;
  late BuildContext context;

  SelectWalletModal(
    BuildContext context,
  ) {
    this.context = context;

    viewModel =
        Provider.of<CryptoDepositViewModel>(context, listen: false);
  }

  TextEditingController noteController = TextEditingController();

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
    viewModel = context.watch<CryptoDepositViewModel>();
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CustomContainer(
                          height: 4.5,
                          width: 1.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: themeSupport().isSelectedDarkMode()
                                ? card_dark
                                : white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(18),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: stringVariables.selectWalletHeader,
                                    fontsize: 14.5,
                                    fontWeight: FontWeight.w400,
                                    color: stackCardText,
                                    align: TextAlign.center,
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  button(),
                                ]),
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
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  _showModal() async {
    final result =
    await Navigator.of(context).push(SelectWalletBottomSheet(context,0));
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomElevatedButton(
          text: stringVariables.cancel,
          radius: 25,
          buttoncolor: grey,
          width: 2.7,
          height: 17,
          isBorderedButton: false,
          blurRadius: 0,
          spreadRadius: 0,
          maxLines: 1,
          icons: false,
          icon: null,
          color: black,
          multiClick: true,fontSize: 13,
          press: () {
            Navigator.pop(context);
          },
        ),
        CustomElevatedButton(
          text: stringVariables.changeWallet,
          radius: 25,
          buttoncolor: themeColor,
          width: 2.7,
          height: 17,
          isBorderedButton: false,
          blurRadius: 0,fontSize: 13,
          spreadRadius: 0,
          maxLines: 1,
          icons: false,
          icon: null,
          color: themeSupport().isSelectedDarkMode() ? black : white,
          multiClick: true,
          press: () {
            Navigator.pop(context);
            _showModal();
          },
        ),
      ],
    );
  }
}
