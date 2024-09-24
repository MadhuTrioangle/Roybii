import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../../Utils/Constant/AppConstants.dart';
import '../../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../../Utils/Languages/English/StringVariables.dart';
import '../../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../../Utils/Widgets/CustomContainer.dart';
import '../../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../../Utils/Widgets/CustomScaffold.dart';
import '../../../../Utils/Widgets/CustomText.dart';
import '../../../../p2p/counter_parties_profile/view/p2p_counter_profile_view.dart';
import '../../../../p2p/orders/model/UserOrdersModel.dart';
import '../../../../p2p/orders/view_model/p2p_order_view_model.dart';
import '../../ViewModel/WalletViewModel.dart';
import '../model/UserFundingWalletDetailsModel.dart';
import '../view_model/funding_coin_details_view_model.dart';

class FundingCoinDetailsView extends StatefulWidget {
  final String coin;

  const FundingCoinDetailsView({Key? key, required this.coin})
      : super(key: key);

  @override
  State<FundingCoinDetailsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<FundingCoinDetailsView>
    with TickerProviderStateMixin {
  late FundingCoinDetailsViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  late P2POrderViewModel p2pOrderViewModel;
  late TabController _tabController;

  @override
  void initState() {
    viewModel =
        Provider.of<FundingCoinDetailsViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    p2pOrderViewModel = Provider.of<P2POrderViewModel>(context, listen: false);
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.fetchUserOrders(0, widget.coin);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // marketViewModel.leaveSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<FundingCoinDetailsViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    return Provider<FundingCoinDetailsViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return buildEditWithdrawalAddress();
      },
    );
  }

  Widget buildEditWithdrawalAddress() {
    return CustomScaffold(
      appBar: buildAppBar(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: CustomCard(
          radius: 25,
          edgeInsets: 12,
          outerPadding: 0,
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTopItems(),
              buildTabBar(),
              CustomSizedBox(
                height: 0.015,
              ),
              viewModel.needToLoad
                  ? Expanded(child: CustomLoader())
                  : buildTabBarView(),
              CustomSizedBox(
                height: 0.015,
              ),
              buildBottomItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomItems() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: CustomElevatedButton(
                  buttoncolor: enableBorder,
                  color: black,
                  press: () {
                    List<UserFundingWalletDetails> list =
                        walletViewModel.userFundingWalletDetails ?? [];
                    list = list
                        .where((element) => element.currencyCode == widget.coin)
                        .toList();
                    UserFundingWalletDetails item;
                    if (list.isNotEmpty) {
                      item = list.first;
                    } else {
                      item = walletViewModel.userFundingWalletDetails?.first ??
                          UserFundingWalletDetails(
                              amount: 0,
                              inorder: 0,
                              currencyCode: "",
                              convertedAmount: 0,
                              convertedCurrencyCode: "",
                              currencyLogo: "",
                              currency_type: "");
                    }
                    constant.walletCurrency.value = item.currencyCode ?? "";

                    if (item.currency_type == "fiat") {
                      moveToCoinDetailsView(
                          context,
                          item.currencyCode,
                          item.totalAmount.toString(),
                          item.amount.toString(),
                          item.currencyCode,
                          item.currency_type,
                          item.inorder.toString(),
                          item.inorder.toString());
                    } else {
                      walletViewModel.getFundingBalanceSocket();
                      moveToFundingWalletView(context, item);
                    }
                  },
                  width: 1,
                  isBorderedButton: true,
                  maxLines: 1,
                  icon: null,
                  multiClick: true,
                  text: stringVariables.withdraw,
                  radius: 25,
                  height: 20,
                  icons: false,
                  blurRadius: 0,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  spreadRadius: 0,
                  offset: Offset(0, 0)),
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            Flexible(
              child: CustomElevatedButton(
                  buttoncolor: themeColor,
                  color: themeSupport().isSelectedDarkMode() ? black : white,
                  press: () {
                    List<UserFundingWalletDetails> list =
                        walletViewModel.userFundingWalletDetails ?? [];
                    list = list
                        .where((element) => element.currencyCode == widget.coin)
                        .toList();
                    UserFundingWalletDetails item;
                    if (list.isNotEmpty) {
                      item = list.first;
                    } else {
                      item = walletViewModel.userFundingWalletDetails?.first ??
                          UserFundingWalletDetails(
                              amount: 0,
                              inorder: 0,
                              currencyCode: "",
                              convertedAmount: 0,
                              convertedCurrencyCode: "",
                              currencyLogo: "",
                              currency_type: "");
                    }

                    constant.walletCurrency.value = item.currencyCode ?? "";
                    if (item.currency_type == "fiat") {
                      moveToCoinDetailsView(
                          context,
                          item.currencyCode,
                          item.totalAmount.toString(),
                          item.amount.toString(),
                          item.currencyCode,
                          item.currency_type,
                          item.inorder.toString(),
                          item.inorder.toString());
                    } else {
                      walletViewModel.getFundingBalanceSocket();
                      moveToFundingWalletView(context, item);
                    }
                  },
                  width: 1,
                  isBorderedButton: true,
                  maxLines: 1,
                  icon: null,
                  multiClick: true,
                  text: stringVariables.deposit,
                  radius: 25,
                  height: 20,
                  icons: false,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  blurRadius: 0,
                  spreadRadius: 0,
                  offset: Offset(0, 0)),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.005,
        ),
      ],
    );
  }

  Widget buildTopItems() {
    List<UserFundingWalletDetails> userFundingWalletDetailsList =
        walletViewModel.userFundingWalletDetails
            .where((element) => element.currencyCode == widget.coin)
            .toList();
    UserFundingWalletDetails userFundingWalletDetails;
    if (userFundingWalletDetailsList.isNotEmpty) {
      userFundingWalletDetails = userFundingWalletDetailsList.first;
    } else {
      userFundingWalletDetails = dummyUserFundingWalletDetails;
    }
    String cryptoValue =
        trimDecimalsForBalance(userFundingWalletDetails.totalAmount.toString());
    num inorderExchange = (userFundingWalletDetails.inorder ?? 0) *
        (userFundingWalletDetails.exchangeRate ?? 0);
    String fiatValue = trimDecimalsForBalance(
        (((userFundingWalletDetails.convertedAmount ?? 0) + inorderExchange) *
                walletViewModel.fiatValue)
            .toString());
    String available =
        trimDecimalsForBalance(userFundingWalletDetails.amount.toString());
    String inOrder =
        trimDecimalsForBalance(userFundingWalletDetails.inorder.toString());
    String fiat = constant.pref?.getString("defaultFiatCurrency") ?? '';
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiat)
        .value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          children: [
            CustomText(
                text: "${stringVariables.fundingBalance}",
                fontWeight: FontWeight.w500,
                fontsize: 14,
                color: textGrey,
                fontfamily: 'InterTight'),
            CustomSizedBox(
              width: 0.02,
            ),
            GestureDetector(
                onTap: () {
                  walletViewModel.setVisible();
                },
                child: Icon(
                  walletViewModel.isvisible
                      ? Icons.remove_red_eye_rounded
                      : Icons.visibility_off,
                  color: textHeaderGrey,
                  size: 20,
                )),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
                text: walletViewModel.isvisible ? cryptoValue : "*****",
                fontWeight: FontWeight.bold,
                fontsize: 24,
                fontfamily: 'InterTight'),
            CustomSizedBox(
              width: 0.02,
            ),
            Column(
              children: [
                CustomText(
                    text: walletViewModel.isvisible
                        ? "≈ ${currencySymbol} ${fiatValue == "NaN" ? "0.00" : fiatValue}"
                        : "*****",
                    fontWeight: FontWeight.w500,
                    fontsize: 14,
                    color: textGrey,
                    fontfamily: 'InterTight'),
                CustomSizedBox(
                  height: 0.002,
                ),
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.025,
        ),
        Row(
          children: [
            textWithValue(stringVariables.available, available),
            textWithValue(stringVariables.inOrder, inOrder),
          ],
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
                text: stringVariables.history_orders,
                fontWeight: FontWeight.w500,
                fontsize: 16,
                fontfamily: 'InterTight'),
            CustomText(
                press: () {
                  moveToFundingHistoryView(context);
                },
                text: stringVariables.viewMore,
                fontWeight: FontWeight.w500,
                fontsize: 14,
                color: themeColor,
                fontfamily: 'InterTight'),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget textWithValue(String title, String value) {
    return Flexible(
      child: CustomContainer(
        width: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                text: title,
                fontWeight: FontWeight.w500,
                fontsize: 14,
                color: textGrey,
                fontfamily: 'InterTight'),
            CustomSizedBox(
              height: 0.01,
            ),
            CustomText(
                text: walletViewModel.isvisible ? value : "*****",
                fontWeight: FontWeight.w500,
                fontsize: 14,
                fontfamily: 'InterTight'),
          ],
        ),
      ),
    );
  }

  Widget buildTabBarView() {
    return Expanded(
        child: TabBarView(
            controller: _tabController, children: [buildP2PItems()]));
  }

  Widget buildTabBar() {
    return ButtonsTabBar(
      buttonMargin: EdgeInsets.zero,
      labelSpacing: 0,
      height: 24,
      controller: _tabController,
      backgroundColor: themeColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      unselectedBackgroundColor: Colors.transparent,
      splashColor: Colors.transparent,
      unselectedLabelStyle: TextStyle(
          fontSize: 13,
          color: themeSupport().isSelectedDarkMode() ? white : black,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w500),
      labelStyle: TextStyle(
          fontSize: 13,
          color: themeSupport().isSelectedDarkMode() ? black : white,
          fontFamily: 'InterTight',
          fontWeight: FontWeight.w500),
      tabs: [
        Tab(
          text: stringVariables.p2p,
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    String coin = widget.coin;
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
                    CustomCircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.transparent,
                      child: FadeInImage.assetNetwork(
                        image: getImage(marketViewModel, walletViewModel, coin),
                        placeholder: splash,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      overflow: TextOverflow.ellipsis,
                      maxlines: 1,
                      softwrap: true,
                      fontfamily: 'InterTight',
                      fontsize: 20,
                      fontWeight: FontWeight.bold,
                      text: coin,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget noOrderHistory() {
    return Center(
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.1,
          ),
          SvgPicture.asset(
            themeSupport().isSelectedDarkMode() ? p2pNoAdsDark : p2pNoAds,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'InterTight',
            fontsize: 18,
            fontWeight: FontWeight.w400,
            text: stringVariables.notFound,
            color: textGrey,
          ),
        ],
      ),
    );
  }

  Widget buildP2PItems() {
    int itemCount = (viewModel.userOrders?.data ?? []).length;
    bool addMore = itemCount != (viewModel.userOrders?.total ?? 0);
    int page = (viewModel.userOrders?.page ?? 0);
    return itemCount != 0
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 12.0),
            itemCount: itemCount + (addMore ? 1 : 0),
            itemBuilder: (context, index) {
              OrdersData ordersData = addMore && index == itemCount
                  ? OrdersData()
                  : (viewModel.userOrders?.data?[index] ?? OrdersData());
              return addMore && index == itemCount
                  ? GestureDetector(
                      onTap: () {
                        viewModel.fetchUserOrders(page, widget.coin);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            fontfamily: 'InterTight',
                            text: stringVariables.more,
                            fontsize: 16,
                            fontWeight: FontWeight.w400,
                            color: themeColor,
                          ),
                        ],
                      ),
                    )
                  : buildListItem(ordersData);
            },
          )
        : noOrderHistory();
  }

  Widget buildListItem(OrdersData ordersData) {
    String side = capitalize((ordersData.tradeType ?? " "));
    String amount = trimDecimalsForBalance((ordersData.amount ?? 0).toString());
    String date = getDate(ordersData.modifiedDate.toString());
    String status = capitalize((ordersData.status ?? " "));
    bool isCompleted = status == stringVariables.completed ||
        status == stringVariables.cancelled;
    String id = ordersData.id ?? "";
    String adId = ordersData.advertisementId ?? "";
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isCompleted) {
              moveToOrderDetailsView(context, id, '', '', '');
            } else {
              if (!p2pOrderViewModel.itemClicked) {
                p2pOrderViewModel.setItemClicked(true);
                p2pOrderViewModel.fetchParticularUserAdvertisement(
                    adId, ordersData);
              }
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCircleAvatar(
                      radius: 16,
                      backgroundColor: themeSupport().isSelectedDarkMode()
                          ? enableBorder.withOpacity(0.25)
                          : enableBorder.withOpacity(0.75),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          side != stringVariables.buy
                              ? sendTransfer
                              : receiveTransfer,
                          color: themeSupport().isSelectedDarkMode()
                              ? white
                              : black,
                        ),
                      )),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSizedBox(
                        height: 0.0075,
                      ),
                      CustomText(
                        fontsize: 16,
                        fontWeight: FontWeight.w500,
                        text: side,
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      CustomText(
                        fontsize: 14,
                        text: id,
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      CustomText(
                        fontsize: 14,
                        text: date,
                        color: textGrey,
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomSizedBox(
                    height: 0.0075,
                  ),
                  CustomText(
                    fontsize: 16,
                    fontWeight: FontWeight.w500,
                    text: amount,
                    color: side == stringVariables.buy ? green : red,
                  ),
                  CustomSizedBox(
                    height: 0.0075,
                  ),
                  CustomText(
                    fontsize: 14,
                    fontWeight: FontWeight.w500,
                    text: status,
                    color: textGrey,
                  ),
                  CustomSizedBox(
                    height: 0.0075,
                  ),
                  Icon(
                    Icons.navigate_next,
                    size: 15,
                  )
                ],
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.025,
        ),
      ],
    );
  }
}
