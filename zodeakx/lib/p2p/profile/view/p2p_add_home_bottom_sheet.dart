import 'package:flutter/material.dart';
import 'package:flutter_pinned_shortcut/flutter_pinned_shortcut.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../view_model/p2p_profile_view_model.dart';

class P2PAddHomeModel extends ModalRoute {
  late P2PProfileViewModel viewModel;
  late BuildContext context;
  final FlutterPinnedShortcut flutterPinnedShortcutPlugin = FlutterPinnedShortcut();

  P2PAddHomeModel(BuildContext context) {
    this.context = context;
    viewModel = Provider.of<P2PProfileViewModel>(context, listen: false);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

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
    viewModel = context.watch<P2PProfileViewModel>();
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        height: 2.4,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  CustomText(
                                    fontfamily: 'GoogleSans',
                                    text: stringVariables.addHomeScreenTitle,
                                    fontsize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  CustomText(
                                    fontfamily: 'GoogleSans',
                                    text: stringVariables.addHomeScreenContent,
                                    fontsize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  buildAddHomeCard(size),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomElevatedButton(
                                          buttoncolor: switchBackground,
                                          color: black,
                                          press: () {
                                            Navigator.pop(context);
                                          },
                                          width: 2.25,
                                          isBorderedButton: true,
                                          maxLines: 1,
                                          icon: null,
                                          multiClick: true,
                                          text: stringVariables.cancel,
                                          radius: 25,
                                          height: size.height / 50,
                                          icons: false,
                                          fontSize: 16,
                                          blurRadius: 0,
                                          spreadRadius: 0,
                                          offset: Offset(0, 0)),
                                      CustomElevatedButton(
                                          buttoncolor: themeColor,
                                          color: black,
                                          press: addPinnedShortcut,
                                          width: 2.25,
                                          isBorderedButton: true,
                                          maxLines: 1,
                                          icon: null,
                                          multiClick: true,
                                          text: stringVariables.add,
                                          radius: 25,
                                          height: size.height / 50,
                                          icons: false,
                                          blurRadius: 0,
                                          fontSize: 16,
                                          spreadRadius: 0,
                                          offset: Offset(0, 0)),
                                    ],
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
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

  void addPinnedShortcut() {
    Navigator.pop(context);
    flutterPinnedShortcutPlugin.createPinnedShortcut(
        id: "1",
        label: "${constant.appName} ${stringVariables.p2p}",
        action: "p2p",
        iconAssetName: p2pIcon
    );
  }

  Widget buildAddHomeCard(
    Size size,
  ) {
    return Column(
      children: [
        CustomContainer(
          decoration: BoxDecoration(
              color:
                  themeSupport().isSelectedDarkMode() ? switchBackground : grey,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: themeSupport().isSelectedDarkMode()
                      ? grey
                      : switchBackground)),
          height: 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    width: 0.05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: "${constant.appName} ${stringVariables.p2p}",
                        fontWeight: FontWeight.bold,
                        fontsize: 20,
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: stringVariables.cross1,
                        fontWeight: FontWeight.w500,
                        fontsize: 18,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCard(
                      outerPadding: 0,
                      edgeInsets: 12.5,
                      radius: 20,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          icon,
                          height: 35,
                        ),
                      )),
                  CustomSizedBox(
                    width: 0.05,
                  )
                ],
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
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
