import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';

class P2PImageViewModal extends ModalRoute {
  late BuildContext context;
  late String image;

  P2PImageViewModal(BuildContext context, String image) {
    this.context = context;
    this.image = image;
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
    Size size = MediaQuery.of(context).size;
    bool isEncoded = !image.contains("http");
    if(image.contains("base64")) {
      image = image.split(',').last;
    }
    return WillPopScope(
      onWillPop: pop,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width / 10),
                      child: Center(
                        child: CustomContainer(
                          constraints:
                              BoxConstraints(maxHeight: size.height / 1.2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: themeSupport().isSelectedDarkMode()
                                ? card_dark
                                : white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width / 35),
                            child: !isEncoded
                                ? CustomNetworkImage(
                                    image: image,
                                  )
                                : Image.memory(
                                    gaplessPlayback: true,
                                    fit: BoxFit.cover,
                                    base64.decode(image),
                                  ),
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
