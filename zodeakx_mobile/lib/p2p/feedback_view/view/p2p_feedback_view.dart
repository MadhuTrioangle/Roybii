import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../order_details_view/model/FeedbackModel.dart';
import '../../order_details_view/view/p2p_leave_comments_bottom_sheet.dart';

class P2PFeedbackView extends StatefulWidget {
  const P2PFeedbackView({
    Key? key,
  }) : super(key: key);

  @override
  State<P2PFeedbackView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PFeedbackView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  TextEditingController address = TextEditingController();
  late FocusNode focusNode;
  GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.leaveFeedbackLocalSocket();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        fieldKey.currentState!.validate();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchFeedback();
      viewModel.getFeedbackLocalSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2POrderCreationViewModel>();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PFeedbackView(size),
      ),
    );
  }

  Widget buildP2PFeedbackView(Size size) {
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 35),
            child: CustomContainer(
              height: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSizedBox(
                      height: 0.02,
                    ),
                    buildUserReviewView(size),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Divider(
                      color: divider,
                      thickness: 0.2,
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    buildCounterReviewView(size),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCounterReviewView(Size size) {
    bool hasFeedback = viewModel.p2pFeedback?.data
            ?.where((element) => element.userId != viewModel.userId)
            .isNotEmpty ??
        false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  text: stringVariables.counterpartyFeedback,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  fontsize: 15,
                ),
              ],
            ),
            hasFeedback
                ? buildCounterPartyReviewView(size)
                : buildNoFeedbackView()
          ],
        ),
      ],
    );
  }

  Widget buildNoFeedbackView() {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.noFeedback,
              fontWeight: FontWeight.w500,
              fontsize: 14,
              color: hintLight,
            ),
          ],
        ),
      ],
    );
  }

  dynamic _showModal(BuildContext context) async {
    final result =
        await Navigator.of(context).push(P2PLeaveCommentsModel(context, true));
  }

  Widget buildUserReviewView(Size size) {
    FeedbackData feedbackData = viewModel.p2pFeedback?.data
            ?.where((element) => element.userId == viewModel.userId)
            .first ??
        FeedbackData();
    String name = feedbackData.name ?? "";
    String date = getDate(feedbackData.modifiedDate.toString());
    bool isPositive =
        feedbackData.feedbackType == stringVariables.positive.toLowerCase();
    Color color = isPositive ? green : red;
    String userComment = feedbackData.feedback ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        CustomContainer(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: themeColor),
                          child: Center(
                              child: CustomText(
                            fontfamily: 'InterTight',
                            text: name.isNotEmpty ? name[0].toUpperCase() : " ",
                            fontWeight: FontWeight.bold,
                            fontsize: 11,
                            color: black,
                          )),
                        ),
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        CustomContainer(
                          constraints:
                              BoxConstraints(maxWidth: size.width / 2.4),
                          child: CustomText(
                            fontfamily: 'InterTight',
                            text: name,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomContainer(
                      width: 15,
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      fontfamily: 'InterTight',
                      text: date,
                      fontWeight: FontWeight.w500,
                      fontsize: 14,
                      color: hintLight,
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  isPositive ? p2pThumbPositive : p2pThumbNegative,
                  height: 18,
                  color: color,
                ),
                CustomSizedBox(
                  width: 0.02,
                )
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              width: 15,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              width: 1.35,
              child: CustomText(
                fontfamily: 'InterTight',
                text: userComment,
                fontWeight: FontWeight.bold,
                fontsize: 14,
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomText(
              press: () {
                _showModal(context);
              },
              fontfamily: 'InterTight',
              text: stringVariables.editFeedback,
              fontWeight: FontWeight.w500,
              fontsize: 14,
              color: themeColor,
            ),
            CustomSizedBox(
              width: 0.02,
            )
          ],
        )
      ],
    );
  }

  Widget buildCounterPartyReviewView(Size size) {
    FeedbackData feedbackData = viewModel.p2pFeedback?.data
            ?.where((element) => element.userId != viewModel.userId)
            .first ??
        FeedbackData();
    String name = feedbackData.name ?? "";
    String date = getDate(feedbackData.modifiedDate.toString());
    bool isPositive =
        feedbackData.feedbackType == stringVariables.positive.toLowerCase();
    Color color = isPositive ? green : red;
    String userComment = feedbackData.feedback ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        CustomContainer(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: themeColor),
                          child: Center(
                              child: CustomText(
                            fontfamily: 'InterTight',
                            text: name.isNotEmpty ? name[0].toUpperCase() : " ",
                            fontWeight: FontWeight.bold,
                            fontsize: 11,
                            color: black,
                          )),
                        ),
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        CustomContainer(
                          constraints:
                              BoxConstraints(maxWidth: size.width / 2.4),
                          child: CustomText(
                            fontfamily: 'InterTight',
                            text: name,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomContainer(
                      width: 15,
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      fontfamily: 'InterTight',
                      text: date,
                      fontWeight: FontWeight.w500,
                      fontsize: 14,
                      color: hintLight,
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  isPositive ? p2pThumbPositive : p2pThumbNegative,
                  height: 18,
                  color: color,
                ),
                CustomSizedBox(
                  width: 0.02,
                )
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              width: 15,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              width: 1.35,
              child: CustomText(
                fontfamily: 'InterTight',
                text: userComment,
                fontWeight: FontWeight.bold,
                fontsize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: buildHeader(size));
  }

  Widget buildHeader(Size size) {
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: CustomContainer(
                      padding: 7.5,
                      width: 12,
                      height: 24,
                      child: SvgPicture.asset(
                        backArrow,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.feedback,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.bold,
              fontsize: 20,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}
