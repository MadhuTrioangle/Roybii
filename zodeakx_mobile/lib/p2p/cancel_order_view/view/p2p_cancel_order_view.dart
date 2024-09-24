import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

class P2PCancelOrderView extends StatefulWidget {
  final String? id;

  const P2PCancelOrderView({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<P2PCancelOrderView> createState() => _CommonViewState();
}

enum CancelReason { reason1, reason2, reason3, reason4, reason5 }

class _CommonViewState extends State<P2PCancelOrderView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  TextEditingController descController = TextEditingController();
  late FocusNode focusNode;
  GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        fieldKey.currentState!.validate();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<P2POrderCreationViewModel>();

    Size size = MediaQuery.of(context).size;
    return Provider(
      create: (context) => viewModel,
      child: CustomScaffold(
        appBar: AppHeader(size),
        child: viewModel.needToLoad
            ? Center(child: CustomLoader())
            : buildP2PCancelOrderView(size),
      ),
    );
  }

  Widget buildP2PCancelOrderView(Size size) {
    String orderId = widget.id ?? '';
    int index = viewModel.reason.index;
    String desc = descController.text;
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: CustomCard(
        outerPadding: 0,
        edgeInsets: 0,
        radius: 25,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 35),
            child: CustomContainer(
              height: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          buildTipsDetailsCard(size),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          CustomText(
                            text: stringVariables.whyCancelOrder,
                            fontfamily: 'InterTight',
                            softwrap: true,
                            fontWeight: FontWeight.bold,
                            fontsize: 17,
                          ),
                          CustomSizedBox(
                            height: 0.02,
                          ),
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor:
                                  themeSupport().isSelectedDarkMode()
                                      ? white
                                      : black,
                            ),
                            child: Column(
                              children: [
                                buildTextWithRadio(size, CancelReason.reason1,
                                    stringVariables.cancelReason1),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildTextWithRadio(size, CancelReason.reason2,
                                    stringVariables.cancelReason2),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildTextWithRadio(size, CancelReason.reason3,
                                    stringVariables.cancelReason3),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildTextWithRadio(size, CancelReason.reason4,
                                    stringVariables.cancelReason4),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildTextWithRadio(size, CancelReason.reason5,
                                    stringVariables.otherReasons),
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                viewModel.reason == CancelReason.reason5
                                    ? CustomTextFormField(
                                        focusNode: focusNode,
                                        keys: fieldKey,
                                        size: 30,
                                        keyboardType: TextInputType.text,
                                        text: stringVariables.enterReasons,
                                        hintColor: switchBackground,
                                        maxLines: 4,
                                        minLines: 4,
                                        controller: descController,
                                        autovalid:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (input) =>
                                            (input ?? "").isEmpty
                                                ? stringVariables.enterReasons
                                                : null,
                                        isContentPadding: true,
                                      )
                                    : CustomSizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom /
                                            1.5)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CustomSizedBox(
                        height: 0.02,
                      ),
                      CustomElevatedButton(
                          buttoncolor: themeColor,
                          color: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                          press: () {
                            if (viewModel.reason == CancelReason.reason5 &&
                                descController.text.isEmpty)
                              fieldKey.currentState!.validate();
                            viewModel.cancelOrder(orderId, index,
                                viewModel.reason.index == 4 ? desc : null);
                          },
                          width: 1,
                          isBorderedButton: true,
                          maxLines: 1,
                          icon: null,
                          multiClick: true,
                          text: stringVariables.confirmCancellation,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextWithRadio(
      Size size, CancelReason cancelReason, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.1,
          child: Radio(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: themeColor,
            value: cancelReason,
            groupValue: viewModel.reason,
            onChanged: (CancelReason? value) {
              viewModel.setReason(value ?? CancelReason.reason1);
            },
          ),
        ),
        CustomSizedBox(
          width: 0.02,
        ),
        CustomContainer(
          constraints: BoxConstraints(maxWidth: size.width / 1.3),
          child: CustomText(
            strutStyleHeight: 1.6,
            maxlines: 2,
            text: content,
            fontfamily: 'InterTight',
            softwrap: true,
            fontWeight: FontWeight.w500,
            fontsize: 15,
            color: viewModel.reason == cancelReason ? themeColor : null,
          ),
        ),
      ],
    );
  }

  Widget buildTipsDetailsCard(Size size) {
    return CustomContainer(
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode()
            ? switchBackground.withOpacity(0.15)
            : enableBorder.withOpacity(0.25),
        border: Border.all(color: hintLight, width: 1),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      width: 1,
      height: isSmallScreen(context) ? 3.9 : 4.75,
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  p2pOrderAttention,
                  color: themeColor,
                ),
                CustomSizedBox(
                  height: 0.01,
                ),
                CustomText(
                  text: stringVariables.tips,
                  fontfamily: 'InterTight',
                  softwrap: true,
                  fontWeight: FontWeight.w500,
                  fontsize: 16,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTipLines(size, stringVariables.cancelOrderTipsContent1),
            CustomSizedBox(
              height: 0.02,
            ),
            buildTipLines(size, stringVariables.cancelOrderTipsContent2),
          ],
        ),
      ),
    );
  }

  Widget buildTipLines(Size size, String content) {
    return Row(
      children: [
        CustomSizedBox(
          width: 0.075,
        ),
        CustomContainer(
          constraints: BoxConstraints(maxWidth: size.width / 1.4),
          child: CustomText(
            text: content,
            fontfamily: 'InterTight',
            softwrap: true,
            fontWeight: FontWeight.w500,
            fontsize: 16,
          ),
        ),
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomText(
              text: stringVariables.cancelOrder,
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
