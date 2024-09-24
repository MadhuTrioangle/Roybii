import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double radius; // radius for card shape
  final Widget child; // return widget
  final double edgeInsets; // need space around the card using edgeInsets
  final double? elevation; // elevation for card
  final Color? shadowColor; // shadowcolor for card
  final bool? borderOnForeground; // checking card have border or not
  final double outerPadding;
  final Color? color;

  CustomCard(
      {Key? key,
      this.color,
      required this.radius,
      required this.child,
      required this.edgeInsets,
      this.elevation,
      this.shadowColor,
      this.borderOnForeground,
      required this.outerPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(outerPadding),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: elevation,
        shadowColor: shadowColor,
        borderOnForeground: false,
        color: color,
        child: Padding(
          padding: EdgeInsets.all(edgeInsets),
          child: child,
        ),
      ),
    );
  }
}
