import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';
import 'package:zodeakx_mobile/staking/home_page/model/stacking_home_page_model.dart';

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
import '../../../Utils/Widgets/CustomOutLineButton.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../increase_balance_bottom_sheet/view/increase_balance_bottom_sheet_view.dart';
import '../viewModel/stacking_creation_view_model.dart';

class StackingCreationView extends StatefulWidget {
  final String viewType;
  final GetAllActiveStatus? activeStakesList;

  const StackingCreationView(
      {Key? key, required this.viewType, this.activeStakesList})
      : super(key: key);

  @override
  State<StackingCreationView> createState() => _StackingCreationViewState();
}

class _StackingCreationViewState extends State<StackingCreationView> {
  late StackingCreationViewModel viewModel;
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormFieldState> amountFieldKey = GlobalKey<FormFieldState>();
  String? currentDate;
  String? nextDay;
  int? interestPeriod;
  int? redemptionPeriod;
  int? lockedDuration;
  String? interestDistributionDate;
  String? interestEndDate;
  String? redemptionDate;

  @override
  void initState() {
    viewModel = Provider.of<StackingCreationViewModel>(context, listen: false);
    viewModel.getDashBoardBalance(widget.activeStakesList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setSelectPlan(0);
      if (widget.activeStakesList?.isFlexible == true) {
        viewModel
            .setAprValue(widget.activeStakesList!.flexibleInterest ?? 0);
        viewModel.setlockedDurationValue(
            widget.activeStakesList!.flexibleInterest!.toInt());
        viewModel.setPlanId('${widget.activeStakesList!.id}');
      } else {
        viewModel
            .setAprValue(widget.activeStakesList!.childs!.first.apr ?? 0);
        viewModel.setlockedDurationValue(
            widget.activeStakesList!.childs!.first.lockedDuration!.toInt());
        viewModel.setPlanId('${widget.activeStakesList!.childs!.first.id}');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<StackingCreationViewModel>();
    return Provider<StackingCreationViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return confirmStakes(
          context,
        );
      },
    );
  }

  Widget confirmStakes(BuildContext context) {
    return CustomScaffold(
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
                    viewModel.setActive(false);
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
                  text:
                      '${widget.activeStakesList?.stakeCurrencyDetails?.code.toString()}' +
                          ' ' +
                          stringVariables.subscribe,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: SingleChildScrollView(child: detailsCard()),
    );
  }

