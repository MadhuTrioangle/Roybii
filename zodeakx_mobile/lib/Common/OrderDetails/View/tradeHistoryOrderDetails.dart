import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zodeakx_mobile/Common/Orders/Model/TradeHistoryModel.dart';
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

class TradeHistoryDetailsView extends StatefulWidget {
  String? orderName;
  TradeHistoryModelDetails? tradeHistoryModelDetails;

  TradeHistoryDetailsView(
      {Key? key, this.orderName, this.tradeHistoryModelDetails})
      : super(key: key);

  @override
  State<TradeHistoryDetailsView> createState() =>
      _TradeHistoryDetailsViewState();
}

class _TradeHistoryDetailsViewState extends State<TradeHistoryDetailsView> {
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
            buildHistoryHeader(size),
            buildTradeDetailsCard(size),
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
                        fontsize: 13,
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
          thickness: 0.2,
          color: divider,
        )
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
                    fontsize: 13,
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
                    text: trimDecimals(
                        widget.tradeHistoryModelDetails!.total.toString()),
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
                text: getDateFromTimeStamp(
                    widget.tradeHistoryModelDetails!.createdDate.toString()),
                softwrap: true,
                overflow: TextOverflow.ellipsis,
                fontsize: 13,
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
}
