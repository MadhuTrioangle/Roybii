import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import 'package:zodeakx_mobile/ZodeakX/CurrencyPreferenceScreen/ViewModel/CurrencyPreferenceViewModel.dart';
import 'package:zodeakx_mobile/p2p/home/view_model/p2p_home_view_model.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';

class CurrencyPreferenceView extends StatefulWidget {
  const CurrencyPreferenceView({Key? key}) : super(key: key);

  @override
  State<CurrencyPreferenceView> createState() => _CurrencyPreferenceViewState();
}

class _CurrencyPreferenceViewState extends State<CurrencyPreferenceView> {
  int id = 0;
  int currencyList = 15;
  late CurrencyPreferenceViewModel viewModel;

  @override
  void initState() {
    viewModel =
        Provider.of<CurrencyPreferenceViewModel>(context, listen: false);
    viewModel.getFiatCurrency();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (constant.previousScreen.value == ScreenType.Market) {
      resumeSocket();
      constant.previousScreen.value = ScreenType.Login;
    }
    super.dispose();
  }

  resumeSocket() {
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.initSocket = true;
    marketViewModel.getTradePairs();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<CurrencyPreferenceViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (viewModel.noInternet)
          ? customSnackBar.showSnakbar(context,
          'Check your internet connection !', SnackbarType.negative)
          : '';
    });

    return Provider<CurrencyPreferenceViewModel>(
      create: (context) => CurrencyPreferenceViewModel(),
      builder: (context, child) {
        return showCurrency(
          context,
        );
      },
    );
  }

  Future<bool> pop() async {
    return true;
  }

  /// FiatCurrency
  Widget showCurrency(BuildContext context,) {
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
                      text: stringVariables.currencyPreference,
                      color:
                      themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                header(context),
                fiatCurrencies(
                  context,
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 35,
                ),
              ],
            ),
          ),
        ));
  }

  ///currency Header
  Widget header(BuildContext context) {
    return CustomText(
      fontfamily: 'GoogleSans',
      text: stringVariables.currencyPreferenceHeader,
      color: textHeaderGrey,
      fontsize: 12,
    );
  }

  ///fiatCurrency Lists
  Widget fiatCurrencies(BuildContext context,) {
    return Expanded(
      child: CustomCard(
          radius: 25,
          edgeInsets: 6,
          outerPadding: 18,
          elevation: 0,
          child: Column(
            children: [
              Expanded(
                child: (viewModel.needToLoad)
                    ? CustomLoader()
                    : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount:
                  viewModel.viewModelCurrencyPairs?.length ?? 0,
                  separatorBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Divider(
                        thickness: 0.1,
                        color: divider,
                      ),
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        viewModel.setActive(index);
                        viewModel.setCurrency(
                            '${viewModel.viewModelCurrencyPairs?[index]
                                .currencyCode}');
                      },
                      child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: CustomText(
                                  fontfamily: 'GoogleSans',
                                  text:
                                  '${viewModel.viewModelCurrencyPairs?[index]
                                      .currencyCode ?? "USD"} - ${viewModel
                                      .viewModelCurrencyPairs?[index]
                                      .currencyName ?? "USD Dollar"}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Radio(
                                value: index,
                                activeColor: themeColor,
                                groupValue: viewModel.id,
                                onChanged: (value) {
                                  viewModel.setActive(index);
                                  viewModel.setCurrency(
                                      '${viewModel
                                          .viewModelCurrencyPairs?[index]
                                          .currencyCode}');
                                },
                              ),
                            ],
                          )),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
