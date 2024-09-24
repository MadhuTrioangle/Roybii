import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/transfer_history/view/transfer_history_filter_model.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../p2p/home/view/p2p_home_view.dart';
import '../../wallet_select/viewModel/wallet_select_view_model.dart';
import '../model/funding_transfer_history_details.dart';
import '../viewModel/transfer_history_view_model.dart';

class TransferHistoryView extends StatefulWidget {
  const TransferHistoryView({Key? key}) : super(key: key);

  @override
  State<TransferHistoryView> createState() => _TransferHistoryViewState();
}

class _TransferHistoryViewState extends State<TransferHistoryView>
    with TickerProviderStateMixin {
  late TransferHistoryViewModel viewModel;
  late WalletSelectViewModel walletSelectViewModel;
  late TabController transferTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
    walletSelectViewModel =
        Provider.of<WalletSelectViewModel>(context, listen: false);
    transferTabController = TabController(length: 2, vsync: this);
    transferTabController.addListener(() {
      viewModel.setTabIndex(transferTabController.index);
      if (transferTabController.animation?.value ==
          transferTabController.index) {
        if (transferTabController.index == 0) {
          viewModel.setLoading(true);
          viewModel.fetchTransferHistoryForFunding();
        } else {
          viewModel.setLoading(true);
          viewModel.fetchTransferHistoryForFunding();
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setTabIndex(0);
      viewModel.setDate();
      viewModel.setLoading(true);
      viewModel.fetchTransferHistoryForFunding();
      //   viewModel.fetchTransferHistory(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<TransferHistoryViewModel>();
    walletSelectViewModel = context.watch<WalletSelectViewModel>();

    return Provider<TransferHistoryViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return transferHistory(
          context,
        );
      },
    );
  }

  Future<bool> pop() async {
    walletSelectViewModel.selectFirstWallet(stringVariables.spotWallet);
    walletSelectViewModel.selectSecondWallet(stringVariables.funding);
    Navigator.pop(context);
    return false;
  }

  Widget transferHistory(BuildContext context) {
    return WillPopScope(
      onWillPop: pop,
      child: CustomScaffold(
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
                        walletSelectViewModel
                            .selectFirstWallet(stringVariables.spotWallet);
                        walletSelectViewModel
                            .selectSecondWallet(stringVariables.funding);
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
                      fontfamily: 'InterTight',
                      fontsize: 21,
                      fontWeight: FontWeight.bold,
                      text: stringVariables.transferHistory,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                  constant.fundingStatus == true
                      ? Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _showModal(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: SvgPicture.asset(
                                stakingFilter,
                              ),
                            ),
                          ),
                        )
                      : CustomSizedBox(),
                ],
              ),
            ),
          ),
          child: CustomCard(
            radius: 15,
            outerPadding: 15,
            edgeInsets: 8,
            elevation: 0,
            child: Column(children: [transferTabbar(), transferTabbarView()]),
          )),
    );
  }

  Widget transferTabbar() {
    return DecoratedTabBar(
      tabBar: TabBar(
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          fontFamily: 'InterTight',
        ),
        indicatorWeight: 0,
        indicator: TabBarIndicator(color: themeColor, radius: 4),
        isScrollable: false,
        labelColor: themeSupport().isSelectedDarkMode() ? white : black,
        labelPadding: EdgeInsets.only(right: 8, left: 8),
        unselectedLabelColor: hintLight,
        controller: transferTabController,
        tabs: buildTabBar(),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: hintLight.withOpacity(0.25),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  buildTabBar() {
    List<Tab> tabs = [];
    if (constant.fundingStatus == true) {
      tabs.add(Tab(text: stringVariables.crypto));
      tabs.add(Tab(text: stringVariables.cash));
    } else {
      tabs.add(Tab(text: stringVariables.cross));
      tabs.add(Tab(text: stringVariables.isolated));
    }

    return tabs;
  }

  Widget transferTabbarView() {
    return Flexible(
      child: CustomContainer(
        width: 1,
        height: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: viewModel.needToLoad
              ? CustomLoader()
              : TabBarView(
                  controller: transferTabController,
                  children: buildTabBarView(),
                ),
        ),
      ),
    );
  }

  buildTabBarView() {
    return [
      CustomContainer(
        height: 1,
        width: 1,
        child: cryptoSection(),
      ),
      CustomContainer(
        height: 1,
        width: 1,
        child: cashSection(),
      )
    ];
  }

  Widget cryptoSection() {
    return Column();
    // List<GetUserFundingWalletTransferDetails> list = viewModel.cryptoHistory;
    // int itemCount = list.length;
    // bool addMore = itemCount != (viewModel.crossTransferHistory?.total ?? 0);
    // int page = viewModel.crossTransferHistory?.page ?? 0;
    // return itemCount == 0
    //     ? noOrderHistory()
    //     : ListView.builder(
    //         itemCount: itemCount,
    //         itemBuilder: (context, index) {
    //           return addMore && index == itemCount
    //               ? GestureDetector(
    //                   onTap: () {
    //                     viewModel.fetchTransferHistory(page);
    //                   },
    //                   behavior: HitTestBehavior.opaque,
    //                   child: Column(
    //                     children: [
    //                       CustomSizedBox(
    //                         height: 0.0075,
    //                       ),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           CustomText(
    //                             fontfamily: 'InterTight',
    //                             text: stringVariables.more,
    //                             fontsize: 16,
    //                             fontWeight: FontWeight.w400,
    //                             color: themeColor,
    //                           ),
    //                         ],
    //                       ),
    //                       CustomSizedBox(
    //                         height: 0.005,
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : buildCrossTransfer(list[index]);
    //         },
    //       );
  }

  Widget buildCrossTransfer(GetUserFundingWalletTransferDetails ordersData) {
    String coin = ordersData.currencyCode.toString();
    String date =
        convertToIST((ordersData.createdDate ?? DateTime.now()).toString());
    String amount =
        trimDecimalsForBalance((ordersData.amount ?? "0").toString());
    String fromWallet = ordersData.fromWallet.toString() == "spot_wallet"
        ? stringVariables.spotWallet
        : stringVariables.funding;

    String toWallet = ordersData.toWallet.toString() == "spot_wallet"
        ? stringVariables.spotWallet
        : stringVariables.funding;

    String status = ordersData.status.toString();
    return constant.fundingStatus == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                height: 0.009,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: fromWallet + " > " + toWallet,
                    fontsize: 14,
                  ),
                  CustomText(
                    text: amount + " " + coin,
                    fontsize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.009,
              ),
              CustomText(text: date),
              CustomSizedBox(height: 0.01),
              CustomText(
                text: status,
                fontWeight: FontWeight.w400,
                fontsize: 14,
                color: stackCardText,
              ),
              CustomSizedBox(height: 0.01),
              Divider(
                thickness: 0.5,
                color: stackCardText,
              ),
            ],
          )
        : Column(
            children: [
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: coin,
                    fontWeight: FontWeight.bold,
                    fontsize: 16,
                  ),
                  CustomText(
                    text: date,
                    color: stackCardText,
                    fontsize: 14,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.marginAccount,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.amount,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                  CustomText(
                    text: amount,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.autoTopTranferIn,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.status,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                  CustomText(
                    text: status,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              Divider(
                height: 0.2,
                color: stackCardText,
                thickness: 0.5,
              ),
              CustomSizedBox(
                height: 0.01,
              ),
            ],
          );
  }

  Widget cashSection() {
    return Column();
    // List<GetUserFundingWalletTransferDetails>? list = viewModel.fiatHistory;
    // int itemCount = list!.length;
    // bool addMore = itemCount != (viewModel.isolatedTransferHistory?.total ?? 0);
    // int page = viewModel.isolatedTransferHistory?.page ?? 0;
    // return itemCount == 0
    //     ? noOrderHistory()
    //     : ListView.builder(
    //         itemCount: itemCount + (addMore ? 1 : 0),
    //         itemBuilder: (context, index) {
    //           return addMore && index == itemCount
    //               ? GestureDetector(
    //                   onTap: () {
    //                     viewModel.fetchTransferHistory(page);
    //                   },
    //                   behavior: HitTestBehavior.opaque,
    //                   child: Column(
    //                     children: [
    //                       CustomSizedBox(
    //                         height: 0.005,
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               : buildIsolatedTransfer(list[index]);
    //         },
    //       );
  }

  Widget noOrderHistory() {
    return Center(
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.15,
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

  Widget buildIsolatedTransfer(GetUserFundingWalletTransferDetails ordersData) {
    String coin = ordersData.currencyCode.toString();
    String date =
        convertToIST((ordersData.createdDate ?? DateTime.now()).toString());
    String amount =
        trimDecimalsForBalance((ordersData.amount ?? "0").toString());
    String fromWallet = ordersData.fromWallet.toString() == "spot_wallet"
        ? stringVariables.spotWallet
        : stringVariables.funding;

    String toWallet = ordersData.toWallet.toString() == "spot_wallet"
        ? stringVariables.spotWallet
        : stringVariables.funding;

    String status = ordersData.status.toString();
    return constant.fundingStatus == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                height: 0.009,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: fromWallet + " > " + toWallet,
                    fontsize: 14,
                  ),
                  CustomText(
                    text: amount + " " + coin,
                    fontsize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.009,
              ),
              CustomText(text: date),
              CustomSizedBox(height: 0.01),
              CustomText(
                text: status,
                fontWeight: FontWeight.w400,
                fontsize: 14,
                color: stackCardText,
              ),
              CustomSizedBox(height: 0.01),
              Divider(
                thickness: 0.5,
                color: stackCardText,
              ),
            ],
          )
        : Column(
            children: [
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: coin,
                    fontWeight: FontWeight.bold,
                    fontsize: 16,
                  ),
                  CustomText(
                    text: date,
                    color: stackCardText,
                    fontsize: 14,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.marginAccount,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.amount,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                  CustomText(
                    text: amount,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.autoTopTranferIn,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.status,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                  CustomText(
                    text: status,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: stackCardText,
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              Divider(
                height: 0.2,
                color: stackCardText,
                thickness: 0.5,
              ),
              CustomSizedBox(
                height: 0.01,
              ),
            ],
          );
  }

  dynamic _showModal(
    BuildContext context,
  ) async {
    final result =
        await Navigator.of(context).push(TransferHistoryFilterModel(context));
  }
}
