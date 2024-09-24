import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Core/appFunctons/appValidators.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomNavigation.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../payment_methods/view/p2p_image_view_dialog.dart';
import '../Model/p2p_appeal_progress_model.dart';

class P2PAppealProgressView extends StatefulWidget {
  final String id;
  final String amount;
  final String symbol;
  final String side;

  const P2PAppealProgressView(
      {Key? key,
      required this.id,
      required this.amount,
      required this.symbol,
      required this.side})
      : super(key: key);

  @override
  State<P2PAppealProgressView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PAppealProgressView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  TextEditingController chatController = TextEditingController();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(true);
      viewModel.fetchAppealHistory(widget.id);
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
            : buildP2PAppealProgressView(size),
      ),
    );
  }

  Widget buildP2PAppealProgressView(Size size) {
    List<AppealHistory>? appealHistory =
        (viewModel.appealHistory?.result ?? []).reversed.toList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 35),
              child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.symmetric(vertical: size.width / 35),
                  itemCount: appealHistory.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    AppealHistory appeal;
                    if (index != appealHistory.length)
                      appeal = appealHistory[index];
                    else
                      appeal = AppealHistory();
                    return index == appealHistory.length
                        ? appealType1View(size)
                        : appealType2View(size, appeal);
                  }),
            ),
          ),
          CustomContainer(
            width: 1,
            height: 11,
            color: themeSupport().isSelectedDarkMode() ? card_dark : white,
            child: Padding(
              padding: EdgeInsets.all(size.width / 40),
              child: GestureDetector(
                onTap: () {
                  moveToChatView(context, widget.id);
                },
                child: CustomContainer(
                  decoration: BoxDecoration(
                    color: themeSupport().isSelectedDarkMode()
                        ? switchBackground.withOpacity(0.15)
                        : enableBorder.withOpacity(0.25),
                    border: Border.all(color: hintLight, width: 1),
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      text: stringVariables.chat,
                      overflow: TextOverflow.ellipsis,
                      fontfamily: 'GoogleSans',
                      fontWeight: FontWeight.w400,
                      fontsize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]);
  }

  Widget appealType1View(Size size) {
    AppealHistory appealHistory =
        (viewModel.appealHistory?.result ?? []).isEmpty
            ? AppealHistory()
            : viewModel.appealHistory?.result?.first ?? AppealHistory();
    String name = appealHistory.userName ?? "";
    String time =
        convertToIST('${appealHistory.createdDate ?? DateTime.now()}');
    String comment =
        "${stringVariables.dear} $name${stringVariables.customerSupportCommentContent1}";
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width / 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: time,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.w400,
            fontsize: 12,
            color: hintLight,
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode() ? card_dark : white,
              border: Border.all(color: hintLight, width: 1),
              borderRadius: BorderRadius.circular(
                15.0,
              ),
            ),
            height: isSmallScreen(context) ? 3.05 : 3.7,
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CustomContainer(
                        decoration: BoxDecoration(
                          color: themeSupport().isSelectedDarkMode()
                              ? card_dark
                              : white,
                          border: Border.all(color: hintLight, width: 1),
                          borderRadius: BorderRadius.circular(
                            500.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            icon,
                            height: 25,
                          ),
                        ),
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomText(
                        text: stringVariables.customerSupportComment,
                        overflow: TextOverflow.ellipsis,
                        fontfamily: 'GoogleSans',
                        fontWeight: FontWeight.w400,
                        fontsize: 14,
                      ),
                    ],
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomText(
                    text: stringVariables.comment,
                    overflow: TextOverflow.ellipsis,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                    color: hintLight,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    text: comment,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                  ),
                ],
              ),
            ),
          ),
          CustomSizedBox(
            height: 0.02,
          ),
          CustomText(
            text: time,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.w400,
            fontsize: 12,
            color: hintLight,
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: themeSupport().isSelectedDarkMode() ? card_dark : white,
              border: Border.all(color: hintLight, width: 1),
              borderRadius: BorderRadius.circular(
                15.0,
              ),
            ),
            height: isSmallScreen(context) ? 7 : 8.5,
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: Center(
                child: CustomText(
                  text: stringVariables.customerSupportCommentContent2,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.w400,
                  fontsize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appealType2View(Size size, AppealHistory appealHistory) {
    String name = appealHistory.userName ?? "";
    List<Widget> imageList = [];
    int imageListCount = (appealHistory.proof ?? []).length;
    for (var i = 0; i < imageListCount; i++) {
      imageList
          .add(buildImageCard(size, appealHistory.proof?[i].proofUrl ?? ""));
    }
    String description = appealHistory.description ?? "";
    String time =
        convertToIST('${appealHistory.createdDate ?? DateTime.now()}');
    String comment = stringVariables.p2pUserCenter;
    bool isBuyer = widget.side == stringVariables.buy
        ? appealHistory.userId != viewModel.userId
        : appealHistory.userId == viewModel.userId;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width / 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: time,
            overflow: TextOverflow.ellipsis,
            fontfamily: 'GoogleSans',
            fontWeight: FontWeight.w400,
            fontsize: 12,
            color: hintLight,
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: isBuyer
                  ? themeSupport().isSelectedDarkMode()
                      ? card_dark
                      : white
                  : themeSupport().isSelectedDarkMode()
                      ? enableBorder.withOpacity(0.25)
                      : enableBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(
                15.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(size.width / 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: stringVariables.appealFiledUser,
                    overflow: TextOverflow.ellipsis,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  Divider(),
                  Row(
                    children: [
                      CustomContainer(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: themeColor),
                        child: Center(
                            child: CustomText(
                          fontfamily: 'GoogleSans',
                          text: name.isNotEmpty ? name[0].toUpperCase() : " ",
                          fontWeight: FontWeight.bold,
                          fontsize: 11,
                          color: black,
                        )),
                      ),
                      CustomSizedBox(
                        width: 0.02,
                      ),
                      CustomContainer(
                        constraints: BoxConstraints(maxWidth: size.width / 2.4),
                        child: CustomText(
                          fontfamily: 'GoogleSans',
                          text: name,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          fontsize: 15,
                        ),
                      ),
                    ],
                  ),
                  imageListCount != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: stringVariables.proof,
                              fontfamily: 'GoogleSans',
                              fontWeight: FontWeight.w500,
                              fontsize: 14,
                              color: hintLight,
                            ),
                            CustomSizedBox(
                              height: 0.01,
                            ),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: imageList,
                            ),
                            CustomSizedBox(
                              height: 0.02,
                            ),
                          ],
                        )
                      : CustomSizedBox(
                          width: 0,
                          height: 0,
                        ),
                  CustomText(
                    text: stringVariables.description,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w500,
                    fontsize: 14,
                    color: hintLight,
                  ),
                  CustomSizedBox(
                    height: 0.01,
                  ),
                  CustomText(
                    text: description,
                    fontfamily: 'GoogleSans',
                    fontWeight: FontWeight.w400,
                    fontsize: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageCard(Size size, String image) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 35),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              _showQrDialog(image);
            },
            child: CustomNetworkImage(
              image: image,
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
    );
  }

  _showQrDialog(String image) async {
    final result =
        await Navigator.of(context).push(P2PImageViewModal(context, image));
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: buildHeader(size));
  }

  Widget buildHeader(Size size) {
    String currencySymbol = widget.symbol;
    double fiatAmount = double.parse(widget.amount);
    return CustomContainer(
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode() ? card_dark : white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      width: 1,
      height: 8,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                CustomSizedBox(
                  width: 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSizedBox(
                      height: 0.03,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: size.width / 35, right: 15),
                        child: SvgPicture.asset(
                          backArrow,
                        ),
                      ),
                    ),
                    CustomSizedBox(
                      height: 0.025,
                    ),
                    Transform.translate(
                      offset: Offset(12, 0),
                      child: Row(
                        children: [
                          CustomText(
                            text: stringVariables.amount,
                            overflow: TextOverflow.ellipsis,
                            fontfamily: 'GoogleSans',
                            fontWeight: FontWeight.w500,
                            fontsize: 14,
                            color: hintLight,
                          ),
                          CustomSizedBox(
                            width: 0.02,
                          ),
                          CustomText(
                            text: "$currencySymbol$fiatAmount",
                            overflow: TextOverflow.ellipsis,
                            fontfamily: 'GoogleSans',
                            fontWeight: FontWeight.w500,
                            fontsize: 14,
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                CustomSizedBox(
                  height: 0.025,
                ),
                CustomText(
                  text: stringVariables.appealProgress,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'GoogleSans',
                  fontWeight: FontWeight.bold,
                  fontsize: 20,
                  color: themeSupport().isSelectedDarkMode() ? white : black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
