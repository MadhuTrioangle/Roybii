import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/p2p/orders/model/UserOrdersModel.dart';
import 'package:zodeakx_mobile/p2p/profile/model/UserPaymentDetailsModel.dart';

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
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

class P2PCryptoReleasingView extends StatefulWidget {
  final String id;
  final List<UserPaymentDetails>? paymentMethods;
  final UserOrdersModel? userOrdersModel;

  const P2PCryptoReleasingView(
      {Key? key, required this.id, this.paymentMethods, this.userOrdersModel})
      : super(key: key);

  @override
  State<P2PCryptoReleasingView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PCryptoReleasingView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  late AnimationController rotationController;
  String paymentStatus = '';

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
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // viewModel.leaveOrderLocalSocket(widget.id);
      // viewModel.getOrderLocalSocket(widget.id, viewModel.userOrdersModel?.result?.data?.first.tradeType ?? '');
      viewModel.setReleaseExpandFlag(false);
      viewModel.setLoading(true);
      viewModel.fetchOrderDetails(
          '${widget.id}',
          '${widget.paymentMethods?.first.paymentName ?? viewModel.userOrdersModel?.result?.data?.first.paymentMethod?.paymentMethodName}',
          '${widget.userOrdersModel?.result?.data?.first.advertisementId}');
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2POrderCreationViewModel>();
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PCryptoReleasingView(size),
      ),
    );
  }

  Widget buildP2PCryptoReleasingView(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String adType = (ordersData.tradeType ?? "buy");
    securedPrint("viewModel.countDown${viewModel.countDown}");
    securedPrint("viewModel.countDown${paymentStatus}");
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
                                  height: 0.02,
                                ),
                                buildOrderDetailsCard(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildPaymentMethodsCard(size, "bank_transfer"),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            CustomSizedBox(
                              height: 0.02,
                            ),
                            CustomElevatedButton(
                                buttoncolor: (paymentStatus == 'paid' &&
                                        viewModel.countDown <= 0)
                                    ? themeColor
                                    : grey,
                                color: (paymentStatus == 'paid' &&
                                        viewModel.countDown <= 0)
                                    ? black
                                    : hintLight,
                                press: () {
                                  if (paymentStatus == 'paid' &&
                                      viewModel.countDown <= 0) {
                                    moveToProvideMoreInfoView(
                                        context, viewModel.orderId, false);
                                    print("order id");
                                    print(viewModel.orderId);
                                  }
                                },
                                width: 1,
                                isBorderedButton: true,
                                maxLines: 1,
                                icon: null,
                                multiClick: true,
                                text: stringVariables.appeal,
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

  Widget buildOrderDetailsCard(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();

    String adType = capitalize((ordersData.tradeType ?? "buy"));
    String cryptoCurrency = adType == stringVariables.buy
        ? ordersData.toAsset ?? ""
        : ordersData.fromAsset ?? '';
    double cryptoAmount =
        double.parse(trimDecimals('${ordersData.amount ?? 0.0}'));
    double fiatAmount = double.parse('${ordersData.total ?? 0.0}');
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset ?? ''
        : ordersData.toAsset ?? '';
    String orderNo = ordersData.id ?? '';
    String createdDate =
        getDate((ordersData.createdDate ?? DateTime.now().toUtc()).toString());
    double price = ordersData.price ?? 0.0;
    paymentStatus = ordersData.status ?? '';
    String buyer = ordersData.kycName ?? " ";
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
      height: viewModel.releaseExpandFlag
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
                      text: "${fiatAmount}",
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
            viewModel.releaseExpandFlag
                ? Column(
                    children: [
                      Divider(
                        thickness: 0.2,
                        color: divider,
                      ),
                      CustomSizedBox(height: 0.01),
                      buildTextField(
                          size, stringVariables.orderNumber, orderNo, true),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      buildTextField(
                          size, stringVariables.createdDate, createdDate),
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
                                offset: Offset(
                                    Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? -7.5
                                        : 7.5,
                                    0),
                                child: CustomText(
                                  decoration: TextDecoration.underline,
                                  fontfamily: 'InterTight',
                                  text: buyer,
                                  fontsize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(
                                    Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? -7.5
                                        : 7.5,
                                    0),
                                child: CustomContainer(
                                  width: 20,
                                  height: 40,
                                  child: SvgPicture.asset(p2pRightArrow
                                      // rightArrow(context),
                                      //  color: themeSupport().isSelectedDarkMode()
                                      //      ? white
                                      //      : black,
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
                if (viewModel.releaseExpandFlag)
                  rotationController.reverse();
                else
                  rotationController.forward();
                viewModel.setReleaseExpandFlag(!viewModel.releaseExpandFlag);
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

  Widget buildPaymentMethodsCard(Size size, String title) {
    String orderNo = "";
    UserPaymentDetails paymentMethods =
        (widget.paymentMethods?.first ?? UserPaymentDetails());
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
      height: isSmallScreen(context)
          ? (name == stringVariables.upi || name == stringVariables.paytm)
              ? 4.9
              : 3.1
          : (name == stringVariables.upi || name == stringVariables.paytm)
              ? 5.4
              : 3.6,
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
              paymentMethodsCard(size, name, false, true),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          //buildTextField(stringVariables.refMessage, orderNo, false, true),
          CustomSizedBox(
            height: 0.02,
          ),
          buildPaymentDetails(size),
        ],
      ),
    );
  }

  Widget buildPaymentDetails(Size size) {
    UserPaymentDetails paymentMethods =
        (widget.paymentMethods?.first ?? UserPaymentDetails());
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String userName = ordersData.kycName ?? '';
    String name = paymentMethods.paymentName ?? "";
    Map<String, dynamic> paymentDetails = paymentMethods.paymentDetails ?? {};

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
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
                      capitalize(
                          paymentDetails.keys.toList()[i].replaceAll("_", " ")),
                      paymentDetails.values.toList()[i]),
            ],
          ),
        ],
      ),
    );
  }

  Widget paymentMethodsCard(Size size, String title,
      [bool startingGap = true, bool flip = false]) {
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
              constraints: BoxConstraints(maxWidth: size.width / 2.4),
              child: CustomText(
                fontfamily: 'InterTight',
                text: value,
                fontsize: 14,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                softwrap: true,
                maxlines: 1,
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

  Widget buildSubHeader(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 45),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontfamily: 'InterTight',
            text: stringVariables.releasingSubtitle,
            fontsize: 10,
            fontWeight: FontWeight.w400,
          ),
          CustomText(
            fontfamily: 'InterTight',
            text:
                '${viewModel.formatedTime(time: viewModel.countDown > 0 ? viewModel.countDown : 0)}',
            fontsize: 16,
            fontWeight: FontWeight.w400,
            color: themeColor,
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
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          // backButton(context),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.releasing,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.bold,
              fontsize: 20,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    moveToChatView(context, viewModel.orderId);
                    viewModel.getOrderLocalSocket(viewModel.orderId, '');
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
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ],
                  ),
                ),
                CustomSizedBox(
                  width: 0.05,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
