import 'package:flutter/cupertino.dart';
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
import '../viewModel/wallet_select_view_model.dart';

class WalletSelectView extends StatefulWidget {
  const WalletSelectView({Key? key}) : super(key: key);

  @override
  State<WalletSelectView> createState() => _WalletSelectViewState();
}

class _WalletSelectViewState extends State<WalletSelectView> {
 late WalletSelectViewModel viewModel;
  @override
  void initState() {
    viewModel = Provider.of<WalletSelectViewModel>(context, listen: false);
    super.initState();
  }

 @override
 Widget build(BuildContext context) {
   viewModel = context.watch<WalletSelectViewModel>();
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
      child: ListView.builder(itemCount: viewModel.walletArray.length,itemBuilder: (context,index){
        return CustomCard(
          radius: 15,
          outerPadding: 4,
          edgeInsets: 15,
          elevation: 0,color: viewModel.walletArray[index]['title'] == stringVariables.usdsfutures ?  themeSupport().isSelectedDarkMode() ? black : grey : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(viewModel.walletArray[index]['logo']),
                  CustomSizedBox(
                    width: 0.04,
                  ),
                  CustomText(text: viewModel.walletArray[index]['title'],fontsize: 14,)
                ],
              ),
              Icon(Icons.arrow_forward_ios,size: 15,)
            ],
          ),
        );
      }),
    );
 }
}
