import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/p2p/ads/view_model/p2p_ads_view_model.dart';
import 'package:zodeakx_mobile/p2p/post_an_ad_view/view/p2p_confirm_post_dialog.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../Utils/Widgets/keyboard_done_widget.dart';
import '../../home/model/p2p_currency.dart';
import 'p2p_time_and_payment_bottom_sheet.dart';

class P2PPostAnAdView extends StatefulWidget {
  const P2PPostAnAdView({Key? key}) : super(key: key);

  @override
  State<P2PPostAnAdView> createState() => _CommonViewState();
}

enum PostType { online, offline }

class _CommonViewState extends State<P2PPostAnAdView>
    with TickerProviderStateMixin {
  late P2PAdsViewModel viewModel;
  late TabController _sideTabController;
  late TabController _priceTabController;
  final GlobalKey _cryptoKey = GlobalKey();
  final GlobalKey _fiatKey = GlobalKey();
  TextEditingController minAmountController = TextEditingController();
  TextEditingController maxAmountController = TextEditingController();
  GlobalKey<FormFieldState> totalFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> minFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> maxFieldKey = GlobalKey<FormFieldState>();
  late FocusNode totalFocusNode;
  late FocusNode minFocusNode;
  late FocusNode maxFocusNode;
  final _formKey = GlobalKey<FormState>();
  late StreamSubscription<bool> keyboardSubscription;
  var overlayEntry;

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(false);
      viewModel.setSelectedCrypto(viewModel.staticPairs[0]);
      viewModel.setSelectedFiat(viewModel.fiatPairs[0]);
    });
    super.dispose();
  }

  _showModel(int type) async {
    final result =
        await Navigator.of(context).push(P2PTimeAndPaymentModel(context, type));
  }

  _showConfirmModel(int type) async {
    final result =
        await Navigator.of(context).push(P2PConfirmPostModel(context, type));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PAdsViewModel>(context, listen: false);
    _sideTabController = TabController(length: 2, vsync: this);
    _priceTabController = TabController(length: 2, vsync: this);
    viewModel.updateMakerFeeValue(0);
    _priceTabController.addListener(() {
      viewModel.setPriceIndex(_priceTabController.index);
      if (_priceTabController.index == 0) {
        viewModel
            .setYourPrice(double.parse(viewModel.fiatPriceController.text));
      } else {
        double value = double.parse(trimDecimals(viewModel
            .calculatePercentage(
                double.parse(viewModel.floatingPriceController.text),
                viewModel.highestPrice)
            .toString()));
        viewModel.setYourPrice(value);
      }
    });
    _sideTabController.addListener(() {
      viewModel.setSideIndex(_sideTabController.index);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      resetView();
      viewModel.fetchHighestPrice();
      viewModel.fiatPriceController.addListener(() {
        if (!isNumeric(viewModel.fiatPriceController.text)) return;
        double value = double.parse(viewModel.fiatPriceController.text);
        double minValue =
            viewModel.calculatePercentage(80, viewModel.highestPrice);
        double maxValue =
            viewModel.calculatePercentage(120, viewModel.highestPrice);
        viewModel.setFixedError(value < minValue || value > maxValue);
        viewModel.setYourPrice(double.parse(trimDecimals(value.toString())));
      });
      viewModel.floatingPriceController.addListener(() {
        if (!isNumeric(viewModel.floatingPriceController.text)) return;
        viewModel.setFloatingPercentage(
            double.parse(viewModel.floatingPriceController.text));
        double value = viewModel.calculatePercentage(
            double.parse(viewModel.floatingPriceController.text),
            viewModel.highestPrice);
        double minValue =
            viewModel.calculatePercentage(80, viewModel.highestPrice);
        double maxValue =
            viewModel.calculatePercentage(120, viewModel.highestPrice);
        viewModel.setFloatingError(value < minValue || value > maxValue);
        viewModel.setYourPrice(double.parse(trimDecimals(value.toString())));
      });
      viewModel.totalAmountController.addListener(() {
        if (viewModel.totalAmountController.text.isEmpty)
          viewModel.setFiatAmount(0);
        if (!isNumeric(viewModel.totalAmountController.text)) return;
        double value = double.parse(viewModel.totalAmountController.text) *
            viewModel.highestPrice;
        viewModel.setFiatAmount(value);
      });
      minAmountController.addListener(() {
        if (!isNumeric(minAmountController.text)) return;
        double value = double.parse(minAmountController.text);
        viewModel.setMinAmount(value);
      });
      maxAmountController.addListener(() {
        if (!isNumeric(maxAmountController.text)) return;
        double value = double.parse(maxAmountController.text);
        viewModel.setMaxAmount(value);
      });
    });

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (Platform.isIOS) {
        if (!visible)
          removeOverlay();
        else
          showOverlay(context);
      }
    });

    totalFocusNode = FocusNode();
    minFocusNode = FocusNode();
    maxFocusNode = FocusNode();
    validator(totalFieldKey, totalFocusNode);
    validator(minFieldKey, minFocusNode);
    validator(maxFieldKey, maxFocusNode);
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState?.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  resetView() {
    viewModel.setPostAdStep(1);
    viewModel.setPriceIndex(0);
    viewModel.setSideIndex(0);
    viewModel.setFiatAmount(0);
    viewModel.setMinAmount(0);
    viewModel.setMaxAmount(0);
    viewModel.setFixedError(false);
    viewModel.setFloatingError(false);
    viewModel.setPaymentError(false);
    viewModel.setPaymentMethods([]);
    viewModel.setTime(15);
    viewModel.setFloatingPercentage(100);
    viewModel.setPostType(PostType.online);
    _priceTabController.index = 0;
    _sideTabController.index = 0;
    viewModel.floatingPriceController.text = "100";
    viewModel.totalAmountController.clear();
    viewModel.autoReplyController.clear();
    viewModel.termsController.clear();
    minAmountController.clear();
    maxAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PAdsViewModel>();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PPostAnAdView(size),
      ),
    );
  }

  Widget buildP2PPostAnAdView(Size size) {
    Widget currentView = buildStep1View(size);
    switch (viewModel.postAdStep) {
      case 1:
        currentView = buildStep1View(size);
        break;
      case 2:
        currentView = buildStep2View(size);
        break;
      case 3:
        currentView = buildStep3View(size);
        break;
      default:
        currentView = buildStep1View(size);
        break;
    }
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: Column(
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
                              children: [
                                currentView,
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
                                viewModel.postAdStep == 1
                                    ? CustomSizedBox(
                                        width: 0,
                                        height: 0,
                                      )
                                    : Row(
                                        children: [
                                          CustomElevatedButton(
                                              buttoncolor: grey,
                                              color: black,
                                              press: () {
                                                viewModel.setPostAdStep(
                                                    viewModel.postAdStep > 0
                                                        ? viewModel.postAdStep -
                                                            1
                                                        : 1);
                                              },
                                              width: 2.4,
                                              isBorderedButton: true,
                                              maxLines: 1,
                                              icon: null,
                                              multiClick: true,
                                              text: stringVariables.previous,
                                              radius: 25,
                                              height: size.height / 50,
                                              icons: false,
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              offset: Offset(0, 0)),
                                          CustomSizedBox(
                                            width: 0.02,
                                          ),
                                        ],
                                      ),
                                CustomElevatedButton(
                                    buttoncolor: themeColor,
                                    color: themeSupport().isSelectedDarkMode()
                                        ? black
                                        : white,
                                    press: () {
                                      switch (viewModel.postAdStep) {
                                        case 1:
                                          validateStep1();
                                          break;
                                        case 2:
                                          validateStep2();
                                          break;
                                        case 3:
                                          if (isvalid()) {
                                            _showConfirmModel(1);
                                          } else {
                                            customSnackBar.showSnakbar(
                                                context,
                                                stringVariables.completeProper,
                                                SnackbarType.negative);
                                          }
                                          break;
                                        default:
                                          break;
                                      }
                                    },
                                    width:
                                        viewModel.postAdStep == 1 ? 1.16 : 2.4,
                                    isBorderedButton: true,
                                    maxLines: 1,
                                    icon: null,
                                    multiClick: true,
                                    text: viewModel.postAdStep == 3
                                        ? stringVariables.post
                                        : capitalize(stringVariables.next),
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
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)),
        ],
      ),
    );
  }

  isvalid() {
    return (((viewModel.priceIndex == 0 && !viewModel.fixedError) ||
            (viewModel.priceIndex == 1 && !viewModel.floatingError)) &&
        (viewModel.totalAmountController.text.isNotEmpty &&
            minAmountController.text.isNotEmpty &&
            maxAmountController.text.isNotEmpty &&
            viewModel.paymentMethods.isNotEmpty));
  }

  bool valid1() {
    return ((viewModel.priceIndex == 0 && !viewModel.fixedError) ||
        (viewModel.priceIndex == 1 && !viewModel.floatingError));
  }

  bool valid2() {
    _formKey.currentState?.validate();
    if (viewModel.paymentMethods.isEmpty) viewModel.setPaymentError(true);
    return (viewModel.totalAmountController.text.isNotEmpty &&
        minAmountController.text.isNotEmpty &&
        maxAmountController.text.isNotEmpty &&
        viewModel.paymentMethods.isNotEmpty);
  }

  validateStep1() {
    if (viewModel.postAdStep == 1 &&
        ((viewModel.priceIndex == 0 && !viewModel.fixedError) ||
            (viewModel.priceIndex == 1 && !viewModel.floatingError))) {
      if (viewModel.totalAmountController.text.isNotEmpty)
        viewModel.setFiatAmount(
            double.parse(viewModel.totalAmountController.text) *
                viewModel.yourPrice);
      viewModel.setPostAdStep(2);
    }
  }

  validateStep2() {
    if (viewModel.totalAmountController.text.isNotEmpty &&
        minAmountController.text.isNotEmpty &&
        maxAmountController.text.isNotEmpty &&
        viewModel.paymentMethods.isNotEmpty) {
      viewModel.setPostAdStep(3);
    } else {
      _formKey.currentState!.validate();
      if (viewModel.paymentMethods.isEmpty) viewModel.setPaymentError(true);
    }
  }

  Widget buildStep1View(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSideField(size),
        buildPriceSettingsField(size),
      ],
    );
  }

  Widget buildStep2View(Size size) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAmountField(size),
          buildPaymentMethodField(size),
          buildPaymentLimitView()
        ],
      ),
    );
  }

  Widget buildStep3View(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTermsAndReplyView(size),
        buildCounterPartiesView(size),
      ],
    );
  }

  Widget buildSideField(Size size) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          padding: 4.5,
          width: 1.5,
          height: 17,
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(
              50.0,
            ),
          ),
          child: TabBar(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            controller: _sideTabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                50.0,
              ),
              color: themeColor,
            ),
            labelStyle: TextStyle(
                fontFamily: 'InterTight',
                fontWeight: FontWeight.w600,
                fontSize: 14),
            labelColor: themeSupport().isSelectedDarkMode() ? black : white,
            unselectedLabelColor: hintLight,
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                text: stringVariables.buy,
              ),
              Tab(
                text: stringVariables.sell,
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomSizedBox(
                        width: 0.015,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        align: TextAlign.center,
                        fontsize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        text: stringVariables.asset,
                        color: hintLight,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  GestureDetector(
                    onTap: () {
                      dynamic state = _cryptoKey.currentState;
                      state.showButtonMenu();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        padLeft: 0,
                        padRight: 10,
                        hintColor: hintLight,
                        hintfontsize: 18,
                        hintfontweight: FontWeight.w500,
                        text: viewModel.selectedCrypto,
                        size: 30,
                        isContentPadding: false,
                        suffixIcon: Theme(
                          data: Theme.of(context).copyWith(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              key: _cryptoKey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              offset:
                                  Offset(size.width / -3.6, size.width / 7.5),
                              constraints: BoxConstraints(
                                minWidth: (size.width * 0.4),
                                maxWidth: (size.width * 0.4),
                                minHeight: (size.height / 12),
                                maxHeight: (size.height / 2.625),
                              ),
                              icon: SvgPicture.asset(
                                p2pDownArrow,
                                height: 7,
                                color: hintLight,
                              ),
                              onSelected: (value) {
                                viewModel.setSelectedCrypto(value.toString());

                                viewModel.fetchHighestPrice();
                              },
                              color: themeSupport().isSelectedDarkMode()
                                  ? card_dark
                                  : white,
                              itemBuilder: (
                                BuildContext context,
                              ) {
                                return viewModel.staticPairs
                                    .map<PopupMenuItem>((String value) {
                                  return buildPopupItem(size, value);
                                }).toList();
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomSizedBox(
                        width: 0.025,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        align: TextAlign.center,
                        fontsize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        text: stringVariables.withFiat,
                        color: hintLight,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  GestureDetector(
                    onTap: () {
                      dynamic state = _fiatKey.currentState;
                      state.showButtonMenu();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        padRight: 0,
                        padLeft: 10,
                        hintColor: hintLight,
                        hintfontsize: 18,
                        hintfontweight: FontWeight.w500,
                        text: viewModel.selectedFiat,
                        size: 30,
                        isContentPadding: false,
                        suffixIcon: Theme(
                          data: Theme.of(context).copyWith(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          child: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              key: _fiatKey,
                              onSelected: (value) {
                                viewModel.setSelectedFiat(value.toString());
                                viewModel.fetchHighestPrice();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              offset: Offset(0, size.width / 7.5),
                              constraints: BoxConstraints(
                                minWidth: (size.width * 0.4),
                                maxWidth: (size.width * 0.4),
                                minHeight: (size.height / 12),
                                maxHeight: (size.height / 2.625),
                              ),
                              icon: SvgPicture.asset(
                                p2pDownArrow,
                                height: 7,
                                color: hintLight,
                              ),
                              color: themeSupport().isSelectedDarkMode()
                                  ? card_dark
                                  : white,
                              itemBuilder: (
                                BuildContext context,
                              ) {
                                return viewModel.fiatPairs
                                    .map<PopupMenuItem>((String value) {
                                  return buildPopupItem(size, value);
                                }).toList();
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget buildPriceSettingsField(Size size) {
    double total = viewModel.highestPrice;
    String fiat = viewModel.selectedFiat;
    double minValue = viewModel.calculatePercentage(80, viewModel.highestPrice);
    double maxValue =
        viewModel.calculatePercentage(120, viewModel.highestPrice);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          fontfamily: 'InterTight',
          align: TextAlign.center,
          fontsize: 14,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w500,
          text: stringVariables.priceSettings,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomContainer(
              padding: 4.5,
              width: 1.5,
              height: 17,
              decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.circular(
                  50.0,
                ),
              ),
              child: TabBar(
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                controller: _priceTabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    50.0,
                  ),
                  color: themeColor,
                ),
                labelStyle: TextStyle(
                    fontFamily: 'InterTight',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: themeSupport().isSelectedDarkMode() ? black : white,
                unselectedLabelColor: hintLight,
                tabs: [
                  Tab(
                    text: stringVariables.fixed,
                  ),
                  Tab(
                    text: stringVariables.floating,
                  ),
                ],
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        viewModel.priceIndex == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomSizedBox(
                        width: 0.015,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        align: TextAlign.center,
                        fontsize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        text: stringVariables.fixed,
                        color: hintLight,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      SvgPicture.asset(
                        p2pOrderAttention,
                        color: hintLight,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomContainer(
                    width: 2,
                    child: CustomTextFormField(
                      padLeft: 0,
                      padRight: 0,
                      controller: viewModel.fiatPriceController,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2),
                        // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d*')),
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      size: 30,
                      fontWeight: FontWeight.w500,
                      fontsize: 16,
                      isContentPadding: false,
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: CustomIconButton(
                        radius: 20,
                        onPress: () {
                          viewModel.fiatPriceController.text = trimDecimals(
                              (viewModel.yourPrice + 0.01).toString());
                          if (isNumeric(viewModel.fiatPriceController.text)) {
                            viewModel.setYourPrice(double.parse(
                                viewModel.fiatPriceController.text));
                          }
                        },
                        color: grey,
                        child: SvgPicture.asset(
                          plusImage,
                          width: 13.5,
                          height: 13.5,
                        ),
                      ),
                      prefixIcon: CustomIconButton(
                        radius: 20,
                        onPress: () {
                          viewModel.fiatPriceController.text = trimDecimals(
                              (viewModel.yourPrice - 0.01).toString());
                          if (isNumeric(viewModel.fiatPriceController.text)) {
                            viewModel.setYourPrice(double.parse(
                                viewModel.fiatPriceController.text));
                          }
                        },
                        color: grey,
                        child: SvgPicture.asset(
                          minusImage,
                          width: 2.5,
                          height: 2.5,
                        ),
                      ),
                    ),
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomSizedBox(
                        width: 0.015,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        align: TextAlign.center,
                        fontsize: 14,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                        text: stringVariables.floatingPriceMargin,
                        color: hintLight,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      SvgPicture.asset(
                        p2pOrderAttention,
                        color: hintLight,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.015,
                  ),
                  CustomContainer(
                    width: 2,
                    child: CustomTextFormField(
                      padLeft: 0,
                      padRight: 0,
                      controller: viewModel.floatingPriceController,
                      textAlign: TextAlign.center,
                      size: 30,
                      fontWeight: FontWeight.w500,
                      fontsize: 16,
                      isContentPadding: false,
                      contentPadding: EdgeInsets.zero,
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2),
                        // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d*')),
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      suffixIcon: CustomContainer(
                        width: 5.5,
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(5, 0),
                              child: CustomText(
                                fontfamily: 'InterTight',
                                align: TextAlign.center,
                                fontsize: 20,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                                text: "%",
                              ),
                            ),
                            CustomIconButton(
                              radius: 20,
                              onPress: () {
                                viewModel.floatingPriceController.text =
                                    trimDecimals(
                                        (viewModel.floatingPricePercentage +
                                                0.01)
                                            .toString());
                                if (isNumeric(
                                    viewModel.floatingPriceController.text)) {
                                  viewModel.setFloatingPercentage(double.parse(
                                      viewModel.floatingPriceController.text));
                                  double value = double.parse(trimDecimals(
                                      viewModel
                                          .calculatePercentage(
                                              double.parse(viewModel
                                                  .floatingPriceController
                                                  .text),
                                              viewModel.highestPrice)
                                          .toString()));
                                  viewModel.setYourPrice(value);
                                }
                              },
                              color: grey,
                              child: SvgPicture.asset(
                                plusImage,
                                width: 13.5,
                                height: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      prefixIcon: CustomIconButton(
                        radius: 20,
                        onPress: () {
                          viewModel.floatingPriceController.text = trimDecimals(
                              (viewModel.floatingPricePercentage - 0.01)
                                  .toString());
                          if (isNumeric(
                              viewModel.floatingPriceController.text)) {
                            viewModel.setFloatingPercentage(double.parse(
                                viewModel.floatingPriceController.text));
                            double value = double.parse(trimDecimals(viewModel
                                .calculatePercentage(
                                    double.parse(
                                        viewModel.floatingPriceController.text),
                                    viewModel.highestPrice)
                                .toString()));
                            viewModel.setYourPrice(value);
                          }
                        },
                        color: grey,
                        child: SvgPicture.asset(
                          minusImage,
                          width: 2.5,
                          height: 2.5,
                        ),
                      ),
                    ),
                  ),
                  CustomSizedBox(
                    height: 0.015,
                  ),
                ],
              ),
        (viewModel.fixedError && viewModel.priceIndex == 0)
            ? CustomText(
                fontfamily: 'InterTight',
                fontsize: 14,
                fontWeight: FontWeight.w400,
                text:
                    "${stringVariables.fixedPriceMarginWithIn} ${trimDecimals(minValue.toString())} ${stringVariables.to} ${trimDecimals(maxValue.toString())}",
                color: red,
              )
            : (viewModel.floatingError && viewModel.priceIndex == 1)
                ? Column(
                    children: [
                      CustomText(
                        fontfamily: 'InterTight',
                        fontsize: 14,
                        fontWeight: FontWeight.w400,
                        text: stringVariables.floatingPriceMarginWithIn,
                        color: red,
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      )
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  ),
        viewModel.priceIndex == 1
            ? Text.rich(
                softWrap: true,
                textAlign: TextAlign.center,
                TextSpan(
                    text: "",
                    style: TextStyle(
                      color: hintLight,
                      fontSize: 14,
                      fontFamily: 'InterTight',
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: stringVariables.pricingFormula,
                        style: TextStyle(
                            color: hintLight,
                            fontSize: 14,
                            fontFamily: 'InterTight',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                      TextSpan(
                        text:
                            " ${viewModel.highestPrice} * ${viewModel.floatingPriceController.text}% = ${trimDecimals(viewModel.calculatePercentage(double.parse((isNumeric(viewModel.floatingPriceController.text)) ? viewModel.floatingPriceController.text : "0"), viewModel.highestPrice).toString())}",
                        style: TextStyle(
                          decoration: null,
                          color: hintLight,
                          fontSize: 14,
                          fontFamily: 'InterTight',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]),
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTextField(stringVariables.yourPrice,
                "${viewModel.yourPrice} $fiat", CrossAxisAlignment.start),
            buildTextField(stringVariables.highestOrderPrice, "$total $fiat",
                CrossAxisAlignment.end, true),
          ],
        )
      ],
    );
  }

  Widget buildAmountField(Size size) {
    String crypto = viewModel.selectedCrypto;
    String fiat = viewModel.selectedFiat;
    P2PCurrency p2pCurrency = viewModel.p2pCurrency
            ?.where((element) => element.code == viewModel.selectedCrypto)
            .first ??
        P2PCurrency();
    num minValue = p2pCurrency.minAdLimit ?? 0.0;
    num maxValue = p2pCurrency.maxAdLimit ?? 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          fontfamily: 'InterTight',
          fontsize: 14,
          fontWeight: FontWeight.w500,
          text: stringVariables.totalTradingAmount,
          color: hintLight,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomTextFormField(
          autovalid: AutovalidateMode.onUserInteraction,
          controller: viewModel.totalAmountController,
          keys: totalFieldKey,
          focusNode: totalFocusNode,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          onChanged: (value) {
            if (value.length > 0) {
              viewModel.updateMakerFeeValue(num.parse(value));
            } else {
              viewModel.updateMakerFeeValue(0);
            }
          },
          padRight: 0,
          padLeft: 0,
          isContentPadding: false,
          size: 30,
          text: stringVariables.enterTradingAmount,
          validator: (input) => (input ?? "").isEmpty
              ? stringVariables.enterTradingAmount
              : isNumeric(input.toString())
                  ? (double.parse(input ?? "0") < minValue ||
                          double.parse(input ?? "0") > maxValue)
                      ? "${stringVariables.amountBetween} ${trimDecimals(minValue.toString())} ${stringVariables.to} ${trimDecimals(maxValue.toString())}"
                      : null
                  : null,
          suffixIcon: GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: CustomContainer(
              width: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    fontfamily: 'InterTight',
                    text: crypto,
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: "~ ${viewModel.fiatAmount} $fiat",
              fontsize: 14,
              fontWeight: FontWeight.w500,
              color: hintLight,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.015,
            ),
            CustomText(
              fontfamily: 'InterTight',
              fontsize: 14,
              fontWeight: FontWeight.w500,
              text: stringVariables.orderLimit,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            // SvgPicture.asset(
            //   p2pOrderAttention,
            //   color: hintLight,
            // ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: CustomTextFormField(
                autovalid: AutovalidateMode.onUserInteraction,
                controller: minAmountController,
                keys: minFieldKey,
                focusNode: minFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  DecimalTextInputFormatter(decimalRange: 2),
                  // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (input) => (input ?? "").isEmpty
                    ? stringVariables.enterMinLimit
                    : isNumeric(input.toString())
                        ? double.parse(input ?? "0") < 0
                            ? stringVariables.minLimitHint
                            : double.parse(input ?? "0") > viewModel.fiatAmount
                                ? stringVariables.minLimitHint
                                : null
                        : null,
                padRight: 0,
                padLeft: 0,
                isContentPadding: false,
                size: 30,
                text: stringVariables.minLimit,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: CustomContainer(
                    width: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          fontfamily: 'InterTight',
                          text: fiat,
                          fontsize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: "  ~  ",
                  fontsize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            Flexible(
              flex: 1,
              child: CustomTextFormField(
                autovalid: AutovalidateMode.onUserInteraction,
                controller: maxAmountController,
                keys: maxFieldKey,
                focusNode: maxFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  DecimalTextInputFormatter(decimalRange: 2),
                  // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                validator: (input) => (input ?? "").isEmpty
                    ? stringVariables.enterMaxLimit
                    : isNumeric(input.toString())
                        ? double.parse(input ?? "0") <
                                (double.parse(
                                        (minAmountController.text.isEmpty ||
                                                !isNumeric(
                                                    minAmountController.text))
                                            ? "0"
                                            : minAmountController.text) +
                                    0.01)
                            ? stringVariables.maxLimitMinHint
                            : double.parse(input ?? "0") > viewModel.fiatAmount
                                ? stringVariables.maxLimitTotalHint
                                : null
                        : null,
                padRight: 0,
                padLeft: 0,
                isContentPadding: false,
                size: 30,
                text: stringVariables.maxLimit,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: CustomContainer(
                    width: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          fontfamily: 'InterTight',
                          text: fiat,
                          fontsize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
    );
  }

  Widget buildPaymentCard(Size size, String title) {
    return CustomContainer(
      height: 20,
      decoration: BoxDecoration(
        color: black12,
        borderRadius: BorderRadius.circular(
          500.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: title,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
            GestureDetector(
              onTap: () {
                viewModel.updatePaymentMethods(title);
              },
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.close,
                color: hintLight,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodField(Size size) {
    List<String> paymentMethods = viewModel.paymentMethods;
    List<Widget> paymentMethodsList = [];
    int paymentMethodsCount = paymentMethods.length;
    for (var i = 0; i < paymentMethodsCount; i++) {
      paymentMethodsList.add(buildPaymentCard(size, paymentMethods[i]));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.paymentMethod,
                  fontsize: 14,
                  fontWeight: FontWeight.w400,
                ),
                CustomSizedBox(
                  height: 0.0075,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.select4methods,
                  fontsize: 14,
                  fontWeight: FontWeight.w400,
                  color: hintLight,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                _showModel(0);
              },
              child: CustomContainer(
                height: 20,
                decoration: BoxDecoration(
                  color: black12,
                  borderRadius: BorderRadius.circular(
                    500.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 20,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        text: stringVariables.add,
                        fontsize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomSizedBox(
                        width: 0.015,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        viewModel.paymentError
            ? Column(
                children: [
                  CustomSizedBox(
                    height: 0.015,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    fontsize: 14,
                    fontWeight: FontWeight.w400,
                    text: stringVariables.pleaseAddPaymentMethod,
                    color: red,
                  )
                ],
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        paymentMethodsCount != 0
            ? Column(
                children: [
                  CustomSizedBox(
                    height: 0.015,
                  ),
                  CustomContainer(
                    width: 1,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: paymentMethodsList,
                    ),
                  ),
                ],
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        CustomSizedBox(
          height: 0.015,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
    );
  }

  Widget buildPaymentLimitView() {
    int timeLimit = viewModel.time != 60 ? viewModel.time : 1;
    String crypto = viewModel.selectedCrypto;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.015,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  fontsize: 14,
                  fontWeight: FontWeight.w500,
                  text: stringVariables.paymentTimeLimit,
                  color: hintLight,
                ),
                CustomSizedBox(
                  width: 0.02,
                ),
                // SvgPicture.asset(
                //   p2pOrderAttention,
                //   color: hintLight,
                // ),
              ],
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                _showModel(1);
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  CustomText(
                    fontfamily: 'InterTight',
                    text:
                        "$timeLimit ${timeLimit == 1 ? stringVariables.hour : stringVariables.min}",
                    fontsize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomContainer(
                    width: 20,
                    height: 40,
                    child: SvgPicture.asset(
                      p2pRightArrow,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.015,
            ),
            CustomText(
              fontfamily: 'InterTight',
              fontsize: 14,
              fontWeight: FontWeight.w500,
              text:
                  "${stringVariables.reservedFee}: ${trimDecimalsForBalance(viewModel.reserveFee.toString())} $crypto",
              color: hintLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTermsAndReplyView(Size size) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        buildTextFormFieldWithTitle(viewModel.termsController,
            stringVariables.termsOptional, stringVariables.termsHint),
        CustomSizedBox(
          height: 0.02,
        ),
        buildTextFormFieldWithTitle(viewModel.autoReplyController,
            stringVariables.autoReplyOptional, stringVariables.autoReplyHint),
        CustomSizedBox(
          height: 0.015,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
    );
  }

  Widget buildCounterPartiesView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          text: stringVariables.counterpartyConditions,
          fontsize: 14,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          fontfamily: 'InterTight',
          text: stringVariables.counterPartyContent,
          fontsize: 14,
          fontWeight: FontWeight.w500,
          color: hintLight,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildCheckBox(),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Theme(
          data: ThemeData(
            unselectedWidgetColor: hintLight,
          ),
          child: Column(
            children: [
              buildTextWithRadio(size, PostType.online, stringVariables.online),
              CustomSizedBox(
                height: 0.02,
              ),
              buildTextWithRadio(
                  size, PostType.offline, stringVariables.offline),
              CustomSizedBox(
                height: 0.02,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildTextWithRadio(Size size, PostType cancelReason, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.1,
          child: Radio(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: themeColor,
            value: cancelReason,
            groupValue: viewModel.postType,
            onChanged: (PostType? value) {
              viewModel.setPostType(value ?? PostType.online);
            },
          ),
        ),
        CustomSizedBox(
          width: 0.02,
        ),
        CustomContainer(
          constraints: BoxConstraints(maxWidth: size.width / 1.3),
          child: CustomText(
            strutStyleHeight: 1.6,
            maxlines: 2,
            text: content,
            fontfamily: 'InterTight',
            softwrap: true,
            fontWeight: FontWeight.w500,
            fontsize: 16,
          ),
        ),
      ],
    );
  }

  Widget buildCheckBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              width: 0.06,
              height: 0.025,
              child: CustomCheckBox(
                checkboxState: true,
                toggleCheckboxState: (value) {},
                activeColor: hintLight,
                checkColor: Colors.white,
                borderColor: enableBorder,
              ),
            ),
            CustomSizedBox(
              width: 0.015,
            ),
            CustomText(
              text: stringVariables.completedKyc,
              fontWeight: FontWeight.w500,
              fontsize: 14,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
    );
  }

  buildTextFormFieldWithTitle(
      TextEditingController controller, String title, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          text: title,
          fontsize: 14,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        CustomTextFormField(
          maxLength: 500,
          padLeft: 0,
          padRight: 0,
          size: 30,
          text: hint,
          hintColor: switchBackground,
          maxLines: 4,
          minLines: 4,
          controller: controller,
          autovalid: AutovalidateMode.onUserInteraction,
          isContentPadding: true,
        ),
      ],
    );
  }

  buildTextField(String title, String value, CrossAxisAlignment alignment,
      [bool attentionFlag = false]) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
              fontsize: 14,
              fontWeight: FontWeight.w400,
              text: title,
              color: hintLight,
            ),
            // attentionFlag
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
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          fontfamily: 'InterTight',
          fontsize: 14,
          fontWeight: FontWeight.w400,
          text: value,
        ),
      ],
    );
  }

  PopupMenuItem buildPopupItem(Size size, String menuItem) {
    return PopupMenuItem(
      value: menuItem,
      child: CustomText(
        fontfamily: 'InterTight',
        align: TextAlign.center,
        fontsize: 16,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        text: menuItem,
      ),
    );
  }

  Widget buildSubHeader(Size size) {
    String title = "";
    switch (viewModel.postAdStep) {
      case 1:
        title = "${viewModel.postAdStep} ${stringVariables.postAdStep1}";
        break;
      case 2:
        title = "${viewModel.postAdStep} ${stringVariables.postAdStep2}";
        break;
      case 3:
        title = "${viewModel.postAdStep} ${stringVariables.postAdStep3}";
        break;
      default:
        title = "${viewModel.postAdStep} ${stringVariables.postAdStep1}";
        break;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            fontfamily: 'InterTight',
            text: title,
            fontsize: 14,
            fontWeight: FontWeight.bold,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          PostAdProgressBar(
              viewModel: viewModel,
              validate1: valid1,
              validate2: valid2,
              isEdit: false),
          CustomSizedBox(
            height: 0.01,
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
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.postAd,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
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

class PostAdProgressBar extends StatefulWidget {
  final P2PAdsViewModel viewModel;
  final Function validate1;
  final Function validate2;
  final bool isEdit;

  const PostAdProgressBar(
      {Key? key,
      required this.viewModel,
      required this.validate1,
      required this.validate2,
      required this.isEdit})
      : super(key: key);

  @override
  State<PostAdProgressBar> createState() => _PostAdProgressBarState();
}

class _PostAdProgressBarState extends State<PostAdProgressBar> {
  Widget buildCircleStroke(Size size, Color color) {
    return CustomContainer(
      width: 3.3,
      height: size.height,
      color: color,
    );
  }

  Widget buildCircleWithText(Color color, String content) {
    return GestureDetector(
      onTap: () {
        bool validate1 = widget.validate1();
        int page = int.parse(content);
        if (page == 2) {
          if (validate1) widget.viewModel.setPostAdStep(page);
        } else if (page == 3) {
          bool validate2 = widget.validate2();
          if (widget.viewModel.postAdStep == 1 &&
              (!widget.isEdit || !validate2)) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            customSnackBar.showSnakbar(
                context, stringVariables.step2Id, SnackbarType.negative);
          } else {
            if (validate1 && validate2) widget.viewModel.setPostAdStep(page);
          }
        } else {
          widget.viewModel.setPostAdStep(page);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(20))),
        width: 15,
        height: isSmallScreen(context)
            ? Platform.isIOS
                ? 25
                : 31
            : 31,
        child: Center(
          child: CustomText(
            fontfamily: 'InterTight',
            text: content,
            fontWeight: FontWeight.w400,
            fontsize: 14,
            color: color == themeColor ? white : hintLight,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    P2PAdsViewModel viewModel = widget.viewModel;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCircleWithText(themeColor, stringVariables.one),
        buildCircleStroke(
            size,
            viewModel.postAdStep > 1
                ? themeColor
                : switchBackground.withOpacity(0.5)),
        buildCircleWithText(
            viewModel.postAdStep > 1
                ? themeColor
                : switchBackground.withOpacity(0.5),
            stringVariables.two),
        buildCircleStroke(
            size,
            viewModel.postAdStep > 2
                ? themeColor
                : switchBackground.withOpacity(0.5)),
        buildCircleWithText(
            viewModel.postAdStep > 2
                ? themeColor
                : switchBackground.withOpacity(0.5),
            stringVariables.three),
      ],
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
