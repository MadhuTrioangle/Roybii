import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomLoader.dart';
import 'package:zodeakx_mobile/Utils/Widgets/CustomSizedbox.dart';

import '../../../Utils/Constant/App_ConstantIcon.dart';
import '../../../Utils/Core/ColorHandler/Colors.dart';
import '../../../Utils/Core/ColorHandler/DarkandLightTheme.dart';
import '../../../Utils/Languages/English/StringVariables.dart';
import '../../../Utils/Widgets/CustomContainer.dart';
import '../../../Utils/Widgets/CustomElevatedButton.dart';
import '../../../Utils/Widgets/CustomScaffold.dart';
import '../../../Utils/Widgets/CustomText.dart';
import '../../../Utils/Widgets/appSnackBar.dart/customSnackBar.dart';
import '../../../Utils/Widgets/appSnackBar.dart/snackbarType.dart';
import '../ViewModel/IdentityVerificationCommonViewModel.dart';

class CameraCaptureView extends StatefulWidget {
  final int type;

  const CameraCaptureView({Key? key, required this.type}) : super(key: key);

  @override
  _CameraCaptureViewState createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends State<CameraCaptureView> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image
  late IdentityVerificationCommonViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<IdentityVerificationCommonViewModel>(context,
        listen: false);
    loadCamera(0);
    super.initState();
  }

  loadCamera(int cam) async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(
        enableAudio: false,
        cameras![cam],
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      //cameras[0] = first camera, change to 1 to another camera

      controller!.setFocusMode(FocusMode.locked);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      customSnackBar.showSnakbar(
          context, "No any camera found", SnackbarType.negative);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<IdentityVerificationCommonViewModel>();
    return Provider<IdentityVerificationCommonViewModel>(
      create: (context) => viewModel,
      child: CustomScaffold(
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
                    fontfamily: 'InterTight',
                    fontsize: 18,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    text: stringVariables.captureImage,
                    color: themeSupport().isSelectedDarkMode() ? white : black,
                  ),
                ),
              ],
            ),
          ),
        ),
        child: CustomContainer(
          child: Column(children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CustomContainer(
                      width: 1,
                      height: 1,
                      child: controller == null
                          ? Center(
                              child: CustomText(
                                fontfamily: 'InterTight',
                                fontsize: 18,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold,
                                text: stringVariables.loadCam,
                              ),
                            )
                          : !controller!.value.isInitialized
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CameraPreview(controller!)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Flexible(
                    child: viewModel.cameraLoading
                        ? GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              customSnackBar.showSnakbar(
                                  context,
                                  "A capture is already pending, do nothing.",
                                  SnackbarType.negative);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: CustomContainer(
                                width: 1,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: themeSupport().isSelectedDarkMode()
                                      ? switchBackground.withOpacity(0.15)
                                      : enableBorder.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: CustomLoader()),
                          )
                        : CustomElevatedButton(
                            blurRadius: 0,
                            spreadRadius: 0,
                            text: stringVariables.capture,
                            color: themeSupport().isSelectedDarkMode()
                                ? black
                                : white,
                            press: () async {
                              try {
                                if (controller != null) {
                                  //check if contrller is not null
                                  if (controller!.value.isInitialized) {
                                    //check if controller is initialized
                                    viewModel.setCameraLoading(true);
                                    image = await takePicture(); //capture image
                                    viewModel.setCameraLoading(false);
                                    if (widget.type == 1) {
                                      viewModel.imageCameraFront(image);
                                    } else if (widget.type == 2) {
                                      viewModel.imageCameraBack(image);
                                    } else {
                                      viewModel.imageCameraFacial(image);
                                    }
                                    Navigator.pop(context);
                                  }
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                                customSnackBar.showSnakbar(context,
                                    e.toString(), SnackbarType.negative);
                              }
                            },
                            radius: 25,
                            buttoncolor: themeColor,
                            width: 1,
                            height: 15,
                            isBorderedButton: false,
                            maxLines: 1,
                            icons: false,
                            multiClick: true,
                            icon: null),
                  ),
                  CustomSizedBox(
                    width: 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      final lensDirection =
                          controller!.description.lensDirection;
                      int camera =
                          lensDirection == CameraLensDirection.front ? 0 : 1;
                      loadCamera(camera);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: CustomContainer(
                        width: 6,
                        height: 15,
                        padding: 2,
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          Icons.cameraswitch_outlined,
                          size: 30,
                          color: themeSupport().isSelectedDarkMode()
                              ? black
                              : white,
                        )),
                  ),
                ],
              ),
            ),
            CustomSizedBox(
              height: 0.02,
            )
          ]),
        ),
      ),
    );
  }
}
