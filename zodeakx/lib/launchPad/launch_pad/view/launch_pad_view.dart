import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../common_view/view_model/launch_pad_commom_view_model.dart';
import '../../launch_pad_home_page/model/fetch_projects_model.dart';
import '../../launch_pad_home_page/model/project_commitedData_model.dart';
import '../../launch_pad_home_page/view/tool_tip_dialog.dart';
import '../../launch_pad_home_page/view_model/launch_pad_home_page_view_model.dart';
import '../view_model/lauch_pad_view_model.dart';

class LaunchPadView extends StatefulWidget {
  const LaunchPadView({Key? key}) : super(key: key);

  @override
  State<LaunchPadView> createState() => _LaunchPadViewState();
}

class _LaunchPadViewState extends State<LaunchPadView> {
  late LaunchPadViewModel viewModel;
  late LaunchPadHomePageViewModel launchPadHomePageViewModel;
  late MarketViewModel marketViewModel;
  late WalletViewModel walletViewModel;

  @override
  void initState() {
    // TODO: implement initState
    launchPadHomePageViewModel =
        Provider.of<LaunchPadHomePageViewModel>(context, listen: false);
    launchPadHomePageViewModel.fetchProject(0);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    launchPadHomePageViewModel = context.watch<LaunchPadHomePageViewModel>();
    viewModel = context.watch<LaunchPadViewModel>();
    return Provider<LaunchPadViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return showLaunchPadPage(
          context,
        );
      },
    );
  }

  Widget showLaunchPadPage(BuildContext context) {
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
                    Provider.of<LaunchPadCommonViewModel>(context,
                            listen: false)
                        .setActive(0);
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
              ),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxlines: 1,
                  softwrap: true,
                  fontfamily: 'GoogleSans',
                  fontsize: 21,
                  fontWeight: FontWeight.bold,
                  text: stringVariables.launchPad,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: CustomCard(
        radius: 15,
        outerPadding: 10,
        edgeInsets: 15,
        elevation: 0,
        child: CustomContainer(
          height: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [buildProjects()],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProjects() {
    List<Datum> fetchProject =
        launchPadHomePageViewModel.fetchProjects?.result?.data ?? [];
    int itemCount = fetchProject.length;
    bool addMore = itemCount !=
        (launchPadHomePageViewModel.fetchProjects?.result?.total ?? 0);
    List<FetchCommitedData> fetchProjectCommitedDatas =
        launchPadHomePageViewModel.fetchProjectCommitedDatas?.result ?? [];
    int page = (launchPadHomePageViewModel.fetchProjects?.result?.page ?? 0);
    return itemCount != 0
        ? ListView.builder(
            itemCount: itemCount + (addMore ? 1 : 0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Datum datum =
                  addMore && index == itemCount ? Datum() : fetchProject[index];
              List<FetchCommitedData> list = fetchProjectCommitedDatas
                  .where((element) => datum.id == element.projectId)
                  .toList();
              FetchCommitedData fetchCommitedData = list.isNotEmpty
                  ? fetchProjectCommitedDatas
                      .where((element) => datum.id == element.projectId)
                      .toList()
                      .first
                  : FetchCommitedData();
              num exchangeRate =
                  ((datum.price ?? 0) * ((datum.exchangeRate ?? 0)));
              return addMore && index == itemCount
                  ? GestureDetector(
                      onTap: () {
                        launchPadHomePageViewModel.fetchProject(page);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            fontfamily: 'GoogleSans',
                            text: stringVariables.more,
                            fontsize: 16,
                            fontWeight: FontWeight.w400,
                            color: themeColor,
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        moveToProjectDetail(context, datum.id ?? "");
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CustomContainer(
                              height: 3.5,
                              width: 1,
                              child: CustomNetworkImage(
                                fit: BoxFit.cover,
                                image: '${datum.projectLogo}',
                              ),
                            ),
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CustomContainer(
                                    width: 3.2,
                                    height: 25,
                                    color: themeSupport().isSelectedDarkMode()
                                        ? black
                                        : grey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(finish),
                                        CustomSizedBox(
                                          width: 0.02,
                                        ),
                                        CustomText(
                                          text: getActiveStatus(
                                              '${datum.projectStatus}'),
                                          fontsize: 11,
                                          color: green,
                                        )
                                      ],
                                    )),
                              ),
                              CustomSizedBox(
                                width: 0.02,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CustomContainer(
                                    width:
                                        ('${datum.projectStatus}' == "active" ||
                                                '${datum.projectStatus}' ==
                                                    "inactive" ||
                                                '${datum.projectStatus}' ==
                                                    "completed")
                                            ? 3.5
                                            : 2,
                                    height: 25,
                                    color: themeSupport().isSelectedDarkMode()
                                        ? black
                                        : grey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomCircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.transparent,
                                            child: SvgPicture.asset(
                                                '${datum.projectStatus}' ==
                                                        "holding"
                                                    ? launchpadInprogress
                                                    : launchpadFinished)),
                                        CustomSizedBox(
                                          width: 0.01,
                                        ),
                                        CustomText(
                                          text: getStatus(
                                            '${datum.projectStatus}',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          softwrap: true,
                                          maxlines: 1,
                                          color: '${datum.projectStatus}' ==
                                                  "holding"
                                              ? red
                                              : green,
                                          fontsize: 11,
                                        ),
                                        CustomSizedBox(
                                          width: 0.01,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              _showDialog(
                                                  '${datum.holdingCurrency}');
                                            },
                                            child: SvgPicture.asset(toolTip)),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          CustomText(
                            text: '${datum.projectName}',
                            fontsize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomSizedBox(
                            height: 0.015,
                          ),
                          CustomText(
                            text: '${datum.description}',
                            fontsize: 12,
                            color: stackCardText,
                          ),
                          CustomSizedBox(
                            height: 0.015,
                          ),
                          buildDetailsView(stringVariables.tokensOffered,
                              '${datum.tokensOffered}' + ' ${datum.token}'),
                          buildDetailsView(
                              stringVariables.salePrice,
                              "1 " +
                                  '${datum.token}' +
                                  " = " +
                                  trimDecimalsForBalance(
                                      exchangeRate.toString()) +
                                  ' ${datum.holdingCurrency}'),
                          buildDetailsView(stringVariables.participants,
                              '${fetchCommitedData.noOfParticipants ?? 0}'),
                          buildDetailsView(
                              stringVariables.totalCommitted,
                              '${fetchCommitedData.commitedValue ?? 0}' +
                                  ' ${datum.holdingCurrency}'),
                          buildDetailsView(stringVariables.endTime,
                              getDate('${datum.tokenDistribution}')),
                          CustomSizedBox(
                            height: 0.03,
                          ),
                        ],
                      ),
                    );
            })
        : buildNoRecord();
  }

  Widget buildNoRecord() {
    return Center(
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.04,
          ),
          SvgPicture.asset(
            notFound,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            fontsize: 20,
            fontWeight: FontWeight.bold,
            text: stringVariables.notFound,
            color: hintLight,
          ),
        ],
      ),
    );
  }

  Widget buildDetailsView(String title, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              fontsize: 13,
              color: stackCardText,
            ),
            CustomText(
              text: (value),
              fontsize: 15,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
    );
  }

  getStatus(String text) {
    if (text == 'holding') {
      return stringVariables.preparationPeriod.toUpperCase();
    } else if (text == 'subscription') {
      return stringVariables.subscriptionPeriod.toUpperCase();
    } else if (text == 'allocation') {
      return stringVariables.rewardCal.toUpperCase();
    } else if (text == 'completed') {
      return stringVariables.finish.toUpperCase();
    } else if (text == 'active') {
      return stringVariables.active.toUpperCase();
    } else {
      return stringVariables.inActive.toUpperCase();
    }
  }

  getActiveStatus(String text) {
    if (text == 'completed') {
      return stringVariables.finish.toUpperCase();
    } else {
      return stringVariables.inprocess.toUpperCase();
    }
  }

  void _showDialog(String holdingCurrency) async {
    final result = await Navigator.of(context)
        .push(ToolTipDialog(context, '${holdingCurrency}'));
  }
}
