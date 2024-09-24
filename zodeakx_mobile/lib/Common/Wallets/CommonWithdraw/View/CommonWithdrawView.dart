import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomQrCode.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../../Utils/Languages/English/StringVariables.dart';
import '../../../../Utils/Widgets/CustomContainer.dart';
import '../../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../../Utils/Widgets/CustomIconButton.dart';
import '../../../../Utils/Widgets/CustomLoader.dart';
import '../../../../Utils/Widgets/CustomNavigation.dart';
import '../../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../../Utils/Widgets/CustomText.dart';
import '../../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../../Utils/Widgets/keyboard_done_widget.dart';
import '../../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../../CoinDetailsViewModel/GetcurrencyViewModel.dart';
import 'SelectWalletBottomSheet.dart';

class CommonWithdrawView extends StatefulWidget {
  String? currencyType;
  String? currencyCode;
  String? availableBalance;

  CommonWithdrawView(
      {Key? key, this.currencyType, this.currencyCode, this.availableBalance})
      : super(key: key);

  @override
  State<CommonWithdrawView> createState() => CommonWithdrawViewState();
}

class CommonWithdrawViewState extends State<CommonWithdrawView> {
  late CommonWithdrawViewModel viewModel;

  final key = GlobalKey<CommonWithdrawViewState>();
  String? bankID;
  FocusNode? focusNode1;
  FocusNode? focusNode2;
  FocusNode? focusNode3;
  FocusNode? focusNode4;
  FocusNode? focusNode5;
  GlobalKey<FormFieldState> field1Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field5Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field3Key = GlobalKey<FormFieldState>();
  late MarketViewModel marketViewModel;
  late WalletViewModel walletViewModel;

  final GlobalKey field4Key = GlobalKey();

  final TextEditingController wallet = TextEditingController();

  final GlobalKey bankKey = GlobalKey();
  final GlobalKey network = GlobalKey();
  final formKey = GlobalKey<FormState>();
  late GetCurrencyViewModel getCurrencyViewModel;
  late CoinDetailsViewModel coinDetailsViewModel;
  late StreamSubscription<bool> keyboardSubscription;
  var overlayEntry;

  @override
  void initState() {
    getCurrencyViewModel =
        Provider.of<GetCurrencyViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);

    viewModel = Provider.of<CommonWithdrawViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.balance = widget.availableBalance.toString();
      viewModel.getDashBoardBalance(widget.currencyCode.toString());
      getCurrencyViewModel.getCurrencyForCryptoWithdraw(widget.currencyType);
      constant.walletCurrency.value = widget.currencyCode.toString();

