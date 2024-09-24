import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/Model/BankDetailHistoryModel.dart';
import 'package:zodeakx_mobile/Common/BankDetailsHistory/ViewModel/BankDetailHistoryViewModel.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomIconButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNoDataImage.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTextformfield.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import 'package:zodeakx_mobile/Utils/Widgets/appSnackBar.dart/snackbarType.dart';

import '../../../Utils/Languages/English/StringVariables.dart';

class BankDetailHistoryView extends StatefulWidget {
  const BankDetailHistoryView({Key? key}) : super(key: key);

  @override
  State<BankDetailHistoryView> createState() => _BankDetailHistoryViewState();
}

class _BankDetailHistoryViewState extends State<BankDetailHistoryView> {
  List<BankDetail> _searchResult = [];
  List<GetBankHistoryDetails>? Result;
  int val = 1;
  int count = 0;
  TextEditingController search = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController accnumber = TextEditingController();
  final TextEditingController bankName = TextEditingController();
  final TextEditingController IbanNumber = TextEditingController();
  final TextEditingController bankAddress = TextEditingController();
  bool isButtonPressed = false;
  bool isButtonTap = false;
  bool isSelect = false;
  late GetBankdetailsHistoryViewModel getBankDetailsHistoryViewModel;

  @override
  void initState() {
    getBankDetailsHistoryViewModel =
        Provider.of<GetBankdetailsHistoryViewModel>(context, listen: false);
    getBankDetailsHistoryViewModel.getBankDetailsHistory();
    super.initState();
  }

