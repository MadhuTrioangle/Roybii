import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../transfer_history/view/transfer_history_view.dart';
import '../../wallet_select/viewModel/wallet_select_view_model.dart';
import '../viewModel/transfer_view_model.dart';

class TransferView extends StatefulWidget {
  final String coin;

  const TransferView({Key? key, required this.coin}) : super(key: key);

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  late TransferViewModel viewModel;
  late MarketViewModel marketViewModel;
  late WalletViewModel walletViewModel;
  late WalletSelectViewModel walletSelectViewModel;
  late CoinDetailsViewModel coinDetailsViewModel;
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormFieldState> amountFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    viewModel = Provider.of<TransferViewModel>(context, listen: false);
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);

    walletSelectViewModel =
        Provider.of<WalletSelectViewModel>(context, listen: false);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      constant.walletCurrency.value = widget.coin;
      viewModel.updateBalance();
      viewModel.setCurrency(widget.coin);

      coinDetailsViewModel.getSpotBalanceSocket();
      walletViewModel.getFundingBalanceSocket();
      viewModel.setLoading(true);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // marketViewModel.leaveSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<TransferViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    walletSelectViewModel = context.watch<WalletSelectViewModel>();

    return Provider<TransferViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return transfer(
          context,
        );
      },
    );
  }

  Future<bool> pop() async {
    Navigator.pop(context);
    walletSelectViewModel.selectFirstWallet(stringVariables.spotWallet);
    walletSelectViewModel.selectSecondWallet(stringVariables.crossMargin);
    amountController.clear();
    return true;
  }

  Widget transfer(BuildContext context) {
    return WillPopScope(
      onWillPop: pop,
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
                      walletSelectViewModel
                          .selectFirstWallet(stringVariables.spotWallet);
                      walletSelectViewModel
                          .selectSecondWallet(stringVariables.crossMargin);
                      amountController.clear();
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
                    overflow: TextOverflow.ellipsis,
                    maxlines: 1,
                    softwrap: true,
                    fontfamily: 'InterTight',
                    fontsize: 21,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.transfer,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      moveToTransferHistoryView(context);
                      walletSelectViewModel
                          .selectFirstWallet(stringVariables.spotWallet);
                      walletSelectViewModel
                          .selectSecondWallet(stringVariables.crossMargin);
                      amountController.clear();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SvgPicture.asset(
                        history,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: transferCard(),
      ),
    );
  }

  Widget transferCard() {
    return CustomCard(
        radius: 15,
        outerPadding: 15,
        edgeInsets: 8,
        elevation: 0,
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(
                        child: Column(
                      children: [
                        CustomCard(
                          radius: 15,
                          outerPadding: 0,
                          edgeInsets: 8,
                          elevation: 0,
                          color: themeSupport().isSelectedDarkMode()
                              ? black
                              : grey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: upperCard(),
                          ),
                        ),
                        (walletSelectViewModel.firstWallet ==
                                    stringVariables.isolatedMargin &&
                                walletSelectViewModel.secondtWallet ==
                                    stringVariables.isolatedMargin)
                            ? middleCard()
                            : (walletSelectViewModel.firstWallet ==
                                    stringVariables.isolatedMargin)
                                ? twoMiddleCard()
                                : (walletSelectViewModel.secondtWallet ==
                                        stringVariables.isolatedMargin)
                                    ? twoMiddleCard()
                                    : middleCard(),
                        viewModel.availabeBalance == "0.00"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(
                                  text: stringVariables.transferHeader,
                                  color: pink,
                                  fontsize: 12,
                                ),
                              )
                            : CustomSizedBox(),
                        textField(),
                        CustomSizedBox(
                          height: isSmallScreen(context) ? 0.09 : 0.19,
                        ),
                        (walletSelectViewModel.firstWallet == stringVariables.spotWallet &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.spotWallet) ||
                                (walletSelectViewModel.firstWallet == stringVariables.crossMargin &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.crossMargin) ||
                                (walletSelectViewModel.firstWallet ==
                                        stringVariables.isolatedMargin &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.isolatedMargin) ||
                                (walletSelectViewModel.firstWallet == stringVariables.funding &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.crossMargin) ||
                                (walletSelectViewModel.firstWallet == stringVariables.crossMargin &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.funding) ||
                                (walletSelectViewModel.firstWallet ==
                                        stringVariables.isolatedMargin &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.funding) ||
                                (walletSelectViewModel.firstWallet == stringVariables.funding &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.isolatedMargin) ||
                                (walletSelectViewModel.firstWallet == stringVariables.funding &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.funding) ||
                                (walletSelectViewModel.firstWallet == stringVariables.usdsfutures &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.usdsfutures) ||
                                (walletSelectViewModel.firstWallet == stringVariables.coinFuture &&
                                    walletSelectViewModel.secondtWallet ==
                                        stringVariables.coinFuture)
                            ? CustomSizedBox()
                            : viewModel.buttonLoader
                                ? CustomLoader()
                                : CustomElevatedButton(
                                    text: stringVariables.confirm
                                            .toUpperCase() +
                                        " " +
                                        stringVariables.transfer.toUpperCase(),
                                    radius: 25,
                                    buttoncolor: themeColor,
                                    width: 1.2,
                                    blurRadius: 13,
                                    spreadRadius: 1,
                                    height:
                                        MediaQuery.of(context).size.height / 50,
                                    isBorderedButton: false,
                                    maxLines: 1,
                                    multiClick: true,
                                    icons: false,
                                    icon: null,
                                    color: themeSupport().isSelectedDarkMode()
                                        ? black
                                        : white,
                                    press: () {
                                      coinDetailsViewModel
                                          .getSpotBalanceSocket();
                                      if (walletSelectViewModel.firstWallet ==
                                              stringVariables.funding ||
                                          walletSelectViewModel.secondtWallet ==
                                              stringVariables.funding) {
                                        viewModel.userFundingWalletTransfer(
                                            amountController.text,
                                            walletSelectViewModel.firstWallet,
                                            walletSelectViewModel
                                                .secondtWallet);
                                      }
                                    },
                                  ),
                        CustomSizedBox(
                          height: 0.02,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom /
                                        1.5))
                      ],
                    ))),
              ));
  }

  Widget upperCard() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            moveToWalletSelectView(context, "First");
            amountController.clear();
          },
          child: Row(
            children: [
              viewModel.isSwap
                  ? SvgPicture.asset(ellipseRoundOutline)
                  : SvgPicture.asset(walletImage),
              CustomSizedBox(
                width: 0.05,
              ),
              CustomText(
                text: stringVariables.from,
                color: stackCardText,
              ),
              CustomSizedBox(
                width: 0.06,
              ),
              CustomContainer(
                width: 2.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: walletSelectViewModel.firstWallet,
                      fontsize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 10,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Column(
          children: [
            CustomSizedBox(
              height: 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_downward_sharp,
                  size: 20,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                GestureDetector(onTap: () {}, child: SvgPicture.asset(swap))
              ],
            ),
            CustomSizedBox(
              height: 0.03,
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            moveToWalletSelectView(context, "Second");

            amountController.clear();
          },
          child: Row(
            children: [
              viewModel.isSwap
                  ? SvgPicture.asset(walletImage)
                  : SvgPicture.asset(ellipseRoundOutline),
              CustomSizedBox(
                width: 0.05,
              ),
              CustomText(
                text: stringVariables.to + "     ",
                color: stackCardText,
              ),
              CustomSizedBox(
                width: 0.06,
              ),
              CustomContainer(
                width: 2.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: walletSelectViewModel.secondtWallet,
                      fontsize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 10,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget middleCard() {
    return GestureDetector(
      onTap: () {},
      child: CustomCard(
          radius: 15,
          outerPadding: 0,
          edgeInsets: 8,
          elevation: 0,
          color: themeSupport().isSelectedDarkMode() ? black : grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomCircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.transparent,
                      child: FadeInImage.assetNetwork(
                        image: splash,
                        placeholder: splash,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      text: "",
                      fontsize: 14,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )
              ],
            ),
          )),
    );
  }

  Widget textField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: stringVariables.amount,
            color: stackCardText,
            fontsize: 14,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomTextFormField(
            autovalid: AutovalidateMode.onUserInteraction,
            controller: amountController,
            isBorder: true,
            keys: amountFieldKey,
            padRight: 0,
            padLeft: 0,
            isContentPadding: false,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            color: themeSupport().isSelectedDarkMode() ? black : grey,
            suffixIcon: CustomContainer(
              width: 3.5,
              child: Row(
                children: [
                  CustomCircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    child: FadeInImage.assetNetwork(
                      image: getImage(marketViewModel, walletViewModel,
                          '${viewModel.currency}'),
                      placeholder: splash,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.01,
                  ),
                  CustomText(
                    text: viewModel.currency,
                    fontsize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomSizedBox(
                    width: 0.01,
                  ),
                  GestureDetector(
                    onTap: () {
                      amountController.text =
                          viewModel.availabeBalance.toString();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          fontfamily: 'InterTight',
                          text: stringVariables.max,
                          color: themeColor,
                          fontsize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            size: 0,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.available + ":",
                color: stackCardText,
                fontsize: 14,
              ),
              CustomText(
                text: viewModel.availabeBalance.toString() +
                    " " +
                    viewModel.currency,
                color: stackCardText,
                fontsize: 14,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget twoMiddleCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: CustomCard(
              radius: 15,
              outerPadding: 0,
              edgeInsets: 8,
              elevation: 0,
              color: themeSupport().isSelectedDarkMode() ? black : grey,
              child: CustomContainer(
                width: 2.9,
                height: 12,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.2,
                        color:
                            viewModel.click ? themeColor : Colors.transparent)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomCircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: FadeInImage.assetNetwork(
                              image: splash,
                              placeholder: splash,
                            ),
                          ),
                          CustomSizedBox(
                            width: 0.02,
                          ),
                          CustomText(
                            text: "",
                            fontsize: 14,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
        GestureDetector(
          onTap: () {},
          child: CustomCard(
              radius: 15,
              outerPadding: 0,
              edgeInsets: 8,
              elevation: 0,
              color: themeSupport().isSelectedDarkMode() ? black : grey,
              child: CustomContainer(
                width: 2.9,
                height: 12,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.2,
                        color:
                            viewModel.click ? Colors.transparent : themeColor)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomCircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: FadeInImage.assetNetwork(
                              image: splash,
                              placeholder: splash,
                            ),
                          ),
                          CustomSizedBox(
                            width: 0.02,
                          ),
                          CustomText(
                            text: "",
                            fontsize: 14,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }

  void moveToTransferHistoryView(BuildContext context) async {
    Navigator.push(
      context,
      CustomMaterialPageRoute(builder: (context) => TransferHistoryView()),
    );
  }
}
