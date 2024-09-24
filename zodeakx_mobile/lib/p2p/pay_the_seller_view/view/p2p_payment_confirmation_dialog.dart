import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/p2p/orders/model/UserOrdersModel.dart';
import 'package:zodeakx_mobile/p2p/profile/model/UserPaymentDetailsModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

class P2PPaymentMethodsModal extends ModalRoute {
  late P2POrderCreationViewModel viewModel;
  late BuildContext context;
  final String order_id;
  final UserOrdersModel? userOrdersModel;

  P2PPaymentMethodsModal(
      BuildContext context, this.order_id, this.userOrdersModel) {
    this.context = context;
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setCheckAlert(true);
      viewModel.setIsPaymentView(false);
    });
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
    UserPaymentDetails paymentMethods =
        (viewModel.paymentMethods?.first ?? UserPaymentDetails());
    String name = paymentMethods.paymentName ?? "";
    String paymentMethodId = paymentMethods.id ?? "238821381273";
    String id = "238821381273";
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
                        child: Padding(
                          padding: EdgeInsets.all(size.width / 35),
                          child: CustomContainer(
                            height: viewModel.isPaymentView
                                ? isSmallScreen(context)
                                    ? 2
                                    : 2.5
                                : isSmallScreen(context)
                                    ? 2.1
                                    : 2.4,
                            width: 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: themeSupport().isSelectedDarkMode()
                                  ? card_dark
                                  : white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(size.width / 35),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      CustomSizedBox(
                                        height: 0.015,
                                      ),
                                      CustomText(
                                        text: viewModel.isPaymentView
                                            ? stringVariables
                                                .paymentConfirmation
                                            : stringVariables.tips,
                                        align: TextAlign.center,
                                        fontWeight: FontWeight.bold,
                                        fontsize: 16,
                                      ),
                                      CustomSizedBox(
                                        height: 0.02,
                                      ),
                                      viewModel.isPaymentView
                                          ? buildPaymentConfirmationView(size)
                                          : buildAttentionCard(
                                              size,
                                              stringVariables
                                                  .paymentConfirmationContent)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomElevatedButton(
                                          blurRadius: 0,
                                          spreadRadius: 0,
                                          text: viewModel.isPaymentView
                                              ? stringVariables.confirmPayment
                                              : stringVariables
                                                  .iHaveTransferred,
                                          color: viewModel.isPaymentView
                                              ? viewModel.checkAlert
                                                  ? black
                                                  : hintLight
                                              : black,
                                          press: () {
                                            if (viewModel.isPaymentView) {
                                              if (viewModel.checkAlert) {
                                                Navigator.pop(context);
                                                viewModel.setStatus('');
                                                viewModel.setisProvide(false);
                                                viewModel.fiatTransferred(
                                                  name,
                                                  paymentMethodId,
                                                  order_id,
                                                  viewModel.paymentMethods,
                                                  userOrdersModel,
                                                );
                                                // moveToCryptoReleasingView(
                                                //     context, "id");
                                              }
                                            } else {
                                              viewModel.setIsPaymentView(true);
                                            }
                                          },
                                          radius: 25,
                                          buttoncolor: viewModel.isPaymentView
                                              ? viewModel.checkAlert
                                                  ? themeColor
                                                  : grey
                                              : themeColor,
                                          width: 1.25,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              43,
                                          isBorderedButton: false,
                                          maxLines: 1,
                                          icons: false,
                                          multiClick: true,
                                          icon: null),
                                      CustomSizedBox(
                                        height: 0.02,
                                      ),
                                      CustomElevatedButton(
                                          blurRadius: 0,
                                          spreadRadius: 0,
                                          text: viewModel.isPaymentView
                                              ? stringVariables.cancel
                                              : stringVariables
                                                  .iHaveNotTransferred,
                                          color: black,
                                          press: () {
                                            Navigator.pop(context);
                                          },
                                          radius: 25,
                                          buttoncolor: switchBackground,
                                          width: 1.25,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              43,
                                          isBorderedButton: false,
                                          maxLines: 1,
                                          icons: false,
                                          multiClick: true,
                                          icon: null),
                                      CustomSizedBox(
                                        height: 0.015,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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

  Widget buildPaymentConfirmationView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              strutStyleHeight: 1.5,
              text: stringVariables.pleaseConfirmInformation,
              fontfamily: 'InterTight',
              softwrap: true,
              fontWeight: FontWeight.w400,
              fontsize: 14,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildCheckBox()
      ],
    );
  }

  Widget buildAttentionCard(Size size, String content) {
    return CustomContainer(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: themeColor.withOpacity(0.2)),
      width: 1,
      height: isSmallScreen(context) ? 5.25 : 6.15,
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CustomSizedBox(
                    height: 0.005,
                  ),
                  SvgPicture.asset(p2pOrderAttention),
                ],
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              CustomContainer(
                width: 1.5,
                child: CustomText(
                  strutStyleHeight: 1.5,
                  text: content,
                  fontfamily: 'InterTight',
                  softwrap: true,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// checkbox with text
  Widget buildCheckBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              width: 0.01,
            ),
            CustomSizedBox(
              width: 0.06,
              height: 0.025,
              child: CustomCheckBox(
                checkboxState: viewModel.checkAlert,
                toggleCheckboxState: (value) {
                  viewModel.setCheckAlert(value ?? false);
                },
                activeColor: themeColor,
                checkColor: Colors.white,
                borderColor: enableBorder,
              ),
            ),
            CustomSizedBox(
              width: 0.015,
            ),
            CustomContainer(
              width: 1.25,
              child: CustomText(
                text: stringVariables.paymentConfirmationAlert,
                fontWeight: FontWeight.w400,
                fontsize: 14,
                strutStyleHeight: 1.3,
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
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
}
