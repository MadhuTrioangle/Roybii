import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/staking/balance/view_model/staking_balance_view_model.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/View/staking_types_bottom_sheet.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/model/UserStakeEarnModel.dart';
import 'package:zodeakx_mobile/staking/staking_transaction/view/staking_product_bottom_sheet.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../model/UserStakeModel.dart';
import '../view_model/staking_transaction_view_model.dart';

class StakingTransactionView extends StatefulWidget {
  const StakingTransactionView({Key? key}) : super(key: key);

  @override
  State<StakingTransactionView> createState() => _StakingTransactionViewState();
}

class _StakingTransactionViewState extends State<StakingTransactionView> {
  late StakingTransactionViewModel viewModel;
  late StakingBalanceViewModel stakingBalanceViewModel;

  @override
  void initState() {
    viewModel =
        Provider.of<StakingTransactionViewModel>(context, listen: false);
    stakingBalanceViewModel =
        Provider.of<StakingBalanceViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
    });
    viewModel.getUserStakes(0);
    stakingBalanceViewModel.getStakeBalance();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<StakingTransactionViewModel>();
    stakingBalanceViewModel = context.watch<StakingBalanceViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider<StakingTransactionViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return buildTransaction(size);
      },
    );
  }

  Future<bool> pop() async {
    return true;
  }

  dynamic _showProductModal(BuildContext context) async {
    final result =
        await Navigator.of(context).push(StakingProductModal(context));
  }

  dynamic _showTypesModal(BuildContext context) async {
    final result = await Navigator.of(context).push(StakingTypesModal(context));
  }

  /// FiatCurrency
  Widget buildTransaction(Size size) {
    return WillPopScope(
        onWillPop: pop,
        child: CustomScaffold(
          appBar: buildAppBar(),
          child: viewModel.needToLoad
              ? Center(child: CustomLoader())
              : buildTransactionView(size),
        ));
  }

  Widget buildTransactionView(Size size) {
    String earing = trimDecimals(
        stakingBalanceViewModel.earningTotalStakeBalance.toString());
    String spending = trimDecimals(
        stakingBalanceViewModel.estimateTotalStakeBalance.toString());
    return CustomCard(
      radius: 15,
      outerPadding: 8,
      edgeInsets: 8,
      elevation: 0,
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.02,
          ),
          buildTransactionHeader(earing, spending),
          CustomSizedBox(
            height: 0.01,
          ),
          Divider(),
          CustomSizedBox(
            height: 0.01,
          ),
          buildTransactionFilters(),
          CustomSizedBox(
            height: 0.02,
          ),
          buildTransactionList(size),
        ],
      ),
    );
  }

  Widget buildTransactionList(Size size) {
    List<dynamic> userStakeDetails = viewModel.transactionList;
    int listCount = userStakeDetails.length;
    int total = viewModel.selectedDirections == stringVariables.spendings
        ? (viewModel.userStake?.total ?? 0)
        : (viewModel.userStake?.total ?? 0) >
                (viewModel.userStakeEarn?.total ?? 0)
            ? (viewModel.userStake?.total ?? 0)
            : (viewModel.userStakeEarn?.total ?? 0);
    int addListCount = (viewModel.userStake?.total ?? 0) >
            (viewModel.userStakeEarn?.total ?? 0)
        ? (viewModel.userStake?.data ?? []).length
        : (viewModel.userStakeEarn?.data ?? []).length;
    bool addMore = addListCount != total;
    int page = (viewModel.userStake?.total ?? 0) >
            (viewModel.userStakeEarn?.total ?? 0)
        ? (viewModel.userStake?.page ?? 0)
        : (viewModel.userStakeEarn?.page ?? 0);
    return Flexible(
      fit: FlexFit.loose,
      child: listCount != 0
          ? ListView.separated(
              padding: EdgeInsets.symmetric(
                  vertical: size.width / 50, horizontal: 8),
              separatorBuilder: (context, index) => CustomSizedBox(
                    height: 0.02,
                  ),
              itemCount: listCount + (addMore ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                bool isEarn = index == listCount
                    ? false
                    : userStakeDetails[index] is UserStakeEarnDetails;
                return addMore && index == listCount
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
                    : isEarn
                        ? buildEarnListCard(size, userStakeDetails[index])
                        : buildHistoryListCard(size, userStakeDetails[index]);
              })
          : buildNoRecord(),
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

  Widget buildHistoryListCard(Size size, UserStakeDetails userStakeDetails) {
    String holding = (userStakeDetails.isFlexible ?? false)
        ? stringVariables.flexible
        : stringVariables.locked;
    String type = userStakeDetails.status == stringVariables.staked
        ? stringVariables.subscription
        : userStakeDetails.status == stringVariables.redeemed
            ? stringVariables.redemption
            : stringVariables.others;
    String value = userStakeDetails.stakeAmount.toString();
    String crypto = userStakeDetails.rewardCurrencyDetails?.code ?? "";
    String date = getDateFromTimeStamp(userStakeDetails.stakedAt.toString());
    return Column(
      children: [
        buildListTextItems(holding, value + " $crypto", true),
        CustomSizedBox(
          height: 0.015,
        ),
        buildListTextItems(date, type, false),
        CustomSizedBox(
          height: 0.0075,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.0075,
        ),
      ],
    );
  }

  Widget buildEarnListCard(Size size, UserStakeEarnDetails userStakeDetails) {
    String holding = (userStakeDetails.userStakeDetails?.isFlexible ?? false)
        ? stringVariables.flexible
        : stringVariables.locked;
    String type = stringVariables.income;
    String value = trimDecimals(userStakeDetails.interestAmount.toString());
    String crypto = userStakeDetails.earnCurrencyDetails?.code ?? "";
    String date = getDateFromTimeStamp(userStakeDetails.createdAt.toString());
    return Column(
      children: [
        buildListTextItems(holding, value + " $crypto", true),
        CustomSizedBox(
          height: 0.015,
        ),
        buildListTextItems(date, type, false),
        CustomSizedBox(
          height: 0.0075,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.0075,
        ),
      ],
    );
  }

  buildListTextItems(String content1, String content2, bool isMain) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
            text: content1,
            fontWeight: isMain ? FontWeight.w500 : FontWeight.w400,
            fontsize: isMain ? 16 : 14,
            color: isMain ? null : textGrey,
            fontfamily: 'GoogleSans'),
        CustomText(
            text: content2,
            fontWeight: isMain ? FontWeight.w500 : FontWeight.w400,
            fontsize: isMain ? 16 : 14,
            color: isMain ? null : textGrey,
            fontfamily: 'GoogleSans'),
      ],
    );
  }

  Widget buildTransactionFilters() {
    String types = viewModel.selectedDirections == stringVariables.all
        ? stringVariables.allTypes
        : viewModel.selectedDirections;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildTextWithArrow(viewModel.selectedProduct, onHoldingPressed),
        buildTextWithArrow(types, onTypesPressed),
      ],
    );
  }

  onHoldingPressed() {
    _showProductModal(context);
  }

  onTypesPressed() {
    _showTypesModal(context);
  }

  Widget buildTransactionHeader(String earing, String spending) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildPairOfItems(stringVariables.earnings, "+$earing", green),
        buildPairOfItems(stringVariables.spendings, "-$spending", red)
      ],
    );
  }

  Widget buildPairOfItems(String title, String value, Color color) {
    String crypto = constant.pref?.getString("defaultCryptoCurrency") ?? '';
    return Column(
      children: [
        CustomText(
            text: title + " ($crypto)",
            fontWeight: FontWeight.w500,
            fontsize: 18,
            fontfamily: 'GoogleSans'),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
            text: value,
            fontWeight: FontWeight.w500,
            fontsize: 16,
            color: color,
            fontfamily: 'GoogleSans'),
      ],
    );
  }

  Widget buildTextWithArrow(String title, VoidCallback onTapped) {
    return GestureDetector(
      onTap: onTapped,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          CustomText(
              text: title,
              fontWeight: FontWeight.w500,
              fontsize: 16,
              fontfamily: 'GoogleSans'),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: SvgPicture.asset(stakingArrowDown),
          ),
        ],
      ),
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
              child: CustomText(
                overflow: TextOverflow.ellipsis,
                maxlines: 1,
                softwrap: true,
                fontfamily: 'GoogleSans',
                fontsize: 21,
                fontWeight: FontWeight.bold,
                text: stringVariables.transaction,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: viewModel.needToLoad
                    ? CustomSizedBox()
                    : GestureDetector(
                        onTap: () async {
                          if (!viewModel.dateFilterApplied) {
                            DateTimeRange? pickedDate =
                                await showDateRangePicker(
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
                              viewModel.getUserStakes(0);
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
                              color: viewModel.dateFilterApplied
                                  ? themeColor
                                  : null,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
