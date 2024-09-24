import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomCircularProgressIndicator.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/model/p2p_advertisement.dart';
import '../../home/view/p2p_home_view.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../orders/model/UserOrdersModel.dart';
import '../../profile/view_model/p2p_profile_view_model.dart';

class P2PWaitingPaymentView extends StatefulWidget {
  final String id;
  final String user_id;
  final String? paymentMethodName;
  final int? timeLimit;

  const P2PWaitingPaymentView(
      {Key? key,
      required this.id,
      required this.user_id,
      this.paymentMethodName,
      this.timeLimit})
      : super(key: key);

  @override
  State<P2PWaitingPaymentView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PWaitingPaymentView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late P2PProfileViewModel p2PProfileViewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  String logginUser = '';
  String buyerName = '';
  String orderNo = '';

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
    p2PProfileViewModel =
        Provider.of<P2PProfileViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.fetchOrderDetails(widget.user_id, '${widget.paymentMethodName}', '${widget.id}');
      p2PProfileViewModel.findUserCenter();
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2POrderCreationViewModel>();
    p2PProfileViewModel = context.watch<P2PProfileViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PWaitingPaymentView(size),
      ),
    );
  }

  Widget buildP2PWaitingPaymentView(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    if (ordersData.sellerId == ordersData.loggedInUser) {
      logginUser = ordersData.sellerId ?? "";
    } else {
      logginUser = ordersData.buyerId ?? "";
    } 
    String paymentStatus = ordersData.status ?? '';
    String adType = capitalize(ordersData.tradeType ?? "buy");
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeaderTimer(size),
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
                                    buttoncolor: paymentStatus == 'paid'
                                        ? themeColor
                                        : grey,
                                    color: paymentStatus == 'paid'
                                        ? black
                                        : hintLight,
                                    press: () {
                                      if (paymentStatus == 'paid')
                                        moveToProvideMoreInfoView(
                                            context, viewModel.orderId, false);
                                    },
                                    width: 2.45,
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
                                CustomElevatedButton(
                                    buttoncolor: paymentStatus == 'paid'
                                        ? themeColor
                                        : grey,
                                    color: paymentStatus == 'paid'
                                        ? black
                                        : hintLight,
                                    press: () {
                                      paymentStatus == 'paid'
                                          ? moveToConfirmPaymentView(
                                              context,
                                              double.parse(
                                                  '${ordersData.total ?? 0.985}'),
                                              adType == stringVariables.buy
                                                  ? ordersData.fromAsset!
                                                  : ordersData.toAsset!,
                                              '${widget.paymentMethodName ?? ''}',
                                              '${widget.id}',
                                              logginUser,
                                              buyerName,
                                              orderNo,
                                            )
                                          : () {};
                                    },
                                    width: 2.45,
                                    isBorderedButton: true,
                                    maxLines: 1,
                                    icon: null,
                                    multiClick: true,
                                    text: stringVariables.confirmRelease,
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
      height: 11,
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
      ),
    );
  }

  Widget buildBasicDetailsCard(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String name = ordersData.kycName ?? stringVariables.accHolderName;
    buyerName = (p2PProfileViewModel.userCenter?.name ?? "") == " "
        ? (constant.userEmail.value.substring(0, 2) +
            "*****." +
            constant.userEmail.value.split(".").last)
        : (p2PProfileViewModel.userCenter?.name ?? "");
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
      height: 6,
      child: Column(
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      moveToChatView(context, orderNo);
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
                    width: 0.02,
                  ),
                ],
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.005,
          ),
          buildTickWithText(size, buyerName, true),
          CustomSizedBox(
            height: 0.015,
          ),
          buildTickWithText(
              size, stringVariables.orderCreatedContent2, false, true),
        ],
      ),
    );
  }

  Widget buildOrderDetailsCard(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String adType = capitalize(ordersData.tradeType ?? "buy");
    String cryptoCurrency = adType == stringVariables.buy
        ? ordersData.toAsset ?? "BTC"
        : ordersData.fromAsset ?? "USD";
    double cryptoAmount =
        double.parse(trimDecimals('${ordersData.amount ?? 0.0}'));
    double fiatAmount = double.parse('${ordersData.total ?? 0.0}');
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset ?? "USD"
        : ordersData.toAsset ?? "BTC";
    double price = ordersData.price ?? 0.0;
    orderNo = ordersData.id ?? '';
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
      height: 3.6,
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.015,
          ),
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
          buildTextField(size, stringVariables.price, "$price $cryptoCurrency"),
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
            height: 0.015,
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethodsCard(Size size) {
    String orderNo = "";
    List<PaymentMethod> paymentMethod =
        (dummyAdvertisement.paymentMethod ?? []);
    List<Widget> paymentCard = [];
    int paymentCardListCount = paymentMethod.length;
    for (var i = 0; i < paymentCardListCount; i++) {
      paymentCard.add(paymentMethodsCard(size, widget.paymentMethodName ?? ''));
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
      height: 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: 0.015,
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
                    text: stringVariables.paymentMethod,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 16,
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     SvgPicture.asset(
              //       p2pDownArrow,
              //       height: 7,
              //       color: hintLight,
              //     ),
              //     CustomSizedBox(
              //       width: 0.03,
              //     )
              //   ],
              // )
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(children: [
            paymentMethodsCard(size, '${widget.paymentMethodName}')
          ]),
        ],
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
              constraints: BoxConstraints(maxWidth: size.width / 3),
              child: CustomText(
                fontfamily: 'GoogleSans',
                text: value,
                fontsize: 14,
                overflow: TextOverflow.ellipsis,
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
      [bool profile = false, bool arrowNeeded = false]) {
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
                  profile ? p2pUser : p2pTick,
                ),
              ],
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.5),
              child: CustomText(
                strutStyleHeight: 1.35,
                fontfamily: 'GoogleSans',
                text: content,
                fontWeight: profile ? FontWeight.w500 : FontWeight.w400,
                overflow: TextOverflow.ellipsis,
                fontsize: profile ? 16 : 14,
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

  calculatePercentage(int percentage, int amount) {
    return (percentage / amount) * amount;
  }

  Widget buildHeaderTimer(Size size) {
    int? timeLimit = widget.timeLimit == 1 ? 60 : widget.timeLimit;
    int currentTime = viewModel.countDown;
    int totalTime = Duration(minutes: timeLimit ?? 0).inSeconds;
    double time = totalTime != 0
        ? calculatePercentage(currentTime, totalTime) / totalTime
        : 0;
    int timeLeft = (time * 25).round() < 0 ? 0 : (time * 25).round();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomContainer(
                  width: 2,
                  child: CustomText(
                    text: stringVariables.waitingForPayment,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.bold,
                    fontsize: 22,
                  ),
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
                  text: stringVariables.expectReceivesPaymentIn,
                  fontsize: 14,
                  fontWeight: FontWeight.w500,
                ),
                CustomSizedBox(
                  width: 0.01,
                ),
                CustomText(
                  fontfamily: 'GoogleSans',
                  text:
                      "${((widget.timeLimit == 1 ? 60 : (widget.timeLimit ?? 0)) / 4).toInt()} min",
                  fontsize: 14,
                  fontWeight: FontWeight.w500,
                  color: themeColor,
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomCircularProgressIndicator(
                      totalSteps: 25,
                      currentStep: timeLeft,
                      padding: math.pi / 15,
                      selectedColor: themeColor,
                      unselectedColor: switchBackground,
                      selectedStepSize: 6.5,
                      unselectedStepSize: 6.5,
                      width: 62,
                      height: 62,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
                      text:
                          '${viewModel.formatedTime(time: viewModel.countDown)}',
                      fontsize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: themeColor,
                    ),
                  ],
                ),
                CustomSizedBox(
                  width: 0.05,
                )
              ],
            ),
            CustomSizedBox(
              height: 0.01,
            )
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
