import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Common/Common/ViewModel/common_view_model.dart';
import 'package:zodeakx_mobile/Common/Wallets/ViewModel/WalletViewModel.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';

class StackingSuccessfulView extends StatefulWidget {
  final String? amount; final String? code;
  const StackingSuccessfulView({Key? key,this.amount,this.code}) : super(key: key);

  @override
  State<StackingSuccessfulView> createState() => _StackingSuccessfulViewState();
}

class _StackingSuccessfulViewState extends State<StackingSuccessfulView> {
  int count = 0;
  late CommonViewModel commonViewModel;
  late WalletViewModel walletViewModel;
  @override
  void initState() {
    commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    commonViewModel = context.watch<CommonViewModel>();
    walletViewModel = context.watch<WalletViewModel>();
    return Provider(
      create: (context) => commonViewModel,
        child: SuccessfulView(context));
  }

  Widget SuccessfulView(BuildContext context){
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
                  text: stringVariables.stake +
                      ' ' +
                      '${widget.code}',
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: successfulCard(),
    );
  }

 Widget successfulCard() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          CustomSizedBox(
            height:0.15,
          ),
          SvgPicture.asset(successful),
          CustomSizedBox(
            height:0.03,
          ),
          CustomText(text:   '${widget.amount}'+" "+  '${widget.code}',fontWeight: FontWeight.w600,fontsize: 18,),
          CustomSizedBox(
            height:0.01,
          ),
          CustomText(text: stringVariables.stakedSuccessfully,fontWeight: FontWeight.w600,fontsize: 18,),
          CustomSizedBox(
            height:0.28,
          ),
          CustomElevatedButton(
            text: stringVariables.goToWallet,
            radius: 25,
            buttoncolor: themeColor,
            width: 1.15,
            blurRadius: 13,
            spreadRadius: 1,
            height: MediaQuery.of(context).size.height / 50,
            isBorderedButton: false,
            maxLines: 1,
            icons: false,
            icon: null,
            multiClick: true,
            color: black,press: (){
            count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 4);
            commonViewModel.setActive(3);
          },
          ),
        ],
      ),
    );
 }
}
