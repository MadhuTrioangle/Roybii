import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Constant/App_ConstantIcon.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
  });

  final String? image;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width ?? null,
      height: height ?? null,
      imageUrl: image ?? "",
      fit: fit ?? null,
      placeholder: (context, url) => Image.asset(splash),
      errorWidget: (context, url, error) => Image.asset(splash),
    );
  }
}
