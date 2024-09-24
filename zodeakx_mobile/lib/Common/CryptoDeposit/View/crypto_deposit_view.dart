import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/CryptoDeposit/View/selectWalletBottomSheet.dart';
import 'package:zodeakx_mobile/Common/CryptoDeposit/View/selectWalletModal.dart';
import 'package:zodeakx_mobile/Common/Wallets/CoinDetailsViewModel/GetcurrencyViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../Wallets/CoinDetailsViewModel/CoinDetailsViewModel.dart';
import '../ViewModel/crypto_deposit_view_model.dart';

class CryptoDepositView extends StatefulWidget {
  String? currencyType;
  CryptoDepositView({super.key, this.currencyType});

  @override
  State<CryptoDepositView> createState() => _CryptoDepositViewState();
}

class _CryptoDepositViewState extends State<CryptoDepositView> {
  late CryptoDepositViewModel viewModel;
  late CoinDetailsViewModel coinDetailsViewModel;
  late GetCurrencyViewModel getCurrencyViewModel;
  late MarketViewModel marketViewModel;

  @override
  void initState() {
    // TODO: implement initState
    viewModel = Provider.of<CryptoDepositViewModel>(context, listen: false);
    getCurrencyViewModel =
        Provider.of<GetCurrencyViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    coinDetailsViewModel =
        Provider.of<CoinDetailsViewModel>(context, listen: false);
    //   getCurrencyViewModel.getCurrencyForCryptoWithdraw(widget.currencyType);
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    getCurrencyViewModel.networkDropDown.clear();
    super.dispose();
  }

  Widget build(BuildContext context) {
    viewModel = context.watch<CryptoDepositViewModel>();
    marketViewModel = context.watch<MarketViewModel>();

    coinDetailsViewModel = context.watch<CoinDetailsViewModel>();
    getCurrencyViewModel = context.watch<GetCurrencyViewModel>();
    return Provider<CryptoDepositViewModel>(
        create: (context) => viewModel,
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
                        fontfamily: 'InterTight',
                        fontsize: 23,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        text:
                            '${stringVariables.deposit}  ${constant.walletCurrency.value}',
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: SingleChildScrollView(
                child: CustomCard(
                    radius: 25,
                    edgeInsets: 15,
                    outerPadding: 20,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        qrCode(),
                        CustomSizedBox(
                          height: 0.03,
                        ),
                        network()
                      ],
                    )))));
  }

  Widget network() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: stringVariables.network,
          color: stackCardText,
          fontsize: 16,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: getCurrencyViewModel.network.toString(),
              fontsize: 14,
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (getCurrencyViewModel.networkDropDown.length > 1) {
                    showNetworkModel();
                  }
                },
                child: SvgPicture.asset(
                  exchangeMargin,
                  color: stackCardText,
                  height: 15,
                ))
          ],
        ),
        getCurrencyViewModel.network != "XRP"
            ? CustomSizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomText(
                    text: stringVariables.tagID,
                    color: stackCardText,
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomSizedBox(
                    height: 0.015,
                  ),
                  CustomText(
                    text: context
                            .watch<CoinDetailsViewModel>()
                            .findAddress
                            ?.tagId ??
                        stringVariables.loading,
                    fontsize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                ],
              ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: stringVariables.walletAddress,
          color: stackCardText,
          fontsize: 16,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.001,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
                width: 1.6,
                child: CustomText(
                  text: context
                          .watch<CoinDetailsViewModel>()
                          .findAddress
                          ?.address ??
                      stringVariables.loading,
                  fontsize: 13.5,
                  fontWeight: FontWeight.w500,
                )),
            CustomIconButton(
              onPress: () {
                Clipboard.setData(ClipboardData(
                  text:
                      Provider.of<CoinDetailsViewModel>(context, listen: false)
                              .findAddress
                              ?.address ??
                          stringVariables.loading,
                )).then((_) {
                  customSnackBar.showSnakbar(context,
                      stringVariables.addressCopied, SnackbarType.positive);
                });
              },
              child: SvgPicture.asset(
                copy,
              ),
            )
          ],
        ),
        CustomSizedBox(
          height: 0.025,
        ),
        Row(
          children: [
            CustomText(
              text: stringVariables.selectWallet,
              color: stackCardText,
              fontsize: 16,
              fontWeight: FontWeight.w500,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            GestureDetector(
                onTap: () {
                  _showModal();
                },
                child: Icon(
                  Icons.info,
                  color: textGrey,
                  size: 18,
                ))
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: viewModel.wallet,
          fontsize: 14,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }

  _showModal() async {
    final result = await Navigator.of(context).push(SelectWalletModal(context));
  }

  Widget qrCode() {
    Image image =
        context.watch<CoinDetailsViewModel>().findAddress?.qrCode != null
            ? Image.memory(base64.decode(
                '${context.watch<CoinDetailsViewModel>().findAddress?.qrCode}'
                    .split(',')
                    .last))
            : Image.asset(
                splash,
              );
    return Column(
      children: [
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
          height: 0.03,
        ),
        CustomText(
          text: '${stringVariables.sendOnly} ${constant.walletCurrency.value}'
              ' ${stringVariables.toDepositAddress}',
          color: stackCardText,
          fontsize: 13,
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        )
      ],
    );
  }

  // getNetworkOfItem(String item) {
  //   String network = "";
  //   List list = (marketViewModel.getCurrencies?.where((element) => element.currencyCode == item).toList() ?? []);
  //   if (list.isNotEmpty) network = list.first.network ?? "";
  //   return network;
  //
  // }

  showNetworkModel() async {
    final result =
        await Navigator.of(context).push(SelectWalletBottomSheet(context, 1));
  }
}
