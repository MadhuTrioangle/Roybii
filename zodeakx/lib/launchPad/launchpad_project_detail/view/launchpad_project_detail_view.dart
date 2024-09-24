import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/launchPad/launch_pad_home_page/model/fetch_projects_model.dart';
import 'package:zodeakx_mobile/launchPad/launchpad_project_detail/model/ProjectCommitedModel.dart';
import 'package:zodeakx_mobile/launchPad/launchpad_project_detail/view/launchpad_commit_dialog.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../model/ParticipantModel.dart';
import '../view_model/launchpad_project_detail_view_model.dart';

class LaunchpadProjectDetailView extends StatefulWidget {
  final String projectId;

  const LaunchpadProjectDetailView({Key? key, required this.projectId})
      : super(key: key);

  @override
  State<LaunchpadProjectDetailView> createState() =>
      _LaunchpadProjectDetailViewState();
}

class _LaunchpadProjectDetailViewState extends State<LaunchpadProjectDetailView>
    with SingleTickerProviderStateMixin {
  late LaunchpadProjectDetailViewModel viewModel;
  late IdentityVerificationCommonViewModel identityVerificationCommonViewModel;
  late MarketViewModel marketViewModel;
  late WalletViewModel walletViewModel;
  var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<LaunchpadProjectDetailViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    identityVerificationCommonViewModel =
        Provider.of<IdentityVerificationCommonViewModel>(context,
            listen: false);
    if (constant.userLoginStatus.value) {
      identityVerificationCommonViewModel.getIdVerification();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
    });
    viewModel.fetchProject(widget.projectId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    viewModel.timeLeft?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<LaunchpadProjectDetailViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    marketViewModel = context.watch<MarketViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider(
        create: (context) => viewModel,
        child: CustomScaffold(
            appBar: buildAppBar(), child: buildHistoryView(size)));
  }

  Widget buildHistoryView(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: viewModel.needToLoad
              ? Center(child: CustomLoader())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTimeWithImage(size),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width / 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProjectBasicDetail(size),
                            buildProjectWebLinks(size),
                            buildSubscriptionTimeline(size),
                            buildSocialMediaDetails(size),
                          ],
                        ),
                      ),
                      buildTokenSaleEconomics(size),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildTokenSaleEconomics(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String projectName = datum.projectName ?? "";
    String heading = "$projectName ${stringVariables.tokenSaleAndEconomics}";
    String fiat = datum.fiatCurrency ?? "";
    String crypto = datum.holdingCurrency ?? "";
    String hardCap = datum.hardcap.toString();
    String total = datum.totalTokenSupply.toString();
    String initialCirculatingSupply = datum.totalCirculatingSupply.toString();
    String publicSalePrice = datum.price.toString();
    String tokenOffered = datum.tokensOffered.toString();
    String hardCapPerUser = datum.hardcapPerUser.toString();
    String tokenType = datum.token ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: CustomText(
            strutStyleHeight: 1.75,
            fontfamily: 'GoogleSans',
            fontsize: 20,
            fontWeight: FontWeight.bold,
            text: heading,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildTokenSaleCard(
            size,
            stringVariables.hardCap,
            "$hardCap $fiat",
            themeSupport().isSelectedDarkMode()
                ? switchBackground.withOpacity(0.15)
                : enableBorder.withOpacity(0.5)),
        buildTokenSaleCard(
            size, stringVariables.totalTokenSupply, "$total $crypto", null),
        buildTokenSaleCard(
            size,
            stringVariables.initialCirculatingSupply,
            "$initialCirculatingSupply${stringVariables.percentageOf} ${stringVariables.totalTokenSupply}",
            themeSupport().isSelectedDarkMode()
                ? switchBackground.withOpacity(0.15)
                : enableBorder.withOpacity(0.5)),
        buildTokenSaleCard(
            size,
            stringVariables.publicSaleTokenPrice,
            "$publicSalePrice $fiat ${stringVariables.tokenSaleContent1} $crypto ${stringVariables.tokenSaleContent2}",
            null),
        buildTokenSaleCard(
            size,
            stringVariables.tokensOffered,
            "$tokenOffered $crypto",
            themeSupport().isSelectedDarkMode()
                ? switchBackground.withOpacity(0.15)
                : enableBorder.withOpacity(0.5)),
        buildTokenSaleCard(
            size,
            stringVariables.hardCapPerUser,
            "$hardCapPerUser $fiat ${stringVariables.tokenSaleContent1} $crypto ${stringVariables.tokenSaleContent2}",
            null),
        buildTokenSaleCard(
            size,
            stringVariables.tokenType,
            tokenType,
            themeSupport().isSelectedDarkMode()
                ? switchBackground.withOpacity(0.15)
                : enableBorder.withOpacity(0.5)),
        buildTokenSaleCard(size, stringVariables.tokenDistribution,
            stringVariables.AfterEndTokenSale, null),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildTokenSaleCard(
      Size size, String title, String value, Color? color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            child: CustomContainer(
          width: 1,
          color: color,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height / 75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSizedBox(
                  width: 0.01,
                ),
                CustomContainer(
                  constraints: BoxConstraints(maxWidth: size.width / 2.5),
                  child: CustomText(
                    align: TextAlign.end,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w400,
                    text: title,
                    color: divider,
                  ),
                ),
                CustomSizedBox(
                  width: 0.03,
                )
              ],
            ),
          ),
        )),
        CustomSizedBox(
          width: 0.02,
        ),
        Flexible(
            child: CustomContainer(
          width: 1,
          color: color,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height / 75),
            child: Row(
              children: [
                CustomSizedBox(
                  width: 0.03,
                ),
                Expanded(
                  child: CustomText(
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w500,
                    text: value,
                  ),
                ),
                CustomSizedBox(
                  width: 0.01,
                ),
              ],
            ),
          ),
        ))
      ],
    );
  }

  Widget buildSocialMediaDetails(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String content = datum.description ?? "";
    String twitterLink = datum.tokenLink?.twitterLink ?? "";
    String facebookLink = datum.tokenLink?.facebookLink ?? "";
    String mediumLink = datum.tokenLink?.mediumLink ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.025,
        ),
        CustomText(
          strutStyleHeight: 1.75,
          fontfamily: 'GoogleSans',
          fontsize: 20,
          fontWeight: FontWeight.bold,
          text: content,
        ),
        CustomSizedBox(
          height: 0.025,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 20,
          fontWeight: FontWeight.bold,
          text: stringVariables.socialChannel,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                moveToWebView(context, facebookLink);
              },
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                launchpadFb,
                color: hintLight,
              ),
            ),
            CustomSizedBox(
              width: 0.1,
            ),
            GestureDetector(
              onTap: () {
                moveToWebView(context, twitterLink);
              },
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                launchpadTwitter,
                color: hintLight,
              ),
            ),
            CustomSizedBox(
              width: 0.1,
            ),
            GestureDetector(
              onTap: () {
                moveToWebView(context, mediumLink);
              },
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                launchpadMedium,
                color: hintLight,
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        buildIntroAndKey(size),
        CustomSizedBox(
          height: 0.03,
        ),
      ],
    );
  }

  Widget buildIntroAndKey(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String intro = datum.introduction ?? "";
    String key = datum.keyFeatures ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHugeContent(stringVariables.projectIntroduction, intro),
        CustomSizedBox(
          height: 0.03,
        ),
        buildHugeContent(stringVariables.keyFeaturesHighlights, key),
      ],
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement?.text ?? "";

    return parsedString;
  }

  Widget buildHugeContent(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 20,
          fontWeight: FontWeight.bold,
          text: title,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomText(
          strutStyleHeight: 1.3,
          fontfamily: 'GoogleSans',
          fontsize: 14,
          fontWeight: FontWeight.w400,
          text: _parseHtmlString(content),
        ),
      ],
    );
  }

  Widget buildSubscriptionTimeline(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String crypto = datum.holdingCurrency ?? "";
    String holdingCalculationPeriodStart = getDate(
        (datum.holdCalculationPeriod?.startDate ?? DateTime.now()).toString());
    String subscriptionPeriodStart = getDate(
        (datum.subscriptionPeriod?.startDate ?? DateTime.now()).toString());
    String allocationPeriodStart = getDate(
        (datum.allocationPeriod?.startDate ?? DateTime.now()).toString());
    String tokenDistribution =
        getDate((datum.tokenDistribution ?? DateTime.now()).toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.015,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 22,
          fontWeight: FontWeight.bold,
          text: stringVariables.subscriptionTimeline,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        buildCirlcleWithContent(
            size,
            1,
            "$crypto ${stringVariables.holdingCalculationPeriod}",
            holdingCalculationPeriodStart,
            buildHoldingCalculationPeriod(size)),
        buildCirlcleWithContent(size, 2, stringVariables.subscriptionPeriod,
            subscriptionPeriodStart, buildSubscriptionPeriod(size)),
        buildCirlcleWithContent(size, 3, stringVariables.calculationPeriod,
            allocationPeriodStart, buildCalculationPeriod(size)),
        buildCirlcleWithContent(size, 4, stringVariables.finalTokenDistribution,
            tokenDistribution, buildFinalTokenDistribution(size), true),
      ],
    );
  }

  navigateToCoinDetails(String crypto) {
    DashBoardBalance dashBoardBalance = walletViewModel
            .viewModelDashBoardBalance
            ?.where((element) => element.currencyCode == crypto)
            .first ??
        DashBoardBalance();
    constant.walletCurrency.value = dashBoardBalance.currencyCode ?? "";

    moveToCoinDetailsView(
        context,
        '${dashBoardBalance.currencyName ?? ""}',
        '${dashBoardBalance.totalBalance ?? ""}',
        '${dashBoardBalance.availableBalance ?? ""}',
        '${dashBoardBalance.currencyCode ?? ""}',
        '${dashBoardBalance.currencyType ?? ""}',
        '${dashBoardBalance.inorderBalance ?? ""}','${dashBoardBalance.mlmStakeBalance ?? ""}',
        );
  }

  Widget buildHoldingCalculationPeriod(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String crypto = datum.holdingCurrency ?? "";
    num amount = viewModel.avgBalance?.avgBalance ?? 0;
    bool isLogin = constant.userLoginStatus.value;
    bool dayFlag = int.parse(viewModel.day) <= 0;
    String first = dayFlag ? viewModel.hour : viewModel.day;
    String second = dayFlag ? viewModel.minute : viewModel.hour;
    String third = dayFlag ? viewModel.second : viewModel.minute;
    return CustomContainer(
      width: 1.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            constraints: BoxConstraints(maxWidth: size.width / 1.35),
            child: CustomText(
              fontfamily: 'GoogleSans',
              fontsize: 11,
              fontWeight: FontWeight.w400,
              text: stringVariables.holdingCalculationContent1 +
                  crypto +
                  stringVariables.holdingCalculationContent2,
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          buildTimeLeftView(size, stringVariables.timeLeftSubscription, first,
              second, third, dayFlag),
          CustomSizedBox(
            height: 0.005,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? switchBackground.withOpacity(0.15)
                  : enableBorder.withOpacity(0.35),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: isLogin
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomContainer(
                              constraints:
                                  BoxConstraints(maxWidth: size.width / 2.2),
                              child: CustomText(
                                fontfamily: 'GoogleSans',
                                fontsize: 11,
                                fontWeight: FontWeight.w500,
                                text: stringVariables.avg +
                                    " $crypto " +
                                    stringVariables.avgContent,
                              ),
                            ),
                            buildKycView(),
                          ],
                        ),
                        CustomSizedBox(
                          height: 0.0075,
                        ),
                        CustomText(
                          fontfamily: 'GoogleSans',
                          fontsize: 12,
                          fontWeight: FontWeight.bold,
                          text: "$amount $crypto",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateToCoinDetails(crypto);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: CustomText(
                                fontfamily: 'GoogleSans',
                                fontsize: 11,
                                fontWeight: FontWeight.w500,
                                text:
                                    "$crypto ${stringVariables.holdingDetails}",
                                decoration: TextDecoration.underline,
                                color: themeColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                navigateToCoinDetails(crypto);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: CustomContainer(
                                height: isSmallScreen(context) ? 30 : 34,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  borderRadius: BorderRadius.circular(
                                    5.0,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Center(
                                    child: CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 11,
                                      fontWeight: FontWeight.bold,
                                      text: "${stringVariables.buy} $crypto",
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomSizedBox(
                          height: 0.0075,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CustomSizedBox(
                                  height: 0.0025,
                                ),
                                SvgPicture.asset(
                                  launchpadResearchReport,
                                  color: themeColor,
                                ),
                              ],
                            ),
                            CustomSizedBox(
                              width: 0.015,
                            ),
                            CustomContainer(
                              constraints:
                                  BoxConstraints(maxWidth: size.width / 1.6),
                              child: CustomText(
                                strutStyleHeight: 1.1,
                                fontfamily: 'GoogleSans',
                                fontsize: 11,
                                fontWeight: FontWeight.w400,
                                text: stringVariables.only +
                                    " $crypto " +
                                    stringVariables.holdingCalculationContent3 +
                                    " $crypto" +
                                    stringVariables.holdingCalculationContent4 +
                                    " $crypto " +
                                    stringVariables.holdingCalculationContent5,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : buildNotLoggedView(size),
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildSubscriptionPeriod(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    ProjectCommited projectCommited =
        (viewModel.projectCommited ?? []).isNotEmpty
            ? viewModel.projectCommited?.first ?? ProjectCommited()
            : ProjectCommited();
    Participant participant = viewModel.participant ?? Participant();
    String crypto = datum.holdingCurrency ?? "";
    num amount = participant.commitedAmount ?? 0;
    num limit = viewModel.avgBalance?.avgBalance ?? 0;
    num totalCommit = projectCommited.commitedValue ?? 0;
    int participants = projectCommited.noOfParticipants ?? 0;
    bool isLogin = constant.userLoginStatus.value;
    bool dayFlag = int.parse(viewModel.day) <= 0;
    String first = dayFlag ? viewModel.hour : viewModel.day;
    String second = dayFlag ? viewModel.minute : viewModel.hour;
    String third = dayFlag ? viewModel.second : viewModel.minute;
    return CustomContainer(
      width: 1.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            constraints: BoxConstraints(maxWidth: size.width / 1.35),
            child: CustomText(
              fontfamily: 'GoogleSans',
              fontsize: 11,
              fontWeight: FontWeight.w400,
              text: stringVariables.reminder +
                  ": " +
                  stringVariables.only +
                  " $crypto " +
                  stringVariables.subcriptionContent1 +
                  " $crypto " +
                  stringVariables.subcriptionContent2 +
                  " $crypto " +
                  stringVariables.subcriptionContent3,
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          buildTimeLeftView(size, stringVariables.timeLeftCalculation, first,
              second, third, dayFlag),
          CustomSizedBox(
            height: 0.005,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? switchBackground.withOpacity(0.15)
                  : enableBorder.withOpacity(0.35),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            width: 1.35,
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: isLogin
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomContainer(
                              constraints:
                                  BoxConstraints(maxWidth: size.width / 2.2),
                              child: CustomText(
                                fontfamily: 'GoogleSans',
                                fontsize: 11,
                                fontWeight: FontWeight.w500,
                                text: stringVariables.yourCommitmentLimit +
                                    ": $limit $crypto ",
                              ),
                            ),
                            buildKycView()
                          ],
                        ),
                        CustomSizedBox(
                          height: 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  fontfamily: 'GoogleSans',
                                  fontsize: 11,
                                  fontWeight: FontWeight.w400,
                                  text: stringVariables.yourCommitted +
                                      " $crypto",
                                ),
                                CustomSizedBox(
                                  height: 0.005,
                                ),
                                CustomText(
                                  fontfamily: 'GoogleSans',
                                  fontsize: 12,
                                  fontWeight: FontWeight.bold,
                                  text: "$amount $crypto",
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _showModel,
                              behavior: HitTestBehavior.opaque,
                              child: CustomContainer(
                                height: isSmallScreen(context) ? 25 : 30,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  borderRadius: BorderRadius.circular(
                                    5.0,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Center(
                                    child: CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 11,
                                      fontWeight: FontWeight.bold,
                                      text: "${stringVariables.commit} $crypto",
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomSizedBox(
                          height: 0.0075,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CustomSizedBox(
                                  height: 0.0025,
                                ),
                                SvgPicture.asset(
                                  launchpadResearchReport,
                                  color: themeColor,
                                ),
                              ],
                            ),
                            CustomSizedBox(
                              width: 0.015,
                            ),
                            CustomContainer(
                              constraints:
                                  BoxConstraints(maxWidth: size.width / 1.6),
                              child: CustomText(
                                strutStyleHeight: 1.1,
                                fontfamily: 'GoogleSans',
                                fontsize: 11,
                                fontWeight: FontWeight.w400,
                                text: stringVariables.only +
                                    " $crypto " +
                                    stringVariables.subcriptionContent3,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : buildNotLoggedView(size),
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CustomCircleAvatar(
                          radius: 10,
                          backgroundColor: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FadeInImage.assetNetwork(
                              image: getImage(
                                  marketViewModel, walletViewModel, crypto),
                              placeholder: splash,
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.01,
                        ),
                        CustomText(
                          fontfamily: 'GoogleSans',
                          fontsize: 11,
                          fontWeight: FontWeight.w500,
                          text: stringVariables.total +
                              " $crypto " +
                              stringVariables.alreadyCommitted,
                          color: divider,
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: CustomText(
                        fontfamily: 'GoogleSans',
                        fontsize: 12,
                        fontWeight: FontWeight.w600,
                        text: "$totalCommit $crypto",
                      ),
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Row(
                      children: [
                        CustomCircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            themeSupport().isSelectedDarkMode()
                                ? launchpadProfileDark
                                : launchpadProfile,
                            height: 16,
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.01,
                        ),
                        CustomText(
                          fontfamily: 'GoogleSans',
                          fontsize: 11,
                          fontWeight: FontWeight.w500,
                          text: stringVariables.totalParticipants,
                          color: divider,
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: CustomText(
                        fontfamily: 'GoogleSans',
                        fontsize: 12,
                        fontWeight: FontWeight.w600,
                        text: participants.toString(),
                      ),
                    ),
                  ]),
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildNotCommittedView(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String crypto = datum.holdingCurrency ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          p2pOrderAttention,
          color: themeColor,
          height: 35,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CustomSizedBox(
                  height: 0.0025,
                ),
                SvgPicture.asset(
                  launchpadResearchReport,
                  color: themeColor,
                ),
              ],
            ),
            CustomSizedBox(
              width: 0.015,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.6),
              child: CustomText(
                strutStyleHeight: 1.1,
                fontfamily: 'GoogleSans',
                fontsize: 11,
                fontWeight: FontWeight.w400,
                text: stringVariables.notCommitContent1 +
                    " $crypto " +
                    stringVariables.notCommitContent2,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildNotLoggedView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          launchpadLogin,
          height: 35,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CustomSizedBox(
                  height: 0.0025,
                ),
                SvgPicture.asset(
                  launchpadResearchReport,
                  color: themeColor,
                ),
              ],
            ),
            CustomSizedBox(
              width: 0.015,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.6),
              child: CustomText(
                strutStyleHeight: 1.1,
                fontfamily: 'GoogleSans',
                fontsize: 11,
                fontWeight: FontWeight.w400,
                text: stringVariables.youNotLogged,
              ),
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        GestureDetector(
          onTap: () {
            moveToRegister(context, false);
          },
          behavior: HitTestBehavior.opaque,
          child: CustomContainer(
            width: 4,
            height: isSmallScreen(context) ? 30 : 34,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(
                5.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: CustomText(
                  fontfamily: 'GoogleSans',
                  fontsize: 11,
                  fontWeight: FontWeight.bold,
                  text: stringVariables.login,
                  color: black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showModel() async {
    final result =
        await Navigator.of(context).push(LaunchpadCommitModel(context));
  }

  Widget buildCalculationPeriod(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    bool isCommitted = (viewModel.projectCommited ?? []).isNotEmpty;
    ProjectCommited projectCommited = isCommitted
        ? viewModel.projectCommited?.first ?? ProjectCommited()
        : ProjectCommited();
    String crypto = datum.holdingCurrency ?? "";
    num totalCommit = projectCommited.commitedValue ?? 0.0;
    int participants = projectCommited.noOfParticipants ?? 0;
    num limit = viewModel.avgBalance?.avgBalance ?? 0;
    bool isLogin = constant.userLoginStatus.value;
    bool dayFlag = int.parse(viewModel.day) <= 0;
    String first = dayFlag ? viewModel.hour : viewModel.day;
    String second = dayFlag ? viewModel.minute : viewModel.hour;
    String third = dayFlag ? viewModel.second : viewModel.minute;
    return CustomContainer(
      width: 1.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            constraints: BoxConstraints(maxWidth: size.width / 1.35),
            child: CustomText(
              fontfamily: 'GoogleSans',
              fontsize: 11,
              fontWeight: FontWeight.w400,
              text: stringVariables.calculationContent1,
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          buildTimeLeftView(size, stringVariables.timeLeftTokenDistribution,
              first, second, third, dayFlag),
          CustomSizedBox(
            height: 0.005,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? switchBackground.withOpacity(0.15)
                  : enableBorder.withOpacity(0.35),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            width: 1.35,
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: isLogin
                  ? isCommitted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomContainer(
                                  constraints: BoxConstraints(
                                      maxWidth: size.width / 2.2),
                                  child: CustomText(
                                    fontfamily: 'GoogleSans',
                                    fontsize: 11,
                                    fontWeight: FontWeight.w500,
                                    text: stringVariables.yourCommitmentLimit +
                                        ": $limit $crypto ",
                                  ),
                                ),
                                buildKycView()
                              ],
                            ),
                            CustomSizedBox(
                              height: 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 11,
                                      fontWeight: FontWeight.w400,
                                      text: stringVariables.yourTokenAllocation,
                                    ),
                                    CustomSizedBox(
                                      height: 0.005,
                                    ),
                                    CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 12,
                                      fontWeight: FontWeight.bold,
                                      text: stringVariables.calculating,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    navigateToCoinDetails(crypto);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: CustomContainer(
                                    height: isSmallScreen(context) ? 30 : 34,
                                    decoration: BoxDecoration(
                                      color: switchBackground.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(
                                        5.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Center(
                                        child: CustomText(
                                          fontfamily: 'GoogleSans',
                                          fontsize: 11,
                                          fontWeight: FontWeight.bold,
                                          text:
                                              "${stringVariables.viewLocked} $crypto",
                                          color: black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            CustomSizedBox(
                              height: 0.0075,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CustomSizedBox(
                                      height: 0.0025,
                                    ),
                                    SvgPicture.asset(
                                      launchpadResearchReport,
                                      color: themeColor,
                                    ),
                                  ],
                                ),
                                CustomSizedBox(
                                  width: 0.015,
                                ),
                                CustomContainer(
                                  constraints: BoxConstraints(
                                      maxWidth: size.width / 1.6),
                                  child: Text.rich(
                                    softWrap: true,
                                    strutStyle: StrutStyle(height: 1.1),
                                    TextSpan(
                                        text:
                                            stringVariables.calculationContent2,
                                        style: TextStyle(
                                          color: themeSupport()
                                                  .isSelectedDarkMode()
                                              ? white
                                              : black,
                                          fontSize: 11,
                                          fontFamily: 'GoogleSans',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: stringVariables
                                                  .pleaseCheckHere,
                                              style: TextStyle(
                                                color: themeColor,
                                                fontSize: 11,
                                                fontFamily: 'GoogleSans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  moveToWebView(
                                                      context,
                                                      viewModel.webLinks[3]
                                                          ["url"]!);
                                                }),
                                        ]),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : buildNotCommittedView(size)
                  : buildNotLoggedView(size),
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCircleAvatar(
                          radius: 10,
                          backgroundColor: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FadeInImage.assetNetwork(
                              image: getImage(
                                  marketViewModel, walletViewModel, crypto),
                              placeholder: splash,
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.01,
                        ),
                        CustomText(
                          fontfamily: 'GoogleSans',
                          fontsize: 11,
                          fontWeight: FontWeight.w500,
                          text: stringVariables.total +
                              " $crypto " +
                              stringVariables.alreadyCommitted,
                          color: divider,
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: CustomText(
                        fontfamily: 'GoogleSans',
                        fontsize: 12,
                        fontWeight: FontWeight.w600,
                        text: "$totalCommit $crypto",
                      ),
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            themeSupport().isSelectedDarkMode()
                                ? launchpadProfileDark
                                : launchpadProfile,
                            height: 16,
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.01,
                        ),
                        CustomText(
                          fontfamily: 'GoogleSans',
                          fontsize: 11,
                          fontWeight: FontWeight.w500,
                          text: stringVariables.totalParticipants,
                          color: divider,
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: CustomText(
                        fontfamily: 'GoogleSans',
                        fontsize: 12,
                        fontWeight: FontWeight.w600,
                        text: participants.toString(),
                      ),
                    ),
                  ]),
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildFinalTokenDistribution(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    bool isCommitted = (viewModel.projectCommited ?? []).isNotEmpty;
    ProjectCommited projectCommited = isCommitted
        ? viewModel.projectCommited?.first ?? ProjectCommited()
        : ProjectCommited();
    Participant participant = viewModel.participant ?? Participant();
    String rewardCurrency = datum.fiatCurrency ?? "";
    String crypto = datum.holdingCurrency ?? "";
    String token = datum.token ?? "";
    num amount = participant.deductedAmount ?? 0;
    num rewardAmount = participant.allocatedToken ?? 0;
    num totalCommit = projectCommited.commitedValue ?? 0.0;
    int participants = projectCommited.noOfParticipants ?? 0;
    bool isLogin = constant.userLoginStatus.value;
    return CustomContainer(
      width: 1.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            constraints: BoxConstraints(maxWidth: size.width / 1.35),
            child: CustomText(
              fontfamily: 'GoogleSans',
              fontsize: 11,
              fontWeight: FontWeight.w400,
              text: stringVariables.finalDistribution1 +
                  " $crypto " +
                  stringVariables.finalDistribution2 +
                  " $rewardCurrency " +
                  stringVariables.finalDistribution3 +
                  " $crypto.",
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomText(
            fontfamily: 'GoogleSans',
            fontsize: 11,
            fontWeight: FontWeight.w400,
            text: stringVariables.finalResultsAnnounced,
          ),
          CustomSizedBox(
            height: 0.005,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode()
                  ? switchBackground.withOpacity(0.15)
                  : enableBorder.withOpacity(0.35),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            width: 1.35,
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: isLogin
                  ? isCommitted
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 11,
                                      fontWeight: FontWeight.w400,
                                      text: stringVariables.toBeDeducted,
                                    ),
                                    CustomSizedBox(
                                      height: 0.005,
                                    ),
                                    CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 12,
                                      fontWeight: FontWeight.bold,
                                      text: "$amount $crypto",
                                    ),
                                  ],
                                ),
                                CustomSizedBox(
                                  width: 0.04,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 11,
                                      fontWeight: FontWeight.w400,
                                      text: stringVariables.yourTokenAllocation,
                                    ),
                                    CustomSizedBox(
                                      height: 0.005,
                                    ),
                                    CustomText(
                                      fontfamily: 'GoogleSans',
                                      fontsize: 12,
                                      fontWeight: FontWeight.bold,
                                      text: "$rewardAmount $token",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            CustomSizedBox(
                              height: 0.015,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    CustomSizedBox(
                                      height: 0.0025,
                                    ),
                                    SvgPicture.asset(
                                      launchpadResearchReport,
                                      color: themeColor,
                                    ),
                                  ],
                                ),
                                CustomSizedBox(
                                  width: 0.015,
                                ),
                                CustomContainer(
                                  constraints: BoxConstraints(
                                      maxWidth: size.width / 1.6),
                                  child: CustomText(
                                    strutStyleHeight: 1.1,
                                    fontfamily: 'GoogleSans',
                                    fontsize: 11,
                                    fontWeight: FontWeight.w400,
                                    text: stringVariables.finalDistribution4 +
                                        " $crypto " +
                                        stringVariables.finalDistribution5 +
                                        " $token " +
                                        stringVariables.finalDistribution6 +
                                        " $token " +
                                        stringVariables.finalDistribution7 +
                                        " $crypto " +
                                        stringVariables.finalDistribution8,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : buildNotCommittedView(size)
                  : buildNotLoggedView(size),
            ),
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(
                10.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCircleAvatar(
                          radius: 10,
                          backgroundColor: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FadeInImage.assetNetwork(
                              image: getImage(
                                  marketViewModel, walletViewModel, crypto),
                              placeholder: splash,
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.01,
                        ),
                        CustomText(
                          fontfamily: 'GoogleSans',
                          fontsize: 11,
                          fontWeight: FontWeight.w500,
                          text: stringVariables.total +
                              " $crypto " +
                              stringVariables.alreadyCommitted,
                          color: divider,
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: CustomText(
                        fontfamily: 'GoogleSans',
                        fontsize: 12,
                        fontWeight: FontWeight.w600,
                        text: "$totalCommit $crypto",
                      ),
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            themeSupport().isSelectedDarkMode()
                                ? launchpadProfileDark
                                : launchpadProfile,
                            height: 16,
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.01,
                        ),
                        CustomText(
                          fontfamily: 'GoogleSans',
                          fontsize: 11,
                          fontWeight: FontWeight.w500,
                          text: stringVariables.totalParticipants,
                          color: divider,
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.0075,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: CustomText(
                        fontfamily: 'GoogleSans',
                        fontsize: 12,
                        fontWeight: FontWeight.w600,
                        text: participants.toString(),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKycView() {
    String kyc = identityVerificationCommonViewModel
            .viewModelVerification?.kyc?.kycStatus ??
        "";
    bool verified = kyc == stringVariables.verified.toLowerCase();
    Color kycColor = verified ? green : red;
    String kycImage = verified ? launchpadVerifyTick : launchpadUnverify;
    String kycStatus =
        verified ? stringVariables.kycVerified : stringVariables.kycUnverified;
    return GestureDetector(
      onTap: () {
        if (!verified) {
          moveToIdentityVerification(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
        height: isSmallScreen(context) ? 32 : 38,
        decoration: BoxDecoration(
          color: kycColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(
            5.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                kycImage,
                height: 10,
              ),
              CustomSizedBox(
                width: 0.01,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                fontsize: 9,
                fontWeight: FontWeight.w500,
                text: kycStatus,
                color: kycColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeLeftView(
      Size size, String title, String days, String hours, String minutes,
      [bool dayFlag = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomContainer(
          constraints: BoxConstraints(
              maxWidth: size.width / (isSmallScreen(context) ? 2.7 : 2.6)),
          child: CustomText(
            fontfamily: 'GoogleSans',
            fontsize: 11,
            fontWeight: FontWeight.w400,
            text: title,
          ),
        ),
        Row(
          children: [
            buildTimeView(
                days, dayFlag ? stringVariables.hours : stringVariables.days),
            CustomSizedBox(
              width: 0.0075,
            ),
            buildTimeView(
                hours, dayFlag ? stringVariables.mins : stringVariables.hours),
            CustomSizedBox(
              width: 0.0075,
            ),
            buildTimeView(
                minutes, dayFlag ? stringVariables.secs : stringVariables.mins),
            CustomSizedBox(
              width: 0.01,
            ),
          ],
        )
      ],
    );
  }

  Widget buildTimeView(String time, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: isSmallScreen(context) ? 12.5 : 13,
          fontWeight: FontWeight.w400,
          text: time,
        ),
        CustomSizedBox(
          width: 0.005,
        ),
        CustomText(
          strutStyleHeight: 0.9,
          fontfamily: 'GoogleSans',
          fontsize: isSmallScreen(context) ? 9 : 10,
          fontWeight: FontWeight.w400,
          text: label,
        ),
      ],
    );
  }

  Widget buildCirlcleWithContent(
      Size size, int index, String title, String dateTime, Widget widget,
      [bool isLast = false]) {
    int currentStep = viewModel.currentStep;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              isLast
                  ? CustomSizedBox(
                      width: 0,
                      height: 0,
                    )
                  : CustomContainer(
                      width: size.width,
                      color: themeColor,
                    ),
              CustomCircleAvatar(
                radius: 12.5,
                backgroundColor: index > currentStep
                    ? themeSupport().isSelectedDarkMode()
                        ? divider
                        : enableBorder
                    : themeColor,
                child: index < currentStep
                    ? SvgPicture.asset(
                        launchpadTick,
                        height: 11,
                        color:
                            themeSupport().isSelectedDarkMode() ? black : white,
                      )
                    : CustomText(
                        fontfamily: 'GoogleSans',
                        fontsize: 12,
                        fontWeight: FontWeight.w500,
                        text: index.toString(),
                        color:
                            themeSupport().isSelectedDarkMode() ? black : white,
                      ),
              ),
            ],
          ),
          CustomSizedBox(
            width: 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                height: 0.005,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                fontsize: index != currentStep ? 14 : 16,
                fontWeight: FontWeight.w500,
                text: title,
              ),
              CustomSizedBox(
                height: 0.015,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                fontsize: index != currentStep ? 10 : 12,
                fontWeight: FontWeight.w500,
                text: dateTime,
              ),
              index != currentStep
                  ? CustomSizedBox(
                      height: isLast ? 0.02 : 0.03,
                    )
                  : widget,
            ],
          )
        ],
      ),
    );
  }

  Widget buildProjectWebLinks(Size size) {
    List<Widget> webLinksList = [];
    int webLinksCount = viewModel.webLinks.length;
    for (var i = 0; i < webLinksCount; i++) {
      webLinksList.add(buildStatusCard(
        (viewModel.webLinks[i]["logo"] ?? ""),
        (viewModel.webLinks[i]["title"] ?? ""),
        (viewModel.webLinks[i]["url"] ?? ""),
        switchBackground.withOpacity(0.3),
        switchBackground.withOpacity(0.15),
        false,
        themeSupport().isSelectedDarkMode() ? white : black,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: webLinksList,
          ),
        ),
        CustomSizedBox(
          height: 0.02,
        )
      ],
    );
  }

  Widget buildProjectBasicDetail(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String projectName = datum.projectName ?? "";
    String status = datum.projectStatus ?? "";
    String type = stringVariables.subscription;
    String fiat = datum.fiatCurrency ?? "";
    String crypto = datum.holdingCurrency ?? "";
    String token = datum.token ?? "";
    String cryptoValue = trimDecimalsForBalance(
        ((datum.price ?? 0) * ((viewModel.exchangeRate ?? 0))).toString());
    String salePrice = "${stringVariables.one} $token = $cryptoValue $crypto";
    String tokens = (datum.tokensOffered ?? 0).toString();
    String tokensOffered = "$tokens $token";
    String lowInvestment = "${datum.minimumCommitment}";
    String singleInitialInvestment = "$lowInvestment $crypto";
    double hardCap = (datum.hardcapPerUser ?? 0) / (datum.price ?? 0);
    String hardCapFiat = "${trimDecimalsForBalance(hardCap.toString())} $token";
    double exchangeWithPrice = (viewModel.exchangeRate) * (datum.price ?? 0);
    String hardCapCrptoCalculation =
        trimDecimalsForBalance((exchangeWithPrice * hardCap).toString());
    String hardCapCrypto = "$hardCapCrptoCalculation $crypto";
    String hardCapUsd =
        "${trimDecimalsForBalance(((exchangeWithPrice * hardCap) * viewModel.exchangeRate).toString())} $fiat";
    String hardCapPerUser = "$hardCapFiat = $hardCapCrypto (≈ $hardCapUsd)";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 22,
          fontWeight: FontWeight.bold,
          text: projectName,
        ),
        CustomSizedBox(height: 0.02),
        Wrap(
          runSpacing: 10,
          spacing: 10,
          children: [
            buildStatusCard(
                getActiveImage(status),
                getStatus(status),
                "",
                enableBorder.withOpacity(0.35),
                switchBackground.withOpacity(0.15)),
            // status == 'completed'
            //     ? CustomSizedBox(
            //         width: 0,
            //         height: 0,
            //       )
            //     : buildImageCard(
            //         crypto,
            //         getStatus(status),
            //         "",
            //         enableBorder.withOpacity(0.35),
            //         switchBackground.withOpacity(0.15)),
          ],
        ),
        CustomSizedBox(height: 0.02),
        buildBasicDetailView(stringVariables.type, type),
        buildBasicDetailView(stringVariables.salePrice, salePrice),
        buildBasicDetailView(stringVariables.tokensOffered, tokensOffered),
        buildBasicDetailView(
            stringVariables.singleInitialInvestment, singleInitialInvestment),
        buildBasicDetailView(stringVariables.hardCapPerUser, hardCapPerUser),
      ],
    );
  }

  getStatus(String text) {
    if (text == 'holding') {
      return stringVariables.preparationPeriod;
    } else if (text == 'subscription') {
      return stringVariables.subscriptionPeriod;
    } else if (text == 'allocation') {
      return stringVariables.rewardCal;
    } else if (text == 'completed') {
      return stringVariables.finish;
    } else if (text == 'active') {
      return stringVariables.active;
    } else {
      return stringVariables.inActive;
    }
  }

  getActiveStatus(String text) {
    if (text == stringVariables.completed.toLowerCase()) {
      return stringVariables.finish;
    } else {
      return stringVariables.inprocess;
    }
  }

  getActiveImage(String text) {
    if (text == stringVariables.holding.toLowerCase()) {
      return launchpadInprogress;
    } else {
      return launchpadFinished;
    }
  }

  Widget buildStatusCard(
      String icon, String title, String url, Color light, Color dark,
      [bool start = true, Color? color = null]) {
    return GestureDetector(
      onTap: () {
        String site = url.contains(".pdf")
            ? "https://docs.google.com/gview?embedded=true&url=${url.contains("%") ? Uri.encodeComponent(url) : url}"
            : url;
        if (url.isNotEmpty) moveToWebView(context, site);
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
          padding: 7.5,
          decoration: BoxDecoration(
            color: themeSupport().isSelectedDarkMode() ? dark : light,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          child: Column(
            children: [
              CustomSizedBox(
                height: start ? 0 : 0.0025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSizedBox(
                    width: start ? 0.015 : 0.01,
                  ),
                  SvgPicture.asset(
                    icon,
                    color: color,
                  ),
                  CustomSizedBox(
                    width: 0.015,
                  ),
                  CustomText(
                    text: title,
                    fontfamily: 'GoogleSans',
                    fontsize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  CustomSizedBox(
                    width: 0.015,
                  ),
                ],
              ),
              CustomSizedBox(
                height: start ? 0 : 0.0025,
              ),
            ],
          )),
    );
  }

  Widget buildImageCard(
      String crypto, String title, String url, Color light, Color dark,
      [bool start = true, Color? color = null]) {
    return CustomContainer(
        padding: 7.5,
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode() ? dark : light,
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        child: Column(
          children: [
            CustomSizedBox(
              height: start ? 0 : 0.0025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSizedBox(
                  width: 0.005,
                ),
                CustomCircleAvatar(
                  radius: 10,
                  backgroundColor:
                      themeSupport().isSelectedDarkMode() ? black : white,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FadeInImage.assetNetwork(
                      image: getImage(marketViewModel, walletViewModel, crypto),
                      placeholder: splash,
                    ),
                  ),
                ),
                CustomSizedBox(
                  width: 0.01,
                ),
                CustomText(
                  text: title,
                  fontfamily: 'GoogleSans',
                  fontsize: 14,
                  fontWeight: FontWeight.w400,
                ),
                CustomSizedBox(
                  width: 0.01,
                ),
              ],
            ),
            CustomSizedBox(
              height: start ? 0 : 0.0025,
            ),
          ],
        ));
  }

  Widget buildBasicDetailView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 14,
          fontWeight: FontWeight.w400,
          color: textGrey,
          text: title,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 14,
          fontWeight: FontWeight.w500,
          text: value,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
      ],
    );
  }

  Widget buildTimeWithImage(Size size) {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String endTime =
        getDate((datum.tokenDistribution ?? DateTime.now()).toString());
    String image = datum.projectLogo ?? "";
    return Column(
      children: [
        CustomSizedBox(height: 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                fontfamily: 'GoogleSans',
                fontsize: 14,
                fontWeight: FontWeight.w500,
                text: stringVariables.endTime,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                fontsize: 14,
                fontWeight: FontWeight.w500,
                text: endTime,
              ),
            ],
          ),
        ),
        CustomSizedBox(height: 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CustomContainer(
                width: 1,
                height: 3.75,
                child: CustomNetworkImage(
                  fit: BoxFit.cover,
                  image: image,
                )),
          ),
        ),
        CustomSizedBox(height: 0.02),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: CustomText(
                      overflow: TextOverflow.ellipsis,
                      maxlines: 1,
                      softwrap: true,
                      fontfamily: 'GoogleSans',
                      fontsize: 21,
                      fontWeight: FontWeight.bold,
                      text: stringVariables.projectDetail,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
