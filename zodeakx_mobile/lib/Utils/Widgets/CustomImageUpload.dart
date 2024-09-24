import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../Core/appFunctons/debugPrint.dart';

class ImageUpload extends StatelessWidget {
  ImageUpload({
    Key? key,
  }) : super(key: key);

  final ImagePicker imagePicker = ImagePicker();

  imageFront(XFile? imagePic, String? img641) async {
    XFile? image1 = imagePic;
    String? img6 = img641;
    var source = ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    imagePic = XFile(image!.path);
    final bytes = File(imagePic.path).readAsBytesSync();
    img641 = base64Encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
