import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';

class MustLoginView extends StatelessWidget {
  const MustLoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<MarketViewModel>();
    return Provider(
        create: (context) => viewModel,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    checkBrightness.value == Brightness.dark
                        ? lightlogo
                        : darklogo,
                    height: themeSupport().isSelectedDarkMode() ? 40 : 40),
                CustomSizedBox(
                  height: 0.04,
                ),
                CustomText(
                  text: stringVariables.marketScreenSubheading,
                  fontsize: 13,
                  fontWeight: FontWeight.w400,
                ),
                CustomSizedBox(
                  height: 0.04,
                ),
                CustomElevatedButton(
                    text: stringVariables.logIn,
                    press: () {
                      moveToRegister(context, false);
                    },
                    color: black,
                    radius: 25,
                    multiClick: true,
                    buttoncolor: themeColor,
                    width: 1.5,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: false,
                    maxLines: 1,
                    icons: false,
                    icon: null),
              ],
            ),
          );
        });
  }
}
