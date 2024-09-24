import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
                text: stringVariables.profile,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ],
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [buildUpperCard(), middleCard()],
          ),
        ),
      ),
    );
  }

  middleCard() {
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                buildRowText(
                    profileAvatar, stringVariables.account, onAccountPress),
                buildRowText(setting, stringVariables.setting, onSettingPress),
                buildRowText(bank, stringVariables.bankDetails, onBankPress),
                buildRowText(referralImage, stringVariables.referEarn,
                    onReferPress, true),
              ],
            ),
          ),
        ),
        CustomSizedBox(height: 0.01),
        CustomCard(
          outerPadding: 0,
          edgeInsets: 0,
          radius: 15,
          elevation: 0,
          color:
              themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                buildRowText(
                    helpCenter, stringVariables.helpCenter, onHelpCenterPress),
                buildRowText(aboutUs, stringVariables.aboutUs, onAboutUsPress),
                buildRowText(legal, stringVariables.legal, onLegalPress, true),
              ],
            ),
          ),
        ),
        CustomSizedBox(height: 0.01),
        CustomCard(
          outerPadding: 0,
          edgeInsets: 0,
          radius: 15,
          elevation: 0,
          color:
              themeSupport().isSelectedDarkMode() ? darkCardColor : inputColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      onLogoutPress;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: stringVariables.logout,
                              fontsize: 14,
                              fontWeight: FontWeight.w500,
                            )
                          ],
                        ),
                        SvgPicture.asset(
                          logout,
                          height: 25,
                          color: hintTextColor,
                          width: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  onAccountPress() {
    moveToAccountView(context);
  }

  onSettingPress() {
    moveToSecurity(context);
  }

  onBankPress() {}
  onReferPress() {}
  onHelpCenterPress() {}
  onAboutUsPress() {}
  onLegalPress() {}
  onLogoutPress() {}

  buildRowText(String image, String title, Function() pressFunc,
      [bool? isLast = false]) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: pressFunc,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      image,
                      height: 25,
                      width: 25,
                      color: hintTextColor,
                    ),
                    CustomSizedBox(
                      width: 0.04,
                    ),
                    CustomText(
                      text: title,
                      fontsize: 14,
                      fontWeight: FontWeight.w500,
                    )
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

  buildUpperCard() {
    String name = "Joshua Satoshi";
    String uidNumber = "R12658DF";
    String status = "Unverified";
    return Center(
      child: CustomContainer(
        width: 1.09,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border(
              left: BorderSide(
                  width: 1.5,
                  color: themeSupport().isSelectedDarkMode()
                      ? darkCardColor
                      : minusLightColor),
              bottom: BorderSide(
                  width: 1.5,
                  color: themeSupport().isSelectedDarkMode()
                      ? darkCardColor
                      : minusLightColor),
              right: BorderSide(
                  width: 1.5,
                  color: themeSupport().isSelectedDarkMode()
                      ? darkCardColor
                      : minusLightColor),
              top: BorderSide(
                  width: 1.5,
                  color: themeSupport().isSelectedDarkMode()
                      ? darkCardColor
                      : minusLightColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(themeSupport().isSelectedDarkMode()
                      ? userDarkAvatar
                      : userLightAvatar),
                  CustomSizedBox(
                    width: 0.03,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        fontWeight: FontWeight.w800,
                        fontsize: 15,
                      ),
                      CustomSizedBox(
                        height: 0.009,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "${stringVariables.uid}: ",
                            fontsize: 11.5,
                            color: stackCardText,
                          ),
                          CustomText(
                            text: uidNumber,
                            fontWeight: FontWeight.w500,
                            fontsize: 12,
                          ),
                          Icon(
                            Icons.copy_all_rounded,
                            color: themeColor,
                            size: 15,
                          )
                        ],
                      ),
                      CustomSizedBox(
                        height: 0.009,
                      ),
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
                            text: status,
                            align: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            fontsize: 10,
                            color: status == "Verified" ? green : red,
                          ))),
                    ],
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: contentFontColor,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
