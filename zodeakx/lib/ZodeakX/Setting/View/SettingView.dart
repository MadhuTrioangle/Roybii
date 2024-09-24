import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/Colors.dart';
import 'package:zodeakx_mobile/Utils/Core/ColorHandler/DarkandLightTheme.dart';
import 'package:zodeakx_mobile/Utils/Languages/English/StringVariables.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Core/appFunctons/appEnums.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../MarketScreen/ViewModel/MarketViewModel.dart';
import '../ViewModel/GetActivityViewModel.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late GetActivityViewModel settingActivity;

  @override
  void initState() {
    settingActivity = Provider.of<GetActivityViewModel>(context, listen: false);
    settingActivity.getIpAndTime();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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

  @override
  Widget build(BuildContext context) {
    settingActivity = context.watch<GetActivityViewModel>();
    String email = constant.pref?.getString("userEmail") ?? '';
    return Provider<GetActivityViewModel>(
      create: (context) => GetActivityViewModel(),
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
                    text: stringVariables.setting,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: (settingActivity.needToLoad)
            ? Center(child: CustomLoader())
            : Column(
                children: [
                  UpperCard(context, email),
                  LowerCard(
                    context,
                  ),
                ],
              ),
      ),
    );
  }

  /// UpperCard contains email,ip,device,last loginTime
  Widget UpperCard(BuildContext context, String email) {
    return Container(
      width: double.infinity,
      child: CustomCard(
          radius: 25,
          elevation: 0,
          edgeInsets: 8,
          outerPadding: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomContainer(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                      width: 3),
                ),
                child: Center(
                    child: CustomText(
                  text: '${email[0].toUpperCase()}',
                  fontWeight: FontWeight.bold,
                  fontsize: 20,
                  color: themeColor,
                )),
              ),
              CustomText(
                text: '${email}',
                fontsize: 18,
                softwrap: true,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
              CustomSizedBox(
                height: 0.03,
              ),
              CustomCard(
                  radius: 25,
                  edgeInsets: 18,
                  outerPadding: 0,
                  elevation: 0,
                  color: themeSupport().isSelectedDarkMode() ? black : grey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            color: hintLight,
                            text: stringVariables.loginDate,
                            align: TextAlign.end,
                            fontfamily: 'GoogleSans',
                            softwrap: true,
                            overflow: TextOverflow.ellipsis,
                            fontsize: 15,
                          ),
                          CustomText(
                              text: getDateFromTimeStamp(
                                  '${settingActivity.viewModelTimeIP?.first.createdDate}'),
                              align: TextAlign.end,
                              softwrap: true,
                              maxlines: 1,
                              fontfamily: 'GoogleSans',
                              overflow: TextOverflow.ellipsis,
                              fontsize: 13)
                        ],
                      ),
                      CustomSizedBox(
                        height: 0.015,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              color: hintLight,
                              text: stringVariables.device,
                              align: TextAlign.end,
                              fontfamily: 'GoogleSans',
                              softwrap: true,
                              overflow: TextOverflow.ellipsis,
                              fontsize: 15),
                          Container(
                              width: 200,
                              child: CustomText(
                                  align: TextAlign.end,
                                  softwrap: true,
                                  maxlines: 1,
                                  fontfamily: 'GoogleSans',
                                  overflow: TextOverflow.ellipsis,
                                  text:
                                      '${settingActivity.viewModelTimeIP?.first.device ?? stringVariables.device}',
                                  fontsize: 13))
                        ],
                      ),
                      CustomSizedBox(
                        height: 0.015,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              color: hintLight,
                              text: stringVariables.os,
                              align: TextAlign.end,
                              fontfamily: 'GoogleSans',
                              softwrap: true,
                              overflow: TextOverflow.ellipsis,
                              fontsize: 15),
                          CustomText(
                              align: TextAlign.end,
                              softwrap: true,
                              maxlines: 1,
                              fontfamily: 'GoogleSans',
                              overflow: TextOverflow.ellipsis,
                              text:
                                  '${settingActivity.viewModelTimeIP?.first.os ?? stringVariables.device}',
                              fontsize: 13)
                        ],
                      ),
                    ],
                  )),
              CustomSizedBox(
                height: 0.02,
              ),
            ],
          )),
    );
  }

  ///LowerCard contains identity verification
  Widget LowerCard(
    BuildContext context,
  ) {
    return CustomCard(
      radius: 25,
      elevation: 0,
      edgeInsets: 8,
      outerPadding: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              CustomSizedBox(
                height: 0.03,
              ),
              CustomText(
                text: stringVariables.identityVerification,
                fontsize: 18,
                fontWeight: FontWeight.bold,
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              Row(
                children: [
                  CustomText(
                    text: stringVariables.status+" :  ",
                    color: themeSupport().isSelectedDarkMode()
                        ? white70
                        : hintLight,
                    fontsize: 16,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        '${settingActivity.viewModelVerification?.kyc?.kycStatus}' ==
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
                            '${settingActivity.viewModelVerification?.kyc?.kycStatus ?? stringVariables.rejected}',
                        fontWeight: FontWeight.bold,
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
          CustomElevatedButton(
              text: settingActivity.viewModelVerification?.kyc?.kycStatus ==
                      "verified"
                  ? stringVariables.view
                  : stringVariables.verify,
              press: () {
                moveToIdentityVerification(context);
              },
              color: black,
              radius: 25,
              multiClick: true,
              buttoncolor: themeColor,
              width: 3.0,
              height: MediaQuery.of(context).size.height / 50,
              isBorderedButton: false,
              maxLines: 1,
              icons: false,
              icon: null),
        ],
      ),
    );
  }
}
