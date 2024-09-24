import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final Widget child; // return widget
  final Color? backgroundColor; // background color for child widget
  final double? minRadius; // minimum radius  for circleAvatar
  final double? maxRadius; // maximum radius for circleAvatar
  final double? radius; // radius for circleAvatar shape
  final Color? foregroundColor; // foregroundColor for the CircleAvatar
  CustomCircleAvatar({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.minRadius,
    this.maxRadius,
    this.radius,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: child,
      backgroundColor: backgroundColor,
      radius: radius,
      foregroundColor: foregroundColor,
      maxRadius: maxRadius,
      minRadius: minRadius,
    );
  }
}
