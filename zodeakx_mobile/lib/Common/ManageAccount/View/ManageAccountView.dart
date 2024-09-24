import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCheckedBox.dart';

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
import '../../DeletePassword/ViewModel/DeletePasswordViewModel.dart';

class ManageAccountView extends StatefulWidget {
  const ManageAccountView({
    Key? key,
  }) : super(key: key);

  @override
  State<ManageAccountView> createState() => _ManageAccountViewState();
}

class _ManageAccountViewState extends State<ManageAccountView> {
  late DeletePasswordViewModel? deletePasswordViewModel;
  @override
  void initState() {
    deletePasswordViewModel =
        Provider.of<DeletePasswordViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    deletePasswordViewModel = context.watch<DeletePasswordViewModel>();
    return buildManageAccountView(context, size);
  }

  Widget buildManageAccountView(BuildContext context, Size size) {
    return Provider(
      create: (context) => deletePasswordViewModel,
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
                  text: stringVariables.manageAccount,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            ),
          ),
        ),
        child: buildDeleteAccount(size),
      ),
    );
  }

  Widget buildDeleteAccount(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width / 30,
        vertical: size.height / 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(deleteAccountImage),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            text: stringVariables.deleteAccount,
            fontsize: 23,
            fontWeight: FontWeight.bold,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            text: stringVariables.instructDeleteAccount,
            softwrap: true,
            fontsize: 14,
            strutStyleHeight: 1.5,
            align: TextAlign.center,
            color: stackCardText,
            fontWeight: FontWeight.w400,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomContainer(
            width: 1.15,
            child: CustomCard(
              outerPadding: 0,
              edgeInsets: 0,
              radius: 15,
              elevation: 0,
              color: themeSupport().isSelectedDarkMode()
                  ? darkCardColor
                  : inputColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: CustomCheckBox(
                      checkboxState:
                          deletePasswordViewModel?.checkBoxStatus ?? false,
                      toggleCheckboxState: (val) {
                        deletePasswordViewModel?.setCheckBoxStatus();
                      },
                      activeColor: themeColor,
                      checkColor: Colors.white,
                      borderColor: enableBorder,
                    ),
                  ),
                  CustomSizedBox(
                    width: 0.01,
                  ),
                  CustomContainer(
                      width: 1.6,
                      height: 11,
                      child: Center(
                        child: CustomText(
                          text: stringVariables.checkBoxDeleteaccountContent,
                          strutStyleHeight: 1.25,
                        ),
                      ))
                ],
              ),
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomContainer(
            width: 1.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomElevatedButton(
                    text: stringVariables.cancel,
                    multiClick: true,
                    color: themeColor,
                    press: () {
                      Navigator.pop(context);
                    },
                    radius: 16,
                    buttoncolor: themeColor,
                    width: 2.4,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: true,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    icons: false,
                    icon: null),
                CustomElevatedButton(
                    text: stringVariables.continues,
                    multiClick: true,
                    color: (deletePasswordViewModel?.checkBoxStatus ?? false)
                        ? white
                        : stackCardText,
                    press: () {
                      if ((deletePasswordViewModel?.checkBoxStatus ?? false)) {
                        moveToDeletePasswordView(context);
                      }
                    },
                    radius: 16,
                    buttoncolor:
                        (deletePasswordViewModel?.checkBoxStatus ?? false)
                            ? themeColor
                            : themeSupport().isSelectedDarkMode()
                                ? disableButtonDark
                                : disableButtonLight,
                    fillColor:
                        (deletePasswordViewModel?.checkBoxStatus ?? false)
                            ? themeColor
                            : themeSupport().isSelectedDarkMode()
                                ? disableButtonDark
                                : disableButtonLight,
                    width: 2.4,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: false,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    icons: false,
                    icon: null),
              ],
            ),
          )
        ],
      ),
    );
  }
}
