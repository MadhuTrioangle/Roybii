import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';

class ManageAccountView extends StatefulWidget {
  const ManageAccountView({
    Key? key,
  }) : super(key: key);

  @override
  State<ManageAccountView> createState() => _ManageAccountViewState();
}

class _ManageAccountViewState extends State<ManageAccountView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return buildManageAccountView(context, size);
  }

  Widget buildManageAccountView(BuildContext context, Size size) {
    return WillPopScope(
      onWillPop: () async => true,
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
                    fontfamily: 'GoogleSans',
                    fontsize: 23,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.manageAccount,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: CustomContainer(
          width: 1,
          height: 4.5,
          child: buildDetailsCard(size),
        ),
      ),
    );
  }

  Widget buildDetailsCard(Size size) {
    return CustomCard(
      radius: 25,
      edgeInsets: 0,
      outerPadding: 8,
      elevation: 0,
      child: Column(
        children: [buildDeleteAccount()],
      ),
    );
  }

  Widget buildDeleteAccount() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 22, bottom: 0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          moveToDeleteAccount(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomContainer(
                  width: 1.25,
                  height: 7.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: stringVariables.deleteAccount,
                        fontWeight: FontWeight.bold,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      CustomText(
                        text: stringVariables.instructDeleteAccount,
                        strutStyleHeight: 1.3,
                        color: themeSupport().isSelectedDarkMode()
                            ? white70
                            : hintLight,
                        fontsize: 12,
                      ),
                      CustomSizedBox(
                        height: 0.015,
                      ),
                    ],
                  ),
                ),
                Icon(
                  size: 15,
                  Icons.arrow_forward_ios,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            ),
            const Divider(
              height: 5,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
