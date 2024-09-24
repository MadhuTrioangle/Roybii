import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/ads/view_model/p2p_ads_view_model.dart';
import 'package:zodeakx_mobile/p2p/home/model/p2p_advertisement.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';

class P2PSuccessfullyPostedView extends StatefulWidget {

  const P2PSuccessfullyPostedView({Key? key,})
      : super(key: key);

  @override
  State<P2PSuccessfullyPostedView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PSuccessfullyPostedView>
    with TickerProviderStateMixin {
  late P2PAdsViewModel viewModel;

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
     WidgetsBinding.instance.addPostFrameCallback((_) {
       viewModel.setLoading(true);
       viewModel.fetchUserAdvertisement();
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
            : buildP2PSuccessfullyPostedView(size),
      ),
    );
  }

  Widget buildP2PSuccessfullyPostedView(Size size) {
    Advertisement advertisement =
        viewModel.p2pAdvertisement?.data?.first ?? dummyAdvertisement;
    String adNo = advertisement.id ?? "";
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSubHeader(size),
          CustomSizedBox(
            height: 0.01,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: CustomContainer(
              width: 1,
              height: 1,
              child: CustomCard(
                outerPadding: 0,
                edgeInsets: 0,
                radius: 25,
                elevation: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
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
                                  height: 0.02,
                                ),
                                buildTextField(
                                    stringVariables.adNumber, adNo, true),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildOrderDetailsCard(size),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            CustomSizedBox(
                              height: 0.02,
                            ),
                            CustomElevatedButton(
                                buttoncolor: themeColor,
                                color: black,
                                press: () {
                                  int count = 0;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                                width: 1,
                                isBorderedButton: true,
                                maxLines: 1,
                                icon: null,
                                multiClick: true,
                                text: stringVariables.done,
                                radius: 25,
                                height: size.height / 50,
                                icons: false,
                                blurRadius: 0,
                                spreadRadius: 0,
                                offset: Offset(0, 0)),
                            CustomSizedBox(
                              height: 0.02,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderDetailsCard(Size size) {
    Advertisement advertisement =
        viewModel.p2pAdvertisement?.data?.first ?? dummyAdvertisement;
    String adNo = advertisement.id ?? "";
    String adType = capitalize(advertisement.advertisementType!);
    String cryptoCurrency = adType == stringVariables.buy
        ? advertisement.toAsset!
        : advertisement.fromAsset!;
    double cryptoAmount = advertisement.amount!.toDouble();
    String fiatCurrency = adType == stringVariables.buy
        ? advertisement.fromAsset!
        : advertisement.toAsset!;
    double minAmount = (advertisement.minTradeOrder ?? 0.0).toDouble();
    double maxAmount = (advertisement.maxTradeOrder ?? 0.0).toDouble();
    return GestureDetector(
      onTap: () {
        moveToAdsDetailsView(context, adNo);
      },
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15)
              : enableBorder.withOpacity(0.25),
          border: Border.all(color: hintLight, width: 1),
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        width: 1,
        height: 4.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
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
                      fontfamily: 'GoogleSans',
                      text: cryptoCurrency,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                    ),
                    CustomSizedBox(
                      width: 0.01,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
                      text: stringVariables.p2pWith,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                    ),
                    CustomSizedBox(
                      width: 0.01,
                    ),
                    CustomText(
                      fontfamily: 'GoogleSans',
                      text: fiatCurrency,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 16,
                    ),
                  ],
                ),
                SvgPicture.asset(
                  p2pRightArrow,
                  height: 30,
                  color: hintLight,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                CustomText(
                  fontfamily: 'GoogleSans',
                  text: "$cryptoAmount $cryptoCurrency",
                  fontsize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTextField(
                stringVariables.amount, "$cryptoAmount $cryptoCurrency"),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTextField(
                stringVariables.limit, "$minAmount - $maxAmount $fiatCurrency"),
            CustomSizedBox(
              height: 0.005,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String title, String value, [isBold = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomText(
              fontfamily: 'GoogleSans',
              text: title,
              fontsize: 14,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: isBold ? null : hintLight,
            ),
          ],
        ),
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: value,
              fontsize: 14,
              fontWeight: FontWeight.bold,
            ),
            CustomSizedBox(
              width: 0.02,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSubHeader(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            p2pTick,
            height: 30,
          ),
          CustomSizedBox(
            width: 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                strutStyleHeight: 2,
                fontfamily: 'GoogleSans',
                text: stringVariables.successfullyPosted,
                fontsize: 22,
                fontWeight: FontWeight.bold,
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              CustomContainer(
                width: 1.25,
                child: CustomText(
                  strutStyleHeight: 1.25,
                  fontfamily: 'GoogleSans',
                  text: stringVariables.successfullyPostedContent,
                  fontsize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
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
        ],
      ),
    );
  }
}
