import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomQrCode.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';

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
import '../../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../../CoinDetailsViewModel/GetcurrencyViewModel.dart';

class CommonWithdrawView extends StatefulWidget {
  String? currencyType;
  String? currencyCode;
  String? availableBalance;

  CommonWithdrawView({Key? key, this.currencyType, this.currencyCode,this.availableBalance})
      : super(key: key);

  @override
  State<CommonWithdrawView> createState() => CommonWithdrawViewState();
}

class CommonWithdrawViewState extends State<CommonWithdrawView> {
  final key = GlobalKey<CommonWithdrawViewState>();
  String? bankID;
  FocusNode? focusNode1;
  FocusNode? focusNode2;
  FocusNode? focusNode3;
  FocusNode? focusNode4;
  FocusNode? focusNode5;
  GlobalKey<FormFieldState> field1Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field3Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field5Key = GlobalKey<FormFieldState>();
  final GlobalKey field4Key = GlobalKey();

  final GlobalKey network = GlobalKey();

  final GlobalKey bankKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  late GetCurrencyViewModel getCurrencyViewModel;
  late CoinDetailsViewModel coinDetailsViewModel;
  late CommonWithdrawViewModel commonWithdrawViewModel;

  @override
  void initState() {
    getCurrencyViewModel = Provider.of<GetCurrencyViewModel>(context, listen: false);
    commonWithdrawViewModel = Provider.of<CommonWithdrawViewModel>(context, listen: false);
    getCurrencyViewModel.getCurrencyForCryptoWithdraw(widget.currencyType);
    super.initState();
    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode1!.addListener(() {
      if (!focusNode1!.hasFocus) {
        field1Key.currentState!.validate();
      }
    });
    focusNode2!.addListener(() {
      if (!focusNode2!.hasFocus) {
        field2Key.currentState!.validate();
      }
    });
  }

