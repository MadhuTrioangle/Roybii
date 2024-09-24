import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Common/Exchange/ViewModel/ExchangeViewModel.dart';
import '../../../Common/Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../../../Common/Wallets/CommonWithdraw/ViewModel/CommonWithdrawViewModel.dart';
import '../../../Common/Wallets/TransactionDetails/Model/CryptoWithdrawHistoryModel.dart';
import '../../../Common/Wallets/TransactionDetails/Model/FiatWithdrawHistory.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../funding_coin_details/model/funding_wallet_balance.dart';
import '../view_model/funding_wallet_view_model.dart';

class FundingWalletView extends StatefulWidget {
  final GetUserFundingWalletDetails item;
  FundingWalletView(
      {Key? key, required this.item,
      })
      : super(key: key);

  @override
  State<FundingWalletView> createState() => _FundingWalletViewState();
}

class _FundingWalletViewState extends State<FundingWalletView> {
  var selectedValue;
  String? dropdownvalue;
  int id = 1;

  late CoinDetailsViewModel viewmodel;
  late MarketViewModel marketViewModel;
  late FundingWalletViewModel fundingWalletViewModel;
  late CommonWithdrawViewModel commonWithdrawViewModel;
  late WalletViewModel getTotalBalance;
  final GlobalKey _stateKey = GlobalKey();
  late GetUserFundingWalletDetails items;


  @override
  void initState() {
    viewmodel = Provider.of<CoinDetailsViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    fundingWalletViewModel = Provider.of<FundingWalletViewModel>(context, listen: false);
    commonWithdrawViewModel = Provider.of<CommonWithdrawViewModel>(context, listen: false);
    getTotalBalance = Provider.of<WalletViewModel>(context, listen: false);
    constant.walletCurrency.value = widget.item.currencyCode.toString();
    fundingWalletViewModel. getCryptoCurrency();
    items = widget.item;
    viewmodel.getCryptoWithdrawHistoryDetails();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    resumeSocket();
  //  marketViewModel.leaveSocket();
    super.dispose();
  }

