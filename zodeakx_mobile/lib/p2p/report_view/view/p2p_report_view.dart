import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomCard.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../add_payment_details/view/border/dotted_border.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';

class P2PReportView extends StatefulWidget {
  final String id;

  const P2PReportView({Key? key, required this.id}) : super(key: key);

  @override
  State<P2PReportView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PReportView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late AnimationController rotationController;
  TextEditingController emailController = TextEditingController();
  TextEditingController descController = TextEditingController();
  late FocusNode emailFocus;
  late FocusNode descFocus;
  GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> descFieldKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    rotationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
    emailFocus = FocusNode();
    descFocus = FocusNode();
    validator(emailFieldKey, emailFocus);
    validator(descFieldKey, descFocus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setMoreExpandFlag(false);
      viewModel.setReportReason(0);
      viewModel.setPhotoError(false);
      viewModel.setButtonLoader(false);
      viewModel.setImageReport(null);
      viewModel.setImageReportEncoded([]);
    });
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
            : buildP2PReportView(size),
      ),
    );
  }

  Widget buildP2PReportView(Size size) {
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
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  buildEmailDetailsView(size),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                  buildDescDetailsCard(size),
                                  Divider(
                                    color: divider,
                                    thickness: 0.2,
                                  ),
                                  CustomSizedBox(
                                    height: 0.01,
                                  ),
                                  buildProofUploadView(size),
                                  CustomSizedBox(
                                    height: 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            CustomSizedBox(
                              height: 0.02,
                            ),
                            viewModel.buttonLoader
                                ? CustomLoader()
                                : CustomElevatedButton(
                                    buttoncolor: themeColor,
                                    color: themeSupport().isSelectedDarkMode()
                                        ? black
                                        : white,
                                    press: () {
                                      if (emailController.text.isNotEmpty &&
                                          descController.text.isNotEmpty &&
                                          viewModel
                                              .imageReportEncoded.isNotEmpty) {
                                        viewModel.setButtonLoader(true);
                                        viewModel.reportUser(
                                            widget.id,
                                            emailController.text,
                                            descController.text);
                                      } else {
                                        _formKey.currentState?.validate();
                                        if (viewModel
                                            .imageReportEncoded.isEmpty)
                                          viewModel.setPhotoError(true);
                                      }
                                    },
                                    width: 1,
                                    isBorderedButton: true,
                                    maxLines: 1,
                                    icon: null,
                                    multiClick: true,
                                    text: stringVariables.report,
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
          ),
        ],
      ),
    );
  }

  Widget buildProofUploadView(Size size) {
    List<Widget> imageList = [];
    int paymentMethodsCount = viewModel.imageReportEncoded.length + 1;
    for (var i = 0; i < paymentMethodsCount; i++) {
      if (i == viewModel.imageReportEncoded.length) {
        imageList.add(buildImageAdder());
      } else {
        imageList.add(buildImageView(size, viewModel.imageReportEncoded[i]));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontfamily: 'InterTight',
          text: stringVariables.uploadProofWithMandatory,
          fontWeight: FontWeight.w500,
          fontsize: 14,
        ),
        CustomSizedBox(
          height: 0.015,
        ),
        CustomText(
          fontfamily: 'InterTight',
          text: stringVariables.uploadProofAlert,
          fontWeight: FontWeight.w400,
          fontsize: 14,
          color: hintLight,
        ),
        CustomSizedBox(
          height: 0.01,
        ),
        viewModel.photoError
            ? Column(
                children: [
                  CustomText(
                    fontfamily: 'InterTight',
                    fontsize: 14,
                    fontWeight: FontWeight.w400,
                    text: stringVariables.uploadProofHint,
                    color: red,
                  ),
                  CustomSizedBox(
                    height: 0.015,
                  ),
                ],
              )
            : CustomSizedBox(
                width: 0,
                height: 0,
              ),
        CustomSizedBox(
          height: 0.01,
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: imageList,
        ),
      ],
    );
  }

  Widget buildImageView(Size size, String image) {
    return CustomContainer(
      width: 4.25,
      height: isSmallScreen(context) ? 6.6 : 8.1,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.memory(
                fit: BoxFit.cover,
                width: size.width / 4.25,
                height: isSmallScreen(context)
                    ? size.height / 6.6
                    : size.height / 8.1,
                base64.decode(image),
                gaplessPlayback: true,
              )),
          GestureDetector(
            onTap: () {
              viewModel.updateImageReportEncoded(image);
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Transform.translate(
                offset: Offset(-2, 2),
                child: Icon(
                  Icons.close,
                  color: black,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageAdder() {
    return GestureDetector(
      onTap: () {
        viewModel.pickImageForReport();
      },
      behavior: HitTestBehavior.opaque,
      child: DottedBorder(
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
              height: isSmallScreen(context) ? 7 : 8.5,
              child: Icon(
                Icons.add,
                color: hintLight,
                size: 30,
              )),
        ),
      ),
    );
  }

  Widget buildDescDetailsCard(Size size) {
    return AnimatedContainer(
      width: size.width,
      height: viewModel.moreExpandFlag
          ? isSmallScreen(context)
              ? size.height / 2.15
              : size.height / 2.6
          : isSmallScreen(context)
              ? size.height / 3.1
              : size.height / 3.75,
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
                  fontfamily: 'InterTight',
                  text: stringVariables.descriptionWithMandatory,
                  fontWeight: FontWeight.w500,
                  fontsize: 14,
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
              hintColor: switchBackground,
              maxLines: 4,
              minLines: 4,
              controller: descController,
              keyboardType: TextInputType.text,
              focusNode: descFocus,
              keys: descFieldKey,
              validator: (input) => (input ?? "").isEmpty
                  ? stringVariables.hintDescription
                  : null,
              autovalid: AutovalidateMode.onUserInteraction,
              isContentPadding: true,
            ),
            buildReasonCard(stringVariables.reportReason1, 0),
            viewModel.moreExpandFlag
                ? CustomSizedBox(
                    height: 0,
                    width: 0,
                  )
                : CustomSizedBox(
                    height: 0.02,
                  ),
            viewModel.moreExpandFlag
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildReasonCard(stringVariables.reportReason2, 1),
                      buildReasonCard(stringVariables.others, 2),
                    ],
                  )
                : CustomSizedBox(
                    width: 0,
                    height: 0,
                  ),
            GestureDetector(
              onTap: () {
                if (viewModel.moreExpandFlag)
                  rotationController.reverse();
                else
                  rotationController.forward();
                viewModel.setMoreExpandFlag(!viewModel.moreExpandFlag);
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    fontfamily: 'InterTight',
                    text: viewModel.moreExpandFlag
                        ? stringVariables.less
                        : stringVariables.more,
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: hintLight,
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 0.5).animate(rotationController),
                    child: SvgPicture.asset(
                      p2pDownArrow,
                      color: hintLight,
                      height: 7.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReasonCard(String content, int index) {
    return Column(
      children: [
        CustomSizedBox(
          height: 0.02,
        ),
        GestureDetector(
          onTap: () {
            viewModel.setReportReason(index);
          },
          child: CustomContainer(
            padding: 10,
            decoration: BoxDecoration(
              color: viewModel.reportReason == index
                  ? themeColor.withOpacity(0.15)
                  : switchBackground.withOpacity(0.1),
              border: Border.all(
                  color:
                      viewModel.reportReason == index ? themeColor : hintLight,
                  width: 1),
              borderRadius: BorderRadius.circular(
                20.0,
              ),
            ),
            child: CustomText(
              fontfamily: 'InterTight',
              text: content,
              fontWeight: FontWeight.w400,
              fontsize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmailDetailsView(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CustomSizedBox(
              width: 0.03,
            ),
            CustomText(
              fontfamily: 'InterTight',
              text: stringVariables.emailIdWithMandatory,
              fontWeight: FontWeight.w500,
              fontsize: 14,
            ),
          ],
        ),
        CustomSizedBox(
          height: 0.02,
        ),
        CustomTextFormField(
          autovalid: AutovalidateMode.onUserInteraction,
          controller: emailController,
          focusNode: emailFocus,
          keys: emailFieldKey,
          keyboardType: TextInputType.text,
          padRight: 0,
          padLeft: 0,
          isContentPadding: false,
          size: 30,
          text: stringVariables.hintEmail,
          validator: (input) => (input ?? "").isEmpty
              ? stringVariables.hintEmail
              : (input ?? "").isValidEmail()
                  ? null
                  : stringVariables.validEmailAddress,
        ),
      ],
    );
  }

  Widget buildPointsWithContent(String point, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              fontfamily: 'InterTight',
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
                fontfamily: 'InterTight',
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
              text: stringVariables.report,
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