  Future<bool> willPopScopeCall() async {
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);
    coinDetailsViewModel.getCryptoCurrency(widget.currencyType);
    return true; // return true to exit app or return false to cancel exit
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
    commonWithdrawViewModel = context.watch<CommonWithdrawViewModel>();
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
                        coinDetailsViewModel
                            .getCryptoCurrency(widget.currencyType);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SvgPicture.asset(
                          backArrow,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      fontfamily: 'GoogleSans',
                      fontsize: 21,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      text:
                          widget.currencyType == CurrencyType.CRYPTO.toString()
                              ? "Withdraw ${widget.currencyCode} Wallet"
                              : "Fiat Withdraw",
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: (getCurrencyViewModel.needToLoad)
              ? Center(child: CustomLoader())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomCard(
                        radius: 25,
                        edgeInsets: 15,
                        outerPadding: 25,
                        elevation: 0,
                        child: widget.currencyType ==
                                CurrencyType.CRYPTO.toString()
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
                      widget.currencyType == CurrencyType.CRYPTO.toString()
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
                  fontfamily: 'GoogleSans',
                ),
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          buildRecepientAddressView(),
          buildNetworkView(),
          constant.walletCurrency.value == "XRP" ?
          buildTagIdView() : CustomSizedBox(width: 0,height: 0,),
          buildAmountView(),
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
            fontfamily: 'GoogleSans',
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
          keys: field1Key,
          controller: commonWithdrawViewModel.recepientAddress,
          focusNode: focusNode1,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
          autovalid: AutovalidateMode.onUserInteraction,
          validator: (input) =>
          commonWithdrawViewModel.recepientAddress.text.isEmpty ? 'Address is required' : null,
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
            fontfamily: 'GoogleSans',
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
              text: commonWithdrawViewModel.netwoksDropDownValue.toString(),
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
                    offset: Offset(
                        0, MediaQuery
                        .of(context)
                        .size
                        .height / 22.5),
                    constraints: BoxConstraints(
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      minHeight:
                      (MediaQuery
                          .of(context)
                          .size
                          .height / 12),
                      maxHeight:
                      (MediaQuery
                          .of(context)
                          .size
                          .height / 3.75),
                    ),
                    onSelected: onSelected,
                    iconSize: 0,
                    color: themeSupport().isSelectedDarkMode()
                        ? black
                        : grey,
                    itemBuilder: (BuildContext context,) {
                      return  commonWithdrawViewModel.netwoksDropDown!
                          .map<PopupMenuItem<String>>((String? value) {
                        return PopupMenuItem(
                            onTap: () {},
                            value: value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  fontsize: 16,
                                  fontfamily: 'Comfortaa',
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
                      color: themeSupport().isSelectedDarkMode()
                          ? white
                          : black,
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller:  commonWithdrawViewModel.tagId,
          focusNode: focusNode5,
          keys: field5Key,
          isContentPadding: false,
          validator: (input) => commonWithdrawViewModel.tagId.text.isEmpty ? 'Tag Id is required' : null,
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller: commonWithdrawViewModel.amount,
          focusNode: focusNode2,
          keys: field2Key,
          isContentPadding: false,
          validator: (input) =>
          commonWithdrawViewModel.amount.text.isEmpty ? 'Amount is required' : null,
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          size: 30,
          controller: commonWithdrawViewModel.fiatAmount,
          autovalid: AutovalidateMode.onUserInteraction,
          focusNode: focusNode2,
          keys: field2Key,
          validator: (input) =>
          commonWithdrawViewModel.fiatAmount.text.isEmpty ? 'Amount is required' : null,
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
            fontfamily: 'GoogleSans',
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
              controller: commonWithdrawViewModel.bank,
              focusNode: focusNode1,
              autovalid: AutovalidateMode.onUserInteraction,
              keys: field1Key,
              validator: (input) =>
              commonWithdrawViewModel.bank.text.isEmpty ? ' This field is required' : null,
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
                  commonWithdrawViewModel.bank.text = value as String;
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
                        child: CustomText(text:value.toString()),
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
        child: CustomText(text:
          value,
              fontWeight: FontWeight.bold, color: textGrey, fontsize: 15
        ),
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
                      fontfamily: 'GoogleSans',
                      fontWeight: FontWeight.w600,
                      fontsize: 14),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'GoogleSans',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: '${getCurrencyViewModel.fiatMinWithdrawLimit}',
                        fontsize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'GoogleSans',
                        overflow: TextOverflow.ellipsis,
                        text: '${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 15,
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
                      fontfamily: 'GoogleSans',
                      fontWeight: FontWeight.w600,
                      fontsize: 14),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'GoogleSans',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: commonWithdrawViewModel.fiatAmount.text.isEmpty
                            ? "0.0"
                            : '${getCurrencyViewModel.fiatTransactionFee.toStringAsFixed(2)}',
                        fontsize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'GoogleSans',
                        overflow: TextOverflow.ellipsis,
                        text: '${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 15,
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
                      fontfamily: 'GoogleSans',
                      fontWeight: FontWeight.w600,
                      fontsize: 14),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'GoogleSans',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: commonWithdrawViewModel.fiatAmount.text.isEmpty
                            ? "0.0"
                            : '${getCurrencyViewModel.fiatYouWillGet.toStringAsFixed(2)}',
                        fontsize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'GoogleSans',
                        overflow: TextOverflow.ellipsis,
                        text: '${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 15,
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
              if (commonWithdrawViewModel.bank.text.isNotEmpty && commonWithdrawViewModel.fiatAmount.text.isNotEmpty) {
                if (getCurrencyViewModel.viewModelVerification?.tfaStatus ==
                    'verified') {
                  moveToVerifyCode(
                      context,
                      AuthenticationVerificationType.fiatWithdrawSubmit,
                      key,
                      getCurrencyViewModel,
                      commonWithdrawViewModel.bank.text,
                      commonWithdrawViewModel.fiatAmount.text,
                      bankID,
                      commonWithdrawViewModel.amount.text,
                      commonWithdrawViewModel.recepientAddress.text);
                } else {
                  customSnackBar.showSnakbar(
                      context,
                      "You have not enabled TFA! Enable TFA to continue",
                      SnackbarType.negative);
                }
              }
            }
          },
          buttoncolor: themeColor,
          width: 1.3,
          isBorderedButton: true,
          color: black,
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
                      fontfamily: 'GoogleSans',
                      fontWeight: FontWeight.w600,
                      fontsize: 15),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'GoogleSans',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: '${getCurrencyViewModel.minWithdrawLimit}',
                        fontsize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'GoogleSans',
                        overflow: TextOverflow.ellipsis,
                        text: '${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 15,
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
                      fontfamily: 'GoogleSans',
                      fontWeight: FontWeight.bold,
                      fontsize: 15),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'GoogleSans',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: commonWithdrawViewModel.amount.text.isEmpty
                            ? "0.00"
                            : '${getCurrencyViewModel.transactionFee.toStringAsFixed(2)}',
                        fontsize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'GoogleSans',
                        overflow: TextOverflow.ellipsis,
                        text: '${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 15,
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
                      fontfamily: 'GoogleSans',
                      fontWeight: FontWeight.bold,
                      fontsize: 15),
                  Row(
                    children: [
                      CustomText(
                        align: TextAlign.end,
                        fontfamily: 'GoogleSans',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: commonWithdrawViewModel.amount.text.isEmpty
                            ? "0.00"
                            : '${getCurrencyViewModel.youWillGet.toStringAsFixed(2)}',
                        fontsize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        align: TextAlign.end,
                        softwrap: true,
                        maxlines: 1,
                        fontfamily: 'GoogleSans',
                        overflow: TextOverflow.ellipsis,
                        text: '${widget.currencyCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 15,
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
              if (commonWithdrawViewModel.recepientAddress.text.isNotEmpty && commonWithdrawViewModel.amount.text.isNotEmpty) {
                if (getCurrencyViewModel.viewModelVerification?.tfaStatus ==
                    'verified') {
                  moveToVerifyCode(
                      context,
                      AuthenticationVerificationType.cryptoWithdraw,
                      key,
                      getCurrencyViewModel,
                      commonWithdrawViewModel.bank.text = '',
                      commonWithdrawViewModel.fiatAmount.text = '',
                      bankID = '',
                      commonWithdrawViewModel.amount.text,
                      commonWithdrawViewModel.recepientAddress.text);
                } else {
                  customSnackBar.showSnakbar(
                      context,
                      "You have not enabled TFA! Enable TFA to continue",
                      SnackbarType.negative);
                }
              }
            }
          },
          buttoncolor: themeColor,
          width: 1.3,
          isBorderedButton: true,
          color: black,
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

  getUsertypedDetails(
    BuildContext context,
  ) {
    if (commonWithdrawViewModel.amount.text != "" && commonWithdrawViewModel.recepientAddress.text != "") {
      getCurrencyViewModel.CreateCryptoWithdraw(
          constant.walletCurrency.value,
          commonWithdrawViewModel.recepientAddress.text,
          double.parse(commonWithdrawViewModel.amount.text),
          double.parse('${getCurrencyViewModel.transactionFee}'),
          double.parse('${getCurrencyViewModel.withdraw}'),
          double.parse('${getCurrencyViewModel.youWillGet}'),
          context);
    }
  }

  getUserFiattypedDetails(
    BuildContext context,
  ) {
    if (commonWithdrawViewModel.bank.text != "" && commonWithdrawViewModel.fiatAmount.text != "") {
      getCurrencyViewModel.CreateFiatWithdraw(
          constant.walletCurrency.value,
          double.parse(commonWithdrawViewModel.fiatAmount.text),
          double.parse('${getCurrencyViewModel.fiatWithdrawFee}'),
          double.parse('${getCurrencyViewModel.withdrawFiat}'),
          context,
          bankID);
    }
  }

  moveToQR(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomQrCode(),
        ));

    if (result.contains(":")) {
      var parts = result.split(':');
      commonWithdrawViewModel.recepientAddress.text = parts[1];
    } else {
      commonWithdrawViewModel.recepientAddress.text = result;
    }
  }
  onSelected(String value) async {
    await  commonWithdrawViewModel.setNetWorkDropdown(value);
  }
}
