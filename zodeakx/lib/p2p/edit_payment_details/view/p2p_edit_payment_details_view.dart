import 'dart:convert';

import 'package:flutter/material.dart';
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
  late Widget currentView = CustomSizedBox();
  TextEditingController nameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  late FocusNode nameFocusNode;
  late FocusNode accNoFocusNode;
  late FocusNode ifscFocusNode;
  late FocusNode bankNameFocusNode;
  late FocusNode accountTypeFocusNode;
  late FocusNode branchFocusNode;
  late FocusNode upiFocusNode;
  GlobalKey<FormFieldState> nameFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> accNoFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> ifscFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> bankNameFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> accountTypeFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> branchFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> upiFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  bool nameFlag = true;
  bool accNoFlag = true;
  bool ifscFlag = true;
  bool bankNameFlag = true;
  bool accountTypeFlag = true;
  bool branchFlag = true;
  bool upiFlag = true;

  @override
  void dispose() {
    // TODO: implement dispose
    nameFocusNode.dispose();
    accNoFocusNode.dispose();
    ifscFocusNode.dispose();
    bankNameFocusNode.dispose();
    accountTypeFocusNode.dispose();
    branchFocusNode.dispose();
    upiFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);

    nameFocusNode = FocusNode();
    accNoFocusNode = FocusNode();
    ifscFocusNode = FocusNode();
    bankNameFocusNode = FocusNode();
    accountTypeFocusNode = FocusNode();
    branchFocusNode = FocusNode();
    upiFocusNode = FocusNode();

    validator(nameFieldKey, nameFocusNode);
    validator(accNoFieldKey, accNoFocusNode);
    validator(ifscFieldKey, ifscFocusNode);
    validator(bankNameFieldKey, bankNameFocusNode);
    validator(accountTypeFieldKey, accountTypeFocusNode);
    validator(branchFieldKey, branchFocusNode);
    validator(upiFieldKey, upiFocusNode);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setImageQrCodeEncoded(null);
      viewModel.setEditQr(null);
      viewModel.setValidInput(true);
      viewModel.setPaymentDetails(null);
      updateItems();
      checkValidInput();
    });
  }

  checkValidInput() {
    nameController.addListener(() {
      nameFlag = nameController.text.isNotEmpty;
      validateInput();
    });
    accNoController.addListener(() {
      accNoFlag = accNoController.text.isNotEmpty;
      validateInput();
    });
    ifscController.addListener(() {
      ifscFlag = ifscController.text.isNotEmpty;
      validateInput();
    });
    bankNameController.addListener(() {
      bankNameFlag = bankNameController.text.isNotEmpty;
      validateInput();
    });
    accountTypeController.addListener(() {
      accountTypeFlag = accountTypeController.text.isNotEmpty;
      validateInput();
    });
    branchController.addListener(() {
      branchFlag = branchController.text.isNotEmpty;
      validateInput();
    });
    upiController.addListener(() {
      upiFlag = upiController.text.isNotEmpty;
      validateInput();
    });
  }

  validateInput() {
    UserPaymentDetails userPaymentDetails = widget.userPaymentDetails;
    String name = userPaymentDetails.paymentName ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    switch (name.toLowerCase()) {
      case "paytm":
        if (accNoFlag)
          viewModel.setValidInput(true);
        else
          viewModel.setValidInput(false);
        break;
      case "imps":
      case "bank transfer":
        if (accNoFlag &&
            ifscFlag &&
            bankNameFlag &&
            accountTypeFlag &&
            branchFlag)
          viewModel.setValidInput(true);
        else
          viewModel.setValidInput(false);
        break;
      case "upi":
        if (upiFlag)
          viewModel.setValidInput(true);
        else
          viewModel.setValidInput(false);
        break;
      default:
        break;
    }
  }

  updateItems() {
    UserPaymentDetails userPaymentDetails = widget.userPaymentDetails;
    String name = userPaymentDetails.paymentName ?? "";
    String userName = (viewModel.getUserByJwt?.kyc?.idProof?.firstName ?? "") +
        " " +
        (viewModel.getUserByJwt?.kyc?.idProof?.lastName ?? "");
    String bankName = userPaymentDetails.paymentDetails?.bankName ?? "";
    String accountNumber =
        userPaymentDetails.paymentDetails?.accountNumber ?? "";
    String ifsc = userPaymentDetails.paymentDetails?.ifscCode ?? "";
    String accountType = userPaymentDetails.paymentDetails?.accountType ?? "";
    String branch = userPaymentDetails.paymentDetails?.branch ?? "";
    String upi = name == stringVariables.upi
        ? userPaymentDetails.paymentDetails?.upiId ?? ""
        : userPaymentDetails.paymentDetails?.accountNumber ?? "";
    String qr = userPaymentDetails.paymentDetails?.qrCode ?? "";
    String qrEncoded = userPaymentDetails.paymentDetails?.qrCode ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    switch (name.toLowerCase()) {
      case "paytm":
        nameController.text = userName;
        accNoController.text = accountNumber;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setEditQr(qrEncoded);
        });
        break;
      case "imps":
      case "bank transfer":
        nameController.text = userName;
        accNoController.text = accountNumber;
        ifscController.text = ifsc;
        bankNameController.text = bankName;
        accountTypeController.text = accountType;
        branchController.text = branch;
        break;
      case "upi":
        nameController.text = userName;
        upiController.text = upi;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setEditQr(qrEncoded);
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PPaymentMethodsViewModel>();
    Size size = MediaQuery.of(context).size;
    UserPaymentDetails userPaymentDetails = widget.userPaymentDetails;
    String name = userPaymentDetails.paymentName ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    switch (name.toLowerCase()) {
      case "paytm":
        currentView = buildPaytmView(size);
        break;
      case "imps":
        currentView = buildImpsAndBankView(
            size, stringVariables.name, stringVariables.bankAccountNumber);
        break;
      case "upi":
        currentView = buildUpiView(size);
        break;
      case "bank transfer":
        currentView = buildImpsAndBankView(
            size, stringVariables.accHolderName, stringVariables.accountNo);
        break;
      default:
        currentView = CustomSizedBox();
        break;
    }
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
    return Column(
      children: [
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: stringVariables.addPaymentContent,
          fontfamily: 'GoogleSans',
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
                if (tfaStatus) {
                  UserPaymentDetails userPaymentDetails =
                      widget.userPaymentDetails;
                  String name = userPaymentDetails.paymentName ?? "";
                  PaymentDetails paymentDetails = PaymentDetails(
                      id: userPaymentDetails.id,
                      accountNumber: accNoController.text,
                      accountType: accountTypeController.text,
                      bankName: bankNameController.text,
                      branch: branchController.text,
                      ifscCode: ifscController.text,
                      paymentName: name,
                      qrCode: viewModel.imageQrCodeEncoded,
                      upiId: upiController.text);
                  viewModel.setPaymentDetails(paymentDetails);
                  moveToVerifyCode(
                      context, AuthenticationVerificationType.EditPayment);
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

  Widget buildPaytmView(Size size) {
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFormFieldWithText(
                  size,
                  stringVariables.name,
                  stringVariables.enterYourName,
                  nameController,
                  nameFieldKey,
                  nameFocusNode),
              buildTextFormFieldWithText(
                  size,
                  stringVariables.account,
                  stringVariables.enterAccountNumber,
                  accNoController,
                  accNoFieldKey,
                  accNoFocusNode),
              buildPaytmQRCode(size, stringVariables.paymentQRCode),
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

  Widget buildImpsAndBankView(
      Size size, String titleOfName, String titleOfAccountNumber) {
    Widget typeAndname = CustomSizedBox();
    if (titleOfName == stringVariables.name) {
      typeAndname = Column(
        children: [
          buildTextFormFieldWithText(
              size,
              stringVariables.bankName,
              stringVariables.enterNameOfBank,
              bankNameController,
              bankNameFieldKey,
              bankNameFocusNode),
          buildTextFormFieldWithText(
              size,
              stringVariables.accountType,
              stringVariables.specifyAccountType,
              accountTypeController,
              accountTypeFieldKey,
              accountTypeFocusNode),
        ],
      );
    } else {
      typeAndname = Column(
        children: [
          buildTextFormFieldWithText(
              size,
              stringVariables.accountType,
              stringVariables.specifyAccountType,
              accountTypeController,
              accountTypeFieldKey,
              accountTypeFocusNode),
          buildTextFormFieldWithText(
              size,
              stringVariables.bankName,
              stringVariables.enterNameOfBank,
              bankNameController,
              bankNameFieldKey,
              bankNameFocusNode),
        ],
      );
    }
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFormFieldWithText(
                  size,
                  titleOfName,
                  stringVariables.enterYourName,
                  nameController,
                  nameFieldKey,
                  nameFocusNode),
              buildTextFormFieldWithText(
                  size,
                  titleOfAccountNumber,
                  stringVariables.enterBankAccountNumber,
                  accNoController,
                  accNoFieldKey,
                  accNoFocusNode),
              buildTextFormFieldWithText(
                  size,
                  stringVariables.ifscCode,
                  stringVariables.enterIfsccode,
                  ifscController,
                  ifscFieldKey,
                  ifscFocusNode),
              typeAndname,
              buildTextFormFieldWithText(
                  size,
                  stringVariables.accountOpeningBranch,
                  stringVariables.enterBankInformation,
                  branchController,
                  branchFieldKey,
                  branchFocusNode),
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

  Widget buildUpiView(Size size) {
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFormFieldWithText(
                  size,
                  stringVariables.name,
                  stringVariables.enterYourName,
                  nameController,
                  nameFieldKey,
                  nameFocusNode),
              buildTextFormFieldWithText(
                  size,
                  stringVariables.upiId,
                  stringVariables.upiHint,
                  upiController,
                  upiFieldKey,
                  upiFocusNode),
              buildPaytmQRCode(size, stringVariables.paymentQRCode),
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
            fontfamily: 'GoogleSans',
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
                                  offset: Offset(-2, 2),
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
                        fontfamily: 'GoogleSans',
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
                              fontfamily: 'GoogleSans',
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
      FocusNode focusNode) {
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.w500,
            fontsize: 16,
            color: hintLight,
          ),
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        CustomTextFormField(
          isReadOnly: controller == nameController,
          controller: controller,
          keys: fieldKey,
          focusNode: focusNode,
          validator: (input) => (input ?? "").isEmpty
              ? (controller == upiController
                  ? stringVariables.enterUpiId
                  : hint)
              : null,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width / 35, right: 15),
                    child: SvgPicture.asset(
                      backArrow,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.edit + " " + name,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'GoogleSans',
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
