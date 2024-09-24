import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/View/MustLoginView.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/view/p2p_home_view.dart';
import '../model/UserOrdersModel.dart';
import '../view_model/p2p_order_view_model.dart';

class P2POrderView extends StatefulWidget {
  const P2POrderView({Key? key}) : super(key: key);

  @override
  State<P2POrderView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2POrderView>
    with TickerProviderStateMixin {
  late P2POrderViewModel viewModel;
  late TabController _tabController;
  late TabController _pendingTabController;
  late TabController _completedTabController;
  bool isLogin = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2POrderViewModel>(context, listen: false);
    if (constant.userLoginStatus.value) viewModel.fetchUserOrdersPending();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.animation?.value == _tabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {

          viewModel.setLoading(true);
          if (_tabController.index == 0) {
            viewModel.fetchUserOrdersPending(_pendingTabController.index);
          } else {
            viewModel.fetchUserOrdersCompleted(_completedTabController.index);
          }
        });
      }
    });
    _pendingTabController =
        TabController(length: viewModel.pendingItems.length, vsync: this);
    _pendingTabController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.setLoading(true);
        viewModel.fetchUserOrdersPending(_pendingTabController.index);
      });
    });
    _completedTabController =
        TabController(length: viewModel.completedItems.length, vsync: this);
    _completedTabController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {

        viewModel.setLoading(true);
        viewModel.fetchUserOrdersCompleted(_completedTabController.index);
      });
    });

/*
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
*/
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2POrderViewModel>();
    isLogin = constant.userLoginStatus.value;
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: isLogin ? buildP2POrderView(size) : MustLoginView(),
      ),
    );
  }

  Widget buildP2POrderView(Size size) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: CustomContainer(
              width: 1,
              height: 1,
              child: Padding(
                padding: EdgeInsets.all(size.width / 35),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    CustomCard(
                      outerPadding: 0,
                      edgeInsets: 0,
                      radius: 25,
                      elevation: 0,
                      child: buildPendingTab(size),
                    ),
                    CustomCard(
                      outerPadding: 0,
                      edgeInsets: 0,
                      radius: 25,
                      elevation: 0,
                      child: buildCompletedTab(size),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPendingTab(Size size) {
    return DefaultTabController(
      length: viewModel.pendingItems.length,
      child: CustomContainer(
        height: 1,
        child: Column(
          children: <Widget>[
            CustomSizedBox(
              height: 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 35),
              child: CustomContainer(
                width: 1,
                height: 17.5,
                child: pendingTabBar(size),
              ),
            ),
            pendingTabBarView(size),
          ],
        ),
      ),
    );
  }

  Widget buildCompletedTab(Size size) {
    return DefaultTabController(
      length: viewModel.completedItems.length,
      child: CustomContainer(
        width: 1,
        height: 1,
        child: Column(
          children: <Widget>[
            CustomSizedBox(
              height: 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 35),
              child: CustomContainer(
                width: 1,
                height: 17.5,
                child: completedTabBar(size),
              ),
            ),
            completedTabBarView(size),
          ],
        ),
      ),
    );
  }

  buildPendingTabBar() {
    List<Tab> tabs = [];
    viewModel.pendingItems.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }

  buildCompletedTabBar() {
    List<Tab> tabs = [];
    viewModel.completedItems.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }

  pendingTabBar(Size size) {
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
        labelPadding: EdgeInsets.symmetric(horizontal: size.width / 19.75),
        labelColor: themeColor,
        unselectedLabelColor: hintLight,
        controller: _pendingTabController,
        tabs: buildPendingTabBar(),
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

  completedTabBar(Size size) {
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
        isScrollable: false,
        labelPadding: EdgeInsets.zero,
        labelColor: themeColor,
        unselectedLabelColor: hintLight,
        controller: _completedTabController,
        tabs: buildCompletedTabBar(),
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

  buildPendingTabBarView() {
    List<Widget> tabs = [];
    List<OrdersData> ordersData = [];
    viewModel.pendingItems.forEach((element) {
      switch (element.toLowerCase()) {
        case "all":
          ordersData = viewModel.userOrdersPending?.data ?? [];
          break;
        case "unpaid":
          ordersData = viewModel.unpaidOrders ?? [];
          break;
        case "paid":
          ordersData = viewModel.paidOrders ?? [];
          break;
        case "appeal pending":
          ordersData = viewModel.appealOrders ?? [];
          break;
        default:
          ordersData = viewModel.userOrdersPending?.data ?? [];
          break;
      }
      tabs.add(CustomDrawerTab(
        tabName: element,
        isPending: true,
        viewModel: viewModel,
        ordersData: ordersData,
      ));
    });
    return tabs;
  }

  buildCompletedTabBarView() {
    List<Widget> tabs = [];
    List<OrdersData> ordersData = [];
    viewModel.completedItems.forEach((element) {
      switch (element.toLowerCase()) {
        case "all":
          ordersData = viewModel.userOrdersCompleted?.data ?? [];
          break;
        case "completed":
          ordersData = viewModel.completedOrders ?? [];
          break;
        case "cancelled":
          ordersData = viewModel.cancelledOrders ?? [];
          break;
        default:
          ordersData = viewModel.userOrdersCompleted?.data ?? [];
          break;
      }
      tabs.add(CustomDrawerTab(
        tabName: element,
        isPending: false,
        viewModel: viewModel,
        ordersData: ordersData,
      ));
    });
    return tabs;
  }

  pendingTabBarView(Size size) {
    return Expanded(
      child: CustomContainer(
        height: 1,
        child: Padding(
          padding: EdgeInsets.all(size.width / 35),
          child: TabBarView(
            controller: _pendingTabController,
            children: buildPendingTabBarView(),
          ),
        ),
      ),
    );
  }

  completedTabBarView(Size size) {
    return Expanded(
      child: CustomContainer(
        height: 1,
        child: Padding(
          padding: EdgeInsets.all(size.width / 35),
          child: TabBarView(
            controller: _completedTabController,
            children: buildCompletedTabBarView(),
          ),
        ),
      ),
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (constant.p2pPop.value) {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  constant.p2pPop.value = false;
                } else {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: size.width / 35, right: 15),
                child: SvgPicture.asset(
                  backArrow,
                ),
              ),
            ),
          ),
          isLogin
              ? buildHeaderCard(size)
              : CustomSizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }

  Widget buildHeaderCard(
    Size size,
  ) {
    return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(left: size.width / 35),
          child: CustomContainer(
            padding: 6,
            width: 1.6,
            height: 15,
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode() ? card_dark : white,
              borderRadius: BorderRadius.circular(
                50.0,
              ),
            ),
            child: TabBar(
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
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
                  text: stringVariables.pending,
                ),
                Tab(
                  text: stringVariables.completed,
                ),
              ],
            ),
          ),
        ));
  }
}

