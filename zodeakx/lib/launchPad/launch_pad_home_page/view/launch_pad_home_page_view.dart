import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/launchPad/launch_pad_home_page/view/tool_tip_dialog.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../common_view/view_model/launch_pad_commom_view_model.dart';
import '../model/fetch_projects_model.dart';
import '../model/project_commitedData_model.dart';
import '../view_model/launch_pad_home_page_view_model.dart';

class LaunchPadHomePageView extends StatefulWidget {
  const LaunchPadHomePageView({Key? key}) : super(key: key);

  @override
  State<LaunchPadHomePageView> createState() => _LaunchPadHomePageViewState();
}

class _LaunchPadHomePageViewState extends State<LaunchPadHomePageView> {
  late LaunchPadHomePageViewModel viewModel;
  late MarketViewModel marketViewModel;
  late WalletViewModel walletViewModel;

  @override
  void initState() {
    // TODO: implement initState
    viewModel = Provider.of<LaunchPadHomePageViewModel>(context, listen: false);
    viewModel.fetchBannerData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<LaunchPadHomePageViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    return Provider<LaunchPadHomePageViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return showHomePage(
          context,
        );
      },
    );
  }

  Widget showHomePage(BuildContext context) {
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
        edgeInsets: 10,
        elevation: 0,
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : CustomContainer(
                height: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [header(), buildProjects()],
                  ),
                ),
              ),
      ),
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
          text: stringVariables.homePageHeader,
          fontsize: 18,
          fontWeight: FontWeight.bold,
          strutStyleHeight: 2,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.homePageSubHeader,
          fontsize: 13,
          color: stackCardText,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAmountView(
                    trimDecimalsForBalance('${viewModel.currentFundLocked}'),
                    '${stringVariables.currentFundLocked}',
                    true),
                CustomSizedBox(
                  height: 0.02,
                ),
                buildAmountView('${viewModel.projectsLaunched}',
                    '${stringVariables.projectsLaunched}', false),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAmountView(
                    trimDecimalsForBalance('${viewModel.totalFundsRaised}'),
                    '${stringVariables.totalFundsRaised}',
                    true),
                CustomSizedBox(
                  height: 0.02,
                ),
                buildAmountView('${viewModel.uniQueParticipants}',
                    '${stringVariables.uniQueParticipants}', false),
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.025,
        ),
        CustomText(
          text: stringVariables.launchPad,
          fontWeight: FontWeight.w600,
          fontsize: 17,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
      ],
    );
  }

  Widget buildAmountView(String amount, String title, bool symbol) {
    String fiatCurrency = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: symbol == false ? '${amount}' : '$currencySymbol${amount}',
          fontsize: 13,
          fontWeight: FontWeight.bold,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: '${title}',
          fontsize: 12,
          color: stackCardText,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget buildProjects() {
    List<Datum> fetchProject = viewModel.fetchProjects?.result?.data ?? [];
    int itemCount = fetchProject.length >= 3 ? 3 : fetchProject.length;
    bool addMore = itemCount != (viewModel.fetchProjects?.result?.total ?? 0);
    List<FetchCommitedData> fetchProjectCommitedDatas =
        viewModel.fetchProjectCommitedDatas?.result ?? [];
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
                        Provider.of<LaunchPadCommonViewModel>(context,
                                listen: false)
                            .setActive(1);
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
                                                    : launchpadFinished)
                                            // FadeInImage.assetNetwork(
                                            //   image: getImage(
                                            //       marketViewModel,
                                            //       walletViewModel,
                                            //       '${datum.holdingCurrency}'),
                                            //   placeholder: splash,
                                            // ),
                                            ),
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
      return "PREPARATION PERIOD";
    } else if (text == 'subscription') {
      return "SUBSCRIPTION PERIOD";
    } else if (text == 'allocation') {
      return "REWARD CALCULATION";
    } else if (text == 'completed') {
      return "FINISHED";
    } else if (text == 'active') {
      return "ACTIVE";
    } else {
      return "INACTIVE";
    }
  }

  getActiveStatus(String text) {
    if (text == 'completed') {
      return "FINISHED";
    } else {
      return "INPROGRESS";
    }
  }

  void _showDialog(String holdingCurrency) async {
    final result = await Navigator.of(context)
        .push(ToolTipDialog(context, '${holdingCurrency}'));
  }
}
