import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/p2p/ads/view_model/p2p_ads_view_model.dart';

import '../../../Common/IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class P2PAdsOptionsModal extends ModalRoute {
  late P2PAdsViewModel viewModel;
  late IdentityVerificationCommonViewModel identityVerificationCommonViewModel;
  late BuildContext context;
  late String id;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  P2PAdsOptionsModal(BuildContext context, String id) {
    this.context = context;
    this.id = id;
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

  buildTextWithIcon(IconData icon, String title, VoidCallback onPressed,
      [bool divider = true, Color? color]) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                text: title,
                fontWeight: FontWeight.w500,
                fontsize: 16,
                color: color,
              ),
            ],
          ),
        ),
        divider
            ? Column(
                children: [
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  Divider(),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                ],
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
      ],
    );
  }

  takeToEditAd() {
    bool tfaStatus =
        identityVerificationCommonViewModel.viewModelVerification?.tfaStatus ==
            'verified';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (tfaStatus) {
      moveToEditAnAdView(context, id);
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.enableTfa, SnackbarType.negative);
    }
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<P2PAdsViewModel>();
    identityVerificationCommonViewModel =
        context.watch<IdentityVerificationCommonViewModel>();
    return WillPopScope(
      onWillPop: pop,
      child: Provider(
        create: (context) => viewModel,
        child: Material(
          type: MaterialType.transparency,
          child: ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: CustomScaffold(
              color: Colors.transparent,
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
                            height: isSmallScreen(context) ? 3.25 : 3.75,
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
                                  left: size.width / 25,
                                  right: size.width / 25,
                                  top: size.width / 35),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        fontfamily: 'GoogleSans',
                                        text: stringVariables.moreActions,
                                        fontWeight: FontWeight.bold,
                                        fontsize: 18,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  Divider(),
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  buildTextWithIcon(
                                      Icons.edit, stringVariables.editDetail,
                                      () async {
                                    Navigator.pop(context);
                                    if (identityVerificationCommonViewModel
                                            ?.viewModelVerification
                                            ?.kyc
                                            ?.kycStatus ==
                                        "verified") {
                                      await identityVerificationCommonViewModel
                                          ?.getIdVerification();
                                      takeToEditAd();
                                    } else {
                                      moveToTradingRequirement(context);
                                    }
                                  }),
                                  buildTextWithIcon(
                                      Icons.remove_red_eye_outlined,
                                      stringVariables.viewMoreDetails, () {
                                    Navigator.pop(context);
                                    moveToAdsDetailsView(context, id);
                                  }),
                                  buildTextWithIcon(
                                      Icons.close, stringVariables.close,
                                      () async {
                                    await identityVerificationCommonViewModel
                                        .getIdVerification();
                                    bool tfaStatus =
                                        identityVerificationCommonViewModel
                                                .viewModelVerification
                                                ?.tfaStatus ==
                                            'verified';
                                    if (tfaStatus) {
                                      viewModel.setCancelId(id);
                                      Navigator.pop(context);
                                      moveToVerifyCode(
                                          context,
                                          AuthenticationVerificationType
                                              .CloseAd);
                                    } else {
                                      scaffoldMessengerKey.currentState
                                          ?.removeCurrentSnackBar();
                                      scaffoldMessengerKey.currentState
                                          ?.showSnackBar(SnackBar(
                                        content: CustomText(
                                          text: stringVariables.enableTfa,
                                          color: white,
                                        ),
                                        backgroundColor: red,
                                        behavior: SnackBarBehavior.fixed,
                                        duration: Duration(seconds: 3),
                                      ));
                                    }
                                  }, false, red),
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
        ),
      ),
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