  Widget detailsCard() {
    return CustomCard(
      radius: 15,
      outerPadding: 15,
      edgeInsets: 8,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              upperCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget upperCard() {
    GetBalance? getBalance = viewModel.getBalance;
    var DetailsForCoin = getBalance?.result
        ?.where((e) =>
    e.currencyCode == widget.activeStakesList?.stakeCurrencyDetails?.code)
        .toList();
    String? currencyName = DetailsForCoin?.first.currencyName;
    num? totalBalance = DetailsForCoin?.first.totalBalance;
    num? availableBalance = DetailsForCoin?.first.availableBalance;
    num? inorderBalance = DetailsForCoin?.first.inorderBalance;
    num? mlmBalance = DetailsForCoin?.first.mlmStakeBalance;
    String? currencyCode = DetailsForCoin?.first.currencyCode;
    CurrencyType? currencyType = DetailsForCoin?.first.currencyType;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomText(
              text: stringVariables.duration +
                  ' (' +
                  stringVariables.days +
                  ") " +
                  "& " +
                  stringVariables.apr,
              color: stackText,
              align: TextAlign.start,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        widget.viewType == stringVariables.locked
            ? CustomOutlineButton(
                text: stringVariables.flexbile,
                width: 1.1,
                height: 15,
                isBorderedButton: false,
                color: themeSupport().isSelectedDarkMode() ? white : black,
                borderWidth: 1.5,
              )
            : planCard(),
        CustomSizedBox(
          height: 0.02,
        ),
        Column(
          children: [
            Row(
              children: [
                CustomText(text: stringVariables.apr + '  ', color: stackText),
                CustomText(text: '${viewModel.aprValue}%'),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            GestureDetector(
              onTap: () {
                constant.walletCurrency.value = '${currencyCode}';
                moveToCoinDetailsView(context,currencyName,totalBalance.toString(),availableBalance.toString(),
                    currencyCode,currencyType.toString(),inorderBalance.toString(),mlmBalance.toString(),);
               // _showIncreaseBalanceBottomSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                      text: stringVariables.subscription +
                          ' ' +
                          stringVariables.amount,
                      color: stackText),
                  CustomText(
                      text: stringVariables.get.toUpperCase() +
                          ' ${widget.activeStakesList?.stakeCurrencyDetails?.code.toString() ?? stringVariables.coinSymbol}',
                      color: themeColor),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            minMaxCard(),
            CustomSizedBox(
              height: 0.02,
            ),
            balanceSection(),
            CustomSizedBox(
              height: 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(
                  text: stringVariables.summary,
                  fontsize: 15,
                  color: stackCardText,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            flexibleRewardSection(),
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
              buttoncolor: themeColor,
              width: 0.0,
              blurRadius: 13,
              spreadRadius: 1,
              height: MediaQuery.of(context).size.height / 50,
              isBorderedButton: false,
              maxLines: 1,
              icons: false,
              multiClick: true,
              icon: null,
              color: black,
              press: () {
                bool flexible = false;
                if (widget.activeStakesList!.isFlexible == true &&
                    viewModel.selectPlan == 0) {
                  flexible = true;
                } else {
                  flexible = false;
                }
                if (amountController.text.isEmpty) {
                  CustomSnackBar().showSnakbar(
                      context,
                      '${stringVariables.pleaseFillFields}',
                      SnackbarType.negative);
                } else {
                  if (viewModel.checkBoxStatus == true) {
                    if (getAvailableQuota() == "0") {
                      CustomSnackBar().showSnakbar(
                          context,
                          stringVariables.availaleQuotaLimitReach +
                              " " +
                              getAvailableQuota() +
                              '${widget.activeStakesList?.stakeCurrencyDetails?.code}',
                          SnackbarType.negative);
                    } else {
                      viewModel.stackingCreation(
                          amountController.text,
                          flexible,
                          '${widget.activeStakesList?.id}',
                          interestDistributionDate,
                          viewModel.planId,
                          interestEndDate,
                          redemptionDate,
                          '${widget.activeStakesList!.stakeCurrencyDetails!.code}');
                    }
                  } else {
                    CustomSnackBar().showSnakbar(
                        context,
                        '${stringVariables.checkboxCondition}',
                        SnackbarType.negative);
                  }
                }
              },
            ),
            CustomSizedBox(
              height: 0.02,
            ),
          ],
        )
      ],
    );
  }

  Widget planCard() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: chipsCard(),
      ),
    );
  }

  Widget minMaxCard() {
    return CustomTextFormField(
      autovalid: AutovalidateMode.onUserInteraction,
      controller: amountController,
      keys: amountFieldKey,
      padRight: 0,
      isBorder: true,
      padLeft: 0,
      color: themeSupport().isSelectedDarkMode() ? black : grey,
      isContentPadding: false,
      onChanged: (value) => {
        if (value.length > 0)
          {viewModel.setEstimatedValue(amountController.text)}
        else
          {viewModel.setEstimatedValue('0')}
      },
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
      ],
      suffixIcon: CustomContainer(
        width: 3.5,
        child: Row(
          children: [
            CustomCircleAvatar(
              radius: 10,
              backgroundColor: Colors.transparent,
              child: Image.asset(splash),
            ),
            CustomText(
              text: " " +
                  ' ${widget.activeStakesList?.stakeCurrencyDetails?.code.toString() ?? stringVariables.coinSymbol}' +
                  "  ",
              color: stackCardText,
              fontWeight: FontWeight.w500,
              fontsize: 13,
            ),
            GestureDetector(
              onTap: () {
                amountController.text = viewModel.maxStakeAmount.toString();
                viewModel
                    .setEstimatedValue(viewModel.maxStakeAmount.toString());
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    fontfamily: 'GoogleSans',
                    text: stringVariables.max,
                    color: themeColor,
                    fontsize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      size: 0,
      text: stringVariables.minimum +
          " " +
          '${viewModel.minStakeAmount}' +
          " " +
          stringVariables.coinSymbol,
    );
  }

  Widget balanceSection() {
    return Column(
      children: [
        Column(
          children: [
            balanceWithTitle(stringVariables.availableBalance,
                viewModel.availableBalance.toString()),
            CustomSizedBox(
              height: 0.01,
            ),
            balanceWithTitle(
                stringVariables.availableQuota, getAvailableQuota()),
            CustomSizedBox(
              height: 0.01,
            ),
            balanceWithTitle(stringVariables.totalPersonalQuota,
                '${widget.activeStakesList?.totalPersonalQuota}'),
          ],
        )
      ],
    );
  }

  Widget balanceWithTitle(
    String title,
    String value,
  ) {
    return Row(
      children: [
        CustomText(
          text: title + ": ",
          color: stackCardText,
        ),
        CustomText(
          text: value,
          fontsize: 15,
          fontWeight: FontWeight.w600,
        ),
        CustomText(
          text:
              '${widget.activeStakesList?.stakeCurrencyDetails?.code.toString() ?? stringVariables.coinSymbol}',
          fontsize: 15,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }

  Widget rewardSection() {
    return CustomCard(
      radius: 15,
      edgeInsets: 0,
      outerPadding: 0,
      elevation: 0,
      color: themeSupport().isSelectedDarkMode() ? black : grey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CustomText(
                  text: stringVariables.estimatedRewardHeading + " ",
                  color: stackCardText,
                ),
                Icon(
                  Icons.info,
                  color: stackText,
                  size: 18,
                )
              ],
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: stringVariables.realTimeAprRewards + " ",
                  color: stackCardText,
                ),
                CustomText(
                  text: "0 " + stringVariables.coinSymbol + " ",
                  color: green,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: stringVariables.bonusTieredAprRewards + " ",
                  color: stackCardText,
                ),
                CustomText(
                  text: "0 " + stringVariables.coinSymbol + " ",
                  color: green,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomText(
              text: stringVariables.estimatedRewardFooter,
              color: stackText,
              fontsize: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget flexibleRewardSection() {
    currentDate = getTimeForstake(DateTime.now().toString());
    securedPrint('currentDate${currentDate}');
    nextDay = getTimeForstake(DateTime.now()
        .add(Duration(
      days: 1,
    ))
        .toString());
    interestPeriod = widget.activeStakesList!.interestPeriod!.toInt();
    redemptionPeriod = widget.activeStakesList!.redemptionPeriod!.toInt();
    lockedDuration = viewModel.lockedDurationValue;
    interestDistributionDate = getTimeForstake(DateTime.now()
        .add(Duration(
      days: interestPeriod! + 1,
    ))
        .toString());
    interestEndDate = getTimeForstake(
        DateTime.now().add(Duration(days: lockedDuration! + 1)).toString());
    redemptionDate = getTimeForstake(DateTime.now()
        .add(Duration(days: lockedDuration! + 1 + redemptionPeriod!))
        .toString());
    securedPrint('nextDay${nextDay}');
    securedPrint('redemptionDate${redemptionDate}');
    securedPrint(
        ' viewModel.lockedDurationValue${viewModel.lockedDurationValue}');
    securedPrint('interestEndDate${lockedDuration! + 1}');
    return CustomCard(
      radius: 15,
      edgeInsets: 0,
      outerPadding: 0,
      elevation: 0,
      color: themeSupport().isSelectedDarkMode() ? black : grey,
      child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (widget.activeStakesList!.isFlexible == true &&
                  viewModel.selectPlan == 0) ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.stakeDate,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: currentDate!,
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.valueDate,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: nextDay!,
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.interestDistributionDate,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: interestDistributionDate!,
                        fontsize: 13,
                      ),
                    ],
                  ),
                ],
              )    :   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.stakeDate,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: currentDate!,
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.valueDate,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: nextDay!,
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.interestPeriod,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: interestPeriod.toString(),
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.interestEndDate,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: interestEndDate!,
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.redemptionPeriod,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: redemptionPeriod.toString(),
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round(), line()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.redemptionDate,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: redemptionDate!,
                        fontsize: 13,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [round()],
                          ),
                          CustomSizedBox(
                            width: 0.02,
                            height: 0,
                          ),
                          CustomText(
                            text: stringVariables.estAPR,
                            color: stackCardText,
                            fontsize: 13,
                          ),
                        ],
                      ),
                      CustomText(
                        text: '${widget.activeStakesList?.flexibleInterest}',
                        fontsize: 13,
                      ),
                    ],
                  ),
                ],
              )
              ,
              (widget.activeStakesList!.isFlexible == true &&
                  viewModel.selectPlan == 0)
                  ? CustomSizedBox()
                  : Column(children: [
                CustomSizedBox(
                  height: 0.015,
                ),
                Divider(
                  color: stackDivider,
                  thickness: 1.5,
                  height: 5,
                ),
                CustomSizedBox(
                  height: 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: stringVariables.estimatedValue,
                      color: stackCardText,
                      fontsize: 13,
                    ),
                    CustomText(
                      text: amountController.text.isNotEmpty
                          ? trimDecimalsForBalance(
                          viewModel.interestAmount.toString()) +
                          " " +
                          widget.activeStakesList!
                              .stakeCurrencyDetails!.code
                              .toString()
                          : '0.00' +
                          ' ' +
                          widget.activeStakesList!
                              .stakeCurrencyDetails!.code
                              .toString(),
                      color: green,
                      fontsize: 13,
                    )
                  ],
                ),
              ])
            ],
          )),
    );
  }

  Widget checkBoxWithText() {
    return Row(
      children: [
        CustomCheckBox(
          checkboxState: viewModel.checkAlert,
          toggleCheckboxState: (val) {
            viewModel.checkBoxStatus = val ?? false;
            viewModel.setActive(val!);
          },
          activeColor: themeColor,
          checkColor: Colors.white,
          borderColor: enableBorder,
        ),
        CustomText(text: stringVariables.checkboxCondition)
      ],
    );
  }

  List<Widget> chipsCard() {
    List<Widget> planList = [];
    int planListCount = viewModel.planDetails.length;

    for (var i = 0; i < planListCount; i++) {
      planList.add(chipsColor(viewModel.planDetails[i]));
    }
    return planList;
  }

  Widget chipsColor(String text) {
    int index = viewModel.planDetails.indexOf(text);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {
          securedPrint(
              "${index} ${widget.activeStakesList?.isFlexible},${text},${viewModel.planDetails}");
          if (widget.activeStakesList?.isFlexible == true && index == 0) {
            viewModel.setAprValue(
                (widget.activeStakesList!.flexibleInterest ?? 0));
            viewModel.setlockedDurationValue(
                widget.activeStakesList!.flexibleInterest!.toInt());
            viewModel.setPlanId('${widget.activeStakesList!.id}');

            securedPrint("hi${widget.activeStakesList?.flexibleInterest}");
          } else {
            List<Child>? childs = widget.activeStakesList?.childs
                ?.where((element) => element.lockedDuration.toString() == text)
                .toList();
            int flexibleIndex =
                widget.activeStakesList?.childs?.indexOf(childs!.first) ?? 0;
            if (amountController.text.isNotEmpty) {
              viewModel.setEstimatedValue(amountController.text);
            }
            viewModel.setPlanId(
                '${widget.activeStakesList!.childs![flexibleIndex].id}');
            viewModel.setAprValue(
                (widget.activeStakesList!.childs![flexibleIndex].apr ?? 0));
            viewModel.setlockedDurationValue(widget
                .activeStakesList!.childs![flexibleIndex].lockedDuration!
                .toInt());
            securedPrint(
                "hi${widget.activeStakesList?.childs?[flexibleIndex].apr}");
          }

          viewModel.setSelectPlan(index);
        },
        child: CustomContainer(
            height: 25,
            width: 6,
            decoration: BoxDecoration(
                border: Border.all(
                  color: viewModel.selectPlan == index
                      ? themeColor
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(5),
                color: themeSupport().isSelectedDarkMode() ? black : grey),
            child: Center(
                child: CustomText(
              text: text,
            ))),
      ),
    );
  }

  Widget round() {
    return CustomContainer(
      height: 75,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: green, width: 1.8)),
    );
  }

  line() {
    return CustomContainer(
      height: 25,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: themeColor,
      ),
    );
  }

  dynamic _showIncreaseBalanceBottomSheet(BuildContext context) async {
    final result = await Navigator.of(context).push(IncreaseBalanceBottomSheet(
      context,
    ));
  }

  String getAvailableQuota() {
    num availableQuota = viewModel.availableQuota;
    if (availableQuota <= 0) {
      availableQuota = 0;
    } else {
      availableQuota = viewModel.availableQuota;
    }
    return availableQuota.toString();
  }
}
