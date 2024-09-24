import 'package:flutter/material.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';


import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';

import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';

class GalleryModal extends ModalRoute {
  late Future Function(bool isCamera) imageUpload;
  int type = 0;
  final BuildContext context;



  GalleryModal(this.imageUpload, this.type, this.context);

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

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {

    return Material(
      type: MaterialType.transparency,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35),
                      topLeft: Radius.circular(35),
                    ),
                    color:
                        themeSupport().isSelectedDarkMode() ? card_dark : white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomText(
                          text: stringVariables.chooseAnAction,
                          fontWeight: FontWeight.w500,
                          fontsize: 20,
                        ),
                        CustomSizedBox(
                          height: 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            imageUpload(true);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              CustomText(
                                text: stringVariables.takePhoto,
                                fontWeight: FontWeight.w400,
                                fontsize: 18,
                              ),
                            ],
                          ),
                        ),
                        CustomSizedBox(
                          height: 0.0125,
                        ),
                        GestureDetector(
                          onTap: () {
                            imageUpload(false);
                            Navigator.pop(context);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              CustomText(
                                text: stringVariables.chooseFromGallery,
                                fontWeight: FontWeight.w400,
                                fontsize: 18,
                              ),
                            ],
                          ),
                        ),
                        CustomSizedBox(
                          height: 0.025,
                        ),
                        CustomElevatedButton(
                            press: () {
                              Navigator.pop(context);
                            },
                            text: stringVariables.cancel,
                            radius: 25,
                            buttoncolor: borderColor,
                            isBorderedButton: false,
                            blurRadius: 0,
                            spreadRadius: 0,
                            maxLines: 1,
                            icons: false,
                            icon: null,
                            color: black,
                            multiClick: true,
                            height: 16,
                            width: 1),
                        CustomSizedBox(
                          height: 0.01,
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
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        // add scale animation
        child: child,
      ),
    );
  }
}
