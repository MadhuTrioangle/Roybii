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
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../add_payment_details/view/border/dotted_border.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

class P2PReachedAgreementView extends StatefulWidget {
  final String id;
  final bool? color;
  final String? side;

  const P2PReachedAgreementView(
      {Key? key, required this.id, this.color, this.side})
      : super(key: key);

  @override
  State<P2PReachedAgreementView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PReachedAgreementView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  TextEditingController descController = TextEditingController();
  GlobalKey<FormFieldState> descKey = GlobalKey<FormFieldState>();
  late FocusNode descFocusNode;

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
    descFocusNode = FocusNode();
    validator(descKey, descFocusNode);
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
            : buildP2PReachedAgreementView(size),
      ),
    );
  }

  Widget buildP2PReachedAgreementView(Size size) {
    return Padding(
      padding: EdgeInsets.only(
          left: size.width / 35,
          right: size.width / 35,
          bottom: size.width / 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: CustomContainer(
              width: 1,
              height: 1,
              child: CustomCard(
                outerPadding: 0,
                edgeInsets: 0,
                radius: 25,
                elevation: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width / 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomSizedBox(
                                  height: 0.02,
                                ),
                                buildDescDetailsCard(size),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProofUploadView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.uploadProofWithMandatory,
          fontWeight: FontWeight.w500,
          fontsize: 14,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        CustomText(
          fontfamily: 'GoogleSans',
          text: stringVariables.uploadProofAlert,
          fontWeight: FontWeight.w400,
          fontsize: 14,
          color: hintLight,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(12),
          strokeWidth: 1.5,
          dashPattern: [6, 4],
          color: themeSupport().isSelectedDarkMode()
              ? white.withOpacity(0.4)
              : black.withOpacity(0.4),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: CustomContainer(
                width: 4.5,
                height: 8.5,
                child: Icon(
                  Icons.add,
                  color: hintLight,
                  size: 30,
                )),
          ),
        )
      ],
    );
  }

  Widget buildDescDetailsCard(Size size) {
    return AnimatedContainer(
      width: size.width,
      height: viewModel.moreExpandFlag ? size.height / 1.85 : size.height / 3.1,
      duration: Duration(milliseconds: 200),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomSizedBox(
                  width: 0.03,
                ),
                CustomText(
                  fontfamily: 'GoogleSans',
                  text: stringVariables.descriptionWithMandatory,
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                  color: hintLight,
                ),
              ],
            ),
            CustomSizedBox(
              height: 0.02,
            ),
            CustomTextFormField(
              color: switchBackground.withOpacity(0.1),
              maxLength: 500,
              padLeft: 0,
              padRight: 0,
              size: 30,
              validator: (input) =>
                  input!.isEmpty ? stringVariables.hintDescription : null,
              hintColor: switchBackground,
              maxLines: 4,
              minLines: 4,
              controller: descController,
              keys: descKey,
              focusNode: descFocusNode,
              autovalid: AutovalidateMode.onUserInteraction,
              isContentPadding: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReasonCard(String content) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        CustomContainer(
          padding: 10,
          decoration: BoxDecoration(
            color: switchBackground.withOpacity(0.1),
            border: Border.all(color: hintLight, width: 1),
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          child: CustomText(
            fontfamily: 'GoogleSans',
            text: content,
            fontWeight: FontWeight.w400,
            fontsize: 14,
          ),
        ),
      ],
    );
  }

  Widget buildProvideInfoCard(Size size) {
    return CustomContainer(
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      width: 1,
      height: 5.5,
      child: Padding(
        padding: EdgeInsets.all(size.width / 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildPointsWithContent(
                stringVariables.one, stringVariables.provideInfoContent1),
            CustomSizedBox(
              height: 0.02,
            ),
            buildPointsWithContent(
                stringVariables.two, stringVariables.provideInfoContent2),
          ],
        ),
      ),
    );
  }

  Widget buildPointsWithContent(String point, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'GoogleSans',
              text: point + ".",
              fontWeight: FontWeight.w400,
              fontsize: 14,
            ),
          ],
        ),
        Row(
          children: [
            CustomSizedBox(
              width: 0.02,
            ),
            CustomContainer(
              width: 1.35,
              child: CustomText(
                fontfamily: 'GoogleSans',
                text: content,
                fontWeight: FontWeight.w400,
                fontsize: 14,
              ),
            ),
          ],
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
              text: stringVariables.reachedAgreement,
              overflow: TextOverflow.ellipsis,
              fontfamily: 'GoogleSans',
              fontWeight: FontWeight.bold,
              fontsize: 20,
              color: themeSupport().isSelectedDarkMode() ? white : black,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (descController.text.isNotEmpty) {
                      viewModel.appealConsensus(
                          widget.color!, descController.text, widget.side);
                      if (widget.color == false) {
                        viewModel.setIsConsenses(true);
                        //Navigator.pop(context);
                      } else {
                        viewModel.setIsConsenses(false);
                      }
                    } else {
                      descKey.currentState?.validate();
                    }
                    //viewModel.fetchAppealHistory();
                  },
                  child: CustomText(
                    fontfamily: 'GoogleSans',
                    text: capitalize(stringVariables.submit),
                    fontWeight: FontWeight.w500,
                    fontsize: 14,
                    color: themeColor,
                  ),
                ),
                CustomSizedBox(width: 0.03)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
