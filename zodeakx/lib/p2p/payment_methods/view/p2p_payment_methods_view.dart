import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNetworkImage.dart';
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2PPaymentMethodsViewModel>(context, listen: false);
    p2pProfileViewModel =
        Provider.of<P2PProfileViewModel>(context, listen: false);
    if (constant.userLoginStatus.value) {
      viewModel.getJwtUserResponse();
      p2pProfileViewModel.findUserCenter();
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
            fontfamily: 'GoogleSans',
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
    Widget widget =
        (userPaymentDetails.paymentName ?? "") == stringVariables.paytm ||
                (userPaymentDetails.paymentName ?? "") == stringVariables.upi
            ? type1View(size, userPaymentDetails)
            : type2View(size, userPaymentDetails);
    return widget;
  }

  Widget type1View(Size size, UserPaymentDetails userPaymentDetails) {
    Color cardColor = constant.paymentCardColors.entries
        .firstWhere((entry) => entry.key == userPaymentDetails.paymentName)
        .value;
    String userName = (viewModel.getUserByJwt?.kyc?.idProof?.firstName ?? "") +
        " " +
        (viewModel.getUserByJwt?.kyc?.idProof?.lastName ?? "");
    String name = userPaymentDetails.paymentName ?? "";
    String upi = name == stringVariables.upi
        ? userPaymentDetails.paymentDetails?.upiId ?? ""
        : userPaymentDetails.paymentDetails?.accountNumber ?? "";
    String qr = userPaymentDetails.paymentDetails?.qrCode ?? "";
    String id = userPaymentDetails.id ?? "";
    return CustomContainer(
      width: 1,
      height: qr.isEmpty ? 6 : 4,
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
                      fontfamily: 'GoogleSans',
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
                        moveToEditPayment(context, userPaymentDetails);
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
          buildItemCard(size, true, userName),
          buildItemCard(size, true, upi),
          qr.isEmpty
              ? CustomSizedBox(
                  width: 0,
                  height: 0,
                )
              : buildQrCard(size, qr),
          CustomSizedBox(
            height: 0.01,
          ),
          Divider(),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget type2View(Size size, UserPaymentDetails userPaymentDetails) {
    Color cardColor = constant.paymentCardColors.entries
        .firstWhere((entry) => entry.key == userPaymentDetails.paymentName)
        .value;
    String userName = (viewModel.getUserByJwt?.kyc?.idProof?.firstName ?? "") +
        " " +
        (viewModel.getUserByJwt?.kyc?.idProof?.lastName ?? "");
    String name = userPaymentDetails.paymentName ?? "";
    if (name == "bank_transfer") name = stringVariables.bankTransfer;
    String bankName = userPaymentDetails.paymentDetails?.bankName ?? "";
    String accountNumber =
        userPaymentDetails.paymentDetails?.accountNumber ?? "";
    String ifsc = userPaymentDetails.paymentDetails?.ifscCode ?? "";
    String accountType = userPaymentDetails.paymentDetails?.accountType ?? "";
    String branch = userPaymentDetails.paymentDetails?.branch ?? "";
    String id = userPaymentDetails.id ?? "";
    return CustomContainer(
      width: 1,
      height: 3,
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
                      fontfamily: 'GoogleSans',
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
                        moveToEditPayment(context, userPaymentDetails);
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
          buildItemCard(size, true, userName),
          buildItemCard(size, true, accountNumber),
          buildItemCard(size, false, ifsc),
          buildItemCard(size, false, accountType),
          buildItemCard(size, false, bankName),
          buildItemCard(size, false, branch),
          CustomSizedBox(
            height: 0.01,
          ),
          Divider(),
          CustomSizedBox(
            height: 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildItemCard(Size size, bool isBold, String title) {
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
              CustomText(
                fontfamily: 'GoogleSans',
                text: title,
                fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
                overflow: TextOverflow.ellipsis,
                fontsize: 13,
                color: isBold ? null : hintLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQrCard(Size size, String qr) {
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
              text: stringVariables.p2pPaymentMethods,
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
