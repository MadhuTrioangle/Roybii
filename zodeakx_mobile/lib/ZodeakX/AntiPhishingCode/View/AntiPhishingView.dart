import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/ZodeakX/AntiPhishingCode/ViewModel/AntiPhishingViewModel.dart';

import '../../../Utils/Widgets/CustomContainer.dart';

class AntiPhishingCodeView extends StatefulWidget {
  AuthenticationVerificationType? screenType;

  AntiPhishingCodeView({Key? key, this.screenType}) : super(key: key);

  @override
  State<AntiPhishingCodeView> createState() => _AntiPhishingCodeViewState();
}

class _AntiPhishingCodeViewState extends State<AntiPhishingCodeView> {
  TextEditingController antiPhishingCode = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var shouldAbsorb = true;
  var isDisable = true;
  bool isClicked = false;
  int count = 0;
  late AntiPhishingViewModel antiPhishingViewModel;

  @override
  Widget build(BuildContext context) {
    antiPhishingViewModel = context.watch<AntiPhishingViewModel>();

    return Provider<AntiPhishingViewModel>(
      create: (context) => AntiPhishingViewModel(),
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
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
                          Navigator.of(context).popUntil((_) => count++ >= 2);
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
                        text: stringVariables.security,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomCard(
                    radius: 25,
                    edgeInsets: 4,
                    outerPadding: 8,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCustomHeader(),
                        buildAntiPhishingDefinition(),
                        buildAntiPhishingWorking(),
                        buildSubmitConfirmChanges(),
                        CustomSizedBox(
                          height: 0.03,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Custom header
  Widget buildCustomHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 20),
          child: CustomText(
            text: stringVariables.antiPhispingCode,
            fontWeight: FontWeight.bold,
            fontsize: 18,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
        ),
        CustomSizedBox(
          height: 0.03,
        )
      ],
    );
  }

  /// AntiPhishing definition
  Widget buildAntiPhishingDefinition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 18),
          child: CustomText(
            text: stringVariables.antiPhishing,
            fontWeight: FontWeight.bold,
            fontsize: 15,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 15),
          child: CustomText(
            text: stringVariables.defAntiPhishing,
            fontsize: 11,
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
            strutStyleHeight: 1.3,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        )
      ],
    );
  }

  /// AntiPhishing Working
  Widget buildAntiPhishingWorking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 15),
          child: CustomText(
            text: stringVariables.workAntiPhishing,
            fontWeight: FontWeight.bold,
            fontsize: 15,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 15),
          child: CustomText(
            text: stringVariables.workAntiPhishingDef,
            fontsize: 11,
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
            strutStyleHeight: 1.3,
          ),
        ),
        CustomSizedBox(
          height: 0.04,
        )
      ],
    );
  }

  ///submit Confirm Changes
  Widget buildSubmitConfirmChanges() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: CustomElevatedButton(
          multiClick: true,
          blurRadius: 0,
          spreadRadius: 0,
          offset: Offset(0, 0),
          color: themeSupport().isSelectedDarkMode() ? black : white,
          text: stringVariables.createAntiPhishing,
          press: () {
            displayDialog(context, antiPhishingViewModel);
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

  /// show alert to create antiphishing code

  displayDialog(
      BuildContext context, AntiPhishingViewModel antiPhishingViewModel) async {
    return showDialog(
        context: context,
        builder: (context) {
          return buildAntiPhisingCode(antiPhishingViewModel, context);
        });
  }

  /// New Anti-Phising Code
  Widget buildAntiPhisingCode(
      AntiPhishingViewModel antiPhishingViewModel, context) {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12),
        child: StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: CustomText(
                          text: stringVariables.createAntiPhisingcode,
                          fontWeight: FontWeight.bold,
                          fontsize: 20,
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: CustomText(
                          text: stringVariables.newDeviceLogin,
                          fontsize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      Flexible(
                        child: CustomTextFormField(
                          size: 30,
                          maxLength: 20,
                          isContentPadding: false,
                          text: stringVariables.enterAntiPhisingCode,
                          controller: antiPhishingCode,
                          autovalid: AutovalidateMode.onUserInteraction,
                          validator: (input) => input!.isEmpty
                              ? stringVariables.antiPhisingRequired
                              : (input.length >= 4 && input.length <= 20) &&
                                      (input.isValidSpecialCharacter())
                                  ? null
                                  : stringVariables.antiPhisingValidator,
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.03,
                      ),
                      (antiPhishingViewModel.needToLoad)
                          ? CustomLoader()
                          : CustomElevatedButton(
                              multiClick: true,
                              color: themeSupport().isSelectedDarkMode()
                                  ? black
                                  : white,
                              blurRadius: 0,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                              text: stringVariables.submit,
                              press: () async {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                if (formKey.currentState!.validate()) {
                                  getAntiPhishingCode(antiPhishingViewModel,
                                      context, widget.screenType);
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  /// Get forgot password details from User
  getAntiPhishingCode(AntiPhishingViewModel antiPhishingViewModel, context,
      [screenType]) {
    antiPhishingViewModel.createAntiphishingCode(
        antiPhishingCode.text, context, screenType);
  }
}

class FormFieldValidator {
  static String? validate(String value, String message) {
    return RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value) ? null : message;
  }
}
