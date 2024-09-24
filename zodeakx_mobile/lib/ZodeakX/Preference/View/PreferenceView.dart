import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/ZodeakX/CurrencyPreferenceScreen/ViewModel/CurrencyPreferenceViewModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomSwitch.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';

class PreferenceView extends StatefulWidget {
  const PreferenceView({super.key});

  @override
  State<PreferenceView> createState() => _PreferenceViewState();
}

class _PreferenceViewState extends State<PreferenceView> {
  late MarketViewModel marketViewModel;
  late CurrencyPreferenceViewModel currencyPreferenceViewModel;

  @override
  void initState() {
    // TODO: implement initState
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    currencyPreferenceViewModel =
        Provider.of<CurrencyPreferenceViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    marketViewModel = context.watch<MarketViewModel>();
    currencyPreferenceViewModel = context.watch<CurrencyPreferenceViewModel>();
    return Provider(
      create: (context) => marketViewModel,
      child: CustomScaffold(
        color: themeSupport().isSelectedDarkMode()
            ? darkScaffoldColor
            : lightScaffoldColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: CustomContainer(
            width: 1,
            height: 1,
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: CustomContainer(
                      padding: 7.5,
                      width: 12,
                      height: 30,
                      child: SvgPicture.asset(
                        backArrow,
                      ),
                    ),
                  ),
                ),
                CustomText(
                  fontfamily: 'InterTight',
                  fontsize: 23,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  text: stringVariables.preference,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildUpperCard(),
            ],
          ),
        ),
      ),
    );
  }

  buildUpperCard() {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        CustomCard(
          outerPadding: 0,
          edgeInsets: 0,
          radius: 15,
          elevation: 0,
          color:
              themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                buildRowText(stringVariables.darkMode, switchButton()),
                buildRowText(stringVariables.currency, currencyButton(), true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  switchButton() {
    return CustomSwitch(
        activeColor: themeColor,
        inactiveColor: switchBackground,
        toggleColor: white,
        value: marketViewModel.active,
        onToggle: (value) {
          marketViewModel.active = value;
          marketViewModel.toggleStatus(value, context);
        });
  }

  currencyButton() {
    return GestureDetector(
      onTap: () {
        moveToCurrency(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          CustomText(
            text: "${constant.userCurrency.value}   ",
            color: contentFontColor,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: contentFontColor,
            size: 13,
          ),
        ],
      ),
    );
  }

  buildRowText(String title, Widget custom, [bool? isLast = false]) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    fontsize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              custom
            ],
          ),
        ),
        if (isLast == false)
          Divider(
            color: themeSupport().isSelectedDarkMode()
                ? marketCardColor
                : lightSearchBarColor,
          )
      ],
    );
  }
}
