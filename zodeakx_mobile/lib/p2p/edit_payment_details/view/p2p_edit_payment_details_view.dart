import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../add_payment_details/view/border/dotted_border.dart';
import '../../home/model/p2p_payment_methods.dart';
import '../../home/view_model/p2p_home_view_model.dart';
import '../../payment_methods/view_model/p2p_payment_methods_view_model.dart';
import '../../profile/model/UserPaymentDetailsModel.dart';

class P2PEditPaymentDetailsView extends StatefulWidget {
  final UserPaymentDetails userPaymentDetails;

  const P2PEditPaymentDetailsView({Key? key, required this.userPaymentDetails})
      : super(key: key);

  @override
  State<P2PEditPaymentDetailsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PEditPaymentDetailsView>
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

    String name = widget.userPaymentDetails.paymentName ?? "";
    PaymentMethods paymentMethods = p2pHomeViewModel.paymentMethods
            ?.where((element) => element.name == name)
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
        dynamicFlag.add(true);
        dynamicMandatoryFlag.add(element.isMandatory ?? false);
        dynamicFocusNode.add(focusNode);
        dynamicFieldKey.add(fieldKey);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setImageQrCodeEncoded(null);
      viewModel.setEditQr(null);
      viewModel.setValidInput(false);
      viewModel.setPaymentDetails(null);
      updateItems();
      checkValidInput();
      validateInput();
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
      viewModel.setValidInput(true);
    }
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
                      paymentFields[i].type == "alphaNumeric")
                else
                  buildPaytmQRCode(
                    size,
                    paymentFields[i].label ?? "",
                  ),
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

  updateItems() async {
    UserPaymentDetails userPaymentDetails = widget.userPaymentDetails;
    String name = userPaymentDetails.paymentName ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    Map<String, dynamic> paymentDetails =
        userPaymentDetails.paymentDetails ?? {};
    int count = 0;
    for (String i in paymentDetails.values) {
      bool isImage = hasValidUrl(i);
      if (isImage) {
        viewModel.imageQrCodeEncoded = i;
        viewModel.setEditQr(i);
      } else {
        dynamicController[count].text = i;
        count++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PPaymentMethodsViewModel>();

    Size size = MediaQuery.of(context).size;
    UserPaymentDetails userPaymentDetails = widget.userPaymentDetails;
    String name = userPaymentDetails.paymentName ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    currentView = dynamicWidget(size);
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PEditPaymentDetailsView(size),
      ),
    );
  }

  Widget buildP2PEditPaymentDetailsView(Size size) {
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
          thickness: 0.2,
          color: divider,
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
                  UserPaymentDetails userPaymentDetails =
                      widget.userPaymentDetails;
                  String name = userPaymentDetails.paymentName ?? "";
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
                      if (viewModel.imageQrCodeEncoded != null) {
                        paymentDetailsParams["${paymentFields[i].labelKey}"] =
                            viewModel.imageQrCodeEncoded;
                      }
                    }
                  }
                  viewModel.setPaymentDetails(name);
                  viewModel.setPaymentDetailsParams(paymentDetailsParams);
                  moveToVerifyCode(
                      context,
                      AuthenticationVerificationType.EditPayment,
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

  Widget buildPaytmQRCode(Size size, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 100),
          child: CustomText(
            text: title,
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
            onTap: () {
              viewModel.pickImageForQrCode();
            },
            behavior: HitTestBehavior.opaque,
            child: viewModel.imageQrCodeEncoded != null ||
                    viewModel.editQr != null &&
                        (viewModel.editQr ?? "").isNotEmpty
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
                                child: viewModel.editQr != null
                                    ? CustomNetworkImage(
                                        image: viewModel.editQr,
                                        fit: BoxFit.cover,
                                        width: size.width / 3.35,
                                        height: size.height / 5.8,
                                      )
                                    : Image.memory(
                                        fit: BoxFit.cover,
                                        width: size.width / 3.35,
                                        height: size.height / 5.8,
                                        base64.decode(
                                            '${viewModel?.imageQrCodeEncoded}')),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                viewModel.setImageQrCodeEncoded(null);
                                viewModel.setEditQr(null);
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
                  ))
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
    //securedPrint("number>>>>>>>${number}");
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
            if (!number) FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
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
        title: buildHeader(size));
  }

  Widget buildHeader(Size size) {
    UserPaymentDetails userPaymentDetails = widget.userPaymentDetails;
    String name = userPaymentDetails.paymentName ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          // backButton(context),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.edit + " " + name,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.bold,
              fontsize: 20,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}
