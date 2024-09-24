import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../counter_parties_profile/model/FeedbackDataModel.dart';
import '../../profile/view_model/p2p_profile_view_model.dart';

class P2PProfileFeedbackView extends StatefulWidget {
  const P2PProfileFeedbackView({
    Key? key,
  }) : super(key: key);

  @override
  State<P2PProfileFeedbackView> createState() => _P2POrderCreationViewState();
}

class _P2POrderCreationViewState extends State<P2PProfileFeedbackView>
    with TickerProviderStateMixin {
  late P2PProfileViewModel viewModel;
  late TabController _tabController;

  @override
  void initState() {
    viewModel = Provider.of<P2PProfileViewModel>(context, listen: false);
    int positiveFeedback = viewModel.userCenter?.positive ?? 0;
    int negativeFeedback = viewModel.userCenter?.negative ?? 0;
    viewModel.fetchFeedbackData(positiveFeedback + negativeFeedback);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        viewModel.setTabIndex(_tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setTabIndex(0);
      viewModel.setFeedbackLoading(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PProfileViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider<P2PProfileViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return buildProfileFeedback(size);
      },
    );
  }

  Widget buildProfileFeedback(Size size) {
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: CustomContainer(
          width: 1,
          height: 1,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 35),
                    child: SvgPicture.asset(
                      backArrow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            CustomSizedBox(
              height: 0.02,
            ),
            viewModel.feedbackLoader
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomLoader(),
                      ],
                    ),
                  )
                : buildFeedback(size),
          ],
        ),
      ),
    );
  }

  Widget header() {
    String name = (viewModel.userCenter?.name ?? "") == " "
        ? (constant.userEmail.value.substring(0, 2) +
            "*****." +
            constant.userEmail.value.split(".").last)
        : (viewModel.userCenter?.name ?? "");
    return Row(
      children: [
        CustomCircleAvatar(
          radius: 18,
          backgroundColor: themeSupport().isSelectedDarkMode() ? white : black,
          child: CustomText(
            fontfamily: 'GoogleSans',
            text: name.isNotEmpty ? name[0].toUpperCase() : " ",
            fontWeight: FontWeight.bold,
            fontsize: 16,
            color: themeSupport().isSelectedDarkMode() ? black : white,
          ),
        ),
        CustomSizedBox(
          width: 0.025,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: name,
          fontsize: 18,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget buildFeedback(Size size) {
    int positiveFeedback = viewModel.userCenter?.positive ?? 0;
    int negativeFeedback = viewModel.userCenter?.negative ?? 0;
    return CustomCard(
        radius: 25,
        edgeInsets: 0,
        outerPadding: 0,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(size.width / 35),
          child: Column(
            children: [
              CustomSizedBox(
                height: 0.01,
              ),
              buildTabBar(positiveFeedback, negativeFeedback),
              CustomSizedBox(
                height: 0.01,
              ),
              Divider(),
              CustomSizedBox(
                height: 0.01,
              ),
              CustomContainer(
                  width: 1,
                  height: isSmallScreen(context) ? 1.65 : 1.75,
                  child: buildTabBarView(size)),
            ],
          ),
        ));
  }

  buildTabBarView(Size size) {
    List<Feedbacks>? allFeedbacks = viewModel.feedbackData?.data;
    int allCount = (allFeedbacks ?? []).length;
    List<Feedbacks>? positiveFeedbacks = viewModel.positiveFeedbacks;
    int positiveCount = (positiveFeedbacks ?? []).length;
    List<Feedbacks>? negativeFeedbacks = viewModel.negativeFeedbacks;
    int negativeCount = (negativeFeedbacks ?? []).length;
    return TabBarView(
      controller: _tabController,
      children: [
        allCount != 0
            ? ListView.builder(
                itemCount: allCount,
                itemBuilder: (BuildContext context, int index) {
                  return buildReviewCard(size, allFeedbacks![index]);
                })
            : noRecords(),
        positiveCount != 0
            ? ListView.builder(
                itemCount: positiveCount,
                itemBuilder: (BuildContext context, int index) {
                  return buildReviewCard(size, positiveFeedbacks![index]);
                })
            : noRecords(),
        negativeCount != 0
            ? ListView.builder(
                itemCount: negativeCount,
                itemBuilder: (BuildContext context, int index) {
                  return buildReviewCard(size, negativeFeedbacks![index]);
                })
            : noRecords(),
      ],
    );
  }

  noRecords() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: stringVariables.notFound,
          fontsize: 15,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget buildReviewCard(Size size, Feedbacks feedbacks) {
    String name = feedbacks.name ?? "";
    bool isPostive =
        feedbacks.feedbackType == stringVariables.positive.toLowerCase();
    String modifiedDate = getDateTimeStamp((feedbacks.modifiedDate ??
            DateTime.parse("2023-02-21T14:08:25.811Z").toString())
        .toString());
    String feedback = feedbacks.feedback ?? "";
    return Column(
      children: [
        CustomContainer(
          decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? switchBackground.withOpacity(0.15)
                  : grey,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: themeSupport().isSelectedDarkMode()
                      ? grey
                      : switchBackground)),
          height: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomContainer(
                    width: 12.5,
                    height: 12.5,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: themeColor),
                    child: Center(
                        child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: name.isNotEmpty ? name[0].toUpperCase() : " ",
                      fontWeight: FontWeight.bold,
                      fontsize: 11,
                      color: black,
                    )),
                  ),
                  CustomSizedBox(
                    width: 0.025,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        constraints:
                            BoxConstraints(maxWidth: size.width / 1.75),
                        child: CustomText(
                          fontfamily: 'GoogleSans',
                          text: name,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 15,
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            fontfamily: 'GoogleSans',
                            text: modifiedDate,
                            fontsize: 12,
                            fontWeight: FontWeight.w500,
                            color: hintLight,
                          ),
                          CustomSizedBox(
                            width: 0.015,
                          ),
                          CustomContainer(
                            width: size.width / 1.5,
                            height: 65,
                            color: hintLight,
                          ),
                          CustomSizedBox(
                            width: 0.015,
                          ),
                          CustomContainer(
                            constraints:
                                BoxConstraints(maxWidth: size.width / 2.75),
                            child: CustomText(
                              overflow: TextOverflow.ellipsis,
                              fontfamily: 'GoogleSans',
                              text: feedback,
                              fontsize: 12,
                              fontWeight: FontWeight.w500,
                              color: hintLight,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  CustomCard(
                    outerPadding: 0,
                    edgeInsets: 12.5,
                    radius: 25,
                    elevation: 2.5,
                    child: SvgPicture.asset(
                      isPostive ? p2pThumbPositive : p2pThumbNegative,
                      height: 15,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        )
      ],
    );
  }

  Widget buildTabBar(int positiveFeedback, int negativeFeedback) {
    return CustomContainer(
      padding: 4.5,
      width: 1.2,
      height: 16,
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(
          50.0,
        ),
      ),
      child: TabBar(
        labelPadding: EdgeInsets.zero,
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            50.0,
          ),
          color: themeColor,
        ),
        labelStyle: TextStyle(
            fontFamily: 'GoogleSans',
            fontWeight: FontWeight.w600,
            fontSize: 14),
        labelColor: themeSupport().isSelectedDarkMode() ? black : white,
        unselectedLabelColor: hintLight,
        tabs: [
          Tab(
            text: stringVariables.all,
          ),
          Tab(
            text: stringVariables.positive + "($positiveFeedback)",
          ),
          Tab(
            text: stringVariables.negative + "($negativeFeedback)",
          ),
        ],
      ),
    );
  }
}
