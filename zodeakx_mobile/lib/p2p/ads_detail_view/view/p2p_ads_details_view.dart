import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/ads/view_model/p2p_ads_view_model.dart';
import 'package:zodeakx_mobile/p2p/home/model/p2p_advertisement.dart';

import '../../../Common/IdentityVerification/ViewModel/IdentityVerificationCommonViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSwitch.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/view/p2p_home_view.dart';

class P2PAdsDetailsView extends StatefulWidget {
  final String id;

  const P2PAdsDetailsView({Key? key, required this.id}) : super(key: key);

  @override
  State<P2PAdsDetailsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PAdsDetailsView>
    with TickerProviderStateMixin {
  late P2PAdsViewModel viewModel;
  late IdentityVerificationCommonViewModel identityVerificationCommonViewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PAdsViewModel>(context, listen: false);
    identityVerificationCommonViewModel =
        Provider.of<IdentityVerificationCommonViewModel>(context,
            listen: false);
    if (constant.userLoginStatus.value)
      identityVerificationCommonViewModel.getIdVerification();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.fetchParticularUserAdvertisement(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PAdsViewModel>();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PProfileDetailView(size),
      ),
    );
  }

  takeToEditAd() {
    bool tfaStatus =
        identityVerificationCommonViewModel.viewModelVerification?.tfaStatus ==
            'verified';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (tfaStatus) {
      moveToEditAnAdView(context, widget.id);
    } else {
      customSnackBar.showSnakbar(
          context, stringVariables.enableTfa, SnackbarType.negative);
    }
  }

  Widget buildP2PProfileDetailView(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomSizedBox(
                        height: 0.03,
                      ),
                      buildFirstSet(size),
                      buildSecondSet(size),
                      buildThirdSet(size),
                      buildFourthSet(size),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedButton(
                          buttoncolor: grey,
                          color: hintLight,
                          press: () {
                            Navigator.pop(context);
                          },
                          width: 2.45,
                          isBorderedButton: true,
                          maxLines: 1,
                          icon: null,
                          multiClick: true,
                          text: stringVariables.close,
                          radius: 25,
                          height: size.height / 50,
                          icons: false,
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0)),
                      CustomElevatedButton(
                          buttoncolor: themeColor,
                          color: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                          press: () async {
                            if (identityVerificationCommonViewModel
                                    ?.viewModelVerification?.kyc?.kycStatus ==
                                "verified") {
                              await identityVerificationCommonViewModel
                                  ?.getIdVerification();
                              takeToEditAd();
                            } else {
                              moveToTradingRequirement(context);
                            }
                          },
                          width: 2.45,
                          isBorderedButton: true,
                          maxLines: 1,
                          icon: null,
                          multiClick: true,
                          text: stringVariables.editDetail,
                          radius: 25,
                          height: size.height / 50,
                          icons: false,
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0)),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstSet(Size size) {
    Advertisement advertisement =
        viewModel.particularAdvertisement?.data?.first ?? dummyAdvertisement;
    bool status =
        advertisement.tradeStatus == stringVariables.published.toLowerCase();
    String id = advertisement.id ?? "";
    updateStatus() {
      if (status) {
        advertisement.tradeStatus = stringVariables.offline.toLowerCase();
      } else {
        advertisement.tradeStatus = stringVariables.published.toLowerCase();
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.adNumber,
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            Row(
              children: [
                CustomContainer(
                  constraints: BoxConstraints(maxWidth: size.width / 2.4),
                  decoration: BoxDecoration(
                    color: status ? green : red,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    child: CustomText(
                      fontfamily: 'InterTight',
                      text: status
                          ? stringVariables.online
                          : stringVariables.offline,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 12,
                      color: white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomSwitch(
                    activeColor: status ? green : red,
                    inactiveColor: switchBackground,
                    toggleColor: white,
                    width: 30,
                    toggleSize: 15,
                    padding: 3,
                    value: status,
                    onToggle: (value) async {
                      String tradeStatus = "";
                      if (status) {
                        tradeStatus = stringVariables.offline.toLowerCase();
                      } else {
                        tradeStatus = stringVariables.published.toLowerCase();
                      }
                      await viewModel?.editAdTradeStatus(
                          id, tradeStatus, updateStatus);
                      viewModel.fetchUserAdvertisement();
                    }),
              ],
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: id,
              color: hintLight,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: '${id}')).then((_) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  customSnackBar.showSnakbar(context,
                      stringVariables.copySnackBar, SnackbarType.positive);
                });
              },
              child: SvgPicture.asset(
                copy,
              ),
            )
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildSecondSet(Size size) {
    Advertisement advertisement =
        viewModel.particularAdvertisement?.data?.first ?? dummyAdvertisement;
    String adType = capitalize(advertisement.advertisementType!);
    String price = (advertisement.price ?? 0.0).toString();
    String priceType = capitalize((advertisement.priceType ?? ""));
    String floatingPrice =
        (advertisement.floatingPriceMargin ?? 0.0).toString();
    String cryptoCurrency = adType == stringVariables.buy
        ? advertisement.toAsset!
        : advertisement.fromAsset!;
    String fiatCurrency = adType == stringVariables.buy
        ? advertisement.fromAsset!
        : advertisement.toAsset!;
    String exchangeRate = viewModel.highestPrice.toString();
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: adType,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
              color: adType == stringVariables.buy ? green : red,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: cryptoCurrency,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.p2pWith,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
            CustomSizedBox(
              width: 0.01,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: fiatCurrency,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
              fontsize: 16,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.price,
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: priceType +
                  (priceType == stringVariables.floating
                      ? " $floatingPrice%"
                      : ""),
              fontsize: 16,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: "$price $fiatCurrency",
              fontsize: 24,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(
            stringVariables.exchangeRate, exchangeRate + " $fiatCurrency"),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildThirdSet(Size size) {
    Advertisement advertisement =
        viewModel.particularAdvertisement?.data?.first ?? dummyAdvertisement;
    String total = trimDecimals((advertisement.amount ?? 0.0).toString());
    String limit =
        trimDecimals((advertisement.minTradeOrder ?? 0.0).toString()) +
            " - " +
            trimDecimals((advertisement.maxTradeOrder ?? 0.0).toString());
    String adType = capitalize(advertisement.advertisementType!);
    num? filledAmount = advertisement.filledAmount;
    String cryptoCurrency = adType == stringVariables.buy
        ? advertisement.toAsset!
        : advertisement.fromAsset!;
    String fiatCurrency = adType == stringVariables.buy
        ? advertisement.fromAsset!
        : advertisement.toAsset!;
    int timeLimit = advertisement.paymentTimeLimit?.toInt() != 60
        ? advertisement.paymentTimeLimit?.toInt() ?? 0
        : 1;
    List<PaymentMethod> paymentMethod = (advertisement.paymentMethod ?? []);
    List<Widget> paymentCard = [];
    int paymentCardListCount = paymentMethod.length;
    for (var i = 0; i < paymentCardListCount; i++) {
      paymentCard.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          paymentMethodsCard(size, paymentMethod[i].paymentMethodName!),
        ],
      ));
    }
    return Column(
      children: [
        buildItemCard(
            stringVariables.totalTradingAmount, total + " $cryptoCurrency"),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(stringVariables.limit, limit + " $fiatCurrency"),
        CustomSizedBox(
          height: 0.02,
        ),
        filledAmount != null
            ? Column(
                children: [
                  buildItemCard(
                      stringVariables.completedTradingAmount,
                      trimDecimals(filledAmount.toString()) +
                          " $cryptoCurrency"),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                ],
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.paymentMethod,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Wrap(
                children: paymentCard,
              ),
            )
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildItemCard(
          stringVariables.paymentTimeLimit,
          "$timeLimit ${timeLimit == 1 ? stringVariables.hours : stringVariables.minutes}",
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(
          color: divider,
          thickness: 0.2,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget buildFourthSet(Size size) {
    Advertisement advertisement =
        viewModel.particularAdvertisement?.data?.first ?? dummyAdvertisement;
    String terms = advertisement.remarks ?? "";
    String date = getDate(
        (advertisement.modifiedDate ?? DateTime.now().toUtc()).toString());
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.createdDate,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: date,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.counterparty,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.completedKyc,
              fontsize: 14,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.conditions,
              fontsize: 14,
              fontWeight: FontWeight.w400,
              color: hintLight,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              constraints: BoxConstraints(maxWidth: size.width / 1.5),
              child: CustomText(
                fontfamily: 'InterTight',
                text: terms.isEmpty ? "---" : terms,
                fontsize: 14,
                fontWeight: FontWeight.w400,
                maxlines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildItemCard(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          text: title,
          fontsize: 14,
          fontWeight: FontWeight.w400,
          color: hintLight,
        ),
        CustomText(
          fontfamily: 'InterTight',
          text: value,
          fontsize: 14,
          fontWeight: FontWeight.w400,
        )
      ],
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.adDetails,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'InterTight',
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
