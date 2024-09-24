import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNetworkImage.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomTimeLine.dart';

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
  int id = 0;

  // int viewmodel.index = 0;
  final TextEditingController lastName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController state = TextEditingController();
  bool stateFlag = false;
  String text = '';
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
    viewModel = Provider.of<IdentityVerificationCommonViewModel>(context,listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dob.clear();
      viewModel.setLoading(true);
    });
    viewModel.getIdVerification();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setActive(context, viewModel.index = 0);
      text = stringVariables.passport;
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
          text: stringVariables.step1,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.basicInfo,
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        AbsorbPointer(
          absorbing: viewModel.personalVerificationStatus,
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              text: stringVariables.hintFirstname,
              isReadOnly: viewModel.personalVerificationStatus,
              //firstName.text.isNotEmpty ? true : false,
              controller: firstName
                ..text =
                    '${viewModel.viewModelVerification?.kyc?.idProof?.firstName ?? firstName.text}',
              autovalid: AutovalidateMode.onUserInteraction,
              validator: (input) => firstName.text.isEmpty
                  ? 'First Name is required'
                  : firstName.text.length > 2
                  ? null
                  : "Must contain 3 characters",
              onChanged: (value) {
                viewModel.viewModelVerification?.kyc?.idProof?.firstName =
                    firstName.text;
              },
              onSaved: (input) {
                firstName.text = input!;
              }),
        ),
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        AbsorbPointer(
          absorbing: viewModel.personalVerificationStatus,
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              text: stringVariables.hintMiddlename,
              isReadOnly: viewModel.personalVerificationStatus,
              //middleName.text.isNotEmpty ? true : false,
              controller: middleName
                ..text =
                    '${viewModel.viewModelVerification?.kyc?.idProof?.middleName ?? middleName.text}',
              autovalid: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                viewModel.viewModelVerification?.kyc?.idProof?.middleName =
                    middleName.text;
              },
              onSaved: (input) {
                middleName.text = input!;
              }),
        ),
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        AbsorbPointer(
          absorbing: viewModel.personalVerificationStatus,
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              text: stringVariables.hintLastname,
              isReadOnly: viewModel.personalVerificationStatus,
              //lastName.text.isNotEmpty ? true : false,
              controller: lastName
                ..text =
                    '${viewModel.viewModelVerification?.kyc?.idProof?.lastName ?? lastName.text}',
              autovalid: AutovalidateMode.onUserInteraction,
              validator: (input) => lastName.text.isEmpty
                  ? 'Last Name is required'
                  : lastName.text.length > 0
                  ? null
                  : "Must contain 1 characters",
              onChanged: (value) {
                viewModel.viewModelVerification?.kyc?.idProof?.lastName =
                    lastName.text;
              },
              onSaved: (input) {
                lastName.text = input!;
              }),
        ),
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
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor,
                onPrimary:
                checkBrightness.value == Brightness.light ? white : black,
                onSurface:
                checkBrightness.value == Brightness.light ? black : white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeColor,
                ),
              ),
              dialogBackgroundColor:
              checkBrightness.value == Brightness.light ? white : card_dark,
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
            fontfamily: 'GoogleSans',
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
            if (!viewModel.personalVerificationStatus) {
              onDOBClicked();
            }
          },
          child: AbsorbPointer(
            // absorbing:viewModel.personalVerificationStatus ,
            child: CustomTextFormField(
                size: 30,
                isContentPadding: false,
                text: stringVariables.dob,
                keyboardType: TextInputType.datetime,
                suffixIcon: Icon(Icons.date_range, color: iconColor),
                isReadOnly: viewModel.personalVerificationStatus,
                //dob.text.isNotEmpty ? true : false,

                controller: dob
                  ..text =
                  ('${(viewModel.viewModelVerification?.kyc?.idProof?.dob != null && viewModel.viewModelVerification?.kyc?.idProof?.dob != "") ? viewModel.viewModelVerification?.kyc?.idProof?.dob.toString().substring(0, 10) : dob.text}'),
                autovalid: AutovalidateMode.onUserInteraction,
                validator: (input) =>
                dob.text.isEmpty ? 'Dob is required' : null,
                onSaved: (input) {
                  dob.text = input!;
                }),
          ),
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
            text: stringVariables.address,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        AbsorbPointer(
          absorbing: viewModel.personalVerificationStatus,
          child: CustomTextFormField(
              isContentPadding: true,
              size: 30,
              text: stringVariables.hintAddress,
              maxLines: 4,
              minLines: 4,
              controller: address
                ..text =
                    '${viewModel.viewModelVerification?.kyc?.idProof?.address1 ?? address.text}',
              isReadOnly: viewModel.personalVerificationStatus,
              //address.text.isNotEmpty ? true : false,
              autovalid: AutovalidateMode.onUserInteraction,
              validator: (input) =>
              address.text.isEmpty ? 'Address is required' : null,
              onChanged: (value) {
                viewModel.viewModelVerification?.kyc?.idProof?.address1 =
                    address.text;
              },
              onSaved: (input) {
                address.text = input!;
              }),
        ),
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
            fontfamily: 'GoogleSans',
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
            dynamic state = _countryKey.currentState;
            (viewModel.personalVerificationStatus)
                ? (() {})
                : state.showButtonMenu();
          },
          child: AbsorbPointer(
            child: CustomTextFormField(
                size: 30,
                isContentPadding: false,
                text: stringVariables.select,
                suffixIcon: PopupMenuButton(
                  key: _countryKey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  offset:
                  Offset(-(MediaQuery.of(context).size.width / 1.465), 0),
                  constraints: new BoxConstraints(
                    minHeight: (MediaQuery.of(context).size.height / 12),
                    minWidth: (MediaQuery.of(context).size.width / 1.25),
                    maxHeight: (MediaQuery.of(context).size.height / 2),
                    maxWidth: (MediaQuery.of(context).size.width / 1.25),
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    country.text = value as String;
                    viewModel.setCountryName(value);
                    // viewModel.setCountryCode(viewModel.countriesList[
                    //     viewModel.countriesNameList.indexOf(value)]['iso2']);
                    // viewModel.getChoosedResult(context, 1);
                  },
                  color:
                  checkBrightness.value == Brightness.dark ? black : white,
                  itemBuilder: (
                      BuildContext context,
                      ) {
                    return viewModel.countriesNameList
                        .map<PopupMenuItem<String>>((String? value) {
                      return PopupMenuItem(
                          onTap: () {
                            countryFlag = true;
                            stateFlag = false;
                            cityFlag = false;
                          },
                          child: CustomText(text: value.toString()),
                          value: value);
                    }).toList();
                  },
                ),
                isReadOnly: viewModel.personalVerificationStatus,
                //country.text.isNotEmpty ? true : false,
                controller: country
                  ..text = countryFlag
                      ? viewModel.countryName!
                      : '${viewModel.viewModelVerification?.kyc?.idProof?.country ?? country.text}',
                autovalid: AutovalidateMode.onUserInteraction,
                validator: (input) =>
                country.text.isEmpty ? 'Country is required' : null,
                onSaved: (input) {
                  country.text = input!;
                }),
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        GestureDetector(
          onTap: () {
            dynamic state = _stateKey.currentState;
            (viewModel.personalVerificationStatus)
                ? (() {})
                : state.showButtonMenu();
          },
          child: AbsorbPointer(
            child: CustomTextFormField(
                size: 30,
                isContentPadding: false,
                text: stringVariables.select,
                suffixIcon: PopupMenuButton(
                  key: _stateKey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  offset:
                  Offset(-(MediaQuery.of(context).size.width / 1.465), 0),
                  constraints: new BoxConstraints(
                    minHeight: (MediaQuery.of(context).size.height / 12),
                    minWidth: (MediaQuery.of(context).size.width / 1.25),
                    maxHeight: (MediaQuery.of(context).size.height / 2),
                    maxWidth: (MediaQuery.of(context).size.width / 1.25),
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    state.text = value as String;
                    viewModel.setStateName(value);
                    // viewModel.setStateCode(viewModel
                    //         .statesList[viewModel.statesNameList.indexOf(value)]
                    //     ['iso2']);
                    // viewModel.getChoosedResult(context, 2);
                  },
                  color:
                  checkBrightness.value == Brightness.dark ? black : white,
                  itemBuilder: (
                      BuildContext context,
                      ) {
                    return viewModel.statesNameList
                        .map<PopupMenuItem<String>>((String? value) {
                      return PopupMenuItem(
                          onTap: () {
                            stateFlag = true;
                            cityFlag = false;
                          },
                          child: CustomText(text: value.toString()),
                          value: value);
                    }).toList();
                  },
                ),
                isReadOnly: viewModel.personalVerificationStatus,
                //state.text.isNotEmpty ? true : false,
                controller: state
                  ..text = stateFlag
                      ? viewModel.stateName!
                      : countryFlag
                      ? ""
                      : '${viewModel.viewModelVerification?.kyc?.idProof?.state ?? state.text}',
                autovalid: AutovalidateMode.onUserInteraction,
                validator: (input) =>
                state.text.isEmpty ? 'State is required' : null,
                onSaved: (input) {
                  state.text = input!;
                }),
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        AbsorbPointer(
          absorbing: viewModel.personalVerificationStatus,
          child: CustomTextFormField(
              onChanged: (value) {
                //viewModel.setCityName(value);
                cityFlag = true;
                cityName = value;
              },
              size: 30,
              isContentPadding: false,
              text: stringVariables.select,
              controller: city
                ..text = cityFlag
                    ? cityName
                    : countryFlag
                    ? ""
                    : '${viewModel.viewModelVerification?.kyc?.idProof?.city ?? city.text}',
              autovalid: AutovalidateMode.onUserInteraction,
              isReadOnly: viewModel.personalVerificationStatus,
              validator: (input) =>
              city.text.isEmpty ? 'City is required' : null,
              onSaved: (input) {
                city.text = input!;
              }),
        ),
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
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.bold,
            fontsize: 15,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        AbsorbPointer(
          absorbing: viewModel.personalVerificationStatus,
          child: CustomTextFormField(
              size: 30,
              isContentPadding: false,
              text: stringVariables.hintPostal,
              isReadOnly: viewModel.personalVerificationStatus,
              //postalCode.text.isNotEmpty ? true : false,
              controller: postalCode
                ..text =
                    '${viewModel.viewModelVerification?.kyc?.idProof?.zip ?? postalCode.text}',
              autovalid: AutovalidateMode.onUserInteraction,
              validator: (input) =>
              postalCode.text.isEmpty ? 'PostalCode is required' : null,
              onChanged: (value) {
                viewModel.viewModelVerification?.kyc?.idProof?.zip =
                    postalCode.text;
              },
              onSaved: (input) {
                postalCode.text = input!;
              }),
        ),
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
        themeSupport().isSelectedDarkMode() ? splash :splashDark
    );
    return CustomContainer(
      width: 1.75,
      height: 5,
      child: FadeInImage(
        fit: BoxFit.fitHeight,
        placeholder: AssetImage(themeSupport().isSelectedDarkMode() ? splash :splashDark),
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
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    text: viewModel.imageFacialPicName ??
                        stringVariables.idFrontView,
                    color: textGrey,
                    fontsize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, top: 4, bottom: 4),
                  child: CustomElevatedButton(
                      blurRadius: 0,
                      spreadRadius: 0,
                      text: stringVariables.chooseFile,
                      color:
                      themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        if ('${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus}' ==
                            "verified" ||
                            '${viewModel.viewModelVerification?.kyc?.facialProof?.facialProofStatus}' ==
                                "pending") {
                        } else {
                          viewModel.imageFacial();
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
          height: 0.02,
        ),
        viewModel.imageFacialPic != null
            ? loadFadeImage(
          '${viewModel.img643}',
        )
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

  /// viewmodel.index 2
  identityInfo() {
    String idProofType =
        '${viewModel.viewModelVerification?.kyc?.idProof?.idProofType}';
    if (idProofType.isNotEmpty) text = idProofType;
    return viewModel.needToLoad
        ? CustomLoader()
        : Center(
      child: Column(
        children: [
          headerStep2(),
          (clicked == true ||
              viewModel.viewModelVerification?.kyc?.idProof
                  ?.idProofType !=
                  "")
              ? selectedType(
              context,
              idProofType == ""
                  ? '${text}'
                  : '${viewModel.viewModelVerification?.kyc?.idProof?.idProofType}')
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
          text: stringVariables.step2,
          fontWeight: FontWeight.bold,
          fontsize: 20,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          text: stringVariables.identityInfo,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Radio(
                value: 0,
                groupValue: id,
                onChanged: (val) async {
                  viewModel.setActive(context, id = 0);
                  // clicked = true;
                  text = stringVariables.passport;
                },
                activeColor: themeColor,
              ),
              Expanded(
                child: CustomText(
                  text: stringVariables.passport,
                  fontsize: 11.0,
                  color: id == 0 ? themeColor : textGrey,
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
                groupValue: id,
                onChanged: (val) async {
                  viewModel.setActive(context, id = 1);
                  // clicked = true;
                  text = stringVariables.idCard;
                },
                activeColor: themeColor,
              ),
              Expanded(
                child: CustomText(
                  text: stringVariables.idCard,
                  fontsize: 11.0,
                  color: id == 1 ? themeColor : textGrey,
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
                groupValue: id,
                onChanged: (val) async {
                  viewModel.setActive(context, id = 2);
                  //  clicked = true;
                  text = stringVariables.drivingLicense;
                },
                activeColor: themeColor,
              ),
              Expanded(
                child: CustomText(
                  text: stringVariables.drivingLicense,
                  fontsize: 11.0,
                  color: id == 2 ? themeColor : textGrey,
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
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxlines: 1,
                    text:
                    '${viewModel.imageFrontPicName ?? stringVariables.idFrontView}',
                    color: textGrey,
                    fontsize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                  child: CustomElevatedButton(
                      blurRadius: 0,
                      spreadRadius: 0,
                      text: stringVariables.chooseFile,
                      color:
                      themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        if ('${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus}' ==
                            "verified" ||
                            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofFrontStatus}' ==
                                "pending") {
                        } else {
                          viewModel.imageFront();
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
                ? loadFadeImage(
              '${viewModel.img641}',
            )
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
                    fontfamily: 'GoogleSans',
                    softwrap: true,
                    overflow: TextOverflow.ellipsis,
                    color: textGrey,
                    maxlines: 1,
                    text: viewModel.imageBackPicName ??
                        stringVariables.idBackView,
                    fontsize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                  child: CustomElevatedButton(
                      blurRadius: 0,
                      spreadRadius: 0,
                      text: stringVariables.chooseFile,
                      color:
                      themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        if ('${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus}' ==
                            "verified" ||
                            '${viewModel.viewModelVerification?.kyc?.idProof?.idProofBackStatus}' ==
                                "pending") {
                        } else {
                          viewModel.imageBack();
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
                ? loadFadeImage(
              '${viewModel.img642}',
            )
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
        postalCode.text != "" &&
        viewModel.personalVerificationStatus == false) {
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
      viewModel.index = 1;
      viewModel.setActive(context, 1);
    }
  }

  updateImage(
      BuildContext context,
      String text,
      ) {
    if (viewModel.imageFrontPic != null &&
        viewModel.imageBackPic != null &&
        text != "" &&
        !viewModel.idVerificationStatus) {
      viewModel.setButtonLoading(true);
      viewModel.UpdateIdInfo(context, viewModel.img641, viewModel.img642, text);
    } else {
      if (viewModel.idVerificationStatus) {
        viewModel.index = 2;
        viewModel.setActive(context, 2);
      } else {
        if (viewModel.imageFrontPic == null ||
            viewModel.imageBackPic == null ||
            text == "") {
          customSnackBar.showSnakbar(
              context, "Please Fill All Fields", SnackbarType.negative);
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
            ? customSnackBar.showSnakbar(
            context, "Please Fill All Fields", SnackbarType.negative)
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
                    fontfamily: 'GoogleSans',
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
        child:viewModel.needToLoad ? Center(child: CustomLoader()) : SingleChildScrollView(
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
                  text2: stringVariables.idInfo,
                  label3: '3',
                  text1: stringVariables.personalInfo,
                  label4: '4',
                  button1Color: viewModel.index == 0 ? themeColor : textGrey,
                  button2Color: viewModel.index == 1 ? themeColor : textGrey,
                  button3Color: viewModel.index == 2 ? themeColor : textGrey,
                  button4Color: viewModel.index == 3 ? themeColor : textGrey,
                  text1Color: viewModel.index == 0 ? themeColor : textGrey,
                  text2Color: viewModel.index == 1 ? themeColor : textGrey,
                  text3Color: viewModel.index == 2 ? themeColor : textGrey,
                  text4Color: viewModel.index == 3 ? themeColor : textGrey,
                  label1Color: viewModel.index == 0 ? black : white,
                  label2Color: viewModel.index == 1 ? black : white,
                  label3Color: viewModel.index == 2 ? black : white,
                  label4Color: viewModel.index == 3 ? black : white,
                  onTapFirstIndex: () {
                    viewModel.setActive(context, viewModel.index = 0);
                  },
                  onTapSecondIndex: () {
                    if (viewModel.personalVerificationStatus) {
                      viewModel.setActive(context, viewModel.index = 1);
                    }
                  },
                  onTapThirdIndex: () {
                    if (viewModel.personalVerificationStatus &&
                        viewModel.idVerificationStatus) {
                      viewModel.setActive(context, viewModel.index = 2);
                    }
                  },
                  onTapFourthIndex: () {
                    if (viewModel.personalVerificationStatus &&
                        viewModel.idVerificationStatus &&
                        viewModel.facialVerificationStatus) {
                      viewModel.setActive(context, viewModel.index = 3);
                    }
                  },
                  child: viewModel.index == 0
                      ? personalInfo()
                      : viewModel.index == 2
                      ? facialInfo()
                      : viewModel.index == 1
                      ? identityInfo()
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
                      if (viewModel.index == 0) {
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
                      } else if (viewModel.index == 1) {
                        updateImage(
                          context,
                          text,
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
