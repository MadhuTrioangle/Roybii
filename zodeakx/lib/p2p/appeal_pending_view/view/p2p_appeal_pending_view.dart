import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import 'package:zodeakx_mobile/p2p/orders/model/UserOrdersModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
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

class P2PAppealPendingView extends StatefulWidget {
  final OrdersData ordersData;

  const P2PAppealPendingView({Key? key, required this.ordersData})
      : super(key: key);

  @override
  State<P2PAppealPendingView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PAppealPendingView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;

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
      OrdersData ordersData = widget.ordersData;
      bool isBuyFlow = ordersData.buyerId == ordersData.loggedInUser;
      String sellerId =
          ordersData.tradeType == stringVariables.buy.toLowerCase()
              ? !isBuyFlow
                  ? ordersData.buyerId ?? ""
                  : ordersData.sellerId ?? ""
              : isBuyFlow
                  ? ordersData.buyerId ?? ""
                  : ordersData.sellerId ?? "";
      viewModel.userId = sellerId;
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
            : buildP2PAppealPendingView(size),
      ),
    );
  }

  Widget buildP2PAppealPendingView(Size size) {
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          buildAppealHintsView(size),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          buildAppealProgressCard(size),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          buildOrderDetailsView(size),
                          CustomSizedBox(
                            height: 0.02,
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

  Widget buildAppealProgressCard(Size size) {
    OrdersData ordersData = widget.ordersData;
    String id = ordersData.id ?? "";
    String adType = capitalize((ordersData.tradeType ?? "buy"));
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset!
        : ordersData.toAsset!;
    double price =
        double.parse(trimDecimals((ordersData.price ?? 0).toString()));
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    return GestureDetector(
      onTap: () {
        moveToAppealProgressView(
            context, id, price.toString(), currencySymbol, adType);
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
    OrdersData ordersData = widget.ordersData;
    String adType = capitalize((ordersData.tradeType ?? "buy"));
    String cryptoCurrency = adType == stringVariables.buy
        ? ordersData.toAsset!
        : ordersData.fromAsset!;
    double cryptoAmount =
        double.parse(trimDecimals('${ordersData.amount ?? 0}'));
    double fiatAmount = double.parse('${ordersData.price ?? 0.0}');
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset!
        : ordersData.toAsset!;
    String orderNo = ordersData.id ?? "";
    String seller = ordersData.counterParty ?? "";
    bool isBuyFlow = ordersData.buyerId == ordersData.loggedInUser;
    String sellerId =
        !isBuyFlow ? ordersData.buyerId ?? "" : ordersData.sellerId ?? "";
    String date = getDate(ordersData.modifiedDate.toString());
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
                    Clipboard.setData(ClipboardData(text: '${fiatAmount}'))
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
        buildTextField(
            size, stringVariables.price, "$cryptoAmount $cryptoCurrency"),
        CustomSizedBox(
          height: 0.02,
        ),
        buildTextField(size, stringVariables.cryptoAmount,
            "$cryptoAmount $cryptoCurrency"),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
        buildTextField(size, stringVariables.orderNumber, orderNo, true),
        CustomSizedBox(
          height: 0.02,
        ),
        buildTextField(size, stringVariables.createdDate, date),
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
                    text: seller,
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
            stringVariables.one, stringVariables.appealPendingContent1),
        CustomSizedBox(
          height: 0.02,
        ),
        buildPointsWithContent(
            stringVariables.two,
            stringVariables.appealPendingContent2,
            true,
            stringVariables.appealPendingContent3,
            stringVariables.provideMoreInfo + "."),
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
              constraints: BoxConstraints(maxWidth: size.width / 2.5),
              child: CustomText(
                fontfamily: 'GoogleSans',
                overflow: TextOverflow.ellipsis,
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
    OrdersData ordersData = widget.ordersData;
    String id = ordersData.id ?? "";
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
                  text: stringVariables.appealPending,
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
                    moveToChatView(context, id);
                  },
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
              text: stringVariables.waitForCSintervention,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPointsWithContent(String point, String content,
      [bool split = false,
      String anotherContent = "",
      String highlightContent = ""]) {
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
              width: 1.23,
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
                                    color: themeColor,
                                    fontSize: 14,
                                    fontFamily: 'GoogleSans',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    moveToProvideMoreInfoView(
                                        context, viewModel.orderId, true);
                                  }),
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
