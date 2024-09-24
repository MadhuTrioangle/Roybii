import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../ViewModel/DeletePasswordViewModel.dart';

class DeletePasswordView extends StatefulWidget {
  const DeletePasswordView({super.key});

  @override
  State<DeletePasswordView> createState() => _DeletePasswordViewState();
}

class _DeletePasswordViewState extends State<DeletePasswordView> {
  late DeletePasswordViewModel deletePasswordViewModel;

  @override
  void initState() {
    // TODO: implement initState
    deletePasswordViewModel =
        Provider.of<DeletePasswordViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    deletePasswordViewModel.password.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deletePasswordViewModel = context.watch<DeletePasswordViewModel>();
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
                  text: stringVariables.password,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: buildPasswordView(),
    );
  }

  buildPasswordView() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: CustomText(
                    text: stringVariables.enterPassword,
                    fontsize: 15,
                  ),
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            CustomTextFormField(
              press: () {},
              hintColor: white,
              //keys: field2Key,
              //focusNode: focusNode2,
              controller: deletePasswordViewModel.password,
              autovalid: AutovalidateMode.onUserInteraction,
              validator: (input) =>
                  input!.isEmpty ? stringVariables.passwordRequired : null,
              isBorderedButton: deletePasswordViewModel.passwordVisible,
              text: stringVariables.password,
              suffixIcon: GestureDetector(
                onTap: () {
                  deletePasswordViewModel.changeIcon();
                },
                child: Icon(
                  deletePasswordViewModel.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
              hintfontsize: 12,
              isContentPadding: false, size: 30,
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            deletePasswordViewModel.loading
                ? CustomLoader()
                : CustomElevatedButton(
                    text: stringVariables.deleteAccount,
                    multiClick: true,
                    press: () async {
                      if (deletePasswordViewModel.password.text.isEmpty) {
                        customSnackBar.showSnakbar(
                            context,
                            stringVariables.passwordRequired,
                            SnackbarType.negative);
                      } else {
                        deletePasswordViewModel.setLoading(true);
                        deletePasswordViewModel.createDeleteAccount();
                      }
                    },
                    radius: 25,
                    buttoncolor: themeColor,
                    width: 0.0,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: false,
                    maxLines: 1,
                    icons: false,
                    icon: null,
                    color: themeSupport().isSelectedDarkMode() ? black : white,
                  ),
            CustomSizedBox(
              height: 0.01,
            ),
            // CustomElevatedButton(
            //         press: () async {
            //           if (deletePasswordViewModel.password.text.isEmpty) {
            //             customSnackBar.showSnakbar(
            //                 context,
            //                 stringVariables.passwordRequired,
            //                 SnackbarType.negative);
            //           } else {
            //             deletePasswordViewModel.setLoading(true);
            //             deletePasswordViewModel.createDeleteAccount();
            //           }
            //         },
            //         text: stringVariables.deleteAccount,
            //         width: size.width / 1.1,
            //         height: 60,
            //         isBorderedButton: false,
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //       ),
          ],
        ),
      ),
    ));
  }
}
