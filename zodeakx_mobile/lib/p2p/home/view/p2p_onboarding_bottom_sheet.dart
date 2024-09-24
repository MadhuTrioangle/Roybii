import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/p2p_home_view_model.dart';

class P2POnBoardingModal extends ModalRoute {

  late P2PHomeViewModel viewModel;
  late BuildContext context;
  PageController? _pageController;
  List<Widget> items = [];

  P2POnBoardingModal(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    _pageController = PageController(viewportFraction: 1);///like width
    items = [buildWelcome(), buildBuyCrypto(),buildDoAndDont() ];
    viewModel.setActiveOnBoard(0);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);///how much milliseconds after the bottom sheet has to visible
  ///example if i keep 6000 millisec sheet appearing slowing and disappearing slowly

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;///This property determines if the user can dismiss the modal by tapping on the barrier (the area outside the route). Setting it to false means the user cannot dismiss the route by tapping outside it.

  @override
  Color get barrierColor => black.withOpacity(0.6);///full screen under the bottom sheet appear black

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
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<P2PHomeViewModel>();

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,///bottom sheet showing at end
                    children: [

                      CustomContainer(
                      padding:8,
                        height: isSmallScreen(context) ?1.65 : 1.75,
                        width: 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          color: themeSupport().isSelectedDarkMode()
                              ? darkCardColor
                              :lightCardColor ,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: size.width / 35,
                              right: size.width / 35,
                              top: size.width / 35,
                            bottom:0
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  CustomWidgetSlider(
                                      height:
                                          isSmallScreen(context) ? 2.12 : 2.2,
                                      items: items,///items has 3 method if i eliminate the one method, 2 page content only visible
                                      pageController: _pageController,
                                      onPageChanged: (page) {
                                        viewModel.setActiveOnBoard(page);
                                      },
                                      activePage: viewModel.activeOnBoard),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomContainer(
                                    height: 12,
                                    width: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                                    onTap: () {
                                                      if (viewModel
                                                              .activeOnBoard !=
                                                          0) {
                                                        previousPage(viewModel
                                                                .activeOnBoard -
                                                            1);
                                                        viewModel.setActiveOnBoard(
                                                            viewModel.activeOnBoard - 1);
                                                      }
                                                    },
                                                    child: CustomContainer(
                                                      width: 10,
                                                      height:20,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),
                                                          border: Border.all(color:viewModel
                                                              .activeOnBoard == 0?themeSupport().isSelectedDarkMode()?minusDarkColor:minusLightColor:
                                                          viewModel.activeOnBoard == (viewModel.noOfOnBoard - 1)
                                                              ? Colors.transparent
                                                              :themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor ,),
                                                        color: viewModel
                                                            .activeOnBoard == 0
                                                            ? themeSupport().isSelectedDarkMode()?marketCardColor:inputColor
                                                            : viewModel.activeOnBoard == (viewModel.noOfOnBoard - 1)
                                                            ? themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor
                                                            : Colors.transparent,),

                                                      child: SvgPicture.asset(
                                                        p2pLeftArrow,
                                                        color: viewModel
                                                                    .activeOnBoard ==
                                                                0
                                                            ? themeSupport().isSelectedDarkMode()?contentFontColor:hintTextColor
                                                            : viewModel.activeOnBoard ==
                                                                    (viewModel
                                                                            .noOfOnBoard -
                                                                        1)
                                                                ? lightCardColor
                                                                : themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor,
                                                      ),
                                                    )
                                                  ),

                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: List.generate(
                                              viewModel.noOfOnBoard,
                                                  (index) => buildDot(
                                                  index,
                                                  context,
                                                  viewModel.activeOnBoard)),
                                        ),
                                        Row(children: [
                                          GestureDetector(
                                                    onTap: () {
                                                      if (viewModel
                                                              .activeOnBoard !=
                                                          (viewModel
                                                                  .noOfOnBoard -
                                                              1)) {
                                                        nextPage(viewModel
                                                                .activeOnBoard +
                                                            1);
                                                        viewModel.setActiveOnBoard(
                                                            viewModel
                                                                    .activeOnBoard +
                                                                1);
                                                      }
                                                    },
                                              child:CustomContainer(
                                                width: 10,
                                                height:20,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),
                                                  border: Border.all(color:viewModel
                                                      .activeOnBoard == 0?Colors.transparent:
                                                  viewModel.activeOnBoard == (viewModel.noOfOnBoard - 1)
                                                      ? themeSupport().isSelectedDarkMode()?minusDarkColor:minusLightColor
                                                      :Colors.transparent ,),
                                                  color: viewModel
                                                      .activeOnBoard == 0
                                                      ? themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor
                                                      : viewModel.activeOnBoard == (viewModel.noOfOnBoard - 1)
                                                      ? themeSupport().isSelectedDarkMode()?marketCardColor:inputColor
                                                      : themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor,),

                                                child: SvgPicture.asset(
                                                  p2pRightArrow,
                                                  color: viewModel
                                                      .activeOnBoard ==
                                                      0
                                                      ? themeSupport().isSelectedDarkMode()?lightCardColor:lightCardColor
                                                      : viewModel.activeOnBoard ==
                                                      (viewModel
                                                          .noOfOnBoard -
                                                          1)
                                                      ? themeSupport().isSelectedDarkMode()?contentFontColor:hintTextColor
                                                      : lightCardColor,
                                                ),
                                              )

                                          ),

                                        ],)

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
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

  void nextPage(int page) {
    _pageController!.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage(int page) {
    _pageController!.animateToPage(page,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Widget buildWelcome() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.welcomeP2P,
              color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
              fontWeight: FontWeight.w600,
              fontsize: 16,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      referCancel,
                      height: 10.45,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor,
                    ))
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      p2pWelcomestep1,
                      height: MediaQuery.of(context).size.width / 2.1,
                    ),
                  ],
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.selectAd,
                  fontWeight: FontWeight.w600,
                  fontsize: 25,
                  align: TextAlign.center,
                  color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.p2pStep1,
                  fontWeight: FontWeight.w400,
                  fontsize: 16,
                  align: TextAlign.center,
                  color: themeSupport().isSelectedDarkMode()?contentFontColor:hintTextColor,
                ),
                // CustomSizedBox(
                //   height: 0.01,
                // ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBuyCrypto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.welcomeP2P,
              color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
              fontWeight: FontWeight.w600,
              fontsize: 16,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      referCancel,
                      height: 10.45,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor,
                    ))
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      p2pWelcomestep2,
                      height: MediaQuery.of(context).size.width / 2.1,
                    ),
                  ],
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.completeBankPayment,
                  fontWeight: FontWeight.w600,
                  fontsize: 25,
                  align: TextAlign.center,
                  color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.p2pStep2,
                  fontWeight: FontWeight.w400,
                  fontsize: 16,
                  align: TextAlign.center,
                  color: themeSupport().isSelectedDarkMode()?contentFontColor:hintTextColor,
                ),
                // CustomSizedBox(
                //   height: 0.01,
                // ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDoAndDont() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.welcomeP2P,
              color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
              fontWeight: FontWeight.w600,
              fontsize: 16,
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      referCancel,
                      height: 10.45,
                      color: themeSupport().isSelectedDarkMode()
                          ? lightCardColor
                          : darkScaffoldColor,
                    ))
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      p2pWelcomestep3,
                      //height: MediaQuery.of(context).size.width / 2.1,
                    ),
                  ],
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.receiveCrypto,
                  fontWeight: FontWeight.w600,
                  fontsize: 25,
                  align: TextAlign.center,
                  color: themeSupport().isSelectedDarkMode()?lightCardColor:darkScaffoldColor,
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.p2pStep3,
                  fontWeight: FontWeight.w400,
                  fontsize: 16,
                  align: TextAlign.center,
                  color: themeSupport().isSelectedDarkMode()?contentFontColor:hintTextColor,
                ),
                CustomSizedBox(
                  height: 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      fillColor: themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor,
                        blurRadius: 0,
                        spreadRadius: 0,
                        text: stringVariables.tradeNow,
                        color:
                        themeSupport().isSelectedDarkMode() ?  lightCardColor:lightCardColor,
                        press: () {
                          Navigator.pop(context, true);
                        },
                        radius: 15,
                        buttoncolor: Colors.transparent,
                        width: MediaQuery.of(context).size.width / 120,
                        height: MediaQuery.of(context).size.height / 43,
                        isBorderedButton: false,
                        maxLines: 1,
                        icons: false,
                        multiClick: true,
                        icon: null),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );


  }

  Widget buildPoints(String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              height: 0.003,
            ),
            Row(
              children: [
                CustomSizedBox(
                  width: 0.003,
                ),
                buildDiamond(),
              ],
            ),
          ],
        ),
        CustomSizedBox(
          width: 0.015,
        ),
        CustomContainer(
          width: 1.15,
          child: CustomText(
            fontfamily: 'InterTight',
            text: content,
            fontWeight: FontWeight.w400,
            fontsize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildDoAndDontPoints(bool dos, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: dos ? 5 : 0, left: dos ? 5 : 0, right: dos ? 5 : 0),
          child: SvgPicture.asset(
            dos ? p2pAlert : p2pError,
            height: dos ? 22.5 : 35,
          ),
        ),
        Column(
          children: [
            CustomSizedBox(
              height: 0.005,
            ),
            CustomContainer(
              width: 1.25,
              child: CustomText(
                fontfamily: 'InterTight',
                text: content,
                fontWeight: FontWeight.w400,
                fontsize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBuyCryptoCard() {
    return CustomContainer(
      height: 7,
      width: 1,
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    p2pPlaceOrder,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    text: stringVariables.placeOrder,
                    fontWeight: FontWeight.w700,
                    fontsize: 10,
                    color: hintLight,
                  ),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    p2pForward,
                  ),
                  CustomSizedBox(
                    height: 0.025,
                  )
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    p2pMakePayment,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    text: stringVariables.makePayment,
                    fontWeight: FontWeight.w700,
                    fontsize: 10,
                    color: hintLight,
                  ),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    p2pForward,
                  ),
                  CustomSizedBox(
                    height: 0.025,
                  )
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    p2pReceiveCrypto,
                  ),
                  CustomText(
                    fontfamily: 'InterTight',
                    text: stringVariables.receiveCrypto,
                    fontWeight: FontWeight.w700,
                    fontsize: 10,
                    color: hintLight,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDiamond() {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationZ(
          math.pi / 4,
        ),
        child: CustomContainer(
          width: 70,
          height: 140,
          decoration: BoxDecoration(
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context, int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomContainer(
          height: 120,
          width: currentIndex == index ?15:60,
          decoration: BoxDecoration(
            color: currentIndex == index ? themeSupport().isSelectedDarkMode()?darkThemeColor:themeColor :themeSupport().isSelectedDarkMode()?minusDarkColor:minusLightColor,
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        CustomSizedBox(
          width: 0.015,
        )
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      // add scale animation
      child: child,
    );
  }

 // int containerHeight() {
 //   for ( index = 0; index < items.length; index++){
 //     index == 2? 2:0;
 //   }
 //   print("index$index");
 //    return index;
 //  }

}

class CustomWidgetSlider extends StatefulWidget {
  final List<Widget> items;
  final PageController? pageController;
  final ValueChanged<int> onPageChanged;
  final int activePage;
  final double height;

  CustomWidgetSlider({
    Key? key,
    required this.items,
    required this.height,
    required this.pageController,
    required this.onPageChanged,
    required this.activePage,
  }) : super(key: key);

  @override
  State<CustomWidgetSlider> createState() => _CustomWidgetSliderState();
}

class _CustomWidgetSliderState extends State<CustomWidgetSlider> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomContainer(
      height: widget.height,
      width: 1,
      child: PageView.builder(
          padEnds: false,
          itemCount: widget.items.length,
          pageSnapping: true,
          controller: widget.pageController,
          onPageChanged: widget.onPageChanged,
          itemBuilder: (context, pagePosition) {
            return widget.items[pagePosition];
          }),
    );
  }
}

