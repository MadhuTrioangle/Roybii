import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Common/IdentityVerification/View/GalleryBottomSheet.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNetworkImage.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTimeLine.dart';

import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../ViewModel/IdentityVerificationCommonViewModel.dart';

class IdentityVerificationView extends StatefulWidget {
  const IdentityVerificationView({Key? key}) : super(key: key);

  @override
  State<IdentityVerificationView> createState() =>
      _IdentityVerificationViewState();
}

class _IdentityVerificationViewState extends State<IdentityVerificationView> {
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  bool cityFlag = false;
  bool clicked = false;
  final TextEditingController country = TextEditingController();
  bool countryFlag = false;
  final TextEditingController dob = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> field1Key = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> field2Key = GlobalKey<FormFieldState>();

  // int viewmodel.index = 0;
  final TextEditingController lastName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController state = TextEditingController();
  bool stateFlag = false;

  bool verified = false;
  bool canEDit = false;
  String cityName = "";

  @override
  DateTime date = DateTime(
    DateTime.now().year - 18,
    DateTime.now().month,
    DateTime.now().day,
  );

  final GlobalKey _countryKey = GlobalKey();
  final GlobalKey _stateKey = GlobalKey();
  late IdentityVerificationCommonViewModel viewModel;

  @override
  void initState() {
    getAllSavedData();
    viewModel = Provider.of<IdentityVerificationCommonViewModel>(context,
        listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dob.clear();
      viewModel.setLoading(true);
    });
    viewModel.getIdVerification();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setActive(context, 0);
      viewModel.setLoading(true);
    });

    super.initState();
  }

  getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clicked = prefs.getBool("clickedValue") ?? false;
  }

  ///viewmodel.index 1
  personalInfo() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          buildHeader(),
          buildFirstNameView(),
          buildMiddleNameView(),
          buildLastNameView(),
          buildDobView(),
          buildAddressView(),
          buildCountryView(),
          buildStateView(),
          buildCityView(),
          buildPostalCodeView(),
          // buildNext(viewModel),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  ///customheader
  Widget buildHeader() {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step2,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.personalInfoHeader,
          color: themeSupport().isSelectedDarkMode() ? white : textGrey,
        ),
      ],
    );
  }

  /// firstname TextFormField with Text
  Widget buildFirstNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.firstName,
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
            size: 30,
            isContentPadding: false,
            text: stringVariables.hintFirstname,
            isReadOnly:
                viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                    ? true
                    : false,
            controller: firstName
              ..text =
                  viewModel.viewModelVerification?.kyc?.idProof?.firstName ??
                      firstName.text,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => firstName.text.isEmpty
                ? stringVariables.firstNameRequired
                : firstName.text.length > 2
                    ? null
                    : stringVariables.contain3Characters,
            onChanged: (value) {
              viewModel.viewModelVerification?.kyc?.idProof?.firstName =
                  firstName.text;
            },
            onSaved: (input) {
              firstName.text = input!;
            }),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// middelename TextFormField with Text
  Widget buildMiddleNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.middleName,
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
            size: 30,
            isContentPadding: false,
            text: stringVariables.hintMiddlename,
            isReadOnly:
                viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                    ? true
                    : false,
            controller: middleName
              ..text =
                  viewModel.viewModelVerification?.kyc?.idProof?.middleName ??
                      middleName.text,
            autovalid: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              viewModel.viewModelVerification?.kyc?.idProof?.middleName =
                  middleName.text;
            },
            onSaved: (input) {
              middleName.text = input!;
            }),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// lastname TextFormField with Text
  Widget buildLastNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.lastName,
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
            size: 30,
            isContentPadding: false,
            text: stringVariables.hintLastname,
            isReadOnly:
                viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                    ? true
                    : false,
            controller: lastName
              ..text =
                  viewModel.viewModelVerification?.kyc?.idProof?.lastName ??
                      lastName.text,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => lastName.text.isEmpty
                ? stringVariables.lastNameRequired
                : lastName.text.length > 0
                    ? null
                    : stringVariables.contain1Characters,
            onChanged: (value) {
              viewModel.viewModelVerification?.kyc?.idProof?.lastName =
                  lastName.text;
            },
            onSaved: (input) {
              lastName.text = input!;
            }),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  onDOBClicked() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1970),
      lastDate: date,
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: themeColor,
                onPrimary: black,
                surface: black,
                onSurface: white,
              ),
              dialogBackgroundColor: black,
            ),
            child: child!);
      },
    );
    if (pickedDate != null) {
      viewModel.dateTime(
        pickedDate,
      );
      dob.text = '${viewModel.formatDate}';
    }
  }

  /// Dob TextFormField with Text
  Widget buildDobView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.dob,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // if (!viewModel.personalVerificationStatus) {
            onDOBClicked();
            // }
          },
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              text: stringVariables.dob,
              keyboardType: TextInputType.datetime,
              isReadOnly:
                  viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                      ? true
                      : false,
              controller: dob
                ..text =
                    ('${(viewModel.viewModelVerification?.kyc?.idProof?.dob != null && viewModel.viewModelVerification?.kyc?.idProof?.dob.toString() != "") ? viewModel.viewModelVerification?.kyc?.idProof?.dob.toString().substring(0, 10) : dob.text}'),
              autovalid: AutovalidateMode.onUserInteraction,
              validator: (input) =>
                  dob.text.isEmpty ? stringVariables.dobRequired : null,
              onSaved: (input) {
                dob.text = input!;
              }),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// Address TextFormField with Text
  Widget buildAddressView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.addressAstrict,
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
            isContentPadding: true,
            size: 30,
            text: stringVariables.hintAddress,
            maxLines: 4,
            minLines: 4,
            controller: address
              ..text =
                  viewModel.viewModelVerification?.kyc?.idProof?.address1 ??
                      address.text,
            isReadOnly:
                viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                    ? true
                    : false,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) =>
                address.text.isEmpty ? stringVariables.addressIsRequired : null,
            onChanged: (value) {
              viewModel.viewModelVerification?.kyc?.idProof?.address1 =
                  address.text;
            },
            onSaved: (input) {
              address.text = input!;
            }),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// Country TextFormField with Text
  Widget buildCountryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.country,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {
        //     dynamic state = _countryKey.currentState;
        //     state.showButtonMenu();
        //     // (viewModel.personalVerificationStatus)
        //     //     ? (() {})
        //     //     : state.showButtonMenu();
        //   },
        //   child: AbsorbPointer(
        //     absorbing: false,
        //     child: CustomTextFormField(
        //       key: _countryKey,
        //       size: 30,
        //       isContentPadding: false,
        //       text: viewModel.countryName,
        //       suffixIcon: PopupMenuButton(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(
        //             Radius.circular(20.0),
        //           ),
        //         ),
        //         offset: Offset(-(MediaQuery.of(context).size.width / 1.465), 0),
        //         constraints: new BoxConstraints(
        //           minHeight: (MediaQuery.of(context).size.height / 12),
        //           minWidth: (MediaQuery.of(context).size.width / 1.25),
        //           maxHeight: (MediaQuery.of(context).size.height / 2),
        //           maxWidth: (MediaQuery.of(context).size.width / 1.25),
        //         ),
        //         icon: Icon(Icons.arrow_drop_down),
        //         onSelected: (value) {
        //           // country.text = value as String;
        //           viewModel.setCountryName(value.toString());
        //         },
        //         color: checkBrightness.value == Brightness.dark ? black : white,
        //         itemBuilder: (
        //           BuildContext context,
        //         ) {
        //           return viewModel.countriesNameList
        //               .map<PopupMenuItem<String>>((String? value) {
        //             return PopupMenuItem(
        //                 onTap: () {
        //                   //  countryFlag = true;
        //                   //  stateFlag = false;
        //                   //  cityFlag = false;
        //                   viewModel.setCountryName(value.toString());
        //                 },
        //                 child: CustomText(text: value.toString()),
        //                 value: value);
        //           }).toList();
        //         },
        //       ),
        //       //  isReadOnly: viewModel.personalVerificationStatus,
        //       //country.text.isNotEmpty ? true : false,
        //       // controller: country
        //       //   ..text = countryFlag
        //       //       ? viewModel.countryName!
        //       //       : viewModel.getPersonalDetailsClass?.result?.country ??
        //       //           country.text,
        //       // autovalid: AutovalidateMode.onUserInteraction,
        //       // validator: (input) =>
        //       //     country.text.isEmpty ? 'Country is required' : null,
        //       // onSaved: (input) {
        //       //   country.text = input!;
        //       // }
        //     ),
        //   ),
        // ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            dynamic state = _countryKey.currentState;
            viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                ? () {}
                : state.showButtonMenu();
          },
          child: AbsorbPointer(
            child: CustomTextFormField(
              size: 30,
              controller: country..text = "${viewModel.countryName}",
              autovalid: AutovalidateMode.onUserInteraction,
              isReadOnly:
                  viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                      ? true
                      : false,
              keys: field1Key,
              validator: (input) =>
                  country.text.isEmpty ? stringVariables.countryRequired : null,
              isContentPadding: false,
              suffixIcon: PopupMenuButton(
                key: _countryKey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                offset: Offset(-(MediaQuery.of(context).size.width / 1.6), 0),
                constraints: new BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height / 12),
                  minWidth: (MediaQuery.of(context).size.width / 1.25),
                  maxHeight: (MediaQuery.of(context).size.height / 2),
                  maxWidth: (MediaQuery.of(context).size.width / 1.25),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                onSelected: (value) {
                  country.text = value as String;
                  viewModel.setCountryName(value.toString());
                },
                color: checkBrightness.value == Brightness.dark ? black : white,
                itemBuilder: (
                  BuildContext context,
                ) {
                  return viewModel.countriesNameList
                      .map<PopupMenuItem<String>>((String? value) {
                    return PopupMenuItem(
                        onTap: () {},
                        child: CustomText(text: value.toString()),
                        value: value);
                  }).toList();
                },
              ),
              text: stringVariables.select,
              hintColor: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List list) {
    List<DropdownMenuItem<String>> dropDownItems = [];
    list.forEach((value) {
      dropDownItems.add(DropdownMenuItem<String>(
        value: value,
        child: CustomText(
          text: value,
          fontWeight: FontWeight.bold,
          color: textGrey,
          fontsize: 15,
        ),
      ));
    });

    return dropDownItems;
  }

  /// State TextFormField with Text
  Widget buildStateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.state,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'InterTight',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {
        //     dynamic state = _stateKey.currentState;
        //     state.showButtonMenu();
        //     // (viewModel.personalVerificationStatus)
        //     //     ? (() {})
        //     //     : state.showButtonMenu();
        //   },
        //   child: AbsorbPointer(
        //     absorbing: false,
        //     child: CustomTextFormField(
        //       size: 30,
        //       isContentPadding: false,
        //       text: stringVariables.select,
        //       suffixIcon: PopupMenuButton(
        //         key: _stateKey,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(
        //             Radius.circular(20.0),
        //           ),
        //         ),
        //         offset: Offset(-(MediaQuery.of(context).size.width / 1.465), 0),
        //         constraints: new BoxConstraints(
        //           minHeight: (MediaQuery.of(context).size.height / 12),
        //           minWidth: (MediaQuery.of(context).size.width / 1.25),
        //           maxHeight: (MediaQuery.of(context).size.height / 2),
        //           maxWidth: (MediaQuery.of(context).size.width / 1.25),
        //         ),
        //         icon: Icon(Icons.arrow_drop_down),
        //         onSelected: (value) {
        //           state.text = value as String;
        //           viewModel.setStateName(value);
        //         },
        //         color: checkBrightness.value == Brightness.dark ? black : white,
        //         itemBuilder: (
        //           BuildContext context,
        //         ) {
        //           return viewModel.statesNameList
        //               .map<PopupMenuItem<String>>((String? value) {
        //             return PopupMenuItem(
        //                 onTap: () {
        //                   stateFlag = true;
        //                   cityFlag = false;
        //                 },
        //                 child: CustomText(text: value.toString()),
        //                 value: value);
        //           }).toList();
        //         },
        //       ),
        //       //  isReadOnly: viewModel.personalVerificationStatus,
        //       //state.text.isNotEmpty ? true : false,
        //       // controller: state..text = state.text,
        //       // autovalid: AutovalidateMode.onUserInteraction,
        //       // validator: (input) =>
        //       //     state.text.isEmpty ? 'State is required' : null,
        //       // onSaved: (input) {
        //       //   state.text = input!;
        //       // }
        //     ),
        //   ),
        // ),

        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            dynamic state = _stateKey.currentState;
            viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                ? () {}
                : state.showButtonMenu();
          },
          child: AbsorbPointer(
            child: CustomTextFormField(
              size: 30,
              controller: state..text = "${viewModel.stateName}",
              autovalid: AutovalidateMode.onUserInteraction,
              keys: field2Key,
              isReadOnly:
                  viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                      ? true
                      : false,
              validator: (input) =>
                  state.text.isEmpty ? stringVariables.stateRequired : null,
              isContentPadding: false,
              suffixIcon: PopupMenuButton(
                key: _stateKey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                offset: Offset(-(MediaQuery.of(context).size.width / 1.6), 0),
                constraints: new BoxConstraints(
                  minHeight: (MediaQuery.of(context).size.height / 12),
                  minWidth: (MediaQuery.of(context).size.width / 1.25),
                  maxHeight: (MediaQuery.of(context).size.height / 2),
                  maxWidth: (MediaQuery.of(context).size.width / 1.25),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
                onSelected: (value) {
                  state.text = value as String;
                  viewModel.setStateName(value);
                },
                color: checkBrightness.value == Brightness.dark ? black : white,
                itemBuilder: (
                  BuildContext context,
                ) {
                  return viewModel.statesNameList
                      .map<PopupMenuItem<String>>((String? value) {
                    return PopupMenuItem(
                        onTap: () {},
                        child: CustomText(text: value.toString()),
                        value: value);
                  }).toList();
                },
              ),
              text: stringVariables.select,
              hintColor: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
        ),

        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// city TextFormField with Text
  Widget buildCityView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.city,
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
            onChanged: (value) {
              //viewModel.setCityName(value);
              cityFlag = true;
              cityName = value;
            },
            size: 30,
            isContentPadding: false,
            text: stringVariables.hintCity,
            isReadOnly:
                viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                    ? true
                    : false,
            controller: city
              ..text = cityFlag
                  ? cityName
                  : countryFlag
                      ? ""
                      : viewModel.viewModelVerification?.kyc?.idProof?.city ??
                          city.text,
            autovalid: AutovalidateMode.onUserInteraction,
            //  isReadOnly: viewModel.personalVerificationStatus,
            validator: (input) =>
                city.text.isEmpty ? stringVariables.cityRequired : null,
            onSaved: (input) {
              city.text = input!;
            }),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// postalCode TextFormField with Text
  Widget buildPostalCodeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.postalCode,
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
            size: 30,
            isContentPadding: false,
            text: stringVariables.hintPostal,
            isReadOnly:
                viewModel.viewModelVerification?.kyc?.kycStatus == "verified"
                    ? true
                    : false,
            controller: postalCode
              ..text = viewModel.viewModelVerification?.kyc?.idProof?.zip ??
                  postalCode.text,
            autovalid: AutovalidateMode.onUserInteraction,
            validator: (input) => postalCode.text.isEmpty
                ? stringVariables.postalCodeRequired
                : null,
            onChanged: (value) {
              viewModel.viewModelVerification?.kyc?.idProof?.zip =
                  postalCode.text;
            },
            onSaved: (input) {
              postalCode.text = input!;
            }),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  ///viewmodel.index 3
  facialInfo() {
    return viewModel.needToLoad
        ? CustomLoader()
        : Center(
            child: Column(
              children: [
                headerStep1(),
                buildFacialView(
                  context,
                ),
                //  buildNext(facial),
              ],
            ),
          );
  }

  ///customheader
  Widget headerStep1() {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step3,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.facial_info,
          color: themeSupport().isSelectedDarkMode() ? white : textGrey,
        ),
      ],
    );
  }

  Widget loadFadeImage(String? url) {
    Image image = url != null
        ? Image.memory(base64.decode('${url}'.split(',').last))
        : Image.asset(
            themeSupport().isSelectedDarkMode() ? splashDark : splash);
    return CustomContainer(
      width: 1.75,
      height: 5,
      child: FadeInImage(
        fit: BoxFit.fitHeight,
        placeholder: AssetImage(
            themeSupport().isSelectedDarkMode() ? splashDark : splash),
        image: image.image,
      ),
    );
  }

  /// choose Facial view
  Widget buildFacialView(
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomSizedBox(
          height: 0.03,
        ),
        CustomContainer(
          width: 1.25,
          height: MediaQuery.of(context).size.height / 50,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    align: TextAlign.start,
                    fontfamily: 'InterTight',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    text: viewModel.imageFacialPicName == null
                        ? stringVariables.selfie
                        : (viewModel.imageFacialPicName!.split("/").last),
                    color: textGrey,
                    fontsize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, top: 4, bottom: 4),
                  child: GestureDetector(
                    onTap: () {
                      if ('${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus}' ==
                              "verified" ||
                          '${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus}' ==
                              "pending") {
                      } else {
                        viewModel.imageFacial(true);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: CustomContainer(
                      padding: 2,
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SvgPicture.asset(
                        camera,
                        color:
                            themeSupport().isSelectedDarkMode() ? black : white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        viewModel.imageFacialPic != null
            ? (!kIsWeb && defaultTargetPlatform == TargetPlatform.android
                ? FutureBuilder<void>(
                    future: retrieveFacialLostData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return CustomContainer(
                            width: 1.75,
                            height: 5,
                            child: Center(
                              child: CustomText(
                                text: stringVariables.haveNotPickedImage,
                              ),
                            ),
                          );
                        case ConnectionState.done:
                          return loadFadeImage(
                            '${viewModel.img643}',
                          );
                        case ConnectionState.active:
                          if (snapshot.hasError) {
                            return CustomContainer(
                              width: 1.75,
                              height: 5,
                              child: Center(
                                child: CustomText(
                                  text:
                                      'Pick image/video error: ${snapshot.error}}',
                                ),
                              ),
                            );
                          } else {
                            return CustomContainer(
                              width: 1.75,
                              height: 5,
                              child: Center(
                                child: CustomText(
                                  text: stringVariables.haveNotPickedImage,
                                ),
                              ),
                            );
                          }
                      }
                    },
                  )
                : loadFadeImage(
                    '${viewModel.img643}',
                  ))
            : "${viewModel.viewModelVerification?.kyc?.facialProof?.facialProof}" !=
                    ""
                ? CustomNetworkImage(
                    image:
                        "${viewModel.viewModelVerification?.kyc?.facialProof?.facialProof}",
                    height: 90,
                    width: 90,
                  )
                : SvgPicture.asset(
                    identityunverifyImage,
                    height: 90,
                    width: 90,
                  ),
        CustomSizedBox(
          height: 0.02,
        ),
        '${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus}' !=
                ""
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    '${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus}' ==
                            "verified"
                        ? doneVerify
                        : rejectedIcon,
                    height: 14,
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomText(
                    text:
                        '${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus ?? stringVariables.rejected}',
                    fontsize: 14,
                  ),
                ],
              )
            : SizedBox(),
        CustomSizedBox(height: 0.02),
      ],
    );
  }

  Future<void> retrieveFacialLostData() async {
    final LostDataResponse response =
        await viewModel.imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      viewModel.imageCameraFacial(response.file);
    }
  }

  /// viewmodel.index 2
  identityInfo() {
    return viewModel.needToLoad
        ? CustomLoader()
        : Center(
            child: Column(
              children: [
                headerStep2(),
                ((viewModel.viewModelVerification?.kyc?.idProof?.idProofType !=
                            "") ||
                        (viewModel.viewModelVerification?.kyc?.idProof
                                        ?.idProofFrontStatus !=
                                    "rejected" ||
                                viewModel.viewModelVerification?.kyc?.idProof
                                        ?.idProofBackStatus !=
                                    "rejected") &&
                            (viewModel.viewModelVerification?.kyc?.kycStatus ==
                                "verified"))
                    ? selectedType(context, viewModel.text)
                    : buildRadioButtonVerification(),
                buildIdFrontView(),
                buildIdBackView(),
                //  buildNext(identity,text)
              ],
            ),
          );
  }

  ///customheader
  Widget headerStep2() {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step1,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.idInfo,
          color: themeSupport().isSelectedDarkMode() ? white : textGrey,
        ),
      ],
    );
  }

  /// selected type
  Widget selectedType(BuildContext context, String variable) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: stringVariables.idType,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: variable,
              fontWeight: FontWeight.bold,
            )
          ],
        ),
      ],
    );
  }

  /// radiobutton verification
  Widget buildRadioButtonVerification() {
    securedPrint(viewModel.text);
    securedPrint(viewModel.radioId);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Radio(
                value: 0,
                groupValue: viewModel.radioId,
                onChanged: (val) async {
                  viewModel.setRadioActive(context, 0);
                  viewModel.setText(stringVariables.passport);
                },
                activeColor: themeColor,
              ),
              Expanded(
                child: CustomText(
                  text: stringVariables.passport,
                  fontsize: 11.0,
                  color: viewModel.radioId == 0 ? themeColor : textGrey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Radio(
                value: 1,
                groupValue: viewModel.radioId,
                onChanged: (val) async {
                  viewModel.setRadioActive(context, 1);
                  viewModel.setText(stringVariables.idCard);
                },
                activeColor: themeColor,
              ),
              Expanded(
                child: CustomText(
                  text: stringVariables.idCard,
                  fontsize: 11.0,
                  color: viewModel.radioId == 1 ? themeColor : textGrey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Radio(
                value: 2,
                groupValue: viewModel.radioId,
                onChanged: (val) async {
                  viewModel.setRadioActive(context, 2);
                  viewModel.setText(stringVariables.drivingLicense);
                },
                activeColor: themeColor,
              ),
              Expanded(
                child: CustomText(
                  text: stringVariables.drivingLicense,
                  fontsize: 11.0,
                  color: viewModel.radioId == 2 ? themeColor : textGrey,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  /// choose id front view
  Widget buildIdFrontView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomSizedBox(
          height: 0.03,
        ),
        CustomContainer(
          width: 1.25,
          height: MediaQuery.of(context).size.height / 50,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    align: TextAlign.start,
                    fontfamily: 'InterTight',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxlines: 1,
                    text: viewModel.imageFrontPicName == null
                        ? stringVariables.idFrontView
                        : (viewModel.imageFrontPicName!.split("/").last),
                    color: textGrey,
                    fontsize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                  child: CustomElevatedButton(
                      blurRadius: 0,
                      spreadRadius: 0,
                      text: stringVariables.upload,
                      color:
                          themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        if ('${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus}' ==
                                "verified" ||
                            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus}' ==
                                "pending") {
                        } else {
                          _showModal(viewModel.imageFront, 1);
                        }
                      },
                      radius: 25,
                      buttoncolor: themeColor,
                      width: MediaQuery.of(context).size.width / 120,
                      height: MediaQuery.of(context).size.height / 43,
                      isBorderedButton: false,
                      maxLines: 1,
                      icons: false,
                      multiClick: true,
                      icon: null),
                )
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            viewModel.imageFrontPic != null
                ? (!kIsWeb && defaultTargetPlatform == TargetPlatform.android
                    ? FutureBuilder<void>(
                        future: retrieveFrontLostData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return CustomContainer(
                                width: 1.75,
                                height: 5,
                                child: Center(
                                  child: CustomText(
                                    text:
                                        '', //You have not yet picked an image.
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                              return loadFadeImage(
                                '${viewModel.img641}',
                              );
                            case ConnectionState.active:
                              if (snapshot.hasError) {
                                return CustomContainer(
                                  width: 1.75,
                                  height: 5,
                                  child: Center(
                                    child: CustomText(
                                      text:
                                          '', // Pick image/video error: ${snapshot.error}
                                    ),
                                  ),
                                );
                              } else {
                                return CustomContainer(
                                  width: 1.75,
                                  height: 5,
                                  child: Center(
                                    child: CustomText(
                                        text:
                                            "" //'You have not yet picked an image.'
                                        ),
                                  ),
                                );
                              }
                          }
                        },
                      )
                    : loadFadeImage(
                        '${viewModel.img641}',
                      ))
                : "${viewModel.viewModelVerification?.kyc?.idProof?.idProofFront}" !=
                        ""
                    ? CustomNetworkImage(
                        image:
                            "${viewModel.viewModelVerification?.kyc?.idProof?.idProofFront}",
                        height: 90,
                        width: 90,
                      )
                    : SvgPicture.asset(
                        identityunverifyImage,
                        height: 90,
                        width: 90,
                      ),
            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus?.length}' !=
                    0
                ? Row(
                    children: [
                      SvgPicture.asset(
                        '${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus}' ==
                                "verified"
                            ? doneVerify
                            : rejectedIcon,
                        height: 14,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomText(
                        text:
                            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus ?? stringVariables.rejected}',
                        fontsize: 14,
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ],
    );
  }

  ///choose id back view
  Widget buildIdBackView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          width: 1.25,
          height: MediaQuery.of(context).size.height / 50,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    align: TextAlign.start,
                    fontfamily: 'InterTight',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    color: textGrey,
                    maxlines: 1,
                    text: viewModel.imageBackPicName == null
                        ? stringVariables.idBackView
                        : (viewModel.imageBackPicName!.split("/").last),
                    fontsize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                  child: CustomElevatedButton(
                      blurRadius: 0,
                      spreadRadius: 0,
                      text: stringVariables.upload,
                      color:
                          themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        if ('${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus}' ==
                                "verified" ||
                            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus}' ==
                                "pending") {
                        } else {
                          _showModal(viewModel.imageBack, 2);
                        }
                      },
                      radius: 25,
                      buttoncolor: themeColor,
                      width: MediaQuery.of(context).size.width / 120,
                      height: MediaQuery.of(context).size.height / 43,
                      isBorderedButton: false,
                      maxLines: 1,
                      icons: false,
                      multiClick: true,
                      icon: null),
                )
              ],
            ),
          ),
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            viewModel.imageBackPic != null
                ? (!kIsWeb && defaultTargetPlatform == TargetPlatform.android
                    ? FutureBuilder<void>(
                        future: retrieveBackLostData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return CustomContainer(
                                width: 1.75,
                                height: 5,
                                child: Center(
                                  child: CustomText(
                                    text:
                                        '', //You have not yet picked an image.
                                  ),
                                ),
                              );
                            case ConnectionState.done:
                              return loadFadeImage(
                                '${viewModel.img642}',
                              );
                            case ConnectionState.active:
                              if (snapshot.hasError) {
                                return CustomContainer(
                                  width: 1.75,
                                  height: 5,
                                  child: Center(
                                    child: CustomText(
                                      text:
                                          '', //Pick image/video error: ${snapshot.error}
                                    ),
                                  ),
                                );
                              } else {
                                return CustomContainer(
                                  width: 1.75,
                                  height: 5,
                                  child: Center(
                                    child: CustomText(
                                      text:
                                          '', //You have not yet picked an image.
                                    ),
                                  ),
                                );
                              }
                          }
                        },
                      )
                    : loadFadeImage(
                        '${viewModel.img642}',
                      ))
                : "${viewModel.viewModelVerification?.kyc?.idProof?.idProofBack}" !=
                        ""
                    ? CustomNetworkImage(
                        image:
                            "${viewModel.viewModelVerification?.kyc?.idProof?.idProofBack}",
                        height: 90,
                        width: 90,
                      )
                    : SvgPicture.asset(
                        identityunverifyImage,
                        height: 90,
                        width: 90,
                      ),
            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus?.length}' !=
                    0
                ? Row(
                    children: [
                      SvgPicture.asset(
                        '${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus}' ==
                                "verified"
                            ? doneVerify
                            : rejectedIcon,
                        height: 14,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomText(
                        text:
                            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus ?? stringVariables.rejected}',
                        fontsize: 14,
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Future<void> retrieveFrontLostData() async {
    final LostDataResponse response =
        await viewModel.imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      viewModel.imageCameraFront(response.file);
    }
  }

  Future<void> retrieveBackLostData() async {
    final LostDataResponse response =
        await viewModel.imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      viewModel.imageCameraBack(response.file);
    }
  }

  ///viewmodel.index 4
  idStatus() {
    return viewModel.needToLoad
        ? CustomLoader()
        : Column(
            children: [
              headerStep4(),
              buildVerification(),
              // buildDone()
            ],
          );
  }

  dynamic _showModal(
      Future Function(bool isCamera) imageUpload, int type) async {
    final result = await Navigator.of(context)
        .push(GalleryModal(imageUpload, type, context));
  }

  ///customheader
  Widget headerStep4() {
    return Column(
      children: [
        CustomText(
          text: stringVariables.step4,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.idStatus,
          color: themeSupport().isSelectedDarkMode() ? white : textGrey,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  /// verification
  Widget buildVerification() {
    return CustomContainer(
      height: 5.5,
      width: 1.3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.idProofFront,
                fontWeight: FontWeight.bold,
                fontsize: 15,
              ),
              CustomSizedBox(
                height: 0.03,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    '${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus}' ==
                            "verified"
                        ? doneVerify
                        : rejectedIcon,
                    height: 14,
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomText(
                    text:
                        '${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus ?? stringVariables.rejected}',
                    fontWeight: FontWeight.bold,
                    fontsize: 14,
                  ),
                ],
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.idProofBack,
                fontWeight: FontWeight.bold,
                fontsize: 15,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    '${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus}' ==
                            "verified"
                        ? doneVerify
                        : rejectedIcon,
                    height: 14,
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomText(
                    text:
                        '${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus ?? stringVariables.rejected}',
                    fontWeight: FontWeight.bold,
                    fontsize: 14,
                  ),
                ],
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: stringVariables.facialProof,
                fontWeight: FontWeight.bold,
                fontsize: 15,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    '${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus}' ==
                            "verified"
                        ? doneVerify
                        : rejectedIcon,
                    height: 14,
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  CustomText(
                    text:
                        '${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus ?? stringVariables.rejected}',
                    fontWeight: FontWeight.bold,
                    fontsize: 14,
                  ),
                ],
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.03,
          ),
        ],
      ),
    );
  }

  getUsertypedDetails(
      BuildContext context, IdentityVerificationCommonViewModel viewModel) {
    if (firstName.text != "" &&
        lastName.text != "" &&
        dob.text != "" &&
        address.text != "" &&
        country.text != "" &&
        state.text != "" &&
        city.text != "" &&
        postalCode.text != ""!) {
      viewModel.setButtonLoading(true);
      viewModel.UpdatePersonalInfo(
          firstName.text,
          middleName.text,
          lastName.text,
          dob.text,
          address.text,
          country.text,
          state.text,
          city.text,
          postalCode.text,
          context);
    } else {
      viewModel.index = 2;
      viewModel.setActive(context, 2);
    }
  }

  updateImage(
    BuildContext context,
    String text,
  ) {
    if (viewModel.imageFrontPic != null &&
        viewModel.imageBackPic != null &&
        text != "" &&
        (viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus !=
                "verified" &&
            viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus !=
                "verified")) {
      viewModel.setButtonLoading(true);
      viewModel.UpdateIdInfo(context, viewModel.img641, viewModel.img642, text);
    } else {
      if (viewModel.idVerificationStatus) {
        viewModel.index = 1;
        viewModel.setActive(context, 1);
        viewModel.getPersonalDetails();
      } else {
        if (viewModel.imageFrontPic == null ||
            viewModel.imageBackPic == null ||
            text == "") {
          customSnackBar.showSnakbar(context, stringVariables.fileIsnotSelected,
              SnackbarType.negative);
        }
      }
    }
  }

  updateFacialImage() {
    if (viewModel.imageFacialPic != null &&
        !viewModel.facialVerificationStatus) {
      viewModel.setButtonLoading(true);
      viewModel.UpdateFacialInfo(
        context,
        viewModel.img643,
      );
    } else {
      if (viewModel.facialVerificationStatus) {
        viewModel.index = 3;
        viewModel.setActive(context, 3);
      } else {
        viewModel.imageFacialPic == null
            ? customSnackBar.showSnakbar(context,
                stringVariables.fileIsnotSelected, SnackbarType.negative)
            : () {};
      }
    }
  }

  naviagtePage(
      BuildContext context, IdentityVerificationCommonViewModel viewModel) {
    viewModel.index = 0;
    viewModel.setActive(context, 0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<IdentityVerificationCommonViewModel>();
    return Provider<IdentityVerificationCommonViewModel>(
      create: (context) => viewModel,
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
                backButton(context),
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    fontfamily: 'InterTight',
                    fontsize: 18,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.identityVerification,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : SingleChildScrollView(
                child: CustomCard(
                  outerPadding: 15,
                  edgeInsets: 8,
                  radius: 25,
                  elevation: 0,
                  child: Column(
                    children: [
                      CustomTimeLine(
                        identityVerificationCommonViewModel: viewModel,
                        label2: '2',
                        text4: stringVariables.idStatus,
                        label1: '1',
                        text3: stringVariables.facialInfo,
                        text2: stringVariables.personalInfo,
                        label3: '3',
                        text1: stringVariables.idInfo,
                        label4: '4',
                        button1Color:
                            viewModel.index == 0 ? themeColor : textGrey,
                        button2Color:
                            viewModel.index == 1 ? themeColor : textGrey,
                        button3Color:
                            viewModel.index == 2 ? themeColor : textGrey,
                        button4Color:
                            viewModel.index == 3 ? themeColor : textGrey,
                        text1Color:
                            viewModel.index == 0 ? themeColor : textGrey,
                        text2Color:
                            viewModel.index == 1 ? themeColor : textGrey,
                        text3Color:
                            viewModel.index == 2 ? themeColor : textGrey,
                        text4Color:
                            viewModel.index == 3 ? themeColor : textGrey,
                        label1Color: viewModel.index == 0 ? black : white,
                        label2Color: viewModel.index == 1 ? black : white,
                        label3Color: viewModel.index == 2 ? black : white,
                        label4Color: viewModel.index == 3 ? black : white,
                        onTapFirstIndex: () {
                          viewModel.setActive(context, viewModel.index = 0);
                        },
                        onTapSecondIndex: () {
                          if (viewModel.idVerificationStatus) {
                            viewModel.setActive(context, viewModel.index = 1);
                          } else {
                            customSnackBar.showSnakbar(
                                context,
                                stringVariables.step1IsIncomplete,
                                SnackbarType.negative);
                          }
                        },
                        onTapThirdIndex: () {
                          if (viewModel.idVerificationStatus) {
                            if (viewModel.personalVerificationStatus) {
                              viewModel.setActive(context, viewModel.index = 2);
                            } else {
                              customSnackBar.showSnakbar(
                                  context,
                                  stringVariables.step2IsIncomplete,
                                  SnackbarType.negative);
                            }
                          } else {
                            customSnackBar.showSnakbar(
                                context,
                                stringVariables.step1IsIncomplete,
                                SnackbarType.negative);
                          }
                        },
                        onTapFourthIndex: () {
                          if (viewModel.idVerificationStatus) {
                            if (viewModel.personalVerificationStatus) {
                              if (viewModel.facialVerificationStatus) {
                                viewModel.setActive(
                                    context, viewModel.index = 3);
                              } else {
                                customSnackBar.showSnakbar(
                                    context,
                                    stringVariables.step3IsIncomplete,
                                    SnackbarType.negative);
                              }
                            } else {
                              customSnackBar.showSnakbar(
                                  context,
                                  stringVariables.step2IsIncomplete,
                                  SnackbarType.negative);
                            }
                          } else {
                            customSnackBar.showSnakbar(
                                context,
                                stringVariables.step1IsIncomplete,
                                SnackbarType.negative);
                          }
                        },
                        child: viewModel.index == 0
                            ? identityInfo()
                            : viewModel.index == 2
                                ? facialInfo()
                                : viewModel.index == 1
                                    ? personalInfo()
                                    : idStatus(),
                        text: viewModel.index == 3
                            ? stringVariables.done.toUpperCase()
                            : stringVariables.next,
                        onTap: () async {
                          if (viewModel.viewModelVerification?.kyc?.kycStatus
                                  ?.toLowerCase() ==
                              'verified') {
                            if (viewModel.index == 0) {
                              viewModel.index = 1;
                              viewModel.setActive(context, 1);
                            } else if (viewModel.index == 1) {
                              viewModel.index = 2;
                              viewModel.setActive(context, 2);
                            } else if (viewModel.index == 2) {
                              viewModel.index = 3;
                              viewModel.setActive(context, 3);
                            } else {
                              viewModel.index = 0;
                              viewModel.setActive(context, 0);
                              Navigator.pop(context);
                            }
                          } else {
                            if (viewModel.index == 1) {
                              if (formKey.currentState?.validate() ?? false) {
                                if (firstName.text.isNotEmpty &&
                                    lastName.text.isNotEmpty &&
                                    dob.text.isNotEmpty &&
                                    address.text.isNotEmpty &&
                                    country.text.isNotEmpty &&
                                    state.text.isNotEmpty &&
                                    city.text.isNotEmpty &&
                                    postalCode.text.isNotEmpty) {
                                  getUsertypedDetails(context, viewModel);
                                  formKey.currentState!.save();
                                }
                              }
                            } else if (viewModel.index == 0) {
                              updateImage(
                                context,
                                viewModel.text,
                              );
                            } else if (viewModel.index == 2) {
                              updateFacialImage();
                            } else if (viewModel.index == 3) {
                              naviagtePage(context, viewModel);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget backButton(BuildContext context, [VoidCallback? onPressed]) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed ??
            () {
              Navigator.pop(context);
            },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SvgPicture.asset(
            backArrow,
          ),
        ),
      ),
    );
  }
}
