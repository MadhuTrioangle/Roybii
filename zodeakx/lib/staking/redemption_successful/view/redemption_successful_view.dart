import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';

class RedemptionSuccessfulView extends StatefulWidget {
  const RedemptionSuccessfulView({Key? key}) : super(key: key);

  @override
  State<RedemptionSuccessfulView> createState() =>
      _RedemptionSuccessfulViewState();
}

class _RedemptionSuccessfulViewState extends State<RedemptionSuccessfulView> {
  @override
  Widget build(BuildContext context) {
    return SuccessfulView(context);
  }

  Widget SuccessfulView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: buildAppBar(context),
      child: buildRedemptionSuccessfulView(size),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    String crypto = "BTC";
    return AppBar(
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
                overflow: TextOverflow.ellipsis,
                maxlines: 1,
                softwrap: true,
                fontfamily: 'GoogleSans',
                fontsize: 21,
                fontWeight: FontWeight.bold,
                text: crypto + ' ' + stringVariables.redemption,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRedemptionAmountView(size) {
    String redemptionSubmitted = "2023-05-13 11:50";
    String estimatedReturnDate = "2023-05-13 11:50";
    return CustomContainer(
        width: 1,
        height: 9,
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15) : enableBorder.withOpacity(0.35),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              buildCircleWithLine(size),
              CustomSizedBox(
                width: 0.02,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTextForRedemption(stringVariables.redemptionSubmitted,
                        redemptionSubmitted),
                    buildTextForRedemption(stringVariables.estimatedReturnDate,
                        estimatedReturnDate),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget buildTextForRedemption(String content1, String content2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 16,
          fontWeight: FontWeight.w400,
          text: content1,
          color: hintLight,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 14,
          fontWeight: FontWeight.w400,
          text: content2,
        ),
      ],
    );
  }

  Widget buildCircleWithLine(size) {
    return Column(children: [
      CustomSizedBox(
        height: 0.005,
      ),
      circleInsideCircle(),
      Flexible(
        fit: FlexFit.loose,
        child: CustomContainer(
          width: size.width,
          color: themeColor,
        ),
      ),
      circleInsideCircle(),
      CustomSizedBox(
        height: 0.0065,
      ),
    ]);
  }

  Widget circleInsideCircle() {
    return CustomCircleAvatar(
        radius: 3.5,
        backgroundColor: green,
        child: CustomCircleAvatar(
          radius: 2,
          backgroundColor: white,
          child: CustomSizedBox(
            width: 0,
            height: 0,
          ),
        ));
  }

  Widget buildRedemptionSuccessfulView(Size size) {
    String amount = "44.243274";
    String crypto = "BTC";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(successful),
                CustomSizedBox(
                  height: 0.03,
                ),
                CustomText(
                    text: stringVariables.redemptionSuccessfully,
                    fontWeight: FontWeight.w500,
                    fontsize: 22,
                    fontfamily: 'GoogleSans'),
                CustomSizedBox(
                  height: 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 50),
                  child: Divider(),
                ),
                CustomSizedBox(
                  height: 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              text: stringVariables.redemptionAmount,
                              fontWeight: FontWeight.w500,
                              fontsize: 16,
                              fontfamily: 'GoogleSans'),
                          CustomText(
                              text: "$amount $crypto",
                              fontWeight: FontWeight.w500,
                              fontsize: 16,
                              color: green,
                              fontfamily: 'GoogleSans'),
                        ],
                      ),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      buildRedemptionAmountView(size)
                    ],
                  ),
                ),
                CustomSizedBox(
                  height: 0.05,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                    text: stringVariables.viewHistory,
                    radius: 25,
                    buttoncolor: themeColor,
                    width: 2.25,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: false,
                    blurRadius: 0,
                    spreadRadius: 0,
                    maxLines: 1,
                    icons: false,
                    icon: null,
                    color: black,
                    multiClick: true,
                    press: () {
                      Navigator.of(context).pop();
                      moveToOrderHistory(context);
                    },
                  ),
                  CustomElevatedButton(
                    text: stringVariables.goToWallet,
                    radius: 25,
                    buttoncolor: enableBorder,
                    width: 2.25,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: false,
                    blurRadius: 0,
                    spreadRadius: 0,
                    maxLines: 1,
                    icons: false,
                    icon: null,
                    color: black,
                    multiClick: true,
                    press: () {
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 3);
                    },
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.015,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
