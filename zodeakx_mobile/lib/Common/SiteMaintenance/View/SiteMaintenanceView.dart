import 'package:flip_panel_plus/flip_panel_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomScaffold.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/AppConstants.dart';
import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomCard.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../ViewModel/SiteMaintenanceViewModel.dart';

class SiteMaintenanceView extends StatefulWidget {
  SiteMaintenanceView({
    super.key,
  });

  @override
  State<SiteMaintenanceView> createState() => _SiteMaintenanceViewState();
}

class _SiteMaintenanceViewState extends State<SiteMaintenanceView> {
  SiteMaintenanceViewModel? siteMaintenanceViewModel;

  @override
  void initState() {
    // TODO: implement initState
    siteMaintenanceViewModel =
        Provider.of<SiteMaintenanceViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    siteMaintenanceViewModel?.leaveSocket();
    super.dispose();
  }

  var outputFormat = DateFormat('yyyy-MM-dd hh:mm:ss');
  @override
  Widget build(BuildContext context) {
    siteMaintenanceViewModel = context.watch<SiteMaintenanceViewModel>();
    var endDate = constant.siteMaintenanceEndDate.value == null
        ? DateTime.now().toString()
        : constant.siteMaintenanceEndDate.value.toString().replaceAll("T", " ");
    var parsedDate = outputFormat.parse(endDate);
    String date = outputFormat.format(DateTime.now().toUtc());
    Duration end = parsedDate.difference(outputFormat.parse(date));
    return Provider(
      create: (context) => siteMaintenanceViewModel,
      child: PopScope(
        canPop: false,
        child: CustomScaffold(
          child: CustomCard(
            radius: 25,
            edgeInsets: 4,
            outerPadding: 8,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    siteMaintenance,
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomText(
                    text: stringVariables.weWillRightBack,
                    fontsize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  constant.siteMaintenanceEndDate.value == null
                      ? CustomSizedBox(
                          width: 0,
                          height: 0,
                        )
                      : FlipClockPlus.reverseCountdown(
                          duration: end,
                          digitColor: Colors.black87,
                          backgroundColor: themeColor,
                          height: 25,
                          width: 25,
                          digitSize: 15,
                          centerGapSpace: 0,
                          separator: CustomSizedBox(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3.0)),
                        ),
                  CustomSizedBox(
                    height: 0.02,
                  ),
                  CustomText(
                    text: stringVariables.maintenanceWork,
                    fontsize: 14,
                    align: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //   CustomScaffold(
    //   color: themeSupport().isSelectedDarkMode() ? black : white,
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //     centerTitle: true,
    //     automaticallyImplyLeading: false,
    //     titleSpacing: 0,
    //     title: CustomContainer(
    //       width: 1,
    //       height: 1,
    //       child: Stack(
    //         children: [
    //           Align(
    //             alignment: AlignmentDirectional.centerStart,
    //             child: GestureDetector(
    //               behavior: HitTestBehavior.opaque,
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //               child: Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 6),
    //                 child: CustomContainer(
    //                   padding: 7.5,
    //                   width: 12,
    //                   height: 24,
    //                   child: SvgPicture.asset(
    //                     backArrow,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Align(
    //             alignment: Alignment.center,
    //             child: CustomText(
    //               fontfamily: 'InterTight',
    //               fontsize: 23,
    //               overflow: TextOverflow.ellipsis,
    //               fontWeight: FontWeight.bold,
    //               text: stringVariables.siteMaintenance,
    //               color: themeSupport().isSelectedDarkMode() ? white : black,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   child: CustomCard(
    //     radius: 25,
    //     edgeInsets: 4,
    //     outerPadding: 8,
    //     elevation: 0,
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Image.asset(
    //             siteMaintenance,
    //           ),
    //           CustomSizedBox(
    //             height: 0.02,
    //           ),
    //           CustomText(
    //             text: stringVariables.weWillRightBack,
    //             fontsize: 24,
    //             fontWeight: FontWeight.bold,
    //           ),
    //           CustomSizedBox(
    //             height: 0.02,
    //           ),
    //           CustomText(
    //             text: "23 Hours 57 Mins 26 Secs",
    //             fontsize: 17,
    //           ),
    //           CustomSizedBox(
    //             height: 0.02,
    //           ),
    //           CustomText(
    //             text: stringVariables.maintenanceWork,
    //             fontsize: 14,
    //             align: TextAlign.center,
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
