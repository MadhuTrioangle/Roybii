import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  const QRImage(this.url, {super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: url,
      size: 225,
      // You can include embeddedImageStyle Property if you
      //wanna embed an image from your Asset folder
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: const Size(
          100,
          100,
        ),
      ),
    );
  }
}
