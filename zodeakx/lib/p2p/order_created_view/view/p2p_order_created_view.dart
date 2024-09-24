import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/view/p2p_home_view.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../orders/model/UserOrdersModel.dart';
import '../../profile/model/UserPaymentDetailsModel.dart';

class P2POrderCreatedView extends StatefulWidget {
  final String id;
  final String? adId;
  final String? paymentMethodName;
  final int? timeLimit;

  const P2POrderCreatedView(
      {Key? key,
      required this.id,
      required this.adId,
      this.paymentMethodName,
      this.timeLimit})
      : super(key: key);

  @override
  State<P2POrderCreatedView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2POrderCreatedView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  final GlobalKey _cryptoKey = GlobalKey();

  String? banktype;

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
      viewModel.setLoading(true);
      viewModel.fetchOrderDetails(
          widget.id, '${widget.paymentMethodName}', '${widget.adId}');
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
            : buildP2POrderCreatedView(size),
      ),
    );
  }

  Widget buildP2POrderCreatedView(Size size) {
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
                                buildBasicDetailsCard(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildAttentionCard(size,
                                    stringVariables.orderCreatedAttention),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildOrderDetailsCard(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildPaymentMethodsCard(size)
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
                                CustomElevatedButton(
                                    buttoncolor: grey,
                                    color: hintLight,
                                    press: () {
                                      moveToCancelOrderView(context, widget.id);
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
                                      moveToPayTheSellerView(
                                          context,
                                          widget.id,
                                          banktype ?? widget.paymentMethodName,
                                          widget.adId,
                                          viewModel.userOrdersModel);
                                    },
                                    width: 2.45,
                                    isBorderedButton: true,
                                    maxLines: 1,
                                    icon: null,
                                    multiClick: true,
                                    text: stringVariables.makePayment,
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

  Widget buildAttentionCard(Size size, String content) {
    return CustomContainer(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: themeColor.withOpacity(0.2)),
      width: 1,
      height: isSmallScreen(context) ? 10.5 : 12.75,
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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
              width: 1.4,
              child: CustomText(
                strutStyleHeight: 1.5,
                text: content,
                fontfamily: 'GoogleSans',
                softwrap: true,
                fontWeight: FontWeight.w400,
                fontsize: 14,
                color: themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBasicDetailsCard(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String name = ordersData.kycName ?? 'DDriveraCripto';

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
      height: isSmallScreen(context) ? 5.25 : 5.75,
      child: Column(
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
                  CustomContainer(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: themeColor),
                    child: Center(
                        child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: name.isNotEmpty ? name[0].toUpperCase() : " ",
                      fontWeight: FontWeight.bold,
                      fontsize: 11,
                      color: black,
                    )),
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomContainer(
                    constraints: BoxConstraints(maxWidth: size.width / 2.4),
                    child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: name,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 15,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.005,
                  ),
                  SvgPicture.asset(
                    p2pVerified,
                  ),
                ],
              ),
            ],
          ),
          buildTickWithText(size, stringVariables.orderCreatedContent1, true),
          CustomSizedBox(
            height: 0.02,
          ),
          buildTickWithText(size, stringVariables.orderCreatedContent2),
          CustomSizedBox(
            height: 0.02,
          ),
        ],
      ),
    );
  }

  Widget buildOrderDetailsCard(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String name = ordersData.kycName ?? '';
    String adType = capitalize(ordersData.tradeType ?? "buy");
    String cryptoCurrency = adType == stringVariables.buy
        ? ordersData.toAsset!
        : ordersData.fromAsset!;
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset!
        : ordersData.toAsset!;
    double cryptoAmount =
        double.parse(trimDecimals('${ordersData.amount ?? 0.0}'));
    double fiatAmount =
        double.parse(trimDecimals('${ordersData.total ?? 0.0}'));
    double price = ordersData.price ?? 0.0;
    String orderNo = ordersData.id ?? '';

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
      height: isSmallScreen(context) ? 3.7 : 4.2,
      child: Column(
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
            height: 0.02,
          ),
          buildTextField(size, stringVariables.orderNumber, orderNo, true),
          CustomSizedBox(
            height: 0.005,
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethodsCard(Size size) {
    String orderNo = "";
    List<UserPaymentDetails> paymentMethod = (viewModel.paymentMethods ?? []);
    List<Widget> paymentCard = [];
    int paymentCardListCount = paymentMethod.length;
    for (var i = 0; i < paymentCardListCount; i++) {
      paymentCard.add(
          paymentMethodsCard(size, banktype ?? '${widget.paymentMethodName}'));
    }
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
      height: isSmallScreen(context) ? 8 : 9.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomText(
                    fontfamily: 'GoogleSans',
                    text: stringVariables.paymentMethod,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 16,
                  ),
                ],
              ),
              PopupMenuButton(
                  padding: EdgeInsets.zero,
                  key: _cryptoKey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  offset: Offset(size.width / -16.6, size.width / 7.5),
                  constraints: BoxConstraints(
                    minWidth: (size.width * 0.5),
                    maxWidth: (size.width * 0.5),
                    minHeight: (size.height / 15),
                    maxHeight: (size.height / 2.625),
                  ),
                  icon: SvgPicture.asset(
                    p2pDownArrow,
                    height: 7,
                    color: hintLight,
                  ),
                  onSelected: (value) {
                    viewModel.setSelectedFiat(value.toString());
                    banktype = value.toString();
                  },
                  color:
                      themeSupport().isSelectedDarkMode() ? card_dark : white,
                  itemBuilder: (
                    BuildContext context,
                  ) {
                    return viewModel.bankNames
                        .map<PopupMenuItem>((String value) {
                      return buildPopupItem(size, value);
                    }).toList();
                  }),
            ],
          ),
          //buildTextField(stringVariables.refMessage, orderNo, false, true),
          Row(children: paymentCard),
          CustomSizedBox(
            height: 0.02,
          )
        ],
      ),
    );
  }

  PopupMenuItem buildPopupItem(Size size, String menuItem) {
    return PopupMenuItem(
      value: menuItem,
      child: CustomText(
        fontfamily: 'GoogleSans',
        align: TextAlign.center,
        fontsize: 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        text: menuItem,
      ),
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
              constraints: BoxConstraints(maxWidth: size.width / 2.4),
              child: CustomText(
                overflow: TextOverflow.ellipsis,
                fontfamily: 'GoogleSans',
                text: value,
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
            Column(
              children: [
                CustomSizedBox(
                  height: 0.001,
                ),
                SvgPicture.asset(
                  p2pTick,
                ),
              ],
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.51),
              child: CustomText(
                maxlines: 2,
                fontfamily: 'GoogleSans',
                text: content,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
                fontsize: 14,
              ),
            ),
          ],
        ),
        arrowNeeded
            ? Row(
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
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
      ],
    );
  }

  Widget buildHeaderTimer() {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String id = ordersData.id ?? "";
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
              text: stringVariables.paySellerWithin,
              fontsize: 16,
              fontWeight: FontWeight.w400,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: '${viewModel.formatedTime(time: viewModel.countDown)}',
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: themeColor,
            ),
          ],
        ),
        Row(
          children: [
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
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              width: 0.02,
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
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.orderCreate,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'GoogleSans',
              fontWeight: FontWeight.bold,
              fontsize: 20,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}
