import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/PhoneNumber/View/phone_dialog.dart';
import 'package:zodeakx_mobile/Common/UpdatePhoneNumber/ViewModel/UpdatePhoneNumberViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appEnums.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/ZodeakX/Setting/Model/GetUserByJwtModel.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/Security/ViewModel/SecurityViewModel.dart';

class PhoneNumberView extends StatefulWidget {
  const PhoneNumberView({
    Key? key,
  }) : super(key: key);

  @override
  State<PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView> {
  late SecurityViewModel viewModel;
  late UpdatePhoneNumberViewModel updatePhoneNumberViewModel;
  late SecurityViewModel securityViewModel;
  final countryPicker = const FlCountryCodePicker();
  late CountryCode countryCode;

  @override
  void initState() {
    viewModel = Provider.of<SecurityViewModel>(context, listen: false);
    securityViewModel = Provider.of<SecurityViewModel>(context, listen: false);
    updatePhoneNumberViewModel =
        Provider.of<UpdatePhoneNumberViewModel>(context, listen: false);
    securityViewModel.getIdVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    viewModel = context.watch<SecurityViewModel>();
    return buildPhoneNumberView(context, size);
  }

  Widget buildPhoneNumberView(BuildContext context, Size size) {
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

  _showAlertModel(String title, String content, VoidCallback onPressed) async {
    final result = await Navigator.of(context).push(PhoneNumberDialog(
        context, title, content, stringVariables.continues, true));
    if (result) {
      onPressed();
    }
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
    MobileNumber mobileNumber =
        viewModel.viewModelVerification?.tfaAuthentication?.mobileNumber ??
            MobileNumber();
    bool noFlag = mobileNumber.status == stringVariables.verified.toLowerCase();
    String mobileNo = mobileNumber.phoneNumber ?? "";
    String mobileCode = mobileNumber.phoneCode ?? "";
    String mobileNoObsecure = mobileNo.isEmpty
        ? ""
        : "${mobileNo.substring(0, 2)}******${mobileNo.substring(mobileNo.length - 4, mobileNo.length)}";
    String date = mobileNumber.updatedAt != null
        ? convertToIST(mobileNumber.updatedAt.toString())
        : "";
    securedPrint("mobileCode${mobileCode}");
    countryCode = mobileCode == ""
        ? CountryCode(name: '', code: "", dialCode: "")
        : countryPicker.countryCodes
            .where((element) => element.dialCode == mobileCode)
            .first;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment:
              noFlag ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSizedBox(
                  width: 0.01,
                ),
                CustomText(
                  maxlines: 2,
                  fontfamily: 'InterTight',
                  fontsize: 23,
                  fontWeight: FontWeight.bold,
                  text: stringVariables.phoneNumberVerification,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            ),
            noFlag
                ? Column(
                    children: [
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomSizedBox(
                                width: 0.01,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  Row(
                                    children: [
                                      CustomCircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                            child: Image.asset(
                                          countryCode.flagUri,
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.fill,
                                          package: countryCode.flagImagePackage,
                                        )),
                                      ),
                                      CustomSizedBox(
                                        width: 0.02,
                                      ),
                                      CustomText(
                                        fontfamily: 'InterTight',
                                        text: "$mobileCode $mobileNoObsecure",
                                      ),
                                    ],
                                  ),
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  CustomText(
                                    fontfamily: 'InterTight',
                                    text: "${stringVariables.added}: $date",
                                    color: textGrey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showAlertModel(
                                      stringVariables.changePhoneNoQuestion,
                                      stringVariables.changePhoneNoContent,
                                      onEditButtonPressed);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: SvgPicture.asset(
                                  p2pPaymentEdit,
                                  height: 17.5,
                                ),
                              ),
                              CustomSizedBox(
                                width: 0.025,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showAlertModel(
                                      stringVariables.removePhoneNoQuestion,
                                      stringVariables.removePhoneNoContent,
                                      onDeleteButtonPressed);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: SvgPicture.asset(
                                  p2pPaymentDelete,
                                  color: red,
                                  height: 25,
                                ),
                              ),
                              CustomSizedBox(
                                width: 0.02,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Image.asset(phoneVerification, height: 150),
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      CustomText(
                        fontfamily: 'InterTight',
                        text: stringVariables.phoneNumberContent,
                      ),
                    ],
                  ),
            if (!noFlag)
              Column(
                children: [
                  CustomElevatedButton(
                      text: stringVariables.addPhoneNumber,
                      multiClick: true,
                      color:
                          themeSupport().isSelectedDarkMode() ? black : white,
                      press: () {
                        moveToUpdatePhoneNumber(context);
                      },
                      radius: 25,
                      buttoncolor: themeColor,
                      width: 0.0,
                      height: MediaQuery.of(context).size.height / 50,
                      isBorderedButton: false,
                      maxLines: 1,
                      icons: false,
                      icon: null),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  onEditButtonPressed() {
    moveToUpdatePhoneNumber(context, false);
  }

  onDeleteButtonPressed() {
    moveToVerifyCode(
        context,
        AuthenticationVerificationType.deletePhoneNumber,
        securityViewModel.viewModelVerification?.tfaStatus,
        securityViewModel
            .viewModelVerification?.tfaAuthentication?.mobileNumber?.status,
        securityViewModel
            .viewModelVerification?.tfaAuthentication?.mobileNumber?.phoneCode,
        securityViewModel.viewModelVerification?.tfaAuthentication?.mobileNumber
            ?.phoneNumber);
  }
}
