import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/home/view_model/p2p_home_view_model.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/model/p2p_payment_methods.dart';
import '../../payment_methods/view_model/p2p_payment_methods_view_model.dart';
import 'border/dotted_border.dart';

class P2PAddPaymentDetailsView extends StatefulWidget {
  final String title;

  const P2PAddPaymentDetailsView({Key? key, required this.title})
      : super(key: key);

  @override
  State<P2PAddPaymentDetailsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PAddPaymentDetailsView>
    with TickerProviderStateMixin {
  late P2PPaymentMethodsViewModel viewModel;
  late P2PHomeViewModel p2pHomeViewModel;
  late Widget currentView = CustomSizedBox();
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> dynamicController = [];
  List<FocusNode> dynamicFocusNode = [];
  List<GlobalKey<FormFieldState>> dynamicFieldKey = [];
  List<bool> dynamicFlag = [];
  List<bool> dynamicMandatoryFlag = [];
  List<PaymentField> paymentFields = [];
  String paymentName = "";
  @override
  void dispose() {
    // TODO: implement dispose
    dynamicFocusNode.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    p2pHomeViewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    securedPrint("widget.title${widget.title}");
    if (widget.title == "Bank Transfer") {
      paymentName = "bank_transfer";
    } else {
      paymentName = widget.title;
    }
    PaymentMethods paymentMethods = p2pHomeViewModel.paymentMethods
            ?.where((element) => element.name == paymentName)
            .first ??
        PaymentMethods();
    paymentFields = paymentMethods.paymentFields ?? [];

    paymentFields.forEach((element) {
      if (element.type != "image") {
        GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();
        FocusNode focusNode = FocusNode();
        validator(fieldKey, focusNode);
        TextEditingController controller = TextEditingController();
        dynamicController.add(controller);
        dynamicFlag.add(!(element.isMandatory ?? false));
        dynamicFocusNode.add(focusNode);
        dynamicFieldKey.add(fieldKey);
        dynamicMandatoryFlag.add(element.isMandatory ?? false);
      } else {
        dynamicMandatoryFlag.add(element.isMandatory ?? false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setImageQrCodeEncoded(null);
      viewModel.setPaymentDetails(null);
      viewModel.setValidInput(false);
      viewModel.setImageRequire(false);
      checkValidInput();
    });
  }

  checkValidInput() {
    for (int i = 0; i < dynamicController.length; i++) {
      dynamicController[i].addListener(() {
        dynamicFlag[i] =
            dynamicController[i].text.isNotEmpty || !dynamicMandatoryFlag[i];
        validateInput();
      });
    }
  }

  validateInput() {
    if (dynamicFlag.contains(false)) {
      viewModel.setValidInput(false);
    } else {
      if (viewModel.imageQrCodeEncoded == null) {
        viewModel.setImageRequire(true);
        viewModel.setValidInput(false);
      } else {
        viewModel.setValidInput(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PPaymentMethodsViewModel>();

    Size size = MediaQuery.of(context).size;
    currentView = dynamicWidget(size);
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PAddPaymentDetailsView(size),
      ),
    );
  }

  Widget dynamicWidget(Size size) {
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < paymentFields.length; i++)
                if (paymentFields[i].type != "image")
                  buildTextFormFieldWithText(
                      size,
                      paymentFields[i].label ?? "",
                      "${stringVariables.enterYour} ${paymentFields[i].label ?? ""}",
                      dynamicController[i],
                      dynamicFieldKey[i],
                      dynamicFocusNode[i],
                      dynamicFlag[i],
                      dynamicMandatoryFlag[i],
                      paymentFields[i].type == "number")
                else
                  buildPaytmQRCode(
                      size,
                      paymentFields[i].label ?? "",
                      dynamicMandatoryFlag[i],
                      "${stringVariables.uploadYour} ${paymentFields[i].label ?? ""}"),
              CustomSizedBox(
                height: 0.02,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom / 3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildP2PAddPaymentDetailsView(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [currentView, buildBottomView(size)],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomView(Size size) {
    bool tfaStatus = viewModel.getUserByJwt?.tfaStatus == 'verified';
    bool mobileStatus =
        viewModel.getUserByJwt?.tfaAuthentication?.mobileNumber?.status ==
            'verified';
    return Column(
      children: [
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: stringVariables.addPaymentContent,
          fontfamily: 'InterTight',
          fontWeight: FontWeight.w400,
          fontsize: 14,
          color: hintLight,
          strutStyleHeight: 1.5,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomElevatedButton(
            width: 1.2,
            buttoncolor: viewModel.isValidInput ? themeColor : grey,
            color: viewModel.isValidInput ? black : hintLight,
            press: () {
              if (viewModel.isValidInput) {
                if (tfaStatus || mobileStatus) {
                  String payment = widget.title;
                  if (payment == stringVariables.bankTransfer) {
                    payment = "bank_transfer";
                  }
                  Map<String, dynamic> paymentDetailsParams = {};
                  int count = 0;
                  for (int i = 0; i < paymentFields.length; i++) {
                    if (paymentFields[i].type != "image") {
                      if (dynamicController[count].text.isNotEmpty) {
                        paymentDetailsParams["${paymentFields[i].labelKey}"] =
                            dynamicController[count].text;
                      }
                      count++;
                    } else {
                      if (viewModel.imageQrCodeEncoded != null)
                        paymentDetailsParams["${paymentFields[i].labelKey}"] =
                            viewModel.imageQrCodeEncoded;
                    }
                  }
                  viewModel.setPaymentDetails(payment);
                  viewModel.setPaymentDetailsParams(paymentDetailsParams);
                  moveToVerifyCode(
                      context,
                      AuthenticationVerificationType.AddPayment,
                      viewModel.getUserByJwt?.tfaStatus,
                      viewModel.getUserByJwt?.tfaAuthentication?.mobileNumber
                          ?.status,
                      viewModel.getUserByJwt?.tfaAuthentication?.mobileNumber
                          ?.phoneCode,
                      viewModel.getUserByJwt?.tfaAuthentication?.mobileNumber
                          ?.phoneNumber);
                } else {
                  customSnackBar.showSnakbar(context, stringVariables.enableTfa,
                      SnackbarType.negative);
                }
              } else {
                _formKey.currentState!.validate();
              }
            },
            isBorderedButton: true,
            maxLines: 1,
            icon: null,
            multiClick: true,
            text: stringVariables.confirm,
            radius: 25,
            height: size.height / 50,
            icons: false,
            blurRadius: 0,
            spreadRadius: 0,
            offset: Offset(0, 0)),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildPaytmQRCode(
      Size size, String title, bool mandatory, String requireMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 100),
          child: CustomText(
            text: title + (mandatory ? "*" : ""),
            fontfamily: 'InterTight',
            fontWeight: FontWeight.w500,
            fontsize: 16,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        GestureDetector(
            onTap: () async {
              await viewModel.pickImageForQrCode();
              if (viewModel.imageQrCodeEncoded == null) {
                viewModel.setImageRequire(true);
                validateInput();
              } else {
                viewModel.setImageRequire(false);
                validateInput();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: viewModel.imageQrCodeEncoded != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContainer(
                        width: 3.5,
                        height: 6,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                viewModel.pickImageForQrCode();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: Image.memory(
                                    fit: BoxFit.cover,
                                    width: size.width / 3.35,
                                    height: size.height / 5.8,
                                    base64.decode(
                                        '${viewModel?.imageQrCodeEncoded}')),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await viewModel.setImageQrCodeEncoded(null);
                                if (viewModel.imageQrCodeEncoded == null) {
                                  viewModel.setImageRequire(true);
                                  validateInput();
                                }
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Transform.translate(
                                  offset: Offset(
                                      Directionality.of(context) ==
                                              TextDirection.rtl
                                          ? 2
                                          : -2,
                                      2),
                                  child: Icon(
                                    Icons.close,
                                    color: black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.0075,
                      ),
                      CustomText(
                        press: () {
                          viewModel.pickImageForQrCode();
                        },
                        text: stringVariables.reUpload,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.w400,
                        fontsize: 14,
                        color: themeColor,
                      ),
                    ],
                  )
                : DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    strokeWidth: 1.5,
                    dashPattern: [6, 4],
                    color: themeSupport().isSelectedDarkMode()
                        ? white.withOpacity(0.4)
                        : black.withOpacity(0.4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: CustomContainer(
                        width: 3.5,
                        height: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              p2pUpload,
                            ),
                            CustomSizedBox(
                              height: 0.005,
                            ),
                            CustomText(
                              text: stringVariables.upload,
                              fontfamily: 'InterTight',
                              fontWeight: FontWeight.w400,
                              fontsize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
        CustomSizedBox(
          height: 0.0075,
        ),
        viewModel.imageRequire
            ? CustomText(
                text: requireMessage,
                color: Colors.red,
              )
            : CustomText(
                text: "",
              )
      ],
    );
  }

  buildTextFormFieldWithText(
      Size size,
      String title,
      String hint,
      TextEditingController controller,
      GlobalKey<FormFieldState> fieldKey,
      FocusNode focusNode,
      bool flag,
      bool mandatoryFlag,
      [bool number = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 100),
          child: CustomText(
            text: title + (mandatoryFlag ? "*" : ""),
            fontfamily: 'InterTight',
            fontWeight: FontWeight.w500,
            fontsize: 16,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        CustomTextFormField(
          keys: fieldKey,
          autovalid: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
          validator: (value) {
            if ((value ?? "").isEmpty) {
              return hint;
            }
            return null;
          },
          inputFormatters: [
            if (number) FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
          ],
          controller: controller,
          padLeft: 0,
          padRight: 0,
          isContentPadding: false,
          size: 30,
          text: hint,
        ),
      ],
    );
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
    return AppBar(
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
                fontfamily: 'InterTight',
                fontsize: 23,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                text: stringVariables.add + " " + widget.title,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(Size size) {
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          // backButton(context),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.add + " " + widget.title,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.bold,
              fontsize: 15,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}
