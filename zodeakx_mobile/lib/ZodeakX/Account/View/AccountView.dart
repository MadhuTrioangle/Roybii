import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
                text: stringVariables.account,
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
    );
  }

  buildUpperCard() {
    String status = "Verified";
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
                buildRowText(
                    stringVariables.personalDetails, onPersonalDetailsPress),
                buildRowText(stringVariables.preference, onPreferencePress),
                buildRowText(stringVariables.verification, onVerificationPress,
                    status, true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildRowText(String title, Function() pressFunc,
      [String? status = "Unverified", bool? isLast = false]) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: pressFunc,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: title,
                      fontsize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    if (isLast == true)
                      CustomContainer(
                          height: 40,
                          width: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: status == "Verified"
                                ? green.withOpacity(0.2)
                                : red.withOpacity(0.2),
                          ),
                          child: Center(
                              child: CustomText(
                            text: status ?? "",
                            align: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            fontsize: 10,
                            color: status == "Verified" ? green : red,
                          ))),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: contentFontColor,
                  size: 13,
                ),
              ],
            ),
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

  onPersonalDetailsPress() {
    moveToPersonalDetailsView(context);
  }

  onPreferencePress() {
    moveToPreferenceView(context);
  }

  onVerificationPress() {}
}
