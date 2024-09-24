import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/p2p/appeal_view/view/cancel_appeal_dialog.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
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

class P2PAppealView extends StatefulWidget {
  final String id;
  final String? side;
  final String loggedInUser;

  const P2PAppealView(
      {Key? key,
      required this.id,
      required this.side,
      required this.loggedInUser})
      : super(key: key);

  @override
  State<P2PAppealView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PAppealView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  String paymentStatus = '';

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
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.isNegotiatied = false;
    });
  }

  _showDialog() async {
    final result =
        await Navigator.of(context).push(P2PCancelAppealModal(context));
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
            : buildP2PAppealView(size),
      ),
    );
  }

  Widget buildP2PAppealView(Size size) {
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeaderTimer(),
          CustomSizedBox(
            height: 0.01,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: CustomContainer(
              width: 1,
              height: 1,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomSizedBox(
                                  height: 0.01,
                                ),
                                buildAppealHintsView(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                (viewModel.isNegotiatied) ||
                                        ((viewModel.appealId ==
                                            widget.loggedInUser))
                                    ? SizedBox()
                                    : buildNegotiationResultView(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildAppealProgressCard(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildOrderDetailsView(size),
                                CustomSizedBox(
                                  height: 0.01,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ((viewModel.isNegotiatied || viewModel.appealHistory?.result?.first.consensus == false))
                            ? SizedBox()
                            : Column(
                                children: [
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  CustomElevatedButton(
                                      buttoncolor: themeColor,
                                      color: black,
                                      press: () {
                                        (viewModel.isNegotiatied) ||
                                                ((viewModel.appealId ==
                                                    widget.loggedInUser))
                                            ? _showDialog()
                                            : moveToReachedAgreementView(
                                                context,
                                                viewModel.orderId,
                                                true,
                                                widget.side);
                                      },
                                      width: 1,
                                      isBorderedButton: true,
                                      maxLines: 1,
                                      icon: null,
                                      multiClick: true,
                                      text: (viewModel.isNegotiatied) ||
                                              ((viewModel.appealId ==
                                                  widget.loggedInUser))
                                          ? stringVariables.cancelAppeal
                                          : stringVariables.makePayment,
                                      radius: 25,
                                      height: size.height / 50,
                                      icons: false,
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      offset: Offset(0, 0)),
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

  Widget buildNegotiationResultView(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.negotiationResult,
          fontsize: 14,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSizedBox(
              width: 0.01,
            ),
            GestureDetector(
              onTap: () {
                moveToReachedAgreementView(
                    context, viewModel.orderId, false, widget.side);
                viewModel.fetchAppealHistory();
              },
              child: buildNegotiationCard(
                  p2pSad, red, stringVariables.negotiationFailed),
            ),
            GestureDetector(
              onTap: () {
                moveToReachedAgreementView(
                    context, viewModel.orderId, true, widget.side);
                viewModel.fetchAppealHistory();
              },
              child: buildNegotiationCard(
                  p2pSmile, green, stringVariables.consensusReached),
            ),
            CustomSizedBox(
              width: 0.01,
            )
          ],
        )
      ],
    );
  }

  Widget buildNegotiationCard(String image, Color color, String content) {
    return CustomContainer(
      decoration: BoxDecoration(
        border: Border.all(color: hintLight, width: 1),
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      height: 17.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              color: color,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: content,
              fontWeight: FontWeight.w500,
              fontsize: 12,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppealProgressCard(Size size) {
    return GestureDetector(
      onTap: () {
        moveToAppealProgressView(context, viewModel.orderId);
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
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
        height: 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTickWithText(size, stringVariables.appealProgress, true),
          ],
        ),
      ),
    );
  }

  Widget buildOrderDetailsView(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String adType = capitalize(ordersData.tradeType ?? "buy");
    String cryptoCurrency = adType == stringVariables.buy
        ? ordersData.toAsset ?? ""
        : ordersData.fromAsset ?? "";
    double cryptoAmount =
        double.parse(trimDecimals('${ordersData.amount ?? 0.0}'));
    double fiatAmount = double.parse('${ordersData.total ?? 0.0}');
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset ?? ""
        : ordersData.toAsset ?? "";
    String orderNo = ordersData.id ?? '';
    String createdDate =
        getDate((ordersData.modifiedDate ?? DateTime.now().toUtc()).toString());
    double price = ordersData.price ?? 0.0;
    paymentStatus = ordersData.status ?? '';
    String buyer = ordersData.counterParty ?? "";
    bool isBuyFlow = ordersData.buyerId == ordersData.loggedInUser;
    String sellerId =
        !isBuyFlow ? ordersData.buyerId ?? "" : ordersData.sellerId ?? "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: adType,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
              color: adType == stringVariables.buy ? green : red,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: cryptoCurrency,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomCircleAvatar(
              radius: 12,
              backgroundColor: Colors.transparent,
              child: FadeInImage.assetNetwork(
                image: getImage(cryptoCurrency),
                placeholder: splash,
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomText(
                  fontfamily: 'GoogleSans',
                  text: stringVariables.fiatAmount,
                  fontsize: 14,
                  fontWeight: FontWeight.w400,
                  color: hintLight,
                ),
              ],
            ),
            Row(
              children: [
                CustomText(
                  fontfamily: 'GoogleSans',
                  text: "$fiatAmount",
                  fontsize: 24,
                  fontWeight: FontWeight.bold,
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
                      fontfamily: 'GoogleSans',
                      text: fiatCurrency,
                      fontsize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                CustomSizedBox(
                  width: 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                            ClipboardData(text: '${fiatAmount}${fiatCurrency}'))
                        .then((_) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      customSnackBar.showSnakbar(context,
                          stringVariables.copySnackBar, SnackbarType.positive);
                    });
                  },
                  child: SvgPicture.asset(
                    copy,
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
          height: 0.02,
        ),
        buildTextField(stringVariables.price, "$price $fiatCurrency"),
        CustomSizedBox(
          height: 0.02,
        ),
        buildTextField(
            stringVariables.cryptoAmount, "$cryptoAmount $cryptoCurrency"),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
        buildTextField(stringVariables.orderNumber, orderNo, true),
        CustomSizedBox(
          height: 0.02,
        ),
        buildTextField(stringVariables.createdDate, createdDate),
        CustomSizedBox(
          height: 0.02,
        ),
        buildTextWithWidget(
          stringVariables.counterparty,
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              moveToCounterProfile(context, sellerId);
            },
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(7.5, 0),
                  child: CustomText(
                    decoration: TextDecoration.underline,
                    fontfamily: 'GoogleSans',
                    text: buyer,
                    fontsize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Transform.translate(
                  offset: Offset(7.5, 0),
                  child: CustomContainer(
                    width: 20,
                    height: 40,
                    child: SvgPicture.asset(
                      p2pRightArrow,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildTextWithWidget(String title, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: title,
              color: hintLight,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        Row(
          children: [
            child,
            CustomSizedBox(
              width: 0.02,
            )
          ],
        )
      ],
    );
  }

  Widget buildAppealHintsView(Size size) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.005,
        ),
        buildPointsWithContent(
            stringVariables.one,
            stringVariables.appealProgressContent1,
            true,
            stringVariables.appealProgressContent2,
            stringVariables.consensusReachedInQuotes),
        CustomSizedBox(
          height: 0.015,
        ),
        buildPointsWithContent(
            stringVariables.two,
            stringVariables.appealProgressContent3,
            true,
            stringVariables.appealProgressContent4,
            stringVariables.negotiationFailedInQuotes),
        CustomSizedBox(
          height: 0.015,
        ),
        buildPointsWithContent(
            stringVariables.three, stringVariables.appealProgressContent5),
        CustomSizedBox(
          height: 0.015,
        ),
        buildPointsWithContent(
            stringVariables.four,
            stringVariables.appealProgressContent6,
            true,
            stringVariables.appealProgressContent7,
            " " + stringVariables.provideMoreInfo + ".", () {
          moveToProvideMoreInfoView(context, viewModel.orderId, true);
        }),
      ],
    );
  }

  String getImage(String crypto) {
    List<dynamic> list = [];
    list = constant.userLoginStatus.value
        ? (walletViewModel.viewModelDashBoardBalance != null)
            ? (walletViewModel.viewModelDashBoardBalance!.isNotEmpty)
                ? walletViewModel.viewModelDashBoardBalance!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : []
        : (marketViewModel.getCurrencies != null)
            ? (marketViewModel.getCurrencies!.isNotEmpty)
                ? marketViewModel.getCurrencies!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : [];
    return (list == null || list.isEmpty) ? "" : list.first.image;
  }

  Widget buildTextField(String title, String value,
      [bool copyText = false, bool alertText = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: title,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            alertText
                ? Row(
                    children: [
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      SvgPicture.asset(
                        p2pOrderAttention,
                        color: hintLight,
                      ),
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
        Row(
          children: [
            CustomContainer(
              width: 2.5,
              child: CustomText(
                fontfamily: 'GoogleSans',
                text: value,
                align: TextAlign.end,
                fontsize: 14,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
                softwrap: true,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            copyText
                ? Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: '${value}'))
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
                      CustomSizedBox(
                        width: 0.02,
                      ),
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ],
    );
  }

  Widget buildTickWithText(Size size, String content,
      [bool arrowNeeded = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              width: 0.03,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.5),
              child: CustomText(
                maxlines: 2,
                fontfamily: 'GoogleSans',
                text: content,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                fontsize: 14,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(
              p2pRightArrow,
              height: 30,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
          ],
        )
      ],
    );
  }

  Widget buildHeaderTimer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomText(
                  text: stringVariables.appeal,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.bold,
                  fontsize: 22,
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    moveToChatView(context, widget.id);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    p2pChat,
                    color: hintLight,
                  ),
                ),
                CustomSizedBox(
                  width: 0.03,
                ),
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: stringVariables.respondAppealWithin,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text:
                  '${viewModel.formatedTime(time: viewModel.appealCountDown)}',
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: themeColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPointsWithContent(String point, String content,
      [bool split = false,
      String anotherContent = "",
      String highlightContent = "",
      VoidCallback? func]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: point + ".",
              fontWeight: FontWeight.w400,
              fontsize: 14,
            ),
          ],
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              width: 1.25,
              child: split
                  ? Text.rich(
                      softWrap: true,
                      TextSpan(
                          text: content,
                          style: TextStyle(
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                            fontSize: 14,
                            fontFamily: 'GoogleSans',
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: highlightContent,
                                style: TextStyle(
                                    color: func != null
                                        ? themeColor
                                        : themeSupport().isSelectedDarkMode()
                                            ? white
                                            : black,
                                    fontSize: 14,
                                    fontFamily: 'GoogleSans',
                                    fontWeight: func != null
                                        ? FontWeight.w400
                                        : FontWeight.bold,
                                    decoration: func != null
                                        ? TextDecoration.underline
                                        : null),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = func),
                            TextSpan(
                              text: anotherContent,
                              style: TextStyle(
                                color: themeSupport().isSelectedDarkMode()
                                    ? white
                                    : black,
                                fontSize: 14,
                                fontFamily: 'GoogleSans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]),
                    )
                  : CustomText(
                      fontfamily: 'GoogleSans',
                      text: content,
                      fontWeight: FontWeight.w400,
                      fontsize: 14,
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
