import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zodeakx_mobile/Common/Orders/Model/TradeHistoryModel.dart';
import 'package:zodeakx_mobile/Common/Orders/Model/TradeOrderModel.dart';
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

class OrderDetailsView extends StatefulWidget {
  String? orderName;
  Order? order;
  CancelOrder? cancelOrder;
  TradeHistoryModelDetails? tradeHistoryModelDetails;

  OrderDetailsView(
      {Key? key,
      this.orderName,
      this.order,
      this.cancelOrder,
      this.tradeHistoryModelDetails})
      : super(key: key);

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
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
                    fontfamily: 'InterTight',
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
          child: Column(children: [
            widget.orderName == "openOrders"
                ? buildHeader(size)
                : widget.orderName == "cancelOrders"
                    ? buildCancelHeader(size)
                    : buildHistoryHeader(size),
            widget.orderName == "openOrders"
                ? buildDetailsCard(size)
                : widget.orderName == "cancelOrders"
                    ? buildCancelDetailsCard(size)
                    : buildTradeDetailsCard(size),
          ]),
        ),
      ),
    );
  }

  Widget buildTradeDetailsCard(Size size) {
    String filled = "0.00";
    String amount = (widget.tradeHistoryModelDetails?.filledAmount).toString();
    return CustomContainer(
        width: 1,
        height: 2.2,
        child: CustomCard(
          radius: 25,
          edgeInsets: 0,
          outerPadding: 8,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTradeBasicDetails(filled, amount, size),
              buildTradeFeesDetails(size),
            ],
          ),
        ));
  }

  Widget buildTradeBasicDetails(String filled, String amount, Size size) {
    String toCurrency = widget.tradeHistoryModelDetails!.pair!.split('/')[1];
    String fromCurrency = widget.tradeHistoryModelDetails!.pair!.split('/')[0];
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
                    text: widget.tradeHistoryModelDetails?.id ?? '',
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
                    color: widget.tradeHistoryModelDetails?.tradeType
                                .toString()
                                .toLowerCase() ==
                            stringVariables.buy.toLowerCase()
                        ? green
                        : red,
                    text: widget.tradeHistoryModelDetails!.orderType
                            .toString() +
                        "/" +
                        widget.tradeHistoryModelDetails!.tradeType.toString(),
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
                    text: stringVariables.amount,
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                    color: textGrey,
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: trimDecimals(amount) + " $fromCurrency",
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      // CustomText(
                      //   text: "/" + trimDecimals(amount) + " $fromCurrency",
                      //   softwrap: true,
                      //   overflow: TextOverflow.ellipsis,
                      //   fontsize: 15,
                      //   fontWeight: FontWeight.w700,
                      //   color: textGrey,
                      // ),
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
                        text: trimDecimals(
                            widget.tradeHistoryModelDetails!.price.toString()),
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: " $toCurrency",
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 15,
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
          color: divider,
          thickness: 0.2,
        ),
      ],
    );
  }

  Widget buildTradeFeesDetails(Size size) {
    String toCurrency = widget.tradeHistoryModelDetails!.pair!.split('/')[1];
    String fromCurrency = widget.tradeHistoryModelDetails!.pair!.split('/')[0];
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
                    text: trimDecimals(widget
                        .tradeHistoryModelDetails!.adminFeeAmount
                        .toString()),
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: (widget.tradeHistoryModelDetails!.tradeType
                                .toString()
                                .toLowerCase() ==
                            stringVariables.buy.toLowerCase())
                        ? " $fromCurrency"
                        : " $toCurrency",
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
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
                    text: trimDecimals(
                        widget.tradeHistoryModelDetails!.total.toString()),
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: " $toCurrency",
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
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
                text: getDateFromTimeStamp(
                    widget.tradeHistoryModelDetails!.createdDate.toString()),
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 15,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          // CustomSizedBox(
          //   height: 0.025,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     CustomText(
          //       text: stringVariables.tradedDate,
          //       softwrap: true,
          //       overflow: TextOverflow.ellipsis,
          //       fontsize: 15,
          //       fontWeight: FontWeight.w700,
          //       color: textGrey,
          //     ),
          //     // CustomText(
          //     //   text: getDateFromTimeStamp(
          //     //       widget.tradeHistoryModelDetails!..toString()),
          //     //   softwrap: true,
          //     //   overflow: TextOverflow.ellipsis,
          //     //   fontsize: 15,
          //     //   fontWeight: FontWeight.w700,
          //     // ),
          //   ],
          // )
          // ,
          // CustomSizedBox(
          //   height: 0.025,
          // )
          // ,
        ],
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
    String fromCurrency = widget.cancelOrder!.pair!.split('/')[0];
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
                    color: widget.cancelOrder?.tradeType
                                .toString()
                                .toLowerCase() ==
                            stringVariables.buy.toLowerCase()
                        ? green
                        : red,
                    text: widget.cancelOrder!.orderType.toString() +
                        "/" +
                        widget.cancelOrder!.tradeType.toString(),
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
                        fontsize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: "/" + trimDecimals(filled) + " $fromCurrency",
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 15,
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
                        text: trimDecimals(
                            widget.cancelOrder!.marketPrice.toString()),
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: " $toCurrency",
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 15,
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
          color: divider,
          thickness: 0.2,
        ),
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
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: (widget.cancelOrder!.tradeType
                                .toString()
                                .toLowerCase() ==
                            stringVariables.buy.toLowerCase())
                        ? " $fromCurrency"
                        : " $toCurrency",
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
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
                    fontsize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: " $toCurrency",
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 15,
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
                text: getDateFromTimeStamp(
                    widget.cancelOrder!.orderedDate.toString()),
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
                fontsize: 15,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.025,
          ),
        ],
      ),
    );
  }

  Widget buildDetailsCard(Size size) {
    String filled = trimDecimals(
        widget.order?.status == stringVariables.filled.toLowerCase()
            ? (widget.order?.initialAmount).toString()
            : (widget.order?.initialAmount - widget.order?.amount).toString());
    String amount = (widget.order?.initialAmount).toString();
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
              buildBasicDetails(filled, amount, size),
              buildFeesDetails(size),
            ],
          ),
        ));
  }

  Widget buildBasicDetails(String filled, String amount, Size size) {
    String toCurrency = widget.order!.pair!.split('/')[1];
    String fromCurrency = widget.order!.pair!.split('/')[0];
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
                    text: widget.order?.id ?? '',
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
                    color: widget.order?.tradeType.toString().toLowerCase() ==
                            stringVariables.buy.toLowerCase()
                        ? green
                        : red,
                    text:
                        widget.order!.orderType + "/" + widget.order!.tradeType,
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
                        text: trimDecimals(filled),
                        softwrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: "/" + trimDecimals(amount) + " $fromCurrency",
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
                        text:
                            trimDecimals(widget.order!.marketPrice.toString()),
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
          color: divider,
          thickness: 0.2,
        ),
      ],
    );
  }

  Widget buildFeesDetails(Size size) {
    String toCurrency = widget.order!.pair!.split('/')[1];
    String fromCurrency = widget.order!.pair!.split('/')[0];
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
                    text: trimDecimals(widget.order!.adminFeeAmount.toString()),
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    fontsize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: (widget.order!.tradeType.toLowerCase() ==
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
          ),
          CustomSizedBox(
            height: 0.025,
          ),
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
                    text: trimDecimals(widget.order!.total.toString()),
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
                text:
                    getDateFromTimeStamp(widget.order!.orderedDate.toString()),
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
                text: getDateFromTimeStamp(widget.order!.tradedDate.toString()),
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

  Widget buildHistoryHeader(Size size) {
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
              text: widget.tradeHistoryModelDetails?.pair ?? "",
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
                  text: capitalize(stringVariables.completed),
                  color: green,
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
                  text: capitalize(widget.cancelOrder!.status!.toString()),
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

  Widget buildHeader(Size size) {
    String percentage = double.parse(trimDecimals(((widget.order?.status
                            .toString() ==
                        stringVariables.filled.toLowerCase()
                    ? (widget.order?.initialAmount)
                    : (widget.order?.initialAmount - widget.order?.amount)) /
                (widget.order?.initialAmount) *
                100)
            .toString()))
        .toInt()
        .toString();
    String addOn = widget.order?.status.toString().toLowerCase() ==
                stringVariables.filled.toLowerCase() ||
            widget.order?.status.toString().toLowerCase() ==
                stringVariables.partially.toLowerCase()
        ? " ($percentage%)"
        : "";
    Color color = widget.order?.status ==
                stringVariables.partially.toLowerCase() ||
            widget.order?.status == stringVariables.inActive.toLowerCase() ||
            widget.order?.status == stringVariables.cancelled
        ? red
        : green;
    Widget icon = widget.order?.status ==
                stringVariables.partially.toLowerCase() ||
            widget.order?.status == stringVariables.inActive.toLowerCase() ||
            widget.order?.status == stringVariables.cancelled
        ? Transform.rotate(
            angle: 45 * pi / 180,
            child: Icon(
              Icons.add_circle,
              color: red,
              size: 15,
            ))
        : Icon(
            Icons.check_circle,
            color: green,
            size: 15,
          );
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
              text: widget.order?.pair ?? "",
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
                icon,
                CustomSizedBox(
                  width: 0.01,
                ),
                CustomText(
                  text: capitalize(widget.order!.status!.toString()) + addOn,
                  color: color,
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
