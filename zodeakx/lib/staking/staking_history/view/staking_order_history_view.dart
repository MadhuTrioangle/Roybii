import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/staking/search_coins/viewModel/search_coins_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_history/view/staking_product_history_bottom_sheet.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../staking_transaction/model/UserStakeEarnModel.dart';
import '../../staking_transaction/model/UserStakeModel.dart';
import '../view_model/staking_order_history_view_model.dart';

class StakingOrderHistoryView extends StatefulWidget {
  const StakingOrderHistoryView({Key? key}) : super(key: key);

  @override
  State<StakingOrderHistoryView> createState() =>
      _StakingOrderHistoryViewState();
}

class _StakingOrderHistoryViewState extends State<StakingOrderHistoryView>
    with SingleTickerProviderStateMixin {
  late StakingOrderHistoryViewModel viewModel;
  late SearchCoinsViewModel searchCoinsViewModel;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    viewModel =
        Provider.of<StakingOrderHistoryViewModel>(context, listen: false);
    searchCoinsViewModel =
        Provider.of<SearchCoinsViewModel>(context, listen: false);
    _tabController.addListener(() {
      viewModel.setTabIndex(_tabController.index);
      if (_tabController.animation?.value == _tabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setTabLoading(true);
          if (_tabController.index != 2)
            viewModel.getUserStakes(0);
          else
            viewModel.getUserStakeEarns(0);
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.setTabIndex(0);
    });
    viewModel.getUserStakes(0);
  }

  changeTab() {
    List<String> tabs = [
      stringVariables.subscription,
      stringVariables.redemption,
      stringVariables.realTimeAprRewards
    ];
    if (viewModel.selectedOrder == stringVariables.locked) {
      tabs = [
        stringVariables.subscription,
        stringVariables.redemption,
        stringVariables.interest
      ];
    }
    viewModel.setTabs(tabs);
  }

  dynamic _showProductModal(
      BuildContext context, VoidCallback changeTab) async {
    final result = await Navigator.of(context)
        .push(StakingProductHistoryModal(context, changeTab));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<StakingOrderHistoryViewModel>();
    searchCoinsViewModel = context.watch<SearchCoinsViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
        create: (context) => viewModel,
        child: CustomScaffold(
            appBar: buildAppBar(), child: buildOrderHistoryView(size)));
  }

  Widget buildOrderHistoryView(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 35),
            child: Column(
              children: [buildTabView(size), buildTabBarView(size)],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabView(Size size) {
    return TabBar(
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      isScrollable: true,
      indicator: CustomIndicator(color: themeColor, radius: 5),
      unselectedLabelColor: themeSupport().isSelectedDarkMode() ? white : black,
      labelColor: themeSupport().isSelectedDarkMode() ? white : black,
      tabs: [
        Tab(
          child: CustomText(
              text: viewModel.tabs[0],
              fontWeight: FontWeight.bold,
              fontsize: 16,
              fontfamily: 'GoogleSans'),
        ),
        Tab(
          child: CustomText(
              text: viewModel.tabs[1],
              fontWeight: FontWeight.bold,
              fontsize: 16,
              fontfamily: 'GoogleSans'),
        ),
        Tab(
          child: CustomText(
              text: viewModel.tabs[2],
              fontWeight: FontWeight.bold,
              fontsize: 16,
              fontfamily: 'GoogleSans'),
        ),
      ],
      controller: _tabController,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  Widget buildTabBarView(size) {
    return Flexible(
      fit: FlexFit.loose,
      child: TabBarView(
        controller: _tabController,
        children: [
          viewModel.tabLoading
              ? Center(child: CustomLoader())
              : buildListOfSubscription(size),
          viewModel.tabLoading
              ? Center(child: CustomLoader())
              : buildListOfRedemption(size),
          viewModel.tabLoading
              ? Center(child: CustomLoader())
              : buildListOfRealTimeApr(size),
        ],
      ),
    );
  }

  Widget buildListOfSubscription(Size size) {
    List<UserStakeDetails> subcriptionList = viewModel.userStake?.data ?? [];
    int itemCount = subcriptionList.length;
    bool addMore = itemCount != (viewModel.userStake?.total ?? 0);
    int page = (viewModel.userStake?.page ?? 0);
    return itemCount != 0
        ? ListView.separated(
            padding:
                EdgeInsets.symmetric(vertical: size.width / 50, horizontal: 8),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.01,
                ),
            itemCount: itemCount + (addMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              return addMore && index == itemCount
                  ? GestureDetector(
                      onTap: () {
                        viewModel.getUserStakes(page);
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
                  : buildSubscriptionListCard(size, subcriptionList[index]);
            })
        : buildNoRecord();
  }

  Widget buildListOfRedemption(Size size) {
    List<UserStakeDetails> redemptionList = viewModel.userStake?.data ?? [];
    int itemCount = redemptionList.length;
    bool addMore = itemCount != (viewModel.userStake?.total ?? 0);
    int page = (viewModel.userStake?.page ?? 0);
    return itemCount != 0
        ? ListView.separated(
            padding:
                EdgeInsets.symmetric(vertical: size.width / 50, horizontal: 8),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.01,
                ),
            itemCount: itemCount + (addMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              return addMore && index == itemCount
                  ? GestureDetector(
                      onTap: () {
                        viewModel.getUserStakes(page);
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
                  : buildRedemptionListCard(size, redemptionList[index]);
            })
        : buildNoRecord();
  }

  Widget buildListOfRealTimeApr(Size size) {
    List<UserStakeEarnDetails> interestList =
        (viewModel.userStakeEarn?.data ?? []);
    int itemCount = interestList.length;
    bool addMore = itemCount != (viewModel.userStakeEarn?.total ?? 0);
    int page = (viewModel.userStakeEarn?.page ?? 0);
    return itemCount != 0
        ? ListView.separated(
            padding:
                EdgeInsets.symmetric(vertical: size.width / 50, horizontal: 8),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.01,
                ),
            itemCount: itemCount + (addMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              return addMore && index == itemCount
                  ? GestureDetector(
                      onTap: () {
                        viewModel.getUserStakeEarns(page);
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
                  : buildRealTimeAprListCard(size, interestList[index]);
            })
        : buildNoRecord();
  }

  Widget buildSubscriptionListCard(
      Size size, UserStakeDetails userStakeDetails) {
    String crypto = userStakeDetails.stakeCurrencyDetails?.code ?? "";
    String date = getDateFromTimeStamp(userStakeDetails.stakedAt.toString());
    String amount = userStakeDetails.stakeAmount.toString();
    String type = (userStakeDetails.isAutoRestake ?? false)
        ? stringVariables.autoSubscribe
        : stringVariables.normal;
    String lockedPeriod = (userStakeDetails.lockedDuration ?? 0).toString();
    return Column(
      children: [
        buildTextForHistory(crypto, date, 1),
        buildTextForHistory(stringVariables.amount, amount, 2),
        viewModel.selectedOrder == stringVariables.locked
            ? buildTextForHistory(stringVariables.lockedPeriod,
                lockedPeriod + " " + stringVariables.days, 2)
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        buildTextForHistory(stringVariables.type, type),
        Divider(),
        CustomSizedBox(
          height: 0.005,
        ),
      ],
    );
  }

  Widget buildRedemptionListCard(Size size, UserStakeDetails userStakeDetails) {
    String crypto = userStakeDetails.stakeCurrencyDetails?.code ?? "";
    String date = getDateFromTimeStamp(userStakeDetails.stakedAt.toString());
    String amount = userStakeDetails.stakeAmount.toString();
    String redemptionDate = userStakeDetails.interestEndAt != null
        ? getDateFromTimeStamp(userStakeDetails.interestEndAt.toString())
        : getDateFromTimeStamp(userStakeDetails.stakedAt.toString());
    ;
    String type = (userStakeDetails.status ?? "") == stringVariables.redeemed
        ? capitalize(stringVariables.redeemed)
        : stringVariables.redeeming;
    return Column(
      children: [
        buildTextForHistory(crypto, date, 1),
        buildTextForHistory(stringVariables.redeemAmount, amount, 2),
        viewModel.selectedOrder == stringVariables.locked
            ? buildTextForHistory(
                stringVariables.redemptionDate, redemptionDate, 2)
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        viewModel.selectedOrder == stringVariables.locked
            ? buildTextForHistory(stringVariables.type, type, 3)
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        Divider(),
        CustomSizedBox(
          height: 0.005,
        ),
      ],
    );
  }

  Widget buildRealTimeAprListCard(
      Size size, UserStakeEarnDetails userStakeEarnDetails) {
    String crypto = userStakeEarnDetails.earnCurrencyDetails?.code ?? "";
    String date =
        getDateFromTimeStamp(userStakeEarnDetails.createdAt.toString());
    String amount =
        trimDecimals(userStakeEarnDetails.interestAmount.toString());
    return Column(
      children: [
        buildTextForHistory(crypto, date, 1),
        buildTextForHistory(
            viewModel.selectedOrder == stringVariables.locked
                ? stringVariables.interestAmount
                : stringVariables.amount,
            amount,
            2),
        Divider(),
        CustomSizedBox(
          height: 0.005,
        ),
      ],
    );
  }

  Widget buildTextForHistory(String content1, String content2, [int type = 0]) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
                text: content1,
                fontWeight: FontWeight.w500,
                fontsize: 16,
                color: type == 1 ? null : textGrey,
                fontfamily: 'GoogleSans'),
            CustomText(
                text: content2,
                fontWeight: type == 2 ? FontWeight.w500 : FontWeight.w400,
                fontsize: type == 1 ? 14 : 16,
                color: (type == 2 || type == 3) ? null : textGrey,
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
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(
                    backArrow,
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
                    onTap: () {
                      _showProductModal(context, changeTab);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      maxlines: 1,
                      softwrap: true,
                      fontfamily: 'GoogleSans',
                      fontsize: 21,
                      fontWeight: FontWeight.bold,
                      text: viewModel.selectedOrder,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showProductModal(context, changeTab);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: SvgPicture.asset(
                        stakingArrowDown,
                        height: 6,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        moveToSearchCoinsView(context, true);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomContainer(
                        width: 17.5,
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.all(3.5),
                          child: SvgPicture.asset(
                            stakingSearch,
                            color:
                                searchCoinsViewModel.selectedHistoryCurrency !=
                                        null
                                    ? themeColor
                                    : null,
                          ),
                        ),
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.025,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (!viewModel.dateFilterApplied) {
                          DateTimeRange? pickedDate = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(1970),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme:
                                      themeSupport().isSelectedDarkMode()
                                          ? ColorScheme.dark(
                                              primary: themeColor,
                                              surface: card_dark,
                                              onPrimary: white,
                                              onSurface: white,
                                            )
                                          : ColorScheme.light(
                                              primary: themeColor,
                                              surface: white,
                                              onPrimary: black,
                                              onSurface: black,
                                            ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: themeColor,
                                    ),
                                  ),
                                  dialogBackgroundColor:
                                      themeSupport().isSelectedDarkMode()
                                          ? card_dark
                                          : white,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            String start =
                                getDateTimeStamp(pickedDate.start.toString());
                            String end =
                                getDateTimeStamp(pickedDate.end.toString());

                            viewModel.setDateFilterApplied(true);
                            viewModel.setStartDate(start);
                            viewModel.setEndDate(end);
                            if (viewModel.tabIndex != 2)
                              viewModel.getUserStakes(0);
                            else
                              viewModel.getUserStakeEarns(0);
                          }
                        } else {
                          viewModel.setDateFilterApplied(false);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomContainer(
                        width: 17.5,
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.all(3.5),
                          child: SvgPicture.asset(
                            stakingCalendar,
                            color:
                                viewModel.dateFilterApplied ? themeColor : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
            height: 0.04,
          ),
          SvgPicture.asset(
            stakingNotFound,
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
            configuration.size!.height - radius - 5);
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
