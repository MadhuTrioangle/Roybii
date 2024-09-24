import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../CryptoDeposit/View/selectWalletBottomSheet.dart';
import '../../Exchange/ViewModel/ExchangeViewModel.dart';
import '../../SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';
import '../CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../CoinDetailsViewModel/GetcurrencyViewModel.dart';
import '../CommonWithdraw/View/SelectWalletBottomSheet.dart';
import '../CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import '../TransactionDetails/Model/CryptoWithdrawHistoryModel.dart';
import '../TransactionDetails/Model/FiatWithdrawHistory.dart';

class CoinDetailsView extends StatefulWidget {
  String? currencyName;
  String? totalBalance;
  String? availableBalance;
  String? currencyCode;
  String? currencyType;
  String? inorderBalance;
  String? mlmStakeBalance;

  CoinDetailsView({
    Key? key,
    this.currencyName,
    this.totalBalance,
    this.availableBalance,
    this.currencyCode,
    this.currencyType,
    this.inorderBalance,
    this.mlmStakeBalance,
  }) : super(key: key);

  @override
  State<CoinDetailsView> createState() => _CoinDetailsViewState();
}

class _CoinDetailsViewState extends State<CoinDetailsView> {
  var selectedValue;

  int id = 1;
  String? totalBalance = '';
  String? availableBalance = '';
  String? inorderBalance = '';
  String? mlmStakeBalance = '';
  String? currencyCode = '';
  late CoinDetailsViewModel viewmodel;
  late CommonWithdrawViewModel commonWithdrawViewModel;
  late MarketViewModel marketViewModel;
  late GetCurrencyViewModel getcurrencyviewmodel; //1

  final GlobalKey _stateKey = GlobalKey();

  @override
  void initState() {
    viewmodel = Provider.of<CoinDetailsViewModel>(context, listen: false);
    commonWithdrawViewModel =
        Provider.of<CommonWithdrawViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    viewmodel.getCryptoCurrency(widget.currencyType);

    getcurrencyviewmodel =
        Provider.of<GetCurrencyViewModel>(context, listen: false); //2

    // viewmodel.getSpotBalanceSocket(constant.walletCurrency.value);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    resumeSocket();
    super.dispose();
  }

