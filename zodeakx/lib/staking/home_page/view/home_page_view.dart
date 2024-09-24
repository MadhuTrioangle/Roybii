import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../model/stacking_home_page_model.dart';
import '../viewModel/home_page_view_model.dart';

class StackingHomePageView extends StatefulWidget {
  const StackingHomePageView({Key? key}) : super(key: key);

  @override
  State<StackingHomePageView> createState() => _StackingHomePageViewState();
}

class _StackingHomePageViewState extends State<StackingHomePageView> {
  late StackingHomePageViewModel viewModel;
  late MarketViewModel marketViewModel;
  late WalletViewModel walletViewModel;
  TextEditingController searchController = TextEditingController();
  List<GetAllActiveStatus> _searchResult = [];
  String filteredText = "";

  @override
  void initState() {
    viewModel = Provider.of<StackingHomePageViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.getActiveStatus();
      searchController.clear();
      searchController.addListener(() {
        searchController.text.isEmpty
            ? viewModel.setsearchControllerText(false)
            : viewModel.setsearchControllerText(true);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<StackingHomePageViewModel>();
    return Provider<StackingHomePageViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return showStakes(
          context,
        );
      },
    );
  }

  Widget showStakes(BuildContext context) {
    return CustomScaffold(
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
                  text: stringVariables.staking,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Center(
        child:viewModel.needToLoad ? CustomLoader() : searchStakes(),
      ),
    );
  }

