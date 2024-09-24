import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/BankDetails/ViewModel/BankDetailsViewModel.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/Model/BankDetailHistoryModel.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/View/BankDetailHistoryView.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/ViewModel/BankDetailHistoryViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../../SiteMaintenance/ViewModel/SiteMaintenanceViewModel.dart';

class BankDetailsView extends StatefulWidget {
  const BankDetailsView({Key? key}) : super(key: key);

  @override
  State<BankDetailsView> createState() => _BankDetailsViewState();
}

class _BankDetailsViewState extends State<BankDetailsView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController accnumber = TextEditingController();
  final TextEditingController bankName = TextEditingController();
  final TextEditingController IbanNumber = TextEditingController();
  final TextEditingController bankAddress = TextEditingController();
  bool isAlreadySelect = false;
  bool Selected = false;
  late AddBankDetailsViewModel bankDetailsViewModel;
  late GetBankdetailsHistoryViewModel getBankdetailsHistoryViewModel;
  SiteMaintenanceViewModel? siteMaintenanceViewModel;

  @override
  void initState() {
    getBankdetailsHistoryViewModel =
        Provider.of<GetBankdetailsHistoryViewModel>(context, listen: false);
    bankDetailsViewModel =
        Provider.of<AddBankDetailsViewModel>(context, listen: false);
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    bankDetailsViewModel.getBankDetailHistory();
    getBankdetailsHistoryViewModel.getBankDetailsHistory();
    siteMaintenanceViewModel?.getSiteMaintenanceStatus();

    super.initState();
  }

  @override
  void dispose() {
    if (constant.previousScreen.value == ScreenType.Market) {
      resumeSocket();
      constant.previousScreen.value = ScreenType.Login;
    }
    super.dispose();
  }

  resumeSocket() {
    MarketViewModel marketViewModel = Provider.of<MarketViewModel>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    marketViewModel.initSocket = true;
    marketViewModel.getTradePairs();
  }

  int val = 2;

  @override
  Widget build(BuildContext context) {
    bankDetailsViewModel = context.watch<AddBankDetailsViewModel>();
    getBankdetailsHistoryViewModel =
        context.watch<GetBankdetailsHistoryViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      (bankDetailsViewModel.showSnackbar)
          ? customSnackBar.showSnakbar(
              context,
              bankDetailsViewModel.addBankDetailsUserResponse?.statusMessage ??
                  "",
              (bankDetailsViewModel.positiveStatus)
                  ? SnackbarType.positive
                  : SnackbarType.negative)
          : '';
      bankDetailsViewModel.showSnackbar = false;
    });

    return Provider<AddBankDetailsViewModel>(
      create: (context) => bankDetailsViewModel,
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
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
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          bankDetailsViewModel.closedPage = true;
                          Navigator.pop(context);
                          siteMaintenanceViewModel?.leaveSocket();
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
                        text: stringVariables.bankDetails,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: [
                    CustomContainer(
                      height: 1.21,
                      width: 0.0,
                      child: CustomCard(
                        radius: 25,
                        edgeInsets: 8,
                        outerPadding: 8,
                        elevation: 0,
                        child: SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildCustomHeader(),
                                buildAccountHolderNameView(),
                                buildAccountNumberView(),
                                buildBankNameView(),
                                buildIBANNumberView(),
                                buildBankAddressView(),
                                buildCustomPrimary(),
                                buildSubmitBankDetails(context),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Header Text
  Widget buildCustomHeader() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 20, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: CustomText(
                text: stringVariables.addAccount,
                overflow: TextOverflow.ellipsis,
                fontfamily: 'InterTight',
                fontWeight: FontWeight.bold,
                fontsize: 20,
              )),
              Flexible(
                child: CustomText(
                  text: stringVariables.bankDetailsHistory,
                  decoration: TextDecoration.underline,
                  press: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankDetailHistoryView()))
                        .then((value) {
                      //This makes sure the textfield is cleared after page is pushed.
                      formKey.currentState!.reset();
                      bankDetailsViewModel.hasInputError1 =
                          false; //Check your conditions on text variable
                      bankDetailsViewModel.hasInputError2 = false;
                      bankDetailsViewModel.hasInputError3 = false;
                      bankDetailsViewModel.hasInputError4 = false;
                      bankDetailsViewModel.hasInputError5 = false;
                    });
                  },
                  overflow: TextOverflow.ellipsis,
                  color: themeColor,
                  fontsize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// AccountHolderName TextFormField with Text
  Widget buildAccountHolderNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: '${stringVariables.accHolderName} *',
            color: textGrey,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          isContentPadding: false,
          controller: username,
          autovalid: AutovalidateMode.always,
          size: 30,
          text: stringVariables.accHolderName,
          focusNode: bankDetailsViewModel.focusNode,
          validator: (input) => bankDetailsViewModel.hasInputError1
              ? input!.isEmpty
                  ? ""
                  : null
              : null,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// AccountNumber TextFormField with Text
  Widget buildAccountNumberView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.accNumber} *',
            color: textGrey,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          controller: accnumber,
          isContentPadding: false,
          autovalid: AutovalidateMode.always,
          size: 30,
          text: stringVariables.accNumber,
          focusNode: bankDetailsViewModel.focusNode2,
          validator: (input) => bankDetailsViewModel.hasInputError2
              ? input!.isEmpty
                  ? ""
                  : null
              : null,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// BankName TextFormField with Text
  Widget buildBankNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.bankName} *',
            color: textGrey,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          controller: bankName,
          isContentPadding: false,
          autovalid: AutovalidateMode.always,
          size: 30,
          text: stringVariables.bankName,
          focusNode: bankDetailsViewModel.focusNode3,
          validator: (input) => bankDetailsViewModel.hasInputError3
              ? input!.isEmpty
                  ? ""
                  : null
              : null,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// IBAN Number TextFormField with Text
  Widget buildIBANNumberView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.ibanNum} *',
            color: textGrey,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          controller: IbanNumber,
          isContentPadding: false,
          autovalid: AutovalidateMode.always,
          size: 30,
          text: stringVariables.ibanNum,
          validator: (input) => bankDetailsViewModel.hasInputError4
              ? input!.isEmpty
                  ? ""
                  : null
              : null,
          focusNode: bankDetailsViewModel.focusNode4,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// Bank Address TextFormField with Text
  Widget buildBankAddressView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.bankAddress} *',
            color: textGrey,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          controller: bankAddress,
          isContentPadding: false,
          autovalid: AutovalidateMode.always,
          size: 30,
          text: stringVariables.bankAddress,
          focusNode: bankDetailsViewModel.focusNode5,
          validator: (input) => bankDetailsViewModel.hasInputError5
              ? input!.isEmpty
                  ? ""
                  : null
              : null,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// Header Text
  Widget buildCustomPrimary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 8),
            child: CustomText(
              text: stringVariables.primary,
              color: textGrey,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
              fontWeight: FontWeight.bold,
              fontsize: 15,
            )),
        Row(
          children: [
            Flexible(
              child: Radio(
                value: 1,
                activeColor: themeColor,
                groupValue: bankDetailsViewModel.id,
                onChanged: (value) {
                  List<BankDetail>? primaryAccount = bankDetailsViewModel
                      .getBankDetailsHistory?[0].bankDetails
                      ?.where((element) => element.primary == true)
                      .toList();
                  bankDetailsViewModel.setCheckbox(true);
                  bankDetailsViewModel.setActiveR(context, value as int);
                },
              ),
            ),
            Flexible(
                child: CustomText(
              text: stringVariables.yes,
            )),
            Flexible(
              child: Radio(
                value: 2,
                activeColor: themeColor,
                groupValue: bankDetailsViewModel.id,
                onChanged: (value) {
                  bankDetailsViewModel.setCheckbox(false);
                  bankDetailsViewModel.setActiveR(context, value as int);
                },
              ),
            ),
            Flexible(child: CustomText(text: stringVariables.no)),
          ],
        )
      ],
    );
  }

  ///Submit Bank Details
  Widget buildSubmitBankDetails(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 7, right: 7, bottom: 15),
      child: CustomElevatedButton(
          text: stringVariables.submit,
          color: themeSupport().isSelectedDarkMode() ? black : white,
          multiClick: true,
          press: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            List<BankDetail>? primaryAccount = getBankdetailsHistoryViewModel
                .getBankDetails?[0].bankDetails
                ?.where((element) => element.primary == true)
                .toList();

            if (username.text.isNotEmpty &&
                accnumber.text.isNotEmpty &&
                bankName.text.isNotEmpty &&
                IbanNumber.text.isNotEmpty &&
                bankAddress.text.isNotEmpty) {
              if (isNumeric(username.text)) {
                customSnackBar.showSnakbar(
                    context,
                    stringVariables.numbersAreNotAllowed,
                    SnackbarType.negative);
              } else {
                if ((getBankdetailsHistoryViewModel
                            .getBankDetails?[0].bankDetails ??
                        [])
                    .isNotEmpty) {
                  ((primaryAccount?.length ?? 0) > 0)
                      ? (bankDetailsViewModel.id == 1)
                          ? displayDialog(
                              context,
                            )
                          : getUserBankDetails(context)
                      : getUserBankDetails(context);
                } else {
                  getUserBankDetails(context);
                }
              }
            }
          },
          spreadRadius: 0.0,
          blurRadius: 0.0,
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  /// Get user BankDetails from User
  getUserBankDetails(context) async {
    if (username.text != "" &&
        accnumber.text != "" &&
        bankName.text != "" &&
        IbanNumber.text != "" &&
        bankAddress.text != "") {
      var clear = await bankDetailsViewModel.createUserBankDetails(
          accnumber.text,
          username.text,
          bankName.text,
          IbanNumber.text,
          bankAddress.text,
          bankDetailsViewModel.checkBoxStatus,
          context);
      if (clear == true) {
        username.clear();
        accnumber.clear();
        bankName.clear();
        bankAddress.clear();
        IbanNumber.clear();
        bankDetailsViewModel.setActiveR(context, 2);
      }
    }
  }

  /// show primary confirmation alert
  displayDialog(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return buildPrimaryConfirmation();
        });
  }

  ///primary confirmation
  Widget buildPrimaryConfirmation() {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: CustomText(
                      text: stringVariables.primaryConfirmation,
                      align: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      fontsize: 20,
                    ),
                  ),
                  CustomSizedBox(
                    height: 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: CustomText(
                      text: stringVariables.primarySelected,
                      color: textGrey,
                      fontsize: 15,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 7),
                    child: CustomText(
                      text: stringVariables.switchAcc,
                      color: textGrey,
                      fontsize: 15,
                    ),
                  ),
                  CustomSizedBox(
                    height: 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                          color: black,
                          text: stringVariables.yes,
                          press: () {
                            getUserBankDetails(context);
                            Navigator.pop(context);
                          },
                          radius: 5,
                          buttoncolor: enableBorder,
                          width: MediaQuery.of(context).size.width / 90,
                          height: MediaQuery.of(context).size.height / 45,
                          isBorderedButton: false,
                          maxLines: 1,
                          icons: false,
                          icon: null),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      CustomElevatedButton(
                        blurRadius: 0,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                        color:
                            themeSupport().isSelectedDarkMode() ? black : white,
                        text: stringVariables.no,
                        press: () {
                          bankDetailsViewModel.setActiveR(context, 2);
                          bankDetailsViewModel.setCheckbox(false);
                          getUserBankDetails(context);
                          Navigator.pop(context);
                        },
                        radius: 5,
                        buttoncolor: themeColor,
                        width: MediaQuery.of(context).size.width / 90,
                        height: MediaQuery.of(context).size.height / 45,
                        isBorderedButton: false,
                        maxLines: 1,
                        icons: false,
                        icon: null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
