import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomIconButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../ViewModel/DeleteAccountViewModel.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  late DeleteAccountViewModel viewModel;
  final GlobalKey _stateKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<DeleteAccountViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(false);
      viewModel.setButtonClick(true);
      viewModel.currentlength = 0;
      viewModel.reason.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return buildDeleteAccountView(context, size);
  }

  Widget buildDeleteAccountView(BuildContext context, Size size) {
    viewModel = context.watch<DeleteAccountViewModel>();
    return Provider(
      create: (context) => viewModel,
      child: WillPopScope(
        onWillPop: () async => true,
        child: CustomScaffold(
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
                      text: stringVariables.deletionReason,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: buildDetailsCard(size),
        ),
      ),
    );
  }

  Widget buildDetailsCard(Size size) {
    return SingleChildScrollView(
        child: CustomCard(
            radius: 25,
            edgeInsets: 4,
            outerPadding: 8,
            elevation: 0,
            child: buildDeleteAccount(size)));
  }

  Widget buildBottomView(size) {
    return viewModel.needToLoad
        ? CustomLoader()
        : Column(
            children: [
              CustomElevatedButton(
                  text: stringVariables.continues.toUpperCase(),
                  multiClick: true,
                  color: themeSupport().isSelectedDarkMode() ? black : white,
                  press: () {
                    if (!viewModel.buttonClick) {
                      if (viewModel.reason.text.isEmpty) {
                        customSnackBar.showSnakbar(
                            context,
                            stringVariables.reasonRequired,
                            SnackbarType.negative);
                      } else {
                        moveToDeleteTermsConditionView(context);
                      }
                    } else {
                      moveToDeleteTermsConditionView(context);
                    }
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
              //     if (!viewModel.buttonClick) {
              //       if (viewModel.reason.text.isEmpty) {
              //         customSnackBar.showSnakbar(
              //             context,
              //             stringVariables.reasonRequired,
              //             SnackbarType.negative);
              //       } else {
              //         moveToDeleteTermsConditionView(context);
              //       }
              //     } else {
              //       moveToDeleteTermsConditionView(context);
              //     }
              //   },
              //   text: stringVariables.emailButtonContinue,
              //   width: size.width * 0.85,
              //   height: 60,
              //   isBorderedButton: false,
              //   fontSize: 16,
              //   fontWeight: FontWeight.w500,
              // ),
              CustomSizedBox(
                height: 0.02,
              ),
            ],
          );
  }

  Widget buildDeleteAccount(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            CustomSizedBox(
              height: 0.02,
              width: double.infinity,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                viewModel.setButtonClick(true);
              },
              child: CustomContainer(
                width: 1.15,
                height: 14,
                color: themeSupport().isSelectedDarkMode() ? black12 : grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomSizedBox(
                            width: 0.02,
                          ),
                          CustomText(
                            fontsize: 12,
                            overflow: TextOverflow.ellipsis,
                            maxlines: 2,
                            softwrap: true,
                            color: viewModel.buttonClick
                                ? themeColor
                                : themeSupport().isSelectedDarkMode()
                                    ? white
                                    : black,
                            fontWeight: FontWeight.w400,
                            text: stringVariables.noLongerUserAccount,
                          ),
                        ],
                      ),
                      CustomIconButton(
                          onPress: () {
                            viewModel.setButtonClick(true);
                          },
                          child: Icon(
                            Icons.radio_button_checked,
                            size: 15,
                            color: viewModel.buttonClick
                                ? themeColor
                                : themeSupport().isSelectedDarkMode()
                                    ? white
                                    : black,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                viewModel.setButtonClick(false);
              },
              child: CustomContainer(
                width: 1.15,
                height: 14,
                color: themeSupport().isSelectedDarkMode() ? black12 : grey,
                child: AbsorbPointer(
                  absorbing: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            CustomText(
                              fontsize: 12,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w400,
                              color: viewModel.buttonClick
                                  ? themeSupport().isSelectedDarkMode()
                                      ? white
                                      : black
                                  : themeColor,
                              text: stringVariables.others,
                            ),
                          ],
                        ),
                        CustomIconButton(
                            onPress: () {
                              viewModel.setButtonClick(false);
                            },
                            child: Icon(
                              Icons.radio_button_checked,
                              size: 15,
                              color: viewModel.buttonClick
                                  ? themeSupport().isSelectedDarkMode()
                                      ? white
                                      : black
                                  : themeColor,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            ),
          ],
        ),
        if (!viewModel.buttonClick)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      size: 30,
                      isContentPadding: true,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      minLines: 4,
                      maxLength: 500,
                      controller: viewModel.reason,
                      hintColor: white,
                      autovalid: AutovalidateMode.onUserInteraction,
                      onChanged: onInput,
                    ),
                  ),
                ],
              ),
              CustomSizedBox(
                height: 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: CustomText(
                      text: "${viewModel.currentlength}/500",
                      align: TextAlign.end,
                    ),
                  )
                ],
              ),
              CustomSizedBox(
                height: 0.05,
              ),
            ],
          ),
        buildBottomView(size),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom)),
      ],
    );
  }

  onInput(String text) {
    viewModel.setCurrentLength(text.length);
  }
}
