import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../model/FeedbackModel.dart';

class P2PLeaveCommentsModel extends ModalRoute {
  late P2POrderCreationViewModel viewModel;
  late BuildContext context;
  bool fromFeedback = false;

  P2PLeaveCommentsModel(BuildContext context, [bool fromFeedback = false]) {
    this.context = context;
    this.fromFeedback = fromFeedback;
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
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
    viewModel = context.watch<P2POrderCreationViewModel>();
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
                  onTap: () {
                    Navigator.pop(context);
                    if (viewModel.p2pFeedback == null) {
                      Future.delayed(Duration(milliseconds: 50), () {
                        viewModel.setIsRated(null);
                      });
                    }
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
                        height: 2.15,
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
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          if (viewModel.p2pFeedback == null) {
                                            Future.delayed(
                                                Duration(milliseconds: 50), () {
                                              viewModel.setIsRated(null);
                                            });
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: hintLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomText(
                                    fontfamily: 'GoogleSans',
                                    text: stringVariables.tradingExperience,
                                    fontsize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  buildRatingView(size)
                                ],
                              ),
                              Column(
                                children: [
                                  CustomElevatedButton(
                                      buttoncolor: viewModel.cmtText.isEmpty
                                          ? grey
                                          : themeColor,
                                      color: viewModel.cmtText.isEmpty
                                          ? hintLight
                                          : black,
                                      press: () {
                                        if (viewModel.cmtText.isNotEmpty) {
                                          Navigator.pop(context);
                                          if(viewModel.p2pFeedback == null) {
                                            viewModel.addFeedback();
                                          } else {
                                            FeedbackData feedbackData =
                                                viewModel.p2pFeedback?.data?.where((element) => element.userId == viewModel.userId).first ??
                                                    FeedbackData();
                                            bool cmtEdited = feedbackData.feedback != viewModel.cmtText;
                                            bool ratingEdited = viewModel.isRated != (feedbackData.feedbackType == stringVariables.positive.toLowerCase());
                                            if(cmtEdited || ratingEdited) {
                                              fromFeedback ? viewModel.editFeedback() :
                                              viewModel.editFeedback(1);
                                            } else {
                                              moveToFeedbackView(context);
                                            }
                                          }
                                        }
                                      },
                                      width: 1,
                                      isBorderedButton: true,
                                      maxLines: 1,
                                      icon: null,
                                      multiClick: true,
                                      text: stringVariables.leaveComments,
                                      radius: 25,
                                      height: size.height / 50,
                                      icons: false,
                                      blurRadius: 0,
                                      fontSize: 16,
                                      spreadRadius: 0,
                                      offset: Offset(0, 0)),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom)),
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

  Widget ratingCard(Size size, bool isPositive, Color color, String title) {
    return GestureDetector(
      onTap: () {
        if (viewModel.isRated != null) {
          if (viewModel.isRated == isPositive)
            viewModel.setIsRated(null);
          else
            viewModel.setIsRated(isPositive);
        } else {
          viewModel.setIsRated(isPositive);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
        padding: 1.5,
        child: Row(
          children: [
            CustomCard(
                radius: 50,
                color: themeSupport().isSelectedDarkMode() ? white70 : null,
                child: CustomContainer(
                  width: 12,
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        isPositive ? p2pThumbPositive : p2pThumbNegative,
                        height: 18,
                        color: color,
                      ),
                    ],
                  ),
                ),
                elevation: 5,
                edgeInsets: 0,
                outerPadding: 0),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              text: title,
              fontfamily: 'GoogleSans',
              softwrap: true,
              fontWeight: FontWeight.w500,
              fontsize: 14,
              color: (color == hintLight.withOpacity(0.8))
                  ? themeSupport().isSelectedDarkMode()
                      ? white
                      : black
                  : themeSupport().isSelectedDarkMode()
                      ? black
                      : white,
            ),
          ],
        ),
        width: 2.65,
        decoration: BoxDecoration(
          color: (color == hintLight.withOpacity(0.8)) ? black12 : color,
          borderRadius: BorderRadius.circular(
            500.0,
          ),
        ),
      ),
    );
  }

  Widget buildRatingView(Size size) {
    bool? isRated = viewModel.isRated;
    return Column(
      children: [
        CustomContainer(
          width: 1.25,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ratingCard(
                  size,
                  true,
                  (isRated ?? false) ? green : hintLight.withOpacity(0.8),
                  stringVariables.positive),
              ratingCard(
                  size,
                  false,
                  (isRated ?? true) ? hintLight.withOpacity(0.8) : red,
                  stringVariables.negative)
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          color: switchBackground.withOpacity(0.1),
          maxLength: 500,
          size: 30,
          hintColor: switchBackground,
          maxLines: 5,
          minLines: 5,
          controller: viewModel.cmtController,
          autovalid: AutovalidateMode.onUserInteraction,
          isContentPadding: true,
        ),
      ],
    );
  }

  Widget buildTipLines(Size size, String content) {
    return Row(
      children: [
        CustomSizedBox(
          width: 0.075,
        ),
        CustomContainer(
          constraints: BoxConstraints(maxWidth: size.width / 1.3),
          child: CustomText(
            text: content,
            fontfamily: 'GoogleSans',
            softwrap: true,
            fontWeight: FontWeight.w400,
            fontsize: 14,
          ),
        ),
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
