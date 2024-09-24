import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class SubcriptionSuccessfulView extends StatefulWidget {
  const SubcriptionSuccessfulView({Key? key}) : super(key: key);

  @override
  State<SubcriptionSuccessfulView> createState() =>
      _SubcriptionSuccessfulViewState();
}

class _SubcriptionSuccessfulViewState extends State<SubcriptionSuccessfulView> {
  @override
  Widget build(BuildContext context) {
    return SuccessfulView(context);
  }

  Widget SuccessfulView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: buildAppBar(context),
      child: buildSubcriptionSuccessfulView(size),
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
                text: crypto + ' ' + stringVariables.subscribe,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRedemptionAmountView(size) {
    String subscriptionDate = "2023-05-13 11:50";
    String valueDate = "2023-05-13 11:50";
    String interestPeriod = "2023-05-13 11:50";
    String interestEndDate = "2023-05-13 11:50";
    String redemptionPeriod = "2023-05-13 11:50";
    String redemptionDate = "2023-05-13 11:50";
    String estAPR = "2023-05-13 11:50";
    String estValue = "0.0003434";
    String crypto = "BTC";
    return CustomContainer(
        width: 1,
        height: 3.35,
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15) : enableBorder.withOpacity(0.35),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCircleWithLine(size),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextForRedemption(
                            stringVariables.subscriptionDate, subscriptionDate),
                        buildTextForRedemption(
                            stringVariables.valueDate, valueDate),
                        buildTextForRedemption(
                            stringVariables.interestPeriod, interestPeriod),
                        buildTextForRedemption(
                            stringVariables.interestEndDate, interestEndDate),
                        buildTextForRedemption(
                            stringVariables.redemptionPeriod, redemptionPeriod),
                        buildTextForRedemption(
                            stringVariables.redemptionDate, redemptionDate),
                        buildTextForRedemption(stringVariables.estAPR, estAPR),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width / 50),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    fontfamily: 'GoogleSans',
                    fontsize: 16,
                    fontWeight: FontWeight.w400,
                    text: stringVariables.estimatedValue,
                    color: hintLight,
                  ),
                  CustomText(
                    fontfamily: 'GoogleSans',
                    fontsize: 14,
                    fontWeight: FontWeight.w400,
                    text: estValue + " $crypto",
                    color: green,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildTextForRedemption(String content1, String content2) {
    return Column(
      children: [
        Row(
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
        ),
        CustomSizedBox(
          height: 0.01,
        )
      ],
    );
  }

  Widget buildCircleWithLine(size) {
    return Column(children: [
      CustomSizedBox(
        height: 0.005,
      ),
      circleInsideCircle(),
      CustomContainer(
        width: size.width,
        height: 45,
        color: themeColor,
      ),
      circleInsideCircle(),
      CustomContainer(
        width: size.width,
        height: 45,
        color: themeColor,
      ),
      circleInsideCircle(),
      CustomContainer(
        width: size.width,
        height: 45,
        color: themeColor,
      ),
      circleInsideCircle(),
      CustomContainer(
        width: size.width,
        height: 45,
        color: themeColor,
      ),
      circleInsideCircle(),
      CustomContainer(
        width: size.width,
        height: 45,
        color: themeColor,
      ),
      circleInsideCircle(),
      CustomContainer(
        width: size.width,
        height: 45,
        color: themeColor,
      ),
      circleInsideCircle(),
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

  Widget buildSubcriptionSuccessfulView(Size size) {
    String subscriptionAmount = "448.74030762";
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
                    text: stringVariables.subcriptionSuccessful,
                    fontWeight: FontWeight.w500,
                    fontsize: 22,
                    fontfamily: 'GoogleSans'),
                CustomSizedBox(
                  height: 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              text: stringVariables.subscriptionAmount,
                              fontWeight: FontWeight.w500,
                              fontsize: 16,
                              color: textGrey,
                              fontfamily: 'GoogleSans'),
                          CustomText(
                              text: subscriptionAmount,
                              fontWeight: FontWeight.w500,
                              fontsize: 16,
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
                  height: 0.02,
                ),
              ],
            ),
          ),
          Column(
            children: [
              CustomElevatedButton(
                text: stringVariables.goToWallet,
                radius: 25,
                buttoncolor: themeColor,
                width: 1.15,
                height: MediaQuery.of(context).size.height / 50,
                isBorderedButton: false,
                maxLines: 1,
                blurRadius: 0,
                spreadRadius: 0,
                icons: false,
                icon: null,
                multiClick: true,
                color: black,
                press: () {
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
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