  resumeSocket() {
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    SiteMaintenanceViewModel siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(
            NavigationService.navigatorKey.currentContext!,
            listen: false);
    exchangeViewModel.initSocket = true;
    exchangeViewModel.fetchData();
    siteMaintenanceViewModel.getSiteMaintenanceStatus();
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = context.watch<CoinDetailsViewModel>();
    commonWithdrawViewModel = context.watch<CommonWithdrawViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    selectedValue = '${widget.currencyCode}';
    totalBalance = "${widget.totalBalance}";
    availableBalance = "${widget.availableBalance}";
    inorderBalance = "${widget.inorderBalance}";
    currencyCode = "${widget.currencyCode}";
    mlmStakeBalance = "${widget.mlmStakeBalance}";
    return Provider<CoinDetailsViewModel>(
      create: (context) => viewmodel,
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
                    text: "${constant.walletCurrency.value} Wallet",
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: viewmodel.needToLoad
            ? Center(child: CustomLoader())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    upperCard(context),
                    middleCard(context),
                    widget.currencyType == CurrencyType.CRYPTO.toString()
                        ? lowerCardCryptoTransactions(context)
                        : lowerCardFiatTransactions(context),
                    Container(
                      height: 100,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  upperCard(
    BuildContext context,
  ) {
    return CustomCard(
      radius: 25,
      edgeInsets: 15,
      outerPadding: 8,
      elevation: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: widget.currencyType == CurrencyType.CRYPTO.toString()
                    ? trimDecimalsForBalance(
                        '${viewmodel.inOrderBalance?.totalBalance ?? "0.0"}')
                    : '${viewmodel.inOrderBalance?.totalBalance?.toStringAsFixed(2) ?? "0.0"}',
                fontsize: 28,
                fontWeight: FontWeight.bold,
              ),
              GestureDetector(
                onTap: () {
                  dynamic state = _stateKey.currentState;
                  state.showButtonMenu();
                },
                child: AbsorbPointer(
                  child: CustomContainer(
                    width: 6,
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          fontfamily: 'InterTight',
                          fontsize: 15,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w800,
                          text: viewmodel.dropdownvalue ??
                              "${widget.currencyCode}",
                          color: textGrey,
                        ),
                        CustomContainer(
                          width: 25,
                          height: 25,
                          child: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            key: _stateKey,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            offset: Offset(
                                (MediaQuery.of(context).size.width / 15), 0),
                            constraints: BoxConstraints(
                              minWidth:
                                  (MediaQuery.of(context).size.width / 2.75),
                              maxWidth:
                                  (MediaQuery.of(context).size.width / 2.75),
                              minHeight:
                                  (MediaQuery.of(context).size.height / 12),
                              maxHeight:
                                  (MediaQuery.of(context).size.height / 3.75),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: textGrey,
                            ),
                            onSelected: (newValue) {
                              setState(() {
                                viewmodel.dropdownvalue = newValue.toString();
                                viewmodel.setDropdownvalue(newValue.toString());
                                constant.walletCurrency.value =
                                    newValue.toString();
                                viewmodel.setNetwork(newValue!.toString());
                                (widget.currencyType ==
                                        CurrencyType.CRYPTO.toString())
                                    ? getCurrency(
                                        constant.walletCurrency.value,
                                      )
                                    : getFiatCurrency(
                                        constant.walletCurrency.value,
                                      );
                                currencyCode = selectedValue;
                              });
                            },
                            color: checkBrightness.value == Brightness.dark
                                ? black
                                : white,
                            itemBuilder: (
                              BuildContext context,
                            ) {
                              return (widget.currencyType ==
                                          CurrencyType.CRYPTO.toString()
                                      ? viewmodel.getCoins ?? []
                                      : viewmodel.fiat)
                                  .map<PopupMenuItem<String>>((String? value) {
                                return PopupMenuItem(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          align: TextAlign.center,
                                          fontfamily: 'InterTight',
                                          fontsize: 15,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500,
                                          text: value.toString(),
                                        ),
                                      ],
                                    ),
                                    value: value);
                              }).toList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomText(
            text: stringVariables.totalBalance,
            fontsize: 18,
            fontWeight: FontWeight.bold,
            color: textGrey,
          ),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  middleCard(
    BuildContext context,
  ) {
    return CustomCard(
      radius: 25,
      edgeInsets: 15,
      outerPadding: 8,
      elevation: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: CustomText(
                  text: stringVariables.balance,
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          CustomCard(
            radius: 25,
            edgeInsets: 18,
            color: themeSupport().isSelectedDarkMode() ? black : grey,
            outerPadding: 4,
            elevation: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                        overflow: TextOverflow.ellipsis,
                        softwrap: true,
                        text: stringVariables.totalBalance,
                        color: hintLight,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.bold,
                        fontsize: 15),
                    Row(
                      children: [
                        CustomText(
                          align: TextAlign.end,
                          fontfamily: 'InterTight',
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          text: widget.currencyType ==
                                  CurrencyType.CRYPTO.toString()
                              ? trimDecimalsForBalance(
                                  '${viewmodel.inOrderBalance?.totalBalance ?? "0.0"}')
                              : '${viewmodel.inOrderBalance?.totalBalance?.toStringAsFixed(2)}',
                          fontsize: isSmallScreen(context) ? 12 : 17,
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          align: TextAlign.end,
                          softwrap: true,
                          maxlines: 1,
                          fontfamily: 'InterTight',
                          overflow: TextOverflow.ellipsis,
                          text: ' ${constant.walletCurrency.value}',
                          fontWeight: FontWeight.bold,
                          fontsize: isSmallScreen(context) ? 12 : 15,
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
                    CustomContainer(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 3.25),
                      child: CustomText(
                          softwrap: true,
                          text: stringVariables.availableBalance,
                          color: hintLight,
                          fontfamily: 'InterTight',
                          fontWeight: FontWeight.w600,
                          fontsize: 15),
                    ),
                    Row(
                      children: [
                        CustomText(
                          align: TextAlign.end,
                          fontfamily: 'InterTight',
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          text: widget.currencyType ==
                                  CurrencyType.CRYPTO.toString()
                              ? trimDecimalsForBalance(
                                  '${viewmodel.inOrderBalance?.availableBalance ?? "0.0"}')
                              : '${viewmodel.inOrderBalance?.availableBalance?.toStringAsFixed(2)}',
                          fontsize: isSmallScreen(context) ? 12 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          align: TextAlign.end,
                          softwrap: true,
                          maxlines: 1,
                          fontfamily: 'InterTight',
                          overflow: TextOverflow.ellipsis,
                          text: ' ${constant.walletCurrency.value}',
                          fontWeight: FontWeight.bold,
                          fontsize: isSmallScreen(context) ? 12 : 17,
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
                        text: stringVariables.locked,
                        color: hintLight,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.bold,
                        fontsize: 15),
                    Row(
                      children: [
                        CustomText(
                          align: TextAlign.end,
                          fontfamily: 'InterTight',
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          text: widget.currencyType ==
                                  CurrencyType.CRYPTO.toString()
                              ? trimDecimalsForBalance(
                                  '${viewmodel.inOrderBalance?.inorderBalance ?? "0.0"}')
                              : '${viewmodel.inOrderBalance?.inorderBalance?.toStringAsFixed(2)}',
                          fontsize: isSmallScreen(context) ? 12 : 17,
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          align: TextAlign.end,
                          softwrap: true,
                          maxlines: 1,
                          fontfamily: 'InterTight',
                          overflow: TextOverflow.ellipsis,
                          text: ' ${constant.walletCurrency.value}',
                          fontWeight: FontWeight.bold,
                          fontsize: isSmallScreen(context) ? 12 : 15,
                        ),
                      ],
                    )
                  ],
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 60,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     CustomContainer(
                //       constraints: BoxConstraints(
                //           maxWidth: MediaQuery.of(context).size.width / 3.25),
                //       child: CustomText(
                //           softwrap: true,
                //           text: stringVariables.mlmBalance,
                //           color: hintLight,
                //           fontfamily: 'InterTight',
                //           fontWeight: FontWeight.w600,
                //           fontsize: 15),
                //     ),
                //     Row(
                //       children: [
                //         CustomText(
                //           align: TextAlign.end,
                //           fontfamily: 'InterTight',
                //           softwrap: true,
                //           overflow: TextOverflow.ellipsis,
                //           text: widget.mlmStakeBalance.toString(),
                //           fontsize: isSmallScreen(context) ? 12 : 17,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         CustomText(
                //           align: TextAlign.end,
                //           softwrap: true,
                //           maxlines: 1,
                //           fontfamily: 'InterTight',
                //           overflow: TextOverflow.ellipsis,
                //           text: ' ${constant.walletCurrency.value}',
                //           fontWeight: FontWeight.bold,
                //           fontsize: isSmallScreen(context) ? 12 : 15,
                //         ),
                //       ],
                //     )
                //   ],
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                  buttoncolor: grey,
                  color: black,
                  press: () async {
                    await getcurrencyviewmodel
                        .getCurrencyForCryptoWithdraw(widget.currencyType);
                    print(constant.walletCurrency.value);

                    print(getcurrencyviewmodel.networkDropDown.length);
                    if (widget.currencyType == CurrencyType.CRYPTO.toString()) {
                      if (getcurrencyviewmodel.networkDropDown != null) {
                        if (getcurrencyviewmodel.networkDropDown.length > 1) {
                          moveToCryptoDepositView(
                            context,
                            widget.currencyType,
                          );
                          showNetworkModel();
                        } else {
                          moveToCryptoDepositView(
                            context,
                            widget.currencyType,
                          );
                        }
                      }
                    } else {
                      moveToFiatDeposit(context);
                    }
                  },
                  width: 2.6,
                  isBorderedButton: true,
                  maxLines: 1,
                  icon: withdrawIcon,
                  text: stringVariables.deposit,
                  radius: 25,
                  height: MediaQuery.of(context).size.height / 45,
                  icons: true,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                  multiClick: true,
                ),
                CustomElevatedButton(
                    buttoncolor: themeColor,
                    color: themeSupport().isSelectedDarkMode() ? black : white,
                    press: () {
                      securedPrint("wallet${constant.walletCurrency.value}");
                      commonWithdrawViewModel.setRadioValue(SelectWallet.spot,
                          trimDecimalsForBalance(availableBalance.toString()));
                      moveToCommonWithdrawView(
                          context,
                          widget.currencyType,
                          '${constant.walletCurrency.value}',
                          widget.currencyType == CurrencyType.CRYPTO.toString()
                              ? trimDecimalsForBalance(
                                  '${viewmodel.inOrderBalance?.availableBalance ?? "0.0"}')
                              : '${viewmodel.inOrderBalance?.availableBalance?.toStringAsFixed(2)}');
                    },
                    width: 2.6,
                    isBorderedButton: true,
                    maxLines: 1,
                    icon: depositIcon,
                    iconColor:
                        themeSupport().isSelectedDarkMode() ? black : white,
                    multiClick: true,
                    text: stringVariables.withdraw,
                    radius: 25,
                    height: MediaQuery.of(context).size.height / 45,
                    icons: true,
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: Offset(0, 0)),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Crypto Trasactions
  lowerCardCryptoTransactions(
    BuildContext context,
  ) {
    List<CryptoWithdrawHistoryDetails>? filteredCryptoTransaction = viewmodel
        .cryptoTransaction
        ?.where((m) => m.currencyCode == constant.walletCurrency.value)
        .toList();
    int transactionLength = filteredCryptoTransaction?.length ?? 0;
    return CustomCard(
      radius: 35,
      edgeInsets: 15,
      outerPadding: 8,
      elevation: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: stringVariables.transactions,
                fontWeight: FontWeight.bold,
                fontfamily: 'InterTight',
                fontsize: 18,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          filteredCryptoTransaction?.length == null
              ? Center(
                  child: Column(
                    children: [
                      CustomSizedBox(
                        height: 0.04,
                      ),
                      CustomText(
                        text: stringVariables.noTransactions,
                        fontsize: 18,
                      ),
                      CustomSizedBox(
                        height: 0.06,
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: transactionLength < viewmodel.Counter
                            ? transactionLength
                            : viewmodel.Counter,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              moveToTransactionDetailView(
                                context,
                                '${filteredCryptoTransaction?[index].amount_mob ?? filteredCryptoTransaction?[index].amount}',
                                '${filteredCryptoTransaction?[index].modifiedDate}',
                                '${filteredCryptoTransaction?[index].status}',
                                '${filteredCryptoTransaction?[index].transactionId}',
                                '${filteredCryptoTransaction?[index].currencyCode}',
                                '${filteredCryptoTransaction?[index].address}',
                                '${filteredCryptoTransaction?[index].userAmount ?? filteredCryptoTransaction?[index].amount}',
                                '${filteredCryptoTransaction?[index].type}',
                                '${filteredCryptoTransaction?[index].modifiedDate}',
                                '${filteredCryptoTransaction?[index].createdDate}',
                                '${filteredCryptoTransaction?[index].address}',
                                '${filteredCryptoTransaction?[index].fromAddress}',
                                '${filteredCryptoTransaction?[index].toAddress}',
                                '${filteredCryptoTransaction?[index].sentAmount}',
                                '${filteredCryptoTransaction?[index].receivedAmount}',
                                '${filteredCryptoTransaction?[index].createdDate}',
                                '${filteredCryptoTransaction?[index].adminFee}',
                              );
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      checkBrightness.value ==
                                                              Brightness.dark
                                                          ? black
                                                          : white,
                                                  child: Image.asset(
                                                    '${filteredCryptoTransaction?[index].type}'
                                                            .contains(
                                                                'crypto_Withdraw')
                                                        ? sendTransfer
                                                        : receiveTransfer,
                                                    height: 20,
                                                    color:
                                                        checkBrightness.value ==
                                                                Brightness.dark
                                                            ? white
                                                            : black,
                                                  )),
                                              CustomSizedBox(width: 0.02),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: '${filteredCryptoTransaction?[index].type}'
                                                            .contains(
                                                                "crypto_Withdraw")
                                                        ? stringVariables
                                                            .withdraw
                                                        : stringVariables
                                                            .deposit,
                                                    fontsize: 13,
                                                    fontfamily: 'InterTight',
                                                  ),
                                                  CustomSizedBox(
                                                    height: 0.005,
                                                  ),
                                                  //CustomText(text:'${filteredCryptoTransaction?[index].createdDate}${DateTime.now().timeZoneOffset}).'),

                                                  CustomText(
                                                    text: convertToIST(
                                                        '${filteredCryptoTransaction?[index].createdDate}'),
                                                    fontsize: 13,
                                                    fontfamily: 'InterTight',
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text:
                                                '${filteredCryptoTransaction?[index].amount_mob ?? filteredCryptoTransaction?[index].amount}',
                                            fontfamily: 'InterTight',
                                            color: green,
                                          ),
                                          CustomSizedBox(
                                            height: 0.005,
                                          ),
                                          CustomText(
                                            text:
                                                '${filteredCryptoTransaction?[index].status}',
                                            fontfamily: 'InterTight',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                CustomSizedBox(
                                  height: 0.01,
                                ),
                                Divider(
                                  color: divider,
                                  thickness: 0.2,
                                ),
                              ],
                            ),
                          );
                        }),
                    transactionLength != 0
                        ? viewmodel.openReadMoreFlag
                            ? Column(
                                children: [
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  CustomText(
                                    press: () {
                                      var add = (transactionLength -
                                                  viewmodel.Counter) >=
                                              5
                                          ? 5
                                          : (transactionLength -
                                              viewmodel.Counter);
                                      viewmodel.setOpenCounter(
                                          viewmodel.Counter + add);
                                      if (viewmodel.Counter >=
                                          transactionLength) {
                                        viewmodel.setOpenReadMoreFlag(false);
                                      }
                                    },
                                    align: TextAlign.center,
                                    text: transactionLength > 5
                                        ? stringVariables.readMore
                                        : "",
                                    color: textGrey,
                                    softwrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                ],
                              )
                            : CustomSizedBox(
                                height: 0.01,
                              )
                        : Column(
                            children: [
                              CustomText(
                                text: stringVariables.noTransactions,
                                fontsize: 18,
                              ),
                              // CustomSizedBox(
                              //   height: 0.04,
                              // )
                            ],
                          ),
                  ],
                ),
        ],
      ),
    );
  }

  /// Fiat Trasactions
  lowerCardFiatTransactions(
    BuildContext context,
  ) {
    List<FiatWithdrawHistoryDetails>? filteredFiatTransaction = viewmodel
        .fiatTransaction
        ?.where((m) => m.currencyCode == constant.walletCurrency.value)
        .toList();
    int transactionFiatLength = filteredFiatTransaction!.length ?? 0;
    return CustomCard(
      radius: 35,
      edgeInsets: 15,
      outerPadding: 8,
      elevation: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: stringVariables.transactions,
                fontWeight: FontWeight.bold,
                fontfamily: 'InterTight',
                fontsize: 18,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          filteredFiatTransaction.length == null
              ? Center(
                  child: Column(
                    children: [
                      CustomSizedBox(
                        height: 0.04,
                      ),
                      CustomText(
                        text: stringVariables.noTransactions,
                        fontsize: 18,
                      ),
                      CustomSizedBox(
                        height: 0.06,
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: transactionFiatLength < viewmodel.Counter
                            ? transactionFiatLength
                            : viewmodel.Counter,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              moveToTransactionDetailView(
                                context,
                                '${filteredFiatTransaction[index].amount_mob}',
                                '${filteredFiatTransaction[index].modifiedDate}',
                                '${filteredFiatTransaction[index].status}',
                                '${filteredFiatTransaction[index].transactionId}',
                                '${filteredFiatTransaction[index].currencyCode}',
                                '${filteredFiatTransaction[index].payMode}',
                                '${filteredFiatTransaction[index].typename}',
                                '${filteredFiatTransaction[index].type}',
                                '${filteredFiatTransaction[index].adminFee}',
                                '${filteredFiatTransaction[index].receivedAmount}',
                                '${filteredFiatTransaction[index].sentAmount}',
                                '${filteredFiatTransaction[index].amount_mob}',
                                '${filteredFiatTransaction[index].payMode}',
                                '${filteredFiatTransaction[index].payMode}',
                                '${filteredFiatTransaction[index].payMode}',
                                '${filteredFiatTransaction[index].payMode}',
                                '${filteredFiatTransaction[index].payMode}',
                              );
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      checkBrightness.value ==
                                                              Brightness.dark
                                                          ? black
                                                          : white,
                                                  child: Image.asset(
                                                    '${filteredFiatTransaction[index].type}'
                                                            .contains(
                                                                "fiat_Withdraw")
                                                        ? sendTransfer
                                                        : receiveTransfer,
                                                    height: 20,
                                                    color:
                                                        checkBrightness.value ==
                                                                Brightness.dark
                                                            ? white
                                                            : black,
                                                  )),
                                              CustomSizedBox(
                                                width: 0.02,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: '${filteredFiatTransaction[index].type}'
                                                            .contains(
                                                                "fiat_Withdraw")
                                                        ? stringVariables
                                                            .withdraw
                                                        : stringVariables
                                                            .deposit,
                                                    fontsize: 16,
                                                    fontfamily: 'InterTight',
                                                  ),
                                                  CustomSizedBox(
                                                    height: 0.005,
                                                  ),
                                                  CustomText(
                                                    text: getDate(
                                                        '${filteredFiatTransaction[index].modifiedDate}'),
                                                    fontsize: 13,
                                                    fontfamily: 'InterTight',
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text:
                                                '${filteredFiatTransaction[index].amount_mob}',
                                            fontfamily: 'InterTight',
                                            color: green,
                                          ),
                                          CustomSizedBox(
                                            height: 0.005,
                                          ),
                                          CustomText(
                                            text:
                                                '${filteredFiatTransaction[index].status}',
                                            fontfamily: 'InterTight',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                CustomSizedBox(
                                  height: 0.01,
                                ),
                                Divider(
                                  color: divider,
                                  thickness: 0.2,
                                ),
                              ],
                            ),
                          );
                        }),
                    transactionFiatLength != 0
                        ? viewmodel.openReadMoreFlag
                            ? Column(
                                children: [
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  CustomText(
                                    press: () {
                                      var add = (transactionFiatLength -
                                                  viewmodel.Counter) >=
                                              5
                                          ? 5
                                          : (transactionFiatLength -
                                              viewmodel.Counter);
                                      viewmodel.setOpenCounter(
                                          viewmodel.Counter + add);
                                      if (viewmodel.Counter >=
                                          transactionFiatLength) {
                                        viewmodel.setOpenReadMoreFlag(false);
                                      }
                                    },
                                    align: TextAlign.center,
                                    text: transactionFiatLength > 5
                                        ? stringVariables.readMore
                                        : "",
                                    color: textGrey,
                                    softwrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                ],
                              )
                            : CustomSizedBox(
                                height: 0.01,
                              )
                        : Column(
                            children: [
                              CustomText(
                                text: stringVariables.noTransactions,
                                fontsize: 18,
                              ),
                              // CustomSizedBox(
                              //   height: 0.04,
                              // )
                            ],
                          ),
                  ],
                ),
        ],
      ),
    );
  }

  displayDialog(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return buildDepositCrypto(context);
        });
  }

