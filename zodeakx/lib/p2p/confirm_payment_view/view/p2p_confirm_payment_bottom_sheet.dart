import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

enum ReceivedPayment { reason1, reason2 }

class P2PConfirmPaymentModel extends ModalRoute {
  late P2POrderCreationViewModel viewModel;
  late BuildContext context;
  String? orderNo;
  String? user_id;
  String? paymentMethodName;
  String? adid;

  P2PConfirmPaymentModel(BuildContext context, this.orderNo, this.user_id,
      this.paymentMethodName, this.adid) {
    this.context = context;
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
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
    viewModel = context.watch<P2POrderCreationViewModel>();
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
                    viewModel.setReceivedPayment(ReceivedPayment.reason1);

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
                        height: 1.52,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  CustomText(
                                    fontfamily: 'GoogleSans',
                                    text:
                                        stringVariables.receivedPaymentAccount,
                                    fontsize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  // buildTextWithRadio(
                                  //     size,
                                  //     ReceivedPayment.reason1,
                                  //     stringVariables.confirmPaymentReason1),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  buildTextWithRadio(
                                      size,
                                      ReceivedPayment.reason2,
                                      stringVariables.confirmPaymentReason2),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  buildTipsDetailsCard(size),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomElevatedButton(
                                          buttoncolor: switchBackground,
                                          color: black,
                                          press: () {
                                            viewModel.setReceivedPayment(ReceivedPayment.reason1);

                                            Navigator.pop(context);
                                          },
                                          width: 2.25,
                                          isBorderedButton: true,
                                          maxLines: 1,
                                          icon: null,
                                          multiClick: true,
                                          text: stringVariables.cancel,
                                          radius: 25,
                                          height: size.height / 50,
                                          icons: false,
                                          fontSize: 16,
                                          blurRadius: 0,
                                          spreadRadius: 0,
                                          offset: Offset(0, 0)),
                                      CustomElevatedButton(
                                          buttoncolor: themeColor,
                                          color: black,
                                          press: () {
                                            if(viewModel.isConfirmPayView == true){
                                              viewModel.getOrderLocalSocket(viewModel.orderId, '');
                                            }
                                           // viewModel.setReceivedPayment(ReceivedPayment.reason1);
                                            if (viewModel.receivedPayment ==
                                                ReceivedPayment.reason2) {
                                              viewModel.releaseCrypto(
                                                  orderNo ?? "",
                                                  user_id,
                                                  adid,
                                                  paymentMethodName);
                                            } else {
                                              customSnackBar.showSnakbar(
                                                  context,
                                                  '',
                                                  SnackbarType.negative);
                                            }
                                          },
                                          width: 2.25,
                                          isBorderedButton: true,
                                          maxLines: 1,
                                          icon: null,
                                          multiClick: true,
                                          text: stringVariables.makePayment,
                                          radius: 25,
                                          height: size.height / 50,
                                          icons: false,
                                          blurRadius: 0,
                                          fontSize: 16,
                                          spreadRadius: 0,
                                          offset: Offset(0, 0)),
                                    ],
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                ],
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

  Widget buildTipsDetailsCard(Size size) {
    return CustomContainer(
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode()
            ? switchBackground.withOpacity(0.15)
            : enableBorder.withOpacity(0.25),
        border: Border.all(color: hintLight, width: 1),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      width: 1,
      height: 2.8,
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(p2pOrderAttention),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    text: stringVariables.tips,
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    fontWeight: FontWeight.bold,
                    fontsize: 14,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.015,
              ),
              buildTipLines(size, stringVariables.confirmPaymentTip1),
              CustomSizedBox(
                height: 0.015,
              ),
              buildTipLines(size, stringVariables.confirmPaymentTip2),
              CustomSizedBox(
                height: 0.015,
              ),
              buildTipLines(size, stringVariables.confirmPaymentTip3),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTipLines(Size size, String content) {
    return Row(
      children: [
        CustomSizedBox(
          width: 0.075,
        ),
        CustomContainer(
          constraints: BoxConstraints(maxWidth: size.width / 1.3),
          child: CustomText(
            text: content,
            fontfamily: 'GoogleSans',
            softwrap: true,
            fontWeight: FontWeight.w400,
            fontsize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildTextWithRadio(Size size, ReceivedPayment reason, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Transform.scale(
          scale: 1.1,
          child: Radio(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: themeColor,
            value: reason,
            groupValue: viewModel.receivedPayment,
            onChanged: (ReceivedPayment? value) {
              viewModel.setReceivedPayment(value ?? ReceivedPayment.reason1);
            },
          ),
        ),
        CustomSizedBox(
          width: 0.02,
        ),
        CustomContainer(
          width: 1.25,
          child: CustomText(
            strutStyleHeight: 1.6,
            maxlines: 2,
            text: content,
            fontfamily: 'GoogleSans',
            softwrap: true,
            fontWeight: FontWeight.w500,
            fontsize: 14,
            color: viewModel.receivedPayment == reason ? themeColor : null,
          ),
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
