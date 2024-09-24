import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomCircleAvatar.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../ViewModel/TransferViewModel.dart';

class TransferView extends StatefulWidget {
  const TransferView({Key? key}) : super(key: key);

  @override
  State<TransferView> createState() => _TransferViewState();
}

class _TransferViewState extends State<TransferView> {
  late TransferViewModel viewModel;
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormFieldState> amountFieldKey = GlobalKey<FormFieldState>();
  @override
  void initState() {
    viewModel = Provider.of<TransferViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<TransferViewModel>();
    return Provider<TransferViewModel>(
      create: (context) => viewModel,
      builder: (context, child) {
        return transfer(
          context,
        );
      },
    );
  }

  Widget transfer(BuildContext context) {
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
                  text: stringVariables.transfer,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ),
            ],
          ),
        ),
      ),
      child: transferCard(),
    );
  }

  Widget transferCard() {
    return SingleChildScrollView(
      child: CustomCard(
          radius: 15,
          outerPadding: 15,
          edgeInsets: 8,
          elevation: 0,
          child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Center(
                  child: Column(
                    children: [
                      CustomCard(
                        radius: 15,
                        outerPadding: 0,
                        edgeInsets: 8,
                        elevation: 0,color: themeSupport().isSelectedDarkMode() ? black : grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: upperCard(),
                        ),
                      ),
                      middleCard(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(text: stringVariables.transferHeader,color: pink,fontsize: 12,),
                      ),
                      textField(),
                      CustomSizedBox(height:isSmallScreen(context)  ? 0.09 : 0.19,),
                      CustomElevatedButton(
                        text: stringVariables.confirm.toUpperCase() + " " + stringVariables.transfer.toUpperCase(),
                        radius: 25,
                        buttoncolor: themeColor,
                        width: 1.2,
                        blurRadius: 13,
                        spreadRadius: 1,
                        height: MediaQuery.of(context).size.height / 50,
                        isBorderedButton: false,
                        maxLines: 1,
                        icons: false,
                        icon: null,
                        color: black,
                        press: () {
                        },
                      ),
                      CustomSizedBox(height: 0.02,),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context)
                                  .viewInsets
                                  .bottom /
                                  1.5))
                    ],
                  )))),
    );
  }

  Widget upperCard() {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(ellipseRoundOutline),
            CustomSizedBox(
              width: 0.05,
            ),
            CustomText(
              text: stringVariables.from,
              color: stackCardText,
            ),
            CustomSizedBox(
              width: 0.06,
            ),
            CustomText(
              text: stringVariables.funding,fontsize: 14,fontWeight: FontWeight.w600,
            ),
            CustomSizedBox(
              width: 0.10,
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 10,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            )
          ],
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_downward_sharp,
              size: 20,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
            SvgPicture.asset(swap)
          ],
        ),
        CustomSizedBox(
          height: 0.03,
        ),
        Row(
          children: [
            SvgPicture.asset(walletImage),
            CustomSizedBox(
              width: 0.05,
            ),
            CustomText(
              text: stringVariables.to+"     ",
              color: stackCardText,
            ),
            CustomSizedBox(
              width: 0.06,
            ),
            CustomText(
              text: stringVariables.spot+" "+stringVariables.wallets,fontsize: 14,fontWeight: FontWeight.w600,
            ),
            CustomSizedBox(
              width: 0.055,
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 10,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            )
          ],
        ),
      ],
    );
  }

  Widget middleCard() {
    return  CustomCard(
        radius: 15,
        outerPadding: 0,
        edgeInsets: 8,
        elevation: 0,color: themeSupport().isSelectedDarkMode() ? black : grey,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:GestureDetector(
            onTap: (){
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(

                  children: [
                    CustomCircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(splash),
                    ),
                    CustomSizedBox(width: 0.02,),
                    CustomText(text: stringVariables.coinSymbol,fontsize: 18,)
                  ],
                ),
                Icon(Icons.arrow_forward_ios,size: 15,)
              ],
            ),
          ),));
  }

  Widget textField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: stringVariables.amount,color: stackCardText,fontsize: 14,),
          CustomSizedBox(height: 0.02,),
          CustomTextFormField(
            autovalid: AutovalidateMode.onUserInteraction,
            controller: amountController,isBorder: true,
            keys: amountFieldKey,
            padRight: 0,
            padLeft: 0,
            isContentPadding: false,
            keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
            ],color: themeSupport().isSelectedDarkMode() ? black : grey,

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
                    text: " " + stringVariables.coinSymbol + "  ",color:stackCardText,fontWeight: FontWeight.w500,fontsize: 13,
                  ),
                  GestureDetector(
                    onTap: () {},
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

          ),
          CustomSizedBox(height: 0.02,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: stringVariables.available + ":",color: stackCardText,fontsize: 14,),
              CustomText(text: stringVariables.coinTotal + " " + stringVariables.coinSymbol,color: stackCardText,fontsize: 14,),


            ],
          )
        ],
      ),
    );
  }
}
