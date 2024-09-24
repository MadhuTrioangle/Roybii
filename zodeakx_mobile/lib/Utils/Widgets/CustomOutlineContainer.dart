import 'package:flutter/cupertino.dart';

import 'CustomContainer.dart';

class CustomOutlineContainer extends StatelessWidget {
  final Decoration? decoration; // add decoration to the outer container
  final double? height; //add height to the container
  final double? width; //add width to the container
  final Widget? child; //return widget
  final BoxBorder? border; // border color to the container
  final BorderRadiusGeometry? borderRadius; //add radius to the container
  final Color? backgroundColor; // backgroundColor to the container

  const CustomOutlineContainer(
      {Key? key,
      this.height,
      this.child,
      this.width,
      this.decoration,
      this.border,
      this.borderRadius,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: border,
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
