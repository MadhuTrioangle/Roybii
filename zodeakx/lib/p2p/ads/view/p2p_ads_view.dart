import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSwitch.dart';
import 'package:zodeakx_mobile/p2p/ads/view/p2p_ads_options_bottom_sheet.dart';

import '../../../Common/IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import '../../../Common/Wallets/View/MustLoginView.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/model/p2p_advertisement.dart';
import '../../home/view/p2p_home_view.dart';
import '../view_model/p2p_ads_view_model.dart';

class P2PAdsView extends StatefulWidget {
  const P2PAdsView({Key? key}) : super(key: key);

  @override
  State<P2PAdsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PAdsView> with TickerProviderStateMixin {
  late P2PAdsViewModel viewModel;
  late IdentityVerificationCommonViewModel identityVerificationCommonViewModel;
  late TabController _tabController;
  late TabController typesTabController;
  late TabController statusTabController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PAdsViewModel>(context, listen: false);
    identityVerificationCommonViewModel =
        Provider.of<IdentityVerificationCommonViewModel>(context,
            listen: false);
    if (constant.userLoginStatus.value)
      identityVerificationCommonViewModel.getIdVerification();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.animation?.value == _tabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_tabController.index == 0) {
            viewModel.setCrypto(null);
            viewModel.setSide(null);
            viewModel.setStatus(null);
          } else if (_tabController.index == 1) {
            viewModel.setSide(null);
            viewModel.setStatus(null);
            viewModel.setCrypto(
                viewModel.staticPairs[viewModel.cryptoTabController.index]);
          } else if (_tabController.index == 2) {
            viewModel.setCrypto(null);
            viewModel.setStatus(null);
            viewModel.setSide(typesTabController.index == 0
                ? stringVariables.buy.toLowerCase()
                : stringVariables.sell.toLowerCase());
          } else {
            viewModel.setCrypto(null);
            viewModel.setSide(null);
            viewModel.setStatus(statusTabController.index == 0
                ? stringVariables.published.toLowerCase()
                : stringVariables.offline.toLowerCase());
          }
          viewModel.setTabLoading(true);
          viewModel.setListLoading(false);
          viewModel.fetchUserAdvertisement();
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setCrypto(null);
      viewModel.setSide(null);
    });
    typesTabController = TabController(length: 2, vsync: this);
    typesTabController.addListener(() {
      if (typesTabController.animation?.value == typesTabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setCrypto(null);
          viewModel.setStatus(null);
          viewModel.setSide(typesTabController.index == 0
              ? stringVariables.buy.toLowerCase()
              : stringVariables.sell.toLowerCase());
          viewModel.setTabLoading(true);
          viewModel.setListLoading(false);
          viewModel.fetchUserAdvertisement();
        });
      }
    });
    statusTabController = TabController(length: 2, vsync: this);
    statusTabController.addListener(() {
      if (statusTabController.animation?.value == statusTabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setCrypto(null);
          viewModel.setSide(null);
          viewModel.setStatus(statusTabController.index == 0
              ? stringVariables.published.toLowerCase()
              : stringVariables.offline.toLowerCase());
          viewModel.setTabLoading(true);
          viewModel.setListLoading(false);
          viewModel.fetchUserAdvertisement();
        });
      }
    });
    if (constant.userLoginStatus.value)
      viewModel.fetchP2PCurrency(initTabController);
  }

  initTabController() {
    viewModel.cryptoTabController =
        TabController(length: viewModel.staticPairs.length, vsync: this);
    viewModel.cryptoTabController.addListener(() {
      if (viewModel.cryptoTabController.animation?.value ==
          viewModel.cryptoTabController.index) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setSide(null);
          viewModel.setStatus(null);
          viewModel.setCrypto(
              viewModel.staticPairs[viewModel.cryptoTabController.index]);
          viewModel.setTabLoading(true);
          viewModel.setListLoading(false);
          viewModel.fetchUserAdvertisement();
        });
      }
    });
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

  takeToPostAd() {
    bool tfaStatus =
        identityVerificationCommonViewModel.viewModelVerification?.tfaStatus ==
            'verified';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (tfaStatus) {
      moveToPostAnAdView(context);
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.enableTfa, SnackbarType.negative);
    }
  }

  Widget buildHeader(Size size) {
    bool isLogin = constant.userLoginStatus.value;

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
                    if (constant.p2pPop.value) {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
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
              ],
            ),
          ),
          isLogin
              ? Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: stringVariables.myAds,
                    overflow: TextOverflow.ellipsis,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.bold,
                    fontsize: 20,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                )
              : CustomSizedBox(
                  width: 0,
                  height: 0,
                ),
          isLogin
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          if (identityVerificationCommonViewModel
                                  ?.viewModelVerification?.kyc?.kycStatus ==
                              "verified") {
                            await identityVerificationCommonViewModel
                                ?.getIdVerification();
                            takeToPostAd();
                          } else {
                            moveToTradingRequirement(context);
                          }
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: size.width / 35, left: 15),
                          child: CustomContainer(
                            width: 12,
                            height: 24,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  plusImage,
                                  color: black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : CustomSizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }

  buildMyAdsView(Size size) {
    return viewModel.needToLoad
        ? Center(child: CustomLoader())
        : Padding(
            padding: EdgeInsets.all(size.width / 35),
            child: CustomCard(
              outerPadding: 0,
              edgeInsets: size.width / 50,
              radius: 25,
              elevation: 0,
              child: DefaultTabController(
                length: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CustomContainer(
                      padding: 6,
                      width: 1,
                      height: 15,
                      decoration: BoxDecoration(
                        color: grey,
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                      ),
                      child: TabBar(
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
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
                        labelColor:
                            themeSupport().isSelectedDarkMode() ? black : white,
                        unselectedLabelColor: hintLight,
                        tabs: [
                          Tab(
                            text: stringVariables.all,
                          ),
                          Tab(
                            text: stringVariables.crypto,
                          ),
                          Tab(
                            text: stringVariables.types,
                          ),
                          Tab(
                            text: stringVariables.status,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                        child: CustomContainer(
                          width: 1,
                          height: 1,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              buildAllTab(size),
                              buildCyptoTab(size),
                              buildTypesTab(size),
                              buildStatusTab(size),
                            ],
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

  Widget buildAllTab(Size size) {
    return viewModel.tabLoader
        ? CustomLoader()
        : CustomDrawerTab(
            viewModel: viewModel,
            identityVerificationCommonViewModel:
                identityVerificationCommonViewModel,
          );
  }

  Widget buildCyptoTab(Size size) {
    return DefaultTabController(
      length: viewModel.staticPairs.length,
      child: Column(
        children: <Widget>[
          CustomContainer(
            width: 1,
            height: 17.5,
            child: viewModel.needToLoad
                ? CustomSizedBox(
                    width: 0,
                    height: 0,
                  )
                : cryptoTabBar(),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CustomContainer(
                  width: 1,
                  height: 1,
                  child: viewModel.tabLoader
                      ? CustomLoader()
                      : cryptoTabBarView()),
            ),
          ),
        ],
      ),
    );
  }

  cryptoTabBar() {
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
        controller: viewModel.cryptoTabController,
        tabs: buildCryptoTabBar(),
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

  buildCryptoTabBar() {
    List<Tab> tabs = [];
    viewModel.staticPairs.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }

  cryptoTabBarView() {
    return TabBarView(
      controller: viewModel.cryptoTabController,
      children: buildCryptoTabBarView(),
    );
  }

  buildCryptoTabBarView() {
    List<Widget> tabs = [];
    viewModel.staticPairs.forEach((element) {
      tabs.add(CustomDrawerTab(
        viewModel: viewModel,
        identityVerificationCommonViewModel:
            identityVerificationCommonViewModel,
      ));
    });
    return tabs;
  }

  Widget buildTypesTab(Size size) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          CustomContainer(
            width: 1,
            height: 17.5,
            child: typesTabBar(),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: CustomContainer(
                  width: 1,
                  height: 1,
                  child:
                      viewModel.tabLoader ? CustomLoader() : typesTabBarView()),
            ),
          ),
        ],
      ),
    );
  }

  typesTabBar() {
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
        controller: typesTabController,
        tabs: buildTypesTabBar(),
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

  buildTypesTabBar() {
    List<Tab> tabs = [];
    viewModel.typesStaticPairs.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }

  typesTabBarView() {
    return TabBarView(
      controller: typesTabController,
      children: buildTypesTabBarView(),
    );
  }

  buildTypesTabBarView() {
    List<Widget> tabs = [];
    viewModel.statusStaticPairs.forEach((element) {
      tabs.add(CustomDrawerTab(
        viewModel: viewModel,
        identityVerificationCommonViewModel:
            identityVerificationCommonViewModel,
      ));
    });
    return tabs;
  }

  Widget buildStatusTab(Size size) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          CustomContainer(
            width: 1,
            height: 17.5,
            child: statusTabBar(),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: CustomContainer(
                  width: 1,
                  height: 1,
                  child: viewModel.tabLoader
                      ? CustomLoader()
                      : statusTabBarView()),
            ),
          ),
        ],
      ),
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
        tabs: buildStatusTabBar(),
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

  buildStatusTabBar() {
    List<Tab> tabs = [];
    viewModel.statusStaticPairs.forEach((element) {
      tabs.add(Tab(text: element));
    });
    return tabs;
  }

  statusTabBarView() {
    return TabBarView(
      controller: statusTabController,
      children: buildStatusTabBarView(),
    );
  }

  buildStatusTabBarView() {
    List<Widget> tabs = [];
    viewModel.statusStaticPairs.forEach((element) {
      tabs.add(CustomDrawerTab(
        viewModel: viewModel,
        identityVerificationCommonViewModel:
            identityVerificationCommonViewModel,
      ));
    });
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PAdsViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
          appBar: AppHeader(size),
          child: constant.userLoginStatus.value == false
              ? MustLoginView()
              : viewModel.needToLoad
                  ? Center(child: CustomLoader())
                  : buildMyAdsView(size)),
    );
  }
}

