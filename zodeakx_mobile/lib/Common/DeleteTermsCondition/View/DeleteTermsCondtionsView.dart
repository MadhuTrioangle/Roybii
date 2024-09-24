import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';

class DeleteTermsConditionView extends StatefulWidget {
  const DeleteTermsConditionView({super.key});

  @override
  State<DeleteTermsConditionView> createState() =>
      _DeleteTermsConditionViewState();
}

class _DeleteTermsConditionViewState extends State<DeleteTermsConditionView> {
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
                  text: stringVariables.termsConditions,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: buildConditionView(),
    );
  }

  buildConditionView() {
    return SingleChildScrollView(
        child: CustomCard(
      radius: 25,
      edgeInsets: 4,
      outerPadding: 8,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: stringVariables.termsConditionsNotes,
              fontsize: 13.5,
              strutStyleHeight: 1.8,
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomElevatedButton(
                text: stringVariables.acceptContinue,
                multiClick: true,
                color: themeSupport().isSelectedDarkMode() ? black : white,
                press: () {
                  moveToDeleteAccountConfirmView(context);
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
            // CustomElevatedButton(
            //   press: () async {
            //    // moveToDeleteAccountConfirmView(context);
            //   },
            //   text: stringVariables.acceptContinue,
            //   width: MediaQuery.of(context).size.width / 1,
            //   height: 60,
            //   isBorderedButton: false,
            //   fontSize: 16,
            //   fontWeight: FontWeight.w500,
            // ),
          ],
        ),
      ),
    ));
  }
}
