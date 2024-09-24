import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../orders/model/UserOrdersModel.dart';
import 'p2p_leave_comments_bottom_sheet.dart';

class P2POrderDetailsView extends StatefulWidget {
  final String id;
  final String? user_id;
  final String? adid;
  final String? paymentMethodName;
  final String? view;

  const P2POrderDetailsView(
      {Key? key,
      required this.id,
      this.paymentMethodName,
      this.adid,
      this.user_id,
      this.view})
      : super(key: key);

  @override
  State<P2POrderDetailsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2POrderDetailsView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  late AnimationController rotationController;
  int count = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    rotationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    viewModel.fetchOrderDetails(
        '${widget.id}', '${widget.paymentMethodName}', '${widget.adid}');
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.setCompletedExpandFlag(false);
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
            : buildP2POrderDetailsView(size),
      ),
    );
  }

  Widget buildP2POrderDetailsView(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String status = ordersData.status ?? "";
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubHeader(size),
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
                    padding: EdgeInsets.symmetric(horizontal: size.width / 35),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          buildOrderDetailsCard(size),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          buildPaymentMethodsCard(size),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          status == stringVariables.completed.toLowerCase()
                              ? buildRatingView(size)
                              : CustomSizedBox(
                                  width: 0,
                                  height: 0,
                                ),
                        ],
                      ),
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

  Widget buildOrderDetailsCard(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String adType = capitalize(ordersData.tradeType!);
    String cryptoCurrency = adType == stringVariables.buy
        ? ordersData.toAsset!
        : ordersData.fromAsset!;
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset!
        : ordersData.toAsset!;
    double cryptoAmount =
        double.parse(trimDecimals(ordersData.amount.toString()));
    double fiatAmount = double.parse(trimDecimals(ordersData.total.toString()));
    double price = double.parse(trimDecimals(ordersData.price.toString()));
    String orderNo = ordersData.id ?? "";
    String orderDate =
        getDate((ordersData.createdDate ?? ordersData.modifiedDate).toString());
    String buyer = ordersData.counterParty ?? "";
    bool isBuyFlow = ordersData.buyerId == ordersData.loggedInUser;
    String sellerId =
        !isBuyFlow ? ordersData.buyerId ?? "" : ordersData.sellerId ?? "";
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode()
            ? switchBackground.withOpacity(0.15)
            : enableBorder.withOpacity(0.25),
        border: Border.all(color: hintLight, width: 1),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      width: size.width,
      height: viewModel.completedExpandFlag
          ? isSmallScreen(context)
              ? size.height / 2.4
              : size.height / 2.75
          : isSmallScreen(context)
              ? size.height / 4
              : size.height / 4.6,
      duration: Duration(milliseconds: 200),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSizedBox(
              height: 0.01,
            ),
            Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
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
                  fontfamily: 'InterTight',
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
                      fontfamily: 'InterTight',
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
                      fontfamily: 'InterTight',
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
                          fontfamily: 'InterTight',
                          text: fiatCurrency,
                          fontsize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
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
            buildTextField(size, stringVariables.price, "$price $fiatCurrency"),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTextField(size, stringVariables.cryptoAmount,
                "$cryptoAmount $cryptoCurrency"),
            CustomSizedBox(
              height: viewModel.completedExpandFlag ? 0.005 : 0.01,
            ),
            viewModel.completedExpandFlag
                ? Column(
                    children: [
                      Divider(
                        color: divider,
                        thickness: 0.2,
                      ),
                      CustomSizedBox(height: 0.01),
                      buildTextField(
                          size, stringVariables.orderNumber, orderNo, true),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      buildTextField(
                          size, stringVariables.createdDate, orderDate),
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
                                  fontfamily: 'InterTight',
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
                                    color: themeSupport().isSelectedDarkMode()
                                        ? white
                                        : black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.015,
                      ),
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  ),
            GestureDetector(
              onTap: () {
                if (viewModel.completedExpandFlag)
                  rotationController.reverse();
                else
                  rotationController.forward();
                viewModel
                    .setCompletedExpandFlag(!viewModel.completedExpandFlag);
              },
              behavior: HitTestBehavior.opaque,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5).animate(rotationController),
                child: CustomContainer(
                  width: 20,
                  height: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      p2pDownArrow,
                      color: hintLight,
                      height: 7.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodsCard(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String orderNo = ordersData.id ?? "";
    String status = ordersData.status ?? "";
    String paymentName = ordersData.paymentMethod?.paymentMethodName ?? "";
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
      height: isSmallScreen(context) ? 8 : 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                    fontfamily: 'InterTight',
                    text: stringVariables.paymentMethod,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 16,
                  ),
                ],
              ),
              paymentName.isNotEmpty
                  ? paymentMethodsCard(size, paymentName, false, true)
                  : CustomSizedBox(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          status == stringVariables.completed.toLowerCase()
              ? buildTextField(
                  size, stringVariables.refMessage, orderNo, false, true)
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 50),
                  child: CustomText(
                    fontfamily: 'InterTight',
                    text: stringVariables.paymentCannotDisplayed,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                  ),
                ),
        ],
      ),
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
              fontfamily: 'InterTight',
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

  Widget paymentMethodsCard(Size size, String title,
      [bool startingGap = true, bool flip = false]) {
    Color cardColor = randomColor();
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
        flip
            ? CustomSizedBox(
                width: 0,
                height: 0,
              )
            : Row(
                children: [
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
                ],
              ),
        CustomText(
          fontfamily: 'InterTight',
          text: title,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
          fontsize: 14,
        ),
        flip
            ? Row(
                children: [
                  CustomSizedBox(
                    width: 0.015,
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
                    width: 0.02,
                  )
                ],
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
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
              constraints: BoxConstraints(maxWidth: size.width / 3.25),
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
                Clipboard.setData(ClipboardData(text: value)).then((_) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  customSnackBar.showSnakbar(context,
                      stringVariables.copySnackBar, SnackbarType.positive);
                });
              },
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                copy,
              ),
            ),
          ],
        ),
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

  Widget buildTextField(Size size, String title, String value,
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
              fontfamily: 'InterTight',
              text: title,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            // alertText
            //     ? Row(
            //         children: [
            //           CustomSizedBox(
            //             width: 0.02,
            //           ),
            //           SvgPicture.asset(
            //             p2pOrderAttention,
            //             color: hintLight,
            //           ),
            //         ],
            //       )
            //     : CustomSizedBox(
            //         width: 0,
            //         height: 0,
            //       )
          ],
        ),
        Row(
          children: [
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 2.5),
              child: CustomText(
                fontfamily: 'InterTight',
                text: value,
                overflow: TextOverflow.ellipsis,
                fontsize: 14,
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
                          Clipboard.setData(ClipboardData(text: value))
                              .then((_) {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            customSnackBar.showSnakbar(
                                context,
                                stringVariables.copySnackBar,
                                SnackbarType.positive);
                          });
                        },
                        behavior: HitTestBehavior.opaque,
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

  Widget buildSubHeader(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String status = ordersData.status ?? "";
    String amount = trimDecimals(ordersData.amount.toString());
    String adType = capitalize(ordersData.tradeType!);
    String crypto = adType == stringVariables.buy
        ? ordersData.toAsset!
        : ordersData.fromAsset!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                fontfamily: 'InterTight',
                text: status == stringVariables.completed.toLowerCase()
                    ? stringVariables.orderCompleted
                    : stringVariables.orderCancelled,
                fontsize: 22,
                fontWeight: FontWeight.bold,
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              CustomText(
                fontfamily: 'InterTight',
                text: status == stringVariables.completed.toLowerCase()
                    ? stringVariables.successfullyPurchased + " $amount $crypto"
                    : stringVariables.youCancelledOrder,
                fontsize: 14,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          SvgPicture.asset(
            status == stringVariables.completed.toLowerCase()
                ? p2pTick
                : p2pOrderAttention,
            height: 40,
            color: status == stringVariables.completed.toLowerCase()
                ? null
                : hintLight,
          ),
        ],
      ),
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
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String orderNo = ordersData.id ?? "";
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
                    count = 0;
                    (widget.view == "creationView")
                        ? Navigator.of(context).popUntil((_) => count++ >= 4)
                        : (widget.view == 'sell')
                            ? Navigator.of(context)
                                .popUntil((_) => count++ >= 5)
                            : Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: CustomContainer(
                      padding: 7.5,
                      width: 12,
                      height: 24,
                      child: SvgPicture.asset(
                        backArrow,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: viewModel.needToLoad
                ? CustomSizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: size.width / 25),
                          child: GestureDetector(
                            onTap: () {
                              moveToChatView(context, orderNo);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  p2pChat,
                                  color: themeColor,
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
                                  color: themeSupport().isSelectedDarkMode()
                                      ? white
                                      : black,
                                ),
                              ],
                            ),
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

  dynamic _showModal(BuildContext context) async {
    final result =
        await Navigator.of(context).push(P2PLeaveCommentsModel(context));
  }

  Widget ratingCard(Size size, bool isPositive, Color color, String title) {
    return GestureDetector(
      onTap: () {
        if (viewModel.isRated == null) {
          Future.delayed(Duration(milliseconds: 250), () {
            viewModel.setIsRated(isPositive);
          });
          _showModal(context);
        } else
          _showModal(context);
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
        padding: 1.5,
        child: Row(
          children: [
            CustomCard(
                radius: 50,
                color: themeSupport().isSelectedDarkMode() ? white70 : null,
                child: CustomContainer(
                  width: 12,
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        isPositive ? p2pThumbPositive : p2pThumbNegative,
                        height: 18,
                        color: color,
                      ),
                    ],
                  ),
                ),
                elevation: 5,
                edgeInsets: 0,
                outerPadding: 0),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              text: title,
              fontfamily: 'InterTight',
              softwrap: true,
              fontWeight: FontWeight.w500,
              fontsize: 14,
              color: (color == hintLight.withOpacity(0.8))
                  ? themeSupport().isSelectedDarkMode()
                      ? white
                      : black
                  : themeSupport().isSelectedDarkMode()
                      ? black
                      : white,
            ),
          ],
        ),
        width: 2.65,
        decoration: BoxDecoration(
          color: (color == hintLight.withOpacity(0.8)) ? black12 : color,
          borderRadius: BorderRadius.circular(
            500.0,
          ),
        ),
      ),
    );
  }

  Widget buildRatingView(Size size) {
    bool? isRated = viewModel.isRated;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: isRated == null
                  ? stringVariables.tradingExperience
                  : stringVariables.yourFeedback,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomContainer(
              width: 1.25,
              child: Row(
                mainAxisAlignment: isRated != null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  (isRated != null && isRated)
                      ? ratingCard(size, true, green, stringVariables.positive)
                      : isRated != null
                          ? CustomSizedBox(
                              width: 0,
                              height: 0,
                            )
                          : ratingCard(size, true, hintLight.withOpacity(0.8),
                              stringVariables.positive),
                  (isRated != null && !isRated)
                      ? ratingCard(size, false, red, stringVariables.negative)
                      : isRated != null
                          ? CustomSizedBox(
                              width: 0,
                              height: 0,
                            )
                          : ratingCard(size, false, hintLight.withOpacity(0.8),
                              stringVariables.negative),
                ],
              ),
            ),
            isRated != null
                ? Column(
                    children: [
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      CustomText(
                        press: () {
                          _showModal(context);
                        },
                        fontfamily: 'InterTight',
                        text: stringVariables.leaveComments,
                        fontsize: 14,
                        fontWeight: FontWeight.w500,
                        color: themeColor,
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
}
