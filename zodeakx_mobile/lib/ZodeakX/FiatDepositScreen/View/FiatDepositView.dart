import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';

import '../../../Common/Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../DashBoardScreen/Model/DashBoardModel.dart';
import '../ViewModel/FiatDepositViewModel.dart';

class FiatDepositView extends StatefulWidget {
  const FiatDepositView({Key? key}) : super(key: key);

  @override
  State<FiatDepositView> createState() => _FiatDepositViewState();
}

class _FiatDepositViewState extends State<FiatDepositView>
    with SingleTickerProviderStateMixin {
  final TextEditingController amount = TextEditingController();
  final TextEditingController paymentAmountController = TextEditingController();
  late FiatDepositViewModel adminBankDetail;
  late CoinDetailsViewModel coinDetailsViewModel;
  final TextEditingController transactionContoller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late TabController _tabController;

  @override
  void initState() {
    adminBankDetail = Provider.of<FiatDepositViewModel>(context, listen: false);
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);
    adminBankDetail.getAdminBankDetails();
    super.initState();
    adminBankDetail = FiatDepositViewModel();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      adminBankDetail.setTabView(_tabController.index == 0);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    adminBankDetail = context.watch<FiatDepositViewModel>();
    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();

    return Provider<FiatDepositViewModel>(
      create: (context) => adminBankDetail,
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
                        coinDetailsViewModel
                            .getCryptoCurrency(CurrencyType.FIAT.toString());
                        adminBankDetail.imagePicName =
                            stringVariables.transactionProof;
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
                      fontsize: 23,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      text: stringVariables.fiatDeposit,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    bankDetails(),
                    tabBar(),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom)),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget selectedCurrency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 28),
          child: Row(
            children: [
              CustomText(
                text: stringVariables.selectedCurrency,
                fontsize: 15,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                text: ' ${constant.walletCurrency.value}',
                fontsize: 15,
                fontWeight: FontWeight.bold,
              )
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: CustomText(text: stringVariables.amount),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: CustomTextFormField(
            size: 30,
            isContentPadding: false,
            controller: paymentAmountController,
            onChanged: (value) => {
              if (value.length > 0)
                {adminBankDetail.updateExchangeRate(double.parse(value))}
            },
            text: stringVariables.enterAmount,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28.0, right: 28.0),
          child: CustomText(
              text: paymentAmountController.text +
                  " " +
                  constant.walletCurrency.value +
                  " = " +
                  '${paymentAmountController.text.length == 0 ? "0" : adminBankDetail.exchangeRate ?? ''} ${adminBankDetail.paymentCurrencyExchangeRate?.toCurrencyCode} '),
        ),
        Padding(
          padding: EdgeInsets.only(top: 18.0, left: 24, right: 22),
          child: adminBankDetail.paypalLoader
              ? CustomLoader()
              : CustomElevatedButton(
                  multiClick: true,
                  text: '',
                  IconHeight: 25,
                  color: themeSupport().isSelectedDarkMode() ? black : white,
                  press: () async {
                    if (adminBankDetail.braintreeClientToken != null &&
                        paymentAmountController.text.isNotEmpty) {
                      adminBankDetail.setPaypalLoading(true);
                      final request = BraintreePayPalRequest(
                          amount: paymentAmountController.text.toString());
                      try {
                        BraintreePaymentMethodNonce? result =
                            await Braintree.requestPaypalNonce(
                          adminBankDetail.braintreeClientToken!.clientToken
                              .toString(),
                          request,
                        );
                        if (result != null) {
                          adminBankDetail.UpdateFiatTrasaction(
                              (double.parse(
                                      adminBankDetail.exchangeRate.toString())
                                  .toStringAsFixed(2)),
                              (double.parse(
                                      paymentAmountController.text.toString())
                                  .toStringAsFixed(2)),
                              result.nonce,
                              paymentAmountController,
                              context);
                        } else {
                          adminBankDetail.setPaypalLoading(false);
                          customSnackBar.showSnakbar(
                              context,
                              stringVariables.payPalCancelled,
                              SnackbarType.negative);
                        }
                      } catch (e) {
                        adminBankDetail.setPaypalLoading(false);
                        customSnackBar.showSnakbar(
                            context,
                            stringVariables.payPalCancelled,
                            SnackbarType.negative);
                      }
                    }
                  },
                  radius: 25,
                  buttoncolor: themeColor,
                  width: 0.0,
                  height: MediaQuery.of(context).size.height / 50,
                  isBorderedButton: false,
                  maxLines: 1,
                  icons: true,
                  icon: payPal,
                ),
        ),
      ],
    );
  }

  Widget bankDetails() {
    return Column(
      children: [
        CustomCard(
            radius: 25,
            edgeInsets: 8,
            outerPadding: 8,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: stringVariables.adminAccName,
                        fontsize: 14,
                        color: textGrey,
                      ),
                      CustomText(
                        text:
                            '${adminBankDetail.getAdminDetails?.first.adminAccountName}',
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: stringVariables.adminAccNum,
                        fontsize: 14,
                        color: textGrey,
                      ),
                      CustomText(
                        text:
                            '${adminBankDetail.getAdminDetails?.first.adminAccountNumber}',
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: '${stringVariables.bankAddress} :',
                        fontsize: 14,
                        color: textGrey,
                      ),
                      CustomText(
                        text:
                            '${adminBankDetail.getAdminDetails?.first.bankAddress}',
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: stringVariables.bankCountry,
                        fontsize: 14,
                        color: textGrey,
                      ),
                      CustomText(
                        text:
                            '${adminBankDetail.getAdminDetails?.first.bankCountry}',
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: '${stringVariables.bankName} :',
                        fontsize: 14,
                        color: textGrey,
                      ),
                      CustomText(
                        text:
                            '${adminBankDetail.getAdminDetails?.first.bankName}',
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: stringVariables.bankPostal,
                        fontsize: 14,
                        color: textGrey,
                      ),
                      CustomText(
                        text:
                            '${adminBankDetail.getAdminDetails?.first.bankPostalZipCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: stringVariables.bankRoute,
                        fontsize: 14,
                        color: textGrey,
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Container(
                              height: 45,
                              width: 140,
                              child: CustomText(
                                text:
                                    '${adminBankDetail.getAdminDetails?.first.bankRoutingSortCode}',
                                fontWeight: FontWeight.bold,
                                fontsize: 14,
                                maxlines: 2,
                                softwrap: true,
                              )),
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
                      CustomText(
                        text: stringVariables.bankSwift,
                        fontsize: 14,
                        color: textGrey,
                      ),
                      CustomText(
                        text:
                            '${adminBankDetail.getAdminDetails?.first.bankSwiftBicCode}',
                        fontWeight: FontWeight.bold,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget tabBar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // the tab bar with two items
          Container(
            height: 50,
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: themeColor,
              labelColor:
                  checkBrightness.value == Brightness.dark ? white : black,
              labelStyle: TextStyle(
                fontSize: 12,
              ),
              tabs: [
                Tab(
                  text: stringVariables.manualDeposit,
                ),
                Tab(
                  text: stringVariables.otherPayment,
                ),
              ],
            ),
          ),
          tabBarView(),
        ],
      ),
    );
  }

  transactionProof() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 28),
            child: Row(
              children: [
                CustomText(
                  text: stringVariables.transactions,
                  fontsize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: CustomText(
              text: stringVariables.amount,
              color: textGrey,
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              controller: amount,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              hintColor: themeSupport().isSelectedDarkMode() ? white : black,
              text: stringVariables.enterAmount,
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: CustomText(
              text: stringVariables.transactionId,
              color: textGrey,
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              controller: transactionContoller,
              text: stringVariables.enterTransactionId,
              hintColor: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
          CustomSizedBox(
            height: 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: CustomContainer(
              width: 1.18,
              height: MediaQuery.of(context).size.height / 50,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        align: TextAlign.start,
                        fontfamily: 'InterTight',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text: adminBankDetail.imagePicName ??
                            stringVariables.transactionProof,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                        fontsize: 15,
                      ),
                    ),
                    CustomElevatedButton(
                        blurRadius: 0,
                        spreadRadius: 0,
                        text: stringVariables.chooseFile,
                        color:
                            themeSupport().isSelectedDarkMode() ? black : white,
                        multiClick: true,
                        press: () {
                          adminBankDetail.imagePath();
                        },
                        radius: 25,
                        buttoncolor: themeColor,
                        width: MediaQuery.of(context).size.width / 120,
                        height: MediaQuery.of(context).size.height / 43,
                        isBorderedButton: false,
                        maxLines: 1,
                        icons: false,
                        icon: null)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.0, left: 24, right: 22),
            child: adminBankDetail.needToLoad
                ? CustomLoader()
                : CustomElevatedButton(
                    text: stringVariables.submit,
                    color: themeSupport().isSelectedDarkMode() ? black : white,
                    press: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      if (formKey.currentState!.validate()) {
                        if (amount.text.isNotEmpty &&
                            transactionContoller.text.isNotEmpty &&
                            adminBankDetail.imagePicName != "") {
                          getUsertypedDetails(
                            context,
                          );
                          formKey.currentState!.save();
                        }
                      }
                    },
                    radius: 25,
                    buttoncolor: themeColor,
                    width: 0.0,
                    multiClick: true,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: false,
                    maxLines: 1,
                    icons: false,
                    icon: '',
                  ),
          ),
        ],
      ),
    );
  }

  tabBarView() {
    return CustomContainer(
      width: 1,
      height: 1.7,
      child: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              transactionProof(),
            ],
          ),
          Column(
            children: [
              selectedCurrency(),
            ],
          ),
        ],
      ),
    );
  }

  getUsertypedDetails(
    BuildContext context,
  ) {
    if (amount.text != "" &&
        transactionContoller.text != "" &&
        adminBankDetail.imgUrl != "" &&
        adminBankDetail.imagePicName != "") {
      adminBankDetail.UpdateFiatDeposit(int.parse(amount.text),
          transactionContoller.text, adminBankDetail.imgUrl, context);
    }
  }
}
