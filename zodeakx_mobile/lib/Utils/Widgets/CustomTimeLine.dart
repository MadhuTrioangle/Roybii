import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:zodeakx_mobile/Common/IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';

import '../Core/ColorHandler/DarkandLightTheme.dart';
import 'CustomContainer.dart';
import 'CustomSizedbox.dart';
import 'CustomText.dart';

class CustomTimeLine extends StatelessWidget {
  final String text1; // add text in timeline first index
  final String text2; // add text in timeline second index
  final String text3; // add text in timeline third index
  final String text4; // add text in timeline fourth index
  final String label1; // add number in timeline first index
  final String label2; // add number in timeline second index
  final String label3; // add number in timeline third index
  final String label4; // add number in timeline fourth index
  Color? text1Color = Colors.black; // add textColor in timeline first index
  Color? text2Color = Colors.black; // add textColor in timeline second index
  Color? text3Color = Colors.black; // add textColor in timeline third index
  Color? text4Color = Colors.black; // add textColor in timeline fourth index
  Color? button1Color =
      Colors.black; // add buttonColor in  timeline first index
  Color? button2Color =
      Colors.black; // add buttonColor in timeline second index
  Color? button3Color = Colors.black; // add buttonColor in timeline third index
  Color? button4Color =
      Colors.black; // add buttonColor in timeline fourth index
  Color? label1Color = Colors.black; // add color in text
  Color? label2Color = Colors.black; // add color in text
  Color? label3Color = Colors.black; // add color in text
  Color? label4Color = Colors.black; // add color in text
  final Function()? onTapFirstIndex; // used to add functionality
  final Function()? onTapSecondIndex; // used to add functionality
  final Function()? onTapThirdIndex; // used to add functionality
  final Function()? onTapFourthIndex; // used to add functionality
  final Function()? onTap; // used to add functionality
  IdentityVerificationCommonViewModel? identityVerificationCommonViewModel;
  double? fontsize = 15.0; // add size in text
  FontWeight? fontWeight = FontWeight.normal;
  String? text; // add fontweight in text
  final Widget? child;

  CustomTimeLine(
      {Key? key,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.text4,
      required this.label1,
      required this.label2,
      required this.label3,
      required this.label4,
      this.text1Color,
      this.text2Color,
      this.text3Color,
      this.text4Color,
      this.button1Color,
      this.button2Color,
      this.button3Color,
      this.button4Color,
      this.onTapFirstIndex,
      this.onTapFourthIndex,
      this.onTapSecondIndex,
      this.onTapThirdIndex,
      this.label1Color,
      this.label2Color,
      this.label3Color,
      this.label4Color,
      this.onTap,
      this.text,
      this.child,
      this.identityVerificationCommonViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 5.5,
          child: FixedTimeline(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            children: [
              TimelineTile(
                oppositeContents: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height / 80,
                      right: MediaQuery.of(context).size.height / 40),
                  child: CustomText(
                    text: text1,
                    color: text1Color,
                    align: TextAlign.center,
                    fontsize: 12,
                  ),
                ),
                node: TimelineNode(
                  indicator: GestureDetector(
                    onTap: onTapFirstIndex,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.height / 100),
                      child: CustomContainer(
                          width: MediaQuery.of(context).size.width / 30,
                          height: MediaQuery.of(context).size.height / 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: button1Color,
                          ),
                          child: Center(
                            child: CustomText(
                              text: label1,
                              fontWeight: fontWeight,
                              fontsize: fontsize,
                              color: label1Color,
                            ),
                          )),
                    ),
                  ),
                  endConnector: SolidLineConnector(
                    thickness: 1,
                    color: divider,
                  ),
                ),
              ),
              TimelineTile(
                  oppositeContents: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 180,
                        right: MediaQuery.of(context).size.height / 50),
                    child: CustomText(
                      text: text2,
                      color: text2Color,
                      align: TextAlign.center,
                      fontsize: 12,
                    ),
                  ),
                  node: TimelineNode(
                    indicator: GestureDetector(
                      onTap: onTapSecondIndex,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height / 120,
                                right: MediaQuery.of(context).size.height / 90),
                            child: CustomContainer(
                                width: MediaQuery.of(context).size.width / 30,
                                height: MediaQuery.of(context).size.height / 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: button2Color,
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: label2,
                                    fontWeight: fontWeight,
                                    fontsize: fontsize,
                                    color: label2Color,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    startConnector: SolidLineConnector(
                      thickness: 1,
                      color: divider,
                    ),
                    endConnector: SolidLineConnector(
                      thickness: 1,
                      color: divider,
                    ),
                  )),
              TimelineTile(
                  oppositeContents: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 50,
                        right: MediaQuery.of(context).size.height / 30),
                    child: CustomText(
                      text: text3,
                      color: text3Color,
                      align: TextAlign.center,
                      fontsize: 12,
                    ),
                  ),
                  node: TimelineNode(
                    indicator: GestureDetector(
                      onTap: onTapThirdIndex,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height / 100,
                                right: MediaQuery.of(context).size.height / 70),
                            child: CustomContainer(
                                width: MediaQuery.of(context).size.width / 30,
                                height: MediaQuery.of(context).size.height / 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: button3Color,
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: label3,
                                    fontWeight: fontWeight,
                                    fontsize: fontsize,
                                    color: label3Color,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    startConnector:
                        SolidLineConnector(thickness: 1, color: divider),
                    endConnector:
                        SolidLineConnector(thickness: 1, color: divider),
                  )),
              TimelineTile(
                  oppositeContents: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height / 200),
                    child: CustomText(
                        text: text4,
                        color: text4Color,
                        align: TextAlign.center),
                  ),
                  node: TimelineNode(
                    indicator: GestureDetector(
                      onTap: onTapFourthIndex,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height / 80,
                            right: MediaQuery.of(context).size.height / 60),
                        child: CustomContainer(
                          child: Center(
                            child: CustomText(
                              text: label4,
                              fontWeight: fontWeight,
                              fontsize: fontsize,
                              color: label4Color,
                            ),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: button4Color,
                          ),
                          width: MediaQuery.of(context).size.width / 30,
                          height: MediaQuery.of(context).size.height / 60,
                        ),
                      ),
                    ),
                    startConnector:
                        SolidLineConnector(thickness: 1, color: divider),
                  )),
            ],
          ),
        ),
        Center(
          child: child,
        ),
        identityVerificationCommonViewModel != null
            ? identityVerificationCommonViewModel!.buttonLoading
                ? CustomLoader()
                : Column(
                    children: [
                      CustomElevatedButton(
                          text: text!,
                          press: onTap!,
                          radius: 25,
                          buttoncolor: themeColor,
                          color: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                          width: 1.25,
                          height: MediaQuery.of(context).size.height / 50,
                          multiClick: true,
                          isBorderedButton: false,
                          maxLines: 1,
                          icons: false,
                          icon: null),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom)),
                    ],
                  )
            : Column(
                children: [
                  CustomElevatedButton(
                      text: text!,
                      press: onTap!,
                      radius: 25,
                      buttoncolor: themeColor,
                      color:
                          themeSupport().isSelectedDarkMode() ? black : white,
                      width: 1.25,
                      height: MediaQuery.of(context).size.height / 50,
                      multiClick: true,
                      isBorderedButton: false,
                      maxLines: 1,
                      icons: false,
                      icon: null),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }
}
