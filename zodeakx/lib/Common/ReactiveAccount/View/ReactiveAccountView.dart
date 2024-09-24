import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/ReactiveAccount/ViewModel/ReactivateAccountViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCheckedBox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Widgets/CustomContainer.dart';

class ReactivateAccount extends StatefulWidget {
  ReactivateAccount({Key? key}) : super(key: key);

  @override
  State<ReactivateAccount> createState() => _ReactivateAccountState();
}

class _ReactivateAccountState extends State<ReactivateAccount> {
  bool _value = false;
  bool select = false;
  late ReactivateAccountViewModel reactivateViewModel;

  @override
  Widget build(BuildContext context) {
    reactivateViewModel = context.watch<ReactivateAccountViewModel>();

    return CustomScaffold(
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
                    reactivateViewModel.setActive(false);
                    reactivateViewModel.setSelect(false);
                    Navigator.pop(context);
                    reactivateViewModel.setLoading(false);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SvgPicture.asset(
                      backArrow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SvgPicture.asset(
                envelope,
              ),
            ),
            CustomSizedBox(
              height: 0.04,
            ),
            CustomText(
              text: stringVariables.reactivateAccount,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              fontsize: 22,
            ),
            CustomSizedBox(
              height: 0.03,
            ),
            buildCardView()
          ],
        ),
      ),
    );
  }

  /// Build Card View
  Widget buildCardView() {
    return Center(
      child: CustomCard(
        radius: 25,
        edgeInsets: 2,
        outerPadding: 8,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizedBox(
              height: 0.02,
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckBox(
                    checkboxState: reactivateViewModel.select,
                    toggleCheckboxState: (val) {
                      reactivateViewModel.checkBoxValue = val ?? false;
                      reactivateViewModel.setSelect(val!);
                    },
                    activeColor: themeColor,
                    checkColor: Colors.white,
                    borderColor: hintLight,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CustomText(
                        text: stringVariables.reactivateInstruction,
                        strutStyleHeight: 1.3,
                        fontsize: 12,
                        press: () {
                          reactivateViewModel.changeCheckBox();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckBox(
                    checkboxState: reactivateViewModel.active,
                    toggleCheckboxState: (val) {
                      reactivateViewModel.checkBoxStatus = val ?? false;
                      reactivateViewModel.setActive(val!);
                    },
                    activeColor: themeColor,
                    checkColor: Colors.white,
                    borderColor: hintLight,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CustomText(
                        text: stringVariables.reactivatedInstruction,
                        strutStyleHeight: 1.3,
                        fontsize: 12,
                        press: () {
                          reactivateViewModel.changeCheckedBox();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.03,
            ),
            buildnavigateReactivate(),
            CustomSizedBox(
              height: 0.01,
            ),
          ],
        ),
      ),
    );
  }

  ///navigate to register screen
  Widget buildnavigateReactivate() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: (reactivateViewModel.needToLoad)
          ? const CustomLoader()
          : CustomElevatedButton(
              text: stringVariables.reactivate,
              color: black,
              multiClick: true,
              press: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                reactivateAccount();
              },
              radius: 25,
              buttoncolor: themeColor,
              width: 0.0,
              height: MediaQuery.of(context).size.height / 50,
              isBorderedButton: false,
              maxLines: 1,
              icons: false,
              icon: null),
    );
  }

  /// reactivate Account

  reactivateAccount() {
    if (reactivateViewModel.active != false &&
        reactivateViewModel.select != false) {
      reactivateViewModel.reactivateAccount(
        context,
      );
    } else {
      customSnackBar.showSnakbar(
          context,
          "Terms and conditions should be accepted to reactivate the account!",
          SnackbarType.negative);
    }
  }
}
