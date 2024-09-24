import 'dart:async';
import 'dart:io';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/UpdatePhoneNumber/ViewModel/UpdatePhoneNumberViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/keyboard_done_widget.dart';

class UpdatePhoneNumberView extends StatefulWidget {
  final bool isAdd;

  const UpdatePhoneNumberView({Key? key, required this.isAdd})
      : super(key: key);

  @override
  State<UpdatePhoneNumberView> createState() => _UpdatePhoneNumberViewState();
}

class _UpdatePhoneNumberViewState extends State<UpdatePhoneNumberView> {
  TextEditingController noController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  late UpdatePhoneNumberViewModel viewModel;
  GlobalKey<FormFieldState> noFieldKey = GlobalKey<FormFieldState>();
  late FocusNode noFocusNode;
  GlobalKey<FormFieldState> otpFieldKey = GlobalKey<FormFieldState>();
  late FocusNode otpFocusNode;
  Timer? _timer;
  final countryPicker = const FlCountryCodePicker();
  late StreamSubscription<bool> keyboardSubscription;
  var overlayEntry;
  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<UpdatePhoneNumberViewModel>(context, listen: false);
    noFocusNode = FocusNode();
    otpFocusNode = FocusNode();
    validator(noFieldKey, noFocusNode);
    validator(otpFieldKey, otpFocusNode);
    noController.addListener(() {
      viewModel.setPhoneNo(noController.text);
    });
    otpController.addListener(() {
      viewModel.setOtp(otpController.text);
    });
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      viewModel.setKeyboardVisibility(visible);
      if (Platform.isIOS) {
        if (!visible)
          removeOverlay();
        else
          showOverlay(context);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CountryCode countryCode = countryPicker.countryCodes
          .where((element) => element.code == "IN")
          .first;
      viewModel.setCountryCode(countryCode);
      viewModel.setRequestTimer(30);
    });
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        viewModel.setRequestTimer(viewModel.requestTimer - 1);
        if (viewModel.requestTimer == 0) {
          viewModel.setRequestTimer(30);
          _timer?.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<UpdatePhoneNumberViewModel>();
    return buildUpdatePhoneNumberView(context, size);
  }

  Widget buildUpdatePhoneNumberView(BuildContext context, Size size) {
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
              ],
            ),
          ),
        ),
        child: buildDetailsCard(size),
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
    List<String> list = [];
    int itemCount = list.length;
    return itemCount != 0
        ? CustomSizedBox()
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    maxlines: 2,
                    fontfamily: 'InterTight',
                    fontsize: 23,
                    fontWeight: FontWeight.bold,
                    text: widget.isAdd
                        ? stringVariables.addPhoneNumber
                        : stringVariables.changePhoneNumber,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                  CustomSizedBox(
                    height: 0.03,
                  ),
                  CustomTextFormField(
                    prefixIcon: GestureDetector(
                      onTap: () async {
                        // Show the country code picker when tapped.
                        final code = await FlCountryCodePicker(
                                searchBarDecoration: InputDecoration(
                                  hoverColor: themeColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: themeColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(color: themeColor),
                                  ),
                                ),
                                searchBarTextStyle: TextStyle(
                                    backgroundColor:
                                        themeSupport().isSelectedDarkMode()
                                            ? black
                                            : white))
                            .showPicker(
                                context: context,
                                backgroundColor:
                                    themeSupport().isSelectedDarkMode()
                                        ? black
                                        : white);
                        // Null check
                        if (code != null) {
                          viewModel.setCountryCode(code);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomSizedBox(
                            width: 0.03,
                          ),
                          CustomCircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                                child: Image.asset(
                              viewModel.countryCode?.flagUri ?? "",
                              width: 25,
                              height: 25,
                              fit: BoxFit.fill,
                              package: viewModel.countryCode?.flagImagePackage,
                            )),
                          ),
                          CustomSizedBox(
                            width: 0.01,
                          ),
                          CustomText(
                            fontfamily: 'InterTight',
                            fontsize: 15,
                            fontWeight: FontWeight.w500,
                            text: viewModel.countryCode?.dialCode ?? "",
                          ),
                          CustomSizedBox(
                            width: 0.01,
                          ),
                        ],
                      ),
                    ),
                    size: 30,
                    isContentPadding: false,
                    text: stringVariables.hintNumber,
                    controller: noController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    ],
                    focusNode: noFocusNode,
                    keys: noFieldKey,
                    autovalid: AutovalidateMode.onUserInteraction,
                    padLeft: 4,
                    padRight: 4,
                    validator: (input) => viewModel.phoneNo.isEmpty
                        ? stringVariables.hintNumber
                        : null,
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomTextFormField(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          child: CustomText(
                            fontfamily: 'InterTight',
                            fontWeight: FontWeight.w500,
                            text: viewModel.requestTimer != 30
                                ? stringVariables.codeSent
                                : stringVariables.getCode,
                            color: viewModel.requestTimer != 30
                                ? hintLight
                                : themeColor,
                          ),
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (viewModel.phoneNo.isEmpty) {
                              noFieldKey.currentState?.validate();
                              return;
                            }
                            if (viewModel.requestTimer == 30) {
                              startTimer();
                              viewModel.updateMobileNumber();
                            }
                          },
                        ),
                        CustomSizedBox(
                          width: 0.03,
                        )
                      ],
                    ),
                    size: 30,
                    isContentPadding: false,
                    text: stringVariables.hintOtp,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    ],
                    controller: otpController,
                    focusNode: otpFocusNode,
                    keyboardType: TextInputType.number,
                    keys: otpFieldKey,
                    autovalid: AutovalidateMode.onUserInteraction,
                    padLeft: 4,
                    padRight: 4,
                    maxLength: 6,
                    validator: (input) =>
                        viewModel.otp.isEmpty ? stringVariables.hintOtp : null,
                  ),
                  if (viewModel.requestTimer != 30)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        top: 9,
                      ),
                      child: CustomText(
                        text: stringVariables.requestNewCode +
                            " ${viewModel.requestTimer} " +
                            stringVariables.seconds,
                        fontsize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomElevatedButton(
                    text: stringVariables.submit,
                    multiClick: true,
                    color: themeSupport().isSelectedDarkMode()
                        ? (viewModel.otp.length == 6 &&
                                viewModel.phoneNo.isNotEmpty)
                            ? white
                            : black
                        : black,
                    press: () {
                      if (viewModel.phoneNo.isEmpty || viewModel.otp.isEmpty) {
                        noFieldKey.currentState?.validate();
                        otpFieldKey.currentState?.validate();
                        return;
                      }
                      if (viewModel.otp.length == 6 &&
                          viewModel.phoneNo.isNotEmpty) {
                        viewModel
                            .verifyMobileNumber(widget.isAdd ? false : true);
                      }
                    },
                    radius: 25,
                    buttoncolor: (viewModel.otp.length == 6 &&
                            viewModel.phoneNo.isNotEmpty)
                        ? themeColor
                        : grey,
                    width: 0.0,
                    height: MediaQuery.of(context).size.height / 50,
                    isBorderedButton: false,
                    maxLines: 1,
                    blurRadius: 0,
                    spreadRadius: 0,
                    icon: null,
                    icons: false,
                  ),
                ],
              ),
            ),
          );
  }
}