  resumeSocket() {
    ExchangeViewModel exchangeViewModel = Provider.of<ExchangeViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    exchangeViewModel.initSocket = true;
    exchangeViewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    viewmodel = context.watch<CoinDetailsViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    getTotalBalance = context.watch<WalletViewModel>();
    fundingWalletViewModel = context.watch<FundingWalletViewModel>();
    commonWithdrawViewModel = context.watch<CommonWithdrawViewModel>();
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
                    fontfamily: 'GoogleSans',
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
        child:
        // viewmodel.needToLoad
        //     ? Center(child: CustomLoader())
        //     :
        SingleChildScrollView(
          child: Column(
            children: [
             fundingUpperCard(context),
              fundingMiddleCard(context),
              items.currencyType == "crypto"
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

  fundingUpperCard(
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
                text: items.currencyType == "crypto"
                    ? trimDecimalsForBalance(
                    items.totalAmount.toString())
                    : trimAs2( items.totalAmount.toString() ),
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
                          fontfamily: 'GoogleSans',
                          fontsize: 15,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w800,
                          text: dropdownvalue ?? items.currencyCode.toString(),
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
                            constraints:  BoxConstraints(
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
                                List<GetUserFundingWalletDetails> list =
                                    getTotalBalance.userFundingWalletDetails ??
                                        [];
                                list = list
                                    .where((element) =>
                                element.currencyCode == newValue.toString())
                                    .toList();
                                dropdownvalue = newValue.toString();
                                constant.walletCurrency.value = newValue.toString();
                                viewmodel.setNetwork(newValue!.toString());
                                if (list.isNotEmpty) {
                                  items = list.first;
                                } else {
                                  items = getTotalBalance
                                      .userFundingWalletDetails?.first ??
                                      GetUserFundingWalletDetails( amount: 0,
                                          inorder: 0,
                                          currencyCode: "",
                                          convertedAmount: 0,
                                          convertedCurrencyCode: "",
                                          currencyLogo: "",currencyType:"");
                                }
                               ( items.currencyType == CurrencyType.CRYPTO.toString() ||
                                   items.currencyType == "crypto")
                                    ? getCurrency(
                                  constant.walletCurrency.value,
                                )
                                    : getFiatCurrency(
                                  constant.walletCurrency.value,
                                );
                               // currencyCode = selectedValue;
                              });
                            },
                            color: checkBrightness.value == Brightness.dark
                                ? black
                                : white,
                            itemBuilder: (
                                BuildContext context,
                                ) {
                              return fundingWalletViewModel.getAllCoins
                                  .map<PopupMenuItem<String>>((String? value) {
                                return PopupMenuItem(
                                    onTap: () {},
                                    value: value,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          align: TextAlign.center,
                                          fontfamily: 'GoogleSans',
                                          fontsize: 15,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500,
                                          text: value.toString(),
                                        ),
                                      ],
                                    ));
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



  fundingMiddleCard(
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
                          text: items.currencyType ==
                              "crypto"
                              ? trimDecimalsForBalance(
                              items.totalAmount.toString())
                              : trimAs2(items.totalAmount.toString()),
                          fontsize: isSmallScreen(context) ? 12 : 17,
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          align: TextAlign.end,
                          softwrap: true,
                          maxlines: 1,
                          fontfamily: 'GoogleSans',
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
                          fontfamily: 'GoogleSans',
                          fontWeight: FontWeight.w600,
                          fontsize: 15),
                    ),
                    Row(
                      children: [
                        CustomText(
                          align: TextAlign.end,
                          fontfamily: 'GoogleSans',
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          text: items.currencyType ==
                              "crypto"
                              ? trimDecimalsForBalance(
                              items.amount.toString())
                              : trimAs2(items.amount.toString()),
                          fontsize: isSmallScreen(context) ? 12 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          align: TextAlign.end,
                          softwrap: true,
                          maxlines: 1,
                          fontfamily: 'GoogleSans',
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
                          text: items.currencyType ==
                              "crypto"
                              ? trimDecimalsForBalance(
                              items.inorder.toString())
                              : trimAs2(items.inorder.toString()),
                          fontsize: isSmallScreen(context) ? 12 : 17,
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          align: TextAlign.end,
                          softwrap: true,
                          maxlines: 1,
                          fontfamily: 'GoogleSans',
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
                //           fontfamily: 'GoogleSans',
                //           fontWeight: FontWeight.w600,
                //           fontsize: 15),
                //     ),
                //     Row(
                //       children: [
                //         CustomText(
                //           align: TextAlign.end,
                //           fontfamily: 'GoogleSans',
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
                //           fontfamily: 'GoogleSans',
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
                  press: () {
                    items.currencyType == "crypto"
                        ? moveToCryptoDepositView(
                      context,CurrencyType.CRYPTO.toString()
                    )
                        : moveToFiatDeposit(context);
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
                      commonWithdrawViewModel.setRadioValue(SelectWallet.funding,items.amount.toString());
                      moveToCommonWithdrawView(context, items.currencyType,
                          constant.walletCurrency.value,items.amount.toString());
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
      radius: 25,
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
                fontfamily: 'GoogleSans',
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
                  text: "No Transactions",
                  fontsize: 18,
                ),
                CustomSizedBox(
                  height: 0.06,
                ),
              ],
            ),
          )
              : Column(
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
                          '${filteredCryptoTransaction?[index].userAmount?? filteredCryptoTransaction?[index].amount}',
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
                            padding: const EdgeInsets.only(top: 5.0,),
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
                                                  ? "Withdraw"
                                                  : "Deposit",
                                              fontsize: 13,
                                              fontfamily: 'GoogleSans',
                                            ),
                                            CustomSizedBox(
                                              height: 0.005,
                                            ),
                                            //CustomText(text:'${filteredCryptoTransaction?[index].createdDate}${DateTime.now().timeZoneOffset}).'),

                                            CustomText(
                                              text: convertToIST(
                                                  '${filteredCryptoTransaction?[index].createdDate}'),
                                              fontsize: 13,
                                              fontfamily: 'GoogleSans',
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
                                      '${filteredCryptoTransaction?[index].amount_mob  ?? filteredCryptoTransaction?[index].amount}',
                                      fontfamily: 'GoogleSans',
                                      color: green,
                                    ),
                                    CustomSizedBox(
                                      height: 0.005,
                                    ),
                                    CustomText(
                                      text:
                                      '${filteredCryptoTransaction?[index].status}',
                                      fontfamily: 'GoogleSans',
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomSizedBox(
                            height: 0.01,
                          ),
                          Divider(),
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
                    text: "No Transactions",
                    fontsize: 18,
                  ),
                  CustomSizedBox(
                    height: 0.04,
                  )
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
      radius: 25,
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
                fontfamily: 'GoogleSans',
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
                  text: "No Transactions",
                  fontsize: 18,
                ),
                CustomSizedBox(
                  height: 0.06,
                ),
              ],
            ),
          )
              : Column(
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
                            padding: const EdgeInsets.only(top: 5.0,),
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
                                                  ? "Withdraw"
                                                  : "Deposit",
                                              fontsize: 16,
                                              fontfamily: 'GoogleSans',
                                            ),
                                            CustomSizedBox(
                                              height: 0.005,
                                            ),
                                            CustomText(
                                              text: getDate(
                                                  '${filteredFiatTransaction[index].modifiedDate}'),
                                              fontsize: 13,
                                              fontfamily: 'GoogleSans',
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
                                      fontfamily: 'GoogleSans',
                                      color: green,
                                    ),
                                    CustomSizedBox(
                                      height: 0.005,
                                    ),
                                    CustomText(
                                      text:
                                      '${filteredFiatTransaction[index].status}',
                                      fontfamily: 'GoogleSans',
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomSizedBox(
                            height: 0.01,
                          ),
                          Divider(),
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
                    text: "No Transactions",
                    fontsize: 18,
                  ),
                  CustomSizedBox(
                    height: 0.04,
                  )
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
                          viewmodel.getCryptoCurrency(items.currencyType);
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
                        fontfamily: 'GoogleSans'),
                    CustomText(
                        text: '  ${constant.walletCurrency.value}',
                        fontsize: 23,
                        fontWeight: FontWeight.bold,
                        fontfamily: 'GoogleSans')
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
                      fontfamily: 'GoogleSans',
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
                      fontfamily: 'GoogleSans',
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
                            fontfamily: 'GoogleSans',
                            softwrap: true,
                            overflow: TextOverflow.ellipsis,
                            text:
                            '${context.watch<CoinDetailsViewModel>().findAddress?.address ?? "Loading..."}',
                            fontsize: 13,
                          ),
                        ),
                        CustomIconButton(
                          onPress: () {
                            Clipboard.setData(ClipboardData(
                                text:
                                '${Provider.of<CoinDetailsViewModel>(context, listen: false).findAddress?.address ?? "Loading..."}'))
                                .then((_) {
                              customSnackBar.showSnakbar(
                                  context, "Address Copied", SnackbarType.positive);
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
                      fontfamily: 'GoogleSans',
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
                      text: "Deposit ${constant.walletCurrency.value} Address only",
                      fontfamily: 'GoogleSans',
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
    viewmodel.getFindAddress(value,"");
  }

  getFiatCurrency(
      String value,
      ) {
    viewmodel.getFiatInOrderBalance(value);
  }
}
