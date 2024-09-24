import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomOutlineContainer.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';

class DeleteAccountConfirmView extends StatefulWidget {
  const DeleteAccountConfirmView({super.key});

  @override
  State<DeleteAccountConfirmView> createState() =>
      _DeleteAccountConfirmViewState();
}

class _DeleteAccountConfirmViewState extends State<DeleteAccountConfirmView> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      color: themeSupport().isSelectedDarkMode() ? black : white,
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
                  fontfamily: 'InterTight',
                  fontsize: 23,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  text: stringVariables.deleteAccount,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: buildConfirmView(),
    );
  }

  buildConfirmView() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: CustomCard(
      radius: 25,
      edgeInsets: 4,
      outerPadding: 8,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomSizedBox(
              height: 0.02,
            ),
            CustomOutlineContainer(
              width: 1.1,
              // height: size.height / 5.6,
              border: Border.all(
                color: themeColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
              backgroundColor:
                  themeSupport().isSelectedDarkMode() ? black : white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: stringVariables.notes + " :"),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    CustomText(text: stringVariables.deleteAccountNote1),
                    CustomText(text: stringVariables.deleteAccountNote2),
                    CustomText(text: stringVariables.deleteAccountNote3),
                  ],
                ),
              ),
            ),
            CustomSizedBox(
              height: 0.03,
            ),
            CustomElevatedButton(
                text: stringVariables.continues.toUpperCase(),
                multiClick: true,
                color: themeSupport().isSelectedDarkMode() ? black : white,
                press: () {
                  moveToDeletePasswordView(context);
                },
                radius: 25,
                buttoncolor: themeColor,
                width: 0.0,
                height: MediaQuery.of(context).size.height / 50,
                isBorderedButton: false,
                maxLines: 1,
                icons: false,
                icon: null),
            CustomSizedBox(
              height: 0.01,
            ),
          ],
        ),
      ),
    ));
  }
}
