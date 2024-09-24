import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zodeakx_mobile/Common/Orders/Model/TradeHistoryModel.dart';
import 'package:zodeakx_mobile/Common/Orders/Model/TradeOrderModel.dart';
import 'package:zodeakx_mobile/Common/Wallets/View/WalletView.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../Orders/Model/CancelledOrderModel.dart';

class CancelOrderDetailsView extends StatefulWidget {
  String? orderName;
  CancelOrder? cancelOrder;


  CancelOrderDetailsView({Key? key,this.orderName,this.cancelOrder,}) : super(key: key);

  @override
  State<CancelOrderDetailsView> createState() => _CancelOrderDetailsViewState();
}

class _CancelOrderDetailsViewState extends State<CancelOrderDetailsView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return buildOrderDetailsView(context, size);
  }

  Widget buildOrderDetailsView(BuildContext context, Size size) {
    return WillPopScope(
      onWillPop: () async => true,
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
                    fontfamily: 'Comfortaa',
                    fontsize: 23,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.orderDetails,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: CustomContainer(
          width: 1,
          height: 1,
          child: Column(
              children: [
                buildCancelHeader(size) ,
                buildCancelDetailsCard(size)
              ]
          ),
        ),
      ),
    );
  }






  Widget buildCancelDetailsCard(Size size) {
    String filled = widget.cancelOrder?.initial_amount.toString() ?? '';
    String amount = (widget.cancelOrder?.partialAmount).toString();
    return CustomContainer(
        width: 1,
        height: 1.95,
        child: CustomCard(
          radius: 25,
          edgeInsets: 0,
          outerPadding: 8,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCancelBasicDetails(filled, amount, size),
              buildCancelFeesDetails(size),
            ],
          ),
        ));
  }

  Widget buildCancelBasicDetails(String filled, String amount, Size size) {
    String toCurrency = widget.cancelOrder!.pair!.split('/')[1];
    String fromCurrency =widget.cancelOrder!.pair!.split('/')[0];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: size.width / 25,
            right: size.width / 25,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: stringVariables.orderId,
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                    color: textGrey,
                  ),
                  CustomText(
                    text: widget.cancelOrder?.id ?? '',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: stringVariables.type,
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                    color: textGrey,
                  ),
                  CustomText(
                    color: widget.cancelOrder?.tradeType.toString().toLowerCase() ==
                        stringVariables.buy.toLowerCase()
                        ? green
                        : red,
                    text: widget.cancelOrder!.orderType.toString() + "/" + widget.cancelOrder!.tradeType.toString(),
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: stringVariables.filled + "/" + stringVariables.amount,
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                    color: textGrey,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: trimDecimals(amount),
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: "/" + trimDecimals(filled) + " $fromCurrency",
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 13,
                        fontWeight: FontWeight.w700,
                        color: textGrey,
                      ),
                    ],
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: stringVariables.price,
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                    color: textGrey,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: trimDecimals(widget.cancelOrder!.marketPrice.toString()),
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: " $toCurrency",
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 13,
                        fontWeight: FontWeight.w700,
                        color: textGrey,
                      ),
                    ],
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.025,
              ),
            ],
          ),
        ),
        Divider(
          height: 2,
          color: hintLight,
        )
      ],
    );
  }

  Widget buildCancelFeesDetails(Size size) {
    String toCurrency = widget.cancelOrder!.pair!.split('/')[1];
    String fromCurrency = widget.cancelOrder!.pair!.split('/')[0];
    return Padding(
      padding: EdgeInsets.only(
        left: size.width / 25,
        right: size.width / 25,
      ),
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.025,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.fee,
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 15,
                fontWeight: FontWeight.w700,
                color: textGrey,
              ),
              Row(
                children: [
                  CustomText(
                    text: trimDecimals(
                        widget.cancelOrder!.adminFeeAmount.toString()),
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: (widget.cancelOrder!.tradeType.toString().toLowerCase() ==
                        stringVariables.buy.toLowerCase())
                        ? " $fromCurrency"
                        : " $toCurrency",
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 13,
                    fontWeight: FontWeight.w700,
                    color: textGrey,
                  ),
                ],
              ),
            ],
          )
          ,
          CustomSizedBox(
            height: 0.025,
          )
          ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.total,
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 15,
                fontWeight: FontWeight.w700,
                color: textGrey,
              ),
              Row(
                children: [
                  CustomText(
                    text: trimDecimals(widget.cancelOrder!.total.toString()),
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: " $toCurrency",
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 13,
                    fontWeight: FontWeight.w700,
                    color: textGrey,
                  ),
                ],
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.025,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.createdDate,
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 15,
                fontWeight: FontWeight.w700,
                color: textGrey,
              ),
              CustomText(
                text: getDateFromTimeStamp(widget.cancelOrder!.orderedDate.toString()),
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 13,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.025,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.tradedDate,
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 15,
                fontWeight: FontWeight.w700,
                color: textGrey,
              ),
              CustomText(
                text: getDateFromTimeStamp(
                    widget.cancelOrder!.tradedDate.toString()),
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 13,
                fontWeight: FontWeight.w700,
              ),
            ],
          )
          ,
          CustomSizedBox(
            height: 0.025,
          )
          ,
        ],
      ),
    );
  }



  String getDateFromTimeStamp(String timeStamp) {
    DateTime parseDate =
    new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }



  Widget buildCancelHeader(Size size) {
    return CustomContainer(
        width: 1,
        height: 7.5,
        child: Column(
          children: [
            CustomText(
              text: stringVariables.pair,
              color: textGrey,
              softwrap: true,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
              fontWeight: FontWeight.w800,
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            CustomText(
              text: widget.cancelOrder?.pair ?? "",
              softwrap: true,
              overflow: TextOverflow.ellipsis,
              fontsize: 18,
              fontWeight: FontWeight.w800,
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text:capitalize(widget.cancelOrder!.status!.toString()),
                  color: red,
                  softwrap: true,
                  overflow: TextOverflow.ellipsis,
                  fontsize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ));
  }


}