      viewModel.recepientAddress.clear();
      viewModel.amount.clear();
      viewModel.fiatAmount.clear();
    });
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode1!.addListener(() {
      if (!focusNode1!.hasFocus) {
        field1Key.currentState?.validate();
      }
    });
    focusNode2!.addListener(() {
      if (!focusNode2!.hasFocus) {
        field2Key.currentState!.validate();
      }
    });

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      viewModel.setKeyboardVisibility(visible);
      if (Platform.isIOS) {
        if (!visible)
          removeOverlay();
        else
          showOverlay(context);
      }
    });
  }

  Future<bool> willPopScopeCall() async {
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);
    coinDetailsViewModel.getCryptoWithdrawHistoryDetails();
    return true; // return true to exit app or return false to cancel exit
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
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

  @override
  void dispose() {
    focusNode1!.dispose();
    focusNode2!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCurrencyViewModel = context.watch<GetCurrencyViewModel>();
    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();

    walletViewModel = context.watch<WalletViewModel>();
    viewModel = context.watch<CommonWithdrawViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    return Provider<GetCurrencyViewModel>(
      create: (context) => getCurrencyViewModel,
      child: WillPopScope(
        onWillPop: willPopScopeCall,
        child: CustomScaffold(
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
                        getCurrencyViewModel.bankName = [];
                        coinDetailsViewModel =
                            Provider.of<CoinDetailsViewModel>(context,
                                listen: false);
                        // coinDetailsViewModel.getCryptoCurrency(widget.currencyType);
                        coinDetailsViewModel.getCryptoWithdrawHistoryDetails();
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
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      fontfamily: 'InterTight',
                      fontsize: 21,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      text: (widget.currencyType ==
                                  CurrencyType.CRYPTO.toString() ||
                              widget.currencyType == "crypto")
                          ? "${stringVariables.withdraw} ${widget.currencyCode} ${stringVariables.wallets}"
                          : stringVariables.fiatWithdraw,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: viewModel.needToLoad
              ? const Center(child: CustomLoader())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomCard(
                        radius: 25,
                        edgeInsets: 15,
                        outerPadding: 25,
                        elevation: 0,
                        child: (widget.currencyType ==
                                    CurrencyType.CRYPTO.toString() ||
                                widget.currencyType == "crypto")
                            ? Column(
                                children: [
                                  cryptoWithdraw(),
                                  crptoBalance(),
                                ],
                              )
                            : Column(
                                children: [
                                  fiatWithdraw(),
                                  fiatBalance(),
                                ],
                              ),
                      ),
                      (widget.currencyType == CurrencyType.CRYPTO.toString() ||
                              widget.currencyType == "crypto")
                          ? fiatNotes()
                          : CryptoNotes(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  /// Crypto Withdraw
  Widget cryptoWithdraw() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.01,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CustomText(
                  text: stringVariables.cryptoWithdraw,
                  fontWeight: FontWeight.bold,
                  fontsize: 18,
                  fontfamily: 'InterTight',
                ),
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          buildRecepientAddressView(),
          buildNetworkView(),
          constant.walletCurrency.value == "XRP"
              ? buildTagIdView()
              : CustomSizedBox(
                  width: 0,
                  height: 0,
                ),
          buildAmountView(),
          buildSelectWalletView()
        ],
      ),
    );
  }

  ///Fiat Withdraw
  Widget fiatWithdraw() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          buildBankView(),
          buildAmountFiatView(),
        ],
      ),
    );
  }

  /// Recepient Address TextFormField with Text
  Widget buildRecepientAddressView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 18),
          child: CustomText(
            text: stringVariables.address,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          isContentPadding: false,
          controller: viewModel.recepientAddress,
          focusNode: focusNode1,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
          autovalid: AutovalidateMode.onUserInteraction,
          validator: (input) => viewModel.recepientAddress.text.isEmpty
              ? stringVariables.addressIsRequired
              : null,
          text: stringVariables.hintRecepientAddress,
          suffixIcon: CustomIconButton(
            onPress: () {
              moveToQR(context);
            },
            child: SvgPicture.asset(
              scanner,
              height: 18,
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// Select Wallet TextFormField with Text
  Widget buildSelectWalletView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 2),
          child: CustomText(
            text: "${stringVariables.send} ${stringVariables.from}",
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            dynamic state = field4Key.currentState;
            _showModal();
          },
          child: AbsorbPointer(
            child: CustomTextFormField(
              size: 30,
              //controller: wallet,
              //   focusNode: focusNode4,
              isReadOnly: true,
              isContentPadding: false,
              text: viewModel.radioValue == SelectWallet.spot
                  ? stringVariables.spotWallet
                  : stringVariables.fundingWallet,
              hintColor: themeSupport().isSelectedDarkMode() ? white : black,
              suffixIcon: Icon(
                key: field4Key,
                Icons.arrow_forward_ios,
                size: 15,
                color: stackCardText,
              ),
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  dynamic _showModal() async {
    final result = await Navigator.of(context).push(
        SelectWalletForWithdrawBottomSheet(
            context, widget.currencyCode.toString()));
  }

  /// Network TextFormField with Text
  Widget buildNetworkView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 2),
          child: CustomText(
            text: stringVariables.network,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        GestureDetector(
          onTap: () {
            dynamic state = network.currentState;
            state.showButtonMenu();
          },
          child: AbsorbPointer(
            child: CustomTextFormField(
              size: 30,
              //controller: network,
              //focusNode: focusNode3,
              keys: field3Key,
              isContentPadding: false,

              isReadOnly: true,
              text: getCurrencyViewModel.network.toString(),
              hintColor: themeSupport().isSelectedDarkMode() ? white : black,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    key: network,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    offset:
                        Offset(0, MediaQuery.of(context).size.height / 22.5),
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width / 3,
                      maxWidth: MediaQuery.of(context).size.width / 3,
                      minHeight: (MediaQuery.of(context).size.height / 12),
                      maxHeight: (MediaQuery.of(context).size.height / 3.75),
                    ),
                    onSelected: onSelected,
                    iconSize: 0,
                    color: themeSupport().isSelectedDarkMode() ? black : grey,
                    itemBuilder: (
                      BuildContext context,
                    ) {
                      return getCurrencyViewModel.networkDropDown
                          .map<PopupMenuItem<String>>((String? value) {
                        return PopupMenuItem(
                            onTap: () {},
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  fontsize: 16,
                                  fontfamily: 'InterTight',
                                  fontWeight: FontWeight.w500,
                                  text: value.toString(),
                                ),
                              ],
                            ));
                      }).toList();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 22,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        //getNetworkOfItem(widget.currencyCode.toString()),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  // getNetworkOfItem(String item) {
  //   List list = (marketViewModel.getCurrencies
  //       ?.where((element) => element.currencyCode == item)
  //       .toList() ??
  //       []);
  //
  //   if (list.isNotEmpty) viewModel.networkWidget = list.first.network ?? "";
  //   return viewModel.networkWidget;
  // }

  /// TagId TextFormField with Text
  Widget buildAmountView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 2),
          child: CustomText(
            text: stringVariables.amount,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller: viewModel.amount,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          focusNode: focusNode2,
          keys: field2Key,
          isContentPadding: false,
          validator: (input) => viewModel.amount.text.isEmpty
              ? stringVariables.addressIsRequired
              : null,
          autovalid: AutovalidateMode.onUserInteraction,
          onChanged: (value) => {
            if (value.length > 0)
              {getCurrencyViewModel.updateExchangeRate(double.parse(value))}
            else
              {getCurrencyViewModel.updateFiatExchangeRate(double.parse("0"))}
          },
          text: stringVariables.hintenterAmount,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// TagId TextFormField with Text
  Widget buildTagIdView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 2),
          child: CustomText(
            text: stringVariables.tagID,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller: viewModel.tagId,
          focusNode: focusNode5,
          keys: field5Key,
          isContentPadding: false,
          validator: (input) => viewModel.tagId.text.isEmpty
              ? stringVariables.tagIDRequired
              : null,
          autovalid: AutovalidateMode.onUserInteraction,
          text: stringVariables.hintenterTagId,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// Amount TextFormField with Text
  Widget buildAmountFiatView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 18),
          child: CustomText(
            text: stringVariables.amount,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller: viewModel.fiatAmount,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          autovalid: AutovalidateMode.onUserInteraction,
          focusNode: focusNode2,
          keys: field2Key,
          validator: (input) => viewModel.fiatAmount.text.isEmpty
              ? stringVariables.amountrequired
              : null,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
          isContentPadding: false,
          onChanged: (value) => {
            if (value.length > 0)
              {getCurrencyViewModel.updateFiatExchangeRate(double.parse(value))}
            else
              {getCurrencyViewModel.updateFiatExchangeRate(double.parse("0"))}
          },
          text: stringVariables.hintenterAmount,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// Recepient Address TextFormField with Text
  Widget buildBankView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 18),
          child: CustomText(
            text: stringVariables.bank,
            fontsize: 15,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            dynamic state = bankKey.currentState;
            state.showButtonMenu();
          },
          child: AbsorbPointer(
            child: CustomTextFormField(
              size: 30,
              controller: viewModel.bank,
              focusNode: focusNode1,
              autovalid: AutovalidateMode.onUserInteraction,
              keys: field1Key,
              validator: (input) => viewModel.bank.text.isEmpty
                  ? stringVariables.thisFieldRequired
                  : null,
              isContentPadding: false,
              suffixIcon: PopupMenuButton(
                key: bankKey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                offset: Offset(-(MediaQuery.of(context).size.width / 1.6), 0),
                constraints: new BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height / 12),
                  minWidth: (MediaQuery.of(context).size.width / 1.25),
                  maxHeight: (MediaQuery.of(context).size.height / 2),
                  maxWidth: (MediaQuery.of(context).size.width / 1.25),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                onSelected: (value) {
                  viewModel.bank.text = value as String;
                },
                color: checkBrightness.value == Brightness.dark ? black : white,
                itemBuilder: (
                  BuildContext context,
                ) {
                  return getCurrencyViewModel.bankName!
                      .map<PopupMenuItem<String>>((String? value) {
                    return PopupMenuItem(
                        onTap: () {
                          var id = getCurrencyViewModel.bankName
                              ?.indexOf(value.toString());
                          bankID = getCurrencyViewModel
                              .bankDetail?[0].bankDetails?[id!].id;
                        },
                        child: CustomText(text: value.toString()),
                        value: value);
                  }).toList();
                },
              ),
              text: stringVariables.hintSelectBank,
              hintColor: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List list) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    list.forEach((value) {
      dropDownItems.add(DropdownMenuItem<String>(
        value: value,
        child: CustomText(
            text: value,
            fontWeight: FontWeight.bold,
            color: textGrey,
            fontsize: 15),
      ));
    });

    return dropDownItems;
  }

  ///fiat Balance
  fiatBalance() {
    return Column(
      children: [
        CustomContainer(
          width: 1.4,
          height: 5.7,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      overflow: TextOverflow.ellipsis,
                      softwrap: true,
                      text: '${stringVariables.minimumwithdrawal}:',
                      color: hintLight,
                      fontfamily: 'InterTight',
                      fontWeight: FontWeight.w600,
                      fontsize: 13),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'InterTight',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: trimAs2(
                            '${getCurrencyViewModel.fiatMinWithdrawLimit}'),
                        fontsize: isSmallScreen(context) ? 12 : 14,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'InterTight',
                        overflow: TextOverflow.ellipsis,
                        text: ' ${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: isSmallScreen(context) ? 11 : 13,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      overflow: TextOverflow.ellipsis,
                      softwrap: true,
                      text: '${stringVariables.transactionFee}:',
                      color: hintLight,
                      fontfamily: 'InterTight',
                      fontWeight: FontWeight.w600,
                      fontsize: 13),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'InterTight',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: viewModel.fiatAmount.text.isEmpty
                            ? "0.00"
                            : getCurrencyViewModel.fiatTransactionFee
                                .toStringAsFixed(2),
                        fontsize: isSmallScreen(context) ? 12 : 14,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'InterTight',
                        overflow: TextOverflow.ellipsis,
                        text: ' ${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: isSmallScreen(context) ? 11 : 13,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      overflow: TextOverflow.ellipsis,
                      softwrap: true,
                      text: '${stringVariables.youWilGet}:',
                      color: hintLight,
                      fontfamily: 'InterTight',
                      fontWeight: FontWeight.w600,
                      fontsize: 13),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'InterTight',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: viewModel.fiatAmount.text.isEmpty
                            ? "0.00"
                            : getCurrencyViewModel.fiatYouWillGet
                                .toStringAsFixed(2),
                        fontsize: isSmallScreen(context) ? 12 : 14,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'InterTight',
                        overflow: TextOverflow.ellipsis,
                        text: ' ${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: isSmallScreen(context) ? 11 : 13,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
            ],
          ),
        ),
        CustomElevatedButton(
          press: () {
            if (formKey.currentState!.validate()) {
              if (viewModel.bank.text.isNotEmpty &&
                  viewModel.fiatAmount.text.isNotEmpty) {
                if (getCurrencyViewModel.viewModelVerification?.tfaStatus ==
                        'verified' ||
                    getCurrencyViewModel.viewModelVerification
                            ?.tfaAuthentication?.mobileNumber?.status ==
                        "verified") {
                  moveToVerifyCode(
                      context,
                      AuthenticationVerificationType.fiatWithdrawSubmit,
                      getCurrencyViewModel.viewModelVerification?.tfaStatus,
                      getCurrencyViewModel.viewModelVerification
                          ?.tfaAuthentication?.mobileNumber?.status,
                      getCurrencyViewModel.viewModelVerification
                          ?.tfaAuthentication?.mobileNumber?.phoneCode,
                      getCurrencyViewModel.viewModelVerification
                          ?.tfaAuthentication?.mobileNumber?.phoneNumber);
                } else {
                  customSnackBar.showSnakbar(context, stringVariables.enableTfa,
                      SnackbarType.negative);
                }
              }
            }
          },
          buttoncolor: themeColor,
          width: 1.3,
          isBorderedButton: true,
          color: themeSupport().isSelectedDarkMode() ? black : white,
          icon: '',
          radius: 25,
          text: stringVariables.submit.toUpperCase(),
          height: MediaQuery.of(context).size.height / 50,
          icons: false,
          maxLines: 1,
          offset: Offset(2, 2),
          spreadRadius: 4,
          blurRadius: 16,
          multiClick: true,
        )
      ],
    );
  }

  ///crpto Balance
  crptoBalance() {
    return Column(
      children: [
        CustomContainer(
          width: 1.4,
          height: 4.7,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      overflow: TextOverflow.ellipsis,
                      softwrap: true,
                      text: '${stringVariables.availableBalance}:',
                      color: hintLight,
                      fontfamily: 'InterTight',
                      fontWeight: FontWeight.w600,
                      fontsize: 13),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'InterTight',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: trimDecimalsForBalance(viewModel.balance),
                        fontsize: isSmallScreen(context) ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'InterTight',
                        overflow: TextOverflow.ellipsis,
                        text: ' ${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: isSmallScreen(context) ? 11 : 13,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      overflow: TextOverflow.ellipsis,
                      softwrap: true,
                      text: '${stringVariables.minimumwithdrawal}:',
                      color: hintLight,
                      fontfamily: 'InterTight',
                      fontWeight: FontWeight.w600,
                      fontsize: 13),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'InterTight',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: trimDecimalsForBalance(
                            '${getCurrencyViewModel.minWithdrawLimit}'),
                        fontsize: isSmallScreen(context) ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'InterTight',
                        overflow: TextOverflow.ellipsis,
                        text: ' ${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: isSmallScreen(context) ? 11 : 13,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      overflow: TextOverflow.ellipsis,
                      softwrap: true,
                      text: '${stringVariables.transactionFee}:',
                      color: hintLight,
                      fontfamily: 'InterTight',
                      fontWeight: FontWeight.bold,
                      fontsize: 13),
                  Row(
                    children: [
                      CustomContainer(
                        width: 4.7,
                        child: CustomText(
                          align: TextAlign.end,
                          fontfamily: 'InterTight',
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          text: viewModel.amount.text.isEmpty
                              ? "0.00"
                              : trimDecimalsForBalance(getCurrencyViewModel
                                  .transactionFee
                                  .toString()),
                          fontsize: isSmallScreen(context) ? 12 : 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'InterTight',
                        overflow: TextOverflow.ellipsis,
                        text: ' ${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: isSmallScreen(context) ? 11 : 13,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      overflow: TextOverflow.ellipsis,
                      softwrap: true,
                      text: '${stringVariables.youWilGet}:',
                      color: hintLight,
                      fontfamily: 'InterTight',
                      fontWeight: FontWeight.bold,
                      fontsize: 13),
                  Row(
                    children: [
                      CustomContainer(
                        width: 4.7,
                        child: CustomText(
                          align: TextAlign.end,
                          fontfamily: 'InterTight',
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          text: viewModel.amount.text.isEmpty
                              ? "0.00"
                              : getCurrencyViewModel.youWillGet
                                  .toStringAsFixed(2),
                          fontsize: isSmallScreen(context) ? 12 : 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'InterTight',
                        overflow: TextOverflow.ellipsis,
                        text: ' ${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: isSmallScreen(context) ? 11 : 13,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
            ],
          ),
        ),
        CustomElevatedButton(
          press: () {
            if (formKey.currentState!.validate()) {
              if (viewModel.recepientAddress.text.isNotEmpty &&
                  viewModel.amount.text.isNotEmpty) {
                if (getCurrencyViewModel.viewModelVerification?.tfaStatus ==
                        'verified' ||
                    getCurrencyViewModel.viewModelVerification
                            ?.tfaAuthentication?.mobileNumber?.status ==
                        "verified") {
                  moveToVerifyCode(
                    context,
                    AuthenticationVerificationType.cryptoWithdraw,
                    getCurrencyViewModel.viewModelVerification?.tfaStatus,
                    getCurrencyViewModel.viewModelVerification
                        ?.tfaAuthentication?.mobileNumber?.status,
                    getCurrencyViewModel.viewModelVerification
                        ?.tfaAuthentication?.mobileNumber?.phoneCode,
                    getCurrencyViewModel.viewModelVerification
                        ?.tfaAuthentication?.mobileNumber?.phoneNumber,
                  );
                } else {
                  customSnackBar.showSnakbar(context, stringVariables.enableTfa,
                      SnackbarType.negative);
                }
              }
            }
          },
          buttoncolor: themeColor,
          width: 1.3,
          isBorderedButton: true,
          color: themeSupport().isSelectedDarkMode() ? black : white,
          icon: '',
          radius: 25,
          text: stringVariables.submit.toUpperCase(),
          height: MediaQuery.of(context).size.height / 50,
          icons: false,
          maxLines: 1,
          offset: Offset(2, 2),
          spreadRadius: 4,
          blurRadius: 16,
          multiClick: true,
        )
      ],
    );
  }

  /// Fiat Withdraw Notes
  fiatNotes() {
    return CustomContainer(
      width: 1.2,
      height: 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: stringVariables.notes,
                fontsize: 15,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomText(
            text: stringVariables.fiatNote1,
            strutStyleHeight: 1.5,
          ),
          CustomSizedBox(
            height: 0.005,
          ),
          CustomText(
            text: stringVariables.fiatNote2,
            strutStyleHeight: 1.5,
          )
        ],
      ),
    );
  }

  /// Crypto Withdraw Notes
  CryptoNotes() {
    return CustomContainer(
      width: 1.2,
      height: 4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: stringVariables.notes,
                fontsize: 15,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomText(
            text: stringVariables.crptoNote1,
            strutStyleHeight: 1.5,
          ),
          CustomSizedBox(
            height: 0.005,
          ),
          CustomText(
            text: stringVariables.crptoNote2,
            strutStyleHeight: 1.5,
          )
        ],
      ),
    );
  }

  moveToQR(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomQrCode(),
        ));

    if (result.contains(":")) {
      var parts = result.split(':');
      viewModel.recepientAddress.text = parts[1];
    } else {
      viewModel.recepientAddress.text = result;
    }
  }

  onSelected(String value) async {
    await viewModel.setNetWorkDropdown(value);
    await getCurrencyViewModel.setNetwork(value);
  }
}
