import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/orders/model/UserOrdersModel.dart';
import 'package:zodeakx_mobile/p2p/pay_the_seller_view/view/p2p_payment_confirmation_dialog.dart';
import 'package:zodeakx_mobile/p2p/profile/model/UserPaymentDetailsModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/model/p2p_advertisement.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

class P2PPayTheSellerView extends StatefulWidget {
  final String? id;
  final String? banktype;
  final String? adId;
  final UserOrdersModel? userOrdersModel;

  const P2PPayTheSellerView(
      {Key? key, this.id, this.banktype, this.adId, this.userOrdersModel})
      : super(key: key);

  @override
  State<P2PPayTheSellerView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PPayTheSellerView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.fetchOrderDetails(
          '${widget.id}', '${widget.banktype}', '${widget.adId}');
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2POrderCreationViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PPayTheSellerView(size),
      ),
    );
  }

  Widget buildP2PPayTheSellerView(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    num amount = double.parse('${ordersData.price ?? 69.254}');
    String id = ordersData.id ?? "";
    String adType = capitalize(ordersData.tradeType ?? "buy");
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset ?? "BTC"
        : ordersData.toAsset ?? "USD";
    Advertisement advertisement = viewModel.advertisement!.isEmpty
        ? dummyAdvertisement
        : viewModel.advertisement?.first ?? dummyAdvertisement;
    String terms = advertisement.remarks ?? "";
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 35),
            child: CustomContainer(
              height: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSizedBox(
                            height: 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: stringVariables.paySeller,
                                fontfamily: 'GoogleSans',
                                softwrap: true,
                                fontWeight: FontWeight.bold,
                                fontsize: 16,
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: stringVariables.orderCancelledIn,
                                fontfamily: 'GoogleSans',
                                softwrap: true,
                                fontWeight: FontWeight.w400,
                                fontsize: 14,
                              ),
                              CustomSizedBox(
                                width: 0.02,
                              ),
                              CustomText(
                                text:
                                    '${viewModel.formatedTime(time: viewModel.countDown)}',
                                fontfamily: 'GoogleSans',
                                softwrap: true,
                                fontWeight: FontWeight.w400,
                                fontsize: 14,
                                color: themeColor,
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: amount.toString(),
                                fontfamily: 'GoogleSans',
                                softwrap: true,
                                fontWeight: FontWeight.bold,
                                fontsize: 22,
                              ),
                              CustomSizedBox(
                                width: 0.02,
                              ),
                              Column(
                                children: [
                                  CustomSizedBox(
                                    height: 0.0075,
                                  ),
                                  CustomText(
                                    text: fiatCurrency,
                                    fontfamily: 'GoogleSans',
                                    softwrap: true,
                                    fontWeight: FontWeight.w400,
                                    fontsize: 14,
                                  ),
                                ],
                              ),
                              CustomSizedBox(
                                width: 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text:
                                              '${amount.toString()} ${fiatCurrency}'))
                                      .then((_) {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    customSnackBar.showSnakbar(
                                        context,
                                        stringVariables.copySnackBar,
                                        SnackbarType.positive);
                                  });
                                },
                                child: SvgPicture.asset(
                                  copy,
                                ),
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          GestureDetector(
                            onTap: () {
                              moveToChatView(context, id);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  p2pChat,
                                ),
                                CustomSizedBox(
                                  width: 0.02,
                                ),
                                CustomText(
                                  text: stringVariables.chat,
                                  fontfamily: 'GoogleSans',
                                  softwrap: true,
                                  fontWeight: FontWeight.bold,
                                  fontsize: 16,
                                ),
                              ],
                            ),
                          ),
                          CustomSizedBox(
                            height: 0.04,
                          ),
                          buildPaymentDetailsCard(size),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          CustomText(
                            fontfamily: 'GoogleSans',
                            text: stringVariables.terms,
                            fontsize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          CustomSizedBox(
                            height: 0.015,
                          ),
                          CustomText(
                            fontfamily: 'GoogleSans',
                            text: terms.isEmpty ? "---" : terms,
                            color: textHeaderGrey,
                            fontsize: 14,
                            fontWeight: FontWeight.w400,
                            maxlines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CustomElevatedButton(
                          //     buttoncolor: grey,
                          //     color: hintLight,
                          //     press: () {
                          //       moveToAppealView(context, "id");
                          //     },
                          //     width: 3,
                          //     isBorderedButton: true,
                          //     maxLines: 1,
                          //     icon: null,
                          //     multiClick: true,
                          //     text: stringVariables.appeal,
                          //     radius: 25,
                          //     height: size.height / 50,
                          //     icons: false,
                          //     blurRadius: 0,
                          //     spreadRadius: 0,
                          //     offset: Offset(0, 0)),
                          CustomElevatedButton(
                              buttoncolor: themeColor,
                              color: black,
                              press: () {
                                _showModal(context, '${widget.id}',
                                    widget.userOrdersModel);
                              },
                              width: 1.2,
                              isBorderedButton: true,
                              maxLines: 1,
                              icon: null,
                              multiClick: true,
                              text: stringVariables.transferredNotifySeller,
                              radius: 25,
                              height: size.height / 50,
                              icons: false,
                              blurRadius: 0,
                              spreadRadius: 0,
                              offset: Offset(0, 0)),
                        ],
                      ),
                      CustomSizedBox(
                        height: 0.02,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic _showModal(
    BuildContext context,
    String id,
    UserOrdersModel? userOrdersModel,
  ) async {
    final result = await Navigator.of(context)
        .push(P2PPaymentMethodsModal(context, id, userOrdersModel));
  }

  Widget buildPaymentDetailsCard(Size size) {
    UserPaymentDetails paymentMethods =
        ((viewModel.paymentMethods ?? []).isNotEmpty
            ? viewModel.paymentMethods?.first ?? UserPaymentDetails()
            : UserPaymentDetails());
    String name = paymentMethods.paymentName ?? "";
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
      height: isSmallScreen(context) ? 1.675 : 2,
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Row(
          children: [
            Column(
              children: [
                CustomContainer(
                  decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 14,
                  height: isSmallScreen(context)
                      ? Platform.isIOS
                          ? 25
                          : 31
                      : 31,
                  child: Center(
                    child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: stringVariables.one,
                      fontWeight: FontWeight.w400,
                      fontsize: 14,
                    ),
                  ),
                ),
                CustomContainer(
                  width: size.width,
                  height: isSmallScreen(context) ? 2.3 : 2.7,
                  color: hintLight,
                ),
                CustomContainer(
                  decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 14,
                  height: isSmallScreen(context)
                      ? Platform.isIOS
                          ? 25
                          : 31
                      : 31,
                  child: Center(
                    child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: stringVariables.two,
                      fontWeight: FontWeight.w400,
                      fontsize: 14,
                    ),
                  ),
                ),
              ],
            ),
            CustomSizedBox(
              width: 0.035,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSizedBox(
                  height: 0.005,
                ),
                CustomContainer(
                  constraints: BoxConstraints(maxWidth: size.width / 1.45),
                  child: CustomText(
                    strutStyleHeight: 1.3,
                    fontfamily: 'GoogleSans',
                    text: stringVariables.paySellerContent1,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                  ),
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                buildPaymentDetails(size),
                CustomSizedBox(
                  height: (name == stringVariables.upi ||
                          name == stringVariables.paytm)
                      ? isSmallScreen(context)
                          ? 0.19
                          : 0.15
                      : 0.065,
                ),
                CustomContainer(
                  constraints: BoxConstraints(maxWidth: size.width / 1.45),
                  child: CustomText(
                    strutStyleHeight: 1.3,
                    fontfamily: 'GoogleSans',
                    text: stringVariables.paySellerContent2,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentDetails(Size size) {
    UserPaymentDetails paymentMethods =
        ((viewModel.paymentMethods ?? []).isNotEmpty
            ? viewModel.paymentMethods?.first ?? UserPaymentDetails()
            : UserPaymentDetails());
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String name = paymentMethods.paymentName ?? "";
    String userName = ordersData.kycName ?? '';
    String accNo = name == stringVariables.upi
        ? (paymentMethods.paymentDetails?.upiId ?? "")
        : (paymentMethods.paymentDetails?.accountNumber ?? "");
    String bankName = paymentMethods.paymentDetails?.bankName ?? "";
    String branch = paymentMethods.paymentDetails?.branch ?? "";
    String refNo = paymentMethods.paymentDetails?.ifscCode ?? "";
    return CustomContainer(
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode() ? card_dark : white,
        border: Border.all(color: hintLight, width: 1),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      width: 1.45,
      height: isSmallScreen(context)
          ? (name == stringVariables.upi || name == stringVariables.paytm)
              ? 6
              : 3.5
          : (name == stringVariables.upi || name == stringVariables.paytm)
              ? 7.25
              : 4.25,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(size.width / 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  paymentMethodsCard(size, name, false),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  buildTextWithCopy(size, stringVariables.name, userName),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  buildTextWithCopy(
                      size,
                      name == stringVariables.upi
                          ? stringVariables.upiId
                          : name == stringVariables.paytm
                              ? stringVariables.accNumber
                              : stringVariables.bankAccountNumber,
                      accNo),
                  (name == stringVariables.upi || name == stringVariables.paytm)
                      ? CustomSizedBox(
                          width: 0,
                          height: 0,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSizedBox(
                              height: 0.02,
                            ),
                            buildTextWithCopy(
                                size, stringVariables.bankName, bankName),
                            CustomSizedBox(
                              height: 0.02,
                            ),
                            buildTextWithCopy(size,
                                stringVariables.accountOpeningBranch, branch),
                          ],
                        ),
                ],
              ),
              // CustomContainer(
              //   constraints: BoxConstraints(maxWidth: size.width / 1.25),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         buildTextWithCopy(
              //             size, stringVariables.refMessage, refNo, true)
              //       ],
              //     ),
              //   ),
              //   height: 20,
              //   decoration: BoxDecoration(
              //     color: black12,
              //     borderRadius: BorderRadius.circular(
              //       500.0,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentMethodsCard(Size size, String title,
      [bool startingGap = true]) {
    Color cardColor = constant.paymentCardColors.entries
        .firstWhere((entry) => entry.key == title)
        .value;
    if (title == "bank_transfer") title = stringVariables.bankTransfer;
    return Row(
      children: [
        startingGap
            ? CustomSizedBox(
                width: 0.02,
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        CustomContainer(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(
              500.0,
            ),
          ),
          width: size.width / 3,
          height: size.height / 14,
        ),
        CustomSizedBox(
          width: 0.01,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: title,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
          fontsize: 14,
        ),
      ],
    );
  }

  buildTextWithCopy(Size size, String title, String value,
      [bool alertText = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: title,
              fontWeight: FontWeight.w400,
              fontsize: 14,
              color: hintLight,
            ),
            alertText
                ? Row(
                    children: [
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      Column(
                        children: [
                          CustomSizedBox(
                            height: 0.0025,
                          ),
                          SvgPicture.asset(
                            p2pOrderAttention,
                            color: hintLight,
                            height: 13,
                          ),
                        ],
                      ),
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  ),
          ],
        ),
        Row(
          children: [
            CustomContainer(
              constraints: BoxConstraints(
                  maxWidth: isSmallScreen(context)
                      ? size.width / 6.5
                      : size.width / 6),
              child: CustomText(
                overflow: TextOverflow.ellipsis,
                fontfamily: 'GoogleSans',
                text: value,
                fontWeight: FontWeight.w400,
                fontsize: 14,
              ),
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: '${value}')).then((_) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  customSnackBar.showSnakbar(context,
                      stringVariables.copySnackBar, SnackbarType.positive);
                });
              },
              child: SvgPicture.asset(
                copy,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: buildHeader(size));
  }

  Widget buildHeader(Size size) {
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 35, right: 15),
                    child: SvgPicture.asset(
                      backArrow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
