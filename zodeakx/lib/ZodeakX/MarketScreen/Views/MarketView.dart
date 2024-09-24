import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/Exchange/ViewModel/ExchangeViewModel.dart';
import 'package:zodeakx_mobile/Common/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCircleAvatar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';

class MarketView extends StatefulWidget {
  MarketView({Key? key}) : super(key: key);

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  bool isLogin = false;
  int selectedScreenIndex = 0;
  late MarketViewModel viewModel;
  late RegisterViewModel registerViewModel;
  late WalletViewModel walletViewModel;
  late ExchangeViewModel exchangeViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<MarketViewModel>(context, listen: false);
    registerViewModel = Provider.of<RegisterViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    exchangeViewModel = Provider.of<ExchangeViewModel>(context, listen: false);
    viewModel.getTradePairs();
    if (constant.userLoginStatus.value) walletViewModel.getDashBoardBalance();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setListRange(10);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    viewModel.leaveSocket();
  }

  Widget build(BuildContext context) {
    viewModel = context.watch<MarketViewModel>();
    registerViewModel = context.watch<RegisterViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    exchangeViewModel = context.watch<ExchangeViewModel>();
    isLogin = constant.userLoginStatus.value;
    String email = constant.pref?.getString("userEmail") ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      (viewModel.noInternet)
          ? customSnackBar.showSnakbar(context,
              'Check your internet connection !', SnackbarType.negative)
          : (viewModel.serverError)
              ? customSnackBar.showSnakbar(context,
                  'There is a problem in server', SnackbarType.negative)
              : "";
    });

    return Provider<MarketViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return showMarket(context, email);
      },
    );
  }

  /// Market Screen
  Widget showMarket(BuildContext context, String email) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
        appBar: AppHeader(context),
        child: Center(
          child: Column(
            children: [
              isLogin == false
                  ? LoginButton(
                      context,
                    )
                  : SizedBox(),
              TradePairs(
                context,
              ),
              sizedbox(context),
            ],
          ),
        ),
      ),
    );
  }

  ///Market Screen APPBAR
  AppBar AppHeader(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: buildHeader());
  }

  Widget buildHeader() {
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: CustomContainer(
                  width: 11,
                  height: 22,
                  child: SvgPicture.asset(
                    userImage,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              fontfamily: 'GoogleSans',
              fontsize: 23,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              text: stringVariables.market,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }

  ///Login and signup Button to move LoginPage
  Widget LoginButton(
    BuildContext context,
  ) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomContainer(
            height: 16,
            width: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    text: stringVariables.marketScreenHeading,
                    fontfamily: 'GoogleSans',
                    fontsize: 20),
                SizedBox(
                  width: checkBrightness.value == Brightness.dark ? 10 : 10,
                ),
                SvgPicture.asset(
                    checkBrightness.value == Brightness.dark
                        ? lightlogo
                        : darklogo,
                    height: themeSupport().isSelectedDarkMode() ? 30 : 30),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
            child: CustomText(
                fontfamily: 'GoogleSans',
                text: stringVariables.marketScreenSubheading,
                color: textGrey,
                overflow: TextOverflow.ellipsis),
          ),
          CustomElevatedButton(
              text: stringVariables.marketScreenButtonName,
              color: black,
              press: () async {
                var listenViewModel =
                    Provider.of<RegisterViewModel>(context, listen: false);
                listenViewModel.closeFocus();
                registerViewModel.setActive(false);
                constant.previousScreen.value = ScreenType.Market;
                viewModel.leaveSocket();
                await moveToRegister(context);
              },
              radius: 25,
              blurRadius: 16,
              spreadRadius: 4,
              offset: Offset(0, 0),
              multiClick: true,
              buttoncolor: themeColor,
              width: 1.2,
              height: MediaQuery.of(context).size.height / 50,
              isBorderedButton: false,
              maxLines: 1,
              icons: false,
              icon: null),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  List<dynamic> getImageList(
      MarketViewModel viewModel, WalletViewModel walletViewModel, int index) {
    List<dynamic> list = [];
    list = isLogin
        ? (walletViewModel.viewModelDashBoardBalance != null)
            ? (walletViewModel.viewModelDashBoardBalance!.isNotEmpty)
                ? walletViewModel.viewModelDashBoardBalance!
                    .where((element) =>
                        element.currencyCode ==
                        viewModel.viewModelTradePairs?[index].symbol!
                            .split("/")
                            .first)
                    .toList()
                : []
            : []
        : (viewModel.getCurrencies != null)
            ? (viewModel.getCurrencies!.isNotEmpty)
                ? viewModel.getCurrencies!
                    .where((element) =>
                        element.currencyCode ==
                        viewModel.viewModelTradePairs?[index].symbol!
                            .split("/")
                            .first)
                    .toList()
                : []
            : [];
    return list;
  }

  /// TradePairs Lists in ListViewBuilder
  Widget TradePairs(
    BuildContext context,
  ) {
    return Expanded(
      child: CustomCard(
        radius: 35,
        edgeInsets: 10,
        outerPadding: 10,
        elevation: 0,
        child: CustomContainer(
          height: isLogin ? 1.41 : 1.99,
          width: 1.1,
          child: (viewModel.needToLoad)
              ? CustomLoader()
              : RefreshIndicator(
                  color: themeColor,
                  onRefresh: () {
                    return viewModel.getTradePairs();
                  },
                  child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >
                          (70 * viewModel.listRange)) {
                        viewModel.updateSocketTradePairs(1);
                        viewModel.setListRange(viewModel.listRange + 10);
                      } else if (notification.metrics.pixels <
                          (70 * (viewModel.listRange - 10))) {
                        viewModel.updateSocketTradePairs(0);
                        viewModel.setListRange(viewModel.listRange - 10);
                      }

                      return true;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: viewModel.viewModelTradePairs?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        List<dynamic>? imageList =
                            getImageList(viewModel, walletViewModel, index);
                        String? image = (imageList == null || imageList.isEmpty)
                            ? ""
                            : imageList.first.image;
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            CommonViewModel commonViewModel = Provider.of<
                                    CommonViewModel>(
                                NavigationService.navigatorKey.currentContext!,
                                listen: false);
                            exchangeViewModel.setTradePair(
                                "${viewModel.viewModelTradePairs?[index].symbol!}");
                            commonViewModel.setActive(1);
                            constant.marketPair.value =
                                "${viewModel.viewModelTradePairs?[index].symbol!}";
                          },
                          child: Container(
                            child: ListTile(
                              leading: CustomCircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: image!.isNotEmpty
                                    ? CustomNetworkImage(image: image)
                                    : Image.asset(splash),
                              ),
                              title: CustomText(
                                  fontfamily: 'GoogleSans',
                                  text: viewModel
                                          .viewModelTradePairs?[index].symbol ??
                                      "${stringVariables.coinName}",
                                  overflow: TextOverflow.ellipsis),
                              subtitle: CustomText(
                                  fontfamily: 'GoogleSans',
                                  text:
                                      "Vol:${isDigit('${viewModel.viewModelTradePairs?[index].quoteVolume}')}",
                                  overflow: TextOverflow.ellipsis),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                      fontfamily: 'GoogleSans',
                                      text:
                                          '${isDigit('${viewModel.viewModelTradePairs?[index].lastPrice}')}',
                                      overflow: TextOverflow.ellipsis),
                                  CustomText(
                                      fontfamily: 'GoogleSans',
                                      text:
                                          '${trimAs2('${viewModel.viewModelTradePairs?[index].priceChangePercent}')} %',
                                      color:
                                          "${trimAs2(viewModel.viewModelTradePairs?[index].priceChangePercent.toString() ?? "0") ?? "${stringVariables.coinChange}"}"
                                                  .contains('-')
                                              ? pink
                                              : green,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  ///need space between bottomNavigation and tradePairsCard Widget
  Widget sizedbox(BuildContext context) {
    return CustomSizedBox(
      height: 0.03,
    );
  }

  displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              text: stringVariables.address,
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async {},
                  child: CustomText(text: stringVariables.getLocation)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: CustomText(text: stringVariables.submit)),
            ],
          );
        });
  }
}
