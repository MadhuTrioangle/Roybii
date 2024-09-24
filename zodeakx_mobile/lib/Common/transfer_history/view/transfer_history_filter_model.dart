import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/transfer_history/view/wallet_selection_transfer_history_bottomsheet.dart';
import 'package:zodeakx_mobile/Utils/Constant/App_ConstantIcon.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomContainer.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomText.dart';

import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/debugPrint.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../transfer/viewModel/transfer_view_model.dart';
import '../../wallet_select/viewModel/wallet_select_view_model.dart';
import '../viewModel/transfer_history_view_model.dart';

class TransferHistoryFilterModel extends ModalRoute {
  late TransferHistoryViewModel viewModel;
  late BuildContext context;
  late WalletSelectViewModel walletSelectViewModel;
  late TransferViewModel transferViewModel;

  TransferHistoryFilterModel(
    BuildContext context,
  ) {
    this.context = context;
    viewModel = Provider.of<TransferHistoryViewModel>(context, listen: false);
    transferViewModel = Provider.of<TransferViewModel>(context, listen: false);
    walletSelectViewModel =
        Provider.of<WalletSelectViewModel>(context, listen: false);
    viewModel.setDate();
    transferViewModel.fetchUserFundingWallet("fundingTransferModal");
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
    viewModel = context.watch<TransferHistoryViewModel>();
    walletSelectViewModel = context.watch<WalletSelectViewModel>();
    transferViewModel = context.watch<TransferViewModel>();

    Size size = MediaQuery.of(context).size;
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        width: 1,
                        decoration: BoxDecoration(
                          color: themeSupport().isSelectedDarkMode()
                              ? card_dark
                              : white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              buildHeader(context),
                              CustomSizedBox(
                                height: 0.001,
                              ),
                              buildHeaderWithUnderline(stringVariables.from),
                              Row(
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showModal("from");
                                        //  moveToWalletSelectView(context, stringVariables.fromTransferHistoryModal);
                                      },
                                      child: CustomContainer(
                                        height: size.height / 35,
                                        decoration: BoxDecoration(
                                          color: themeSupport()
                                                  .isSelectedDarkMode()
                                              ? switchBackground
                                                  .withOpacity(0.15)
                                              : enableBorder.withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: CustomText(
                                                fontfamily: 'InterTight',
                                                text: viewModel.firstWallet,
                                                fontsize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Icon(
                                                  Icons.arrow_right,
                                                  color: hintLight,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              buildHeaderWithUnderline(stringVariables.to),
                              Row(
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        _showModal("to");
                                        //   moveToWalletSelectView(context, stringVariables.toTransferHistoryModal);
                                      },
                                      child: CustomContainer(
                                        height: size.height / 35,
                                        decoration: BoxDecoration(
                                          color: themeSupport()
                                                  .isSelectedDarkMode()
                                              ? switchBackground
                                                  .withOpacity(0.15)
                                              : enableBorder.withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: CustomText(
                                                fontfamily: 'InterTight',
                                                text: viewModel.secondWallet,
                                                fontsize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Icon(
                                                  Icons.arrow_right,
                                                  color: hintLight,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              buildHeaderWithUnderline(stringVariables.date),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              buildStartEndDate(
                                size,
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              buildHeaderWithUnderline(stringVariables.coin),
                              Row(
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: CustomContainer(
                                        height: size.height / 35,
                                        decoration: BoxDecoration(
                                          color: themeSupport()
                                                  .isSelectedDarkMode()
                                              ? switchBackground
                                                  .withOpacity(0.15)
                                              : enableBorder.withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: CustomText(
                                                fontfamily: 'InterTight',
                                                text: transferViewModel
                                                    .setCurrencyForFilter,
                                                fontsize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Icon(
                                                  Icons.arrow_right,
                                                  color: hintLight,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomSizedBox(
                                height: 0.03,
                              ),
                              buildButtons()
                            ],
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

  _showModal(String whichWallet) async {
    final result = await Navigator.of(context)
        .push(SelectWalletTransferHistoryBottomSheet(context, whichWallet));
  }

  Widget buildHeaderWithUnderline(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          text: title,
          fontsize: 16,
          color: textGrey,
          fontWeight: FontWeight.w500,
        ),
        CustomSizedBox(
          height: 0.0025,
        ),
        Divider(),
        CustomSizedBox(
          height: 0.0025,
        ),
      ],
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // add fade animation
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      // add scale animation
      child: child,
    );
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CustomText(
                fontfamily: 'InterTight',
                text: stringVariables.filter,
                fontsize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                behavior: HitTestBehavior.opaque,
                child: CustomContainer(
                    width: 18,
                    height: 30,
                    child: SvgPicture.asset(
                      marginClose,
                      color:
                          themeSupport().isSelectedDarkMode() ? white : black,
                    )),
              ),
            )
          ],
        ),
        CustomSizedBox(
          height: 0.03,
        ),
      ],
    );
  }

  Widget buildStartEndDate(
    Size size,
  ) {
    return Row(
      children: [
        buildDateCard(
          size,
          viewModel.startFilterDate,
          false,
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.04,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.to.toLowerCase(),
              fontsize: 15,
              fontWeight: FontWeight.w500,
              color: textGrey,
            ),
            CustomSizedBox(
              width: 0.04,
            ),
          ],
        ),
        buildDateCard(
            size,
            viewModel.endFilterDate,
            true,
            DateFormat('yyyy-MM-dd').parse(viewModel.startFilterDate),
            DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())),
      ],
    );
  }

  Widget buildDateCard(Size size, String date,
      [bool isEnd = false, DateTime? firstDate, DateTime? lastDate]) {
    return Flexible(
      child: GestureDetector(
        onTap: () async {
          securedPrint("Hiiii");
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.parse(date),
            firstDate: firstDate ?? DateTime(1970),
            lastDate: lastDate ?? DateTime.now(),
            builder: (context, child) {
              return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: themeColor,
                      onPrimary: black,
                      surface: black,
                      onSurface: white,
                    ),
                    dialogBackgroundColor: black,
                  ),
                  child: child!);
            },
          );
          if (pickedDate != null) {
            if (isEnd) {
              viewModel.setEndFilterDate(
                  DateFormat('yyyy-MM-dd').format(pickedDate));
            } else {
              securedPrint("Hiii");
              viewModel.setStartFilterDate(
                  DateFormat('yyyy-MM-dd').format(pickedDate));
            }
            DateTime end = pickedDate;
            DateTime start =
                DateFormat('yyyy-MM-dd').parse(viewModel.startFilterDate);
            if (!end.isAfter(start)) {
              // securedPrint("biii");
              viewModel.setStartFilterDate(
                  DateFormat('yyyy-MM-dd').format(pickedDate));
            }
          }
        },
        child: CustomContainer(
          height: size.height / 35,
          decoration: BoxDecoration(
            color: themeSupport().isSelectedDarkMode()
                ? switchBackground.withOpacity(0.15)
                : enableBorder.withOpacity(0.35),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: CustomText(
                fontfamily: 'InterTight',
                text: date,
                fontsize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
          right: 12.0, left: 12.0, top: 8.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: CustomElevatedButton(
                width: 1,
                buttoncolor: enableBorder,
                color: black,
                press: () {
                  viewModel.setFirstWallet(stringVariables.spotWallet);
                  viewModel.setSecondWallet(stringVariables.fundingWallet);
                  transferViewModel
                      .setCurrencyForFilterModal(stringVariables.all);
                  viewModel.fetchTransferHistoryForFunding();
                  Navigator.pop(context);
                },
                isBorderedButton: true,
                maxLines: 1,
                icon: null,
                multiClick: true,
                text: stringVariables.reset,
                radius: 25,
                height: size.height / 50,
                icons: false,
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0)),
          ),
          CustomSizedBox(
            width: 0.04,
          ),
          Flexible(
            child: CustomElevatedButton(
                width: 1,
                buttoncolor: themeColor,
                color: themeSupport().isSelectedDarkMode() ? black : white,
                press: () {
                  viewModel.fetchTransferHistoryForFunding();
                  Navigator.pop(context);
                },
                isBorderedButton: true,
                maxLines: 1,
                icon: null,
                multiClick: true,
                text: stringVariables.confirm,
                radius: 25,
                height: size.height / 50,
                icons: false,
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(0, 0)),
          ),
        ],
      ),
    );
  }
}
