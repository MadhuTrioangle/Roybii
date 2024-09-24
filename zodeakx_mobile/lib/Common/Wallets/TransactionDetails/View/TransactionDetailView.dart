import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../../Utils/Languages/English/StringVariables.dart';
import '../../../../Utils/Widgets/CustomContainer.dart';
import '../../../../Utils/Widgets/CustomScaffold.dart';
import '../../../../Utils/Widgets/CustomText.dart';

class TransactionDetailView extends StatefulWidget {
  String? amount;
  String? modifiedDate;
  String? status;
  String? transactionId;
  String? currencyCode;
  String? payMode;
  String? typename;
  String? type;
  String? adminFee;
  String? receivedAmount;
  String? sentAmount;
  String? fromAddress;
  String? toAddress;
  String? sentCryptoAmount;
  String? receivedCryptoAmount;
  String? cryptoCreatedDate;
  String? cryptoAdminFee;

  TransactionDetailView(
      {Key? key,
      this.amount,
      this.modifiedDate,
      this.status,
      this.transactionId,
      this.currencyCode,
      this.payMode,
      this.typename,
      this.type,
      this.adminFee,
      this.receivedAmount,
      this.sentAmount,
      this.fromAddress,
      this.toAddress,
      this.sentCryptoAmount,
      this.receivedCryptoAmount,
      this.cryptoCreatedDate,
      this.cryptoAdminFee})
      : super(key: key);

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  @override
  Widget build(BuildContext context) {
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
                  text: (widget.type == "fiat_Deposit" ||
                          widget.type == "crypto_Deposit")
                      ? stringVariables.depositDetails
                      : stringVariables.withdrawDetails,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Column(
        children: [
          CustomCard(
            radius: 25,
            edgeInsets: 18,
            outerPadding: 10,
            elevation: 0,
            child: widget.type == "fiat_Deposit"
                ? depositFiatDetail(context)
                : widget.type == "fiat_Withdraw"
                    ? withdrawFiatDetail(context)
                    : widget.type == "crypto_Withdraw"
                        ? withdrawCryptoDetail(context)
                        : depositCryptoDetail(context),
          )
        ],
      ),
    );
  }

  /// Deposit Crypto History Detail
  depositCryptoDetail(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.amount,
          fontfamily: 'InterTight',
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.amount}',
          fontfamily: 'InterTight',
          fontsize: 25,
          fontWeight: FontWeight.bold,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.status}',
          fontfamily: 'InterTight',
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Center(
            child: CustomText(
          text: stringVariables.transactionDetailtext,
          fontfamily: 'InterTight',
          strutStyleHeight: 1,
          align: TextAlign.center,
        )),
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.transactionId,
              fontfamily: 'InterTight',
            ),
            Container(
                width: 150,
                child: CustomText(
                  text: '${widget.transactionId}',
                  fontfamily: 'InterTight',
                )),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.currencycode,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.currencyCode}',
              fontfamily: 'InterTight',
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
              text: stringVariables.address,
              fontfamily: 'InterTight',
            ),
            Container(
                width: 150,
                child: CustomText(
                  text: '${widget.payMode}',
                  fontfamily: 'InterTight',
                )),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.userAmount,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.typename}',
              fontfamily: 'InterTight',
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
              text: stringVariables.createdDate,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.type}',
              fontfamily: 'InterTight',
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
              text: stringVariables.modifiedDate,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.adminFee}',
              fontfamily: 'InterTight',
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  /// Withdraw Crypto History Detail
  withdrawCryptoDetail(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.amount,
          fontfamily: 'InterTight',
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.amount}',
          fontfamily: 'InterTight',
          fontsize: 25,
          fontWeight: FontWeight.bold,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.status}',
          fontfamily: 'InterTight',
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Center(
            child: CustomText(
          text: stringVariables.transactionDetailtext,
          fontfamily: 'InterTight',
          strutStyleHeight: 1,
          align: TextAlign.center,
        )),
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.currencycode,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.currencyCode}',
              fontfamily: 'InterTight',
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
              text: stringVariables.from + "  " + stringVariables.address,
              fontfamily: 'InterTight',
            ),
            Container(
                width: 150,
                child: CustomText(
                  text: '${widget.fromAddress}',
                  fontfamily: 'InterTight',
                )),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.to + "  " + stringVariables.address,
              fontfamily: 'InterTight',
            ),
            Container(
                width: 150,
                child: CustomText(
                  text: '${widget.toAddress}',
                  fontfamily: 'InterTight',
                )),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.sendAmount,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.sentCryptoAmount}',
              fontfamily: 'InterTight',
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
              text: stringVariables.receiveAmount,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.receivedCryptoAmount}',
              fontfamily: 'InterTight',
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
              text: stringVariables.createdDate,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: getDate('${widget.cryptoCreatedDate}'),
              fontfamily: 'InterTight',
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
              text: stringVariables.adminFee,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.cryptoAdminFee}',
              fontfamily: 'InterTight',
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  /// Deposit Fiat History Detail
  depositFiatDetail(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.amount,
          fontfamily: 'InterTight',
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.amount}',
          fontfamily: 'InterTight',
          fontsize: 25,
          fontWeight: FontWeight.bold,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.status}',
          fontfamily: 'InterTight',
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Center(
            child: CustomText(
          text: stringVariables.transactionFiatDetailtext,
          fontfamily: 'InterTight',
          strutStyleHeight: 1,
          align: TextAlign.center,
        )),
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.transactionId,
              fontfamily: 'InterTight',
            ),
            Container(
                width: 150,
                child: CustomText(
                  text: '${widget.transactionId}',
                  fontfamily: 'InterTight',
                  align: TextAlign.end,
                )),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.currencycode,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.currencyCode}',
              fontfamily: 'InterTight',
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
              text: stringVariables.payMode,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.payMode}',
              fontfamily: 'InterTight',
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
              text: stringVariables.modifiedDate,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: getDate('${widget.modifiedDate}'),
              fontfamily: 'InterTight',
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  /// Withdraw Fiat History Detail
  withdrawFiatDetail(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: stringVariables.amount,
          fontfamily: 'InterTight',
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.amount}',
          fontfamily: 'InterTight',
          fontsize: 25,
          fontWeight: FontWeight.bold,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${widget.status}',
          fontfamily: 'InterTight',
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Center(
            child: CustomText(
          text: stringVariables.transactionFiatDetailtext,
          fontfamily: 'InterTight',
          strutStyleHeight: 1,
          align: TextAlign.center,
        )),
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.transactionId,
              fontfamily: 'InterTight',
            ),
            Container(
                width: 150,
                child: CustomText(
                  text: '${widget.transactionId}',
                  fontfamily: 'InterTight',
                )),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: stringVariables.currencycode,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.currencyCode}',
              fontfamily: 'InterTight',
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
              text: stringVariables.modifiedDate,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: getDate('${widget.modifiedDate}'),
              fontfamily: 'InterTight',
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
              text: stringVariables.sendAmount,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.sentAmount}',
              fontfamily: 'InterTight',
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
              text: stringVariables.receiveAmount,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.receivedAmount}',
              fontfamily: 'InterTight',
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
              text: stringVariables.adminFee,
              fontfamily: 'InterTight',
            ),
            CustomText(
              text: '${widget.adminFee}',
              fontfamily: 'InterTight',
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }
}