class CustomDrawerTab extends StatefulWidget {
  String tabName;
  bool isPending;
  P2POrderViewModel viewModel;
  List<OrdersData> ordersData;

  CustomDrawerTab({
    Key? key,
    required this.tabName,
    required this.isPending,
    required this.viewModel,
    required this.ordersData,
  }) : super(key: key);

  @override
  CustomDrawerTabState createState() => new CustomDrawerTabState();
}

class CustomDrawerTabState extends State<CustomDrawerTab> {
  final _controller = ScrollController();
  int currentPage = 0;
  int type = 0;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    P2POrderViewModel viewModel = widget.viewModel;
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    _controller.addListener(() {
      if (_controller.position.atEdge && !(viewModel?.listLoder ?? false)) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel?.setListLoading(true);
            currentPage++;
            if (widget.isPending) {
              type = viewModel.pendingItems.indexOf(widget.tabName);
              viewModel.fetchUserOrdersPending(type, currentPage);
            } else {
              type = viewModel.completedItems.indexOf(widget.tabName);
              viewModel.fetchUserOrdersCompleted(type, currentPage);
            }
          });
        }
      }
    });
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

  Widget buildOrdersData(Size size, List<OrdersData> ordersDataList) {
    int listCount = ordersDataList.length;
    return ListView.separated(
        padding: EdgeInsets.only(top: size.width / 50),
        separatorBuilder: (context, index) => CustomSizedBox(
              height: 0.02,
            ),
        controller: _controller,
        itemCount: listCount + ((widget.viewModel?.listLoder ?? false) ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          OrdersData ordersData =
              index >= listCount ? OrdersData() : ordersDataList[index];
          return index >= listCount
              ? CustomLoader()
              : buildListCard(size, ordersData);
        });
  }

  Widget buildListCard(Size size, OrdersData ordersData) {
    String side = capitalize(ordersData.tradeType ?? "");
    String crypto = side == stringVariables.buy
        ? ordersData.toAsset ?? ""
        : ordersData.fromAsset ?? "";
    String fiat = side == stringVariables.buy
        ? ordersData.fromAsset ?? ""
        : ordersData.toAsset ?? "";
    String status = ordersData.status ?? "";
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
          if(!widget.viewModel.itemClicked) {
            widget.viewModel.setItemClicked(true);
            widget.viewModel.fetchParticularUserAdvertisement(adId, ordersData);
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
        height: isSmallScreen(context) ? 3.75 : 4.25,
        child: Padding(
          padding: EdgeInsets.all(size.width / 35),
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
                          image: getImage(crypto),
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
                          color: isCompleted ? hintLight : themeColor,
                          fontsize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        SvgPicture.asset(
                          p2pRightArrow,
                          height: 30,
                          color: isCompleted ? hintLight : themeColor,
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
                  constraints: BoxConstraints(maxWidth: size.width / 1.25),
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
              fontsize: 14,
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
                          Clipboard.setData(
                                  ClipboardData(text: content ?? ""))
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
        Flexible(
          child: CustomText(
            fontfamily: 'GoogleSans',
            overflow: TextOverflow.ellipsis,
            text: rightContent,
            fontsize: 14,
            fontWeight: rightBold ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String getImage(String crypto) {
    List<dynamic> list = [];
    list = constant.userLoginStatus.value
        ? (walletViewModel.viewModelDashBoardBalance != null)
            ? (walletViewModel.viewModelDashBoardBalance!.isNotEmpty)
                ? walletViewModel.viewModelDashBoardBalance!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : []
        : (marketViewModel.getCurrencies != null)
            ? (marketViewModel.getCurrencies!.isNotEmpty)
                ? marketViewModel.getCurrencies!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : [];
    return (list == null || list.isEmpty) ? "" : list.first.image;
  }

  @override
  Widget build(BuildContext context) {
    P2POrderViewModel viewModel = widget.viewModel;
    List<OrdersData> ordersData = widget.ordersData;
    Size size = MediaQuery.of(context).size;
    return viewModel.needToLoad
        ? CustomLoader()
        : ordersData.length == 0
            ? noOrderHistory()
            : buildOrdersData(size, ordersData);
  }
}
