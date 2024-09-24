import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
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
    _pageController = PageController(viewportFraction: 1);
    items = [buildWelcome(), buildBuyCrypto(), buildDoAndDont()];
    viewModel.setActiveOnBoard(0);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        height: isSmallScreen(context) ? 1.65 : 1.75,
                        width: 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                          color: themeSupport().isSelectedDarkMode()
                              ? card_dark
                              : white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: size.width / 35,
                              right: size.width / 35,
                              top: size.width / 35),
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
                                          isSmallScreen(context) ? 2.04 : 2.2,
                                      items: items,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                        Row(
                                          children: [
                                            viewModel.activeOnBoard == 0
                                                ? CustomSizedBox()
                                                : GestureDetector(
                                                    onTap: () {
                                                      if (viewModel
                                                              .activeOnBoard !=
                                                          0) {
                                                        previousPage(viewModel
                                                                .activeOnBoard -
                                                            1);
                                                        viewModel.setActiveOnBoard(
                                                            viewModel
                                                                    .activeOnBoard -
                                                                1);
                                                      }
                                                    },
                                                    child: CustomCircleAvatar(
                                                      backgroundColor: viewModel
                                                                  .activeOnBoard ==
                                                              0
                                                          ? hintLight
                                                          : viewModel.activeOnBoard ==
                                                                  (viewModel
                                                                          .noOfOnBoard -
                                                                      1)
                                                              ? themeColor
                                                              : black,
                                                      child: CustomCircleAvatar(
                                                        radius: 19,
                                                        backgroundColor: viewModel
                                                                    .activeOnBoard ==
                                                                (viewModel
                                                                        .noOfOnBoard -
                                                                    1)
                                                            ? themeColor
                                                            : white,
                                                        child: SvgPicture.asset(
                                                          p2pLeftArrow,
                                                          color: viewModel
                                                                      .activeOnBoard ==
                                                                  0
                                                              ? hintLight
                                                              : viewModel.activeOnBoard ==
                                                                      (viewModel
                                                                              .noOfOnBoard -
                                                                          1)
                                                                  ? white
                                                                  : black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            viewModel.activeOnBoard ==
                                                    (viewModel.noOfOnBoard - 1)
                                                ? CustomSizedBox(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                                : CustomSizedBox(
                                                    width: 0.04,
                                                  ),
                                            viewModel.activeOnBoard ==
                                                    (viewModel.noOfOnBoard - 1)
                                                ? CustomSizedBox(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                                : GestureDetector(
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
                                                    child: CustomCircleAvatar(
                                                      backgroundColor: viewModel
                                                                  .activeOnBoard ==
                                                              (viewModel
                                                                      .noOfOnBoard -
                                                                  1)
                                                          ? hintLight
                                                          : themeColor,
                                                      child: CustomCircleAvatar(
                                                        radius: 19,
                                                        backgroundColor: viewModel
                                                                    .activeOnBoard ==
                                                                (viewModel
                                                                        .noOfOnBoard -
                                                                    1)
                                                            ? white
                                                            : themeColor,
                                                        child: SvgPicture.asset(
                                                          p2pRightArrow,
                                                          color: viewModel
                                                                      .activeOnBoard ==
                                                                  (viewModel
                                                                          .noOfOnBoard -
                                                                      1)
                                                              ? hintLight
                                                              : white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        )
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.welcomeP2P,
          fontWeight: FontWeight.bold,
          fontsize: 18,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      p2pWelcome,
                      height: MediaQuery.of(context).size.width / 2.1,
                    ),
                  ],
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                CustomText(
                  fontfamily: 'GoogleSans',
                  text: stringVariables.welcomeP2PContent1,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                ),
                CustomSizedBox(
                  height: 0.01,
                ),
                CustomText(
                  fontfamily: 'GoogleSans',
                  text: stringVariables.welcomeP2PContent2,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                ),
                CustomSizedBox(
                  height: 0.01,
                ),
                CustomText(
                  fontfamily: 'GoogleSans',
                  text: stringVariables.welcomeP2PContent3,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBuyCrypto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.buyCrypto,
          fontWeight: FontWeight.bold,
          fontsize: 18,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildBuyCryptoCard(),
        CustomSizedBox(
          height: 0.02,
        ),
        buildPoints(stringVariables.buyCryptoContent1),
        CustomSizedBox(
          height: 0.02,
        ),
        buildPoints(stringVariables.buyCryptoContent2),
        CustomSizedBox(
          height: 0.02,
        ),
        buildPoints(stringVariables.buyCryptoContent3),
        CustomSizedBox(
          height: 0.02,
        ),
        buildPoints(stringVariables.buyCryptoContent4),
      ],
    );
  }

  Widget buildDoAndDont() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.p2pDoAndDont,
          fontWeight: FontWeight.bold,
          fontsize: 18,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDoAndDontPoints(true, stringVariables.doAndDontContent1),
                CustomSizedBox(
                  height: 0.02,
                ),
                buildDoAndDontPoints(true, stringVariables.doAndDontContent2),
                CustomSizedBox(
                  height: 0.02,
                ),
                buildDoAndDontPoints(false, stringVariables.doAndDontContent3),
                CustomSizedBox(
                  height: 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                        blurRadius: 0,
                        spreadRadius: 0,
                        text: stringVariables.tradeNow,
                        color: black,
                        press: () {
                          Navigator.pop(context, true);
                        },
                        radius: 25,
                        buttoncolor: themeColor,
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
            fontfamily: 'GoogleSans',
            text: content,
            fontWeight: FontWeight.w400,
            fontsize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildDoAndDontPoints(bool dos, String content) {
    return Transform.translate(
      offset: Offset(-8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            dos ? p2pAlert : p2pError,
          ),
          Column(
            children: [
              CustomSizedBox(
                height: 0.005,
              ),
              CustomContainer(
                width: 1.25,
                child: CustomText(
                  fontfamily: 'GoogleSans',
                  text: content,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
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
                    fontfamily: 'GoogleSans',
                    text: stringVariables.placeOrder,
                    fontWeight: FontWeight.bold,
                    fontsize: 13,
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
                    fontfamily: 'GoogleSans',
                    text: stringVariables.makePayment,
                    fontWeight: FontWeight.bold,
                    fontsize: 13,
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
                    fontfamily: 'GoogleSans',
                    text: stringVariables.receiveCrypto,
                    fontWeight: FontWeight.bold,
                    fontsize: 13,
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
      children: [
        CustomContainer(
          height: 120,
          width: 60,
          decoration: BoxDecoration(
            color: currentIndex == index ? themeColor : switchBackground,
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
