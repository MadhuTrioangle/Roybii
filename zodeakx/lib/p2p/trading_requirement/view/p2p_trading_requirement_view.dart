import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../profile/view_model/p2p_profile_view_model.dart';

class P2PTradingRequirementView extends StatefulWidget {
  const P2PTradingRequirementView({Key? key}) : super(key: key);

  @override
  State<P2PTradingRequirementView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PTradingRequirementView>
    with TickerProviderStateMixin {
  late P2PProfileViewModel p2pProfileViewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    p2pProfileViewModel =
        Provider.of<P2PProfileViewModel>(context, listen: false);
    if (constant.userLoginStatus.value) p2pProfileViewModel.findUserCenter();
/*
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: AppHeader(size),
      child: buildP2PTradingRequirementView(size),
    );
  }

  Widget buildP2PTradingRequirementView(Size size) {
    bool emailStatus =
        p2pProfileViewModel.userCenter?.emailStatus == "verified";
    bool kycStatus = p2pProfileViewModel.userCenter?.kycStatus == "verified";
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: Column(
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 30),
                  child: Column(
                    children: [
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      CustomContainer(
                        width: 1,
                        child: CustomText(
                          fontfamily: 'GoogleSans',
                          text: stringVariables.tradingRequrimentContent,
                          fontsize: 14,
                          fontWeight: FontWeight.w400,
                          color: hintLight,
                        ),
                      ),
                      CustomSizedBox(
                        height: 0.025,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              CustomContainer(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: hintLight,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: 11,
                                height: 22,
                                child: Center(
                                  child: CustomText(
                                    fontfamily: 'GoogleSans',
                                    text: stringVariables.one,
                                    fontWeight: FontWeight.w500,
                                    fontsize: 16,
                                  ),
                                ),
                              ),
                              CustomContainer(
                                width: size.width,
                                height: 9,
                                color: hintLight,
                              ),
                              CustomContainer(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: hintLight,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: 11,
                                height: 22,
                                child: Center(
                                  child: CustomText(
                                    fontfamily: 'GoogleSans',
                                    text: stringVariables.two,
                                    fontWeight: FontWeight.w500,
                                    fontsize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CustomSizedBox(
                            width: 0.035,
                          ),
                          Column(
                            children: [
                              buildVerificationCard(
                                  size,
                                  stringVariables.completeEmailVerification,
                                  emailStatus),
                              CustomSizedBox(
                                height: 0.02,
                              ),
                              buildVerificationCard(
                                  size,
                                  stringVariables.completeKYCVerification,
                                  kycStatus),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVerificationCard(Size size, String title, bool verified) {
    return CustomContainer(
      width: 1.4,
      decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode() ? switchBackground : grey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: themeSupport().isSelectedDarkMode()
                  ? grey
                  : switchBackground)),
      height: 7,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width / 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: title,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomElevatedButton(
                buttoncolor: verified ? white70 : themeColor,
                color: verified ? themeColor : black,
                press: () {
                  if (!verified) {
                    moveToIdentityVerification(context);
                  }
                },
                width: 3,
                isBorderedButton: true,
                maxLines: 1,
                icon: null,
                multiClick: true,
                text: verified
                    ? stringVariables.verified
                    : stringVariables.verify,
                radius: 25,
                height: size.height / 40,
                icons: false,
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0)),
          ],
        ),
      ),
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
              text: stringVariables.tradingRequriment,
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
