import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';


import '../../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../../Utils/Languages/English/StringVariables.dart';
import '../../../../Utils/Widgets/CustomText.dart';
import '../ViewModel/crypto_deposit_view_model.dart';

class SelectWalletBottomSheet extends ModalRoute {
  late CryptoDepositViewModel viewModel;
  late GetCurrencyViewModel getCurrencyViewModel;
  late CoinDetailsViewModel coinDetailsViewModel;
  late BuildContext context;
  int type;

  SelectWalletBottomSheet(this.context,this.type) {
    viewModel = Provider.of<CryptoDepositViewModel>(context, listen: false);
    getCurrencyViewModel = Provider.of<GetCurrencyViewModel>(context, listen: false);
    coinDetailsViewModel = Provider.of<CoinDetailsViewModel>(context, listen: false);
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
    viewModel = context.watch<CryptoDepositViewModel>();
    getCurrencyViewModel = context.watch<GetCurrencyViewModel>();
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
                          padding: const EdgeInsets.only(left: 20.0,right: 20,top: 8,bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomSizedBox(
                                height: 0.02,
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(cancel,color: Colors.transparent,),
                                CustomText(text:type == 1 ? stringVariables.changeNetwork : stringVariables.changeWallet,fontWeight: FontWeight.w600,fontsize: 17,),
                                GestureDetector(
                                  onTap: (){
                                    coinDetailsViewModel.getFindAddress(constant.walletCurrency.value,"");
                                    Navigator.pop(context);},
                                    child: SvgPicture.asset(cancel,color: stackCardText,)),
                              ],
                            ),
                              type == 1 ? Column(
                                children: [
                                  CustomSizedBox(height: 0.04,),
                                  CustomContainer(
                                    height: 6,
                                    child: ListView.builder(itemCount: getCurrencyViewModel.networkDropDown.length,
                                        itemBuilder: (context,index){
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
                                              Navigator.pop(context);
                                              getCurrencyViewModel.setNetwork(getCurrencyViewModel.networkDropDown[index]);
                                              coinDetailsViewModel.getFindAddress("",getCurrencyViewModel.networkDropDown[index]);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: CustomText(text: getCurrencyViewModel.networkDropDown[index]),
                                            ),
                                          ),
                                          Divider()
                                        ],
                                      );
                                    }),
                                  )
                                ],
                              ) : Column(
                                children: [
                                  CustomSizedBox(
                                    height: 0.03,
                                  ),
                                  CustomText(text: stringVariables.changeWalletHeader,fontsize: 14,color: stackCardText,),
                                  CustomSizedBox(
                                    height: 0.03,
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){

                                      viewModel.updateUserDefaultWallet(stringVariables.spotWallet);
                                      Navigator.pop(context);
                                    },
                                    child: CustomText(text: stringVariables.spotWallet,fontsize: 16,fontWeight: FontWeight.w500,),
                                  ),
                                  CustomSizedBox(
                                    height: 0.03,
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: (){
                                      viewModel.updateUserDefaultWallet(stringVariables.fundingWallet);
                                      Navigator.pop(context);
                                    },
                                    child: CustomText(text: stringVariables.fundingWallet,fontsize: 16,fontWeight: FontWeight.w500,),
                                  )
                                ],
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