  Widget searchStakes() {
    return CustomCard(
      radius: 15,
      outerPadding: 15,
      edgeInsets: 8,
      elevation: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: searchField(),
          ),
          stakesListView()
        ],
      ),
    );
  }

  Widget searchField() {
    return CustomTextFormField(
      size: 30,
      isContentPadding: false,
      prefixIcon: GestureDetector(
          onTap: () {
            searchController.clear();
            onSearchTextChanged(
              searchController.text,
            );
            onSearchTextChanged('');
          },
          child: Icon(
            Icons.search,
            color: textGrey,
            size: 25,
          )),
      text: "search",
      hintfontsize: 16,
      controller: searchController,
      onChanged: onSearchTextChanged,
    );
  }

  onSearchTextChanged(
    String text,
  ) async {
    securedPrint(text);_searchResult.clear();
    if (!viewModel.searchControllerText) {
      return;
    }

    List<GetAllActiveStatus> searchResult;

    searchResult = viewModel.activityStatus ?? [];
    securedPrint("length${searchResult.length}");
    _searchResult = searchResult
        .where((element) => element.stakeCurrencyDetails!.code!
            .toLowerCase()
            .contains(text.toLowerCase()) || element.rewardCurrencyDetails!.code!
        .toLowerCase()
        .contains(text.toLowerCase()))
        .toList();
  }

  Widget stakesListView() {
    List<GetAllActiveStatus>? getActiveStakesList =
        viewModel.getActiveStakesClass?.result;
    return Flexible(
      fit: FlexFit.loose,
      child:searchController.text.isNotEmpty && _searchResult.isEmpty
          ? Padding(
        padding: EdgeInsets.only(top: 50),
        child: CustomText(
          text: "No Search Result Found",
          fontsize: 18,
        ),
      )
          : viewModel.searchControllerText
          ? ListView.builder(
          shrinkWrap: true,
          itemCount: _searchResult.length,
          itemBuilder: (context, index) {
            bool expanded = getActiveStakesList![index].isExpand;
            return Column(
              children: [
                (_searchResult[index].isFlexible == false &&
                    _searchResult[index].childs?.length == 0 &&
                    _searchResult[index].childs?.length != null)
                    ? CustomSizedBox(
                  height: 0,
                )
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      viewModel.setReleaseExpandFlag(index);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.transparent,
                              child: FadeInImage.assetNetwork(
                                image: getImage(
                                    marketViewModel,
                                    walletViewModel,
                                    '${_searchResult[index].stakeCurrencyDetails?.code}'),
                                placeholder: splash,
                              ),
                            ),
                            CustomSizedBox(
                              width: 0.03,
                            ),
                            CustomText(
                              text: '${_searchResult[index].stakeCurrencyDetails?.code}' +
                                  ' - ' +
                                  '${_searchResult[index].rewardCurrencyDetails?.code}',
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomText(
                              text: stringVariables.apr +
                                  '  ' +
                                  getApr(index, _searchResult),
                              color: green,
                              fontsize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            Icon(
                              expanded
                                  ? Icons.arrow_drop_up_sharp
                                  : Icons.arrow_drop_down_sharp,
                              color: hintLight,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                expanded
                    ? Row(
                  mainAxisAlignment: (_searchResult[index]
                      .isFlexible ==
                      true)
                      ? (_searchResult[index].childs?.length != 0)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start
                      : MainAxisAlignment.start,
                  children: [
                    _searchResult[index].childs?.length != 0
                        ? GestureDetector(
                      onTap: () {
                        moveToStackingCreationView(
                          context,
                          stringVariables.flexbile,  _searchResult[index],
                        );
                      },
                      child: durationCards(
                          stringVariables.locked,
                          stringVariables.fixed +
                              ' ' +
                              stringVariables.term,
                          '${_searchResult[index].childs?.last.apr}'),
                    )
                        : CustomSizedBox(
                      height: 0,
                      width: 0,
                    ),
                    _searchResult[index].isFlexible == true
                        ? GestureDetector(
                      onTap: () {
                        moveToStackingCreationView(
                          context,
                          stringVariables.locked,_searchResult[index]
                        );
                      },
                      child: durationCards(
                          stringVariables.flexbile,
                          stringVariables.flexbile +
                              ' ' +
                              stringVariables.term,
                          '${_searchResult[index].flexibleInterest}'),
                    )
                        : CustomSizedBox(
                      height: 0,
                      width: 0,
                    )
                  ],
                )
                    : CustomSizedBox()
              ],
            );
          })
          :ListView.builder(
          shrinkWrap: true,
          itemCount: getActiveStakesList?.length,
          itemBuilder: (context, index) {
            bool expanded = getActiveStakesList![index].isExpand;
            return Column(
              children: [
                (getActiveStakesList[index].isFlexible == false &&
                        getActiveStakesList[index].childs?.length == 0 &&
                        getActiveStakesList[index].childs?.length != null)
                    ? CustomSizedBox(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            viewModel.setReleaseExpandFlag(index);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomCircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.transparent,
                                    child: FadeInImage.assetNetwork(
                                      image: getImage(
                                          marketViewModel,
                                          walletViewModel,
                                          '${getActiveStakesList[index].stakeCurrencyDetails?.code}'),
                                      placeholder: splash,
                                    ),
                                  ),
                                  CustomSizedBox(
                                    width: 0.03,
                                  ),
                                  CustomText(
                                    text: '${getActiveStakesList[index].stakeCurrencyDetails?.code}' +
                                        ' - ' +
                                        '${getActiveStakesList[index].rewardCurrencyDetails?.code}',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomText(
                                    text: stringVariables.apr +
                                        '  ' +
                                        getApr(index, getActiveStakesList),
                                    color: green,
                                    fontsize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomSizedBox(
                                    width: 0.02,
                                  ),
                                  Icon(
                                    expanded
                                        ? Icons.arrow_drop_up_sharp
                                        : Icons.arrow_drop_down_sharp,
                                    color: hintLight,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                expanded
                    ? Row(
                        mainAxisAlignment: (getActiveStakesList[index]
                                    .isFlexible ==
                                true)
                            ? (getActiveStakesList[index].childs?.length != 0)
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start
                            : MainAxisAlignment.start,
                        children: [
                          getActiveStakesList[index].childs?.length != 0
                              ? GestureDetector(
                                  onTap: () {
                                    moveToStackingCreationView(
                                      context,
                                      stringVariables.flexbile,getActiveStakesList[index]
                                    );
                                  },
                                  child: durationCards(
                                      stringVariables.locked,
                                      stringVariables.fixed +
                                          ' ' +
                                          stringVariables.term,
                                      '${getActiveStakesList[index].childs?.last.apr}'),
                                )
                              : CustomSizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          getActiveStakesList[index].isFlexible == true
                              ? GestureDetector(
                                  onTap: () {
                                    moveToStackingCreationView(
                                      context,
                                      stringVariables.locked,
                                        getActiveStakesList[index]
                                    );
                                  },
                                  child: durationCards(
                                      stringVariables.flexbile,
                                      stringVariables.flexbile +
                                          ' ' +
                                          stringVariables.term,
                                      '${getActiveStakesList[index].flexibleInterest}'),
                                )
                              : CustomSizedBox(
                                  height: 0,
                                  width: 0,
                                )
                        ],
                      )
                    : CustomSizedBox()
              ],
            );
          }),
    );
  }

  Widget durationCards(String title, String term, String apr) {
    return CustomCard(
      radius: 15,
      outerPadding: 8,
      edgeInsets: 0,
      color: themeSupport().isSelectedDarkMode() ? black : grey,
      elevation: 0,
      child: CustomContainer(
        width: 2.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomContainer(
                    width: 5.5,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: themeSupport().isSelectedDarkMode()
                          ? textLight
                          : purpleLight,
                    ),
                    child: Center(
                        child: CustomText(
                            text: stringVariables.protected,
                            align: TextAlign.end,
                            color: purple,
                            fontsize: 11))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    align: TextAlign.end,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    text: stringVariables.apr + '  ' + apr + "%",
                    color: green,
                    fontsize: 13,
                    fontWeight: FontWeight.w300,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    text: term,
                    align: TextAlign.end,
                    fontsize: 12,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getApr(int index, List<GetAllActiveStatus>? getActiveStakesList) {
    String? aprLowValue = '';
    String? aprHighValue = '';
    if (getActiveStakesList?[index].isFlexible == true) {
      aprLowValue = '${getActiveStakesList?[index].flexibleInterest}';
      if (getActiveStakesList?[index].childs?.length != 0) {
        aprHighValue = '${getActiveStakesList?[index].childs?.last.apr}';
      } else {
        aprLowValue = '${getActiveStakesList?[index].flexibleInterest}';
        aprHighValue = '0';
      }
    } else if (getActiveStakesList?[index].isFlexible == false &&
        (getActiveStakesList?[index].childs?.length == 0)) {
      aprLowValue = '${getActiveStakesList?[index].flexibleInterest}';
      aprHighValue = '0';
    } else if (getActiveStakesList?[index].isFlexible == false &&
        (getActiveStakesList?[index].childs?.length != 0)) {
      aprLowValue = '${getActiveStakesList?[index].flexibleInterest}';
      aprHighValue = '${getActiveStakesList?[index].childs?.last.apr}';
    }
    if (aprHighValue == "0" || aprHighValue == "null") {
      return aprLowValue + "%";
    } else {
      return aprLowValue + "% ~ " + aprHighValue + "%";
    }
  }
}
