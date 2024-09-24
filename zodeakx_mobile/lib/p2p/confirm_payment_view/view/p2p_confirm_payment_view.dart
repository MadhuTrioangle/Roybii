import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/home/model/p2p_advertisement.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../orders/model/UserOrdersModel.dart';
import '../../profile/model/UserPaymentDetailsModel.dart';
import 'p2p_confirm_payment_bottom_sheet.dart';

class P2PConfirmPaymentView extends StatefulWidget {
  final double? amount;
  final String? fiatCurrency;
  final String? paymentMethodName;
  final String? adid;
  final String? logginUser;
  final String? buyerName;
  final String? orderNo;

  const P2PConfirmPaymentView(
      {Key? key,
      this.amount,
      this.fiatCurrency,
      this.paymentMethodName,
      this.adid,
      this.logginUser,
      this.buyerName,
      this.orderNo})
      : super(key: key);

  @override
  State<P2PConfirmPaymentView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PConfirmPaymentView>
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
    viewModel.fetchPaymentMethods('${widget.logginUser}',
        '${widget.paymentMethodName}', '${widget.adid}', viewModel.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
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
            : buildP2PConfirmPaymentView(size),
      ),
    );
  }

  Widget buildP2PConfirmPaymentView(Size size) {
    Advertisement advertisement = viewModel.advertisement!.isEmpty
        ? dummyAdvertisement
        : viewModel.advertisement?.first ?? dummyAdvertisement;
    String terms = advertisement.remarks ?? "";
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: Column(
        children: [
          buildConfirmPaymentView(),
          Flexible(
            fit: FlexFit.loose,
            child: CustomContainer(
              height: 1,
              width: 1,
              child: CustomCard(
                outerPadding: 0,
                edgeInsets: 0,
                radius: 25,
                elevation: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: EdgeInsets.all(size.width / 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildPaymentDetailsCard(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                CustomText(
                                  fontfamily: 'InterTight',
                                  text: stringVariables.terms,
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                CustomSizedBox(
                                  height: 0.015,
                                ),
                                CustomText(
                                  fontfamily: 'InterTight',
                                  text: terms.isEmpty ? "---" : terms,
                                  color: textHeaderGrey,
                                  fontsize: 14,
                                  fontWeight: FontWeight.w400,
                                  maxlines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                CustomSizedBox(
                                  height: 0.01,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // CustomElevatedButton(
                                //     buttoncolor: themeColor,
                                //     color: black,
                                //     press: () {
                                //
                                //       moveToAppealView(context,viewModel.orderId,"sell");
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
                                      _showModal(context);
                                    },
                                    width: 1.2,
                                    isBorderedButton: true,
                                    maxLines: 1,
                                    icon: null,
                                    multiClick: true,
                                    text: stringVariables.paymentReceived,
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
          ),
        ],
      ),
    );
  }

  Widget buildConfirmPaymentView() {
    String amount = '${widget.amount}';
    String currency = '${widget.fiatCurrency}';
    String id = '${widget.orderNo}';
    return Column(
      children: [
        CustomText(
          text: stringVariables.confirmPaymentReceived,
          fontfamily: 'InterTight',
          softwrap: true,
          fontWeight: FontWeight.w500,
          fontsize: 14,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: "$amount $currency",
          fontfamily: 'InterTight',
          softwrap: true,
          fontWeight: FontWeight.bold,
          fontsize: 24,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        SvgPicture.asset(
          p2pDownArrow,
          height: 7,
          color: hintLight,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        GestureDetector(
          onTap: () {
            moveToChatView(context, id);
            viewModel.getOrderLocalSocket(viewModel.orderId, '');
            viewModel.setIsConfirmPayView(true);
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
                fontfamily: 'InterTight',
                softwrap: true,
                fontWeight: FontWeight.bold,
                fontsize: 16,
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  dynamic _showModal(BuildContext context) async {
    final result = await Navigator.of(context).push(P2PConfirmPaymentModel(
        context,
        widget.orderNo,
        '${widget.logginUser}',
        '${widget.paymentMethodName}',
        '${widget.adid}'));
  }

  Widget buildPaymentDetailsCard(Size size) {
    UserPaymentDetails payments =
        viewModel.paymentMethods?.first ?? UserPaymentDetails();
    String name = payments.paymentName ?? "";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CustomSizedBox(
              height: 0.01,
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
                  fontfamily: 'InterTight',
                  text: stringVariables.one,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                ),
              ),
            ),
            CustomContainer(
              width: size.width,
              height: isSmallScreen(context) ? 2.4 : 2.75,
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
                  fontfamily: 'InterTight',
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
              height: 0.01,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.45),
              child: CustomText(
                strutStyleHeight: 1.3,
                fontfamily: 'InterTight',
                text: stringVariables.confirmPaymentContent1,
                fontWeight: FontWeight.w400,
                fontsize: 14,
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            buildPaymentDetails(size),
            CustomSizedBox(
              height:
                  (name == stringVariables.upi || name == stringVariables.paytm)
                      ? isSmallScreen(context)
                          ? 0.14
                          : 0.125
                      : 0.05,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.45),
              child: CustomText(
                strutStyleHeight: 1.3,
                fontfamily: 'InterTight',
                text:
                    '${stringVariables.confirmPaymentContent2} ${constant.appName} ${stringVariables.confirmPaymentContent4}',
                fontWeight: FontWeight.w400,
                fontsize: 14,
              ),
            ),
            CustomSizedBox(
              height: 0.015,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(p2pOrderAttention),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomContainer(
                  width: 1.5,
                  child: CustomText(
                    strutStyleHeight: 1.3,
                    text:
                        '${constant.appName} ${stringVariables.confirmPaymentContent3}',
                    fontfamily: 'InterTight',
                    softwrap: true,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: themeColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPaymentDetails(Size size) {
    UserPaymentDetails payments =
        viewModel.paymentMethods?.first ?? UserPaymentDetails();
    String name = payments.paymentName ?? "";
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String userName = ordersData.kycName ?? '';
    String buyerName = '${widget.buyerName}';
    Map<String, dynamic> paymentDetails = payments.paymentDetails ?? {};
    return CustomContainer(
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode() ? card_dark : white,
        border: Border.all(color: hintLight, width: 1),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      width: 1.45,
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
                if (userName.isNotEmpty)
                  Column(
                    children: [
                      buildTextWithCopy(size, stringVariables.name, userName),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                    ],
                  ),
                for (int i = 0; i < paymentDetails.values.length; i++)
                  if (!hasValidUrl(paymentDetails.values.toList()[i]))
                    buildTextWithCopy(
                        size,
                        capitalize(paymentDetails.keys
                            .toList()[i]
                            .replaceAll("_", " ")),
                        paymentDetails.values.toList()[i]),
              ],
            ),
            Row(
              children: [
                CustomContainer(
                  constraints: BoxConstraints(maxWidth: size.width / 1.25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          fontfamily: 'InterTight',
                          text: buyerName,
                          fontWeight: FontWeight.w400,
                          fontsize: 12,
                          color: hintLight,
                        ),
                      ],
                    ),
                  ),
                  height: 20,
                  decoration: BoxDecoration(
                    color: black12,
                    borderRadius: BorderRadius.circular(
                      500.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentMethodsCard(Size size, String title,
      [bool startingGap = true]) {
    var colorList = constant.paymentCardColors.entries
        .where((element) => element.key == title)
        .toList();
    Color cardColor = randomColor();
    if (colorList.isNotEmpty) {
      cardColor = colorList.first.value;
    }
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
          fontfamily: 'InterTight',
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
              fontfamily: 'InterTight',
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
              constraints: BoxConstraints(maxWidth: size.width / 7.5),
              child: CustomText(
                overflow: TextOverflow.ellipsis,
                fontfamily: 'InterTight',
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
          //   backButton(context),
        ],
      ),
    );
  }
}
