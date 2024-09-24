import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../transfer/viewModel/transfer_view_model.dart';
import '../viewModel/wallet_select_view_model.dart';

class WalletSelectView extends StatefulWidget {
  final String? type;

  const WalletSelectView({Key? key, this.type}) : super(key: key);

  @override
  State<WalletSelectView> createState() => _WalletSelectViewState();
}

class _WalletSelectViewState extends State<WalletSelectView> {
  late WalletSelectViewModel viewModel;
  late TransferViewModel transferViewModel;
  late List<Map<String, dynamic>> walletList;

  @override
  void initState() {
    viewModel = Provider.of<WalletSelectViewModel>(context, listen: false);
    transferViewModel = Provider.of<TransferViewModel>(context, listen: false);

    walletList = viewModel.walletCheck(
        widget.type?.toLowerCase() == "first" ? 0 : 1,
        viewModel.firstWallet,
        viewModel.secondtWallet);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<WalletSelectViewModel>();
    transferViewModel = context.watch<TransferViewModel>();

    return Provider<WalletSelectViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return walletSelectView(
          context,
        );
      },
    );
  }

  Widget walletSelectView(BuildContext context) {
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
                child: CustomText(
                  overflow: TextOverflow.ellipsis,
                  maxlines: 1,
                  softwrap: true,
                  fontfamily: 'InterTight',
                  fontsize: 21,
                  fontWeight: FontWeight.bold,
                  text: stringVariables.selectWallet,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: buildCard(),
    );
  }

  Widget buildCard() {
    return CustomCard(
      radius: 15,
      outerPadding: 15,
      edgeInsets: 10,
      elevation: 0,
      child: ListView.builder(
          itemCount: walletList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: CustomCard(
                radius: 15,
                outerPadding: 4,
                edgeInsets: 15,
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(walletList[index]['logo']),
                        CustomSizedBox(
                          width: 0.04,
                        ),
                        CustomText(
                          text: walletList[index]['title'],
                          fontsize: 14,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
