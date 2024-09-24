import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/staking/balance/model/ActiveUserStakesModel.dart';

import '../../../Common/Wallets/ViewModel/WalletViewModel.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../ZodeakX/MarketScreen/ViewModel/MarketViewModel.dart';
import '../viewModel/staking_redemption_view_model.dart';

class StakingRedemptionView extends StatefulWidget {
  final StakeItem userStakeDetail;

  const StakingRedemptionView({Key? key, required this.userStakeDetail})
      : super(key: key);

  @override
  State<StakingRedemptionView> createState() => _StakingRedemptionViewState();
}

class _StakingRedemptionViewState extends State<StakingRedemptionView> {
  late StakingRedemptionViewModel viewModel;
  late WalletViewModel walletViewModel;
  late MarketViewModel marketViewModel;
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormFieldState> amountFieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    viewModel = Provider.of<StakingRedemptionViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    marketViewModel = Provider.of<MarketViewModel>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setCheckAlert(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<StakingRedemptionViewModel>();
    Size size = MediaQuery.of(context).size;
    return Provider<StakingRedemptionViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return stakingRedemption(context, size);
      },
    );
  }

  Widget stakingRedemption(BuildContext context, Size size) {
    return CustomScaffold(
      appBar: buildAppBar(context),
      child: buildStakingRedemption(size),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    String crypto = "BTC";
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
                overflow: TextOverflow.ellipsis,
                maxlines: 1,
                softwrap: true,
                fontfamily: 'GoogleSans',
                fontsize: 21,
                fontWeight: FontWeight.bold,
                text: crypto + ' ' + stringVariables.redemption,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStakingRedemption(Size size) {
    return CustomCard(
      radius: 15,
      outerPadding: 15,
      edgeInsets: 15,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(child: upperView(size))),
          bottomView()
        ],
      ),
    );
  }

  Widget upperView(Size size) {
    StakeItem userStakeDetail = widget.userStakeDetail;
    String cryptoCurrency = userStakeDetail.rewardCurrencyDetails?.code ?? "";
    String amount = userStakeDetail.stakeAmount.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.005,
        ),
        CustomText(
          text: stringVariables.redemptionAmount,
          color: textGrey,
          fontfamily: 'GoogleSans',
          fontsize: 14,
          fontWeight: FontWeight.w400,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        minMaxCard(cryptoCurrency, amount),
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          children: [
            CustomText(
              text: stringVariables.available + ": ",
              color: textGrey,
              fontfamily: 'GoogleSans',
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
            CustomText(
              text: "$amount ",
              fontfamily: 'GoogleSans',
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
            CustomText(
              text: cryptoCurrency,
              color: textGrey,
              fontfamily: 'GoogleSans',
              fontsize: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.01,
        ),
        CustomText(
          text: stringVariables.summary,
          fontsize: 16,
          fontfamily: 'GoogleSans',
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        buildRedemptionAmountView(size)
      ],
    );
  }

  Widget buildRedemptionAmountView(size) {
    String redemptionSubmitted = getTimeForstake(DateTime.now().toString());
    DateTime redemptionDate = DateTime.now()
        .add(Duration(days: widget.userStakeDetail.lockedDuration ?? 0));
    String estimatedReturnDate = getTimeForstake(redemptionDate.toString());
    String estValue = "0.0003434";
    String crypto = "BTC";
    return CustomContainer(
        width: 1,
        height: 8,
        decoration: BoxDecoration(
          color: themeSupport().isSelectedDarkMode()
              ? switchBackground.withOpacity(0.15)
              : enableBorder.withOpacity(0.35),
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  buildCircleWithLine(size),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextForRedemption(stringVariables.submissionDate,
                            redemptionSubmitted),
                        CustomSizedBox(
                          height: 0.03,
                        ),
                        buildTextForRedemption(
                            stringVariables.estimatedReturnDate,
                            estimatedReturnDate),
                      ],
                    ),
                  )
                ],
              ),
              // Divider(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     CustomText(
              //       fontfamily: 'GoogleSans',
              //       fontsize: 16,
              //       fontWeight: FontWeight.w400,
              //       text: stringVariables.estimatedValue,
              //       color: hintLight,
              //     ),
              //     CustomText(
              //       fontfamily: 'GoogleSans',
              //       fontsize: 14,
              //       fontWeight: FontWeight.w400,
              //       text: estValue + " $crypto",
              //       color: green,
              //     ),
              //   ],
              // ),
            ],
          ),
        ));
  }

  Widget buildTextForRedemption(String content1, String content2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          fontsize: 16,
          fontWeight: FontWeight.w400,
          text: content1,
          color: hintLight,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: CustomText(
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontsize: 14,
            fontWeight: FontWeight.w400,
            text: content2,
          ),
        ),
      ],
    );
  }

  Widget buildCircleWithLine(size) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      circleInsideCircle(),
      CustomContainer(
        width: size.width,
        height: 23,
        color: themeColor,
      ),
      circleInsideCircle(),
    ]);
  }

  Widget circleInsideCircle() {
    return CustomCircleAvatar(
        radius: 3.5,
        backgroundColor: green,
        child: CustomCircleAvatar(
          radius: 2,
          backgroundColor: white,
          child: CustomSizedBox(
            width: 0,
            height: 0,
          ),
        ));
  }

  Widget bottomView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizedBox(
          height: 0.01,
        ),
        checkBoxWithText(),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomElevatedButton(
          text: stringVariables.confirm.toUpperCase(),
          radius: 25,
          buttoncolor: viewModel.checkAlert ? themeColor : enableBorder,
          width: 0.0,
          blurRadius: 0,
          spreadRadius: 0,
          height: MediaQuery.of(context).size.height / 50,
          isBorderedButton: false,
          maxLines: 1,
          icons: false,
          icon: null,
          color: viewModel.checkAlert ? black : hintLight,
          multiClick: true,
          press: () {
            // String id = widget.userStakeDetail.sId ?? "";
            // if (viewModel.checkAlert) viewModel.requestForRedeem(id);
            moveToRedemptionSuccessful(context);
          },
        ),
        CustomSizedBox(
          height: 0.01,
        ),
      ],
    );
  }

  Widget minMaxCard(String cryptoCurrency, String amount) {
    return CustomContainer(
      width: 1,
      height: 12.5,
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode()
            ? switchBackground.withOpacity(0.15)
            : enableBorder.withOpacity(0.35),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: CustomTextFormField(
        autovalid: AutovalidateMode.onUserInteraction,
        controller: amountController,
        text: amount,
        keys: amountFieldKey,
        hintfontweight: FontWeight.bold,
        hintfontsize: 16,
        padRight: 0,
        isReadOnly: true,
        isBorder: true,
        padLeft: 0,
        isContentPadding: false,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        ],
        suffixIcon: CustomContainer(
          width: 3.5,
          height: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCircleAvatar(
                radius: 10,
                backgroundColor: Colors.transparent,
                child: FadeInImage.assetNetwork(
                  image: getImage(cryptoCurrency),
                  placeholder: splash,
                ),
              ),
              CustomText(
                text: " " + cryptoCurrency + "  ",
                color: stackCardText,
                fontfamily: 'GoogleSans',
                fontWeight: FontWeight.w500,
                fontsize: 14,
              ),
              CustomSizedBox(
                width: 0.04,
              )
            ],
          ),
        ),
        size: 0,
      ),
    );
  }

  String getImage(String crypto) {
    List<dynamic> list = [];
    list = constant.userLoginStatus.value
        ? (walletViewModel.viewModelDashBoardBalance != null)
            ? (walletViewModel.viewModelDashBoardBalance!.isNotEmpty)
                ? walletViewModel.viewModelDashBoardBalance!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : []
        : (marketViewModel.getCurrencies != null)
            ? (marketViewModel.getCurrencies!.isNotEmpty)
                ? marketViewModel.getCurrencies!
                    .where((element) => element.currencyCode == crypto)
                    .toList()
                : []
            : [];
    return (list == null || list.isEmpty) ? "" : list.first.image;
  }

  Widget checkBoxWithText() {
    return Row(
      children: [
        CustomCheckBox(
          checkboxState: viewModel.checkAlert,
          toggleCheckboxState: (val) {
            viewModel.setCheckAlert(val ?? false);
          },
          activeColor: themeColor,
          checkColor: Colors.white,
          borderColor: enableBorder,
        ),
        CustomText(text: stringVariables.checkboxCondition)
      ],
    );
  }
}
