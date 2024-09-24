import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNetworkImage.dart';
import 'package:zodeakx_mobile/p2p/home/view_model/p2p_home_view_model.dart';
import 'package:zodeakx_mobile/p2p/payment_methods/view/p2p_delete_payment_dialog.dart';
import 'package:zodeakx_mobile/p2p/profile/view_model/p2p_profile_view_model.dart';

import '../../../Common/Wallets/View/MustLoginView.dart';
import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomSizedbox.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../home/model/p2p_payment_methods.dart';
import '../../profile/model/UserPaymentDetailsModel.dart';
import '../view_model/p2p_payment_methods_view_model.dart';
import 'p2p_image_view_dialog.dart';

class P2PPaymentMethodsView extends StatefulWidget {
  const P2PPaymentMethodsView({Key? key}) : super(key: key);

  @override
  State<P2PPaymentMethodsView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PPaymentMethodsView>
    with TickerProviderStateMixin {
  late P2PPaymentMethodsViewModel viewModel;
  late P2PProfileViewModel p2pProfileViewModel;
  late P2PHomeViewModel p2pHomeViewModel;

  @override
  void dispose() {
    // TODO: implement dispose
    if (constant.userLoginStatus.value) p2pProfileViewModel.findUserCenter();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    p2pHomeViewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
    p2pProfileViewModel =
        Provider.of<P2PProfileViewModel>(context, listen: false);
    if (constant.userLoginStatus.value) {
      viewModel.getJwtUserResponse();
      p2pProfileViewModel.findUserCenter();
      p2pHomeViewModel.fetchPaymentMethods();
    }
/*
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
*/
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2PPaymentMethodsViewModel>();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : constant.userLoginStatus.value == false
                ? MustLoginView()
                : buildP2PPaymentMethodsView(size),
      ),
    );
  }

  Widget buildP2PPaymentMethodsView(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: viewModel.needToLoad
            ? CustomLoader()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          buildPaymentMethodItems(size),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          CustomElevatedButton(
                              buttoncolor: themeColor,
                              color: black,
                              press: () {
                                bool verified = p2pProfileViewModel
                                            .userCenter?.emailStatus ==
                                        "verified" &&
                                    p2pProfileViewModel.userCenter?.kycStatus ==
                                        "verified";
                                if (verified)
                                  moveToSelectPayment(context);
                                else
                                  moveToTradingRequirement(context);
                              },
                              width: 1.15,
                              isBorderedButton: true,
                              maxLines: 1,
                              fontSize: 16,
                              icon: null,
                              multiClick: true,
                              text: stringVariables.addPaymentMethod,
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
                ],
              ),
      ),
    );
  }

  Widget buildNoPaymentMethod(Size size) {
    return CustomContainer(
      width: 1,
      height: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            themeSupport().isSelectedDarkMode()
                ? p2pNoPaymentDark
                : p2pNoPayment,
          ),
          CustomSizedBox(
            height: 0.025,
          ),
          CustomText(
            fontfamily: 'InterTight',
            text: stringVariables.noPaymentMethod,
            color: hintLight,
            fontsize: 18,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethodItems(Size size) {
    List<UserPaymentDetails> paymentMethods = viewModel.paymentMethods ?? [];
    List<Widget> paymentMethodsList = [];
    int paymentMethodsCount = paymentMethods.length;
    for (var i = 0; i < paymentMethodsCount; i++) {
      paymentMethodsList.add(buildPaymentCard(size, paymentMethods[i]));
    }
    return paymentMethodsCount == 0
        ? buildNoPaymentMethod(size)
        : Column(
            children: paymentMethodsList,
          );
  }

  Widget buildPaymentCard(Size size, UserPaymentDetails userPaymentDetails) {
    Widget widget = type2View(size, userPaymentDetails);
    return widget;
  }

  // Widget type1View(Size size, UserPaymentDetails userPaymentDetails) {
  //   Color cardColor = randomColor();
  //   String userName = (viewModel.getUserByJwt?.kyc?.idProof?.firstName ?? "") +
  //       " " +
  //       (viewModel.getUserByJwt?.kyc?.idProof?.lastName ?? "");
  //   String name = userPaymentDetails.paymentName ?? "";
  //   String upi = name == stringVariables.upi ? "" : "";
  //   String qr = "";
  //   String id = userPaymentDetails.id ?? "";
  //   return CustomContainer(
  //     width: 1,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.symmetric(horizontal: size.width / 50),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   CustomSizedBox(
  //                     width: 0.02,
  //                   ),
  //                   CustomContainer(
  //                     decoration: BoxDecoration(
  //                       color: cardColor,
  //                       borderRadius: BorderRadius.circular(
  //                         500.0,
  //                       ),
  //                     ),
  //                     width: size.width / 4,
  //                     height: size.height / 14,
  //                   ),
  //                   CustomSizedBox(
  //                     width: 0.02,
  //                   ),
  //                   CustomText(
  //                     fontfamily: 'InterTight',
  //                     text: name,
  //                     fontWeight: FontWeight.w500,
  //                     overflow: TextOverflow.ellipsis,
  //                     fontsize: 15,
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       List<PaymentMethods> paymentMethods = p2pHomeViewModel
  //                               .paymentMethods
  //                               ?.where((element) => element.name == name)
  //                               .toList() ??
  //                           [];
  //                       print("Status - ${paymentMethods.first.status}");
  //                       if (paymentMethods.isNotEmpty) {
  //                         moveToEditPayment(context, userPaymentDetails);
  //                       } else {
  //                         customSnackBar.showSnakbar(
  //                             context,
  //                             "You have not enabled TFA! Enable TFA to continue",
  //                             SnackbarType.negative);
  //                       }
  //                     },
  //                     behavior: HitTestBehavior.opaque,
  //                     child: SvgPicture.asset(p2pPaymentEdit),
  //                   ),
  //                   CustomSizedBox(
  //                     width: 0.02,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       _showDeleteDialog(id);
  //                     },
  //                     behavior: HitTestBehavior.opaque,
  //                     child: SvgPicture.asset(
  //                       p2pPaymentDelete,
  //                       color: red,
  //                       height: 30,
  //                     ),
  //                   ),
  //                   CustomSizedBox(
  //                     width: 0.02,
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //         buildItemCard(size, true, userName),
  //         buildItemCard(size, true, upi),
  //         qr.isEmpty
  //             ? CustomSizedBox(
  //                 width: 0,
  //                 height: 0,
  //               )
  //             : buildQrCard(size, qr),
  //         CustomSizedBox(
  //           height: 0.01,
  //         ),
  //         Divider(
  //           color: divider,
  //           thickness: 0.2,
  //         ),
  //         CustomSizedBox(
  //           height: 0.01,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget type2View(Size size, UserPaymentDetails userPaymentDetails) {
    var colorList = constant.paymentCardColors.entries
        .where((element) => element.key == userPaymentDetails.paymentName)
        .toList();
    Color cardColor = randomColor();
    if (colorList.isNotEmpty) {
      cardColor = colorList.first.value;
    }
    String userName = (viewModel.getUserByJwt?.kyc?.idProof?.firstName ?? "") +
        " " +
        (viewModel.getUserByJwt?.kyc?.idProof?.lastName ?? "");
    String name = userPaymentDetails.paymentName ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    String bankName = "";
    String accountNumber = "";
    String ifsc = "";
    String accountType = "";
    String branch = "";
    String id = userPaymentDetails.id ?? "";
    return CustomContainer(
      width: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomContainer(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(
                          500.0,
                        ),
                      ),
                      width: size.width / 4,
                      height: size.height / 14,
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    CustomText(
                      fontfamily: 'InterTight',
                      text: name,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                      fontsize: 15,
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        List<PaymentMethods> paymentMethods = p2pHomeViewModel
                                .paymentMethods
                                ?.where((element) => element.name == name)
                                .toList() ??
                            [];
                        if (paymentMethods.isNotEmpty) {
                          moveToEditPayment(context, userPaymentDetails);
                        } else {
                          customSnackBar.showSnakbar(
                              context,
                              stringVariables.paymentMethodNotAvailable,
                              SnackbarType.negative);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(p2pPaymentEdit),
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDeleteDialog(id);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(
                        p2pPaymentDelete,
                        color: red,
                        height: 30,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                  ],
                )
              ],
            ),
          ),
          // buildItemCard(size, true, userName),
          buildDynamicItems(userPaymentDetails.paymentDetails ?? {}),
          CustomSizedBox(
            height: 0.01,
          ),
          Divider(
            thickness: 0.2,
            color: divider,
          ),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildDynamicItems(Map<String, dynamic> mapItems) {
    List<dynamic> listItems = mapItems.values.toList();
    List<dynamic> listItemsKeys = mapItems.keys.toList();
    print(listItemsKeys);
    int length = listItems.length;
    Size size = MediaQuery.sizeOf(context);
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: length,
        itemBuilder: (BuildContext context, int index) {
          bool isImage = hasValidUrl(listItems[
              index]); //sending all values(accno,qrimage link, ifsc code,name) inside hasvalidurl method
          return isImage
              ? buildQrCard(size, listItems[index], listItemsKeys[index], false)
              : buildItemCard(
                  size, false, listItems[index], listItemsKeys[index]);
        });
  }

  Widget buildItemCard(Size size, bool isBold, String title, String head) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            children: [
              CustomSizedBox(
                width: 0.04,
              ),
              Flexible(
                child: CustomText(
                  fontfamily: 'InterTight',
                  text: head.replaceAll('_', ' ').toUpperCase(),
                  //  head==stringVariables.p2pAccNumber?stringVariables.p2pAccNumber:
                  // head==stringVariables.p2pName?stringVariables.p2pName:
                  // head==stringVariables.p2pmno?stringVariables.p2pmno:
                  // head==stringVariables.p2pBank?stringVariables.p2pBank:
                  // head==stringVariables.p2pIban?stringVariables.p2pIban:"oh ",
                  fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  fontsize: 13,
                  color: isBold ? null : textHeaderGrey,
                ),
              ),
            ],
          ),
          CustomSizedBox(
            width: 0.04,
          ),
          Row(
            children: [
              CustomSizedBox(
                width: 0.04,
              ),
              Flexible(
                child: CustomText(
                  fontfamily: 'InterTight',
                  text: title,
                  fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  fontsize: 13,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildQrCard(Size size, String qr, String head, bool isBold) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
      child: Column(
        children: [
          CustomSizedBox(
            height: 0.02,
          ),
          Row(
            children: [
              CustomSizedBox(
                width: 0.04,
              ),
              Flexible(
                child: CustomText(
                  fontfamily: 'InterTight',
                  text: head.replaceAll('_', ' ').toUpperCase(),
                  fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  fontsize: 13,
                  color: isBold ? textLight : textHeaderGrey,
                ),
              ),
            ],
          ),
          CustomSizedBox(
            width: 0.04,
          ),
          Row(
            children: [
              CustomSizedBox(
                width: 0.04,
              ),
              GestureDetector(
                onTap: () {
                  _showQrDialog(qr);
                },
                child: CustomNetworkImage(
                  image: qr,
                  height: 40,
                  width: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showQrDialog(String image) async {
    final result =
        await Navigator.of(context).push(P2PImageViewModal(context, image));
  }

  _showDeleteDialog(String id) async {
    final result =
        await Navigator.of(context).push(P2PDeletePaymentModel(context, id));
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
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
                fontfamily: 'InterTight',
                fontsize: 23,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                text: stringVariables.p2pPaymentMethods,
                color: themeSupport().isSelectedDarkMode() ? white : black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(Size size) {
    return CustomContainer(
      width: 1,
      height: 1,
      child: Stack(
        children: [
          // backButton(context),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.p2pPaymentMethods,
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
