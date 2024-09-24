import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../ads/view_model/p2p_ads_view_model.dart';
import '../../home/view/p2p_home_view.dart';
import 'p2p_post_an_ad_view.dart';

class P2PConfirmPostModel extends ModalRoute {
  late P2PAdsViewModel viewModel;
  late BuildContext context;
  late int type;

  P2PConfirmPostModel(BuildContext context, int type) {
    this.context = context;
    this.type = type;
    viewModel = Provider.of<P2PAdsViewModel>(context, listen: false);
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
    viewModel = context.watch<P2PAdsViewModel>();
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
                    Navigator.of(context).pop();
                  },
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Padding(
                    padding: EdgeInsets.all(size.width / 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CustomContainer(
                            height: isSmallScreen(context) ? 1.3 : 1.5,
                            width: 1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: themeSupport().isSelectedDarkMode()
                                  ? card_dark
                                  : white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(size.width / 30),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomSizedBox(
                                            height: 0.015,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                fontfamily: 'GoogleSans',
                                                text:
                                                    stringVariables.confirmPost,
                                                fontsize: 22,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                          CustomSizedBox(
                                            height: 0.03,
                                          ),
                                          buildFirstSet(size),
                                          buildSecondSet(size),
                                          buildThirdSet(size),
                                          buildFourthSet(size),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomElevatedButton(
                                              buttoncolor: grey,
                                              color: hintLight,
                                              press: () {
                                                Navigator.pop(context);
                                              },
                                              width: 2.45,
                                              isBorderedButton: true,
                                              maxLines: 1,
                                              icon: null,
                                              multiClick: true,
                                              text: stringVariables.cancel,
                                              radius: 25,
                                              height: size.height / 50,
                                              icons: false,
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              offset: Offset(0, 0)),
                                          CustomElevatedButton(
                                              buttoncolor: themeColor,
                                              color: black,
                                              press: () {
                                                Navigator.pop(context);
                                                moveToVerifyCode(
                                                    context,
                                                    type == 1
                                                        ? AuthenticationVerificationType
                                                            .PostAd
                                                        : AuthenticationVerificationType
                                                            .EditAd);
                                              },
                                              width: 2.45,
                                              isBorderedButton: true,
                                              maxLines: 1,
                                              icon: null,
                                              multiClick: true,
                                              text: stringVariables.post,
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFirstSet(Size size) {
    bool status = viewModel.postType == PostType.online;
    String tradeStatus = viewModel.postType == PostType.online
        ? stringVariables.published.toLowerCase()
        : stringVariables.offline.toLowerCase();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.status,
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            Row(
              children: [
                CustomContainer(
                  constraints: BoxConstraints(maxWidth: size.width / 2.4),
                  decoration: BoxDecoration(
                    color: status ? green : red,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: status
                          ? stringVariables.online
                          : stringVariables.offline,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 12,
                      color: white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                CustomSizedBox(
                  width: 0.02,
                ),
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildSecondSet(Size size) {
    String adType =
        viewModel.sideIndex == 0 ? stringVariables.buy : stringVariables.sell;
    String price = (viewModel.yourPrice ?? 0.0).toString();
    String priceType = viewModel.priceIndex == 0
        ? stringVariables.fixed
        : stringVariables.floating;
    String floatingPrice = (viewModel.floatingPricePercentage ?? 0).toString();
    String cryptoCurrency = viewModel.sideIndex != 0
        ? viewModel.selectedFiat
        : viewModel.selectedCrypto;
    String fiatCurrency = viewModel.sideIndex != 0
        ? viewModel.selectedCrypto
        : viewModel.selectedFiat;
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: adType,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
              color: adType == stringVariables.buy ? green : red,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: cryptoCurrency,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.p2pWith,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: fiatCurrency,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.price,
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: priceType +
                  (priceType == stringVariables.floating
                      ? " $floatingPrice%"
                      : ""),
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: "$price $fiatCurrency",
              fontsize: 24,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildThirdSet(Size size) {
    String total = viewModel.totalAmountController.text.toString();
    String limit =
        viewModel.minAmount.toString() + " - " + viewModel.maxAmount.toString();
    String adType = viewModel.sideIndex == 0
        ? stringVariables.buy.toLowerCase()
        : stringVariables.sell.toLowerCase();
    String cryptoCurrency = viewModel.sideIndex != 0
        ? viewModel.selectedFiat
        : viewModel.selectedCrypto;
    String fiatCurrency = viewModel.sideIndex != 0
        ? viewModel.selectedCrypto
        : viewModel.selectedFiat;
    int timeLimit = viewModel.time != 60 ? viewModel.time ?? 0 : 1;
    List<Widget> paymentCard = [];
    int paymentCardListCount = viewModel.paymentMethods.length;
    for (var i = 0; i < paymentCardListCount; i++) {
      String title = viewModel.paymentMethods[i];
      if (title == stringVariables.bankTransfer) title = "bank_transfer";
      paymentCard.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          paymentMethodsCard(size, title),
        ],
      ));
    }
    return Column(
      children: [
        buildItemCard(
            stringVariables.totalTradingAmount, total + " $cryptoCurrency"),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(stringVariables.limit, limit + " $fiatCurrency"),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.paymentMethod,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            Flexible(
              child: Wrap(
                children: paymentCard,
              ),
            )
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(
          stringVariables.paymentTimeLimit,
          "$timeLimit ${timeLimit == 1 ? stringVariables.hours : stringVariables.minutes}",
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildFourthSet(Size size) {
    String terms = viewModel.termsController.text;
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.counterparty,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.completedKyc,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.conditions,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.5),
              child: CustomText(
                fontfamily: 'GoogleSans',
                text: terms.isEmpty ? "---" : terms,
                fontsize: 14,
                fontWeight: FontWeight.w400,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildItemCard(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: title,
          fontsize: 14,
          fontWeight: FontWeight.w400,
          color: hintLight,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: value,
          fontsize: 14,
          fontWeight: FontWeight.w400,
        )
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
