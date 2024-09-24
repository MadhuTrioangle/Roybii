import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../view_model/p2p_home_view_model.dart';

class P2PNoticeModal extends ModalRoute {
  late P2PHomeViewModel viewModel;
  late BuildContext context;

  P2PNoticeModal(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    viewModel.setCheckAlert(false);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => black.withOpacity(0.6);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  Future<bool> pop() async {
    Navigator.pop(context, false);
    return false;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    viewModel = context.watch<P2PHomeViewModel>();
  
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: pop,
      child: Provider(
        create: (context) => viewModel,
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {},
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CustomContainer(
                          height: isSmallScreen(context) ? 1.3 : 1.7,///1.3 is for android 1.7 is for ios
                          width: 1.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: themeSupport().isSelectedDarkMode()
                                ?darkCardColor:lightCardColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width / 25),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                    SvgPicture.asset(
                                    p2pRiskNotice,
                                      height: 110,
                                    ),
                                    CustomSizedBox(height: 0.02,),
                                    CustomText(
                                      text: stringVariables.riskNotice,
                                      align: TextAlign.center,
                                      fontWeight: FontWeight.w600,
                                      fontsize: 22,
                                      color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
                                    ),
                                    CustomSizedBox(height: 0.02,),
                                    CustomContainer(

                                      height: isSmallScreen(context) ?4 : 5,
                                      child: SingleChildScrollView(
                                        child: CustomText(

                                          text: stringVariables
                                              .riskNoticeContent,
                                          fontWeight: FontWeight.w400,
                                          fontsize: 14,
                                          align: TextAlign.center,
                                          strutStyleHeight: 1.3,
                                          color: themeSupport().isSelectedDarkMode()?contentFontColor:hintTextColor,
                                        ),
                                      ),
                                    ),
                                    CustomSizedBox(height: 0.02,),
                                  ],
                                ),
                                Column(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildCheckBox(),
      CustomSizedBox(height: 0.02,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomElevatedButton(

                                            blurRadius: 0,
                                            spreadRadius: 0,
                                            text: stringVariables.cancel,
                                            // color: viewModel.checkAlert
                                            //     ? themeSupport()
                                            //             .isSelectedDarkMode()
                                            //         ? Colors.black
                                            //         :  Colors.black
                                            //     :  Colors.red,
                                            color: themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor,
                                            press: () {
                                            Navigator.pop(context);
                                            },
                                            radius: 15,
                                            buttoncolor:themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                111,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                43,
                                            isBorderedButton: false,

                                            maxLines: 1,
                                            icons: false,
                                            multiClick: true,
                                            icon: null),
                                        Row(
                                          children: [
                                            CustomElevatedButton(
                                                blurRadius: 0,
                                                spreadRadius: 0,
                                                text: stringVariables.confirm,
                                                // color: viewModel.checkAlert
                                                //     ? themeSupport()
                                                //     .isSelectedDarkMode()
                                                //     ? black
                                                //     : white
                                                //     : hintLight,
                                                color: themeSupport().isSelectedDarkMode()?minusDarkColor:disbleLighttext,
                                              fillColor:viewModel.checkAlert? themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor: themeSupport().isSelectedDarkMode()?hintTextColor:disableButtonLight          ,
                                                press: () {
                                                  if (viewModel.checkAlert)
                                                    Navigator.pop(context, true);
                                                },
                                                radius: 15,
                                                buttoncolor: Colors.transparent,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    111,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    43,
                                                isBorderedButton: false,
                                                maxLines: 1,
                                                icons: false,
                                                multiClick: true,
                                                icon: null),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // CustomSizedBox(
                                    //   height: 0.01,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// checkbox with text
  Widget buildCheckBox() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomCard(
          elevation: 0,
          borderColor: themeSupport().isSelectedDarkMode()?minusDarkColor:minusLightColor,
            radius: 15,
            edgeInsets: 15,
            outerPadding: 0,
          color: themeSupport().isSelectedDarkMode()?marketCardColor:inputColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSizedBox(
                    width: 0.0525,
                    height: 0.030,
                    child: CustomCheckBox(
                      checkboxState: viewModel.checkAlert,
                      toggleCheckboxState: (value) {
                        viewModel.setCheckAlert(value ?? false);
                      },
                      activeColor: Colors.white,
                      checkColor: themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor,
                      borderColor:  themeSupport().isSelectedDarkMode()?hintTextColor:contentFontColor,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.030,
                  ),
                  CustomContainer(
                    width: 1.7,
                    child: CustomText(
                      text: stringVariables.riskNoticeAlert,
                      fontWeight: FontWeight.w400,
                      fontsize: 14,
                      strutStyleHeight: 1.3,
                      color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
