import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/SplashScreen/ViewModel/SplashViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../model/LaunchpadHistoryModel.dart';
import '../model/UserVoteEarnModel.dart';
import '../model/UserVoteModel.dart';
import '../view_model/launchpad_history_view_model.dart';

class LaunchpadHistoryView extends StatefulWidget {
  const LaunchpadHistoryView({Key? key}) : super(key: key);

  @override
  State<LaunchpadHistoryView> createState() => _LaunchpadHistoryViewState();
}

class _LaunchpadHistoryViewState extends State<LaunchpadHistoryView>
    with SingleTickerProviderStateMixin {
  late LaunchpadHistoryViewModel viewModel;
  late SplashViewModel splashViewModel;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<LaunchpadHistoryViewModel>(context, listen: false);
    _tabController =
        new TabController(length: viewModel.tabs.length, vsync: this);
    splashViewModel = Provider.of<SplashViewModel>(context, listen: false);
    _tabController.addListener(() {
      viewModel.setTabIndex(_tabController.index);
      if (_tabController.animation?.value == _tabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setTabLoading(true);
          if (_tabController.index == 0)
            viewModel.fetchLaunchpadHistory();
          else if (_tabController.index == 1) {
            viewModel.fetchVotingHistory(0);
          } else {
            viewModel.fetchAirdropHistory(0);
          }
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.setTabLoading(true);
      viewModel.setTabIndex(0);
    });
    viewModel.fetchLaunchpadHistory();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<LaunchpadHistoryViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
        create: (context) => viewModel,
        child: CustomScaffold(
            appBar: buildAppBar(), child: buildHistoryView(size)));
  }

  Widget buildHistoryView(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width / 35,
        vertical: size.width / 50,
      ),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 20,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             buildListOfLaunchpad(size),
            // buildTabView(size),
            // buildTabBarView(size)
          ],
        ),
      ),
    );
  }

  Widget buildTabView(Size size) {
    List<String> tabsList = viewModel.tabs;
    List<Widget> tabsItem = [];
    int tabsCount = tabsList.length;
    for (var i = 0; i < tabsCount; i++) {
      tabsItem.add(buildTab(tabsList[i]));
    }
    return CustomContainer(
      height: 30,
      child: Padding(
        padding: EdgeInsets.only(left: size.width / 35),
        child: TabBar(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          labelPadding: EdgeInsets.only(right: size.width / 20),
          indicator: CustomIndicator(color: themeColor, radius: 5),
          unselectedLabelColor:
              themeSupport().isSelectedDarkMode() ? white : black,
          labelColor: themeSupport().isSelectedDarkMode() ? white : black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: tabsItem,
          controller: _tabController,
        ),
      ),
    );
  }

  Widget buildTab(String title) {
    return Tab(
      child: CustomText(
          text: title,
          fontWeight: FontWeight.bold,
          fontsize: 16,
          fontfamily: 'GoogleSans'),
    );
  }

  Widget buildTabBarView(size) {
    return Flexible(
      fit: FlexFit.loose,
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: TabBarView(
          controller: _tabController,
          children: [
            viewModel.tabLoading
                ? Center(child: CustomLoader())
                : buildListOfLaunchpad(size),
            viewModel.tabLoading
                ? Center(child: CustomLoader())
                : buildListOfVoting(size),
            viewModel.tabLoading
                ? Center(child: CustomLoader())
                : buildListOfAirdrop(size),
          ],
        ),
      ),
    );
  }

  Widget buildListOfLaunchpad(Size size) {
    List<LaunchpadHistory> launchpadHistory = viewModel.launchpadHistory;
    int itemCount = launchpadHistory.length;
    return itemCount != 0
        ? ListView.separated(
            padding: EdgeInsets.symmetric(
                vertical: size.width / 25, horizontal: size.width / 25),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.01,
                ),
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              return buildLaunchpadListCard(size, launchpadHistory[index]);
            })
        : buildNoRecord();
  }

  Widget buildListOfVoting(Size size) {
    int itemCount = (viewModel.userVote?.data ?? []).length;
    bool addMore = itemCount !=
        ((viewModel.userVote?.count ?? []).isNotEmpty
            ? (viewModel.userVote?.count?.first.total ?? 0)
            : 0);
    int page = ((viewModel.userVote?.count ?? []).isNotEmpty
        ? (viewModel.userVote?.count?.first.page ?? 0)
        : 0);
    return itemCount != 0
        ? ListView.separated(
            padding: EdgeInsets.symmetric(
                vertical: size.width / 25, horizontal: size.width / 25),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.01,
                ),
            itemCount: itemCount + (addMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              VoteData voteData = addMore && index == itemCount
                  ? VoteData()
                  : (viewModel.userVote?.data?[index] ?? VoteData());
              return addMore && index == itemCount
                  ? GestureDetector(
                      onTap: () {
                        viewModel.fetchVotingHistory(page);
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
                  : buildVotingListCard(size, voteData);
            })
        : buildNoRecord();
  }

  Widget buildListOfAirdrop(Size size) {
    int itemCount = (viewModel.userVoteEarn?.data ?? []).length;
    bool addMore = itemCount != (viewModel.userVoteEarn?.total ?? 0);
    int page = (viewModel.userVoteEarn?.page ?? 0);
    return itemCount != 0
        ? ListView.separated(
            padding: EdgeInsets.symmetric(
                vertical: size.width / 25, horizontal: size.width / 25),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.01,
                ),
            itemCount: itemCount + (addMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              VoteEarnData voteEarnData = addMore && index == itemCount
                  ? VoteEarnData()
                  : (viewModel.userVoteEarn?.data?[index] ?? VoteEarnData());
              return addMore && index == itemCount
                  ? GestureDetector(
                      onTap: () {
                        viewModel.fetchAirdropHistory(page);
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
                  : buildAirdropListCard(size, voteEarnData);
            })
        : buildNoRecord();
  }

  Widget buildLaunchpadListCard(Size size, LaunchpadHistory launchpadHistory) {
    String date = getDate(launchpadHistory.modifiedDate.toString());
    String amount = launchpadHistory.projectName ?? "";
    String allocatedTokenId = launchpadHistory.allocatedTokenId ?? "";
    String commitedTokenId = launchpadHistory.commitedTokenId ?? "";
    String defaultFiat =
        splashViewModel.defaultCurrency?.fiatDefaultCurrency ?? "";
    String type =
        launchpadHistory.commitedAmount.toString() + " $commitedTokenId";
    String price = launchpadHistory.price.toString() + " $defaultFiat";
    String detected =
        launchpadHistory.deductedAmount.toString() + " $commitedTokenId";
    String tokensPurchased =
        launchpadHistory.allocatedToken.toString() + " $allocatedTokenId";
    String status = launchpadHistory.status ?? "";
    return Column(
      children: [
        buildTextForHistory(stringVariables.date, date),
        buildTextForHistory(stringVariables.project, amount),
        buildTextForHistory(stringVariables.commitedAmount, type),
        buildTextForHistory(stringVariables.price, price),
        buildTextForHistory(stringVariables.deducted, detected),
        buildTextForHistory(stringVariables.tokensPurchased, tokensPurchased),
        buildTextForHistory(stringVariables.status, capitalize(status)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: Divider(),
        ),
        CustomSizedBox(
          height: 0.005,
        ),
      ],
    );
  }

  Widget buildVotingListCard(Size size, VoteData voteData) {
    String votingTime = getDate(voteData.createdAt.toString());
    String project = voteData.projectName ?? "";
    String ticker = voteData.currency ?? "";
    int numberOfVotes = voteData.noOfVotes ?? 0;
    return Column(
      children: [
        buildTextForHistory(stringVariables.votingTime, votingTime),
        buildTextForHistory(stringVariables.project, project),
        buildTextForHistory(stringVariables.ticker, ticker),
        buildTextForHistory(stringVariables.numberOfVotes,
            "$numberOfVotes ${stringVariables.votes}"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: Divider(),
        ),
        CustomSizedBox(
          height: 0.005,
        ),
      ],
    );
  }

  Widget buildAirdropListCard(Size size, VoteEarnData voteEarnData) {
    String votingTime = getDate(voteEarnData.createdAt.toString());
    String project = voteEarnData.projectName ?? "";
    String currency = voteEarnData.rewardCurrencyCode ?? "";
    int numberOfVotes = voteEarnData.noOfVotes ?? 0;
    num reward = voteEarnData.rewardAmount ?? 0;
    return Column(
      children: [
        buildTextForHistory(currency, votingTime, true),
        buildTextForHistory(stringVariables.project, project),
        buildTextForHistory(stringVariables.airdropAmount,
            trimDecimalsForBalance(reward.toString())),
        buildTextForHistory(stringVariables.numberOfVotes,
            "$numberOfVotes ${stringVariables.votes}"),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: Divider(),
        ),
        CustomSizedBox(
          height: 0.005,
        ),
      ],
    );
  }

  Widget buildTextForHistory(String content1, String content2,
      [bool highlight = false]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
                text: content1,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
                fontsize: 16,
                color: highlight ? null : textGrey,
                fontfamily: 'GoogleSans'),
            CustomText(
                text: content2,
                fontWeight: FontWeight.w500,
                fontsize: 16,
                fontfamily: 'GoogleSans')
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        )
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      maxlines: 1,
                      softwrap: true,
                      fontfamily: 'GoogleSans',
                      fontsize: 21,
                      fontWeight: FontWeight.bold,
                      text: stringVariables.history_orders,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoRecord() {
    return Center(
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.06,
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
}

class CustomIndicator extends Decoration {
  final BoxPainter _painter;

  CustomIndicator({required Color color, required double radius})
      : _painter = _CustomIndicator(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
//   throw UnimplementedError();
// }
}

class _CustomIndicator extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CustomIndicator(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Offset customOffset = offset +
        Offset(configuration.size!.width / 2,
            configuration.size!.height - radius + 6);
    //canvas.drawCircle(customOffset, radius, _paint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: customOffset,
                width: configuration.size!.width / 3,
                height: 3),
            Radius.circular(radius)),
        _paint);
  }
}
