import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';

class PersonalDetailsView extends StatefulWidget {
  const PersonalDetailsView({super.key});

  @override
  State<PersonalDetailsView> createState() => _PersonalDetailsViewState();
}

class _PersonalDetailsViewState extends State<PersonalDetailsView> {
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
                text: stringVariables.personalDetails,
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
            children: [
              buildUpperCard(),
              buildLowerCard(),
            ],
          ),
        ),
      ),
    );
  }

  buildLowerCard() {
    String uidNumber = "R12658DF";
    String emailId = "abc@gmail.com";
    String name = "Joshua Satoshi";
    String address =
        "No. 123 Roybits Street Off Canada and Nigeria Highways, Port Harcourt, Nigeria";
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
                buildRowText(stringVariables.uid, uidNumber),
                buildRowText(stringVariables.email, emailId),
                buildRowText(stringVariables.fullName, name),
                buildRowText(stringVariables.address, address, true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildRowText(String title, String content, [bool? isLast = false]) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: title,
                    fontsize: 12.5,
                    color: stackCardText,
                    fontWeight: FontWeight.w500,
                  ),
                  if (title == stringVariables.uid) SvgPicture.asset(copy)
                ],
              ),
              CustomSizedBox(
                height: 0.005,
              ),
              CustomText(
                text: content,
                fontsize: 14,
                fontWeight: FontWeight.w500,
              ),
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

  buildUpperCard() {
    String name = "Joshua Satoshi";

    String status = "Unverified";
    return Center(
      child: CustomContainer(
        width: 1.09,
        height: 4.5,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    themeSupport().isSelectedDarkMode()
                        ? userDarkAvatar
                        : userLightAvatar,
                    height: 95,
                    width: 95,
                  ),
                  Positioned(
                    bottom: 1,
                    right: -5,
                    child: SvgPicture.asset(
                      themeSupport().isSelectedDarkMode() ? edit : edit,
                      height: 35,
                      width: 35,
                    ),
                  ),
                ],
              ),
              CustomSizedBox(
                width: 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: name,
                    fontWeight: FontWeight.w800,
                    fontsize: 16.5,
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
        ),
      ),
    );
  }
}
