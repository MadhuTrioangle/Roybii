import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  final TextEditingController address = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return buildDeleteAccountView(context, size);
  }

  Widget buildDeleteAccountView(BuildContext context, Size size) {
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
                    text: stringVariables.deleteAccount,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: CustomContainer(
          width: 1,
          height: 1,
          child: SingleChildScrollView(child: buildDetailsCard(size)),
        ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDeleteAccount(),
        ],
      ),
    );
  }

  Widget buildBottomView() {
    return Column(
      children: [
        CustomElevatedButton(
          buttoncolor: themeColor,
          color: black,
          press: () async {
            if (address.text.isEmpty) {
              customSnackBar.showSnakbar(context,
                  stringVariables.enterSomething, SnackbarType.negative);
            } else {
              await launchUrl(Uri.parse(
                  "mailto:${constant.contactMail.value}?subject=Delete '${constant.appName} Account&body=${address.text}"));
            }
          },
          width: 1.5,
          isBorderedButton: true,
          maxLines: 1,
          icon: null,
          text: stringVariables.contactCustomerSupport,
          radius: 25,
          height: MediaQuery.of(context).size.height / 45,
          icons: false,
          blurRadius: 0,
          spreadRadius: 0,
          offset: Offset(0, 0),
          multiClick: true,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildDeleteAccount() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 22, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: stringVariables.pleaseConfirm,
            color: themeSupport().isSelectedDarkMode() ? white : black,
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomCard(
            radius: 15,
            edgeInsets: size.width / 20,
            color: themeSupport().isSelectedDarkMode() ? black : grey,
            outerPadding: size.width / 100,
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPoints(stringVariables.deletePoint1),
                buildPoints(stringVariables.deletePoint2),
                buildPoints(stringVariables.deletePoint3, false),
              ],
            ),
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          CustomContainer(
            width: 1.15,
            height: 7.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  text: stringVariables.deleteDesc1,
                  strutStyleHeight: 1.3,
                  softwrap: true,
                  color: red,
                  fontsize: 13,
                ),
                CustomSizedBox(
                  height: 0.015,
                ),
                CustomText(
                  text: stringVariables.deleteDesc2,
                  strutStyleHeight: 1.3,
                  softwrap: true,
                  color: red,
                  fontsize: 13,
                ),
              ],
            ),
          ),
          CustomSizedBox(
            height: 0.015,
          ),
          buildReasonView(),
          CustomSizedBox(
            height: 0.015,
          ),
          const Divider(
            height: 5,
            thickness: 1,
          ),
          CustomSizedBox(
            height: 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildBottomView(),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildReasonView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 10),
          child: CustomText(
            text: stringVariables.shareDetails,
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
          isContentPadding: true,
          size: 30,
          keyboardType: TextInputType.text,
          text: stringVariables.deleteHint,
          maxLines: 4,
          minLines: 4,
          maxLength: 1000,
          controller: address,
          autovalid: AutovalidateMode.onUserInteraction,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildPoints(String content, [gap = true]) {
    return Column(
      children: [
        CustomText(
            text: content,
            color: hintLight,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.w500,
            fontsize: 13),
        gap
            ? CustomSizedBox(
                height: 0.01,
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
      ],
    );
  }
}
