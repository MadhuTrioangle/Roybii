import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/debugPrint.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomElevatedButton.dart';
import 'package:zodeakx_mobile/ZodeakX/DashBoardScreen/Model/DashBoardModel.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCheckedBox.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../launch_pad_home_page/model/fetch_projects_model.dart';
import '../view_model/launchpad_project_detail_view_model.dart';

class LaunchpadCommitModel extends ModalRoute {
  late LaunchpadProjectDetailViewModel viewModel;
  late WalletViewModel walletViewModel;
  late BuildContext context;
  late num balance;
  late FocusNode amountFocusNode;

  LaunchpadCommitModel(BuildContext context) {
    this.context = context;
    viewModel =
        Provider.of<LaunchpadProjectDetailViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String crypto = datum.holdingCurrency ?? "";
    DashBoardBalance dashBoardBalance = walletViewModel
            .viewModelDashBoardBalance
            ?.where((element) => element.currencyCode == crypto)
            .first ??
        DashBoardBalance();
    balance = dashBoardBalance?.availableBalance ?? 0;
    amountFocusNode = FocusNode();
    viewModel.amountController.clear();
    validator(viewModel.amountKey, amountFocusNode);
    viewModel.setActive(false);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => black.withOpacity(0.6);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  Future<bool> pop() async {
    Navigator.pop(context, false);
    return false;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    viewModel = context.watch<LaunchpadProjectDetailViewModel>();
    Size size = MediaQuery.of(context).size;
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    String id = datum.id ?? "";
    String crypto = datum.holdingCurrency ?? "";
    num limit = viewModel.avgBalance?.avgBalance ?? 0;
    return WillPopScope(
      onWillPop: pop,
      child: Provider(
        create: (context) => viewModel,
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                IgnorePointer(
                  ignoring: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CustomContainer(
                        //  height: isSmallScreen(context) ? 1.85 : 2.1,
                          width: 1.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: themeSupport().isSelectedDarkMode()
                                ? card_dark
                                : white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width / 20,
                                vertical: size.width / 35),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomSizedBox(
                                      height: 0.02,
                                    ),
                                    CustomText(
                                        align: TextAlign.center,
                                        text:
                                            stringVariables.commit + " $crypto",
                                        fontWeight: FontWeight.bold,
                                        fontsize: 18,
                                        fontfamily: 'GoogleSans'),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomSizedBox(
                                          height: 0.04,
                                        ),
                                        buildTextView(
                                            stringVariables.maxCommitmentLimit,
                                            "${trimDecimalsForBalance(limit.toString())} $crypto"),
                                        CustomSizedBox(
                                          height: 0.02,
                                        ),
                                        buildTextView(
                                            stringVariables.spotWalletBalance,
                                            "${trimDecimalsForBalance(balance.toString())} $crypto"),
                                        CustomSizedBox(
                                          height: 0.04,
                                        ),
                                        buildAmountField(),
                                        CustomSizedBox(
                                          height: 0.005,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    checkBoxWithText(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: CustomElevatedButton(
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              text: stringVariables.cancel,
                                              color: black,
                                              press: () {
                                                Navigator.pop(context, true);
                                              },
                                              radius: 25,
                                              buttoncolor: enableBorder,
                                              width: 1.3,
                                              height: 16,
                                              isBorderedButton: false,
                                              maxLines: 1,
                                              icons: false,
                                              multiClick: true,
                                              icon: null),
                                        ),
                                        CustomSizedBox(
                                          width: 0.02,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: CustomElevatedButton(
                                              blurRadius: 0,
                                              spreadRadius: 0,
                                              text: stringVariables.commitNow,
                                              color: viewModel.checkAlert
                                                  ? themeSupport()
                                                          .isSelectedDarkMode()
                                                      ? black
                                                      : white
                                                  : black,
                                              press: () {
                                                if (viewModel.checkAlert) {
                                                  if (viewModel.amountController
                                                      .text.isEmpty) {
                                                    viewModel
                                                        .amountKey.currentState!
                                                        .validate();
                                                    return;
                                                  }
                                                  viewModel
                                                      .subscribeProject(id);
                                                  Navigator.pop(context, true);
                                                }
                                              },
                                              radius: 25,
                                              buttoncolor: viewModel.checkAlert
                                                  ? themeColor
                                                  : enableBorder,
                                              width: 1.3,
                                              height: 16,
                                              isBorderedButton: false,
                                              maxLines: 1,
                                              icons: false,
                                              multiClick: true,
                                              icon: null),
                                        ),
                                      ],
                                    ),
                                    CustomSizedBox(
                                      height: 0.015,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextView(String title, String value) {
    var amount = trimDecimalsForBalance(value.split(" ").first.toString());
    var currency = value.split(" ").last;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
            text: title,
            fontWeight: FontWeight.w500,
            fontsize: 14,
            color: hintLight,
            fontfamily: 'GoogleSans'),
        CustomText(
            text: "$amount $currency",
            fontWeight: FontWeight.w500,
            fontsize: 14,
            fontfamily: 'GoogleSans'),
      ],
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget buildAmountField() {
    Datum datum = viewModel.fetchProjects?.result?.data?.first ?? Datum();
    num limit = viewModel.avgBalance?.avgBalance ?? 0;
    num minAmount = datum.minimumCommitment ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            text: stringVariables.amount,
            fontWeight: FontWeight.w500,
            fontsize: 12,
            fontfamily: 'GoogleSans'),
        CustomSizedBox(
          height: 0.0075,
        ),
        CustomTextFormField(
          autovalid: AutovalidateMode.onUserInteraction,
          controller: viewModel.amountController,
          keys: viewModel.amountKey,
          focusNode: amountFocusNode,
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
          inputFormatters: [
           // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if ((value ?? "").isEmpty) {
              return stringVariables.enterAmount;
            } else if (isNumeric(value ?? "")) {
              if (double.parse(value ?? "0") < minAmount) {
                return stringVariables.minimumAmountIs + " $minAmount";
              } else if (double.parse(value ?? "0") > limit) {
                return stringVariables.maximumAmountIs + " $limit";
              }
            }
            return null;
          },
          padLeft: 0,
          padRight: 0,
          isContentPadding: false,
          contentPadding: EdgeInsets.only(left: 20, right: 10),
          size: 30,
          text: stringVariables.enterAmount,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.amountController.text = balance.toString();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: CustomContainer(
                    padding: 5,
                    child: CustomText(
                      fontfamily: 'GoogleSans',
                      text: stringVariables.max,
                      color: themeColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget checkBoxWithText() {
    return Transform.translate(
      offset: Offset(-10, 0),
      child: Row(
        children: [
          CustomCheckBox(
            checkboxState: viewModel.checkAlert,
            toggleCheckboxState: (val) {
              viewModel.setActive(val!);
            },
            activeColor: themeColor,
            checkColor: Colors.white,
            borderColor: enableBorder,
          ),
          CustomText(text: stringVariables.checkboxCondition)
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return FadeTransition(
      opacity: animation,
      // add slide animation
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
