import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  Color? color = Colors.black; // add color
  final Function()? onPress; //add functionality
  final Widget? child; // add widget
  double? radius = 2;

  CustomIconButton(
      {Key? key, this.onPress, this.color, this.child, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: child!,
      splashRadius: radius ?? 2,
    );
  }
}
