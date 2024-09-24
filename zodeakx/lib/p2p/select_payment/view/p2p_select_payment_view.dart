import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/home/view_model/p2p_home_view_model.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../../payment_methods/view_model/p2p_payment_methods_view_model.dart';
import '../../profile/model/UserPaymentDetailsModel.dart';

class P2PSelectPaymentView extends StatefulWidget {
  const P2PSelectPaymentView({Key? key}) : super(key: key);

  @override
  State<P2PSelectPaymentView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PSelectPaymentView>
    with TickerProviderStateMixin {
  late P2PPaymentMethodsViewModel viewModel;
  late P2PHomeViewModel p2pHomeViewModel;

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
    p2pHomeViewModel = Provider.of<P2PHomeViewModel>(context, listen: false);
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
            : buildP2PSelectPaymentView(size),
      ),
    );
  }

  Widget buildP2PSelectPaymentView(Size size) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(
                height: 0.03,
              ),
              CustomText(
                fontfamily: 'GoogleSans',
                text: stringVariables.recommended,
                fontsize: 16,
                fontWeight: FontWeight.w600,
              ),
              CustomSizedBox(
                height: 0.02,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                    itemCount: p2pHomeViewModel.cards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildListCard(
                          size,
                          "assets/images/p2p/svg/p2pPaymentCard${index + 1}.svg",
                          p2pHomeViewModel.cards[index]);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListCard(Size size, String banner, String title) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            String payment = title;
            if (title == stringVariables.bankTransfer)
              payment = "bank_transfer";
            List<UserPaymentDetails> list = (viewModel.paymentMethods ?? [])
                .where((element) => element.paymentName == payment)
                .toList();
            if (list.isEmpty) {
              moveToAddPayment(context, title);
            } else {
              customSnackBar.showSnakbar(context,
                  stringVariables.paymentAlready, SnackbarType.negative);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                banner,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomSizedBox(
                        width: 0.04,
                      ),
                      CustomText(
                        fontfamily: 'GoogleSans',
                        text: title,
                        fontsize: 15,
                        fontWeight: FontWeight.w600,
                        color: white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        p2pRightArrow,
                        height: 30,
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        CustomSizedBox(
          height: 0.01,
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
              text: stringVariables.selectPaymentMethod,
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