  getBankName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    constant.bankName.value = prefs.getString("bankName").toString();
  }

  @override
  Widget build(BuildContext context) {
    getBankDetailsHistoryViewModel =
        context.watch<GetBankdetailsHistoryViewModel>();

    return Provider<GetBankdetailsHistoryViewModel>(
      create: (context) => getBankDetailsHistoryViewModel,
      builder: (context, child) {
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
                    Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        fontfamily: 'InterTight',
                        fontsize: 23,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        text: stringVariables.bankDetailsHistory,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: getBankDetailsHistoryViewModel
                              .getBankDetails![0].bankDetails!.isEmpty
                          ? const Center(child: CustomNoDataImage())
                          : CustomCard(
                              radius: 25,
                              edgeInsets: 8,
                              outerPadding: 8,
                              elevation: 0,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    buildsearchfield(),
                                    buildBankHistory(),
                                  ],
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildsearchfield() {
    return Column(
      children: [
        buildSearchBankHistory(),
        buildCustomHeader(),
      ],
    );
  }

  Widget buildBankHistory() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        search.text.isNotEmpty && _searchResult.isEmpty
            ? noRecords()
            : _searchResult.isNotEmpty || search.text.isNotEmpty
                ? ListView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: _searchResult.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        onTap: () {},
                        leading: CustomText(
                          text: '${_searchResult[i].bankName?.toUpperCase()}',
                          color: themeSupport().isSelectedDarkMode()
                              ? white
                              : hintLight,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomContainer(
                              width: 15,
                              height: 0.0,
                              child: CustomIconButton(
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                onPress: () {
                                  displayEditDialog(context, i, true);
                                  getBankDetailsHistoryViewModel
                                      .getBankDetailsHistory();
                                },
                              ),
                            ),
                            CustomIconButton(
                              onPress: () {
                                displayDialog(context, i);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                : ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: 400, minHeight: 56.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: getBankDetailsHistoryViewModel
                                .getBankDetails?[0].bankDetails?.length ??
                            0,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            dense: true,
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -2),
                            leading: CustomText(
                              text: getBankDetailsHistoryViewModel
                                      .getBankDetails?[0]
                                      .bankDetails?[index]
                                      .bankName
                                      ?.toUpperCase() ??
                                  "",
                              color: themeSupport().isSelectedDarkMode()
                                  ? white
                                  : hintLight,
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomContainer(
                                    width: 15,
                                    height: 0.0,
                                    child: CustomIconButton(
                                      onPress: () {
                                        displayEditDialog(
                                            context, index, false);
                                        getBankDetailsHistoryViewModel
                                            .getBankDetailsHistory();
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  CustomIconButton(
                                    onPress: () {
                                      ScaffoldMessenger.of(context)
                                          .removeCurrentSnackBar();
                                      displayDialog(context, index);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: pink,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
      ],
    );
  }

  /// Header Text
  Widget buildCustomHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: CustomText(
                text: stringVariables.bank,
                overflow: TextOverflow.ellipsis,
                fontfamily: 'InterTight',
                fontWeight: FontWeight.bold,
                fontsize: 17,
              )),
              Flexible(
                child: CustomText(
                  text: stringVariables.action,
                  press: () {},
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'InterTight',
                  fontWeight: FontWeight.bold,
                  fontsize: 17,
                ),
              ),
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildSearchBankHistory() {
    Result = getBankDetailsHistoryViewModel.getBankDetails;
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          press: () {
            search.clear();
            onSearchTextChanged(
              search.text,
            );
            onSearchTextChanged('');
          },
          onChanged: onSearchTextChanged,
          controller: search,
          prefixIcon: Icon(
            Icons.search,
            color: hintLight,
          ),
          size: 30,
          text: stringVariables.search,
          hintfontsize: 16,
          isContentPadding: false,
        ),
        CustomSizedBox(
          height: 0.04,
        ),
      ],
    );
  }

  /// show alert to edit bank history

  displayEditDialog(BuildContext context, int index,
      [bool search = false]) async {
    username.text = search
        ? '${_searchResult[index].accountHolderName}'
        : '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[index].accountHolderName}';
    accnumber.text = search
        ? '${_searchResult[index].accountNumber}'
        : '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[index].accountNumber}';
    bankName.text = search
        ? '${_searchResult[index].bankName}'
        : '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[index].bankName}';
    IbanNumber.text = search
        ? '${_searchResult[index].ibanNumber}'
        : '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[index].ibanNumber}';
    bankAddress.text = search
        ? '${_searchResult[index].bankAddress}'
        : '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[index].bankAddress}';
    getBankDetailsHistoryViewModel.setActive(
        context,
        getBankDetailsHistoryViewModel
                    .getBankDetails?[0].bankDetails?[index].primary ==
                true
            ? 1
            : 2);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return buildEditBankHistory(index);
        });
  }

  ///edit bank history
  Widget buildEditBankHistory(
    int index,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, right: 12, top: 28, bottom: 28),
      child: StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          content: CustomContainer(
            height: 1.5,
            width: 0.0,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CustomIconButton(
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildHeader(),
                              buildAccountHolderNameView(index),
                              buildAccountNumberView(index),
                              buildBankNameView(index),
                              buildIBANNumberView(index),
                              buildBankAddressView(index),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, top: 12, bottom: 8),
                                      child: CustomText(
                                        text: stringVariables.primary,
                                        color:
                                            themeSupport().isSelectedDarkMode()
                                                ? white70
                                                : hintLight,
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
                                          groupValue:
                                              getBankDetailsHistoryViewModel.id,
                                          onChanged: (value) {
                                            setState(() {
                                              getBankDetailsHistoryViewModel
                                                  .setCheckbox(true);

                                              getBankDetailsHistoryViewModel
                                                  .setActive(
                                                      context, value as int);
                                            });
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
                                          groupValue:
                                              getBankDetailsHistoryViewModel.id,
                                          onChanged: (value) {
                                            setState(() {
                                              getBankDetailsHistoryViewModel
                                                  .setCheckbox(false);

                                              getBankDetailsHistoryViewModel
                                                  .setActive(
                                                      context, value as int);
                                            });
                                          },
                                          activeColor: themeColor,
                                        ),
                                      ),
                                      Flexible(
                                          child: CustomText(
                                              text: stringVariables.no)),
                                    ],
                                  )
                                ],
                              ),
                              buildSubmitBankDetails(index, context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// show primary confirmation alert
  displayPrimaryDialog(BuildContext context, int index) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return buildPrimaryConfirmation(index);
        });
  }

  ///primary confirmation
  Widget buildPrimaryConfirmation(int index) {
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
                            getUserEditBankDetails(index, context);
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                            count = 0;
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
                          getUserEditBankDetails(index, context);
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

  /// show alert to delete bank history

  displayDialog(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return buildDeleteBankHistory(index);
        });
  }

  ///delete bank history
  Widget buildDeleteBankHistory(
    int index,
  ) {
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
                      text: stringVariables.deleteBank,
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
                      text: stringVariables.deleteBankDetail,
                      color: textGrey,
                      fontsize: 15,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 7),
                    child: CustomText(
                      text: stringVariables.deleteDetail,
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
                            getUserBankDetails(index);
                            getBankDetailsHistoryViewModel
                                .getBankDetails?[0].bankDetails
                                ?.removeAt(index);
                            Navigator.pop(context);
                          },
                          radius: 25,
                          buttoncolor: enableBorder,
                          width: MediaQuery.of(context).size.width / 100,
                          height: MediaQuery.of(context).size.height / 50,
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
                          Navigator.pop(context);
                        },
                        radius: 25,
                        buttoncolor: themeColor,
                        width: MediaQuery.of(context).size.width / 100,
                        height: MediaQuery.of(context).size.height / 50,
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

  onSearchTextChanged(
    String text,
  ) async {
    _searchResult.clear();
    setState(() {});
    if (text.isEmpty) {
      return;
    }
    List<GetBankHistoryDetails> searchResult =
        Result as List<GetBankHistoryDetails>;
    List<BankDetail>? search = searchResult[0].bankDetails;
    _searchResult = search!
        .where((element) =>
            element.bankName!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    setState(() {});
  }

  noRecords() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSizedBox(
          height: 0.05,
        ),
        CustomText(
          text: stringVariables.notFound,
          fontsize: 15,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  /// Delete BankDetails from User
  getUserBankDetails(int index) {
    var bankDetail = BankDetail(
        id: '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[index].id ?? 0}');
    getBankDetailsHistoryViewModel.deleteUserBankDetails(bankDetail, context);
  }

  /// customHeader
  Widget buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CustomText(
            text: stringVariables.editAccount,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 20,
          ),
        )
      ],
    );
  }

  /// AccountHolderName TextFormField with Text
  Widget buildAccountHolderNameView(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.accHolderName} *',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
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
          controller: username,
          autovalid: AutovalidateMode.always,
          size: 30,
          isContentPadding: false,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// AccountNumber TextFormField with Text
  Widget buildAccountNumberView(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.accNumber} *',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
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
          autovalid: AutovalidateMode.always,
          size: 30,
          isContentPadding: false,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// BankName TextFormField with Text
  Widget buildBankNameView(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.bankName} *',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
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
          autovalid: AutovalidateMode.always,
          size: 30,
          isContentPadding: false,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// IBAN Number TextFormField with Text
  Widget buildIBANNumberView(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.ibanNum} *',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
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
          autovalid: AutovalidateMode.always,
          size: 30,
          isContentPadding: false,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  /// Bank Address TextFormField with Text
  Widget buildBankAddressView(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: CustomText(
            text: '${stringVariables.bankAddress} *',
            color: themeSupport().isSelectedDarkMode() ? white70 : hintLight,
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
          autovalid: AutovalidateMode.always,
          size: 30,
          isContentPadding: false,
          hintColor: themeSupport().isSelectedDarkMode() ? white : black,
        )
      ],
    );
  }

  ///Submit Bank Details
  Widget buildSubmitBankDetails(int index, context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 7, right: 7, bottom: 15),
      child: CustomElevatedButton(
          multiClick: true,
          blurRadius: 0,
          spreadRadius: 0,
          offset: Offset(0, 0),
          color: themeSupport().isSelectedDarkMode() ? black : white,
          text: stringVariables.submit,
          press: () {
            if (username.text.isNotEmpty &&
                accnumber.text.isNotEmpty &&
                bankName.text.isNotEmpty &&
                IbanNumber.text.isNotEmpty &&
                bankAddress.text.isNotEmpty) {
              List<BankDetail>? primaryAccount = getBankDetailsHistoryViewModel
                  .getBankDetails?[0].bankDetails
                  ?.where((element) => element.primary == true)
                  .toList();
              ((primaryAccount?.length ?? 0) > 0)
                  ? (getBankDetailsHistoryViewModel.id == 1)
                      ? displayPrimaryDialog(
                          context,
                          index,
                        )
                      : getUserEditBankDetails(index, context)
                  : getUserEditBankDetails(index, context);
            } else {
              customSnackBar.showSnakbar(context,
                  stringVariables.provideValidData, SnackbarType.negative);
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
    );
  }

  /// Get user BankDetails from User
  getUserEditBankDetails(int index, context) {
    if (username.text != "" &&
        accnumber.text != "" &&
        bankName.text != "" &&
        IbanNumber.text != "" &&
        bankAddress.text != "") {
      getBankDetailsHistoryViewModel.createUserEditBankDetails(
          username.text,
          accnumber.text,
          bankName.text,
          IbanNumber.text,
          bankAddress.text,
          getBankDetailsHistoryViewModel.checkBoxStatus,
          '${getBankDetailsHistoryViewModel.getBankDetails?[0].bankDetails?[index].id}',
          context);
    } else {}
  }
}
