import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../Common/ViewModel/common_view_model.dart';

class AccountDeletedView extends StatefulWidget {
  const AccountDeletedView({super.key});

  @override
  State<AccountDeletedView> createState() => _AccountDeletedViewState();
}

class _AccountDeletedViewState extends State<AccountDeletedView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
        child: buildAccountDeleteView(),
      ),
    );
  }

  buildAccountDeleteView() {
    return CustomCard(
      edgeInsets: 4,
      outerPadding: 8,
      radius: 25,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            deleteAccount,
            height: 100,
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: stringVariables.accountDeleted),
            ],
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomElevatedButton(
              text: stringVariables.okay,
              multiClick: true,
              color: themeSupport().isSelectedDarkMode() ? black : white,
              press: () async {
                constant.userLoginStatus.value = false;
                constant.pref?.setBool('loginStatus', false);
                constant.pref
                    ?.setString("userEmail", stringVariables.dummyEmail);
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 7);
                Provider.of<CommonViewModel>(context, listen: false)
                    .setActive(0);
                moveToRegister(context, false);
              },
              radius: 25,
              buttoncolor: themeColor,
              width: 0.0,
              height: MediaQuery.of(context).size.height / 50,
              isBorderedButton: false,
              maxLines: 1,
              icons: false,
              icon: null),
          // CustomElevatedButton(
          //   press: () async {
          //     constant.userLoginStatus.value = false;
          //     constant.pref?.setBool('loginStatus', false);
          //     constant.pref?.setString(
          //         "userEmail", stringVariables.dummyEmail);
          //     int count = 0;
          //     Navigator.of(context).popUntil((_) => count++ >= 7);
          //     Provider.of<CommonViewModel>(context, listen: false)
          //         .setActive(0);
          //     moveToLoginRegister(
          //         context, ScreenType.loginpasswordchange, true);
          //   },
          //   text: stringVariables.okay,
          //   width: MediaQuery.of(context).size.width / 2.5,
          //   height: 60,
          //   isBorderedButton: false,
          //   fontSize: 16,
          //   fontWeight: FontWeight.w500,
          // ),
        ],
      ),
    );
  }
}
