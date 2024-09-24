import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';
import 'package:zodeakx_mobile/p2p/orders/model/UserOrdersModel.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Core/appFunctons/appValidators.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomLoader.dart';
import '../../../Utils/Widgets/CustomNavigation.dart';
import '../../../Utils/Widgets/CustomNetworkImage.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/CustomTextformfield.dart';
import '../../order_creation_view/ViewModel/p2p_order_creation_view_model.dart';
import '../../payment_methods/view/p2p_image_view_dialog.dart';
import '../../profile/view_model/p2p_profile_view_model.dart';
import '../model/MessageHistoryModel.dart';

class P2PChatView extends StatefulWidget {
  final String id;

  const P2PChatView({Key? key, required this.id}) : super(key: key);

  @override
  State<P2PChatView> createState() => _CommonViewState();
}

class _CommonViewState extends State<P2PChatView>
    with TickerProviderStateMixin {
  late P2POrderCreationViewModel viewModel;
  late P2PProfileViewModel p2pProfileViewModel;
  TextEditingController chatController = TextEditingController();
  bool firstTime = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.setLoading(false);
      viewModel.setChatTime("");
      viewModel.leaveChatLocalSocket(widget.id);
      viewModel.getOrderLocalSocket(widget.id, '');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = Provider.of<P2POrderCreationViewModel>(context, listen: false);
    p2pProfileViewModel =
        Provider.of<P2PProfileViewModel>(context, listen: false);
    if (constant.userLoginStatus.value) p2pProfileViewModel.findUserCenter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("p2pid");
      print(widget.id);
      viewModel.setLoading(true);
      viewModel.fetchMessageHistory(widget.id);
      viewModel.getChatLocalSocket(widget.id);
    });
    firstTime = false;
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
            : buildP2PChatView(size),
      ),
    );
  }

  Widget buildP2PChatView(Size size) {
    List<MessageHistory> messageHistory = viewModel.messageHistory;
    String buyer = viewModel.userId;
    String seller = viewModel.id;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 35),
              child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: messageHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isBuyer = messageHistory[index].userId == buyer;
                    bool isSeller = messageHistory[index].userId == seller;
                    return isBuyer
                        ? chatType1View(size, messageHistory[index])
                        : isSeller
                            ? chatType2View(size, messageHistory[index])
                            : chatType3View(size, messageHistory[index]);
                  }),
            ),
          ),
          Column(
            children: [
              CustomContainer(
                width: 1,
                height: 11,
                color: themeSupport().isSelectedDarkMode() ? card_dark : white,
                child: Row(
                  children: [
                    CustomSizedBox(
                      width: 0.02,
                    ),
                    GestureDetector(
                        onTap: () {
                          viewModel.pickImage(widget.id);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Icon(Icons.add_circle_outlined)),
                    Flexible(
                      fit: FlexFit.loose,
                      child: CustomTextFormField(
                        onFieldSubmit: onFieldSubmitted,
                        color: switchBackground.withOpacity(0.1),
                        controller: chatController,
                        isContentPadding: false,
                        size: 30,
                        text: stringVariables.pleaseEnterContentHere,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onFieldSubmitted(chatController.text);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(
                        p2pChat,
                        height: 20,
                        color: themeColor,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.02,
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        ]);
  }

  Widget chatType1View(Size size, MessageHistory messageHistory) {
    String name = (p2pProfileViewModel.userCenter?.name ?? "") == " "
        ? (constant.userEmail.value.substring(0, 2) +
            "*****." +
            constant.userEmail.value.split(".").last)
        : (p2pProfileViewModel.userCenter?.name ?? "");
    String time = "";
    bool timeFlag = false;
    if (messageHistory.createdDate != null) {
      timeFlag = viewModel.messageHistory.indexOf(messageHistory) ==
          (viewModel.messageHistory.length - 1);
      if (timeFlag) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setChatTime(
              getDateTimeStamp(messageHistory.createdDate.toString()));
        });
        final msgTime = messageHistory.createdDate!;
        time = DateFormat('yyyy-MM-dd hh:mm').format(msgTime);
      }
    } else {
      final now = DateTime.now();
      time = DateFormat('yyyy-MM-dd hh:mm').format(now);
      int index = viewModel.messageHistory.indexOf(messageHistory);
      viewModel.messageHistory[index].createdDate = now.toUtc();
      timeFlag = index == (viewModel.messageHistory.length - 1);
    }
    String comment = messageHistory.message ?? "";
    String image = messageHistory.image ?? "";
    bool sending = messageHistory.sending ?? false;
    bool sendingFailed = messageHistory.sendingFailed ?? false;
    String received =
        DateFormat.jm().format((messageHistory.createdDate ?? DateTime.now()));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width / 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          timeFlag
              ? CustomText(
                  text: time,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'InterTight',
                  fontWeight: FontWeight.w400,
                  fontsize: 12,
                  color: hintLight,
                )
              : CustomSizedBox(
                  width: 0,
                  height: 0,
                ),
          comment.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomContainer(
                          decoration: BoxDecoration(
                            color: themeSupport().isSelectedDarkMode()
                                ? card_dark
                                : white,
                            border: Border.all(color: hintLight, width: 1),
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          constraints:
                              BoxConstraints(maxWidth: size.width / 1.5),
                          child: Padding(
                            padding: EdgeInsets.all(size.width / 35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: comment,
                                  fontfamily: 'InterTight',
                                  fontWeight: FontWeight.w400,
                                  fontsize: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        Transform.translate(
                          offset: Offset(0, 10),
                          child: CustomContainer(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: themeColor),
                            child: Center(
                                child: CustomText(
                              fontfamily: 'InterTight',
                              text:
                                  name.isNotEmpty ? name[0].toUpperCase() : " ",
                              fontWeight: FontWeight.bold,
                              fontsize: 11,
                              color: black,
                            )),
                          ),
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(
                          text: "${stringVariables.messageReceived} $received",
                          overflow: TextOverflow.ellipsis,
                          fontfamily: 'InterTight',
                          fontWeight: FontWeight.w400,
                          fontsize: 12,
                          color: hintLight,
                        ),
                        CustomSizedBox(
                          width: 0.09,
                        ),
                      ],
                    ),
                  ],
                )
              : image.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomContainer(
                              decoration: BoxDecoration(
                                color: themeSupport().isSelectedDarkMode()
                                    ? card_dark
                                    : white,
                                border: Border.all(color: hintLight, width: 1),
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [buildImageCard(size, image)],
                                ),
                              ),
                            ),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            Transform.translate(
                              offset: Offset(0, 10),
                              child: CustomContainer(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: themeColor),
                                child: Center(
                                    child: CustomText(
                                  fontfamily: 'InterTight',
                                  text: name.isNotEmpty
                                      ? name[0].toUpperCase()
                                      : " ",
                                  fontWeight: FontWeight.bold,
                                  fontsize: 11,
                                  color: black,
                                )),
                              ),
                            ),
                          ],
                        ),
                        CustomSizedBox(
                          height: 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomText(
                              text: sending
                                  ? stringVariables.sending
                                  : sendingFailed
                                      ? stringVariables.sendingFailed
                                      : "${stringVariables.messageReceived} $received",
                              overflow: TextOverflow.ellipsis,
                              fontfamily: 'InterTight',
                              fontWeight: FontWeight.w400,
                              fontsize: 12,
                              color: sending
                                  ? null
                                  : sendingFailed
                                      ? red
                                      : hintLight,
                            ),
                            CustomSizedBox(
                              width: 0.09,
                            ),
                          ],
                        ),
                      ],
                    )
                  : CustomSizedBox(
                      width: 0,
                      height: 0,
                    ),
        ],
      ),
    );
  }

  Widget buildImageCard(Size size, String image) {
    bool isEncoded = !image.contains("http");
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _showQrDialog(image);
          },
          child: isEncoded
              ? buildImageView(size, image)
              : CustomNetworkImage(
                  image: image,
                  width: 40,
                ),
        ),
      ],
    );
  }

  Widget buildImageView(Size size, String image) {
    if (image.contains("base64")) {
      image = image.split(',').last;
    }
    Uint8List _image = base64.decode(image);
    return CustomContainer(
      width: 10,
      height: 20,
      child: Stack(
        children: [
          Image.memory(
            gaplessPlayback: true,
            fit: BoxFit.cover,
            width: size.width / 10,
            height: size.height / 20,
            _image,
          ),
        ],
      ),
    );
  }

  _showQrDialog(String image) async {
    final result =
        await Navigator.of(context).push(P2PImageViewModal(context, image));
  }

  Widget chatType3View(Size size, MessageHistory messageHistory) {
    String name = stringVariables.admin;
    String time = "";
    bool timeFlag = viewModel.messageHistory.indexOf(messageHistory) ==
        (viewModel.messageHistory.length - 1);
    if (timeFlag) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.setChatTime(
            getDateTimeStamp(messageHistory.createdDate.toString()));
      });
      time = getDateWithoutSeconds(messageHistory.createdDate.toString());
    }
    String comment = messageHistory.message ?? "";
    String received =
        DateFormat.jm().format(messageHistory.createdDate ?? DateTime.now());
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width / 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          timeFlag
              ? CustomText(
                  text: time,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'InterTight',
                  fontWeight: FontWeight.w400,
                  fontsize: 12,
                  color: hintLight,
                )
              : CustomSizedBox(
                  width: 0,
                  height: 0,
                ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Transform.translate(
                offset: Offset(0, 10),
                child: CustomContainer(
                  width: 15,
                  height: 15,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: themeColor),
                  child: Center(
                      child: CustomText(
                    fontfamily: 'InterTight',
                    text: name.isNotEmpty ? name[0].toUpperCase() : " ",
                    fontWeight: FontWeight.bold,
                    fontsize: 11,
                    color: black,
                  )),
                ),
              ),
              CustomSizedBox(
                width: 0.02,
              ),
              CustomContainer(
                constraints: BoxConstraints(maxWidth: size.width / 1.5),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.25),
                  border: Border.all(color: themeColor, width: 1),
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
                        text: name,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.w500,
                        fontsize: 14,
                        color: themeColor,
                      ),
                      CustomSizedBox(
                        height: 0.01,
                      ),
                      CustomText(
                        text: comment,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.w400,
                        fontsize: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          CustomSizedBox(
            height: 0.01,
          ),
          Row(
            children: [
              CustomSizedBox(
                width: 0.09,
              ),
              CustomText(
                text: "${stringVariables.messageReceived} $received",
                overflow: TextOverflow.ellipsis,
                fontfamily: 'InterTight',
                fontWeight: FontWeight.w400,
                fontsize: 12,
                color: hintLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chatType2View(Size size, MessageHistory messageHistory) {
    String name =
        viewModel.userOrdersModel?.result?.data?.first.counterParty ?? "";
    String time = "";
    bool timeFlag = viewModel.messageHistory.indexOf(messageHistory) ==
        (viewModel.messageHistory.length - 1);
    if (timeFlag && !firstTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.setChatTime(
            getDateTimeStamp(messageHistory.createdDate.toString()));
        firstTime = true;
      });
      time = getDateWithoutSeconds(messageHistory.createdDate.toString());
    }
    String comment = messageHistory.message ?? "";
    String received =
        DateFormat.jm().format(messageHistory.createdDate ?? DateTime.now());
    String image = messageHistory.image ?? "";
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.width / 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          timeFlag
              ? CustomText(
                  text: time,
                  overflow: TextOverflow.ellipsis,
                  fontfamily: 'InterTight',
                  fontWeight: FontWeight.w400,
                  fontsize: 12,
                  color: hintLight,
                )
              : CustomSizedBox(
                  width: 0,
                  height: 0,
                ),
          comment.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Transform.translate(
                          offset: Offset(0, 10),
                          child: CustomContainer(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: themeColor),
                            child: Center(
                                child: CustomText(
                              fontfamily: 'InterTight',
                              text:
                                  name.isNotEmpty ? name[0].toUpperCase() : " ",
                              fontWeight: FontWeight.bold,
                              fontsize: 11,
                              color: black,
                            )),
                          ),
                        ),
                        CustomSizedBox(
                          width: 0.02,
                        ),
                        CustomContainer(
                          constraints:
                              BoxConstraints(maxWidth: size.width / 1.5),
                          decoration: BoxDecoration(
                            color: themeSupport().isSelectedDarkMode()
                                ? switchBackground.withOpacity(0.15)
                                : enableBorder.withOpacity(0.25),
                            border: Border.all(color: hintLight, width: 1),
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
                                  text: comment,
                                  fontfamily: 'InterTight',
                                  fontWeight: FontWeight.w400,
                                  fontsize: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Row(
                      children: [
                        CustomSizedBox(
                          width: 0.09,
                        ),
                        CustomText(
                          text: "${stringVariables.messageReceived} $received",
                          overflow: TextOverflow.ellipsis,
                          fontfamily: 'InterTight',
                          fontWeight: FontWeight.w400,
                          fontsize: 12,
                          color: hintLight,
                        ),
                      ],
                    ),
                  ],
                )
              : image.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 10),
                              child: CustomContainer(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: themeColor),
                                child: Center(
                                    child: CustomText(
                                  fontfamily: 'InterTight',
                                  text: name.isNotEmpty
                                      ? name[0].toUpperCase()
                                      : " ",
                                  fontWeight: FontWeight.bold,
                                  fontsize: 11,
                                  color: black,
                                )),
                              ),
                            ),
                            CustomSizedBox(
                              width: 0.02,
                            ),
                            CustomContainer(
                              decoration: BoxDecoration(
                                color: themeSupport().isSelectedDarkMode()
                                    ? card_dark
                                    : white,
                                border: Border.all(color: hintLight, width: 1),
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [buildImageCard(size, image)],
                                ),
                              ),
                            ),
                          ],
                        ),
                        CustomSizedBox(
                          height: 0.01,
                        ),
                        Row(
                          children: [
                            CustomSizedBox(
                              width: 0.09,
                            ),
                            CustomText(
                              text:
                                  "${stringVariables.messageReceived} $received",
                              overflow: TextOverflow.ellipsis,
                              fontfamily: 'InterTight',
                              fontWeight: FontWeight.w400,
                              fontsize: 12,
                              color: hintLight,
                            ),
                          ],
                        ),
                      ],
                    )
                  : CustomSizedBox(
                      width: 0,
                      height: 0,
                    ),
        ],
      ),
    );
  }

  onFieldSubmitted(String value) {
    if (value.isEmpty) return;
    chatController.clear();
    MessageHistory messageHistory = MessageHistory(
        adminId: null, userId: viewModel.userId, image: null, message: value);
    viewModel.sendMessageSocket(widget.id, messageHistory);
    viewModel.createMessage(widget.id, value);
  }

  /// APPBAR
  AppBar AppHeader(Size size) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 115,
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: viewModel.needToLoad ? CustomSizedBox() : buildHeader(size));
  }

  Widget buildHeader(Size size) {
    OrdersData ordersData =
        viewModel.userOrdersModel?.result?.data?.first ?? OrdersData();
    String name = ordersData.counterParty ?? "";
    String adType = capitalize((ordersData.tradeType ?? "buy"));
    String fiatCurrency = adType == stringVariables.buy
        ? ordersData.fromAsset!
        : ordersData.toAsset!;
    String currencySymbol = constant.currencySymbol.entries
        .firstWhere((entry) => entry.key == fiatCurrency)
        .value;
    double fiatAmount =
        double.parse((trimDecimals(ordersData.price.toString())));
    String status = capitalize(ordersData.status!);
    return CustomContainer(
      decoration: BoxDecoration(
        color: themeSupport().isSelectedDarkMode() ? card_dark : white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        ),
      ),
      width: 1,
      height: 6,
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
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Transform.translate(
                      offset: Offset(12, 0),
                      child: CustomText(
                        text: status,
                        overflow: TextOverflow.ellipsis,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.bold,
                        fontsize: 22,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ),
                    CustomSizedBox(
                      height: 0.01,
                    ),
                    Transform.translate(
                      offset: Offset(12, 0),
                      child: Row(
                        children: [
                          CustomText(
                            text: stringVariables.amount,
                            overflow: TextOverflow.ellipsis,
                            fontfamily: 'InterTight',
                            fontWeight: FontWeight.w500,
                            fontsize: 14,
                            color: hintLight,
                          ),
                          CustomSizedBox(
                            width: 0.025,
                          ),
                          CustomText(
                            text: "$currencySymbol$fiatAmount",
                            overflow: TextOverflow.ellipsis,
                            fontfamily: 'InterTight',
                            fontWeight: FontWeight.w500,
                            fontsize: 14,
                            color: themeSupport().isSelectedDarkMode()
                                ? white
                                : black,
                          ),
                        ],
                      ),
                    ),
                    CustomSizedBox(
                      height: 0.01,
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
                  height: 0.005,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomContainer(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: themeColor),
                      child: Center(
                          child: CustomText(
                        fontfamily: 'InterTight',
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
                        fontfamily: 'InterTight',
                        text: name,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        fontsize: 15,
                        color:
                            themeSupport().isSelectedDarkMode() ? white : black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        moveToReport(context, widget.id);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomText(
                        text: stringVariables.report,
                        overflow: TextOverflow.ellipsis,
                        fontfamily: 'InterTight',
                        fontWeight: FontWeight.w500,
                        fontsize: 14,
                        color: themeColor,
                      ),
                    ),
                    CustomSizedBox(
                      width: 0.04,
                    )
                  ],
                ),
                CustomSizedBox(
                  height: isSmallScreen(context) ? 0.015 : 0.03,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
