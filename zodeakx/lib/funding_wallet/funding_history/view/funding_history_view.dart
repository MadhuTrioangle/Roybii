import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../../p2p/home/view/p2p_home_view.dart';
import '../../../p2p/orders/model/UserOrdersModel.dart';
import '../../../p2p/orders/view_model/p2p_order_view_model.dart';
import '../view_model/funding_history_view_model.dart';
import 'funding_history_type_model.dart';

class FundingHistoryView extends StatefulWidget {
  const FundingHistoryView({super.key});

  @override
  State<FundingHistoryView> createState() => _FundingHistoryViewState();
}

class _FundingHistoryViewState extends State<FundingHistoryView>
    with TickerProviderStateMixin {
  late FundingHistoryViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  late P2POrderViewModel p2POrderViewModel;
  late TabController walletTabController;
  late TabController statusTabController;
  late TabController payTabController;

  @override
  void initState() {
    // TODO: implement initState
    viewModel = Provider.of<FundingHistoryViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    p2POrderViewModel = Provider.of<P2POrderViewModel>(context, listen: false);
    // walletTabController = TabController(length: 2, vsync: this);
    statusTabController = TabController(length: 2, vsync: this);
    // walletTabController.addListener(() {
    //   viewModel.setWalletTabIndex(walletTabController.index);
    //   if (walletTabController.animation?.value == walletTabController.index) {
    //     mainApiCall(walletTabController.index);
    //   }
    // });
    statusTabController.addListener(() {
      viewModel.setStatusTabIndex(statusTabController.index);
      if (statusTabController.animation?.value == statusTabController.index) {
        viewModel.setLoading(true);
        viewModel.fetchUserOrders();
      }
    });
    // payTabController.addListener(() {
    //   viewModel.setPayTabIndex(payTabController.index);
    //   if (payTabController.animation?.value == payTabController.index) {
    //     viewModel.setLoading(true);
    //     //viewModel.getUserpayTransactionHistory();
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setStatusTabIndex(0);
      viewModel.setWalletTabIndex(0);
      viewModel.setPayTabIndex(0);
      viewModel.setLoading(true);
      viewModel.fetchUserOrders();
    });
    super.initState();
  }

  mainApiCall(int index) {
    if (index == 0) {
      viewModel.setLoading(true);
      viewModel.fetchUserOrders();
    } else {
      viewModel.setLoading(true);
      //viewModel.getUserpayTransactionHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<FundingHistoryViewModel>();
    p2POrderViewModel = context.watch<P2POrderViewModel>();
    return Provider<FundingHistoryViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return showPage(
          context,
        );
      },
    );
  }

  Widget showPage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: buildAppHeader(),
      child: Padding(
          padding: EdgeInsets.all(size.width / 35),
          child: CustomCard(
              outerPadding: 0,
              edgeInsets: size.width / 50,
              radius: 25,
              elevation: 0,
              child:walletTabBarView(size))),
    );
  }

  walletTabBarView(Size size) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomContainer(
          width: 1,
          height: 17.5,
          child: statusTabBar(),
        ),
        viewModel.needToLoad
            ? Expanded(child: CustomLoader())
            : buildStatusTabBarView()
      ],
    );
  }



  statusTabBar() {
    return DecoratedTabBar(
      tabBar: TabBar(
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          fontFamily: 'GoogleSans',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontFamily: 'GoogleSans',
        ),
        indicatorWeight: 0,
        indicator: TabBarIndicator(color: themeColor, radius: 4),
        isScrollable: true,
        labelColor: themeColor,
        unselectedLabelColor: hintLight,
        controller: statusTabController,
        tabs: buildTabBar(),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: hintLight.withOpacity(0.25),
            width: 2.0,
          ),
        ),
      ),
    );
  }

  buildTabBar() {
    List<Tab> tabs = [];
    viewModel.walletTabs.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }



  buildWalletTabBarView(Size size) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            width: 1,
            height: 17.5,
            child: statusTabBar(),
          ),
          viewModel.needToLoad
              ? Expanded(child: CustomLoader())
              : buildStatusTabBarView()
        ],
      ),
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     CustomContainer(
      //       width: 1,
      //       height: 17.5,
      //       child: payTabBar(),
      //     ),
      //     viewModel.needToLoad
      //         ? Expanded(child: CustomLoader())
      //         : buildPayTabBarView()
      //   ],
      // ),
    ];
  }

  Widget noOrderHistory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          themeSupport().isSelectedDarkMode() ? p2pNoOrdersDark : p2pNoOrders,
        ),
        CustomSizedBox(
          height: 0.025,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.noOrderHistory,
          color: hintLight,
          fontsize: 18,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.025,
        ),
      ],
    );
  }

  buildStatusTabBarView() {
    return Flexible(
      child: CustomContainer(
        width: 1,
        height: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TabBarView(
            controller: statusTabController,
            children: buildStatusTabView(),
          ),
        ),
      ),
    );
  }

  // buildPayTabBarView() {
  //   return Flexible(
  //     child: CustomContainer(
  //       width: 1,
  //       height: 1,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: TabBarView(
  //           controller: payTabController,
  //           children: buildPayTabView(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // buildPayTabView() {
  //   return [
  //     Column(
  //       children: [
  //         paid(),
  //       ],
  //     ),
  //     Column(
  //       children: [receive()],
  //     ),
  //   ];
  // }

  // receive() {
  //   List<TransactionHistory>? list =
  //       viewModel.payTransactionHistory?.data ?? [];
  //   int itemCount = list.length;
  //   bool addMore = itemCount != (viewModel.payTransactionHistory?.total ?? 0);
  //   int page = viewModel.payTransactionHistory?.page ?? 0;
  //   return Flexible(
  //     fit: FlexFit.loose,
  //     child: CustomContainer(
  //       height: 1,
  //       child: itemCount == 0
  //           ? noOrderHistory()
  //           : ListView.builder(
  //               itemCount: itemCount + (addMore ? 1 : 0),
  //               itemBuilder: (context, index) {
  //                 return addMore && index == itemCount
  //                     ? GestureDetector(
  //                         onTap: () {
  //                           viewModel.getUserpayTransactionHistory(page);
  //                         },
  //                         behavior: HitTestBehavior.opaque,
  //                         child: Column(
  //                           children: [
  //                             CustomSizedBox(
  //                               height: 0.01,
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 CustomText(
  //                                   fontfamily: 'GoogleSans',
  //                                   text: stringVariables.more,
  //                                   fontsize: 16,
  //                                   fontWeight: FontWeight.w400,
  //                                   color: themeColor,
  //                                 ),
  //                               ],
  //                             ),
  //                             CustomSizedBox(
  //                               height: 0.01,
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : buildHistoryItems(
  //                         list[index], false, (index + 1) == list.length);
  //               },
  //             ),
  //     ),
  //   );
  // }
  //
  // Widget buildHistoryItems(TransactionHistory transactionHistory,
  //     [bool isPaid = false, bool isLast = false]) {
  //   String userType = transactionHistory.userType ?? "";
  //   String payId = transactionHistory.payId ?? "";
  //   String remarks = transactionHistory.remarks ?? "";
  //   String coin = transactionHistory.receiveCurrency ?? "";
  //   String date = transactionHistory.createdAt != null
  //       ? getDate(transactionHistory.createdAt.toString())
  //       : "";
  //   num amount = transactionHistory.sendAmount ?? 0;
  //   String status = transactionHistory.status ?? " ";
  //   Color color = green;
  //   return GestureDetector(
  //     onTap: () {
  //       moveToPayPaymentDetailsView(context, transactionHistory);
  //     },
  //     behavior: HitTestBehavior.opaque,
  //     child: Column(
  //       children: [
  //         CustomSizedBox(
  //           height: 0.02,
  //         ),
  //         buildHistoryText(
  //             (remarks.isEmpty ? userType : remarks) + " - ${payId}",
  //             "$amount $coin"),
  //         CustomSizedBox(
  //           height: 0.015,
  //         ),
  //         buildHistoryText(date, capitalize(status), false, color),
  //         CustomSizedBox(
  //           height: 0.02,
  //         ),
  //         if (!isLast)
  //           Divider(
  //             height: 0,
  //             color: stackCardText,
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildHistoryText(String title, String content,
      [bool isBold = false, Color? color]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: title,
          fontsize: color != null ? 14 : 16,
          color: color != null ? hintLight : null,
          fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
        ),
        CustomText(
          text: content,
          fontsize: 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: color,
        ),
      ],
    );
  }

  // paid() {
  //   List<TransactionHistory>? list =
  //       viewModel.payTransactionHistory?.data ?? [];
  //   int itemCount = list.length;
  //   bool addMore = itemCount != (viewModel.payTransactionHistory?.total ?? 0);
  //   int page = viewModel.payTransactionHistory?.page ?? 0;
  //   return Flexible(
  //     fit: FlexFit.loose,
  //     child: CustomContainer(
  //       height: 1,
  //       child: itemCount == 0
  //           ? noOrderHistory()
  //           : ListView.builder(
  //               itemCount: itemCount + (addMore ? 1 : 0),
  //               itemBuilder: (context, index) {
  //                 return addMore && index == itemCount
  //                     ? GestureDetector(
  //                         onTap: () {
  //                           viewModel.getUserpayTransactionHistory(page);
  //                         },
  //                         behavior: HitTestBehavior.opaque,
  //                         child: Column(
  //                           children: [
  //                             CustomSizedBox(
  //                               height: 0.01,
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 CustomText(
  //                                   fontfamily: 'GoogleSans',
  //                                   text: stringVariables.more,
  //                                   fontsize: 16,
  //                                   fontWeight: FontWeight.w400,
  //                                   color: themeColor,
  //                                 ),
  //                               ],
  //                             ),
  //                             CustomSizedBox(
  //                               height: 0.01,
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : buildHistoryItems(
  //                         list[index], true, (index + 1) == list.length);
  //               },
  //             ),
  //     ),
  //   );
  // }

  buildStatusTabView() {
    int itemCount = (viewModel.userOrders?.data ?? []).length;
    bool addMore = itemCount != (viewModel.userOrders?.total ?? 0);
    int page = (viewModel.userOrders?.page ?? 0);
    return [
      Column(
        children: [
          Row(
            children: [
              buildDropDownText(
                  stringVariables.type, viewModel.statusPending, 1),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: CustomContainer(
              height: 1,
              child: itemCount != 0
                  ? ListView.separated(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width / 50),
                  separatorBuilder: (context, index) => CustomSizedBox(
                    height: 0.02,
                  ),
                  physics: ScrollPhysics(),
                  shrinkWrap: false,
                  itemCount: itemCount + (addMore ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    OrdersData ordersData = addMore && index == itemCount
                        ? OrdersData()
                        : (viewModel.userOrders?.data?[index] ??
                        OrdersData());
                    return addMore && index == itemCount
                        ? GestureDetector(
                      onTap: () {
                        viewModel.fetchUserOrders(page);
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
                        : buildListCard(ordersData);
                  })
                  : noOrderHistory(),
            ),
          )
        ],
      ),
      Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropDownText(
                  stringVariables.type, viewModel.statusCompleted, 1),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: CustomContainer(
              height: 1,
              child: itemCount != 0
                  ? ListView.separated(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width / 50),
                  separatorBuilder: (context, index) => CustomSizedBox(
                    height: 0.02,
                  ),
                  physics: ScrollPhysics(),
                  shrinkWrap: false,
                  itemCount: itemCount + (addMore ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    OrdersData ordersData = addMore && index == itemCount
                        ? OrdersData()
                        : (viewModel.userOrders?.data?[index] ??
                        OrdersData());
                    return addMore && index == itemCount
                        ? GestureDetector(
                      onTap: () {
                        viewModel.fetchUserOrders(page);
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
                        : buildListCard(ordersData);
                  })
                  : noOrderHistory(),
            ),
          )
        ],
      ),
    ];
  }

  AppBar buildAppHeader() {
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
            ((viewModel.statusIndex == 1) || (viewModel.walletIndex == 1))
                ? Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  child: CustomContainer(
                      padding: 3.15,
                      width: 17.5,
                      height: 35,
                      child: SvgPicture.asset(
                        marginCalendar,
                        color: viewModel.filterApplied
                            ? themeColor
                            : switchBackground,
                      )),
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    bool filter = !viewModel.filterApplied;
                    if (filter) {
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
                        viewModel.setFilterApplied(true);
                        viewModel.setStartDate(start);
                        viewModel.setEndDate(end);
                        if (viewModel.walletIndex == 0) {
                          viewModel.fetchUserOrders();
                        } else {
                          // viewModel.getUserpayTransactionHistory();
                        }
                      }
                    } else {
                      viewModel.setFilterApplied(false);
                      viewModel.setStartDate("");
                      viewModel.setEndDate("");
                      if (viewModel.walletIndex == 0) {
                        viewModel.fetchUserOrders();
                      } else {
                        //viewModel.getUserpayTransactionHistory();
                      }
                    }
                  },
                ),
              ),
            )
                : CustomSizedBox(
              width: 0,
              height: 0,
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
                text: stringVariables.history_orders,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*  Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SvgPicture.asset(
                        stakingSearch,
                      ),
                    ),
                  ),
                ),*/
  Widget buildDropDownText(String title, String selected, int type) {
    return GestureDetector(
      onTap: () {
        _showModal(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: "$title: $selected",
              fontsize: 14,
              color: textGrey,
              fontWeight: FontWeight.bold,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            SvgPicture.asset(
              dropDownArrowImage,
              color: textGrey,
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  dynamic _showModal(
      BuildContext context,
      ) async {
    final result =
    await Navigator.of(context).push(FundingHistoryTypeModel(context));
  }

  buildListCard(OrdersData ordersData) {
    String side = capitalize(ordersData.tradeType ?? " ");
    String crypto = side == stringVariables.buy
        ? ordersData.toAsset ?? ""
        : ordersData.fromAsset ?? "";
    String fiat = side == stringVariables.buy
        ? ordersData.fromAsset ?? ""
        : ordersData.toAsset ?? "";
    String status = ordersData.status ?? " ";
    bool isCompleted = status == stringVariables.completed.toLowerCase() ||
        status == stringVariables.cancelled.toLowerCase();
    String price = trimDecimals((ordersData.price ?? 0.00).toString());
    String amount = trimDecimals((ordersData.amount ?? 0.00).toString());
    String total = trimDecimals((ordersData.total ?? 0.00).toString());
    String counterParty = ordersData.counterParty ?? "";
    String date = getDateTime((ordersData.modifiedDate ??
        DateTime.parse("2023-02-21T14:08:25.811Z").toString())
        .toString());
    String id = ordersData.id ?? "";
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiat)
        .value;
    return GestureDetector(
      onTap: () {
        String status = ordersData.status ?? "";
        String id = ordersData.id ?? "";
        String adId = ordersData.advertisementId ?? "";
        bool isCompleted = status == stringVariables.completed.toLowerCase() ||
            status == stringVariables.cancelled.toLowerCase();
        String side = capitalize(ordersData.tradeType ?? "");
        if (isCompleted) {
          moveToOrderDetailsView(context, id, '', '', '');
        } else {
          if (!p2POrderViewModel.itemClicked) {
            p2POrderViewModel.setItemClicked(true);
            p2POrderViewModel.fetchParticularUserAdvertisement(
                adId, ordersData);
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15)
              : enableBorder.withOpacity(0.25),
          border: Border.all(color: hintLight, width: 1),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        width: 1,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: side,
                        color: side == stringVariables.buy ? green : red,
                        fontsize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: crypto,
                        fontsize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomCircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        child: FadeInImage.assetNetwork(
                          image: getImage(
                              marketViewModel, walletViewModel, crypto),
                          placeholder: splash,
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(10, 0),
                    child: Row(
                      children: [
                        CustomText(
                          fontfamily: 'GoogleSans',
                          text: capitalize(status),
                          color: themeColor,
                          fontsize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SvgPicture.asset(
                          p2pRightArrow,
                          height: 30,
                          color: themeColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.015,
              ),
              buildTextCard(
                  stringVariables.price + " $currencySymbol$price", fiat),
              CustomSizedBox(
                height: 0.015,
              ),
              buildTextCard(stringVariables.amount + " $amount $crypto", date,
                  false, true),
              CustomSizedBox(
                height: 0.015,
              ),
              buildTextCard(stringVariables.order + " $id",
                  "$currencySymbol$total", true, true, id),
              CustomSizedBox(
                height: 0.015,
              ),
              GestureDetector(
                onTap: () {
                  moveToChatView(context, id);
                },
                behavior: HitTestBehavior.opaque,
                child: CustomContainer(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.message,
                              color: hintLight,
                            ),
                            CustomSizedBox(
                              width: 0.015,
                            ),
                            CustomText(
                              align: TextAlign.center,
                              fontfamily: 'GoogleSans',
                              text: counterParty,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              color: hintLight,
                              fontsize: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  height: 20,
                  decoration: BoxDecoration(
                    color: black12,
                    borderRadius: BorderRadius.circular(
                      500.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextCard(String leftContent, String rightContent,
      [bool copyContent = false, bool rightBold = false, String? content]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: leftContent,
              color: hintLight,
              fontsize: 13,
              fontWeight: FontWeight.w400,
            ),
            copyContent
                ? Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: content ?? ""))
                        .then((_) {
                      ScaffoldMessenger.of(context)
                          .removeCurrentSnackBar();
                      customSnackBar.showSnakbar(
                          context,
                          stringVariables.copySnackBar,
                          SnackbarType.positive);
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    copy,
                  ),
                ),
              ],
            )
                : CustomSizedBox(
              height: 0,
              width: 0,
            )
          ],
        ),
        CustomSizedBox(
          width: 0.02,
        ),
        Flexible(
          child: CustomText(
            fontfamily: 'GoogleSans',
            overflow: TextOverflow.ellipsis,
            text: rightContent,
            fontsize: 13,
            fontWeight: rightBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
