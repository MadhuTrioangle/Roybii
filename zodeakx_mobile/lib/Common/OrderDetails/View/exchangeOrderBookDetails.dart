import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zodeakx_mobile/Common/Exchange/Model/AllOpenOrderHistoryModel.dart';
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

class ExchangeOrderDetailsView extends StatefulWidget {
  final dynamic order;

  const ExchangeOrderDetailsView({Key? key, required this.order})
      : super(key: key);

  @override
  State<ExchangeOrderDetailsView> createState() =>
      _ExchangeOrderDetailsViewState();
}

class _ExchangeOrderDetailsViewState extends State<ExchangeOrderDetailsView> {
  late AllOpenOrderHistory openOrderHistory;
  late Order order;
  bool orderType = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    widget.order is Order
        ? order = widget.order
        : openOrderHistory = widget.order;
    widget.order is Order ? orderType = true : orderType = false;
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
            children: [buildHeader(size), buildDetailsCard(size)],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(Size size) {
    String percentage = orderType
        ? double.parse(trimDecimals(
                ((order.status == stringVariables.filled.toLowerCase()
                            ? (order.amount)
                            : (order.amount - order.amount)) /
                        (order.initialAmount) *
                        100)
                    .toString()))
            .toInt()
            .toString()
        : double.parse(trimDecimals(((((openOrderHistory.initialAmount ?? 0) -
                            (openOrderHistory.amount ?? 0)) /
                        (openOrderHistory.initialAmount ?? 1)) *
                    100)
                .toString()))
            .toInt()
            .toString();
    String addOn = widget.order.status.toString().toLowerCase() ==
                stringVariables.filled.toLowerCase() ||
            widget.order.status.toString().toLowerCase() ==
                stringVariables.partially.toLowerCase()
        ? " ($percentage%)"
        : "";
    Color color =
        widget.order.status == stringVariables.partially.toLowerCase() ||
                widget.order.status == stringVariables.inActive.toLowerCase() ||
                widget.order.status == stringVariables.cancelled
            ? red
            : green;
    Widget icon =
        widget.order.status == stringVariables.partially.toLowerCase() ||
                widget.order.status == stringVariables.inActive.toLowerCase() ||
                widget.order.status == stringVariables.cancelled
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
              text: widget.order.pair!,
              softwrap: true,
              overflow: TextOverflow.ellipsis,
              fontsize: 18,
              fontWeight: FontWeight.w800,
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            if (!orderType)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  CustomSizedBox(
                    width: 0.01,
                  ),
                  CustomText(
                    text: capitalize(widget.order.status!.toString()) + addOn,
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

  Widget buildDetailsCard(Size size) {
    String filled = orderType
        ? trimDecimals(order.status == stringVariables.filled.toLowerCase()
            ? (order.initialAmount).toString()
            : (order.initialAmount - order.amount).toString())
        : trimDecimals(((openOrderHistory.initialAmount ?? 0) -
                (openOrderHistory.amount ?? 0))
            .toString());
    String amount = orderType
        ? (order.initialAmount).toString()
        : openOrderHistory.initialAmount.toString();
    return CustomContainer(
        width: 1,
        height: orderType ? 1.95 : 2.45,
        child: CustomCard(
          radius: 25,
          edgeInsets: 0,
          outerPadding: 8,
          elevation: 0,
          child: Column(
            children: [
              buildBasicDetails(filled, amount, size),
              buildFeesDetails(size),
            ],
          ),
        ));
  }

  Widget buildBasicDetails(String filled, String amount, Size size) {
    String toCurrency = widget.order.pair!.split('/')[1];
    String fromCurrency = widget.order.pair!.split('/')[0];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: size.width / 25,
            right: size.width / 25,
            top: size.height / 50,
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
                    text: widget.order.id,
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
                    color: widget.order.tradeType.toString().toLowerCase() ==
                            stringVariables.buy.toLowerCase()
                        ? green
                        : red,
                    text: widget.order.orderType + "/" + widget.order.tradeType,
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
                        fontsize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: "/" + trimDecimals(amount) + " $fromCurrency",
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
                        text: trimDecimals(widget.order.marketPrice.toString()),
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
          thickness: 0.2,
          color: divider,
        )
      ],
    );
  }

  Widget buildFeesDetails(Size size) {
    String toCurrency = widget.order.pair!.split('/')[1];
    String fromCurrency = widget.order.pair!.split('/')[0];
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
          orderType
              ? Row(
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
                              widget.order.adminFeeAmount.toString()),
                          softwrap: true,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          text: (widget.order.tradeType.toLowerCase() ==
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
                )
              : SizedBox.shrink(),
          orderType
              ? CustomSizedBox(
                  height: 0.025,
                )
              : SizedBox.shrink(),
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
                    text: trimDecimals(widget.order.total.toString()),
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
                text: getDateFromTimeStamp(widget.order.orderedDate.toString()),
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
          // orderType
          //     ? Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           CustomText(
          //             text: stringVariables.tradedDate,
          //             softwrap: true,
          //             overflow: TextOverflow.ellipsis,
          //             fontsize: 15,
          //             fontWeight: FontWeight.w700,
          //             color: textGrey,
          //           ),
          //           CustomText(
          //             text: getDateFromTimeStamp(
          //                 widget.order.orderedDate.toString()),
          //             softwrap: true,
          //             overflow: TextOverflow.ellipsis,
          //             fontsize: 15,
          //             fontWeight: FontWeight.w700,
          //           ),
          //         ],
          //       )
          //     : SizedBox.shrink(),
          // orderType
          //     ? CustomSizedBox(
          //         height: 0.025,
          //       )
          //     : SizedBox.shrink(),
        ],
      ),
    );
  }

  String getDateFromTimeStamp(String timeStamp) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}