class CustomDrawerTab extends StatefulWidget {
  P2PAdsViewModel? viewModel;
  IdentityVerificationCommonViewModel? identityVerificationCommonViewModel;

  CustomDrawerTab(
      {Key? key, this.viewModel, this.identityVerificationCommonViewModel})
      : super(key: key);

  @override
  CustomDrawerTabState createState() => new CustomDrawerTabState();
}

class CustomDrawerTabState extends State<CustomDrawerTab>
    with TickerProviderStateMixin {
  final _controller = ScrollController();
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge &&
          !(widget.viewModel?.listLoder ?? false)) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.viewModel?.setListLoading(true);
            currentPage++;
            widget.viewModel?.fetchUserAdvertisement(currentPage);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    P2PAdsViewModel? viewModel = widget.viewModel;
    int listCount = viewModel?.p2pAdvertisement?.data?.length ?? 0;
    List<Advertisement> advertisementList =
        viewModel?.p2pAdvertisement?.data ?? [];
    return listCount != 0
        ? ListView.separated(
            padding: EdgeInsets.only(top: size.width / 50),
            separatorBuilder: (context, index) => CustomSizedBox(
                  height: 0.02,
                ),
            controller: _controller,
            itemCount: listCount + ((viewModel?.listLoder ?? false) ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              Advertisement advertisement = index >= listCount
                  ? Advertisement()
                  : advertisementList[index];
              return index >= listCount
                  ? CustomLoader()
                  : buildListCard(
                      size,
                      advertisement,
                    );
            })
        : buildNoAdsView(size);
  }

  takeToPostAd() {
    bool tfaStatus = widget.identityVerificationCommonViewModel
            ?.viewModelVerification?.tfaStatus ==
        'verified';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (tfaStatus) {
      moveToPostAnAdView(context);
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.enableTfa, SnackbarType.negative);
    }
  }

  Widget buildNoAdsView(Size size) {
    return CustomContainer(
      width: 1,
      height: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            p2pNoAds,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            text: stringVariables.noAds,
            fontsize: 18,
            fontWeight: FontWeight.w400,
            color: hintLight,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomElevatedButton(
              buttoncolor: themeColor,
              color: black,
              press: () async {
                if (widget.identityVerificationCommonViewModel
                        ?.viewModelVerification?.kyc?.kycStatus ==
                    "verified") {
                  await widget.identityVerificationCommonViewModel
                      ?.getIdVerification();
                  takeToPostAd();
                } else {
                  moveToTradingRequirement(context);
                }
              },
              width: 3,
              isBorderedButton: true,
              maxLines: 1,
              icon: null,
              multiClick: true,
              text: stringVariables.postAd,
              radius: 25,
              height: size.height / 50,
              icons: false,
              blurRadius: 0,
              spreadRadius: 0,
              offset: Offset(0, 0)),
        ],
      ),
    );
  }

  Widget buildTextField(String title, String value,
      [bool copyText = false, bool alertText = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: title,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            alertText
                ? Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                SvgPicture.asset(
                  p2pOrderAttention,
                  color: hintLight,
                ),
              ],
            )
                : CustomSizedBox(
              width: 0,
              height: 0,
            )
          ],
        ),
        Row(
          children: [
            CustomContainer(
              width: 2.25,
              child: CustomText(
                fontfamily: 'GoogleSans',
                text: value,align: TextAlign.end,
                fontsize: 14,maxlines: 1,overflow: TextOverflow.ellipsis,softwrap: true,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            copyText
                ? Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: '${value}'))
                        .then((_) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      customSnackBar.showSnakbar(
                          context,
                          stringVariables.copySnackBar,
                          SnackbarType.positive);
                    });
                  },
                  child: SvgPicture.asset(
                    copy,
                  ),
                ),
                CustomSizedBox(
                  width: 0.02,
                ),
              ],
            )
                : CustomSizedBox(
              width: 0,
              height: 0,
            )
          ],
        ),
      ],
    );
  }

  dynamic _showModal(BuildContext context, String id) async {
    final result =
        await Navigator.of(context).push(P2PAdsOptionsModal(context, id));
  }

  buildListCard(
    Size size,
    Advertisement advertisement,
  ) {
    String adType = capitalize(advertisement.advertisementType!);
    String id = advertisement.id!;
    bool status = advertisement.tradeStatus!.toLowerCase() ==
        stringVariables.published.toLowerCase();
    String cryptoCurrency = adType == stringVariables.buy
        ? advertisement.toAsset!
        : advertisement.fromAsset!;
    double cryptoAmount =
        double.parse(trimDecimals(advertisement.amount!.toString()));
    String fiatCurrency = adType == stringVariables.buy
        ? advertisement.fromAsset!
        : advertisement.toAsset!;
    double minAmount =
        double.parse(trimDecimals(advertisement.minTradeOrder!.toString()));
    double maxAmount =
        double.parse(trimDecimals(advertisement.maxTradeOrder!.toString()));
    List<PaymentMethod> paymentMethod = (advertisement.paymentMethod ?? []);
    List<Widget> paymentCard = [];
    int paymentCardListCount = paymentMethod.length;
    for (var i = 0; i < paymentCardListCount; i++) {
      paymentCard
          .add(paymentMethodsCard(size, paymentMethod[i].paymentMethodName!));
    }

    P2PAdsViewModel? viewModel = widget.viewModel;

    updateStatus() {
      if (status) {
        advertisement.tradeStatus = stringVariables.offline.toLowerCase();
      } else {
        advertisement.tradeStatus = stringVariables.published.toLowerCase();
      }
    }

    return GestureDetector(
      onTap: () {
        moveToAdsDetailsView(context, id);
      },
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
        height: isSmallScreen(context) ? 4.1 : 4.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
                      text: adType,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                      color: adType == stringVariables.buy ? green : red,
                    ),
                    CustomSizedBox(
                      width: 0.01,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
                      text: cryptoCurrency,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                    ),
                    CustomSizedBox(
                      width: 0.01,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
                      text: stringVariables.p2pWith,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                    ),
                    CustomSizedBox(
                      width: 0.01,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
                      text: fiatCurrency,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomContainer(
                      constraints: BoxConstraints(maxWidth: size.width / 2.4),
                      decoration: BoxDecoration(
                        color: status ? themeColor : switchBackground,
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2.0),
                        child: CustomText(
                          fontfamily: 'GoogleSans',
                          text: status
                              ? stringVariables.online
                              : stringVariables.offline,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 12,
                          color: white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomSwitch(
                        activeColor: themeColor,
                        inactiveColor: switchBackground,
                        toggleColor: white,
                        width: 30,
                        value: status,
                        onToggle: (value) {
                          String tradeStatus = "";
                          if (status) {
                            tradeStatus = stringVariables.offline.toLowerCase();
                          } else {
                            tradeStatus =
                                stringVariables.published.toLowerCase();
                          }
                          viewModel?.editAdTradeStatus(
                              advertisement.id!, tradeStatus, updateStatus);
                        }),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                  ],
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTextField(
                stringVariables.adNumber, id, true),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTextField(
                stringVariables.amount, "$cryptoAmount $cryptoCurrency"),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTextField(
                stringVariables.limit, "$minAmount - $maxAmount $fiatCurrency"),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: paymentCard),
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _showModal(context, id);
                      },
                      child: CustomContainer(
                        width: 25,
                        height: 45,
                        child: Icon(
                          Icons.more_vert_sharp,
                          color: themeSupport().isSelectedDarkMode()
                              ? white
                              : black,
                          size: 17.5,
                        ),
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.01,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
