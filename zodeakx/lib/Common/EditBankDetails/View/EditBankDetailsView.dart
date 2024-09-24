import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/EditBankDetails/ViewModel/EditBankDetailsViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../BankDetailsHistory/Model/BankDetailHistoryModel.dart';

class EditBankDetailsView extends StatefulWidget {
  final index;

  EditBankDetailsView({Key? key, required this.index}) : super(key: key);

  @override
  State<EditBankDetailsView> createState() => _EditBankDetailsViewState();
}

enum OS { yes, no }

class _EditBankDetailsViewState extends State<EditBankDetailsView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController accnumber = TextEditingController();
  final TextEditingController bankName = TextEditingController();
  final TextEditingController IbanNumber = TextEditingController();
  final TextEditingController bankAddress = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  late EditBankDetailsViewModel editBankDetailsViewModel;
  int val = 2;

  @override
  Widget build(BuildContext context) {
    editBankDetailsViewModel = context.watch<EditBankDetailsViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (editBankDetailsViewModel.showSnackbar)
          ? customSnackBar.showSnakbar(
              context,
              editBankDetailsViewModel
                      .editBankDetailsUserResponse?.statusMessage ??
                  "",
              (editBankDetailsViewModel.positiveStatus)
                  ? SnackbarType.positive
                  : SnackbarType.negative)
          : '';
      editBankDetailsViewModel.showSnackbar = false;
    });

    return Provider<EditBankDetailsViewModel>(
      create: (context) => editBankDetailsViewModel,
      child: Builder(builder: (context) {
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
                      fontfamily: 'GoogleSans',
                      fontsize: 23,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      text: stringVariables.editBankDetails,
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
              child: Column(
                children: [
                  CustomCard(
                    radius: 25,
                    edgeInsets: 8,
                    outerPadding: 8,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAccountHolderNameView(),
                        buildAccountNumberView(),
                        buildBankNameView(),
                        buildIBANNumberView(),
                        buildBankAddressView(),
                        buildCustomPrimary(),
                        buildSubmitBankDetails(widget.index, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// AccountHolderName TextFormField with Text
  Widget buildAccountHolderNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 28),
          child: CustomText(
            text: '${stringVariables.accHolderName}*',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          isContentPadding: false,
          controller: username
            ..text =
                '${editBankDetailsViewModel.getBankDetails?[0].bankDetails?[widget.index].accountHolderName}',
          autovalid: AutovalidateMode.always,
          size: 30,
          //   text:  '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[0].accountHolderName}',

          // validator: (input) =>_hasInputError1 ? input!.isEmpty? '' :null: null,
          color: themeSupport().isSelectedDarkMode() ? white : black,
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
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: '${stringVariables.accNumber}*',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          controller: accnumber
            ..text =
                '${editBankDetailsViewModel.getBankDetails?[0].bankDetails?[widget.index].accountNumber}',
          autovalid: AutovalidateMode.always,
          size: 30,
          isContentPadding: false,
          color: themeSupport().isSelectedDarkMode() ? white : black,
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
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: '${stringVariables.bankName}*',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          isContentPadding: false,
          controller: bankName
            ..text =
                '${editBankDetailsViewModel.getBankDetails?[0].bankDetails?[widget.index].bankName}',
          autovalid: AutovalidateMode.always,
          size: 30,
          //initText: '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[0].bankName}',

          color: themeSupport().isSelectedDarkMode() ? white : black,
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
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: '${stringVariables.ibanNum}*',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          isContentPadding: false,
          controller: IbanNumber
            ..text =
                '${editBankDetailsViewModel.getBankDetails?[0].bankDetails?[widget.index].ibanNumber}',
          autovalid: AutovalidateMode.always,
          size: 30,
          //initText: '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[0].ibanNumber}',

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
          padding: const EdgeInsets.only(left: 12.0, top: 8),
          child: CustomText(
            text: '${stringVariables.bankAddress}*',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          isContentPadding: false,
          controller: bankAddress
            ..text =
                '${editBankDetailsViewModel.getBankDetails?[0].bankDetails?[widget.index].bankAddress}',
          autovalid: AutovalidateMode.always,
          size: 30,
          //initText: '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[0].bankAddress}',

          color: themeSupport().isSelectedDarkMode() ? white : black,
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
              color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'GoogleSans',
              fontWeight: FontWeight.bold,
              fontsize: 15,
            )),
        Row(
          children: [
            Flexible(
              child: Radio(
                value: 1,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = value as int;
                  });
                },
                activeColor: themeColor,
              ),
            ),
            Flexible(
                child: CustomText(
              text: stringVariables.yes,
            )),
            Flexible(
              child: Radio(
                value: 2,
                groupValue: val,
                onChanged: (value) {
                  setState(() {
                    val = value as int;
                  });
                },
                activeColor: themeColor,
              ),
            ),
            Flexible(child: CustomText(text: stringVariables.no)),
          ],
        )
      ],
    );
  }

  ///Submit Bank Details
  Widget buildSubmitBankDetails(int index, context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 7, right: 7, bottom: 15),
      child: CustomElevatedButton(
          text: stringVariables.submit,
          color: black,
          press: () {
            if (username.text.isNotEmpty &&
                accnumber.text.isNotEmpty &&
                bankName.text.isNotEmpty &&
                IbanNumber.text.isNotEmpty &&
                bankAddress.text.isNotEmpty) {
              getUserBankDetails(editBankDetailsViewModel, index, context);
            }

            ScaffoldMessenger.of(context).removeCurrentSnackBar();
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

  /// Get user BankDetails from User
  getUserBankDetails(
      EditBankDetailsViewModel editBankDetailsViewModel, int index, context) {
    if (username.text != "" &&
        accnumber.text != "" &&
        bankName.text != "" &&
        IbanNumber.text != "" &&
        bankAddress.text != "") {
      var bankDetail = BankDetail(
          accountHolderName: username.text,
          accountNumber: accnumber.text,
          bankName: bankName.text,
          ibanNumber: IbanNumber.text,
          bankAddress: bankAddress.text,
          primary: editBankDetailsViewModel
              .getBankDetails?[0].bankDetails?[index].primary,
          id: '${editBankDetailsViewModel.getBankDetails?[0].bankDetails?[index].id}');
      editBankDetailsViewModel.createUserEditBankDetails(bankDetail, context);
    } else {}
  }
}