  buildDepositCrypto(
    BuildContext context,
  ) {
    Image image =
        context.watch<CoinDetailsViewModel>()?.findAddress?.qrCode != null
            ? Image.memory(base64.decode(
                '${context.watch<CoinDetailsViewModel>()?.findAddress?.qrCode}'
                    .split(',')
                    .last))
            : Image.asset(
                splash,
              );
    return AlertDialog(
      insetPadding: EdgeInsets.only(bottom: 120, top: 70, left: 15, right: 15),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      CoinDetailsViewModel viewmodel =
                          Provider.of<CoinDetailsViewModel>(context,
                              listen: false);
                      viewmodel.getCryptoCurrency(widget.currencyType);
                    },
                    child: SvgPicture.asset(
                      cancel,
                      height: 18,
                    ))
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    text: stringVariables.deposit,
                    fontsize: 25,
                    fontWeight: FontWeight.bold,
                    fontfamily: 'InterTight'),
                CustomText(
                    text: '  ${constant.walletCurrency.value}',
                    fontsize: 23,
                    fontWeight: FontWeight.bold,
                    fontfamily: 'InterTight')
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: stringVariables.scanningQr,
                  fontfamily: 'InterTight',
                  color: textGrey,
                  fontsize: 13,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomContainer(
              width: 1,
              height: 4,
              child: FadeInImage(
                fit: BoxFit.fitHeight,
                placeholder: AssetImage(splash),
                image: image.image,
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: stringVariables.useThisAddress,
                  fontfamily: 'InterTight',
                  color: textGrey,
                  fontsize: 13,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomContainer(
              width: 1,
              height: MediaQuery.of(context).size.height / 50,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 0.5),
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
                    Container(
                      width: 200,
                      child: CustomText(
                        align: TextAlign.start,
                        fontfamily: 'InterTight',
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        text:
                            '${context.watch<CoinDetailsViewModel>().findAddress?.address ?? stringVariables.loading}',
                        fontsize: 13,
                      ),
                    ),
                    CustomIconButton(
                      onPress: () {
                        Clipboard.setData(ClipboardData(
                                text:
                                    '${Provider.of<CoinDetailsViewModel>(context, listen: false).findAddress?.address ?? stringVariables.loading}'))
                            .then((_) {
                          customSnackBar.showSnakbar(
                              context,
                              stringVariables.addressCopied,
                              SnackbarType.positive);
                        });
                      },
                      child: SvgPicture.asset(
                        copy,
                      ),
                    )
                  ],
                ),
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: stringVariables.important.toUpperCase(),
                  fontfamily: 'InterTight',
                  fontsize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text:
                      "${stringVariables.deposit} ${constant.walletCurrency.value} ${stringVariables.addressOnly}",
                  fontfamily: 'InterTight',
                  color: textGrey,
                  fontsize: 13,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  getCurrency(
    String value,
  ) {
    viewmodel.getInOrderBalance(value);
  }

  getFiatCurrency(
    String value,
  ) {
    viewmodel.getFiatInOrderBalance(value);
  }

  showNetworkModel() async {
    final result =
        await Navigator.of(context).push(SelectWalletBottomSheet(context, 1));
  }
}
