import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/home/model/p2p_advertisement.dart';
import 'package:zodeakx_mobile/p2p/home/view_model/p2p_home_view_model.dart';
import 'package:zodeakx_mobile/p2p/profile/model/UserPaymentDetailsModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../home/view/p2p_home_view.dart';
import '../../payment_methods/view_model/p2p_payment_methods_view_model.dart';
import '../ViewModel/p2p_order_creation_view_model.dart';

class P2POrderCreationView extends StatefulWidget {
  final bool isBuy;
  final int page;
  Advertisement advertisement;

  P2POrderCreationView(
      {Key? key,
      required this.isBuy,
      required this.page,
      required this.advertisement})
      : super(key: key);

  @override
  State<P2POrderCreationView> createState() => _P2POrderCreationViewState();
}

class _P2POrderCreationViewState extends State<P2POrderCreationView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late P2PHomeViewModel p2pHomeViewModel;
  late WalletViewModel walletViewModel;
  late TabController _tabController;
  TextEditingController amountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  String paymentId = '';
  late AnimationController rotationController;
  late P2PPaymentMethodsViewModel paymentMethodsViewModel;
  List<UserPaymentDetails>? paymentMethods;
  final GlobalKey payment_key = GlobalKey();
  String paymenttype = '';
  String balance = "0.00";
  int? timeLimit;
  GlobalKey<FormFieldState> amountFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> quantityFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> paymentFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  late FocusNode amountFocusNode;
  late FocusNode quantityFocusNode;
  late FocusNode paymentFocusNode;

  @override
  void initState() {
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    paymentMethodsViewModel =
        Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    paymentMethodsViewModel.fetchPaymentMethods();
    paymentMethodsViewModel.getJwtUserResponse();
    p2pHomeViewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    List<DashBoardBalance>? dashBoardBalance = walletViewModel
        .viewModelDashBoardBalance
        ?.where(
            (element) => element.currencyCode == widget.advertisement.fromAsset)
        .toList();
    if ((dashBoardBalance ?? []).isNotEmpty)
      balance =
          trimDecimals(dashBoardBalance!.first.availableBalance.toString());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        viewModel.setTabIndex(_tabController.index);
        if (_tabController.index == 1) {
          if (quantityController.text.isNotEmpty &&
              isNumeric(quantityController.text)) {
            calculateAmount(double.parse(quantityController.text));
            viewModel.setQuantity(quantityController.text);
          } else {
            viewModel.setQuantity("");
            viewModel.setAmount("");
          }
        } else {
          if (amountController.text.isNotEmpty &&
              isNumeric(amountController.text)) {
            calculateQuantity(double.parse(amountController.text));
            viewModel.setAmount(amountController.text);
          } else {
            viewModel.setQuantity("");
            viewModel.setAmount("");
          }
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setTabIndex(0);
      viewModel.setQuantity("");
      viewModel.setAmount("");
    });
    amountController.addListener(() {
      if (amountController.text.isNotEmpty &&
          isNumeric(amountController.text)) {
        calculateQuantity(double.parse(amountController.text));
        viewModel.setAmount(amountController.text);
      } else {
        viewModel.setQuantity("");
        viewModel.setAmount("");
      }
    });
    quantityController.addListener(() {
      if (quantityController.text.isNotEmpty &&
          isNumeric(quantityController.text)) {
        calculateAmount(double.parse(quantityController.text));
        viewModel.setQuantity(quantityController.text);
      } else {
        viewModel.setQuantity("");
        viewModel.setAmount("");
      }
    });

    amountFocusNode = FocusNode();
    quantityFocusNode = FocusNode();
    paymentFocusNode = FocusNode();
    validator(amountFieldKey, amountFocusNode);
    validator(quantityFieldKey, quantityFocusNode);
    validator(paymentFieldKey, paymentFocusNode);

    rotationController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    super.initState();
  }

  updateAdvertisement() {
    List<Advertisement> advertisement = viewModel.p2pAdvertisement?.data
            ?.where((element) => element.id == widget.advertisement.id)
            .toList() ??
        [];
    if (advertisement.isNotEmpty) widget.advertisement = advertisement.first;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  calculateQuantity(double value) {
    double quantity = value / (widget.advertisement.price?.toDouble() ?? 0.0);
    viewModel.setQuantity(quantity.toString());
  }

  calculateAmount(double value) {
    double amount = (widget.advertisement.price?.toDouble() ?? 0.0) * value;
    viewModel.setAmount(amount.toString());
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2POrderCreationViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider<P2POrderCreationViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return buildOrderCreation(size);
      },
    );
  }

  Widget buildOrderCreation(Size size) {
    String currency = widget.advertisement.fromAsset ?? "USDT";
    String name = widget.advertisement.name ?? "USDT";
    double price = widget.advertisement.price?.toDouble() ?? 0.0;
    double minAmount = widget.advertisement.minTradeOrder?.toDouble() ?? 0.0;
    double maxAmount = widget.advertisement.maxTradeOrder?.toDouble() ?? 0.0;
    timeLimit = widget.advertisement.paymentTimeLimit?.toInt() != 60
        ? widget.advertisement.paymentTimeLimit?.toInt() ?? 0
        : 1;

    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: CustomContainer(
          width: 1,
          height: 1,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 35),
                    child: SvgPicture.asset(
                      backArrow,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxlines: 1,
                  softwrap: true,
                  fontfamily: 'GoogleSans',
                  fontsize: 21,
                  fontWeight: FontWeight.bold,
                  text: (widget.isBuy
                          ? stringVariables.buy
                          : stringVariables.sell) +
                      " " +
                      currency,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(size, price, minAmount, maxAmount),
              CustomSizedBox(
                height: 0.02,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildCreation(
                          size, widget.advertisement.paymentMethod ?? []),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      buildAttentionCard(
                          size, stringVariables.p2pOrderCreateAttention),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      buildTradeInfo(
                          size,
                          "$timeLimit ${timeLimit == 1 ? stringVariables.hours : stringVariables.minutes}",
                          name,
                          (widget.advertisement.paymentMethod ?? [])),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showModel() async {
    final result =
        await Navigator.of(context).push(P2PTimeAndPaymentModel(context));
  }

  Widget header(
    Size size,
    double price,
    double min,
    double max,
  ) {
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == constant.userCurrency.value)
        .value;
    String crypto = widget.advertisement.fromAsset ?? "USDT";
    String fiat = widget.advertisement.toAsset ?? "USD";
    String side = widget.isBuy
        ? stringVariables.sell.toLowerCase()
        : stringVariables.buy.toLowerCase();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 100),
      child: Row(
        children: [
          CustomText(
            fontfamily: 'GoogleSans',
            text: stringVariables.price,
            color: textHeaderGrey,
            fontsize: 14,
            fontWeight: FontWeight.w400,
          ),
          CustomSizedBox(
            width: 0.02,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            text: currencySymbol,
            fontsize: 14,
            color: widget.isBuy ? green : red,
            fontWeight: FontWeight.w600,
          ),
          CustomSizedBox(
            width: 0.01,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            text: price.toString(),
            fontsize: 14,
            color: widget.isBuy ? green : red,
            fontWeight: FontWeight.w600,
          ),
          CustomSizedBox(
            width: 0.02,
          ),
          RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(rotationController),
            child: GestureDetector(
              onTap: () {
                rotationController.forward(from: 0.0);
                viewModel.fetchAdvertisement(
                    side,
                    crypto,
                    fiat,
                    updateAdvertisement,
                    p2pHomeViewModel.amount,
                    p2pHomeViewModel.payment,
                    widget.page);
              },
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                p2pRefresh,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
          ),
          CustomSizedBox(
            width: 0.08,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            text: stringVariables.limit,
            color: textHeaderGrey,
            fontsize: 14,
            fontWeight: FontWeight.w400,
          ),
          CustomSizedBox(
            width: 0.02,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            text: "$currencySymbol $min - $currencySymbol $max",
            fontsize: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget buildCreation(Size size, [List<PaymentMethod>? list]) {
    String adType = capitalize( widget.advertisement.advertisementType!);
    String crypto = adType == stringVariables.buy
        ? widget.advertisement.toAsset!
        : widget.advertisement.fromAsset!;
    double cryptoAmount = widget.advertisement.amount!.toDouble();
    String fiat = adType == stringVariables.buy
        ? widget.advertisement.fromAsset!
        : widget.advertisement.toAsset!;
    String adId = widget.advertisement.id ?? "USDT";
    String side = widget.isBuy
        ? stringVariables.buy.toLowerCase()
        : stringVariables.sell.toLowerCase();
    double minAmount = widget.advertisement.minTradeOrder?.toDouble() ?? 0.0;
    double maxAmount = widget.advertisement.maxTradeOrder?.toDouble() ?? 0.0;
    double price = widget.advertisement.price?.toDouble() ?? 0.0;
    double amount =
        viewModel.amount.isNotEmpty ? double.parse(viewModel.quantity) : 0.0;
    double total =
        viewModel.quantity.isNotEmpty ? double.parse(viewModel.amount) : 0.0;
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiat)
        .value;
    return CustomCard(
        radius: 25,
        edgeInsets: 0,
        outerPadding: 0,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(size.width / 35),
          child: Column(
            children: [
              CustomSizedBox(
                height: 0.01,
              ),
              CustomContainer(
                padding: 4.5,
                width: 1.5,
                height: isSmallScreen(context) ? 14 : 17,
                decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(
                    50.0,
                  ),
                ),
                child: TabBar(
                  overlayColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      50.0,
                    ),
                    color: themeColor,
                  ),
                  labelStyle: TextStyle(
                      fontFamily: 'GoogleSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  labelColor:
                      themeSupport().isSelectedDarkMode() ? black : white,
                  unselectedLabelColor: hintLight,
                  tabs: [
                    Tab(
                      text: stringVariables.byFiat,
                    ),
                    Tab(
                      text: stringVariables.byCrypto,
                    ),
                  ],
                ),
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              viewModel.tabIndex == 0
                  ? CustomTextFormField(
                      autovalid: AutovalidateMode.onUserInteraction,
                      validator: (input) => input!.isEmpty
                          ? stringVariables.enterAmount
                          : isNumeric(input)
                              ? double.parse(input) < minAmount
                                  ? stringVariables.minAmountIs + " $minAmount"
                                  : double.parse(input) > maxAmount
                                      ? stringVariables.maxAmountIs +
                                          " $maxAmount"
                                      : null
                              : null,
                      controller: amountController,
                      focusNode: amountFocusNode,
                      keys: amountFieldKey,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                      ],
                      isContentPadding: false,
                      contentPadding: EdgeInsets.zero,
                      size: 30,
                      text: stringVariables.enterAmount,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          amountController.text = maxAmount.toString();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              fontfamily: 'GoogleSans',
                              text: stringVariables.all,
                              color: themeColor,
                              fontsize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            fontfamily: 'GoogleSans',
                            text: currencySymbol,
                            fontsize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    )
                  : CustomTextFormField(
                      autovalid: AutovalidateMode.onUserInteraction,
                      validator: (input) => input!.isEmpty
                          ? stringVariables.enterQuantity
                          : isNumeric(viewModel.amount)
                              ? double.parse(viewModel.amount) < minAmount
                                  ? stringVariables.minAmountIs + " $minAmount"
                                  : double.parse(viewModel.amount) > maxAmount
                                      ? stringVariables.maxAmountIs +
                                          " $maxAmount"
                                      : null
                              : null,
                      controller: quantityController,
                      keys: quantityFieldKey,
                      focusNode: quantityFocusNode,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                      ],
                      isContentPadding: false,
                      contentPadding: EdgeInsets.only(left: 20, right: 10),
                      size: 30,
                      text: stringVariables.enterQuantity,
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            width: isSmallScreen(context) ? 5.55 : 5.75,
                            child: Row(
                              children: [
                                CustomText(
                                  fontfamily: 'GoogleSans',
                                  text: crypto,
                                  color: hintLight,
                                  fontsize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                CustomSizedBox(
                                  width: 0.015,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    double quantity = maxAmount /
                                        (widget.advertisement.price
                                                ?.toDouble() ??
                                            0.0);
                                    quantityController.text =
                                        quantity.toString();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: CustomText(
                                    fontfamily: 'GoogleSans',
                                    text: stringVariables.all,
                                    color: themeColor,
                                    fontsize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              CustomSizedBox(
                height: 0.02,
              ),
              viewModel.tabIndex == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                fontfamily: 'GoogleSans',
                                text: stringVariables.balance,
                                color: textHeaderGrey,
                                fontsize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              CustomSizedBox(
                                width: 0.01,
                              ),
                              CustomText(
                                fontfamily: 'GoogleSans',
                                text: balance,
                                color: textHeaderGrey,
                                fontsize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              CustomSizedBox(
                                width: 0.01,
                              ),
                              CustomText(
                                fontfamily: 'GoogleSans',
                                text: fiat,
                                color: textHeaderGrey,
                                fontsize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                        ],
                      ),
                    )
                  : CustomSizedBox(
                      height: 0,
                    ),
              !widget.isBuy
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            dynamic state = payment_key.currentState;
                            state.showButtonMenu();
                            if (paymentMethodsViewModel.paymentsList.isEmpty) {
                              CustomSnackBar().showSnakbar(
                                  context,
                                  "There is no payment method.",
                                  SnackbarType.negative);
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextFormField(
                              autovalid: AutovalidateMode.onUserInteraction,
                              validator: (input) => input!.isEmpty
                                  ? stringVariables.selectPaymentMethod
                                  : null,
                              controller: paymentController,
                              keys: paymentFieldKey,
                              focusNode: paymentFocusNode,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.]")),
                              ],
                              isReadOnly: true,
                              isContentPadding: false,
                              size: 30,
                              text: stringVariables.selectPaymentMethod,
                              suffixIcon: PopupMenuButton(
                                  padding: EdgeInsets.zero,
                                  key: payment_key,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  offset: Offset(
                                      size.width / -12.5, size.width / 7.5),
                                  constraints: BoxConstraints(
                                    minWidth: (size.width * 0.6),
                                    maxWidth: (size.width * 0.6),
                                    minHeight: (size.height / 15),
                                    maxHeight: (size.height / 2.625),
                                  ),
                                  icon: SvgPicture.asset(
                                    p2pDownArrow,
                                    height: 7,
                                    color: hintLight,
                                  ),
                                  onSelected: (value) {
                                    viewModel.setPaymentType(value.toString());
                                    paymentController.text = value.toString();
                                    if (value == stringVariables.bankTransfer)
                                      value = "bank_transfer";
                                    paymentId = paymentMethodsViewModel
                                            .paymentMethods
                                            ?.where(
                                              (element) =>
                                                  element.paymentName == value,
                                            )
                                            .first
                                            .id ??
                                        "";
                                  },
                                  color: themeSupport().isSelectedDarkMode()
                                      ? card_dark
                                      : white,
                                  itemBuilder: (
                                    BuildContext context,
                                  ) {
                                    return paymentMethodsViewModel.paymentsList
                                        .map<PopupMenuItem>((String value) {
                                      return buildPopupItem(size, value);
                                    }).toList();
                                  }),

                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     SvgPicture.asset(
                              //       height: 5,
                              //       p2pDownArrow,
                              //       color: themeSupport().isSelectedDarkMode()
                              //           ? white
                              //           : black,
                              //     ),
                              //   ],
                              // ),
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          height: 0.02,
                        ),
                      ],
                    )
                  : CustomSizedBox(
                      height: 0,
                    ),
              buildTextWithAmount(
                  stringVariables.quantity,
                  viewModel.quantity.isEmpty ? "---" : viewModel.quantity,
                  crypto),
              CustomSizedBox(
                height: 0.02,
              ),
              buildTextWithAmount(stringVariables.amount,
                  viewModel.amount.isEmpty ? "---" : viewModel.amount, fiat),
              CustomSizedBox(
                height: 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: viewModel.buttonLoader
                    ? CustomLoader()
                    : CustomElevatedButton(
                        buttoncolor: widget.isBuy ? green : red,
                        color: white,
                        press: () {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          if (viewModel.amount.isNotEmpty &&
                              viewModel.quantity.isNotEmpty &&
                              (widget.isBuy || paymentController.text.isNotEmpty)) {
                            viewModel.setButtonLoader(true);
                            if (constant.userLoginStatus.value) {
                              viewModel.setTimeLimit(timeLimit!);

                              if (paymentController.text ==
                                  stringVariables.bankTransfer)
                                paymentController.text = "bank_transfer";
                              widget.isBuy
                                  ? viewModel.fetchOrderCreation(
                                      adId,
                                      side,
                                      fiat,
                                      crypto,
                                      price,
                                      amount,
                                      total,
                                      list?[0].paymentMethodName,
                                      timeLimit)
                                  : viewModel.fetchOrderCreation(
                                      adId,
                                      side,
                                      crypto,
                                      fiat,
                                      price,
                                      amount,
                                      total,
                                      paymentController.text,
                                      timeLimit,
                                      paymentId,
                                    );
                              //moveToWaitingPaymentView(context, "id");
                              // viewModel.fetchOrderCreation(
                              //     adId, side, fiat, crypto, price, amount, total);
                            } else {
                              customSnackBar.showSnakbar(
                                  context,
                                  stringVariables.loginToContinue,
                                  SnackbarType.negative);
                            }
                          } else {
                            _formKey.currentState?.validate();
                          }
                        },
                        width: 1.15,
                        isBorderedButton: true,
                        maxLines: 1,
                        icon: null,
                        multiClick: true,
                        text: widget.isBuy
                            ? stringVariables.buy.toUpperCase()
                            : stringVariables.sell.toUpperCase(),
                        radius: 25,
                        height: size.height / 50,
                        icons: false,
                        blurRadius: 0,
                        spreadRadius: 0,
                        offset: Offset(0, 0)),
              ),
              CustomSizedBox(
                height: 0.01,
              ),
            ],
          ),
        ));
  }

  Widget buildAttentionCard(Size size, String content) {
    return CustomContainer(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: themeColor.withOpacity(0.2)),
      width: 1,
      height: isSmallScreen(context) ? 6.25 : 9.5,
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CustomSizedBox(
                  height: 0.0075,
                ),
                SvgPicture.asset(p2pAttention),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomContainer(
              width: 1.35,
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

  Widget buildTradeInfo(Size size, String duration, String buyer,
      List<PaymentMethod> paymentMethod) {
    String terms = widget.advertisement.remarks ?? "";
    List<Widget> paymentCard = [];
    int paymentCardListCount = paymentMethod.length;
    for (var i = 0; i < paymentCardListCount; i++) {
      paymentCard.add(paymentMethodsCard(
          size, paymentMethod[i].paymentMethodName!, i != 0));
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            fontfamily: 'GoogleSans',
            text: stringVariables.tradeInfo,
            fontsize: 16,
            fontWeight: FontWeight.w700,
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          buildTextWithWidget(
            stringVariables.paymentWindow,
            CustomText(
              fontfamily: 'GoogleSans',
              text: duration,
              fontsize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          buildTextWithWidget(
            stringVariables.counterparty,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                moveToCounterProfile(
                    context, widget.advertisement.userId ?? "");
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
            height: 0.015,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            text: stringVariables.paymentMethods,
            color: textHeaderGrey,
            fontsize: 14,
            fontWeight: FontWeight.w400,
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          Row(children: paymentCard),
          CustomSizedBox(
            height: 0.01,
          ),
          Divider(),
          CustomSizedBox(
            height: 0.01,
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
            height: 0.025,
          ),
        ],
      ),
    );
  }

  Widget buildTextWithAmount(String title, String amount, String currency) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontfamily: 'GoogleSans',
            text: title,
            color: textHeaderGrey,
            fontsize: 14,
            fontWeight: FontWeight.w400,
          ),
          Row(
            children: [
              CustomText(
                fontfamily: 'GoogleSans',
                text: isNumeric(amount) ? trimDecimals(amount) : amount,
                fontsize: 14,
                fontWeight: FontWeight.w500,
              ),
              CustomSizedBox(
                width: 0.01,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                text: currency,
                fontsize: 14,
                fontWeight: FontWeight.w500,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTextWithWidget(String title, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: title,
          color: textHeaderGrey,
          fontsize: 14,
          fontWeight: FontWeight.w400,
        ),
        child
      ],
    );
  }
}

class P2PTimeAndPaymentModel extends ModalRoute {
  late P2POrderCreationViewModel viewModel;
  late P2PPaymentMethodsViewModel paymentMethodsViewModel;
  late BuildContext context;

  P2PTimeAndPaymentModel(BuildContext context) {
    this.context = context;

    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    paymentMethodsViewModel =
        Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    paymentMethodsViewModel.getJwtUserResponse();
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
    paymentMethodsViewModel = context.watch<P2PPaymentMethodsViewModel>();
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
                    Navigator.pop(context);
                  },
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        height: 4,
                        width: 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          color: themeSupport().isSelectedDarkMode()
                              ? card_dark
                              : white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: size.width / 35,
                              right: size.width / 35,
                              top: size.width / 35),
                          child: paymentMethodsViewModel.needToLoad
                              ? CustomLoader()
                              : buildPaymentView(size),
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

  Widget buildPaymentView(Size size) {
    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
              itemCount: paymentMethodsViewModel.paymentsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: paymentMethodsViewModel.paymentsList[index],
                          overflow: TextOverflow.ellipsis,
                          fontfamily: 'GoogleSans',
                          fontWeight: FontWeight.bold,
                          fontsize: 20,
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      // add scale animation
      child: child,
    );
  }
}
