import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../../Utils/Languages/English/StringVariables.dart';
import '../../CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../../ViewModel/WalletViewModel.dart';
import '../ViewModel/CommonWithdrawViewModel.dart';



class SelectWalletForWithdrawBottomSheet extends ModalRoute {
  late CommonWithdrawViewModel viewModel;
  late CoinDetailsViewModel coinDetailsViewModel;
  late WalletViewModel walletViewModel;
  late BuildContext context;
  late String currencyCode;

  SelectWalletForWithdrawBottomSheet(
    this.context,
    this.currencyCode,
  ) {
    viewModel = Provider.of<CommonWithdrawViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);
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
    viewModel = context.watch<CommonWithdrawViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();
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
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    marginClose,
                                    color: Colors.transparent,
                                  ),
                                  CustomText(
                                    text:
                                        "${stringVariables.send} ${stringVariables.from}",
                                    fontsize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset(
                                        marginClose,
                                        color: stackCardText,
                                        height: 20,
                                      )),
                                ],
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              CustomText(
                                text: stringVariables.available,
                                color: stackCardText,
                                fontsize: 15,
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              CustomText(
                                text: '${viewModel.balance} ${currencyCode}',
                                fontsize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              selectWallet(),
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

  Widget selectWallet() {
    return Column(
      children: [
        CustomContainer(
          height: 7,
          child: Center(
            child: ListView.builder(
                itemCount: 2,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              index == 0 ? walletImage : funding,
                              width: 25,
                              height: 15,
                            ),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            CustomText(
                                text: index == 0
                                    ? stringVariables.spotWallet
                                    : stringVariables.fundingWallet)
                          ],
                        ),
                        Row(
                          children: [
                            CustomText(
                                text: index == 0
                                    ? '${viewModel.spotWalletBalance} ${currencyCode}'
                                    : '${viewModel.fundingWallettBalance} ${currencyCode}'),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            Transform.scale(
                              scale: 1.1,
                              child: Radio(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: themeColor,
                                value: index == 0
                                    ? SelectWallet.spot
                                    : SelectWallet.funding,
                                groupValue: viewModel.radioValue,
                                onChanged: (SelectWallet? value) {
                                  viewModel.setRadioValue(
                                      value!,
                                      index == 0
                                          ? '${viewModel.spotWalletBalance}'
                                          : '${viewModel.fundingWallettBalance}');
                                  Navigator.pop(context);
                                  // index == 0
                                  //     ? coinDetailsViewModel
                                  //         .getSpotBalanceSocket()
                                  //     : walletViewModel
                                  //         .getFundingBalanceSocket();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
        // CustomElevatedButton(
        //     buttoncolor: themeColor,
        //     color: themeSupport().isSelectedDarkMode() ? black : white,
        //     press: () async {
        //       Navigator.pop(context);
        //     },
        //     width: 1.2 ,
        //     isBorderedButton: true,
        //     maxLines: 1,
        //     icon: null,
        //     multiClick: true,
        //     text: stringVariables.confirm,
        //     radius: 25,
        //     height: MediaQuery.of(context).size.height / 50,
        //     icons: false,
        //     blurRadius: 0,
        //     spreadRadius: 0,
        //     offset: Offset(0, 0))
      ],
    );
  }
}
