import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/View/MustLoginView.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../ViewModel/OrdersViewModel.dart';
import 'cancel_dialog.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView>
    with SingleTickerProviderStateMixin {
  int selectedScreenIndex = 2;
  late TabController _tabController;
  late OrdersViewModel viewModel;
  late MarketViewModel marketViewModel;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    viewModel = Provider.of<OrdersViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    viewModel.tradeHistoryPageCounter = 0;
    viewModel.cancelHistoryPageCounter = 0;
    if (constant.userLoginStatus.value) viewModel.getOpenOrders();
    _tabController.addListener(() {
      if( _tabController.index == 0){
        viewModel.getOpenOrders();
      }else if( _tabController.index == 1){
        viewModel.cancelPage = 0;
        viewModel.getCancelledOrders(0);
      }else if( _tabController.index == 2){
        viewModel.getTradeHistory(0);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<OrdersViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider<OrdersViewModel>(
      create: (context) => viewModel,
      child: buildOrdersView(size),
    );
  }

  WillPopScope buildOrdersView(Size size) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomScaffold(
        appBar: AppHeader(context),
        child: constant.userLoginStatus.value == false
            ? MustLoginView()
            : viewModel.needToLoad
                ? Center(child: CustomLoader())
                : buildTabSection(size),
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
              text: stringVariables.orders,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }



  Widget buildTabSection(Size size) {
    int openLength = viewModel.openOrderHistory?.length ?? 0;
    int cancelOrderLength = viewModel.cancelOrders?.length ?? 0;
    securedPrint("viewModel.cancelTotal${viewModel.cancelTotal}");
    int historyLength = viewModel.tradeHistory?.data?.length ?? 0;
   return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          CustomContainer(
            padding: 4,
            width: 1.25,
            height: 15.15,
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
              labelColor: themeSupport().isSelectedDarkMode() ? black : white,
              unselectedLabelColor: hintLight,labelStyle: TextStyle(fontSize: 13),
              tabs: [
                Tab(
                  text: stringVariables.open,
                ),
                Tab(
                  text: stringVariables.cancelled,
                ),
                Tab(
                  text: stringVariables.history_orders,
                ),
              ],
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomContainer(
            width: 1,
            height: 1.48,
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  color: themeColor,
                  onRefresh: () {
                    return viewModel.getOpenOrders();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: (openLength == 0)
                        ? Padding(
                      padding: EdgeInsets.only(top: size.height / 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            align: TextAlign.center,
                            text: stringVariables.noOpenOrders,
                            color: textGrey,
                            softwrap: true,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(
                          left: size.width / 50, right: size.width / 50),
                      child: Column(
                        children: [
                          CustomCard(
                            radius: 25,
                            edgeInsets: 0,
                            outerPadding: 0,
                            child: Column(
                              children: [
                                ListView.builder(
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount:openLength,
                                    // openLength < viewModel.openCounter
                                    //     ? openLength
                                    //     : viewModel.openCounter,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          moveToOrderDetails(
                                            context,"openOrders",
                                            viewModel.openOrderHistory![index],
                                          );
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Column(
                                          children: [
                                            CustomContainer(
                                              width: 1,
                                              height: 4.875,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: size.height / 50,
                                                    left: size.width / 25,
                                                    right:
                                                    size.width / 25),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        CustomText(
                                                          text: viewModel
                                                              .openOrderHistory![
                                                          index]
                                                              .tradeType,
                                                          softwrap: true,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          fontsize: 17,
                                                          color: viewModel
                                                              .openOrderHistory![
                                                          index]
                                                              .tradeType
                                                              .toLowerCase() ==
                                                              stringVariables
                                                                  .buy
                                                                  .toLowerCase()
                                                              ? green
                                                              : red,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                        ),
                                                        CustomText(
                                                          text: getDateFromTimeStamp(viewModel
                                                              .openOrderHistory![
                                                          index]
                                                              .orderedDate
                                                              .toString()),
                                                          softwrap: true,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          fontsize: 14,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                      ],
                                                    ),
                                                    CustomSizedBox(
                                                      height:
                                                      size.height *
                                                          0.000015,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CustomText(
                                                              text: viewModel
                                                                  .openOrderHistory![
                                                              index]
                                                                  .pair
                                                                  .split(
                                                                  "/")
                                                                  .first,
                                                              softwrap:
                                                              true,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              fontsize:
                                                              18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                            ),
                                                            CustomSizedBox(
                                                              width:
                                                              0.004,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  top:
                                                                  2.0),
                                                              child:
                                                              CustomText(
                                                                text: "/",
                                                                fontsize:
                                                                13,
                                                              ),
                                                            ),
                                                            CustomSizedBox(
                                                              width:
                                                              0.002,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  top:
                                                                  2.0),
                                                              child:
                                                              CustomText(
                                                                text: viewModel
                                                                    .openOrderHistory![
                                                                index]
                                                                    .pair
                                                                    .split(
                                                                    "/")
                                                                    .last,
                                                                fontsize:
                                                                13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        CustomText(
                                                          text: viewModel
                                                              .openOrderHistory![
                                                          index]
                                                              .status
                                                              .toLowerCase() ==
                                                              stringVariables
                                                                  .filled
                                                                  .toLowerCase()
                                                              ? "  " +
                                                              stringVariables
                                                                  .completed
                                                              : capitalize(viewModel
                                                              .openOrderHistory![
                                                          index]
                                                              .status)
                                                              ,
                                                          softwrap: true,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          fontsize: 16,
                                                          color: viewModel
                                                              .openOrderHistory![
                                                          index]
                                                              .status
                                                              .toLowerCase() ==
                                                              stringVariables
                                                                  .active
                                                                  .toLowerCase()
                                                              ? green
                                                              : red,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                        ),
                                                      ],
                                                    ),
                                                    CustomSizedBox(
                                                      height:
                                                      size.height *
                                                          0.00001,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: [
                                                        Center(
                                                          child:
                                                          CustomContainer(
                                                            width: 7.5,
                                                            height: 16,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Stack(
                                                                  alignment:
                                                                  Alignment.center,
                                                                  children: [
                                                                    CircularProgressIndicator(
                                                                      value:
                                                                      (viewModel.openOrderHistory![index].initialAmount - viewModel.openOrderHistory![index].amount) / viewModel.openOrderHistory![index].initialAmount,
                                                                      backgroundColor:
                                                                      Colors.grey,
                                                                      valueColor:
                                                                      AlwaysStoppedAnimation(Colors.green),
                                                                      strokeWidth:
                                                                      3,
                                                                    ),
                                                                    CustomText(
                                                                      color:
                                                                      green,
                                                                      text:
                                                                      double.parse(trimDecimals((((viewModel.openOrderHistory![index].initialAmount - viewModel.openOrderHistory![index].amount) / viewModel.openOrderHistory![index].initialAmount) * 100).toString())).toInt().toString() + "%",
                                                                      softwrap:
                                                                      true,
                                                                      overflow:
                                                                      TextOverflow.ellipsis,
                                                                      fontsize:
                                                                      11,
                                                                      fontWeight:
                                                                      FontWeight.w400,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        CustomSizedBox(
                                                          width: 0.005,
                                                        ),
                                                        CustomContainer(
                                                          width: 1.4,
                                                          height: 10,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CustomText(
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      softwrap:
                                                                      true,
                                                                      text: stringVariables
                                                                          .amount,
                                                                      color:
                                                                      hintLight,
                                                                      fontfamily:
                                                                      "Comfortaa",
                                                                      fontWeight:
                                                                      FontWeight.w600,
                                                                      fontsize: 13),
                                                                  CustomSizedBox(
                                                                    width:
                                                                    0.045,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      CustomText(
                                                                        text: trimDecimals((viewModel.openOrderHistory![index].initialAmount - viewModel.openOrderHistory![index].amount).toString()),
                                                                        softwrap: true,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        fontsize: 18,
                                                                        fontWeight: FontWeight.w700,
                                                                      ),
                                                                      CustomSizedBox(
                                                                        width: 0.004,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 2.0),
                                                                        child: CustomText(
                                                                          text: "/",
                                                                          fontsize: 13,
                                                                        ),
                                                                      ),
                                                                      CustomSizedBox(
                                                                        width: 0.002,
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 2.0),
                                                                        child: CustomText(
                                                                          text: trimDecimals(viewModel.openOrderHistory![index].initialAmount.toString()),
                                                                          fontsize: 13,
                                                                        ),
                                                                      ),
                                                                      CustomText(
                                                                          overflow: TextOverflow.ellipsis,
                                                                          softwrap: true,
                                                                          text: " ${viewModel.openOrderHistory![index].pair.split('/')[0]}",
                                                                          color: hintLight,
                                                                          fontfamily: "Comfortaa",
                                                                          fontWeight: FontWeight.w500,
                                                                          fontsize: 12),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              CustomSizedBox(
                                                                height:
                                                                0.005,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.start,
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          CustomText(overflow: TextOverflow.ellipsis, softwrap: true, text: stringVariables.price, color: hintLight, fontfamily: 'Comfortaa', fontWeight: FontWeight.w600, fontsize: 13),
                                                                          CustomSizedBox(
                                                                            width: 0.095,
                                                                          ),
                                                                          CustomText(
                                                                            align: TextAlign.end,
                                                                            fontfamily: 'Comfortaa',
                                                                            softwrap: true,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            text: trimDecimals(viewModel.openOrderHistory![index].marketPrice.toString()),
                                                                            fontsize: 14.5,
                                                                            fontWeight: FontWeight.w700,
                                                                          ),
                                                                          CustomText(overflow: TextOverflow.ellipsis, softwrap: true, text: " ${viewModel.openOrderHistory![index].pair.split('/')[1]}", color: hintLight, fontfamily: 'Comfortaa', fontWeight: FontWeight.w500, fontsize: 12),
                                                                        ],
                                                                      ),
                                                                      CustomSizedBox(
                                                                        height: 0.005,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          CustomText(overflow: TextOverflow.ellipsis, softwrap: true, text: stringVariables.total, color: hintLight, fontfamily: 'Comfortaa', fontWeight: FontWeight.w600, fontsize: 13),
                                                                          CustomSizedBox(
                                                                            width: 0.1,
                                                                          ),
                                                                          CustomText(
                                                                            align: TextAlign.end,
                                                                            fontfamily: 'Comfortaa',
                                                                            softwrap: true,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            text: trimDecimals(viewModel.openOrderHistory![index].total.toString()),
                                                                            fontsize: 14.5,
                                                                            fontWeight: FontWeight.w700,
                                                                          ),
                                                                          CustomText(overflow: TextOverflow.ellipsis, softwrap: true, text: " ${viewModel.openOrderHistory![index].pair.split('/')[1]}", color: hintLight, fontfamily: 'Comfortaa', fontWeight: FontWeight.w500, fontsize: 12),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CustomElevatedButton(
                                                                    press:
                                                                        () {
                                                                      showCancelDialog(index);
                                                                      // viewModel.cancelOrder(viewModel.openOrderHistory![index].id,
                                                                      //     context);
                                                                    },
                                                                    multiClick:
                                                                    true,
                                                                    color:
                                                                    white,
                                                                    text:
                                                                    stringVariables.cancel,
                                                                    width:
                                                                    6,
                                                                    isBorderedButton:
                                                                    true,
                                                                    maxLines:
                                                                    1,
                                                                    icon:
                                                                    null,
                                                                    radius:
                                                                    15,
                                                                    height:
                                                                    MediaQuery.of(context).size.height / 25,
                                                                    icons:
                                                                    false,
                                                                    blurRadius:
                                                                    0,
                                                                    spreadRadius:
                                                                    0,
                                                                    offset: Offset(
                                                                        0,
                                                                        0),fontSize: 12,
                                                                    buttoncolor:
                                                                    red,
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            index !=
                                                (openLength -
                                                    1)
                                                ? Divider(
                                              height: 2,
                                              color: hintLight,
                                            )
                                                : CustomSizedBox(
                                              height: 0.005,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          // viewModel.openReadMoreFlag
                          //     ? Column(
                          //         children: [
                          //           CustomSizedBox(
                          //             height: 0.03,
                          //           ),
                          //           CustomText(
                          //             press: () {
                          //               var add = (openLength -
                          //                           viewModel
                          //                               .openCounter) >=
                          //                       3
                          //                   ? 3
                          //                   : (openLength -
                          //                       viewModel.openCounter);
                          //               viewModel.setOpenCounter(
                          //                   viewModel.openCounter + add);
                          //               if (viewModel.openCounter >=
                          //                   openLength) {
                          //                 viewModel
                          //                     .setOpenReadMoreFlag(false);
                          //               }
                          //             },
                          //             align: TextAlign.center,
                          //             text: stringVariables.readMore,
                          //             color: textGrey,
                          //             softwrap: true,
                          //             overflow: TextOverflow.ellipsis,
                          //             fontsize: 16,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //           CustomSizedBox(
                          //             height: 0.03,
                          //           ),
                          //         ],
                          //       )
                          //     : CustomSizedBox(
                          //         height: 0.03,
                          //       ),
                        ],
                      ),
                    ),
                  ),
                ),
                RefreshIndicator(
                  color: themeColor,
                  onRefresh: () {
                    return viewModel.getCancelledOrders(0);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: cancelOrderLength == 0
                        ? Padding(
                            padding: EdgeInsets.only(top: size.height / 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  align: TextAlign.center,
                                  text: stringVariables.noRecords,
                                  color: textGrey,
                                  softwrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: size.width / 50, right: size.width / 50),
                            child: Column(
                              children: [
                                CustomCard(
                                  radius: 25,
                                  edgeInsets: 0,
                                  outerPadding: 0,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount:cancelOrderLength <
                                              viewModel.cancelCounter
                                              ? cancelOrderLength
                                              : viewModel.cancelCounter,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                securedPrint("index${index}");
                                                moveToCancelDetails(
                                                    context,"cancelOrders",
                                                  viewModel.cancelOrders![index],
                                                    );
                                              },
                                              child: Column(
                                                children: [
                                                  CustomContainer(
                                                    width: 1,
                                                    height: 4.875,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: size.height / 50,
                                                          left: size.width / 25,
                                                          right:
                                                              size.width / 25),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              CustomText(
                                                                text: viewModel.cancelOrders![index].tradeType.toString(),
                                                                softwrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontsize: 17,
                                                                color: viewModel.cancelOrders![
                                                                                index]
                                                                            .tradeType.toString()
                                                                            .toLowerCase() ==
                                                                        stringVariables
                                                                            .buy
                                                                            .toLowerCase()
                                                                    ? green
                                                                    : red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                              CustomText(
                                                                text: getDateFromTimeStamp(viewModel.cancelOrders![
                                                                        index]
                                                                    .orderedDate
                                                                    .toString()),
                                                                softwrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontsize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ],
                                                          ),
                                                          CustomSizedBox(
                                                            height:
                                                                size.height *
                                                                    0.00001,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CustomText(
                                                                    text: viewModel.cancelOrders![
                                                                            index]
                                                                        .pair.toString()
                                                                        .split(
                                                                            "/")
                                                                        .first,
                                                                    softwrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontsize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                  CustomSizedBox(
                                                                    width:
                                                                        0.004,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            2.0),
                                                                    child:
                                                                        CustomText(
                                                                      text: "/",
                                                                      fontsize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                  CustomSizedBox(
                                                                    width:
                                                                        0.002,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            2.0),
                                                                    child:
                                                                        CustomText(
                                                                      text: viewModel.cancelOrders![
                                                                              index]
                                                                          .pair.toString()
                                                                          .split(
                                                                              "/")
                                                                          .last,
                                                                      fontsize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              CustomText(
                                                                text: capitalize(viewModel.cancelOrders![
                                                                            index]
                                                                        .status.toString()
                                                                        ),
                                                                softwrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontsize: 16,
                                                                color: red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ],
                                                          ),
                                                          CustomSizedBox(
                                                            height:
                                                                size.height *
                                                                    0.00001,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          softwrap:
                                                                              true,
                                                                          text: stringVariables
                                                                              .amount,
                                                                          color:
                                                                              hintLight,
                                                                          fontfamily:
                                                                              'Comfortaa',
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontsize:
                                                                              13),
                                                                      CustomSizedBox(
                                                                        width:
                                                                            0.05,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          CustomText(
                                                                            text:trimDecimals((viewModel.cancelOrders![index].partialAmount).toString()),
                                                                            softwrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontsize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                          CustomSizedBox(
                                                                            width:
                                                                                0.004,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2.0),
                                                                            child:
                                                                                CustomText(
                                                                              text: "/",
                                                                              fontsize: 13,
                                                                            ),
                                                                          ),
                                                                          CustomSizedBox(
                                                                            width:
                                                                                0.002,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 2.0),
                                                                            child:
                                                                                CustomText(
                                                                              text: trimDecimals((viewModel.cancelOrders![index].initial_amount).toString()),
                                                                              fontsize: 13,
                                                                            ),
                                                                          ),
                                                                          CustomText(
                                                                              overflow: TextOverflow.ellipsis,
                                                                              softwrap: true,
                                                                              text: " ${viewModel.cancelOrders![index].pair.toString().split('/')[0]}",
                                                                              color: hintLight,
                                                                              fontfamily: 'Comfortaa',
                                                                              fontWeight: FontWeight.w500,
                                                                              fontsize: 12),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  CustomSizedBox(
                                                                    height:
                                                                        0.005,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          softwrap:
                                                                              true,
                                                                          text: stringVariables
                                                                              .price,
                                                                          color:
                                                                              hintLight,
                                                                          fontfamily:
                                                                              'Comfortaa',
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontsize:
                                                                              13),
                                                                      CustomSizedBox(
                                                                        width:
                                                                            0.1,
                                                                      ),
                                                                      CustomText(
                                                                        align: TextAlign
                                                                            .end,
                                                                        fontfamily:
                                                                            'Comfortaa',
                                                                        softwrap:
                                                                            true,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        text: trimDecimals(viewModel.cancelOrders![index]
                                                                            .marketPrice
                                                                            .toString()),
                                                                        fontsize:
                                                                            14.5,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                      CustomText(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          softwrap:
                                                                              true,
                                                                          text:
                                                                              " ${viewModel.cancelOrders![index].pair.toString().split('/')[1]}",
                                                                          color:
                                                                              hintLight,
                                                                          fontfamily:
                                                                              'Comfortaa',
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontsize:
                                                                              12),
                                                                    ],
                                                                  ),
                                                                  CustomSizedBox(
                                                                    height:
                                                                        0.005,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomText(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          softwrap:
                                                                              true,
                                                                          text: stringVariables
                                                                              .total,
                                                                          color:
                                                                              hintLight,
                                                                          fontfamily:
                                                                              'Comfortaa',
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontsize:
                                                                              13),
                                                                      CustomSizedBox(
                                                                        width:
                                                                            0.105,
                                                                      ),
                                                                      CustomText(
                                                                        align: TextAlign
                                                                            .end,
                                                                        fontfamily:
                                                                            'Comfortaa',
                                                                        softwrap:
                                                                            true,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        text: trimDecimals(viewModel.cancelOrders![index]
                                                                            .total
                                                                            .toString()),
                                                                        fontsize:
                                                                            14.5,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                      CustomText(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          softwrap:
                                                                              true,
                                                                          text:
                                                                              " ${viewModel.cancelOrders![index].pair.toString().split('/')[1]}",
                                                                          color:
                                                                              hintLight,
                                                                          fontfamily:
                                                                              'Comfortaa',
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontsize:
                                                                              12),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              CustomSizedBox(
                                                                width: 0.05,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  index !=
                                                          (cancelOrderLength -
                                                              1)
                                                      ? Divider(
                                                          height: 2,
                                                          color: hintLight,
                                                        )
                                                      : CustomSizedBox(
                                                          height: 0.005,
                                                        ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                                viewModel.cancelReadMoreFlag
                                    ? Column(
                                  children: [
                                    CustomSizedBox(
                                      height: 0.03,
                                    ),
                                    CustomText(
                                      press: () async {
                                        var add = (cancelOrderLength -
                                            viewModel
                                                .cancelCounter) >=
                                            3
                                            ? 3
                                            : (cancelOrderLength -
                                            viewModel.cancelCounter);
                                        viewModel.setCancelCounter(
                                            viewModel.cancelCounter +
                                                add);
                                        if (viewModel.cancelCounter >=
                                            cancelOrderLength) {
                                          //viewModel.setHistoryReadMoreFlag(false);
                                          await viewModel
                                              .checkCancelHasMoreData();
                                        }
                                      },
                                      align: TextAlign.center,
                                      text: stringVariables.readMore,
                                      color: textGrey,
                                      softwrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      fontsize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomSizedBox(
                                      height: 0.03,
                                    ),
                                  ],
                                )
                                    : CustomSizedBox(
                                  height: 0.03,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                RefreshIndicator(
                  color: themeColor,
                  onRefresh: () {
                    return viewModel.getTradeHistory(0);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: historyLength == 0
                        ? Padding(
                      padding: EdgeInsets.only(top: size.height / 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            align: TextAlign.center,
                            text: stringVariables.noRecords,
                            color: textGrey,
                            softwrap: true,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(
                          left: size.width / 50, right: size.width / 50),
                      child: Column(
                        children: [
                          CustomCard(
                            radius: 25,
                            edgeInsets: 0,
                            outerPadding: 0,
                            child: Column(
                              children: [
                                ListView.builder(
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: historyLength <
                                        viewModel.historyCounter
                                        ? historyLength
                                        : viewModel.historyCounter,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          moveToTradeHistoryDetails(
                                            context,"tradeOrders",
                                            viewModel.tradeHistory!.data![index],
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            CustomContainer(
                                              width: 1,
                                              height: 4.875,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: size.height / 50,
                                                    left: size.width / 25,
                                                    right:
                                                    size.width / 25),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        CustomText(
                                                          text: viewModel
                                                              .tradeHistory!
                                                              .data![
                                                          index]
                                                              .tradeType.toString(),
                                                          softwrap: true,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          fontsize: 17,
                                                          color: viewModel
                                                              .tradeHistory!
                                                              .data![
                                                          index]
                                                              .tradeType.toString()
                                                              .toLowerCase() ==
                                                              stringVariables
                                                                  .buy
                                                                  .toLowerCase()
                                                              ? green
                                                              : red,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                        ),
                                                        CustomText(
                                                          text: getDateFromTimeStamp(viewModel
                                                              .tradeHistory!
                                                              .data![
                                                          index].createdDate.toString()),
                                                          softwrap: true,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          fontsize: 14,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                      ],
                                                    ),
                                                    CustomSizedBox(
                                                      height:
                                                      size.height *
                                                          0.00001,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CustomText(
                                                              text: viewModel
                                                                  .tradeHistory!
                                                                  .data![
                                                              index]
                                                                  .pair.toString()
                                                                  .split(
                                                                  "/")
                                                                  .first,
                                                              softwrap:
                                                              true,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                              fontsize:
                                                              18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                            ),
                                                            CustomSizedBox(
                                                              width:
                                                              0.004,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  top:
                                                                  2.0),
                                                              child:
                                                              CustomText(
                                                                text: "/",
                                                                fontsize:
                                                                13,
                                                              ),
                                                            ),
                                                            CustomSizedBox(
                                                              width:
                                                              0.002,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  top:
                                                                  2.0),
                                                              child:
                                                              CustomText(
                                                                text: viewModel
                                                                    .tradeHistory!
                                                                    .data![
                                                                index]
                                                                    .pair.toString()
                                                                    .split(
                                                                    "/")
                                                                    .last,
                                                                fontsize:
                                                                13,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        CustomText(
                                                          text:capitalize(stringVariables.completed),
                                                          softwrap: true,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          fontsize: 16,
                                                          color:green,
                                                          fontWeight:
                                                          FontWeight
                                                              .w700,
                                                        ),
                                                      ],
                                                    ),
                                                    CustomSizedBox(
                                                      height:
                                                      size.height *
                                                          0.00001,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                CustomText(
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    softwrap:
                                                                    true,
                                                                    text: stringVariables
                                                                        .amount,
                                                                    color:
                                                                    hintLight,
                                                                    fontfamily:
                                                                    'Comfortaa',
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    fontsize:
                                                                    13),
                                                                CustomSizedBox(
                                                                  width:
                                                                  0.05,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    CustomText(
                                                                      text:  trimDecimals((viewModel.tradeHistory!.data![index].filledAmount).toString()),
                                                                      softwrap:
                                                                      true,
                                                                      overflow:
                                                                      TextOverflow.ellipsis,
                                                                      fontsize:
                                                                      18,
                                                                      fontWeight:
                                                                      FontWeight.w700,
                                                                    ),
                                                                    // CustomSizedBox(
                                                                    //   width:
                                                                    //   0.004,
                                                                    // ),
                                                                    // Padding(
                                                                    //   padding:
                                                                    //   const EdgeInsets.only(top: 2.0),
                                                                    //   child:
                                                                    //   CustomText(
                                                                    //     text: "/",
                                                                    //     fontsize: 13,
                                                                    //   ),
                                                                    // ),
                                                                    // CustomSizedBox(
                                                                    //   width:
                                                                    //   0.002,
                                                                    // ),
                                                                    // Padding(
                                                                    //   padding:
                                                                    //   const EdgeInsets.only(top: 2.0),
                                                                    //   child:
                                                                    //   CustomText(
                                                                    //     text: trimDecimals((viewModel.tradeHistory!.data![index].amount).toString()),
                                                                    //     fontsize: 13,
                                                                    //   ),
                                                                    // ),
                                                                    CustomText(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        softwrap: true,
                                                                        text: " ${viewModel.tradeHistory!.data![index].pair.toString().split('/')[0]}",
                                                                        color: hintLight,
                                                                        fontfamily: 'Comfortaa',
                                                                        fontWeight: FontWeight.w500,
                                                                        fontsize: 12),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            CustomSizedBox(
                                                              height:
                                                              0.005,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                CustomText(
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    softwrap:
                                                                    true,
                                                                    text: stringVariables
                                                                        .price,
                                                                    color:
                                                                    hintLight,
                                                                    fontfamily:
                                                                    'Comfortaa',
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    fontsize:
                                                                    13),
                                                                CustomSizedBox(
                                                                  width:
                                                                  0.1,
                                                                ),
                                                                CustomText(
                                                                  align: TextAlign
                                                                      .end,
                                                                  fontfamily:
                                                                  'Comfortaa',
                                                                  softwrap:
                                                                  true,
                                                                  overflow:
                                                                  TextOverflow.ellipsis,
                                                                  text: trimDecimals(viewModel
                                                                      .tradeHistory!
                                                                      .data![index]
                                                                      .adminFeeAmount
                                                                      .toString()),
                                                                  fontsize:
                                                                  14.5,
                                                                  fontWeight:
                                                                  FontWeight.w700,
                                                                ),
                                                                CustomText(
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    softwrap:
                                                                    true,
                                                                    text:
                                                                    " ${viewModel.tradeHistory!.data![index].pair.toString().split('/')[1]}",
                                                                    color:
                                                                    hintLight,
                                                                    fontfamily:
                                                                    'Comfortaa',
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontsize:
                                                                    12),
                                                              ],
                                                            ),
                                                            CustomSizedBox(
                                                              height:
                                                              0.005,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                CustomText(
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    softwrap:
                                                                    true,
                                                                    text: stringVariables
                                                                        .total,
                                                                    color:
                                                                    hintLight,
                                                                    fontfamily:
                                                                    'Comfortaa',
                                                                    fontWeight: FontWeight
                                                                        .w600,
                                                                    fontsize:
                                                                    13),
                                                                CustomSizedBox(
                                                                  width:
                                                                  0.105,
                                                                ),
                                                                CustomText(
                                                                  align: TextAlign
                                                                      .end,
                                                                  fontfamily:
                                                                  'Comfortaa',
                                                                  softwrap:
                                                                  true,
                                                                  overflow:
                                                                  TextOverflow.ellipsis,
                                                                  text: trimDecimals(viewModel
                                                                      .tradeHistory!
                                                                      .data![index]
                                                                      .total
                                                                      .toString()),
                                                                  fontsize:
                                                                  14.5,
                                                                  fontWeight:
                                                                  FontWeight.w700,
                                                                ),
                                                                CustomText(
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    softwrap:
                                                                    true,
                                                                    text:
                                                                    " ${viewModel.tradeHistory!.data![index].pair.toString().split('/')[1]}",
                                                                    color:
                                                                    hintLight,
                                                                    fontfamily:
                                                                    'Comfortaa',
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontsize:
                                                                    12),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        CustomSizedBox(
                                                          width: 0.05,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            index !=
                                                (viewModel
                                                    .historyCounter -
                                                    1)
                                                ? Divider(
                                              height: 2,
                                              color: hintLight,
                                            )
                                                : CustomSizedBox(
                                              height: 0.005,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          viewModel.historyReadMoreFlag
                              ? Column(
                            children: [
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              CustomText(
                                press: () async {
                                  var add = (historyLength -
                                      viewModel
                                          .historyCounter) >=
                                      3
                                      ? 3
                                      : (historyLength -
                                      viewModel.historyCounter);
                                  viewModel.setHistoryCounter(
                                      viewModel.historyCounter +
                                          add);
                                  if (viewModel.historyCounter >=
                                      historyLength) {
                                    //viewModel.setHistoryReadMoreFlag(false);
                                    await viewModel
                                        .checkHistoryHasMoreData();
                                  }
                                },
                                align: TextAlign.center,
                                text: stringVariables.readMore,
                                color: textGrey,
                                softwrap: true,
                                overflow: TextOverflow.ellipsis,
                                fontsize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                            ],
                          )
                              : CustomSizedBox(
                            height: 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildOpenOrderAmount(String content1, String content2, String content3,
      [String? content4]) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: CustomContainer(
            width: 1,
            child: CustomText(
              fontfamily: 'GoogleSans',
              text: content1,
              fontsize: 14,
              color: textGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CustomSizedBox(
          width: 0.01,
        ),
        Flexible(
          flex: 2,
          child: CustomContainer(
            width: 1,
            child: content4 != null
                ? Row(
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: content2,
                        fontsize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: CustomText(
                          text: "/",
                          fontsize: 14,
                          fontfamily: 'GoogleSans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.005,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: CustomText(
                          text: content4,
                          fontsize: 14,
                          fontfamily: 'GoogleSans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.005,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: CustomText(
                          fontfamily: 'SourceSans',
                          text: content3,
                          fontsize: 13,
                          color: textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: content2,
                        fontsize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomSizedBox(
                        width: 0.005,
                      ),
                      CustomText(
                        fontfamily: 'SourceSans',
                        text: content3,
                        fontsize: 13,
                        color: textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  String getDateFromTimeStamp(String timeStamp) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").parse(timeStamp);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  showCancelDialog(int index) async {
    final result =
    await Navigator.of(context).push(CancelAlert(context, index));
  }


}
